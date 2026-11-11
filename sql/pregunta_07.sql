WITH mensual AS (
  SELECT DATE_FORMAT(order_date, 'yyyy-MM') AS mes,
         SUM(sales) AS ventas,
         SUM(profit) AS ganancia
  FROM tem12m_nelson.superstore
  WHERE order_date IS NOT NULL
  GROUP BY DATE_FORMAT(order_date, 'yyyy-MM')
), tendencia AS (
  SELECT *,
         LAG(ventas, 1) OVER (ORDER BY mes) AS ventas_mes_anterior,
         LAG(ventas, 12) OVER (ORDER BY mes) AS ventas_mismo_mes_anio_anterior,
         AVG(ventas) OVER (ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS promedio_movil_3m,
         ROW_NUMBER() OVER (ORDER BY ventas DESC) AS top_mes,
         ROW_NUMBER() OVER (ORDER BY ventas ASC) AS menor_mes
  FROM mensual
)
SELECT mes, ROUND(ventas, 2) AS ventas, ROUND(ganancia, 2) AS ganancia,
       CASE WHEN ventas_mes_anterior IS NULL OR ventas_mes_anterior = 0 THEN NULL
            ELSE ROUND((ventas - ventas_mes_anterior) * 100.0 / ventas_mes_anterior, 2) END AS cambio_mes_pct,
       CASE WHEN ventas_mismo_mes_anio_anterior IS NULL OR ventas_mismo_mes_anio_anterior = 0 THEN NULL
            ELSE ROUND((ventas - ventas_mismo_mes_anio_anterior) * 100.0 / ventas_mismo_mes_anio_anterior, 2) END AS cambio_anual_pct,
       ROUND(promedio_movil_3m, 2) AS promedio_movil_3m,
       top_mes, menor_mes
FROM tendencia
ORDER BY mes;
