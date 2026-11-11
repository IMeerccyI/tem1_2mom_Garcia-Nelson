#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
mkdir -p datasets

zip_file="datasets/superstore.zip"
url="https://www.kaggle.com/api/v1/datasets/download/vivek468/superstore-dataset-final"
curl -fL --retry 2 "$url" -o "$zip_file"
unzip -oq "$zip_file" -d datasets/source
iconv -f CP1252 -t UTF-8 'datasets/source/Sample - Superstore.csv' > datasets/superstore.csv
python3 scripts/validar_csv.py
printf 'CSV listo: %s/datasets/superstore.csv\n' "$project_dir"
