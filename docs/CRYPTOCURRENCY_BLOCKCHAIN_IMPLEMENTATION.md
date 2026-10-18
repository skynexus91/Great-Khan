# KHAN cryptocurrency and blockchain implementation plan
Date: 2026-10-19. Status: proposed implementation path; no token or independent chain has been deployed.

## Decision: token first, independent chain later
Build KHAN as a testnet ERC-20-compatible token on an existing EVM network before considering a standalone chain. This separates token product risk from consensus and validator risk. The existing TypeScript simulator remains a specification and testing reference, NOT an authoritative on-chain ledger.

## Phase 0 — architecture and legal gates
- Decide maximum supply, mint/burn policy, distribution, unlocks, admin authority, recovery, upgradeability, treasury roles and secondary-token relationships. Do not invent supply figures or promise returns.
- Write a threat model: compromised deployer, malicious admin, replay, reentrancy, unsafe approvals, governance capture, oracle manipulation and lost keys.
- Obtain appropriate legal/regulatory review for any real issuance, custody, marketing or trading. Romania/EU launch requires analysis of MiCA and applicable rules; do not assume an exemption.
- Define on-chain vs off-chain responsibilities: wallet balances and token transfers belong on chain; personal identity and private records should not.

## Phase 1 — testnet KHAN token
- Use Solidity with well-reviewed OpenZeppelin ERC20 and AccessControl (or Ownable2Step) building blocks.
- Prefer fixed initial supply minted to a testnet multisig; any additional minting requires a documented governance-approved policy. If minting is unnecessary, omit it entirely.
- Use Foundry or Hardhat for compilation, tests, deployment scripts, verification and reproducible releases.
- Add invariant tests for totalSupply, balances, mint/burn authorization, role restrictions and transfer behavior.
- Never put private keys, seed phrases, or RPC secrets in GitHub. Use GitHub Actions secrets for authorized deployment, ideally with a separate human approval gate.
- Verify contract source on the chosen testnet explorer and publish address, chain ID, compiler version, ABI and deployment transaction.

## Phase 2 — treasury and governance
- Build a treasury contract with restricted disbursement, multisig sign-off, timelock and on-chain event logs.
- **40/30/30 applies only to verified net distributable protocol revenue**, never all transfers or wallet deposits. Do not route user funds automatically to recipients.
- Specify distribution cadence, eligibility, appeals, anti-sybil controls, emergency pause and quorum.
- Consider a separate governance token only if necessary; KHAN as primary unit does not imply secondary tokens must be freely tradable.

## Phase 3 — Android-first interface
- Responsive web dApp first: connect wallet, show testnet KHAN balance, initiate transfers, explain network fees and view transaction status.
- Mobile wallet integration via standards-compatible provider, with explicit chain switching and signing confirmation.
- Accessibility and performance tests on midrange Android hardware. Never request seed phrases or handle raw private keys in the frontend.

## Phase 4 — blockchain architecture decision
**Option A: Existing L1 token:** fastest, cheapest operationally, but no independent chain.
**Option B: EVM L2 / rollup:** custom execution environment and branding; depends on settlement, bridge, sequencing and data availability; requires substantial audits and operating budget.
**Option C: Standalone appchain (e.g., Cosmos SDK or Substrate):** native chain and validators, but significantly greater consensus, governance, infrastructure and security burden.
Recommendation: decide after pilot traction and independent security review. A new chain is not a prerequisite for KHAN cryptocurrency.

## Release gates
G0 approved tokenomics + threat model + legal review plan.
G1 local contract tests and invariants pass.
G2 deployed verified testnet contract with published address and repeatable instructions.
G3 independent contract review and documented remediation.
G4 working Android-first testnet demo, telemetry with privacy controls and recovery instructions.
G5 real-value launch only after independent security and legal sign-off, approved governance and operational readiness.

## Definition of done for first implementation sprint
- Solidity token contract (no unreviewed custom ERC-20 accounting).
- Automated unit/invariant tests.
- Reproducible testnet deployment script; no hard-coded secrets.
- README with test commands and explicit testnet-only warning.
- GitHub Actions CI for Solidity.
- Testnet deployment performed only with explicit network, funded test wallet and user authorization.

## Immediate next task
Choose target testnet (e.g., Ethereum Sepolia or an EVM L2 testnet), contract tooling and supply policy. Implement local contract and tests first; do not conflate writing Solidity with deployment.
