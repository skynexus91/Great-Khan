# KHAN fixed-supply ERC-20 — experimental testnet prototype

**Not deployed, audited, authorized, or suitable for real money.** The contract currently uses a minimal custom ERC-20 implementation; **replace with reviewed OpenZeppelin ERC20 before considering production**. KHAN does not yet implement treasury, governance, jurisdiction gating or 40/30/30 distributions.

## Local testing
Install Foundry (forge, cast), then:
```bash
cd contracts
forge test -vv
```
Tests cover initial supply, transfers, approvals and invalid recipients. This does not constitute an audit. GitHub Actions workflow: `.github/workflows/solidity.yml`.

## Deploy locally without any network fees
```bash
anvil
# in a second terminal, with anvil's disposable test key ONLY:
cd contracts
export KHAN_INITIAL_HOLDER=0x000000000000000000000000000000000000dEaD
export KHAN_INITIAL_SUPPLY_WEI=1000000000000000000000000
forge script script/DeployKhan.s.sol:DeployKhan --rpc-url http://127.0.0.1:8545 --private-key <ANVIL_DISPOSABLE_KEY> --broadcast
```
The example mints 1,000,000 KHAN to the placeholder address, which is **not a usable treasury**. For a real testnet, replace with an explicitly approved holder wallet, funded with **faucet tokens only**.

## Optional public EVM testnet — approval required
1. Choose a specific EVM testnet (e.g. Sepolia) and verify chain ID and official RPC endpoint.
2. Agree initial supply, allocation and initial holder. Do not invent final tokenomics.
3. Use a dedicated throwaway deployer wallet; keep keys out of source, logs, chat and GitHub.
4. Set `ETH_RPC_URL`, `KHAN_INITIAL_HOLDER`, `KHAN_INITIAL_SUPPLY_WEI` and use Foundry's interactive keystore or protected environment for signing.
5. Simulate: `forge script script/DeployKhan.s.sol:DeployKhan --rpc-url "$ETH_RPC_URL"`.
6. Only after explicit permission and checks, add `--broadcast` and a protected signer. Record chain ID, contract address, transaction hash and verified source.

No deployment has been performed by this repository change.
