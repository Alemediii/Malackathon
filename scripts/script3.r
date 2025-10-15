# Cargar librerías necesarias
library(readxl)
library(dplyr)
library(lubridate)

# Definir y crear carpeta de salida
output_dir <- "C:/Users/Alejandro/Desktop/PROJECTS/MALACKANALISIS/reportes/reporte2"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Leer el archivo Excel
datos <- read_excel("C:/Users/Alejandro/Desktop/PROJECTS/MALACKANALISIS/data/SaludMental.xls")

# 2.1 Estructura y dimensiones
dimensiones <- dim(datos)
cat("Filas:", dimensiones[1], "Columnas:", dimensiones[2], "\n")
str(datos)

# 2.2 Tipología de variables
# Detectar tipos
var_types <- sapply(datos, class)

# Organizar variables por tipo y guardar en archivos separados

# Variables numéricas
num_vars <- names(datos)[sapply(datos, is.numeric)]
if(length(num_vars) > 0){
  writeLines(c("-- numerico --", num_vars), file.path(output_dir, "variables_numericas.txt"))
}

# Variables lógicas
logic_vars <- names(datos)[sapply(datos, is.logical)]
if(length(logic_vars) > 0){
  writeLines(c("-- logico --", logic_vars), file.path(output_dir, "variables_logicas.txt"))
}

# Variables categóricas (factor o character con <= 50 valores únicos)
cat_vars <- names(datos)[sapply(datos, function(x) (is.character(x) | is.factor(x)) && length(unique(x)) <= 50)]
if(length(cat_vars) > 0){
  writeLines(c("-- categorico --", cat_vars), file.path(output_dir, "variables_categoricas.txt"))
}

# Variables de fecha
date_vars <- names(datos)[sapply(datos, function(x) inherits(x, "Date") | inherits(x, "POSIXct") | inherits(x, "POSIXlt"))]
if(length(date_vars) > 0){
  writeLines(c("-- fecha --", date_vars), file.path(output_dir, "variables_fecha.txt"))
}

# Variables de texto libre: character con > 50 valores únicos
text_vars <- names(datos)[sapply(datos, function(x) is.character(x) && length(unique(x)) > 50)]
if(length(text_vars) > 0){
  writeLines(c("-- texto libre --", text_vars), file.path(output_dir, "variables_texto_libre.txt"))
}

# Ejemplo: guardar resumen de variables en un archivo CSV
tibble(
  variable = names(datos),
  tipo = sapply(datos, function(x) class(x)[1]),
  n_unique = sapply(datos, function(x) length(unique(x))),
  n_na = sapply(datos, function(x) sum(is.na(x)))
) %>%
  write.csv(file = file.path(output_dir, "resumen_variables.csv"), row.names = FALSE)