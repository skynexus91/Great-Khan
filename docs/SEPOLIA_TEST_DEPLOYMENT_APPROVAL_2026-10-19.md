# KHAN Sepolia test deployment — owner authorization and readiness

Date: 2026-10-19.

## Explicit owner authorization
Owner approved **preparation of deployment** to the public Ethereum Sepolia testnet, using **test assets only**. This is **not** approval for mainnet, production, fundraising, real-money trading, or regulatory claims.

## Approved parameters
- Token name: The Great Khan
- Symbol: KHAN
- Decimals: 18
- Fixed supply: 1,000,000,000 KHAN = `1000000000000000000000000000` base units.
- Testnet chain: Ethereum Sepolia, chain ID 11155111.
- Recipient address, confirmed by owner as displayed in MetaMask: `0x480F2b9E76098882d4245d36788db656a6cB585a`.
- Deployer wallet: **not provided**; never commit or request private keys or recovery phrases.

## Mandatory technical gates
- [ ] Run `cd contracts && forge test -vv` with successful output.
- [ ] Review GitHub Actions workflow logs and record green run URL.
- [ ] Run Anvil deployment simulation and verify deployed token metadata, balance, totalSupply and chain ID.
- [ ] Verify official Sepolia RPC and faucet; use only faucet ETH.
- [ ] Run Sepolia simulation without broadcast and inspect transactions.
- [ ] Only then consider broadcasting with a protected signer under a separately confirmed execution plan; record transaction hash and deployed contract address.
- [ ] Independent security review before any production deployment.

## Current state
Deployment **not executed**; no contract address, tx hash or confirmed passing test results. The repository contains the deploy script and tests but that is not proof they ran.

## Commands (safe, no broadcast)
```bash
cd contracts
forge test -vv
export KHAN_INITIAL_HOLDER=0x480F2b9E76098882d4245d36788db656a6cB585a
export KHAN_INITIAL_SUPPLY_WEI=1000000000000000000000000000
forge script script/DeployKhan.s.sol:DeployKhan --rpc-url "$SEPOLIA_RPC_URL"
```
Set `SEPOLIA_RPC_URL` privately to a reputable Sepolia endpoint. **No `--broadcast`** in the preparation commands. Never put a secret in the repository.
