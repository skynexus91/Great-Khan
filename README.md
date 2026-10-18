# The Great Khan (KHAN)

Open-source experimental economic simulation and Solidity token research project. **Not audited, not deployed, not production-ready, and not a financial service.** All blockchain work is limited to Anvil and Ethereum Sepolia; no mainnet deployment is authorized.

## Components
- `src/domain/revenue.ts`: deterministic allocation simulation.
- `contracts/src/KhanToken.sol`: governed ERC-20 prototype, 18 decimals, **1,000,000,000 KHAN initially**, **5,000,000,000 KHAN immutable lifetime cap**.
- `contracts/src/KhanMultisig.sol`: bespoke onchain **3-of-5** governance wallet; each approval requires an onchain transaction.
- `contracts/src/KhanSeizureEscrow.sol`: seizure case accounting, onchain dispute, governance-controlled release with a seven-day delay.
- `contracts/test/`: Foundry unit and fuzz tests.
- `docs/EMERGENCY_AND_ESCROW.md`: emergency and custody model.
- `docs/MULTISIG_3_OF_5.md`: multisig authorization and operational limitations.
- `docs/SECURITY_REVIEW_PRELIMINARY.md`: preliminary security review; not an independent audit.
- `docs/TRI_PILLAR_ECONOMY.md`: economic allocation charter.

## Economic simulation
Proposed **40% Commons / 30% People / 30% Businesses** applies only to **net distributable protocol revenue**, not user balances, seized funds or the KHAN token supply. This distribution is an economic simulation and is not an onchain token distribution mechanism.

## Token governance
- Mint: governance-only, queued, 48-hour delay, total supply cannot exceed 5 billion KHAN.
- Seize: governance-only, queued, 48-hour delay; tokens move only to designated custody address. Use the escrow contract for accountable custody.
- Emergency guardian: may freeze an account or pause transfers for 24 hours per action. Repeated actions can renew the restriction.
- Governance: can freeze/pause for seven days per action, unfreeze/unpause early, and administer escrow.
- Escrow: records seizure cases; governance can queue a release with a seven-day delay; the source may file an onchain dispute. Governance currently also resolves disputes; **independent arbitration is not implemented**.
- All administrative powers must be disclosed to users. The 3-of-5 wallet is a custom research implementation, not an audited Safe deployment.

## Tests
```bash
npm ci
npm test
cd contracts
forge test -vv
```
GitHub Actions workflows run the JS/TS and Foundry test suites. Passing tests does not establish security.

## Deployment
Only Anvil (chain 31337) or Ethereum Sepolia (11155111), with separate explicit approval before any broadcast. Deployment sequence: 3-of-5 multisig -> seizure escrow -> token (custody set to escrow) -> multisig-authorized escrow token binding. **The existing deployment script deploys only the token and requires preconfigured addresses.** Never put private keys, seed phrases or recovery phrases in GitHub or chat.

## Outstanding security gates
Independent audit, escrow arbitration design, guardian renewal abuse protections, rate-limited mint, signer recovery, adversarial invariant/fuzz tests, static analysis and complete deployment rehearsal are required before any real-value usage.

## Project status
Experimental prototype only. No real blockchain funds, promised returns or deployed contracts are provided.
