# Gráficos extra: riesgo de mortalidad, estancia vs coste, reingresos

library(readr)
library(ggplot2)
library(dplyr)

# Leer datos
datos <- suppressMessages(read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))

# Crear carpeta de salida si no existe
dir.create('nuevo/plots', showWarnings = FALSE, recursive = TRUE)

# 1. Gráfico de densidad de riesgo de mortalidad APR
if ('riesgo_mortalidad_apr' %in% names(datos)) {
	df_riesgo <- datos %>% filter(!is.na(riesgo_mortalidad_apr))
	png('nuevo/plots/densidad_riesgo_mortalidad.png', width = 900, height = 600)
	print(
		ggplot(df_riesgo, aes(x = as.numeric(riesgo_mortalidad_apr))) +
			geom_density(fill = '#56B4E9', alpha = 0.6) +
			labs(title = 'Densidad de riesgo de mortalidad APR', x = 'Riesgo de mortalidad APR', y = 'Densidad') +
			theme_minimal()
	)
	dev.off()
}

# 2. Gráfico de dispersión: estancia vs coste (log transformado)
if (all(c('estancia_dias', 'coste_apr') %in% names(datos))) {
	df_disp <- datos %>%
		mutate(estancia = as.numeric(estancia_dias),
					 coste = suppressWarnings(as.numeric(gsub(',', '.', coste_apr)))) %>%
		filter(!is.na(estancia) & !is.na(coste) & coste > 0)
	png('nuevo/plots/dispersion_estancia_coste_log.png', width = 900, height = 600)
	print(
		ggplot(df_disp, aes(x = estancia, y = log10(coste))) +
			geom_point(alpha = 0.3, color = '#E69F00') +
			geom_smooth(method = 'lm', se = FALSE, color = 'blue') +
			labs(title = 'Estancia vs coste (log10)', x = 'Días de estancia', y = 'Log10(Coste APR)') +
			theme_minimal()
	)
	dev.off()
}

# 3. Gráfico de barras de reingresos (si existe columna reingreso)
if ('reingreso' %in% names(datos)) {
	df_reing <- datos %>% filter(!is.na(reingreso))
	png('nuevo/plots/barras_reingresos.png', width = 700, height = 600)
	print(
		ggplot(df_reing, aes(x = as.factor(reingreso), fill = as.factor(reingreso))) +
			geom_bar() +
			labs(title = 'Frecuencia de reingresos', x = 'Reingreso', y = 'Frecuencia') +
			scale_fill_manual(values = c('#009E73', '#D55E00')) +
			theme_minimal() +
			theme(legend.position = 'none')
	)
	dev.off()
}

# 4. Gráfico de barras de comorbilidad binaria (≥2 diagnósticos)
diag_cols <- grep('^diagnostico(_principal|_\\d+)$', names(datos), value = TRUE)
diagnosticos <- datos[, diag_cols]
num_diag <- apply(diagnosticos, 1, function(x) sum(!is.na(x) & x != ''))
comorb <- ifelse(num_diag >= 2, '≥2 diagnósticos', '1 diagnóstico')
df_comorb <- data.frame(Comorbilidad = comorb)
tabla_comorb <- as.data.frame(table(df_comorb$Comorbilidad))
colnames(tabla_comorb) <- c('Comorbilidad', 'Frecuencia')
tabla_comorb$Porcentaje <- round(tabla_comorb$Frecuencia / sum(tabla_comorb$Frecuencia) * 100, 1)

png('nuevo/plots/barras_comorbilidad_binaria.png', width = 700, height = 600)
print(
	ggplot(tabla_comorb, aes(x = Comorbilidad, y = Frecuencia, fill = Comorbilidad)) +
		geom_bar(stat = 'identity') +
		geom_text(aes(label = paste0(Porcentaje, '%')), vjust = -0.5, size = 6) +
		labs(title = 'Comorbilidad binaria (≥2 diagnósticos)', x = '', y = 'Nº de pacientes') +
		scale_fill_manual(values = c('#56B4E9', '#D55E00')) +
		theme_minimal() +
		theme(legend.position = 'none')
)
dev.off()