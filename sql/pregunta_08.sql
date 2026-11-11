-- Resumen del Pareto de ventas: productos necesarios para llegar al 80 %
WITH productos AS (
  SELECT product_id, SUM(sales) AS monto
  FROM tem12m_nelson.superstore
  GROUP BY product_id
), acumulado AS (
  SELECT product_id, monto,
         ROW_NUMBER() OVER (ORDER BY monto DESC, product_id) AS posicion,
         SUM(monto) OVER (ORDER BY monto DESC, product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS acumulado,
         SUM(monto) OVER () AS total_general
  FROM productos
), limite AS (
  SELECT MIN(CASE WHEN acumulado >= total_general * 0.80 THEN posicion END) AS productos_80
  FROM acumulado
)
SELECT 'Ventas' AS indicador,
       COUNT(*) AS productos_totales,
       ROUND(MAX(a.total_general), 2) AS total,
       MAX(l.productos_80) AS productos_para_80_pct,
       ROUND(MAX(CASE WHEN a.posicion = l.productos_80 THEN a.acumulado END) * 100.0 / MAX(a.total_general), 2) AS acumulado_pct
FROM acumulado a CROSS JOIN limite l;

-- Resumen del Pareto de ganancias
WITH productos AS (
  SELECT product_id, SUM(profit) AS monto
  FROM tem12m_nelson.superstore
  GROUP BY product_id
), acumulado AS (
  SELECT product_id, monto,
         ROW_NUMBER() OVER (ORDER BY monto DESC, product_id) AS posicion,
         SUM(monto) OVER (ORDER BY monto DESC, product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS acumulado,
         SUM(monto) OVER () AS total_general
  FROM productos
), limite AS (
  SELECT MIN(CASE WHEN acumulado >= total_general * 0.80 THEN posicion END) AS productos_80
  FROM acumulado
)
SELECT 'Ganancias' AS indicador,
       COUNT(*) AS productos_totales,
       ROUND(MAX(a.total_general), 2) AS total,
       MAX(l.productos_80) AS productos_para_80_pct,
       ROUND(MAX(CASE WHEN a.posicion = l.productos_80 THEN a.acumulado END) * 100.0 / MAX(a.total_general), 2) AS acumulado_pct
FROM acumulado a CROSS JOIN limite l;

-- Cinco productos con mayor aporte por ventas
WITH productos AS (
  SELECT product_id, MAX(product_name) AS product_name, SUM(sales) AS monto
  FROM tem12m_nelson.superstore
  GROUP BY product_id
), ranking AS (
  SELECT product_id, product_name, monto,
         ROW_NUMBER() OVER (ORDER BY monto DESC, product_id) AS posicion,
         SUM(monto) OVER () AS total_general
  FROM productos
)
SELECT product_id, product_name, ROUND(monto, 2) AS ventas, posicion,
       ROUND(monto * 100.0 / total_general, 2) AS aporte_pct
FROM ranking
WHERE posicion <= 5
ORDER BY posicion;

-- Cinco productos con mayor aporte por ganancias
WITH productos AS (
  SELECT product_id, MAX(product_name) AS product_name, SUM(profit) AS monto
  FROM tem12m_nelson.superstore
  GROUP BY product_id
), ranking AS (
  SELECT product_id, product_name, monto,
         ROW_NUMBER() OVER (ORDER BY monto DESC, product_id) AS posicion,
         SUM(monto) OVER () AS total_general
  FROM productos
)
SELECT product_id, product_name, ROUND(monto, 2) AS ganancias, posicion,
       ROUND(monto * 100.0 / total_general, 2) AS aporte_pct
FROM ranking
WHERE posicion <= 5
ORDER BY posicion;
