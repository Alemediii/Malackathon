# Ejemplo de visualización avanzada de datos faltantes y tipos de variable

# Instalar paquetes si es necesario:
# install.packages('naniar')
# install.packages('ggplot2')
# install.packages('dplyr')

library(naniar)
library(ggplot2)
library(dplyr)

# Leer datos
datos <- suppressMessages(readr::read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))

# Crear carpeta de salida si no existe
dir.create('nuevo/plots', showWarnings = FALSE, recursive = TRUE)


# 1. Mapa de calor de nulos (usando una muestra para archivos grandes)
set.seed(123)
datos_muestra <- dplyr::slice_sample(datos, n = 1000)
png('nuevo/plots/mapa_nulos.png', width = 1200, height = 700)
print(naniar::vis_miss(datos_muestra) + ggtitle('Mapa de calor de nulos (muestra 1000 filas)'))
dev.off()
cat('Mapa de calor de nulos guardado en nuevo/plots/mapa_nulos.png\n')

# 2. Gráfico de barras de frecuencia por tipo de variable
tipos <- sapply(datos, function(x) {
	if (inherits(x, c('numeric', 'integer'))) {
		'Numérica'
	} else if (inherits(x, c('Date', 'POSIXct', 'POSIXt'))) {
		'Fecha'
	} else {
		'Categórica'
	}
})

tabla_tipos <- as.data.frame(table(Tipo = tipos))

png('nuevo/plots/frecuencia_tipos.png', width = 900, height = 600)
print(ggplot(tabla_tipos, aes(x = Tipo, y = Freq, fill = Tipo)) +
				geom_bar(stat = 'identity') +
				labs(title = 'Frecuencia por tipo de variable', x = 'Tipo de variable', y = 'Cantidad') +
				theme_minimal() +
				theme(legend.position = 'none'))
dev.off()
cat('Gráfico de frecuencia de tipos guardado en nuevo/plots/frecuencia_tipos.png\n')

# 3. Gráfico de barras: porcentaje de nulos por variable
porc_nulos <- sapply(datos, function(x) sum(is.na(x)) / length(x) * 100)
df_nulos <- data.frame(Variable = names(porc_nulos), Porcentaje = porc_nulos)
df_nulos <- df_nulos[order(-df_nulos$Porcentaje), ]

png('nuevo/plots/porcentaje_nulos.png', width = 1400, height = 600)
print(ggplot2::ggplot(df_nulos, ggplot2::aes(x = reorder(Variable, -Porcentaje), y = Porcentaje)) +
	ggplot2::geom_bar(stat = 'identity', fill = '#E69F00') +
	ggplot2::labs(title = 'Porcentaje de nulos por variable', x = 'Variable', y = '% de nulos') +
	ggplot2::theme_minimal() +
	ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1)))
dev.off()
cat('Gráfico de porcentaje de nulos guardado en nuevo/plots/porcentaje_nulos.png\n')