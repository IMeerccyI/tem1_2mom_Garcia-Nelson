WITH clasificados AS (
  SELECT category, sub_category, sales, profit, discount,
         CASE WHEN discount = 0 THEN 'Sin descuento'
              WHEN discount <= 0.20 THEN 'Bajo'
              WHEN discount <= 0.50 THEN 'Medio'
              ELSE 'Alto' END AS rango_descuento
  FROM tem12m_nelson.superstore
)
SELECT rango_descuento, category, sub_category,
       ROUND(SUM(sales), 2) AS ventas,
       ROUND(SUM(profit), 2) AS ganancia,
       ROUND(SUM(profit) * 100.0 / SUM(sales), 2) AS margen_pct,
       COUNT(CASE WHEN profit < 0 THEN 1 END) AS registros_con_perdida,
       ROUND(COUNT(CASE WHEN profit < 0 THEN 1 END) * 100.0 / COUNT(*), 2) AS no_rentables_pct,
       ROUND(AVG(discount) * 100.0, 2) AS descuento_promedio_pct
FROM clasificados
GROUP BY rango_descuento, category, sub_category
ORDER BY rango_descuento, no_rentables_pct DESC;

-- Comparación directa de pérdidas por rango de descuento
WITH clasificados AS (
  SELECT sales, profit, discount,
         CASE WHEN discount = 0 THEN 'Sin descuento'
              WHEN discount <= 0.20 THEN 'Bajo'
              WHEN discount <= 0.50 THEN 'Medio'
              ELSE 'Alto' END AS rango_descuento
  FROM tem12m_nelson.superstore
)
SELECT rango_descuento, COUNT(*) AS registros,
       COUNT(CASE WHEN profit < 0 THEN 1 END) AS registros_con_perdida,
       ROUND(COUNT(CASE WHEN profit < 0 THEN 1 END) * 100.0 / COUNT(*), 2) AS no_rentables_pct,
       ROUND(AVG(discount) * 100.0, 2) AS descuento_promedio_pct
FROM clasificados
GROUP BY rango_descuento
ORDER BY no_rentables_pct;
