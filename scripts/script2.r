# ----------------------------------------------------------
# Informe inicial automático para dataset (filas 1:5000)
# Requisitos: readxl, readr, dplyr, tidyr, stringr, lubridate,
# ggplot2, janitor, skimr, naniar, flextable, rmarkdown
# ----------------------------------------------------------

# Instalar y cargar paquetes si falta
pkg <- c("readxl","readr","dplyr","tidyr","stringr","lubridate",
         "ggplot2","janitor","skimr","naniar","flextable")
instalar_si_falta <- function(p) if(!require(p,character.only=TRUE)){install.packages(p, repos = "https://cloud.r-project.org"); library(p,character.only=TRUE)}
invisible(lapply(pkg, instalar_si_falta))

# Ajusta estas rutas
ruta_excel <- "C:/Users/Alejandro/Desktop/PROJECTS/MALACKANALISIS/SaludMental.xls"   # o ruta a CSV si lo exportas
salida_dir <- "C:/Users/Alejandro/Desktop/PROJECTS/MALACKANALISIS/REPORTE"
dir.create(salida_dir, showWarnings = FALSE)

# 1) Lectura eficiente: si es Excel, leer solo la 1ª hoja y primeras 5000 filas
library(readxl)
info_hojas <- excel_sheets(ruta_excel)
datos_raw <- read_excel(path = ruta_excel, sheet = info_hojas[1], n_max = 5000)

# Si usas CSV, usa en su lugar:
# datos_raw <- readr::read_csv("ruta/a/Libro1_1-5000.csv")

# Guardar un CSV de trabajo
readr::write_csv(datos_raw, file.path(salida_dir, "datos_1-5000.csv"))

# 2) Previsualización y tipos
cat("Filas leídas:", nrow(datos_raw), " Columnas:", ncol(datos_raw), "\n")
str(datos_raw)
summary(datos_raw)

# 3) Limpieza básica de nombres y tipos
library(janitor)
datos <- datos_raw %>%
  janitor::clean_names() %>%         # nombres en minúscula y _ en espacios
  mutate_if(is.character, str_trim) # recortar espacios

# Intentar parsear columnas fecha y numéricas comunes
possible_date_cols <- names(datos)[sapply(datos, function(x) any(grepl("[0-9]{4}-[0-9]{2}-[0-9]{2}", as.character(x))))]
for(col in possible_date_cols){
  parsed <- lubridate::parse_date_time(datos[[col]], orders = c("ymd","dmy","mdy","Ymd"))
  if(sum(!is.na(parsed)) / length(parsed) > 0.6) datos[[col]] <- parsed
}

# 4) Detección valores faltantes y duplicados
library(naniar)
miss_summary <- naniar::miss_var_summary(datos)
readr::write_csv(miss_summary, file.path(salida_dir, "missing_summary.csv"))

dup_keys <- datos %>% duplicated()
n_dup <- sum(dup_keys)
cat("Duplicados detectados:", n_dup, "\n")
if(n_dup > 0) {
  readr::write_csv(datos[dup_keys, ], file.path(salida_dir, "duplicados.csv"))
}

# 5) Resumen por columnas: tipos, n_unique, top values
col_summary <- data.frame(
  columna = names(datos),
  tipo = sapply(datos, function(x) class(x)[1]),
  n_unique = sapply(datos, function(x) length(unique(x))),
  n_na = sapply(datos, function(x) sum(is.na(x)))
)
readr::write_csv(col_summary, file.path(salida_dir, "column_summary.csv"))

# 6) Estadísticas descriptivas rápidas (numéricas)
num_cols <- names(datos)[sapply(datos, is.numeric)]
if(length(num_cols) > 0){
  stats_num <- datos %>% select(all_of(num_cols)) %>% skimr::skim()
  capture.output(stats_num, file = file.path(salida_dir, "numeric_summary.txt"))
}

# 7) Tablas claves: conteo por categorías importantes (autodetectar columnas tipo factor/char con pocas categorías)
cat_cols <- names(datos)[sapply(datos, function(x) is.character(x) | is.factor(x))]
# elegir columnas candidatas con <= 50 categorías
cand_cat <- Filter(function(c) length(unique(datos[[c]])) <= 50, cat_cols)

for(col in cand_cat){
  tbl <- datos %>% count(!!sym(col), sort = TRUE)
  readr::write_csv(tbl, file.path(salida_dir, paste0("table_count_", col, ".csv")))
}

# 8) Series temporales / volumen por fecha (si hay columna fecha detectada)
date_cols <- names(datos)[sapply(datos, lubridate::is.Date)]
if(length(date_cols) > 0){
  fecha <- date_cols[1]
  ts <- datos %>%
    filter(!is.na(!!sym(fecha))) %>%
    mutate(period = lubridate::floor_date(!!sym(fecha), unit = "day")) %>%
    count(period) 
  readr::write_csv(ts, file.path(salida_dir, "time_series_daily.csv"))
  # Gráfico
  p <- ggplot(ts, aes(x = period, y = n)) + geom_line(color = "steelblue") + theme_minimal() +
    labs(x = "Fecha", y = "Registros", title = paste("Volumen diario —", fecha))
  ggsave(filename = file.path(salida_dir, "timeseries_daily.png"), plot = p, width = 8, height = 3)
}

# 9) Distribuciones numéricas: histogramas y boxplots (guardar los 5 más informativos)
if(length(num_cols) > 0){
  top_num <- head(num_cols, 5)
  for(col in top_num){
    p1 <- ggplot(datos, aes(x = !!sym(col))) + geom_histogram(bins = 30, fill = "steelblue") + theme_minimal()
    ggsave(file.path(salida_dir, paste0("hist_", col, ".png")), p1, width = 6, height = 4)
    p2 <- ggplot(datos, aes(y = !!sym(col))) + geom_boxplot(fill = "grey70") + theme_minimal()
    ggsave(file.path(salida_dir, paste0("box_", col, ".png")), p2, width = 3, height = 4)
  }
}

# 10) Detección de outliers simple (IQR) por variable numérica
outlier_list <- list()
for(col in num_cols){
  x <- datos[[col]]
  q1 <- quantile(x, 0.25, na.rm = TRUE); q3 <- quantile(x, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  out_mask <- x < (q1 - 1.5*iqr) | x > (q3 + 1.5*iqr)
  outlier_list[[col]] <- sum(out_mask, na.rm = TRUE)
}
outliers_df <- data.frame(variable = names(outlier_list), n_outliers = unlist(outlier_list))
readr::write_csv(outliers_df, file.path(salida_dir, "outliers_summary.csv"))

# 11) Guardar un RDS del dataset procesado para análisis siguientes
saveRDS(datos, file = file.path(salida_dir, "datos_limpios_1-5000.rds"))

# 12) Resumen en consola
cat("Salida generada en:", salida_dir, "\n")