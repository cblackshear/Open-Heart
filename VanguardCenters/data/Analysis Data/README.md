# Introduction
These programs are used to create the CCDC’s derived variables for participants across the study. Descriptions of variables contained in the analysis datasets are available in the [Analysis Data Dictionary](https://docs.google.com/spreadsheets/d/1xAoVWFYKDURl6PUCy5y32ffUUFv54ytZ8H1YuCx9LO4/edit?usp=sharing).

- Cross-Sectional variables for participants at [exam visit 1](https://www.jacksonheartstudy.org/Portals/0/pdf/analysis1.pdf "Exam Visit 1 Codebook"), [exam visit 2](https://www.jacksonheartstudy.org/Portals/0/pdf/analysis2.pdf "Exam Visit 2 Codebook"), and [exam visit 3](https://www.jacksonheartstudy.org/Portals/0/pdf/analysis3.pdf "Exam Visit 3 Codebook"):
  - **analysis1**, **analysis2**, and **analysis3** programs are used to create the analysis-ready data
  - **validation1**, **validation2**, and **validation3** programs are used to perform QC on the prepared data

- Longitudinal variables for participants across all visits:
  - A [long-form](https://github.com/cblackshear/Open-Heart/wiki/Frequently-Asked-Questions-%28FAQ%29/_edit#what-is-a-long-form-data-set "multiple observations per participant – one per visit") dataset, [`analysisLong`](https://www.jacksonheartstudy.org/Portals/0/pdf/analysislong.pdf "All-Exam (Long-Form) Codebook"), is compiled from the cross-sectional datasets created above
  - A [wide-form](https://github.com/cblackshear/Open-Heart/wiki/Frequently-Asked-Questions-%28FAQ%29/_edit#what-is-a-wide-format-data-set "one observation per participant where the variables reflect a single visit") dataset, [`analysisWide`](https://www.jacksonheartstudy.org/Portals/0/pdf/analysiswide.pdf "All-Exam (Wide-Form) Codebook"), is compiled by transposing the long-form data.

# How to Use
The `0-0 RUNanalyses` file runs the other programs for creation of the analysis datasets.

# Frequently Asked Questions (FAQ)

**How are the analysis datasets derived?**
> Variables that have been derived by the JHS CCDC are added to the analysis datasets. Documentation of these datasets is available in the [Analysis Data Dictionary](https://docs.google.com/spreadsheets/d/1xAoVWFYKDURl6PUCy5y32ffUUFv54ytZ8H1YuCx9LO4/edit?usp=sharing). This analysis data dictionary gives the description and definition of the derived variables as well as the “raw” variables the derivation utilizes. References for definitions, when available, are listed in the “reference” column of the data dictionary.
