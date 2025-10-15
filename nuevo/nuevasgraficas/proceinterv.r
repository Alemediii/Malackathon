# Procedimientos e intervenciones

library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)

# Leer datos
datos <- suppressMessages(read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))

# Crear carpeta de salida si no existe
dir.create('nuevo/plots', showWarnings = FALSE, recursive = TRUE)

# 1. Gráfico de barras de procedimientos más frecuentes
proc_cols <- grep('^procedimiento_\\d+$', names(datos), value = TRUE)
procedimientos <- datos[, proc_cols]
procedimientos_long <- procedimientos %>%
	pivot_longer(everything(), names_to = 'tipo', values_to = 'procedimiento') %>%
	filter(!is.na(procedimiento) & procedimiento != '')
top_proc <- procedimientos_long %>%
	group_by(procedimiento) %>%
	summarise(Frecuencia = n(), .groups = 'drop') %>%
	arrange(desc(Frecuencia)) %>%
	head(20)

png('nuevo/plots/top20_procedimientos.png', width = 1200, height = 600)
print(
	ggplot(top_proc, aes(x = reorder(procedimiento, Frecuencia), y = Frecuencia)) +
		geom_bar(stat = 'identity', fill = '#009E73') +
		coord_flip() +
		labs(title = 'Top 20 procedimientos más frecuentes', x = 'Procedimiento', y = 'Frecuencia') +
		theme_minimal()
)
dev.off()

# 2. Gráfico de dispersión: número de procedimientos vs estancia
num_proc <- apply(procedimientos, 1, function(x) sum(!is.na(x) & x != ''))
estancia <- as.numeric(datos$estancia_dias)
df_disp <- data.frame(num_proc = num_proc, estancia = estancia)
df_disp <- df_disp[!is.na(df_disp$estancia), ]

png('nuevo/plots/dispersion_proc_estancia.png', width = 900, height = 600)
print(
	ggplot(df_disp, aes(x = num_proc, y = estancia)) +
		geom_jitter(width = 0.2, height = 0, alpha = 0.3, color = '#D55E00') +
		geom_smooth(method = 'lm', se = FALSE, color = 'blue') +
		labs(title = 'Nº de procedimientos vs días de estancia', x = 'Nº de procedimientos', y = 'Días de estancia') +
		theme_minimal()
)
dev.off()

# 3. Serie temporal de intervenciones: por mes
# 3. Diagrama de sectores: porcentaje de ingresos por estación del año
if ('fecha_de_intervencion' %in% names(datos)) {
	fechas_str <- substr(datos$fecha_de_intervencion, 1, 8)
	fechas_validas <- as.Date(fechas_str, format = '%d%m%Y')
	fechas_validas <- fechas_validas[!is.na(fechas_validas)]
	if (length(fechas_validas) > 0) {
		df_fechas <- data.frame(fecha = fechas_validas)
		# Función para obtener estación del año
		get_season <- function(date) {
			m <- as.integer(format(date, '%m'))
			d <- as.integer(format(date, '%d'))
			ifelse((m == 12 & d >= 21) | (m %in% c(1,2)) | (m == 3 & d < 21), 'Invierno',
			ifelse((m == 3 & d >= 21) | (m %in% c(4,5)) | (m == 6 & d < 21), 'Primavera',
			ifelse((m == 6 & d >= 21) | (m %in% c(7,8)) | (m == 9 & d < 23), 'Verano',
			'Otoño')))
		}
		df_fechas$estacion <- get_season(df_fechas$fecha)
		estaciones <- df_fechas %>% group_by(estacion) %>% summarise(Ingresos = n(), .groups = 'drop')
		estaciones$Porcentaje <- round(estaciones$Ingresos / sum(estaciones$Ingresos) * 100, 2)
		png('nuevo/plots/ingresos_por_estacion.png', width = 800, height = 600)
		print(
			ggplot(estaciones, aes(x = '', y = Porcentaje, fill = estacion)) +
				geom_bar(stat = 'identity', width = 1) +
				coord_polar('y', start = 0) +
				theme_void() +
				labs(title = 'Porcentaje de ingresos por estación del año', fill = 'Estación') +
				geom_text(aes(label = paste0(Porcentaje, '%')), position = position_stack(vjust = 0.5))
		)
		dev.off()
	}
}
