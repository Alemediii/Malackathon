# Script para calcular medidas de dispersión de columnas numéricas
# Lee el archivo filas_nulos_desconocidos.csv y guarda resultados en TXT

library(readr)
library(dplyr)

# Ruta de entrada y salida (ajustada al working directory actual)
input_file <- 'reportes/reporte4/filas_nulos_desconocidos.csv'
output_dir <- 'reportes/reporte5/dispersion/'
output_file <- paste0(output_dir, 'medidas_dispersion.txt')

# Leer datos
datos <- suppressMessages(read_csv(input_file, show_col_types = FALSE, progress = FALSE))

# Seleccionar solo columnas numéricas
datos_num <- datos %>% select(where(is.numeric))

# Calcular medidas de dispersión para cada columna numérica
resultados <- lapply(names(datos_num), function(col) {
	x <- datos_num[[col]]
	x <- x[!is.na(x)]
	if (length(x) == 0) return(NULL)
	desv <- sd(x)
	rango <- range(x)
	percentiles <- quantile(x, probs = c(0.25, 0.5, 0.75, 0.9, 0.95, 0.99))
	res <- paste0(
		'Columna: ', col, '\n',
		'  Desviación estándar: ', round(desv, 3), '\n',
		'  Rango: [', rango[1], ', ', rango[2], ']\n',
		'  Percentiles:\n',
		'    P25: ', percentiles[1], '\n',
		'    P50 (mediana): ', percentiles[2], '\n',
		'    P75: ', percentiles[3], '\n',
		'    P90: ', percentiles[4], '\n',
		'    P95: ', percentiles[5], '\n',
		'    P99: ', percentiles[6], '\n'
	)
	return(res)
})

# Guardar resultados en archivo TXT
writeLines(unlist(resultados), output_file)
