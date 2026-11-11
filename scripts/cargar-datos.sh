#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"

if [[ ! -s datasets/superstore.csv ]]; then
  ./scripts/preparar-datos.sh
fi

printf 'Iniciando Hive y HDFS...\n'
docker compose up -d --wait
printf 'Copiando el CSV a HDFS...\n'
docker cp datasets/superstore.csv tem12m-namenode:/tmp/superstore.csv
docker exec tem12m-namenode hdfs dfs -mkdir -p /tmp
docker exec tem12m-namenode hdfs dfs -put -f /tmp/superstore.csv /tmp/
printf 'Creando y cargando tablas...\n'
docker exec tem12m-hiveserver2 beeline \
  -u 'jdbc:hive2://localhost:10000/default' --silent=true \
  -f /opt/hive/queries/crear-tablas.sql
docker exec tem12m-hiveserver2 beeline \
  -u 'jdbc:hive2://localhost:10000/default' --silent=true \
  -f /opt/hive/queries/cargar-datos.sql
printf 'Filas en tabla ORC:\n'
docker exec tem12m-hiveserver2 beeline \
  -u 'jdbc:hive2://localhost:10000/default' --silent=true --outputformat=table \
  -e 'SELECT COUNT(*) AS registros FROM tem12m_nelson.superstore;' 2>/dev/null
