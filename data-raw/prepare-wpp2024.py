"""Extract the 2023 period life tables from the three pinned UN CSVs.

Run with Python 3.10+ and local originals; no packages or network required.
"""
import argparse
import csv
import gzip
import hashlib
import math
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SEXES = {"Female": ("2", "female"), "Male": ("1", "male"), "Both": ("3", "both")}
MEASURES = ("mx", "qx", "px", "lx", "dx", "Lx", "Tx", "ex", "ax")
OUTPUT = ("location_code", "location", "iso3", "level", "region", "subregion",
          "year", "sex", "x", "age_interval", "age_span", "open_interval", *MEASURES)


def read_csv(path):
    with path.open(encoding="utf-8-sig", newline="") as stream:
        return list(csv.DictReader(stream))


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(2**22), b""):
            digest.update(block)
    return digest.hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source_dir", type=Path)
    parser.add_argument("output_csv", type=Path)
    args = parser.parse_args()
    catalog = read_csv(ROOT / "wpp2024-areas.csv")
    areas = {r["location_code"]: r for r in catalog}
    if len(catalog) != 95 or len(areas) != 95 or sum(r["level"] == "country" for r in catalog) != 67:
        raise ValueError("Unexpected area selection")
    provenance = {r["file"]: r for r in read_csv(ROOT / "provenance.csv")
                  if r["dataset"] == "mortality_regions"}
    results = {}
    for file_sex, (sex_id, sex) in SEXES.items():
        expected_label = {"1": "Male", "2": "Female", "3": "Total"}[sex_id]
        name = f"WPP2024_Life_Table_Complete_Medium_{file_sex}_1950-2023.csv.gz"
        path = args.source_dir / name
        reference = provenance[name]
        if path.stat().st_size != int(reference["bytes"]) or sha256(path) != reference["sha256"]:
            raise ValueError(f"Original does not match provenance: {name}")
        count = 0
        with gzip.open(path, "rt", encoding="utf-8-sig", newline="") as stream:
            reader = csv.reader(stream)
            fields = next(reader)
            ix = {key: fields.index(key) for key in ("LocID", "Time", "Location",
                  "LocTypeName", "ISO3_code", "VarID", "Variant", "SexID", "Sex",
                  "AgeGrp", "AgeGrpStart", "AgeGrpSpan", *MEASURES)}
            for row in reader:
                if row[ix["Time"]] != "2023":
                    continue
                code = row[ix["LocID"]]
                if code not in areas:
                    continue
                area = areas[code]
                observed = tuple(row[ix[k]] for k in ("Location", "LocTypeName", "ISO3_code",
                                                       "VarID", "Variant", "SexID", "Sex"))
                expected = (area["location"], area["source_type"], area["iso3"],
                            "2", "Medium", sex_id, expected_label)
                if observed != expected:
                    raise ValueError((code, observed, expected))
                age = int(row[ix["AgeGrpStart"]])
                interval, span = (row[ix[k]] for k in ("AgeGrp", "AgeGrpSpan"))
                if (not 0 <= age <= 100 or span != ("-1" if age == 100 else "1") or
                        (interval == "100+") != (age == 100)):
                    raise ValueError((code, age, interval, span))
                key = (int(code), sex, age)
                if key in results:
                    raise ValueError(f"Duplicate source row: {key}")
                numeric = tuple(row[ix[k]] for k in MEASURES)
                values = tuple(map(float, numeric))
                if not all(math.isfinite(x) and x >= 0 for x in values) or max(values[1:3]) > 1:
                    raise ValueError((key, numeric))
                results[key] = (code, area["location"], area["iso3"], area["level"],
                                area["region"], area["subregion"], 2023, sex, age,
                                interval, span, "TRUE" if age == 100 else "FALSE", *numeric)
                count += 1
        if count != 9595:
            raise ValueError(f"{name}: expected 9595 observations, got {count}")
        print(f"{name}: {count} observations verified", flush=True)
    expected_keys = {(int(code), sex, age) for code in areas
                     for _, sex in SEXES.values() for age in range(101)}
    if results.keys() != expected_keys:
        raise ValueError("Incomplete area/sex/age coverage")
    with args.output_csv.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.writer(stream, lineterminator="\n")
        writer.writerow(OUTPUT)
        writer.writerows(results[k] for k in sorted(results))


if __name__ == "__main__":
    main()
