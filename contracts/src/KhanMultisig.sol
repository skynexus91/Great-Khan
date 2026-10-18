// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice On-chain 3-of-5 multisig prototype for KHAN governance (Anvil/Sepolia ONLY).
/// @dev No offchain signatures; every confirmation is an onchain transaction.
///      No Ether transfers supported; target calls are executed with zero ETH.
contract KhanMultisig {
    uint256 public constant REQUIRED = 3;
    uint256 public constant SIGNER_COUNT = 5;

    address[5] public signers;
    mapping(address => bool) public isSigner;
    uint256 public signerEpoch;
    uint256 public transactionCount;

    struct Transaction {
        address target;
        bytes data;
        uint256 confirmations;
        uint256 epoch;
        bool executed;
    }

    mapping(uint256 => Transaction) private transactions;
    mapping(uint256 => mapping(address => bool)) public confirmed;

    event Proposed(uint256 indexed transactionId, address indexed proposer, address indexed target, bytes data);
    event Confirmed(uint256 indexed transactionId, address indexed signer, uint256 count);
    event Revoked(uint256 indexed transactionId, address indexed signer, uint256 count);
    event Executed(uint256 indexed transactionId, address indexed executor);
    event SignerReplaced(address indexed previousSigner, address indexed newSigner, uint256 epoch);

    error NotSigner();
    error InvalidSigner();
    error InvalidTarget();
    error UnknownTransaction();
    error AlreadyExecuted();
    error AlreadyConfirmed();
    error NotConfirmed();
    error InsufficientConfirmations();
    error OutdatedSigners();
    error OnlySelf();
    error CallFailed(bytes reason);

    modifier onlySigner() {
        if (!isSigner[msg.sender]) revert NotSigner();
        _;
    }

    constructor(address[5] memory initialSigners) {
        for (uint256 i; i < SIGNER_COUNT; ++i) {
            address signer = initialSigners[i];
            if (signer == address(0) || signer == address(this) || isSigner[signer]) revert InvalidSigner();
            isSigner[signer] = true;
            signers[i] = signer;
        }
    }

    function propose(address target, bytes calldata data) external onlySigner returns (uint256 id) {
        if (target == address(0) || target.code.length == 0) revert InvalidTarget();
        id = transactionCount++;
        Transaction storage txn = transactions[id];
        txn.target = target;
        txn.data = data;
        txn.epoch = signerEpoch;
        emit Proposed(id, msg.sender, target, data);
        _confirm(id, txn);
    }

    function confirm(uint256 id) external onlySigner {
        Transaction storage txn = _pending(id);
        _confirm(id, txn);
    }

    function revoke(uint256 id) external onlySigner {
        Transaction storage txn = _pending(id);
        if (!confirmed[id][msg.sender]) revert NotConfirmed();
        confirmed[id][msg.sender] = false;
        --txn.confirmations;
        emit Revoked(id, msg.sender, txn.confirmations);
    }

    function execute(uint256 id) external onlySigner returns (bytes memory result) {
        Transaction storage txn = _pending(id);
        if (txn.confirmations < REQUIRED) revert InsufficientConfirmations();
        txn.executed = true; // CEI: reverts on failed target call, preventing replay
        (bool success, bytes memory response) = txn.target.call(txn.data);
        if (!success) revert CallFailed(response);
        emit Executed(id, msg.sender);
        return response;
    }

    /// @notice Signer rotation must itself be proposed, approved and executed by 3 signers.
    /// @dev Rotation invalidates every pending transaction from previous signer epoch.
    function replaceSigner(address oldSigner, address newSigner) external {
        if (msg.sender != address(this)) revert OnlySelf();
        if (!isSigner[oldSigner] || newSigner == address(0) || newSigner == address(this) ||
            isSigner[newSigner]) revert InvalidSigner();
        for (uint256 i; i < SIGNER_COUNT; ++i) {
            if (signers[i] == oldSigner) {
                signers[i] = newSigner;
                break;
            }
        }
        isSigner[oldSigner] = false;
        isSigner[newSigner] = true;
        ++signerEpoch;
        emit SignerReplaced(oldSigner, newSigner, signerEpoch);
    }

    function getTransaction(uint256 id)
        external view returns (address target, bytes memory data, uint256 count, bool executed, uint256 epoch)
    {
        if (id >= transactionCount) revert UnknownTransaction();
        Transaction storage txn = transactions[id];
        return (txn.target, txn.data, txn.confirmations, txn.executed, txn.epoch);
    }

    function _pending(uint256 id) internal view returns (Transaction storage txn) {
        if (id >= transactionCount) revert UnknownTransaction();
        txn = transactions[id];
        if (txn.executed) revert AlreadyExecuted();
        if (txn.epoch != signerEpoch) revert OutdatedSigners();
    }

    function _confirm(uint256 id, Transaction storage txn) internal {
        if (confirmed[id][msg.sender]) revert AlreadyConfirmed();
        confirmed[id][msg.sender] = true;
        ++txn.confirmations;
        emit Confirmed(id, msg.sender, txn.confirmations);
    }
}
