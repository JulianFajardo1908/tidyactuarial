"""Extract the licensed tables from pinned Europe PMC full-text XML files."""
import argparse
import csv
import hashlib
import math
import re
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parent
TABLES = [
    ("PMC9989186.xml", "T3", "montoya2023_us_dog", "dog", "United States", 18),
    ("PMC9989186.xml", "T4", "montoya2023_us_cat", "cat", "United States", 18),
    ("PMC9050668.xml", "Tab2", "teng2022_uk_dog", "dog", "United Kingdom", 21),
]
COLS = ("table_id", "species", "country", "x", "age_interval", "open_interval",
        "n_deaths", "n_midyear", "mx", "qx", "ax", "lx", "Lx", "Tx", "ex",
        "ex_ci_low", "ex_ci_high")
NUM = re.compile(r"\d+(?:\.\d+)?")


def clean(text):
    return text.replace(",", "").strip()


def extract(root, table, table_id, species, country, size):
    rows = root.findall(f".//table-wrap[@id='{table}']//tbody/tr")
    if len(rows) != size:
        raise ValueError(f"Unexpected row count for {table_id}")
    out = []
    for x, row in enumerate(rows):
        cells = [clean("".join(c.itertext())) for c in row]
        interval = cells[0].replace("\u2013", "-").replace("\xa0", " ")
        open_interval = x == size - 1
        if open_interval:
            if interval not in (f"{x}+", f"{x} and over"):
                raise ValueError((table_id, interval))
        elif interval != f"{x}-{x+1}":
            raise ValueError((table_id, interval))
        if country == "United States":
            _, midyear, deaths, mx, qx, lx, lx_years, tx, ex, ci = cells
            ax = ""
            low, high = NUM.findall(ci)
        else:
            _, deaths, lx, qx, ax, lx_years, tx, ci = cells
            midyear = mx = ""
            ex, low, high = NUM.findall(ci)
        nums = (deaths, midyear, mx, qx, ax, lx, lx_years, tx, ex, low, high)
        if any(not math.isfinite(float(v)) or float(v) < 0 for v in nums if v):
            raise ValueError((table_id, interval, nums))
        if not 0 <= float(qx) <= 1 or not float(low) <= float(ex) <= float(high):
            raise ValueError((table_id, interval, qx, ex))
        out.append((table_id, species, country, x, interval, str(open_interval).upper(), *nums))
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source_dir", type=Path)
    parser.add_argument("output_csv", type=Path)
    args = parser.parse_args()
    with (ROOT / "provenance.csv").open(encoding="utf-8-sig", newline="") as f:
        provenance = {r["file"]: r for r in csv.DictReader(f) if r["dataset"] == "pet_lifetables"}
    sources = {}
    for name in {t[0] for t in TABLES}:
        original = (args.source_dir / name).read_bytes()
        if len(original) != int(provenance[name]["bytes"]) or (
                hashlib.sha256(original).hexdigest() != provenance[name]["sha256"]):
            raise ValueError(f"Source changed: {name}")
        sources[name] = ET.fromstring(original)
    result = []
    for filename, *spec in TABLES:
        result.extend(extract(sources[filename], *spec))
    with args.output_csv.open("w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f, lineterminator="\n")
        writer.writerow(COLS)
        writer.writerows(result)


if __name__ == "__main__":
    main()
