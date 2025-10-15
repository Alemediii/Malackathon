# Perfil demográfico con visualizaciones avanzadas

library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)

# Leer datos
datos <- suppressMessages(read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))

# Crear carpeta de salida si no existe
dir.create('nuevo/plots', showWarnings = FALSE, recursive = TRUE)


# 1. Histograma de edad por sexo
datos$sexo <- factor(datos$sexo, levels = c(1,2), labels = c('Hombre','Mujer'))
edad <- as.numeric(datos$edad)
df_edad <- data.frame(edad = edad, sexo = datos$sexo)
df_edad <- df_edad[!is.na(df_edad$edad) & !is.na(df_edad$sexo), ]

png('nuevo/plots/hist_edad_sexo.png', width = 1000, height = 700)
print(
	ggplot(df_edad, aes(x = edad, fill = sexo)) +
		geom_histogram(position = 'identity', alpha = 0.5, bins = 40) +
		facet_wrap(~sexo, ncol = 1) +
		labs(title = 'Distribución de edad por sexo', x = 'Edad', y = 'Frecuencia') +
		theme_minimal()
)
dev.off()

# 1b. Boxplot de edad por sexo
png('nuevo/plots/boxplot_edad_sexo.png', width = 700, height = 700)
print(
	ggplot(df_edad, aes(x = sexo, y = edad, fill = sexo)) +
		geom_boxplot(outlier.colour = 'red', alpha = 0.5) +
		labs(title = 'Boxplot de edad por sexo', x = 'Sexo', y = 'Edad') +
		theme_minimal()
)
dev.off()

# 2. Pirámide poblacional: edad vs sexo
df_piramide <- df_edad %>%
	mutate(grupo_edad = cut(edad, breaks = seq(0, 100, by = 5), right = FALSE, include.lowest = TRUE)) %>%
	group_by(grupo_edad, sexo) %>%
	summarise(n = n(), .groups = 'drop') %>%
	mutate(n = ifelse(sexo == 'Hombre', -n, n))

png('nuevo/plots/piramide_poblacional.png', width = 900, height = 700)
print(
	ggplot(df_piramide, aes(x = grupo_edad, y = n, fill = sexo)) +
		geom_bar(stat = 'identity', width = 0.8) +
		coord_flip() +
		scale_y_continuous(labels = abs) +
		labs(title = 'Pirámide poblacional', x = 'Grupo de edad', y = 'Número de personas') +
		theme_minimal()
)
dev.off()

# 3. Mapa coroplético por Comunidad Autónoma
# Requiere el paquete sf y un shapefile de España con CCAA. Usaremos el paquete mapSpain para obtenerlo.
if (!requireNamespace('mapSpain', quietly = TRUE)) install.packages('mapSpain')
library(mapSpain)
library(sf)

# Obtener geometría de CCAA
ccaa_sf <- esp_get_ccaa()

# Contar pacientes por comunidad
df_ccaa <- datos %>%
	group_by(comunidad_autonoma) %>%
	summarise(Pacientes = n(), .groups = 'drop')

# Unir datos con geometría
ccaa_sf <- ccaa_sf %>%
	left_join(df_ccaa, by = c('ine.ccaa.name' = 'comunidad_autonoma'))

png('nuevo/plots/mapa_ccaa_pacientes.png', width = 900, height = 700)
print(
	ggplot(ccaa_sf) +
		geom_sf(aes(fill = Pacientes), color = 'white') +
		scale_fill_viridis_c(option = 'C', na.value = 'grey90') +
		labs(title = 'Pacientes por Comunidad Autónoma', fill = 'Pacientes') +
		theme_minimal()
)
dev.off()
