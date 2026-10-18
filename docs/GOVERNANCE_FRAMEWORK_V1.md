# KHAN Governance Framework v1 — Draft for consultation
Date: 2026-10-19. **Proposal only**, not an operational DAO, legal constitution or binding policy.

## Objectives
Protect community participants, treasury funds and the economic promise that KHAN Commons, People and Businesses share **net distributable protocol revenue** 40/30/30. Preserve human review and meaningful appeal.

## Roles and separation of duties
- **Token holders / participants:** may submit proposals, comment and vote once voting rights are explicitly defined. Token ownership alone must not automatically confer unlimited influence.
- **Commons council:** reviews public-benefit spending, proposes budgets and reports conflicts.
- **People delegates:** represent individual users and publish reasons for votes.
- **Business delegates:** represent participating organizations and disclose related-party interests.
- **Security guardians:** narrowly empowered to pause critical contracts, but not to seize funds or rewrite allocations.
- **Treasury multisig signers:** execute approved transfers with role separation and a timelock; signers cannot unilaterally create spending mandates.
- **Independent auditor / ombuds:** reviews decisions, financial reconciliation, complaints and appeals.

## Proposal lifecycle
1. Draft with rationale, beneficiary, amount, risk, conflicts, and technical/legal assessment.
2. Public review and amendment window.
3. Eligibility, anti-sybil and conflict-of-interest checks.
4. Voting by defined constituency and quorum; publish tallies.
5. Mandatory timelock for treasury-affecting decisions.
6. Multisig execution of approved bounded instructions.
7. Post-execution audit, reporting, and appeal process.

## Voting model to test (not yet adopted)
Start with off-chain nonbinding votes in the simulator; compare one-person-one-vote with verified eligibility, delegated voting, and capped token-weighted voting. Define quorum, majority, veto scope, appeal and emergency overrides through public consultation. Do not set arbitrary on-chain parameters until anti-capture analysis is complete.

## Treasury and accounting controls
- Funds held for users, deposits and locked reserves are excluded from distributable revenue.
- Treasury ledger must distinguish gross receipts, refunds, operating expenses, restricted assets, reserves and net distributable revenue.
- The 40/30/30 split is an allocation rule applied **after** eligibility is verified, not an automatic fee split.
- Two independent reviewers for spending proposals, multisig execution and immutable event evidence.
- Publish periodic reconciliation, variance and exceptions.

## Safeguards
- Conflict-of-interest declarations and recusal.
- Anti-sybil and eligibility policy, with privacy-preserving verification where feasible.
- Emergency pause limited by scope, expiry and public incident report.
- Appeal channel and transparent case handling.
- No retroactive confiscation or arbitrary transfer restrictions.
- Governance changes require higher scrutiny than routine operations.

## Acceptance criteria before smart-contract governance
Written charter approved; voting and quorum rules agreed; multisig signers independent; timelock tested; pause privileges bounded; treasury disbursement simulated and audited; critical threat scenarios covered; legal classification reviewed.
