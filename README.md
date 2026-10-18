# The Great Khan

Open-source, mobile-first KHAN economic simulation. **Demo only:** no real funds, financial returns, or live blockchain.

## Economic model
- **40% KHAN Commons:** infrastructure, resilience and security.
- **30% People:** community programs and user benefits.
- **30% Businesses:** support for businesses of all sizes.

Percentages apply to **net distributable protocol revenue**, never user balances or locked reserves. All amounts use integer minor units. Changes to governance and funding require transparent review.

## Repository
- `src/domain/revenue.ts` — deterministic three-pillar allocation engine.
- `src/domain/revenue.test.ts` — 100,000 reproducibly randomized allocation scenarios and input validation.
- `docs/ARCHITECTURE.md` — economic invariants and implementation plan.
- `docs/HISTORICAL_GOVERNANCE.md` — historically inspired, rights-preserving governance.
- `docs/TRI_PILLAR_ECONOMY.md` — three-pillar charter.
- `.github/workflows/vitest.yml` — automated Vitest checks.

## Test locally
```bash
npm install
npm test
```

## Development status
Economic allocation engine implemented. Wallet transfers, token issuance, treasury operations, governance authorization, complete mobile UI and independent blockchain are **not yet implemented in this repository**. Test success for allocation does not imply a production-ready financial system.

Development and testing are managed in GitHub.
