# Histograma de la duración de los días de estancia

library(readr)
library(ggplot2)

# Leer datos
datos <- suppressMessages(read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))

# Extraer columna de días de estancia (asegurar que es numérica)
estancia <- as.numeric(datos$estancia_dias)
estancia <- estancia[!is.na(estancia)]


# Calcular percentil 99 para limitar el eje x
p99 <- quantile(estancia, 0.99, na.rm = TRUE)

# Graficar histograma centrado en valores medios
hist_plot <- ggplot(data.frame(estancia), aes(x = estancia)) +
	geom_histogram(binwidth = 1, fill = '#0073C2FF', color = 'black', boundary = 0) +
	labs(title = 'Histograma de días de estancia (hasta P99)', x = 'Días de estancia', y = 'Frecuencia') +
	xlim(0, p99) +
	theme_minimal()

# Guardar gráfico como PNG
output_path <- 'reportes/reporte5/graficas/estanciadias_hist.png'
dir.create(dirname(output_path), showWarnings = FALSE, recursive = TRUE)
png(output_path, width = 900, height = 600)
print(hist_plot)
dev.off()
cat('Gráfico guardado en:', output_path, '\n')
