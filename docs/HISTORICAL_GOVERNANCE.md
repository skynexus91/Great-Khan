# KHAN governance inspired by the Mongol Empire — design proposal v0.1

This is an **analogy, not a reconstruction or endorsement of imperial conquest**. Historical institutions varied across rulers and periods. Avoid claims of a single uniform Great Khan tax code.

## Historical inspiration → safe digital adaptation

| Historical institution | Broad historical function | KHAN adaptation | Safeguard |
|---|---|---|---|
| Great Khan and imperial kurultai | Central legitimacy and elite consultation | Protocol charter and elected multi-party council | No permanent sovereign, term limits, recall and constitutional constraints |
| Yam / örtöö relay network | Relay stations, messengers, horses, rapid administrative communication | Regional validator/relay nodes and signed message queues | Rate limits, spam controls, end-to-end encryption, privacy and independent audit |
| Paiza / gerege credentials | Authorized travel, logistics and access to relay resources | Revocable, narrowly scoped role credentials | No privileged financial exemption; least privilege, expiry and public oversight |
| Darughachi administrative officials | Local administration and tribute/tax supervision | Regionally elected treasury stewards | Multi-signature approvals, audit trails, conflict-of-interest disclosure |
| Tribute and levies | Funding imperial administration, varying by locality and era | Small disclosed network service fee | Public cap, exemptions/credits for low-value transactions, no coercion |
| Commercial facilitation / merchant networks | Long-distance trade supported by protected routes and relays | Interregional exchange and payment routing | Open access, transparent routing fees, no monopolies or preferential treatment |
| Local autonomy within an empire | Varied local customs and institutions | Regional budgets and proposal governance | Equal basic rights, portable identities, appeals and anti-discrimination rules |

## Constitutional rules
- **No empire-like coercion:** no conquest, forced tribute, hereditary rank, arbitrary seizure, discrimination, surveillance state, or censorship of lawful criticism.
- **Decentralized authority:** users elect regional delegates; protocol-level changes need a separate, stronger approval threshold and timelock. An emergency committee can pause narrowly defined dangerous functions but cannot confiscate funds.
- **Public accountability:** protocol parameters, treasury inflows, approvals, allocations, audits and delegate votes are inspectable. Individual payment details are private by default.
- **Right to appeal:** verification and moderation decisions have reasons, review and appeal.
- **Separation of powers:** node operators validate protocol rules, regional councils propose allocations, independent reviewers check compliance, and treasury multisig executes approved payments.

## The 'Yam' communication layer
1. Signed messages carry message_id, sender role, destination, expiry, version, payload hash and nonce.
2. Nodes validate signatures, authorization and expiry; deduplicate message_id; route via regional peers.
3. Receipts acknowledge delivery and finality; retry with bounded backoff; maintain an auditable metadata trail without exposing private content.
4. Validators and relays are separate roles. Message delivery is not proof of transaction finality.
5. Service levels: queue fairness, anti-spam, regional redundancy, partition recovery and independent monitoring.

## Fees and tariffs
- **Network fee:** transparent, bounded KHAN charge for transfers and token activity, calculated in integer minor units. No fee-on-fee and no undisclosed surcharge.
- **Interregional routing tariff:** optional *cost-based* charge only where measurable additional service is provided; quote upfront; no region-of-origin discrimination. For Alpha 0.2, **disable extra tariffs by default** until evidence justifies them.
- **Token issuance:** published one-time KHAN service charge plus separately accounted refundable/locked KHAN reserve; reserve is not spendable treasury.
- **Revenue split:** configurable proportions between network maintenance, regional commons and shared treasury, with auditable accounting. Defaults are *simulation parameters*, not historical claims.
- **Protection:** fee ceiling, low-value transfer allowance, user-visible preview, governance timelock for increases, and no hidden fees.

## Treasury redistribution
1. Calculate spendable KHAN excluding locked reserves and pending obligations.
2. Accept proposals from eligible participants, with budget, region, milestones and public rationale.
3. Community voting plus independently checked sustainability/need/impact scores produce an advisory ranking.
4. Human reviewers verify eligibility and conflicts; elected council approves a bounded funding batch.
5. Execute with multisig or equivalent threshold authorization, idempotency keys and an append-only event log.
6. Report actual spend, outcomes and appeals; reclaim unspent funds only under predefined transparent rules.

## Alpha 0.2 implementation mapping
- `src/domain/fees`: quoted service fee, caps, allowances, integer accounting.
- `src/domain/identity`: scoped paiza-like credentials and revocation.
- `src/domain/messaging`: Yam-inspired signed relay envelopes and replay protection.
- `src/domain/governance`: regional delegates, proposal lifecycle, quorum, appeals.
- `src/domain/treasury`: spendable-vs-locked balances, allocation and audits.
- `src/domain/ledger`: conservation invariants, events, deterministic IDs.

## Acceptance tests
- Unprivileged role cannot change tax rates or redirect treasury.
- Duplicate relay message cannot duplicate a payment.
- Expired/revoked credential is rejected.
- Network partition and retries do not duplicate settlement.
- Fee estimate equals charged fee and never exceeds cap.
- A regional payment is not penalized merely because of sender origin.
- No disbursement without approvals; all funds conserved.
- Privacy-protected transaction data is not leaked in public reports.

## Important distinction
The Mongol Empire's communications and administrative networks offer useful **coordination** patterns, but its conquest and extraction are explicitly excluded from the KHAN model. This is a rights-preserving, voluntary digital cooperative, not an imperial hierarchy.
