#!/usr/bin/env python3
"""Download comparable annual World Bank WDI series for KHAN research.
Standard-library only. Fails loudly if data are unreachable; never substitutes estimates.
Usage: python3 scripts/extract_country_indicators.py
"""
import csv
import json
from datetime import datetime, timezone
from pathlib import Path
from urllib.request import urlopen
from urllib.parse import quote

COUNTRIES = {
"ARG":"Argentina","VEN":"Venezuela","BOL":"Bolivia","CUB":"Cuba","HTI":"Haiti",
"BRA":"Brazil","COL":"Colombia","SDN":"Sudan","SSD":"South Sudan",
"ZWE":"Zimbabwe","NGA":"Nigeria","GHA":"Ghana","ETH":"Ethiopia",
"EGY":"Egypt","MWI":"Malawi","SLE":"Sierra Leone","LBR":"Liberia",
"AGO":"Angola","ZMB":"Zambia","MOZ":"Mozambique","COD":"DR Congo",
"TUN":"Tunisia","DZA":"Algeria"}
INDICATORS = {
"FP.CPI.TOTL.ZG":"cpi_annual_pct",
"NY.GDP.MKTP.KD.ZG":"real_gdp_growth_pct",
"NY.GDP.PCAP.CD":"gdp_per_capita_current_usd",
"SL.UEM.TOTL.ZS":"unemployment_pct",
"SP.POP.TOTL":"population",
"BX.TRF.PWKR.DT.GD.ZS":"remittances_pct_gdp",
"GC.DOD.TOTL.GD.ZS":"central_government_debt_pct_gdp",
}
OUT = Path("data/country_indicators")
def fetch(code):
    url = ("https://api.worldbank.org/v2/country/"
           + quote(";".join(COUNTRIES), safe=";")
           + "/indicator/" + code
           + "?format=json&date=2020:2026&per_page=2000")
    with urlopen(url, timeout=35) as r:
        result=json.load(r)
    if not isinstance(result,list) or len(result)<2 or not isinstance(result[1],list):
        raise RuntimeError("Unexpected World Bank API response for "+code)
    return url,result[1]
def main():
    OUT.mkdir(parents=True,exist_ok=True)
    values={}
    sources={}
    for code,field in INDICATORS.items():
        url,observations=fetch(code)
        sources[field]=url
        for item in observations:
            iso=item.get("countryiso3code")
            year=item.get("date")
            if iso in COUNTRIES and year and year.isdigit():
                values[(iso,int(year),field)]=item.get("value")
    fields=["iso3","country","year"]+list(INDICATORS.values())
    rows=[]
    for iso,name in COUNTRIES.items():
        for year in range(2020,2027):
            row={"iso3":iso,"country":name,"year":year}
            for field in INDICATORS.values():
                row[field]=values.get((iso,year,field))
            rows.append(row)
    with (OUT/"wdi_2020_2026.csv").open("w",newline="",encoding="utf-8") as f:
        writer=csv.DictWriter(f,fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)
    meta={"retrieved_utc":datetime.now(timezone.utc).isoformat(),
          "source":"World Bank WDI API v2","indicator_urls":sources,
          "missing_values":"blank; never imputed",
          "notes":"Annual WDI observations; 2026 may be absent. IMF forecasts are separate."}
    (OUT/"metadata.json").write_text(json.dumps(meta,indent=2)+"\n",encoding="utf-8")
    print("Wrote",len(rows),"country-year rows to",OUT)
if __name__=="__main__":
    main()
