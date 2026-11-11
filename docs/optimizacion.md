# Optimización

La tabla de consulta usa ORC, que almacena columnas en formato binario y resulta práctico para las sumas, filtros y agrupaciones del examen. No particioné la tabla porque el archivo tiene 9.994 filas; para este tamaño, mantener particiones agrega trabajo sin una mejora clara. La tabla staging conserva el CSV para la carga y auditoría.
