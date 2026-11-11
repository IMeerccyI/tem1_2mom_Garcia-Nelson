WITH anual AS (
  SELECT region,
         YEAR(order_date) AS anio,
         SUM(sales) AS ventas,
         SUM(profit) AS ganancia
  FROM tem12m_nelson.superstore
  WHERE order_date IS NOT NULL
  GROUP BY region, YEAR(order_date)
), cambios AS (
  SELECT *,
         LAG(ventas) OVER (PARTITION BY region ORDER BY anio) AS ventas_anio_anterior,
         LAG(ganancia) OVER (PARTITION BY region ORDER BY anio) AS ganancia_anio_anterior,
         RANK() OVER (PARTITION BY anio ORDER BY ganancia DESC) AS mejor_region,
         RANK() OVER (PARTITION BY anio ORDER BY ganancia ASC) AS peor_region
  FROM anual
)
SELECT region, anio, ROUND(ventas, 2) AS ventas,
       ROUND(ganancia, 2) AS ganancia,
       ROUND(ganancia * 100.0 / ventas, 2) AS margen_pct,
       CASE WHEN ventas_anio_anterior = 0 THEN NULL
            ELSE ROUND((ventas - ventas_anio_anterior) * 100.0 / ventas_anio_anterior, 2) END AS cambio_ventas_pct,
       CASE WHEN ganancia_anio_anterior = 0 THEN NULL
            ELSE ROUND((ganancia - ganancia_anio_anterior) * 100.0 / ganancia_anio_anterior, 2) END AS cambio_ganancia_pct,
       mejor_region, peor_region
FROM cambios
ORDER BY anio, mejor_region;
