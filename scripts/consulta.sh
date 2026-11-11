#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! "$1" =~ ^[1-8]$ ]]; then
  echo "Uso: $0 <consulta del 1 al 8>" >&2
  exit 2
fi

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
sql_file="sql/consulta_${1}.sql"
if [[ ! -s "$sql_file" ]]; then
  echo "No existe $sql_file" >&2
  exit 1
fi
if ! docker inspect --format '{{.State.Health.Status}}' tem12m-hiveserver2 2>/dev/null | rg -q '^healthy$'; then
  echo 'Hive no está listo. Inicie el entorno con: docker compose up -d --wait' >&2
  exit 1
fi
printf 'Consulta %s\n' "$1"
cat "$sql_file"
printf '\nResultado:\n'
docker exec tem12m-hiveserver2 beeline \
  -u 'jdbc:hive2://localhost:10000/default' --silent=true --outputformat=table \
  -f "/opt/hive/queries/$(basename "$sql_file")" 2>/dev/null
