# KHAN — global compliance-by-design revision v1
Date: 2026-10-19. **Design proposal, not a finding of legal compliance.** Applies to all countries in the India, EU, Latin America and Africa research perimeter. No single token architecture can be certified legal everywhere without country-by-country review, licenses and operational controls.

## Global baseline (common technical core)
1. **No promises of price stability, asset backing, redemption, yield or profits.** KHAN is proposed as a utility/community accounting token, subject to legal classification; labels do not decide regulatory status.
2. **Fixed supply by default** for initial testnet experiments; mint authority should be absent unless issuance policy is independently reviewed. Document cap, decimals, allocation, vesting, governance and admin powers before deployment.
3. **No on-chain private user data**, political affiliation, protest participation or sensitive identity details. Off-chain identity/AML checks only when legally necessary, with minimization and privacy controls.
4. **Role separation:** multisig treasury, timelocked upgrades, limited emergency pause and publicly logged changes. A pause/freeze mechanism is not automatically lawful or advisable; assess rights, proportionality and appeal.
5. **40/30/30 applies only to audited net distributable protocol revenue**, never user deposits or transaction principal. A payout mechanism must be independently classified for securities, collective-investment, tax and payment-service consequences before implementation. Do not encode automatic cash-flow entitlements in the ERC-20 token.
6. **No embedded tax withholding or global blacklist assumptions**: obligations differ by jurisdiction and service model. Keep country-specific compliance in a separately reviewed service layer, not a universal smart-contract switch.
7. **Testnet-only** until security audit, qualified local legal opinion, applicable authorization, sanctions/AML controls and marketing approvals are complete.
8. **No claim of legal tender**, bank account equivalence, remittance license or guaranteed inflation protection.

## Architecture boundaries
- Token contract: audited ERC-20 standard behavior, immutable supply policy, events, minimal privileges.
- Treasury: separate contract and ledger, approved revenue reconciliation, governance-controlled disbursements; avoid automatic transfers to unverified beneficiaries.
- Governance: proposals, deliberation, human review, conflicts and appeal, bounded execution.
- Jurisdiction policy engine (off-chain): records where and which activities are approved, licenses/registrations, consumer disclosures, taxes and marketing restrictions; deny real-value operations where clearance is missing.
- Client: explicit chain ID, testnet label, wallet-signed transactions, risk disclosure, accessibility, data minimization.
- Audit evidence: versioned contract source, tests, deployments, legal memos, authorization proofs, change logs.

## Country approval matrix schema
Country; activities (education/testnet, token issuance, offer, marketing, custody, transfer service, exchange, redemption); token classification; regulator; applicable law and effective date; required authorization; AML/CFT; FX/payment limits; sanctions; privacy; tax; advertising; counsel; evidence URL; review date; decision = HOLD / TESTNET EDUCATION ONLY / CONDITIONAL / APPROVED; expiration date.

**Default for every country: HOLD for real-value activity.** The user-facing educational demo is not automatically exempt from all local law; review advertising and privacy requirements as applicable.

## Regional review gates
- EU/Romania: MiCA classification, CASP activity, white-paper/offer, GDPR and financial instruments analysis.
- India: VDA taxation, FIU-IND/PMLA scope, FEMA/RBI payment restrictions and DPDP requirements.
- Latin America: independent review per sovereign jurisdiction, with special attention to Brazil, Mexico, Argentina, Venezuela, Cuba, Bolivia, El Salvador and cross-border sanctions/FX.
- Africa: independent review per sovereign jurisdiction, including CBN/SEC Nigeria, FSCA/FIC South Africa, Kenyan authorities, WAEMU/CEMAC regional rules and North African restrictions.

## High-risk country guardrails
Where conflict, sanctions, severe currency controls or instability affect consumers, do not launch or market a real-value token without explicit independent safety assessment and local legal clearance. Never target political opponents or protest participants.

## Engineering acceptance tests
- Supply cannot increase unexpectedly; no unauthorized mint.
- Token transfers cannot drain treasury; fee accounting separated from token transfer.
- Governance execution cannot bypass timelock or multisig controls.
- Service API denies disallowed activities by country and policy version.
- Every permission decision is logged without storing sensitive political data.
- Replay and reentrancy tests; no signing keys in source.
- UI always distinguishes testnet from production.

## Unresolved decisions requiring product owner + counsel
Token cap/decimals/vesting; whether KHAN conveys any economic rights; business participation rights; whether any fiat conversion or remittance functionality exists; issuer legal entity and domiciles; custody; cross-border services; geographic rollout. Until resolved, there is no global legal compliance certification.

## Sources and companion documents
- [Country economic baseline](COUNTRY_CPI_MACRO_MICRO_LEGAL_BASELINE_2026.md)
- [Global jurisdiction inventory](GLOBAL_LEGAL_COMPLIANCE_INDIA_LATAM_AFRICA.md)
- [EU legal roadmap](LEGAL_COMPLIANCE_ROADMAP_EU.md)
- [Governance](GOVERNANCE_FRAMEWORK_V1.md)
- [Blockchain implementation](CRYPTOCURRENCY_BLOCKCHAIN_IMPLEMENTATION.md)
