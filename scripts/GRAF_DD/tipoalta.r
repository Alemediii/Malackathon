# Diagrama de barras para tipo_alta en filas_nulos_desconocidos.csv

library(readr)
library(ggplot2)

# Leer datos
datos <- suppressMessages(read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))

# Contar frecuencias de tipo_alta
tabla <- as.data.frame(table(datos$tipo_alta))
colnames(tabla) <- c('TipoAlta', 'Frecuencia')

# Graficar diagrama de barras
bar <- ggplot(tabla, aes(x = reorder(TipoAlta, -Frecuencia), y = Frecuencia, fill = TipoAlta)) +
	geom_bar(stat = 'identity') +
	labs(title = 'Número de personas por tipo de alta', x = 'Tipo de alta', y = 'Número de personas') +
	theme_minimal() +
	theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = 'none')

# Guardar gráfico como PNG
output_path <- 'reportes/reporte5/graficas/tipoalta_bar.png'
dir.create(dirname(output_path), showWarnings = FALSE, recursive = TRUE)
png(output_path, width = 900, height = 600)
print(bar)
dev.off()
cat('Gráfico guardado en:', output_path, '\n')
