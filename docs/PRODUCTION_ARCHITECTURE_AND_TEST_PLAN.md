# KHAN production-oriented design and Sepolia release gates

Status: DESIGN / EXPERIMENTAL. Not audited; not deployed; no financial services are offered.

## Immutable core
- Name: The Great Khan; symbol: KHAN; decimals: 18.
- Exactly 1,000,000,000 KHAN minted once to an explicitly confirmed recipient.
- No post-deployment minting, owner override, confiscation, blacklist, pausing, or hidden transfer fees.
- ERC-20 implementation currently self-contained for dependency-free prototype testing. **Before production, evaluate replacing it with a pinned, reviewed OpenZeppelin ERC20 implementation**; run compatibility tests before adopting any change.
- Approvals in this prototype require setting an existing nonzero allowance to zero before setting a different nonzero amount. This mitigates a known race but is stricter than common ERC-20 interfaces; document integration impact and re-evaluate against OpenZeppelin patterns.

## Modular protocol architecture (NOT YET IMPLEMENTED)
1. Token: minimal non-upgradeable ERC-20; user balances independent of protocol treasury.
2. Treasury: segregated custody, multisignature approvals, onchain accounting, time-delayed governance actions, and emergency procedures.
3. Revenue allocator: 40% Commons / 30% People / 30% Businesses, calculated ONLY on net distributable protocol revenue; never user balances, customer deposits, or reserves. Integer arithmetic with explicit remainder rules and audit logs.
4. Governance: least privilege, timelocks, transparent proposals, separation of roles, revocation and recovery paths. Never allow governance to mint or seize KHAN.
5. Payments: escrow and settlement as separate audited modules; replay protection, idempotency, dispute/refund paths, and integration testing. No claim of fiat stability or guaranteed exchange rates.
6. Mobile UX: accessible low-bandwidth interface, wallet security, transaction previews, clear fees, no custody of recovery phrases.
7. Operational/legal: jurisdiction-specific payment/crypto compliance, sanctions screening where applicable, consumer protection, privacy, incident response, liquidity and off-ramp assessment.

## Required test plan
- Exact token metadata, supply, constructor zero-address rejection.
- Transfers: zero, full balance, insufficient balance, zero address, conservation of total balances.
- Allowances: reset-to-zero, transferFrom, insufficient allowance, infinite allowance, race/integration behavior.
- Fuzz and invariant tests: sum of balances equals totalSupply across randomized transfers and approvals.
- Gas benchmarks and limits; deterministic reproducible Foundry tests in CI.
- Treasury/allocator tests: zero revenue, rounding, overflow boundaries, conservation, unauthorized withdrawals, multisig and timelock.
- Payments: duplicate execution, reentrancy, refund/dispute flows, malicious contracts, failure/retry behavior.
- Static analysis, dependency pinning, threat model, independent security review, and post-deploy verification.

## Deployment gates
1. Record a green Foundry CI run and review all test logs.
2. Dry-run Anvil and Sepolia simulation, estimate gas against test ETH balance.
3. Independently verify network chain ID 11155111, bytecode, recipient and supply.
4. Require fresh explicit owner approval of transaction details and deployer account.
5. Publish verified contract address and transaction hash only after successful deployment.
6. No Ethereum mainnet deployment or fundraising from this plan.

## Test recipient
Public address supplied for Sepolia testing:
`0x480F2b9E76098882d4245d36788db656a6cB585a`

**Security**: Never commit or send private keys, seed phrases, or wallet recovery credentials. Previously disclosed keys must be considered compromised.
