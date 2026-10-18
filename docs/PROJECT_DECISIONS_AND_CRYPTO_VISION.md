# The Great Khan — consolidated project record
**Updated:** 2026-10-19. **Purpose:** preserve the project decisions discussed so far in one version-controlled reference. This is a reconstruction of project decisions, **not a verbatim archive of all chats**.

## Vision and ultimate cryptocurrency ambition
The Great Khan aims to become a **cryptocurrency-based community economy** with KHAN as the main unit, potential secondary tokens linked to KHAN, transparent transfer fees directed to a treasury, and governance that protects people and businesses from abuse. The project's aspirational public-interest goals include lowering financial participation barriers, supporting communities and organizations, and protecting citizens from radical or coercive actions through accountable governance.

**Critical status distinction:** cryptocurrency is the **target product**, not a present capability. The current repository is a **simulator**; it does not issue transferable on-chain assets, implement consensus, hold user funds, or offer a live blockchain. Claims to the contrary would be misleading.

## Core economic policy
Only **net distributable protocol revenue** is eligible for the proposed 40% KHAN Commons / 30% People / 30% Businesses split. Do not redistribute users' principal, deposits, restricted funds, or reserves. Changes require transparent governance and human oversight. Fee collection and allocation are different operations; their accounting must remain auditable.

## What has been implemented
- Strict TypeScript revenue allocation with BigInt intermediate arithmetic and randomized tests.
- Demo wallet registry and validation.
- KHAN transfer fee and conservation engine.
- Idempotent in-memory event ledger with conflict rejection and history.
- Experimental versioned JSON snapshot serialization, structural checks and **noncryptographic** corruption checksum; this does not authenticate snapshots or provide crash-atomic durability.
- Vitest and GitHub Actions checks; previous green status was reported by the project owner for the earlier run. Every new commit needs its own CI verification.
- Architecture, economic, governance, technical, managerial, marketing, advertising, and business-planning documentation.

## Decisions on scope and priorities
1. Build working code and automated tests directly in `skynexus91/Great-Khan`.
2. Prioritize wallets and transfers, then integrated ledger and persistence.
3. Prepare Android/mobile-friendly user experience, but do not claim it exists until a working demo is committed and tested.
4. Build independent blockchain **only after** validation of demand, architecture, security, economics and legal requirements.
5. Use original images and diagrams; label conceptual advertising imagery as such.
6. Maintain separate technical, managerial, marketing and advertising workstreams and upload project artifacts to GitHub where tooling supports the format.
7. Treat every future project conversation as an opportunity to update this record and the relevant GitHub documentation. This is a workflow commitment, not an automatic recording system.

## Technical next actions
P0: authenticated event chain with replay verification, event and wallet consistency, crash-atomic persistence, and unique operation IDs across concurrent requests. P0: authorization and issuance/burn rules with supply conservation. P1: minimal responsive demo and realistic performance/accessibility tests. P1: secure service and persistence model. P2: cryptocurrency chain feasibility and regulatory review, then prototype testnet only if justified.

## Management next actions
Assign accountable owners for engineering, security, product, community governance and compliance. Track issue priorities, definition of done, change control, risk register, release gates, burn rate and incident response. Use independent reviews for financial, governance and security claims.

## Marketing and advertising next actions
Market **the simulator today**, not a nonexistent tradable token. Produce a clear landing page, transparent educational demos, community onboarding, and GitHub progress reports. Advertising creative should emphasize open source and visible rules, include SIMULATION/NO REAL FUNDS, and avoid returns, price speculation, investment solicitation or security certifications. Paid spend requires approved budget, measurement and legal/platform policy review.

## Existing documents
- [Business plan](BUSINESS_PLAN_MASTER.md)
- [Technical implementation](TECHNICAL_IMPLEMENTATION.md)
- [Product management](PRODUCT_MANAGEMENT.md)
- [Marketing](MARKETING_STRATEGY.md)
- [Advertising](ADVERTISING_PLAYBOOK.md)
- [Architecture](ARCHITECTURE.md)
- [Three-pillar economy](TRI_PILLAR_ECONOMY.md)
- [Historical governance](HISTORICAL_GOVERNANCE.md)

## Open decisions (not silently resolved)
Chain architecture (new L1 vs L2 vs existing chain), consensus, token supply and issuance, compliance jurisdictions, custody model, anti-sybil identity, budget, actual customer validation, and audited security posture.
