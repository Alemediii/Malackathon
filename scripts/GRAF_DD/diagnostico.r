# Diagrama de sectores para diagnostico_principal en filas_nulos_desconocidos.csv

library(readr)
library(ggplot2)

# Leer datos
datos <- suppressMessages(read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))

# Contar frecuencias de diagnostico_principal
tabla <- as.data.frame(table(datos$diagnostico_principal))
colnames(tabla) <- c('Diagnostico', 'Frecuencia')
tabla <- tabla[tabla$Diagnostico != '' & !is.na(tabla$Diagnostico), ]
tabla$Porcentaje <- round(tabla$Frecuencia / sum(tabla$Frecuencia) * 100, 2)

# Graficar diagrama de sectores
pie <- ggplot(tabla, aes(x = '', y = Porcentaje, fill = Diagnostico)) +
	geom_bar(stat = 'identity', width = 1) +
	coord_polar('y', start = 0) +
	theme_void() +
	labs(title = 'Porcentaje de personas por diagnóstico principal')

# Guardar gráfico como PNG
output_path <- 'reportes/reporte5/graficas/diagnostico_pie.png'
dir.create(dirname(output_path), showWarnings = FALSE, recursive = TRUE)
png(output_path, width = 900, height = 600)
print(pie)
dev.off()
cat('Gráfico guardado en:', output_path, '\n')
