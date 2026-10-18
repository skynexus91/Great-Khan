# The Great Khan — Tri-pillar economic constitution (draft 0.1)

## The three equal-status stakeholders
1. **KHAN Commons** — protocol, network infrastructure, security, resilience, public goods and development. This is a **purpose-restricted commons treasury**, not founder income.
2. **People** — verified natural persons, users, workers and communities. Equal baseline rights, privacy, accessibility, appeal and participation.
3. **Businesses** — micro, small, medium and large enterprises. Equal basic standing, transparent access and no purchased political power. Business support may be scaled by demonstrated need and impact, not simply size.

## Distribution proposal (simulation defaults)
Distribute only **net distributable protocol revenue**, after explicit operating obligations, legally required taxes, refunds and reserve liabilities are recognized:
- **40% KHAN Commons:** infrastructure maintenance, security audits, validator incentives, emergency reserves and open development.
- **30% People Pool:** community projects, accessibility, education, low-income fee relief and participation grants.
- **30% Business Pool:** transparent grants for micro/SME innovation, job creation, sustainable investment and interregional trade, with open eligibility for large businesses on equivalent objective terms.

These are **draft policy parameters, not historical tax rates or guaranteed returns**. Treasury allocation must never promise profit or yield. All shares are allocated in integer minor units; remainder goes to an explicitly disclosed rounding account. The commons share cannot be withdrawn by a single person.

## Separate power from revenue
Three chambers: Commons/Protocol, People, Businesses. For major monetary policy changes require approval from **at least two of three chambers**, including the People chamber for changes to individual rights or household fees, plus timelock and public audit. The KHAN chamber cannot unilaterally increase its own allocation. Constitutional changes require a stronger threshold and independent review. No stakeholder may veto emergency security patches indefinitely; narrowly scoped emergency powers expire automatically.

## Fair burden and benefit
- Fees are based on measured service costs and capped; show an estimate before each transaction.
- Small-value transfers may receive a limited allowance, funded transparently from the People Pool rather than by hidden surcharges.
- Companies of all sizes have the same baseline eligibility and procedural rights. No entity receives more votes merely for transacting more KHAN.
- Anti-Sybil verification must minimize collection of personal data and support appeals.
- Separate protocol fees from any actual tax obligations owed under local law.
- No mandatory contribution outside voluntary use of services; no retroactive confiscation.
- Publish annual and quarterly reports on pool inflows, allocations, beneficiaries, and conflicts of interest, preserving private transaction data.

## Historical-modern synthesis
- Yam relay network -> redundant privacy-preserving regional communications.
- Regional administrators -> audited stewards with limited terms and multisig controls.
- Historic tribute -> voluntary transparent capped protocol service charges, **not coercive tribute**.
- Modern credit unions/cooperatives -> member accountability and open books.
- Modern payment rails -> predictable finality, idempotent operations, anti-fraud and consumer protections.
- Modern public finance -> restricted funds, budget appropriations, independent audit and appeals.

## Accounting and test invariants
1. Gross fee receipts = net distributable revenue + operating obligations + refunds + reserve provisions (where applicable).
2. Distributable revenue = Commons allocation + People allocation + Business allocation + disclosed rounding remainder.
3. Commons, People and Business funds are segregated ledgers; no cross-pool spend without approved transparent budget transfer.
4. Locked issuance reserves and user balances are never treasury revenue.
5. Policy changes are versioned, approved by required chambers, time-delayed and logged.
6. No entity may both propose, approve and execute its own funding request.
7. Simulate adversarial cases: whale voting, fake users, business splitting, circular transfers to farm rewards, fee shocks and treasury exhaustion.

## Next implementation milestone
Implement a pure `distributeRevenue(amountMinorUnits, weights={commons:40,people:30,business:30})` with conservation tests and explicit remainder handling. Keep actual on-chain distribution disabled until threat modelling, legal review and governance validation.
