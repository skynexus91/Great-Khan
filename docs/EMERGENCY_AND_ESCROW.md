# Emergency guardian and seizure escrow — Sepolia research prototype

## Emergency guardian
- The guardian can freeze an address or pause token transfers for at most 24 hours per action.
- Governance may freeze/pause for 7 days per action; only governance may unfreeze/unpause early.
- Expiry is checked dynamically in `frozen(address)` and `paused()`; no maintenance transaction is required.
- Repeated guardian actions can extend restrictions. Rate limits, case approval and guardian replacement remain open security issues.
- The guardian CANNOT mint or seize KHAN. Those actions still require multisig governance and the token's 48-hour delay.

## Seizure escrow
- Deploy `KhanSeizureEscrow(governanceMultisig)` first.
- Deploy `KhanToken(initialHolder, governanceMultisig, guardian, escrowAddress)`.
- Have governance multisig execute `escrow.bindToken(tokenAddress)` once. Before binding, seizures into this escrow revert atomically.
- A token seizure records the unique case ID, source address and amount inside escrow. Only KHAN token can record seizures.
- Governance multisig can queue a return/release with a **7-day** delay; source may file a dispute onchain, cancelling the queued release.
- Governance must resolve dispute explicitly before any new release can be queued. Recipient can be an alternate address approved by governance.
- Funds cannot be released while disputed; all releases are recorded. Only the original seized KHAN can be released for each case.
- Escrow cannot send funds while token transfers are paused or if recipient is frozen; try again after restrictions expire.

## Security limitations
- Not audited. No real-value use or mainnet deployment.
- Custody escrow does not provide independent arbitration; the same governance multisig can resolve disputes and choose a recipient. An independent reviewer, appeals policy and legal framework are still required.
- Emergency guardian can repeatedly renew restrictions; maximum single-action duration is not a cumulative cap.
- Any tokens sent directly to escrow outside `executeSeizure` are unaccounted and cannot be recovered by current escrow code.
- Case IDs in the token can be queued with alternate parameters; reserve unique IDs on queue in a follow-up.
- Use five independently controlled signer addresses; no private keys in GitHub or chat.
- Existing deployment script requires escrow address but does not automatically deploy/bind escrow. A tested Anvil/Sepolia deployment orchestration script remains needed.
