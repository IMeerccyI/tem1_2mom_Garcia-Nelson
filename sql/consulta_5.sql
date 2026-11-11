WITH productos AS (
  SELECT category, sub_category, product_id, product_name,
         SUM(sales) AS ventas,
         SUM(profit) AS ganancia,
         SUM(quantity) AS unidades,
         CASE WHEN SUM(sales) = 0 THEN NULL
              ELSE SUM(profit) * 100.0 / SUM(sales) END AS margen_pct
  FROM tem12m_nelson.superstore
  GROUP BY category, sub_category, product_id, product_name
), ranking AS (
  SELECT *,
         RANK() OVER (PARTITION BY category ORDER BY ganancia DESC) AS rank_ganancia_categoria,
         DENSE_RANK() OVER (ORDER BY unidades DESC) AS rank_unidades,
         RANK() OVER (ORDER BY margen_pct ASC) AS rank_margen_bajo,
         SUM(ganancia) OVER (
           PARTITION BY category ORDER BY ganancia DESC, product_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
         ) AS ganancia_acumulada_categoria
  FROM productos
)
SELECT category, sub_category, product_id, product_name,
       ROUND(ventas, 2) AS ventas, ROUND(ganancia, 2) AS ganancia,
       unidades, ROUND(margen_pct, 2) AS margen_pct,
       rank_ganancia_categoria, rank_unidades, rank_margen_bajo,
       ROUND(ganancia_acumulada_categoria, 2) AS ganancia_acumulada_categoria
FROM ranking
WHERE rank_ganancia_categoria <= 5 OR rank_unidades <= 5 OR rank_margen_bajo <= 5
ORDER BY category, rank_ganancia_categoria, rank_unidades;
