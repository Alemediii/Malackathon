# Diagrama de sectores para comunidad_autonoma en filas_nulos_desconocidos.csv

library(readr)
library(ggplot2)

# Leer datos
datos <- suppressMessages(read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))

# Contar frecuencias de comunidad_autonoma
tabla <- as.data.frame(table(datos$comunidad_autonoma))
colnames(tabla) <- c('Comunidad', 'Frecuencia')

# Graficar diagrama de sectores
pie <- ggplot(tabla, aes(x = '', y = Frecuencia, fill = Comunidad)) +
  geom_bar(stat = 'identity', width = 1) +
  coord_polar('y', start = 0) +
  theme_void() +
  labs(title = 'Distribución por Comunidad Autónoma')



# Guardar gráfico como PNG para verlo en VS Code
output_path <- 'reportes/reporte5/dispersion/ccaa_pie.png'
dir.create(dirname(output_path), showWarnings = FALSE, recursive = TRUE)
png(output_path, width = 800, height = 600)
print(pie)
dev.off()
cat('Gráfico guardado en:', output_path, '\n')

# (Opcional) Mostrar advertencia si hay problemas de parsing
probs <- suppressWarnings(problems(datos))
if (nrow(probs) > 0) {
  warning('Problemas de parsing detectados en el archivo CSV. Revise los datos si es necesario.')
}
