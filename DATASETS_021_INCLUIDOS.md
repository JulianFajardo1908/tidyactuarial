# Datos incluidos en la candidata 0.2.1

## mortality_regions

**28.785 filas, 21 columnas, 285 tablas de período.** Corte de 2023 de
*World Population Prospects 2024*, División de Población de las Naciones
Unidas. Son estimaciones de período, no observaciones individuales,
proyecciones ni una cohorte real. Selección de 67 países o áreas y 28
agregados geográficos; tres categorías de sexo y edades 0–99 más 100+.
Clave: código de área WPP, año, sexo y edad inicial. M49 e ISO3 se
validaron para países; los agregados usan identificadores WPP.

Fuente: [UN WPP 2024](https://population.un.org/wpp/). Atribución y [CC
BY 3.0 IGO](https://creativecommons.org/licenses/by/3.0/igo/) en
`inst/COPYRIGHTS`. Referencias oficiales del régimen de datos en
`data-raw/README.md`. La licencia MIT del código se mantiene separada de
la licencia del dataset. Originales consultados el 2026-11-06, fuera de
Git; URL, tamaño y SHA256 completos en
[`data-raw/provenance.csv`](https://julianfajardo1908.github.io/tidyactuarial/data-raw/provenance.csv).

| Original WPP (1950–2023) | Filas incluidas | SHA-256 |
|----|---:|----|
| Female | 9.595 | `0e23ba8cc2daabd9aa40839b02e21917205f29ea45791c2b1a87bd42705b1458` |
| Male | 9.595 | `e304a776352e5899ff45a1e0c059bdbaa32e8a8249d36d8f4627b2afaf6358be` |
| Both | 9.595 | `7ad8748f4dec567dcfd74fb7161a369e09f6501489c49bce1cd0572c16484058` |

Se conservan los valores numéricos publicados. Se añaden metadatos de
selección y una bandera para la edad abierta. Tasas y probabilidades en
base 1; `mx` por persona-año, `lx` y `dx` por 100.000 vidas de radix,
`Lx` y `Tx` en años-persona del radix, `ex` y `ax` en años. No hay
escalado porcentual ni cierre añadido.

### Cotejo numérico

| Colombia 2023 a los 65 años |         qx |        lx |      ex |
|-----------------------------|-----------:|----------:|--------:|
| Ambos                       | 0,01115004 | 85491,226 | 18,3787 |
| Mujeres                     | 0,00880358 | 89108,544 | 19,6962 |
| Hombres                     | 0,01379633 | 81889,090 | 16,8579 |

Sin claves duplicadas. `qx + px` difiere de 1 en como máximo 1,2e-16. Un
segundo lector cotejó exactamente los 259.065 campos numéricos
seleccionados (9 campos por fila) con los tres archivos gzip. Los
residuos máximos de `lx - lx_siguiente - dx` y `Tx - Tx_siguiente - Lx`
en tramos anuales son aproximadamente 0,001. `lx*qx - dx` y `mx*Lx - dx`
quedan por debajo de 0,001 en valor absoluto en tramos anuales. El
máximo de `abs(Tx/lx - ex)` es aproximadamente 0,000163 años. En las 84
filas abiertas de agregados el `dx` original no satisface `lx*qx`
(discrepancia máxima 3289,386): se conserva y documenta, no se considera
una muerte en un intervalo anual. El `qx=1` original en 100+ cubre el
intervalo abierto; no implica extinción al año siguiente.

Aplicación:
[`t_px()`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
en un plazo soportado, usando solo `x,lx` de una tabla; Colombia ambos
65→70: `79847.433/85491.226`. No combinar las columnas redondeadas con
validadores que requieren identidades exactas ni usar el intervalo
abierto para una valoración vitalicia automática.

En el solapamiento de 3.939 filas con la muestra antigua de 2023, todos
los `mx` coinciden. Esa muestra reconstruye qx/lx/dx con ax=0,5 y cierra
su horizonte según su documentación. Ejemplo: Sudáfrica, hombres, edad
0, qx antiguo 0,03026138 frente al qx ONU 0,02992495. Se conservan los
ocho objetos anteriores sin modificar.

La viñeta usa
[`MASS::Melanoma`](https://rdrr.io/pkg/MASS/man/Melanoma.html) de forma
opcional para incidencia acumulada con censura. No se redistribuyen los
205 registros ni se interpretan como decrementos anuales por edad.

## pet_lifetables

**57 filas, 17 columnas, tres tablas.** Montoya et al. (2023), tablas 3
y 4: perros y gatos de EE. UU., 18 edades cada uno, datos clínicos
2013–2019, radix hipotético de 100.000. Teng et al. (2022), tabla 2: 21
edades de perros del Reino Unido, defunciones entre enero de 2016 y
julio de 2020, denominador inicial de 30.563. No se combinan
poblaciones, ni se usa como tabla tarifaria para mascotas aseguradas.

Ambos originales tienen **CC BY 4.0**, confirmado en los avisos de los
artículos [Montoya](https://pmc.ncbi.nlm.nih.gov/articles/PMC9989186/) y
[Teng](https://pmc.ncbi.nlm.nih.gov/articles/PMC9050668/). Atribución en
inst/COPYRIGHTS. XML de Europe PMC consultados el 2026-11-06; URL y SHA
fijados en
[provenance.csv](https://julianfajardo1908.github.io/tidyactuarial/data-raw/provenance.csv).

| Tabla              | Edades    | qx al final (publicado) | lx al final | ex a edad 0 |
|--------------------|-----------|------------------------:|------------:|------------:|
| Perros EE. UU.     | 0–16, 17+ |                  0,4166 |      13.204 |       12,69 |
| Gatos EE. UU.      | 0–16, 17+ |                  0,4015 |      13.168 |       11,18 |
| Perros Reino Unido | 0–19, 20+ |                       1 |          23 |       11,23 |

Se cotejaron las 57 filas y los 627 campos numéricos o faltantes contra
las transcripciones del kit: cero diferencias. Los campos no publicados
quedan ausentes; se normaliza solo la puntuación de intervalos. El
residuo máximo en `1 - lx_siguiente/lx - qx` antes de la última fila es
0,00049942, compatible con el redondeo; el de `Tx/lx - ex` es 0,0049505
años. No se extrapola ni se impone un qx de cierre uniforme. Los
recuentos de muerte en EE. UU. son de la población del estudio, no
decrementos del radix hipotético. Usar `x,lx` de una sola tabla para
[`t_px()`](https://julianfajardo1908.github.io/tidyactuarial/reference/t_px.md)
con plazo observado; perros EE. UU. de 0 a 5: 0,93223.
