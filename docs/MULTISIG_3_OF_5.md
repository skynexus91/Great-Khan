# KHAN 3-of-5 multisignature governance (Sepolia candidate)

Implemented: `contracts/src/KhanMultisig.sol`, `contracts/test/KhanMultisig.t.sol`.

## Mechanics
- Five distinct, nonzero signer addresses are configured once at multisig deployment.
- Proposer's proposal counts as first confirmation; any two other signers confirm to reach threshold 3.
- Anyone outside the five signers cannot propose, confirm, revoke or execute.
- Any signer may execute an approved transaction. Execution is one-shot and atomic, with revert on failed target call.
- A signer may revoke their approval before execution.
- Changing a signer requires a 3-of-5 approved call to the multisig itself (`replaceSigner`). Rotation invalidates pending transactions from previous signer epoch.
- This wallet can call other contracts with zero ETH only; it cannot receive/forward ETH through a payable execution interface.
- For token governance, deploy KhanToken with `governance_` set to the **deployed KhanMultisig contract address**, not an individual signer's wallet.
- Token `queueMint`, `executeMint`, `queueSeizure`, `executeSeizure`, `unfreeze` and `unpause` then require multisig-approved calls. The token's additional 48-hour delay still applies to mint and seizure.
- **Emergency guardian** can still independently freeze accounts and pause transfers. This is an explicit security exception; it does not allow mint, seize, unfreeze or unpause.

## Unresolved operational requirements
- User must designate five distinct signer PUBLIC addresses before any deployment; NEVER submit seed phrases or private keys.
- Establish independence, signer backup/recovery, hardware wallets and geographic separation. A 3-of-5 multisig is not secure if one person controls 3 keys.
- Multisig itself has no timelock; KHAN token mint/seizure timelock is separate.
- There is no signer inactivity expiration, onchain emergency recovery, multisig cancellation voting, EIP-712 signature support or ERC-1271 support.
- Multisig governance and custody must be independently reviewed before deployment; do not point custody at an ordinary personal wallet without a restitution/dispute process.
- No Sepolia or mainnet transactions have been executed as part of this change.

## Required checks
- Green GitHub Actions for the commit containing the multisig code.
- Unit tests: 3-of-5 threshold, duplicate/zero signers, unauthorized callers, revoke, execute-once, failure rollback, signer rotation and governance-controlled KHAN mint.
- Additional adversarial fuzz/invariant tests, static analysis, multisig signer recovery and independent audit before real-value usage.
