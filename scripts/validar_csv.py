#!/usr/bin/env python3
import csv
from pathlib import Path

path = Path(__file__).resolve().parents[1] / "datasets" / "superstore.csv"
expected = 9994
with path.open(encoding="utf-8", newline="") as source:
    reader = csv.DictReader(source)
    rows = list(reader)
    columns = reader.fieldnames or []

print(f"Filas: {len(rows)}")
print(f"Columnas: {len(columns)}")
print(f"Órdenes distintas: {len({r['Order ID'] for r in rows})}")
print(f"Clientes distintos: {len({r['Customer ID'] for r in rows})}")
if len(rows) != expected or len(columns) != 21:
    raise SystemExit("El CSV no tiene la forma esperada.")
if any(None in row for row in rows):
    raise SystemExit("Se encontró una fila con cantidad de campos distinta.")
