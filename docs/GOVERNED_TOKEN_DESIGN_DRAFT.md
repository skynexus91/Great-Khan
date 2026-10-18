# KHAN governed token — Sepolia candidate, NOT AUDITED

Owner-confirmed initial supply: **1,000,000,000 KHAN**.
Owner-confirmed immutable lifetime maximum: **5,000,000,000 KHAN**.
Decimals: 18. Up to 4 billion additional KHAN can be minted, but never beyond the cap.

## Implemented in branch
- Immutable governance, guardian and custody addresses supplied at deployment.
- Governance-only queued mint and seizure with an experimental **48-hour minimum onchain delay**. This delay is a provisional design parameter, not separately approved policy.
- Mint cap enforced again at execution time; replay-protected case IDs shared across mint and seizure.
- Guardian or governance can freeze accounts and pause transfers immediately. Only governance can unfreeze and unpause.
- Frozen accounts cannot send or receive regular transfers or grant approvals. Seizure bypasses transfer freeze and pause but sends funds ONLY to designated custody address, preserving total supply.
- Minted KHAN sent directly to recipient; no mint to frozen accounts. Seized KHAN are not burned.
- Deployment script restricted to Anvil chain 31337 or Sepolia chain 11155111.

## Critical limitations and unresolved decisions
- **A governance address is not itself a 3-of-5 multisig.** A separately deployed and reviewed Safe/multisig must be used; a single-key governance address is unsafe.
- Custody is only an address, NOT a dispute/restitution escrow contract yet. Its security and legal process remain unimplemented.
- Mint rate limits, case expiration, freeze review deadlines, administrative role rotation/recovery, dispute handling, formal event-driven compliance workflow, emergency pause duration and timelock parameters remain to be designed.
- Zero-first approve behavior may impact wallet/DEX compatibility; review against pinned OpenZeppelin contracts before production.
- Current implementation uses custom ERC-20 logic; independent audit, invariant/fuzz coverage and integration tests are mandatory.
- 48-hour delay does NOT by itself provide legal authorization for seizure.
- The token is centrally administrable. Users must be clearly warned of mint, freeze, pause and seizure powers.
- This is a **prototype**, not a final audited production contract. No onchain deployment or private key use has been authorized.

## Release gates
1. All Foundry tests green with recorded GitHub Actions run and logs.
2. Review authorization, custody design, multisig policy and case controls.
3. Add invariant/fuzz tests for cap, balances, frozen transferFrom, approval and seizure replay, queue cancellation and timelock.
4. Static analysis, gas analysis, independent review, legal assessment and bytecode/source verification.
5. Anvil simulation and Sepolia gas estimation; owner approval of exact deployment parameters.
6. Sepolia-only transaction approval, then contract verification and published transaction hash. No mainnet.
