library(readxl)
library(dplyr)
library(tidyr)
library(janitor)
library(DescTools)

# Definir y crear carpeta de salida
output_dir <- "C:/Users/Alejandro/Desktop/PROJECTS/MALACKANALISIS/reportes/reporte3"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Leer datos
datos <- read_excel("C:/Users/Alejandro/Desktop/PROJECTS/MALACKANALISIS/data/SaludMental.xls")

# Convertir todas las columnas POSIXct/POSIXlt a character para evitar errores de formato
for(col in names(datos)) {
  if(inherits(datos[[col]], "POSIXct") || inherits(datos[[col]], "POSIXlt")) {
    datos[[col]] <- as.character(datos[[col]])
  }
}

# 2.3. Revisión de valores nulos, vacíos y desconocidos
df_2_3 <- data.frame(
  variable=names(datos),
  nulos=sapply(datos, function(x) sum(is.na(x))),
  vacios=sapply(datos, function(x) sum(x == "" & !is.na(x))),
  desconocidos=sapply(datos, function(x) sum(tolower(as.character(x)) %in% c("desconocido", "no sabe", "ns/nc", "na")))
)
write.csv(df_2_3, file=file.path(output_dir, "2.3_valores_nulos_vacios_desconocidos.csv"), row.names=FALSE)

# 2.4. Análisis de duplicados y consistencia de registros
duplicados <- datos %>% duplicated()
write(paste("Registros duplicados:", sum(duplicados)), file=file.path(output_dir, "2.4_duplicados.txt"))
if(sum(duplicados) > 0) {
  write.csv(datos[duplicados,], file=file.path(output_dir, "2.4_registros_duplicados.csv"), row.names=FALSE)
}

# 2.5. Identificación de outliers (valores atípicos) para variables numéricas
# Seleccionar solo columnas numéricas que NO sean fechas
num_vars <- names(datos)[sapply(datos, function(x) is.numeric(x) && !inherits(x, "POSIXct") && !inherits(x, "POSIXlt"))]
outliers <- lapply(num_vars, function(var) {
  x <- datos[[var]]
  q1 <- quantile(x, 0.25, na.rm=TRUE)
  q3 <- quantile(x, 0.75, na.rm=TRUE)
  iqr <- q3 - q1
  which(x < (q1 - 1.5*iqr) | x > (q3 + 1.5*iqr))
})
names(outliers) <- num_vars
outlier_counts <- sapply(outliers, length)
write.csv(data.frame(variable=names(outlier_counts), n_outliers=outlier_counts),
          file=file.path(output_dir, "2.5_outliers_por_variable.csv"), row.names=FALSE)

# 2.6. Estadísticas descriptivas básicas
# Usar solo columnas numéricas puras (no fechas)
desc_stats <- datos %>%
  select(all_of(num_vars)) %>%
  summarise_all(list(
    media = ~mean(., na.rm=TRUE),
    mediana = ~median(., na.rm=TRUE),
    moda = ~Mode(., na.rm=TRUE),
    sd = ~sd(., na.rm=TRUE),
    rango = ~diff(range(., na.rm=TRUE)),
    p25 = ~quantile(., 0.25, na.rm=TRUE),
    p75 = ~quantile(., 0.75, na.rm=TRUE)
  ))
write.csv(desc_stats, file=file.path(output_dir, "2.6_estadisticas_descriptivas.csv"), row.names=FALSE)

# Distribución de variables clave (ejemplo: Edad, Estancia Días, Coste APR)
if("Edad" %in% num_vars) {
  png(file.path(output_dir, "2.6_hist_edad.png"))
  hist(datos$Edad, main="Distribución de Edad", xlab="Edad")
  dev.off()
}
if("Estancia Días" %in% num_vars) {
  png(file.path(output_dir, "2.6_hist_estancia_dias.png"))
  hist(datos$`Estancia Días`, main="Distribución de Estancia Días", xlab="Estancia Días")
  dev.off()
}
if("Coste APR" %in% num_vars) {
  png(file.path(output_dir, "2.6_hist_coste_apr.png"))
  hist(datos$`Coste APR`, main="Distribución de Coste APR", xlab="Coste APR")
  dev.off()
}
