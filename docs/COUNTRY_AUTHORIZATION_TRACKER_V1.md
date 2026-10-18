# KHAN country authorization tracker v1
2026-10-19. **Every entry: HOLD — no real-value launch approval.** Country-level source checks are incomplete. Official regulator homepages are research leads, not verified filing portals, email addresses, or proof of legal permission.

| Country | Regulator / research entry point | Email/address/forms/fees |
|---|---|---|
| Argentina | https://www.argentina.gob.ar/cnv | Pending official verification |
| Venezuela | https://www.bcv.org.ve/ | Pending official verification |
| Bolivia | https://www.asfi.gob.bo/ | Pending official verification |
| Cuba | https://www.bc.gob.cu/ | Pending official verification |
| Haiti | https://www.brh.ht/ | Pending official verification |
| Brazil | https://www.bcb.gov.br/ | See verified wave 1; licensing fee pending |
| Colombia | https://www.superfinanciera.gov.co/ | Pending official verification |
| Sudan | https://cbos.gov.sd/ | Pending official verification |
| South Sudan | https://boss.gov.ss/ | Pending official verification |
| Zimbabwe | https://www.rbz.co.zw/ | Pending official verification |
| Nigeria | https://sec.gov.ng/ | See verified wave 1; fees pending |
| Ghana | https://www.bog.gov.gh/ | Pending official verification |
| Ethiopia | https://nbe.gov.et/ | Pending official verification |
| Egypt | https://www.cbe.org.eg/ | Pending official verification |
| Malawi | https://www.rbm.mw/ | Pending official verification |
| Sierra Leone | https://bsl.gov.sl/ | Pending official verification |
| Liberia | https://www.cbl.org.lr/ | Pending official verification |
| Angola | https://www.bna.ao/ | Pending official verification |
| Zambia | https://www.boz.zm/ | Pending official verification |
| Mozambique | https://www.bancomoc.mz/ | Pending official verification |
| DR Congo | https://www.bcc.cd/ | Pending official verification |
| Tunisia | https://www.bct.gov.tn/ | Pending official verification |
| Algeria | https://www.bank-of-algeria.dz/ | Pending official verification |
| India | https://fiuindia.gov.in/ | See verified wave 1; fees pending |
| Romania | https://asfromania.ro/ | See verified wave 1; fees pending |

## Approval checklist per country
Identify competent regulator for each KHAN activity; obtain current dated legal text; confirm permitted token rights; determine whether issuer white paper, CASP/VASP, AML, payments/FX, consumer advertising, privacy and tax obligations apply; record **official** contact page, email, physical address, portal, forms and fees; obtain local counsel review; mark launch permitted only after written evidence of required approvals. Do not treat a general enquiry mailbox as a license application route.

## Data extraction
Run `python3 scripts/extract_country_indicators.py` in an internet-enabled environment. The script writes annual WDI CPI, GDP growth, GDP per capita, unemployment, population, remittances and debt observations to `data/country_indicators/`. **No downloaded output is included in this commit; figures remain unverified until executed and checked.**

## Engineering
`contracts/src/KhanToken.sol` is a **testnet-only, unaudited, fixed-supply ERC-20 prototype**. Supply is selected at construction, and no mint function exists. This contract deliberately does not implement 40/30/30 payouts, compliance gating, governance or custody. Test with `cd contracts && forge test -vv`. GitHub Actions CI runs the same suite; no passing run is claimed here.
