-- Cantidad de clientes en cada segmento RFM
WITH fecha_ref AS (
  SELECT MAX(order_date) AS max_fecha FROM tem12m_nelson.superstore
), base AS (
  SELECT s.customer_id,
         DATEDIFF(f.max_fecha, MAX(s.order_date)) AS recency_dias,
         COUNT(DISTINCT s.order_id) AS frequency_ordenes,
         SUM(s.sales) AS monetary_ventas
  FROM tem12m_nelson.superstore s CROSS JOIN fecha_ref f
  GROUP BY s.customer_id, f.max_fecha
), grupos AS (
  SELECT *,
         6 - NTILE(5) OVER (ORDER BY recency_dias ASC, customer_id) AS r_score,
         6 - NTILE(5) OVER (ORDER BY frequency_ordenes DESC, customer_id) AS f_score,
         6 - NTILE(5) OVER (ORDER BY monetary_ventas DESC, customer_id) AS m_score
  FROM base
), segmentos AS (
  SELECT *,
    CASE WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Alto valor'
         WHEN r_score >= 4 AND f_score >= 4 THEN 'Recurrente'
         WHEN r_score <= 2 THEN 'En riesgo'
         ELSE 'Otros' END AS segmento
  FROM grupos
)
SELECT segmento, COUNT(*) AS clientes
FROM segmentos
GROUP BY segmento
ORDER BY segmento;

WITH fecha_ref AS (
  SELECT MAX(order_date) AS max_fecha FROM tem12m_nelson.superstore
), base AS (
  SELECT s.customer_id,
         DATEDIFF(f.max_fecha, MAX(s.order_date)) AS recency_dias,
         COUNT(DISTINCT s.order_id) AS frequency_ordenes,
         SUM(s.sales) AS monetary_ventas
  FROM tem12m_nelson.superstore s CROSS JOIN fecha_ref f
  GROUP BY s.customer_id, f.max_fecha
), grupos AS (
  SELECT *,
         6 - NTILE(5) OVER (ORDER BY recency_dias ASC, customer_id) AS r_score,
         6 - NTILE(5) OVER (ORDER BY frequency_ordenes DESC, customer_id) AS f_score,
         6 - NTILE(5) OVER (ORDER BY monetary_ventas DESC, customer_id) AS m_score
  FROM base
), segmentos AS (
  SELECT *,
    CASE WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Alto valor'
         WHEN r_score >= 4 AND f_score >= 4 THEN 'Recurrente'
         WHEN r_score <= 2 THEN 'En riesgo'
         ELSE 'Otros' END AS segmento
  FROM grupos
), ejemplos AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY segmento ORDER BY monetary_ventas DESC) AS n
  FROM segmentos
)
SELECT customer_id, recency_dias, frequency_ordenes, ROUND(monetary_ventas, 2) AS monetary,
       r_score, f_score, m_score, segmento
FROM ejemplos
WHERE n <= 5
ORDER BY segmento, n;
