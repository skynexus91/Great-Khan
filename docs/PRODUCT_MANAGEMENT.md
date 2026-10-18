# Product management — The Great Khan
Version 0.2 / 2026-10-19

## Product thesis
Build an accessible, transparent economic **simulation** in which KHAN is the base accounting unit, secondary community tokens can eventually be modeled, and community-approved initiatives can receive distributions. The product currently has no production token, blockchain or financial service.

## Target stakeholders
People: mobile-first participants and community voters. Businesses: small, medium and large operators who may later issue or accept community instruments. KHAN Commons: shared infrastructure and public-interest governance. Reviewers/stewards: accountable moderators with restricted, audited privileges.

## Scope and completed deliverables
Completed in the GitHub repository: revenue allocation domain, wallet validation, transfer domain, idempotent in-memory ledger, versioned snapshot serialization, unit/property-style randomized tests, GitHub Actions configuration, governance and architecture documents. In-progress: persistence validation and tests. Not completed: integrated mobile application, backend, real custody, KYC/AML, independent consensus network, secure identity, live payments or public launch.

## Milestones and acceptance criteria
M1 Accounting engine: exact integer conservation, 100k reproducible revenue cases, boundary coverage, passing CI. M2 Wallets/transfers: reject invalid inputs, fee correctness, unique IDs, 20k transfer cases. M3 Ledger: same-ID replay is a no-op, conflicting replay rejected, immutable history and 2k chained transfers. M4 Durable prototype: versioned load/save, schema migrations, replay verification, crash recovery and documented corruption behavior. M5 Android browser experience: readable at 360px, >=44px tap targets, accessible keyboard/screen reader flows, p95 input response target under 100ms on midrange device. M6 Governance: roles, approval separation, audited allocation, anti-sybil policies. M7 Pilot: usability, accessibility, threat-model review and transparent limitations.

## RACI (proposed, not staffed)
Product owner: approve scope, positioning and release gates. Engineering: implement domain, CI, performance and threat mitigations. Security reviewer: independently assess critical code and permissions. Community council: review fairness, allocation policy and appeals. Marketing: publish only substantiated capabilities and results. No person is assumed appointed to any role.

## Risks and mitigations
Financial/regulatory misinterpretation -> prominent simulator labels and jurisdiction-specific legal review before real-value use. Manipulated votes -> authorization, anti-sybil and human appeal. Treasury abuse -> separation of duties and immutable audits. Privacy -> data minimization, no secrets in browser storage. Mobile performance -> real-device benchmarks. False confidence from green CI -> distinct gates for tests, security audit and product readiness.

## Success metrics (targets, not results)
100% CI pass for release candidate; 0 known critical ledger-conservation failures; 0 unauthorized disbursements in test suite; completion of core mobile tasks by >=90% of usability testers; no real-money feature until independent security and legal sign-off.

## Release gate
A green workflow is necessary but not sufficient. No claims of decentralized production, security certification, guaranteed returns or launched blockchain until independently verified.
