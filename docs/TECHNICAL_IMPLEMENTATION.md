# Technical implementation — The Great Khan
Updated: 2026-10-19. Status: experimental simulator, NOT a production blockchain.

## Architecture
The TypeScript domain layer is independent of any UI: `revenue.ts`, `transfers.ts`, `wallets.ts`, `ledger.ts`, and `persistence.ts`. Unit tests live alongside each module. Node 22, TypeScript strict typecheck, Vitest and GitHub Actions run on pushes to main and pull requests.

## Revenue
`distributeRevenue(amount, weights)` allocates net distributable simulated protocol revenue among KHAN Commons (40%), People (30%), Businesses (30%) by default. Shares must total 100. All monetary values are nonnegative safe integers in minor units. BigInt intermediate multiplication avoids floating-point overflow; largest-remainder allocation conserves the total, including odd amounts and large safe integers. The three pillars do NOT represent automatic ownership or investment returns.

## Wallets
`validateWallet` rejects malformed IDs, negative, fractional and unsafe balances, and nonboolean verification flags. `createWallet` rejects duplicate IDs and creates an empty unverified demo wallet. `totalWalletBalance` sums via BigInt and checks uniqueness. Demo wallet IDs are NOT public keys; verified is a simulation flag, not real-world identity verification.

## Transfers
`transferKhan` validates distinct participants, amount, fee rate (0–10,000 basis points), sufficient sender funds including fee, and recipient/treasury overflow. Fee uses ceiling integer arithmetic, with exact BigInt intermediates. Returns new objects rather than mutating inputs. Invariant: sender debit = receiver credit + treasury fee.

## Ledger
`applyTransfer` resolves sender and recipient from a wallet registry, validates the state, and records a KHAN_TRANSFER event. Identical operation ID plus identical payload is an idempotent retry; reusing an ID with changed payload fails. Registry and history are returned immutably. This is an in-memory demo and NOT transactional multiuser storage.

## Persistence
`serializeLedger` and `deserializeLedger` use a versioned JSON envelope, deterministic noncryptographic checksum, and structural validation. `saveLedger`/`loadLedger` accept a storage adapter. Corrupt, incompatible and oversized snapshots fail closed. IMPORTANT: the checksum detects accidental corruption, NOT malicious tampering. This implementation does NOT provide authenticated persistence, event replay proof, encryption, crash-atomic writes, database durability, cryptographic signatures or cross-device synchronization.

## Test matrix
- Revenue: 100,000 seeded randomized amounts and weight combinations; boundaries and invalid inputs.
- Transfers: 20,000 seeded randomized transfer cases; fee conservation and rejection paths.
- Wallets: uniqueness, bounds and exact aggregate accounting.
- Ledger: 2,000 sequential operations, idempotency, event history and rejection paths.
- Persistence: round trips, malformed snapshots, duplicate events and repeated save/load cycles.
- GitHub workflow: `.github/workflows/vitest.yml`, `npm run typecheck`, `npm test -- --testTimeout=120000`.

## Security and reliability backlog (prioritized)
P0: Persist an immutable genesis/supply commitment and cryptographically authenticated hash-chain of ledger events; validate state by replay; prevent replay IDs across persistence boundaries. P0: Move real multiuser state to a database with atomic transaction boundaries and unique operation IDs. P0: authorization model for issuer/reviewer/voter/admin; never trust a browser verification flag. P1: browser persistence migrations and safe recovery, backup, restore and tamper-evident audit. P1: deterministic supply/property testing, fuzzing and concurrency simulations. P2: responsive mobile frontend and accessibility/performance budget. P3: threat model and independent audit before any real-value deployment.

## Run
```bash
npm install
npm run typecheck
npm test -- --testTimeout=120000
```
Never interpret passing unit tests as a security audit or chain launch.
