# KHAN architecture, security and test plan (English)

**Status: Experimental Anvil/Sepolia prototype. Not audited, not deployed.** The owner-approved governance design supersedes the original fixed-supply, no-admin proposal.

## Owner-approved token parameters
- Name: The Great Khan; symbol: KHAN; 18 decimals.
- Initial issuance: **1,000,000,000 KHAN**.
- Immutable lifetime cap: **5,000,000,000 KHAN**.
- Mint, freeze, seize and pause are intentionally supported administrative powers. They must be disclosed to holders.
- Mint/seizure: governance-only, token-enforced 48-hour queue delay.
- Guardian: 24-hour per-action emergency freeze/pause; governance: seven-day per-action freeze/pause.
- 3-of-5 bespoke multisig controls governance; signer rotation invalidates pending proposals.
- Seized KHAN are transferred into `KhanSeizureEscrow`, with case recording, source dispute and seven-day delayed release. Independent arbitration is not implemented.

## Architecture
1. **Token:** custom ERC-20 with cap and administrative powers; evaluate OpenZeppelin integration and compatibility before production.
2. **Governance:** five independent signer wallets and three onchain approvals. No single-key token mint/seize if governance address is configured correctly.
3. **Emergency:** separate guardian may freeze/pause immediately but cannot mint or seize. Renewals can prolong freezes beyond 24 hours cumulatively.
4. **Escrow:** custody accounting and delayed releases; a dispute suspends release until governance resolution.
5. **Revenue allocator:** proposed 40% Commons / 30% People / 30% Businesses, only for net distributable protocol revenue; not deployed onchain.
6. **Payments/mobile:** not yet production implemented.
7. **Legal/compliance:** consumer protection, dispute resolution, privacy, financial regulation and applicable sanctions analysis before any real-value use.

## Testing and security gates
- ERC-20 transfers, approvals, invalid recipients and allowance boundaries.
- Mint supply cap, mint queue timelock, replay resistance and permissions.
- Multisig 3-of-5 threshold, revocation, rotation, failure rollback.
- Guardian expiry, freeze/pause enforcement and renewal abuse.
- Escrow case recording, dispute, delayed release, unauthorized actions and reentrancy.
- Additional invariant/fuzz testing, static analysis, manual threat modeling, independent audit, deployment rehearsal and source verification.
- Do not treat passing GitHub Actions as an audit.

## Deployment constraints
Only Anvil chain 31337 or Ethereum Sepolia chain 11155111; **no broadcast without separate user authorization**. Prepare five distinct public signer addresses, governance multisig, escrow, guardian and initial holder. The existing token-only script requires prior multisig and escrow setup. Never request or store private keys in GitHub/chat.

## Known blockers for production
Escrow has no independent arbitration; guardian can renew restrictions; no epoch mint cap; multisig lacks lost-quorum recovery; bespoke contracts have no external audit. See `docs/SECURITY_REVIEW_PRELIMINARY.md` and `docs/EMERGENCY_AND_ESCROW.md`.
