# Script de limpieza final para SaludMentalCSV.csv
# Elimina columnas obsoletas, filas con nulos, desconocidos y outliers, y documenta todo


# Librerías necesarias
dependencias <- c("readr", "dplyr", "stringr", "janitor", "naniar")
lapply(dependencias, function(pkg) if(!require(pkg, character.only = TRUE)) install.packages(pkg, repos = "https://cloud.r-project.org"))
if(!require("outliers", character.only = TRUE)) install.packages("outliers", repos = "https://cloud.r-project.org")
library(readr)
library(dplyr)
library(stringr)
library(janitor)
library(naniar)
library(outliers)


# Rutas robustas usando getwd()
root_dir <- getwd()
input_csv <- file.path(root_dir, "data", "SaludMentalCSV.csv")
output_dir <- file.path(root_dir, "reportes", "reporte4")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
output_csv <- file.path(output_dir, "SaludMentalLIMPIO.csv")

# Verificar existencia del archivo
if(!file.exists(input_csv)) stop(paste("No se encuentra el archivo:", input_csv))

# Leer datos
datos <- read_delim(input_csv, delim = ";", locale = locale(encoding = "LATIN1"), guess_max = 10000)
datos <- janitor::clean_names(datos)

# Columnas obsoletas a eliminar
cols_obsoletas <- c(
  "gdr_ap", "cdm_ap", "tipo_gdr_ap", "valor_peso_espanol", "gdr_ir", "tipo_gdr_ir", "tipo_proceso_ir", "valor_peso_americano_apr"
)
cols_obsoletas <- cols_obsoletas[cols_obsoletas %in% names(datos)]

# Guardar columnas eliminadas
data.frame(columna = cols_obsoletas) %>%
  write_csv(file.path(output_dir, "columnas_eliminadas.csv"))

# Eliminar columnas obsoletas
datos <- datos %>% select(-all_of(cols_obsoletas))


# Guardar filas con NA o valores desconocidos antes de eliminar
na_rows <- datos %>% filter(
  if_any(where(~!is.logical(.)), ~is.na(.) | as.character(.) %in% c("", "NA", "NaN", "Desconocido", "desconocido", "9", "999", "9999"))
)
if(nrow(na_rows) > 0) write_csv(na_rows, file.path(output_dir, "filas_nulos_desconocidos.csv"))

# Eliminar filas con NA o valores desconocidos
datos <- datos %>% filter(
  if_all(where(~!is.logical(.)), ~!(is.na(.) | as.character(.) %in% c("", "NA", "NaN", "Desconocido", "desconocido", "9", "999", "9999")))
)


# Detectar y guardar outliers (solo columnas numéricas, no lógicas)
outlier_rows <- NULL
num_cols <- names(datos)[sapply(datos, function(x) is.numeric(x) && !is.logical(x))]
if(length(num_cols) > 0){
  for(col in num_cols){
    vals <- datos[[col]]
    # Solo si hay más de 4 valores y sd > 0
    if(length(vals) > 4 && sd(vals, na.rm=TRUE) > 0){
      # Control de errores por si outlier falla
      out_idx <- tryCatch({
        which(vals %in% outlier(vals, logical=TRUE))
      }, error=function(e) integer(0))
      if(length(out_idx) > 0){
        outlier_rows <- rbind(outlier_rows, datos[out_idx,])
      }
    }
  }
}
if(!is.null(outlier_rows)) write_csv(unique(outlier_rows), file.path(output_dir, "filas_outliers.csv"))

# Eliminar outliers del dataset
if(length(num_cols) > 0){
  out_idx_all <- unique(unlist(lapply(num_cols, function(col) {
    vals <- datos[[col]]
    if(length(vals) > 4 && sd(vals, na.rm=TRUE) > 0){
      tryCatch(which(vals %in% outlier(vals, logical=TRUE)), error=function(e) integer(0))
    } else {
      integer(0)
    }
  })))
  if(length(out_idx_all) > 0){
    datos <- datos[-out_idx_all, ]
  }
}

# Guardar dataset limpio
write_csv(datos, output_csv)

cat("Limpieza completada. Dataset limpio y reportes generados en reporte4.\n")
