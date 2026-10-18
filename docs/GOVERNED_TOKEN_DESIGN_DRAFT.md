# KHAN governed token — proposed specification (not implemented)

Status: DRAFT / Sepolia research only. This document supersedes the fixed-supply assumption for future design; it does NOT change the existing token contract or authorize deployment. Initial supply: 1,000,000,000 KHAN, decimals: 18. Maximum cap: **TBD, requires explicit owner confirmation before implementation**. The cap is immutable once deployed; totalSupply + amount <= cap on every mint, with overflow-safe Solidity 0.8 checks. Never mint if cap is unset.

## Administrative functions and authorization
- mint(to, amount): authorized MINTER role via multisig + timelock; positive amount; nonzero recipient; cap invariant; event. Define periodic rate limit before implementation.
- freeze(account, caseId): FREEZER role; require reason reference, expiration/review deadline; block outbound and inbound transfers and transferFrom involving frozen accounts. Consider preventing approve/permit changes for frozen owners, while permitting allowance revocation. Exemptions must be explicit and narrowly defined.
- unfreeze(account, caseId): separate REVIEWER or governance authorization; public event.
- seize(from, amount, caseId): only after recorded authorization and timelock except narrowly specified emergency process; send solely to immutable custody/escrow contract, never an administrator EOA. Must reject zero amount, missing authorization, insufficient balance, duplicate case execution; publicly emit caseId and amount without PII. Define restitution/dispute process and legal basis.
- pause/unpause: emergency transfer suspension by security council with limited duration and separate unpause authorization. Avoid bypass of cap or administrative accounting.

## Governance
- Proposed 3-of-5 multisig with independent signers, no single-key superuser.
- Timelock for mint and seizure (duration TBD), explicit daily/epoch mint limits, role separation, revocation, emergency response.
- Onchain event logs and public operational policy; case details kept offchain and privacy-preserving. Confiscation must be legally reviewed in relevant jurisdictions.
- No proxy upgrades by default; if upgrades are proposed, disclose power and require separate explicit approval and independent review.

## Mandatory tests and release gates
- Fuzz/invariant: totalSupply <= cap, conservation of balances, mint limits, unauthorized roles cannot mint/freeze/seize, frozen accounts cannot bypass via transferFrom, admin events, zero address, boundary cap and overflow.
- Multisig/timelock: threshold, delays, cancellation, replay resistance, signer rotation, compromised-key response.
- Seizure: duplicate case, escrow isolation, insufficient balance, disputes, reversal/restitution; blocked wallet interactions.
- Pause: emergency scope, duration and unpause; do not accidentally bypass sanctions/legal requirements.
- Gas profiling, static analysis, CI, fork testing, external audit, verified source code, user disclosure and regulatory review.
- Deployment Sepolia ONLY after owner confirms cap, timelock and custody design, green CI and fresh transaction approval. No mainnet.

## Open decision
Owner must select **maximum lifetime supply** in whole KHAN units (must be >= 1,000,000,000). This is distinct from a yearly mint budget. Do not silently choose a cap.
