# The Great Khan — economic logic and architecture (Alpha 0.2)

## Scope
A mobile-first **simulation**, not a production blockchain or financial product. KHAN is the base unit for fees, reserves and governance accounting. Secondary community tokens depend on KHAN for issuance reserves and transaction fees. No real deposits, keys, or financial value.

## Domain boundaries
1. **Wallets:** demo identity, region, verified status, KHAN and token balances.
2. **KHAN ledger:** immutable-style event records; every state transition has a unique id, timestamp, actor and before/after accounting.
3. **Transfers:** validate identities, asset existence, positive finite amount and sufficient balance. Deduct sender amount plus KHAN fee; credit receiver amount; credit treasury fee.
4. **Token issuance:** only verified identities; globally unique symbol; supply within configured limits; KHAN issuance charge goes to treasury and reserve goes to a separately tracked locked-reserve account. Tokens cannot operate outside KHAN accounting.
5. **Treasury:** transparent inflows, outflows and locked reserves; never treat reserves as spendable treasury. Require conservation checks.
6. **Governance:** one eligible demo identity/one vote per proposal; human review before disbursement. Separate proposal author, reviewer and execution permissions.
7. **Project scoring:** deterministic weighted need, sustainability, impact, and eligible votes. AI recommendations are advisory and explainable, never transaction-authorizing.
8. **Redistribution:** calculate a bounded pool; distribute exact integer minor units using deterministic remainder allocation so total payouts never exceed pool; log approvals and allocation events.
9. **Persistence:** versioned schema, validation on load, migrations and recovery from corrupt browser storage. Later replace local-only store with authenticated backend and database.
10. **Mobile:** responsive Android-first layout, accessible touch targets, offline-friendly navigation, minimal client bundle.

## Non-negotiable invariants
- No negative balances, NaN, Infinity or fractional minor units.
- KHAN conservation across wallets + treasury + locked reserves + allocated project accounts, except explicitly logged genesis/mint/burn.
- A transfer's KHAN debit equals receiver KHAN credit plus treasury fee.
- Issuance deducts charge and locked reserve exactly once.
- Token balances across wallets equal token supply, unless a separately recorded mint/burn operation exists.
- Allocation cannot spend locked reserves or more than available treasury.
- Unverified actors cannot issue tokens or impersonate verified voters.
- Votes refer to existing eligible wallets and projects.
- Parameter updates have bounds, roles and audit history.
- All mutations must be idempotent for a repeated operation id.

## Existing Alpha 0.1 code observations
Source inspected read-only from `src/lib/sim.ts` in the Lovable project:
- Demo wallets start with 5,000 + 3,000 + 2,000 KHAN; treasury starts with another 1,000 KHAN.
- Transfer charges a configurable KHAN fee and logs the transaction.
- Token issuance locks a KHAN reserve in token metadata and sends an issuance charge to treasury.
- Governance allows voting and approval, and allocation distributes a percentage of treasury.
- Current hash is FNV-based **simulation identifier**, not a cryptographic transaction hash.
- Current browser localStorage is a demo persistence mechanism, not secure custody.
- Current vote, review, verification and parameter actions lack authorization checks; this must be fixed before any shared deployment.
- Current redistribution uses per-project rounding and can over/under-allocate; use integer minor units and deterministic remainders.
- Current state uses JS floating-point amounts; migrate to integer minor units.

## Implementation sequence
**P0:** migrate original source read-only, establish repeatable install/build/test; lock down simulation-only labels.
**P1:** extract pure domain functions, integer arithmetic, invariants and property-based tests.
**P2:** roles and approval rules, append-only ledger, deterministic treasury allocations, validated persistence.
**P3:** Android performance and touch usability, end-to-end browser tests and CI.
**P4:** optional authenticated backend; independent chain architecture is a separate research milestone.

## Required test scenarios
Transfer: exact balance, insufficient balance, negative/NaN/Infinity, self transfer, unknown asset, fee accounting.
Tokens: verified/unverified issuer, duplicate symbol, insufficient KHAN, reserve conservation, supply conservation.
Governance: duplicate votes, unknown voter, unapproved funding, authorization, deterministic scoring.
Treasury: multiple eligible projects, rounding remainders, repeated allocation request, conservation.
Persistence: reload, corrupt JSON, schema migration, reset.
Android: 360px viewport, touch controls, keyboard and screen reader access, slow-device interaction latency.

## Operating rule
Do not modify Lovable or publish there without renewed user permission. Source retrieval from Lovable is read-only. Development target: `skynexus91/Great-Khan`.
