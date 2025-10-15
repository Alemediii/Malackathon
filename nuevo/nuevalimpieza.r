# Limpieza avanzada para pais_residencia en SaludMentaLimpio.csv
# Elimina o corrige valores float en pais_residencia

library(dplyr)
input_file <- "C:/Users/Alejandro/Desktop/PROJECTS/MALACKANALISIS/reportes/reporte4/SaludMentaLimpio.csv"
output_file <- "C:/Users/Alejandro/Desktop/PROJECTS/MALACKANALISIS/nuevo/SaludMentaLimpio_limpio.csv"

# Leer datos
raw <- read.csv(input_file, stringsAsFactors = FALSE)


# Detectar y convertir valores float en pais_residencia a integer (como string)
convert_float_to_int <- function(x) {
  ifelse(suppressWarnings(!is.na(as.numeric(x)) & grepl("\\.", x)),
         as.character(as.integer(as.numeric(x))),
         x)
}
raw$pais_residencia <- convert_float_to_int(raw$pais_residencia)

# Opcional: filtrar filas con NA en pais_residencia
# raw <- raw[!is.na(raw$pais_residencia), ]

# Guardar resultado
write.csv(raw, output_file, row.names = FALSE)
if (file.exists(output_file)) {
  cat(paste('Archivo limpio guardado en:', output_file, '\n'))
} else {
  cat('Error: No se pudo guardar el archivo limpio.\n')
}
