# Resultados

Se analizaron las 9.994 filas del conjunto Sample Superstore indicado en la consigna. El CSV se cargó en una tabla staging y luego en una tabla ORC para las consultas.

## 1. Estructura de los datos

El diccionario contiene los 21 campos del archivo, su tipo Hive y su uso. La tabla analítica convierte fechas y valores numéricos; conserva `postal_code` como texto.

## 2. Calidad

Hive encontró 9.994 filas, 5.009 órdenes y 793 clientes. No se detectaron `Row ID` repetidos, campos vacíos, fechas inválidas, ventas no positivas, descuentos fuera de 0–1 ni envíos anteriores a la compra.

## 3. Ventas por región y año

En 2017, West lideró con ventas de 250.128,37 y ganancias de 43.808,96; su margen fue 17,51 %. Central tuvo la menor ganancia regional: 7.550,84. West aumentó sus ventas 33,42 % frente a 2016.

## 4. Clientes RFM

La segmentación obtuvo 103 clientes de alto valor, 70 recurrentes, 316 en riesgo y 304 en otros. La recencia se calculó desde la última fecha disponible en el conjunto.

## 5. Productos

El producto con mayor ganancia fue la copiadora Canon imageCLASS 2200, con 25.199,93. También se observan productos con ganancia negativa, por lo que el volumen de ventas por sí solo no indica rentabilidad.

## 6. Descuentos

De los 856 registros con descuentos mayores al 50 %, todos tuvieron pérdida. En el rango medio (más de 20 % hasta 50 %), 492 de 537 registros fueron no rentables (91,62 %). Los 4.798 registros sin descuento no tuvieron pérdida. Esto muestra una asociación en estos datos; no demuestra que el descuento sea la única causa.

## 7. Tendencia mensual

El mes con más ventas fue noviembre de 2017 (118.447,83); el de menos ventas fue febrero de 2014 (4.519,89). La consulta calcula también cambio mensual, comparación interanual y promedio móvil de tres meses.

## 8. Pareto

Para llegar al 80 % acumulado se necesitaron 414 de 1.862 productos en ventas (80,04 %) y 164 de 1.862 en ganancias (80,03 %). La concentración de ganancias fue mayor que la de ventas.

## Conclusión

Hive permitió cargar, transformar y consultar el dataset con agregaciones y funciones de ventana. ORC se usó para la tabla analítica; el CSV quedó como staging para conservar la fuente de carga.
