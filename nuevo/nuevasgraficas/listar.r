# Listar solo los nombres de las variables del CSV
library(readr)
datos <- suppressMessages(read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))
cat(names(datos), sep = '\n')
