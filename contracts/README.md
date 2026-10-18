# KHAN Solidity contracts — Anvil / Sepolia prototype

**Experimental only. Not audited. No onchain deployment has been performed.**

## Token configuration
- Symbol: KHAN; decimals: 18.
- Initial supply: 1,000,000,000 KHAN.
- Permanent maximum: 5,000,000,000 KHAN.
- 48-hour token-level queue delay for mint and seizure.
- Governed freezes, pause, and confiscation are enabled. **KHAN is administratively controllable**, unlike a permissionless censorship-resistant token.

## Contracts
1. `src/KhanMultisig.sol`: five distinct signers, three approvals to execute; one onchain transaction per confirmation. Governance cannot be safely configured as one ordinary personal wallet.
2. `src/KhanSeizureEscrow.sol`: holds seized tokens, records cases, allows source disputes and 7-day governance-authorized releases.
3. `src/KhanToken.sol`: custom ERC-20 implementation with immutable cap, mint, freeze, pause, seize.
4. `script/DeployKhan.s.sol`: deploys **only KHAN token**, not multisig or escrow. Restricted to Anvil or Sepolia.

## Local tests
Install Foundry, then:
```bash
cd contracts
forge test -vv
```
From repository root:
```bash
npm ci
npm test
```

## Safe deployment preparation — NO BROADCAST
1. Deploy/test a 3-of-5 governance wallet with five independent **public** signer addresses on Anvil.
2. Deploy `KhanSeizureEscrow(governanceMultisig)` on Anvil.
3. Supply the following public address environment variables for the token script:
```bash
export KHAN_INITIAL_HOLDER=0x... 
export KHAN_GOVERNANCE_MULTISIG=0x...
export KHAN_GUARDIAN=0x...
export KHAN_CUSTODY=0x... # must be escrow address
```
4. Simulate token deployment with Foundry without `--broadcast`, and confirm chain ID 31337 or 11155111.
5. Through three separate multisig approvals, call `escrow.bindToken(tokenAddress)`. Before binding, seizure into escrow will revert.
6. Confirm custody balance/case accounting and all permissions in Anvil tests. A tested complete deployment orchestrator is **not yet implemented**.

Never broadcast to Sepolia without fresh explicit approval. Never use Ethereum mainnet. Never disclose wallet private keys or recovery phrases.

## Important security caveats
- Guardian restrictions expire per action, but can be renewed indefinitely.
- The same multisig resolves escrow disputes and approves releases: independent arbitration is absent.
- The custom ERC-20 and multisig are not audited. Prefer reviewed libraries and an established multisig for production.
- Unsolicited direct token transfers to escrow are not tracked as seizure cases and can become stuck.
- This repo is a technical prototype, not a regulated custody service.
