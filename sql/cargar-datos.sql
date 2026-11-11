LOAD DATA INPATH '/tmp/superstore.csv'
OVERWRITE INTO TABLE tem12m_nelson.superstore_staging;

INSERT OVERWRITE TABLE tem12m_nelson.superstore
SELECT
  CAST(TRIM(row_id) AS INT),
  TRIM(order_id),
  CAST(FROM_UNIXTIME(UNIX_TIMESTAMP(TRIM(order_date), 'M/d/yyyy')) AS DATE),
  CAST(FROM_UNIXTIME(UNIX_TIMESTAMP(TRIM(ship_date), 'M/d/yyyy')) AS DATE),
  TRIM(ship_mode),
  TRIM(customer_id),
  TRIM(customer_name),
  TRIM(segment),
  TRIM(country),
  TRIM(city),
  TRIM(state),
  CASE WHEN TRIM(postal_code) = '' THEN NULL ELSE TRIM(postal_code) END,
  TRIM(region),
  TRIM(product_id),
  TRIM(category),
  TRIM(sub_category),
  TRIM(product_name),
  CAST(TRIM(sales) AS DOUBLE),
  CAST(TRIM(quantity) AS INT),
  CAST(TRIM(discount) AS DOUBLE),
  CAST(TRIM(profit) AS DOUBLE)
FROM tem12m_nelson.superstore_staging;
