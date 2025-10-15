Cogiendo los PDF's y el XLS y haciendo el modelo de datos -> 

	

Columnas BD XLS:


Comunidad Autónoma (Código INE)	->  DONE
Nombre -> CLARO
Fecha de nacimiento -> Claro
Sexo -> DONE
CCAA Residencia (Código INE)-> DONE
Fecha de Ingreso -> CLARO
Circunstancia de Contacto -> DONE
Fecha de Fin Contacto -> CLARO
Tipo Alta	-> DONE
Estancia Días -> CLARO
Diagnóstico Principal -> TMBN CIE10S
Categoría -> Es una especie de resumen textual del dianóstico -> NO APARECE EN RAE-CMBD pero es útil
Diagnóstico 2	Diagnóstico 3	Diagnóstico 4	Diagnóstico 5	Diagnóstico 6	Diagnóstico 7	Diagnóstico 8	Diagnóstico 9	Diagnóstico 10	Diagnóstico 11	Diagnóstico 12	Diagnóstico 13	Diagnóstico 14
->  Corresponden a CIE10ES tmbn a partir de 1/01/2016


Fecha de Intervención -> DONE CLARO EN ddmmaaaa
hhmi

Procedimiento 1	Procedimiento 2	Procedimiento 3	Procedimiento 4	Procedimiento 5	Procedimiento 6	Procedimiento 7	Procedimiento 8	Procedimiento 9	Procedimiento 10	Procedimiento 11	Procedimiento 12	Procedimiento 13	Procedimiento 14	Procedimiento 15	Procedimiento 16	Procedimiento 17	Procedimiento 18	Procedimiento 19	Procedimiento 20 -> Corresponden a CIE10ES tmbn a partir de 1/01/2016


GDR AP > Grupo Relacionado con el Diagnóstico All Patient
🟥 Obsoleto
CDM AP -> Categoría Diagnóstica Mayor All Patient
🟥 Obsoleto
Tipo GDR AP -> Tipo de GRD (médico / quirúrgico) All Patient
🟥 Obsoleto

Estos campos se calculaban con software 3M™ All Patient DRG (AP-DRG), usado hasta 2015.

Valor Peso Español	 -> 🟥 Obsoleto
GRD APR	-> Código del grupo APR-DRG según versión vigente DONE  TABLA GRD
CDM APR -> Categoría Diagnóstica Mayor (Major Diagnostic Category)  TABLA GRD
Tipo GDR APR	-> Tipo de proceso (Q = Quirúrgico / M = Médico)  TABLA GRD
Valor Peso Americano APR -> Peso USA de referencia (opcional en exportaciones) -> En nuestra tabla columna vacía
Nivel Severidad APR -> GRADO del 1-4
Riesgo Mortalidad APR -> Nivel de Riesgo de Mortalidad (1 a 4)
Servicio -> Se refiere al servicio responsable del alta hospitalaria del paciente / de
la atención (AAE) tabla de servicios 
Edad -> En años claro
Reingreso -> 1. Reingreso (para un mismo paciente, centro y año en los 30 días tras
un alta previa)/ 2. nuevo episodio

Coste APR -> Coste nuestro no el medio de la tabla, pero lo podemos consultar en la tabla TABLA GRD
GDR IR -> Tipo de GRD (médico / quirúrgico) All Patient
🟥 Obsoleto
Tipo GDR IR-> Tipo de GRD (médico / quirúrgico) All Patient
🟥 Obsoleto
Tipo PROCESO IR -> Tipo de GRD (médico / quirúrgico) All Patient
🟥 Obsoleto

Con la implantación del APR-DRG (All Patient Refined DRG), el Ministerio retiró oficialmente los tres campos anteriores.


CIE -> Referencia al estándar todos son iguales -> 10
Número de registro anual -> No es una variable normativa del RAE-CMBD, aunque corresponde funcionalmente al identificador de episodio.

Centro Recodificado -> Código anonimizado ininversible  -> pero tenemos la tabla para inserción
CIP SNS Recodificado -> Código identificación personal en el SNS Anonimizado
País Nacimiento -> Según estánadar ISO 3166-1 (tenemos la tabla)
País Residencia ->  Según estánadar ISO 3166-1 (tenemos la tabla)
Fecha de Inicio contacto -> Fecha y hora de inicio del contacto  -> Fecha (ddmmaa aa hhmi)
Régimen Financiación -> Tabla régimenes de financiación
Procedencia -> Tabla procedencia

Continuidad Asistencial  -> Tabla continuidad asistencial
Ingreso en UCI -> 1 SI / 2 NO
Días UCI -> Numérico 3 dígitos


Diagnóstico 15 Diagnóstico 16 Diagnóstico 17 Diagnóstico 18 Diagnóstico 19 Diagnóstico 20 ->  Corresponden a CIE10ES tmbn a partir de 1/01/2016


POA Diagnóstico Principal -> TABLA POA DIAGNÓSTICO


POA Diagnóstico 2 -> TABLA POA DIAGNÓSTICO
POA Diagnóstico 3	-> TABLA POA DIAGNÓSTICO
POA Diagnóstico 4-> TABLA POA DIAGNÓSTICO
POA Diagnóstico 5-> TABLA POA DIAGNÓSTICO
POA Diagnóstico 6-> TABLA POA DIAGNÓSTICO
POA Diagnóstico 7	POA Diagnóstico 8	POA Diagnóstico 9	POA Diagnóstico 10	POA Diagnóstico 11	POA Diagnóstico 12	POA Diagnóstico 13	POA Diagnóstico 14	POA Diagnóstico 15	POA Diagnóstico 16	POA Diagnóstico 17	POA Diagnóstico 18	POA Diagnóstico 19	POA Diagnóstico 20
-> TABLA POA DIAGNÓSTICO

Procedimiento Externo 1	Procedimiento Externo 2	Procedimiento Externo 3	Procedimiento Externo 4	Procedimiento Externo 5	Procedimiento Externo 6 -> CIE10ES

Tipo GRD APR	 -> Nuevo Q/M
Peso Español APR	-> TABLA PESO ESPAÑOL
Edad en Ingreso -> 	3 Dígitos
Mes de Ingreso -> aaaa-dd 


------------------------------------------------------------
🧾 ANOTACIONES BASADAS EN RAE-CMBD (REAL DECRETO 69/2015 y ANEXO 2018)
------------------------------------------------------------

Comunidad Autónoma (Código INE)
Tipo de dato: Carácter
Longitud: 2
Fuente: Anexo II.c Real Decreto 69/2015

Nombre
Tipo de dato: Carácter
Longitud: Variable (<=200)
Fuente: Variable interna del dataset, no figura en RAE-CMBD

Fecha de nacimiento
Tipo de dato: Fecha (ddmmaaaa)
Longitud: 8
Fuente: Anexo II.a Real Decreto 69/2015

Sexo
Tipo de dato: Carácter
Longitud: 1
Valores: 1 Varón / 2 Mujer / 9 No especificado
Fuente: Anexo II.a Real Decreto 69/2015

CCAA Residencia (Código INE)
Tipo de dato: Carácter
Longitud: 2
Fuente: Anexo II.c Real Decreto 69/2015

Fecha de Ingreso
Tipo de dato: Fecha y hora (ddmmaaaa hhmi)
Longitud: 13
Fuente: FECINGHOSP - Anexo II.a Real Decreto 69/2015

Circunstancia de Contacto
Tipo de dato: Carácter
Longitud: 1
Valores: 1 No programado / 2 Programado / 9 Desconocido
Fuente: CIRCONT - Anexo II.a Real Decreto 69/2015

Fecha de Fin Contacto
Tipo de dato: Fecha y hora (ddmmaaaa hhmi)
Longitud: 13
Fuente: FECFINCONT - Anexo II.a Real Decreto 69/2015

Tipo Alta
Tipo de dato: Carácter
Longitud: 1
Valores: 1 Domicilio / 2 Traslado a otro hospital / 3 Alta voluntaria / 4 Éxitus / 5 Centro sociosanitario / 8 Otros / 9 Desconocido
Fuente: TIPALT - Anexo II.a Real Decreto 69/2015

Estancia Días
Tipo de dato: Numérico
Longitud: 3
Fuente: Variable calculada (Anexo 2018, sección B.1)

Diagnóstico Principal
Tipo de dato: Carácter
Longitud: 8
Formato: CIE10ES
Fuente: D1 - Anexo II.a Real Decreto 69/2015

Categoría
Tipo de dato: Carácter
Longitud: Variable
Fuente: No incluida en RAE-CMBD; agrupación textual derivada de CIE10ES

Diagnóstico 2–20
Tipo de dato: Carácter
Longitud: 8
Formato: CIE10ES
Fuente: D2-D20 - Anexo II.a Real Decreto 69/2015

Fecha de Intervención
Tipo de dato: Fecha y hora (ddmmaaaa hhmi)
Longitud: 13
Fuente: FECINT - Anexo II.a Real Decreto 69/2015

Procedimiento 1–20
Tipo de dato: Carácter
Longitud: 7
Formato: CIE10ES Procedimientos
Fuente: PROC1–PROC20 - Anexo II.a Real Decreto 69/2015

Procedimiento Externo 1–6
Tipo de dato: Carácter
Longitud: 7
Formato: CIE10ES Procedimientos
Fuente: PROCEXT1–PROCEXT6 - Anexo II.a Real Decreto 69/2015

POA Diagnóstico Principal y 2–20
Tipo de dato: Carácter
Longitud: 1
Valores: S Sí / N No / D Desconocido / I Indeterminado clínicamente / E Exento
Fuente: POAD1–POAD20 - Anexo II.a Real Decreto 69/2015

Servicio
Tipo de dato: Carácter
Longitud: 3
Fuente: SERVICIO - Anexo II.b Real Decreto 69/2015

Edad
Tipo de dato: Numérico
Longitud: 3
Fuente: Variable derivada (Anexo 2018, sección B.1)

Reingreso
Tipo de dato: Carácter
Longitud: 1
Valores: 1 Reingreso / 2 Nuevo episodio
Fuente: Variable calculada (Anexo 2018, sección A.2)

Régimen Financiación
Tipo de dato: Carácter
Longitud: 1
Valores: 1 SNS / 2 Reglamentos UE / 3 Mutualidades / 4 Mutuas / 5 Tráfico / 6 Privado / 7 Seguro Privado / 8 Transfronterizo / 9 Otros
Fuente: REGFIN - Anexo II.a Real Decreto 69/2015

Procedencia
Tipo de dato: Carácter
Longitud: 2
Fuente: PROCEDENCIA - Anexo II.a Real Decreto 69/2015

Continuidad Asistencial
Tipo de dato: Carácter
Longitud: 1
Fuente: DISPOSITIVO_CONTINUIDAD - Anexo II.a Real Decreto 69/2015

Ingreso en UCI
Tipo de dato: Carácter
Longitud: 1
Valores: 1 Sí / 2 No
Fuente: UCI - Anexo II.a Real Decreto 69/2015

Días UCI
Tipo de dato: Numérico
Longitud: 3
Fuente: DIAS_UCI - Anexo II.a Real Decreto 69/2015

Centro Recodificado
Tipo de dato: Carácter
Longitud: 9
Fuente: CEN_SAN - Anexo II.a Real Decreto 69/2015

CIP SNS Recodificado
Tipo de dato: Carácter
Longitud: 16
Fuente: CIP - Anexo II.a Real Decreto 69/2015

País Nacimiento
Tipo de dato: Carácter
Longitud: 3 (ISO 3166-1)
Fuente: PAIS_NAC - Anexo II.d Real Decreto 69/2015

País Residencia
Tipo de dato: Carácter
Longitud: 3 (ISO 3166-1)
Fuente: PAIS_NAC / RESIDE_MUNI - Anexo II.d Real Decreto 69/2015

Fecha de Inicio contacto
Tipo de dato: Fecha y hora (ddmmaaaa hhmi)
Longitud: 13
Fuente: FECINICONT - Anexo II.a Real Decreto 69/2015

GDR AP, CDM AP, Tipo GDR AP, GDR IR, Tipo GDR IR, Tipo PROCESO IR
Tipo de dato: Carácter
Longitud: Variable
Estado: Obsoletos
Fuente: CMBD pre-2015 (Anexo 2018 sección A.1)

GRD APR
Tipo de dato: Carácter
Longitud: 3
Fuente: GRD APR - Anexo 2018 sección B.1

CDM APR
Tipo de dato: Carácter
Longitud: 2
Fuente: CDM APR - Anexo 2018 sección B.1

Tipo GRD APR
Tipo de dato: Carácter
Longitud: 1
Valores: Q Quirúrgico / M Médico
Fuente: Tipo GRD APR - Anexo 2018 sección B.1

Nivel Severidad APR
Tipo de dato: Carácter
Longitud: 1 (1–4)
Fuente: Nivel Severidad APR - Anexo 2018 sección B.1

Riesgo Mortalidad APR
Tipo de dato: Carácter
Longitud: 1 (1–4)
Fuente: Riesgo Mortalidad APR - Anexo 2018 sección B.1

Peso Español APR
Tipo de dato: Numérico (decimal)
Fuente: Peso Español APR - Anexo 2018 sección B.1

Coste APR
Tipo de dato: Numérico (decimal)
Fuente: Coste APR - Anexo 2018 sección B.1

Número de registro anual
Tipo de dato: Carácter
Longitud: 30
Fuente: Identificador técnico de episodio (no oficial, equivalente a unidad de registro del Art.6 RD 69/2015)

Edad en Ingreso
Tipo de dato: Numérico
Longitud: 3
Fuente: Variable calculada (Anexo 2018, sección B.1)

Mes de Ingreso
Tipo de dato: Fecha parcial (mes-año)
Longitud: 7
Fuente: Variable derivada (Anexo 2018, sección B.1)


------------------------------------------------------------
📘 TABLA RESUMEN DE VARIABLES SEGÚN RAE-CMBD (REAL DECRETO 69/2015)
------------------------------------------------------------

| Variable | Tipo de dato | Longitud | Descripción breve | Tabla nuestra |
|-----------|---------------|-----------|--------------------|----------------|
| Comunidad Autónoma | Carácter | 2 | Código INE de la comunidad autónoma del centro sanitario. | CCAA |
| Nombre | Carácter | Variable | Nombre del paciente (dato auxiliar, no incluido en RAE-CMBD). | CONTACTO |
| Fecha de nacimiento | Fecha | 8 | Fecha de nacimiento del paciente. | CONTACTO |
| Sexo | Carácter | 1 | Sexo biológico: 1 Varón / 2 Mujer / 9 No especificado. | CONTACTO |
| CCAA Residencia | Carácter | 2 | Código INE de la comunidad autónoma de residencia del paciente. | CONTACTO |
| Fecha de Ingreso | Fecha y hora | 13 | Fecha/hora en la que se ordena el ingreso hospitalario. | CONTACTO |
| Circunstancia de Contacto | Carácter | 1 | Indica si el contacto fue programado o no. | CONTACTO |
| Fecha de Fin Contacto | Fecha y hora | 13 | Fecha/hora de finalización del contacto asistencial. | CONTACTO |
| Tipo Alta | Carácter | 1 | Destino del paciente tras el alta. | CONTACTO |
| Estancia Días | Numérico | 3 | Días entre inicio y fin del contacto. | CONTACTO |
| Diagnóstico Principal | Carácter | 8 | Código CIE10ES del diagnóstico principal. | DIAGNÓSTICO |
| Diagnóstico 2–20 | Carácter | 8 | Códigos CIE10ES de diagnósticos secundarios. | DIAGNÓSTICO |
| POA Diagnóstico Principal y 2–20 | Carácter | 1 | Indicador de si el diagnóstico estaba presente al ingreso. | DIAGNÓSTICO |
| Categoría | Carácter | Variable | Agrupación textual derivada del diagnóstico principal. | DIAGNÓSTICO |
| Fecha de Intervención | Fecha y hora | 13 | Fecha/hora de la primera intervención quirúrgica. | PROCEDIMIENTO |
| Procedimiento 1–20 | Carácter | 7 | Códigos CIE10ES de procedimientos realizados en el centro. | PROCEDIMIENTO |
| Procedimiento Externo 1–6 | Carácter | 7 | Códigos CIE10ES de procedimientos realizados en otros centros. | PROCEDIMIENTO |
| Servicio | Carácter | 3 | Código del servicio responsable del alta. | CONTACTO |
| Edad | Numérico | 3 | Edad del paciente en años al ingreso. | CONTACTO |
| Reingreso | Carácter | 1 | Indica si el paciente reingresó dentro de 30 días. | CONTACTO |
| Régimen Financiación | Carácter | 1 | Fuente de financiación del episodio (SNS, privado, etc.). | CONTACTO |
| Procedencia | Carácter | 2 | Origen del contacto (AP, urgencias, otro hospital, etc.). | CONTACTO |
| Continuidad Asistencial | Carácter | 1 | Indica si se planificó continuidad asistencial tras el alta. | CONTACTO |
| Ingreso en UCI | Carácter | 1 | Indica si el paciente ingresó en UCI. | CONTACTO |
| Días UCI | Numérico | 3 | Días de estancia en UCI. | CONTACTO |
| Centro Recodificado | Carácter | 9 | Código anonimizado del centro asistencial. | CONTACTO |
| CIP SNS Recodificado | Carácter | 16 | Identificador personal anonimizado del paciente. | CONTACTO |
| País Nacimiento | Carácter | 3 | Código ISO del país de nacimiento. | CONTACTO |
| País Residencia | Carácter | 3 | Código ISO del país de residencia. | CONTACTO |
| Fecha de Inicio contacto | Fecha y hora | 13 | Fecha/hora de llegada o inicio del contacto asistencial. | CONTACTO |
| GRD APR | Carácter | 3 | Grupo APR-DRG según la versión vigente. | GRD |
| CDM APR | Carácter | 2 | Categoría Diagnóstica Mayor asociada al GRD APR. | GRD |
| Tipo GRD APR | Carácter | 1 | Tipo de proceso (Q Quirúrgico / M Médico). | GRD |
| Nivel Severidad APR | Carácter | 1 | Nivel de gravedad del caso (1 a 4). | GRD |
| Riesgo Mortalidad APR | Carácter | 1 | Nivel de riesgo de mortalidad (1 a 4). | GRD |
| Peso Español APR | Numérico (decimal) | Variable | Peso medio de complejidad hospitalaria. | GRD |
| Coste APR | Numérico (decimal) | Variable | Coste medio estimado según nivel de severidad. | GRD |
| Número de registro anual | Carácter | 30 | Identificador técnico del episodio (no oficial). | CONTACTO |
| Edad en Ingreso | Numérico | 3 | Edad en años al momento del ingreso. | CONTACTO |
| Mes de Ingreso | Fecha parcial | 7 | Mes y año del ingreso hospitalario. | CONTACTO |


