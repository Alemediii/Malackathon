# Diagnósticos y comorbilidades

library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)
library(reshape2)

# Leer datos
datos <- suppressMessages(read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))

# Crear carpeta de salida si no existe
dir.create('nuevo/plots', showWarnings = FALSE, recursive = TRUE)

# 1. Top 20 diagnósticos principales
tabla_diag <- as.data.frame(table(datos$diagnostico_principal))
colnames(tabla_diag) <- c('Diagnostico', 'Frecuencia')
tabla_diag <- tabla_diag[tabla_diag$Diagnostico != '' & !is.na(tabla_diag$Diagnostico), ]
top20 <- tabla_diag %>% arrange(desc(Frecuencia)) %>% head(20)

png('nuevo/plots/top20_diagnosticos.png', width = 1200, height = 600)
print(
	ggplot(top20, aes(x = reorder(Diagnostico, Frecuencia), y = Frecuencia)) +
		geom_bar(stat = 'identity', fill = '#0073C2FF') +
		coord_flip() +
		labs(title = 'Top 20 diagnósticos principales', x = 'Diagnóstico', y = 'Frecuencia') +
		theme_minimal()
)
dev.off()

# 2. Heatmap de co-ocurrencia de diagnósticos (matriz de comorbilidad)
# Seleccionar columnas de diagnósticos (diagnostico_principal y diagnostico_2:diagnostico_20)
diag_cols <- grep('^diagnostico(_principal|_\\d+)$', names(datos), value = TRUE)
diagnosticos <- datos[, diag_cols]

# Convertir a matriz binaria de presencia/ausencia por paciente y diagnóstico
diagnosticos_long <- diagnosticos %>%
	mutate(id_paciente = row_number()) %>%
	pivot_longer(-id_paciente, names_to = 'tipo', values_to = 'diagnostico') %>%
	filter(!is.na(diagnostico) & diagnostico != '')

matriz_binaria <- table(diagnosticos_long$id_paciente, diagnosticos_long$diagnostico)
matriz_comorb <- t(matriz_binaria) %*% matriz_binaria

# Para el heatmap, mostrar solo los 20 diagnósticos más frecuentes
top_diag <- names(sort(colSums(matriz_binaria), decreasing = TRUE)[1:20])
matriz_comorb_top <- matriz_comorb[top_diag, top_diag]

# Convertir a formato largo para ggplot2
df_heatmap <- as.data.frame(as.table(matriz_comorb_top))
colnames(df_heatmap) <- c('Diagnostico1', 'Diagnostico2', 'Coocurrencia')

library(viridis)
png('nuevo/plots/heatmap_comorbilidad.png', width = 1100, height = 900)
print(
	ggplot(df_heatmap, aes(x = Diagnostico1, y = Diagnostico2, fill = Coocurrencia)) +
		geom_tile(color = 'white') +
		scale_fill_viridis(option = 'C', direction = -1) +
		geom_text(aes(label = ifelse(Coocurrencia > 0, Coocurrencia, '')), size = 3, color = 'black') +
		labs(title = 'Heatmap de co-ocurrencia de diagnósticos (Top 20)', x = 'Diagnóstico', y = 'Diagnóstico', fill = 'Co-ocurrencia') +
		theme_minimal() +
		theme(axis.text.x = element_text(angle = 45, hjust = 1))
)
dev.off()

# 3. Distribución del número de diagnósticos por paciente
num_diag <- apply(diagnosticos, 1, function(x) sum(!is.na(x) & x != ''))
png('nuevo/plots/hist_num_diagnosticos.png', width = 900, height = 600)
print(
	ggplot(data.frame(num_diag), aes(x = num_diag)) +
		geom_histogram(binwidth = 1, fill = '#E69F00', color = 'black') +
		labs(title = 'Distribución del número de diagnósticos por paciente', x = 'Nº de diagnósticos', y = 'Frecuencia') +
		theme_minimal()
)
dev.off()
