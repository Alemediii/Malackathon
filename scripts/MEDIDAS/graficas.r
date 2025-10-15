
# Leer el archivo filas_nulos_desconocidos.csv de reporte4
library(readr)
reporte4 <- suppressMessages(read_csv('reportes/reporte4/filas_nulos_desconocidos.csv', show_col_types = FALSE, progress = FALSE))

# Función para contar nulos y desconocidos por variable
listar_variables <- function(df) {
    resultado <- data.frame(
        Variable = names(df),
        Filas = sapply(df, length),
        Nulos = sapply(df, function(x) sum(is.na(x))),
        Desconocidos = sapply(df, function(x) sum(tolower(as.character(x)) %in% c("desconocido", "desconocida")))
    )
    return(resultado)
}

resultado <- listar_variables(reporte4)
print(resultado)