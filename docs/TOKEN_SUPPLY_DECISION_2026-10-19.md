# KHAN tokenomics decision log — 2026-10-19

## Confirmed by project owner
- **Total initial token supply: 1,000,000,000 units (one billion).**
- Supply remains **fixed** in the prototype: no external mint function.
- Decimals: 18; constructor parameter `initialSupply` is in base units, therefore **1000000000000000000000000000** for one billion tokens.
- **Name and symbol remain The Great Khan (KHAN).** The owner clarified that the earlier “CATHY” interpretation was incorrect; no rename requested.

## Pending user inputs before public Sepolia deployment
1. Supply an EVM address (`0x` plus 40 hexadecimal characters) to receive test tokens. **Never share a private key or seed phrase.**
2. Confirm the specific Sepolia deployment transaction after tests pass; use faucet ETH only.

## Release gates
- Local `forge test -vv` and GitHub Actions green, with recorded run link.
- Contract deployment dry-run on Anvil and Sepolia simulation.
- Explicit owner confirmation of token name/symbol, holder, supply and chain.
- No mainnet launch, commercial offer, fundraising, or statement of regulatory approval.
