// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Experimental KHAN seizure escrow. Requires token custody address to equal this contract.
/// @dev Deploy escrow first, deploy token pointing to escrow, then bindToken via multisig governance.
interface IEscrowKhan {
    function custody() external view returns (address);
    function governance() external view returns (address);
    function transfer(address to, uint256 amount) external returns (bool);
}
contract KhanSeizureEscrow {
    uint256 public constant RELEASE_DELAY = 7 days;
    address public immutable governance;
    address public token;
    uint256 private entered;

    struct Case {
        address source;
        uint256 deposited;
        uint256 released;
        uint256 releaseReadyAt;
        address recipient;
        bool disputed;
    }
    mapping(bytes32 => Case) public cases;

    event TokenBound(address indexed token);
    event SeizureRecorded(bytes32 indexed caseId, address indexed source, uint256 amount);
    event ReleaseQueued(bytes32 indexed caseId, address indexed recipient, uint256 amount, uint256 readyAt);
    event DisputeFiled(bytes32 indexed caseId, address indexed claimant);
    event DisputeResolved(bytes32 indexed caseId);
    event Released(bytes32 indexed caseId, address indexed recipient, uint256 amount);
    event ReleaseCancelled(bytes32 indexed caseId);

    error Unauthorized();
    error InvalidCase();
    error InvalidAddress();
    error AlreadyBound();
    error NotReady();
    error Disputed();
    error Reentrant();
    error TransferFailed();

    modifier onlyGovernance() { if (msg.sender != governance) revert Unauthorized(); _; }
    modifier nonReentrant() {
        if (entered != 0) revert Reentrant();
        entered = 1;
        _;
        entered = 0;
    }

    constructor(address governance_) {
        if (governance_ == address(0)) revert InvalidAddress();
        governance = governance_;
    }

    function bindToken(address token_) external onlyGovernance {
        if (token != address(0)) revert AlreadyBound();
        if (token_ == address(0) || token_.code.length == 0) revert InvalidAddress();
        if (IEscrowKhan(token_).custody() != address(this) ||
            IEscrowKhan(token_).governance() != governance) revert InvalidAddress();
        token = token_;
        emit TokenBound(token_);
    }

    function recordSeizure(bytes32 caseId, address from, uint256 amount) external {
        if (msg.sender != token || token == address(0)) revert Unauthorized();
        if (caseId == bytes32(0) || from == address(0) || amount == 0) revert InvalidCase();
        Case storage c = cases[caseId];
        if (c.deposited != 0) revert InvalidCase();
        c.source = from;
        c.deposited = amount;
        emit SeizureRecorded(caseId, from, amount);
    }

    /// @notice The source wallet may file an onchain dispute; governance must explicitly resolve it.
    function dispute(bytes32 caseId) external {
        Case storage c = cases[caseId];
        if (c.deposited == 0 || msg.sender != c.source || c.released != 0) revert Unauthorized();
        c.disputed = true;
        c.releaseReadyAt = 0;
        emit DisputeFiled(caseId, msg.sender);
    }

    function resolveDispute(bytes32 caseId) external onlyGovernance {
        Case storage c = cases[caseId];
        if (!c.disputed) revert InvalidCase();
        c.disputed = false;
        emit DisputeResolved(caseId);
    }

    /// @dev Recipient is ordinarily original source; alternate recipient needs explicit governance approval.
    function queueRelease(bytes32 caseId, address recipient) external onlyGovernance {
        Case storage c = cases[caseId];
        if (c.deposited == 0 || c.released != 0 || c.disputed) revert InvalidCase();
        if (recipient == address(0) || recipient == address(this)) revert InvalidAddress();
        c.recipient = recipient;
        c.releaseReadyAt = block.timestamp + RELEASE_DELAY;
        emit ReleaseQueued(caseId, recipient, c.deposited, c.releaseReadyAt);
    }

    function cancelRelease(bytes32 caseId) external onlyGovernance {
        Case storage c = cases[caseId];
        if (c.releaseReadyAt == 0) revert InvalidCase();
        c.releaseReadyAt = 0;
        emit ReleaseCancelled(caseId);
    }

    function executeRelease(bytes32 caseId) external onlyGovernance nonReentrant {
        Case storage c = cases[caseId];
        if (c.disputed) revert Disputed();
        if (c.releaseReadyAt == 0 || block.timestamp < c.releaseReadyAt) revert NotReady();
        uint256 amount = c.deposited - c.released;
        if (amount == 0) revert InvalidCase();
        c.released = c.deposited;
        c.releaseReadyAt = 0;
        if (!IEscrowKhan(token).transfer(c.recipient, amount)) revert TransferFailed();
        emit Released(caseId, c.recipient, amount);
    }
}
