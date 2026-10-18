// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Governed KHAN prototype for Anvil/Sepolia testing ONLY. NOT AUDITED.
/// @dev Governance must be an independently configured multisignature wallet in production.
///      Token-level timelocks apply even after the governance wallet approves an action.
contract KhanToken {
    string public constant name = "The Great Khan";
    string public constant symbol = "KHAN";
    uint8 public constant decimals = 18;
    uint256 public constant CAP = 5_000_000_000 ether;
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 ether;
    uint256 public constant ADMIN_DELAY = 2 days;

    uint256 public totalSupply;
    address public immutable governance;
    address public immutable guardian;
    address public immutable custody;
    bool public paused;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public frozen;
    mapping(bytes32 => uint256) public mintReadyAt;
    mapping(bytes32 => uint256) public seizureReadyAt;
    mapping(bytes32 => bool) public consumedCases;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Frozen(address indexed account, bytes32 indexed caseId);
    event Unfrozen(address indexed account, bytes32 indexed caseId);
    event Paused(address indexed guardian);
    event Unpaused(address indexed governance);
    event MintQueued(bytes32 indexed id, address indexed to, uint256 amount, uint256 readyAt);
    event MintExecuted(bytes32 indexed id, address indexed to, uint256 amount);
    event SeizureQueued(bytes32 indexed caseId, address indexed from, uint256 amount, uint256 readyAt);
    event SeizureExecuted(bytes32 indexed caseId, address indexed from, uint256 amount);
    event ActionCancelled(bytes32 indexed id);

    error Unauthorized();
    error ZeroAddress();
    error InvalidAmount();
    error InsufficientBalance();
    error InsufficientAllowance();
    error AllowanceMustBeZeroFirst();
    error CapExceeded();
    error AccountFrozen();
    error TransfersPaused();
    error InvalidCase();
    error ActionNotReady();
    error ActionAlreadyExists();

    modifier onlyGovernance() { if (msg.sender != governance) revert Unauthorized(); _; }
    modifier onlyGuardianOrGovernance() {
        if (msg.sender != guardian && msg.sender != governance) revert Unauthorized();
        _;
    }

    constructor(address initialHolder, address governance_, address guardian_, address custody_) {
        if (initialHolder == address(0) || governance_ == address(0) ||
            guardian_ == address(0) || custody_ == address(0)) revert ZeroAddress();
        if (custody_ == initialHolder || custody_ == governance_ || custody_ == guardian_) revert InvalidCase();
        governance = governance_;
        guardian = guardian_;
        custody = custody_;
        totalSupply = INITIAL_SUPPLY;
        balanceOf[initialHolder] = INITIAL_SUPPLY;
        emit Transfer(address(0), initialHolder, INITIAL_SUPPLY);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        if (spender == address(0)) revert ZeroAddress();
        if (frozen[msg.sender]) revert AccountFrozen();
        if (amount != 0 && allowance[msg.sender][spender] != 0) revert AllowanceMustBeZeroFirst();
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        _checkTransfer(from, to);
        uint256 allowed = allowance[from][msg.sender];
        if (allowed < amount) revert InsufficientAllowance();
        if (allowed != type(uint256).max) {
            allowance[from][msg.sender] = allowed - amount;
            emit Approval(from, msg.sender, allowed - amount);
        }
        _move(from, to, amount);
        return true;
    }

    function freeze(address account, bytes32 caseId) external onlyGuardianOrGovernance {
        if (account == address(0) || account == custody || caseId == bytes32(0)) revert InvalidCase();
        frozen[account] = true;
        emit Frozen(account, caseId);
    }

    function unfreeze(address account, bytes32 caseId) external onlyGovernance {
        if (account == address(0) || caseId == bytes32(0)) revert InvalidCase();
        frozen[account] = false;
        emit Unfrozen(account, caseId);
    }

    function pause() external onlyGuardianOrGovernance {
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() external onlyGovernance {
        paused = false;
        emit Unpaused(msg.sender);
    }

    /// @dev Queue identifiers are unique to a specific action, recipient and amount.
    function queueMint(bytes32 id, address to, uint256 amount) external onlyGovernance {
        if (id == bytes32(0) || to == address(0)) revert InvalidCase();
        if (amount == 0) revert InvalidAmount();
        if (amount > CAP - totalSupply) revert CapExceeded();
        bytes32 key = keccak256(abi.encode("MINT", id, to, amount));
        if (mintReadyAt[key] != 0 || consumedCases[id]) revert ActionAlreadyExists();
        mintReadyAt[key] = block.timestamp + ADMIN_DELAY;
        emit MintQueued(id, to, amount, mintReadyAt[key]);
    }

    function executeMint(bytes32 id, address to, uint256 amount) external onlyGovernance {
        bytes32 key = keccak256(abi.encode("MINT", id, to, amount));
        uint256 ready = mintReadyAt[key];
        if (ready == 0 || block.timestamp < ready) revert ActionNotReady();
        if (consumedCases[id]) revert ActionAlreadyExists();
        if (amount > CAP - totalSupply) revert CapExceeded();
        if (frozen[to]) revert AccountFrozen();
        consumedCases[id] = true;
        delete mintReadyAt[key];
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
        emit MintExecuted(id, to, amount);
    }

    function queueSeizure(bytes32 caseId, address from, uint256 amount) external onlyGovernance {
        if (caseId == bytes32(0) || from == address(0) || from == custody) revert InvalidCase();
        if (amount == 0) revert InvalidAmount();
        bytes32 key = keccak256(abi.encode("SEIZE", caseId, from, amount));
        if (seizureReadyAt[key] != 0 || consumedCases[caseId]) revert ActionAlreadyExists();
        seizureReadyAt[key] = block.timestamp + ADMIN_DELAY;
        emit SeizureQueued(caseId, from, amount, seizureReadyAt[key]);
    }

    /// @notice Force-transfer only into designated custody, including from frozen accounts.
    /// @dev Seized funds remain under custody's separate policy; this contract cannot restore them.
    function executeSeizure(bytes32 caseId, address from, uint256 amount) external onlyGovernance {
        bytes32 key = keccak256(abi.encode("SEIZE", caseId, from, amount));
        uint256 ready = seizureReadyAt[key];
        if (ready == 0 || block.timestamp < ready) revert ActionNotReady();
        if (consumedCases[caseId]) revert ActionAlreadyExists();
        if (balanceOf[from] < amount) revert InsufficientBalance();
        consumedCases[caseId] = true;
        delete seizureReadyAt[key];
        _move(from, custody, amount);
        emit SeizureExecuted(caseId, from, amount);
    }

    function cancelMint(bytes32 id, address to, uint256 amount) external onlyGovernance {
        bytes32 key = keccak256(abi.encode("MINT", id, to, amount));
        if (mintReadyAt[key] == 0) revert InvalidCase();
        delete mintReadyAt[key];
        consumedCases[id] = true;
        emit ActionCancelled(id);
    }

    function cancelSeizure(bytes32 id, address from, uint256 amount) external onlyGovernance {
        bytes32 key = keccak256(abi.encode("SEIZE", id, from, amount));
        if (seizureReadyAt[key] == 0) revert InvalidCase();
        delete seizureReadyAt[key];
        consumedCases[id] = true;
        emit ActionCancelled(id);
    }

    function _checkTransfer(address from, address to) internal view {
        if (to == address(0)) revert ZeroAddress();
        if (paused) revert TransfersPaused();
        if (frozen[from] || frozen[to]) revert AccountFrozen();
    }

    function _transfer(address from, address to, uint256 amount) internal {
        _checkTransfer(from, to);
        _move(from, to, amount);
    }

    function _move(address from, address to, uint256 amount) internal {
        uint256 current = balanceOf[from];
        if (current < amount) revert InsufficientBalance();
        unchecked { balanceOf[from] = current - amount; }
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }
}
