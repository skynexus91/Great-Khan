# KHAN Security Review — preliminary internal code review

Scope: KhanToken.sol, KhanMultisig.sol, deployment script, Foundry tests, as of branch feature/khan-production-foundation.

**This is a preliminary engineering review, NOT an independent security audit.** Passing CI is not proof of financial safety. No mainnet deployment recommended.

## Findings
1. HIGH / unresolved: `custody` is an immutable arbitrary address. Seized funds can be moved to an EOA, with no onchain restitution, appeal, independent custodian or release controls. Require a separately audited escrow/custody contract and legal process before real use.
2. HIGH / operational: a single guardian can freeze any user or pause transfers instantly, with no onchain expiry or approval threshold. This is an intentional emergency power but creates censorship and key-compromise risk. Recommend short automatic expiry, multi-party escalation, transparent case evidence and recovery procedures.
3. MEDIUM: no onchain rate limit for mint, only immutable lifetime 5B cap and 48h queue delay. Governance could mint all remaining 4B at once after delay. Define epoch mint ceilings and disclosure rules.
4. MEDIUM: custom ERC-20 implementation and zero-first approve may reduce interoperability. Use a pinned, reviewed OpenZeppelin baseline and expanded compatibility testing before production.
5. MEDIUM: frozen users cannot revoke allowances via approve(spender,0); this may expose users to previously granted allowances after unfreeze. Consider permitting zero-amount allowance revocation during freeze.
6. MEDIUM: governance multisig has no emergency signer recovery when 3 signers are lost. Signer rotation requires existing 3 approvals. Define documented recovery strategy.
7. MEDIUM: `KhanMultisig` is a bespoke implementation, not independently audited Safe. Onchain confirmations are transparent and cost gas. Prefer a well-reviewed multisig (e.g., Safe) before financial use.
8. LOW: multisig `propose` allows arbitrary contract targets and calldata; intended flexibility increases blast radius of a compromised 3-of-5 quorum. A target/function allowlist can limit damage.
9. LOW: `mintReadyAt` and `seizureReadyAt` use action-parameter hashes; the same case ID can be queued with different parameters before any execution. The `consumedCases` check blocks double execution, but duplicate queue events can confuse operators. Enforce unique case ID reservation on first queue.
10. INFO: guardian may freeze token recipients and pause immediately; `seize` bypasses both pause and freeze to move into custody, and `mint` may execute while paused. These semantics must be documented for users.
11. INFO: immutable governance/custody addresses make recovery and migration difficult. The tradeoff must be accepted explicitly.

## Minimum gates before any onchain deployment
- Fix or formally accept every high-risk finding, especially custody and emergency guardian controls.
- Independent third-party audit and static analysis, including fuzz/invariant tests.
- Verify the actual multisig configuration has five independent public addresses; avoid concentrated control.
- Run green GitHub Actions for exact merge SHA, plus post-merge verification.
- No mainnet; Sepolia deployment requires a separate explicit approval and safe public address configuration.

## Merge policy
Code may be merged to main as an **experimental research prototype** only. Main branch inclusion does not certify production readiness or authorize any blockchain deployment.
