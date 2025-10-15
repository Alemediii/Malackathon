# Script para calcular medidas de tendencia central de variables numéricas relevantes
# Lee el archivo CSV de salud mental y exporta los resultados a un TXT

# Librerías necesarias
suppressWarnings(suppressMessages(library(dplyr)))

# Ruta del archivo CSV y de salida
input_file <- "C:/Users/Alejandro/Desktop/PROJECTS/MALACKANALISIS/reportes/reporte4/filas_nulos_desconocidos.csv"
output_file <- "C:/Users/Alejandro/Desktop/PROJECTS/MALACKANALISIS/reportes/reporte5/tendenciacentral/tendencia_central.txt"

# Leer el archivo CSV
df <- read.csv(input_file, stringsAsFactors = FALSE)

# Seleccionar solo columnas numéricas relevantes
df_numeric <- df %>% select(where(is.numeric))

# Si hay columnas numéricas, calcular medidas
txt <- ''
if (ncol(df_numeric) > 0) {
  for (col in names(df_numeric)) {
    vals <- df_numeric[[col]]
    vals <- vals[!is.na(vals)]
    if (length(vals) > 0) {
      txt <- paste0(txt, 'Variable: ', col, '\n')
      txt <- paste0(txt, '  Media: ', mean(vals), '\n')
      txt <- paste0(txt, '  Mediana: ', median(vals), '\n')
      txt <- paste0(txt, '  Moda: ', paste(names(sort(-table(vals)))[1], collapse=','), '\n')
      txt <- paste0(txt, '  Min: ', min(vals), '\n')
      txt <- paste0(txt, '  Max: ', max(vals), '\n')
      txt <- paste0(txt, '  Desviación estándar: ', sd(vals), '\n\n')
    }
  }
} else {
  txt <- 'No se encontraron columnas numéricas relevantes.'
}

# Guardar resultados en TXT
writeLines(txt, output_file)
