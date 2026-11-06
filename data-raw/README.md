# Rebuilding the 2023 WPP data

Download the three exact files listed in [provenance.csv](provenance.csv)
to a directory outside the repository. The SHA-256 digests pin the original
archives. [wpp2024-areas.csv](wpp2024-areas.csv) is the selection of 95
official location IDs with the expected UN names, ISO codes and area types.
Select 904 and 927 for the two geographic areas whose labels also occur
under SDG IDs 1830 and 1836.

From the package root, with Python 3.10+ and R with tibble installed:

~~~sh
python data-raw/prepare-wpp2024.py /path/to/originals /path/to/selection.csv
Rscript data-raw/build-mortality-regions.R /path/to/selection.csv
~~~

Both steps run offline. The first selects and validates source keys and
copies the numerical fields; the second checks the annual identities with
allowance for rounding, preserves the open age and saves the xz-compressed
tibble. No terminal age or annual survival beyond the observed table is
imputed. The 100+ row is not an annual death or exposure interval. Keep
the original archives and intermediate CSV out of Git.

The UN Population Division credits [World Population Prospects 2024](https://population.un.org/wpp/)
and identifies [CC BY 3.0 IGO](https://creativecommons.org/licenses/by/3.0/igo/)
in its [data API](https://population.un.org/dataportalapi/index.html) and
[WPP 2024 methodology](https://population.un.org/wpp/assets/Files/WPP2024_Methodology.pdf).
See the installed COPYRIGHTS notice for attribution and changes.
