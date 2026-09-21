# Vaccination Data Analysis and Visualization

**Domain:** Public Health and Epidemiology
**Tools used:** MySQL, Power BI, Python (pandas, matplotlib, seaborn) via Google Colab

## Problem Statement

Analyze global vaccination data to understand trends in vaccination coverage, disease
incidence, and effectiveness. Data was cleaned, stored in a MySQL database, and
connected to Power BI to build interactive dashboards, alongside a separate Python
notebook for exploratory data analysis (EDA).

## Data Source

WHO global immunization dataset, covering vaccine coverage, disease case counts,
vaccine introduction timelines, and vaccination schedules across countries and
WHO regions.

## Database Structure

A MySQL database (`vaccination_project`) with 6 tables, structured as a star schema
with `countries` as the central dimension table:

| Table | Description |
|---|---|
| `countries` | Country code, name, and WHO region (dimension table) |
| `coverage_data` | Vaccination coverage % by country, year, and antigen |
| `coverage_data_aggregate` | Same shape as `coverage_data`, aggregated by group/category — currently empty (0 rows) in the source data |
| `disease_cases` | Reported disease case counts by **WHO region** (not individual country) and year |
| `vaccine_introduction` | Whether/when each vaccine was introduced into a country's program |
| `vaccine_schedule` | Dose schedules, target populations, and age of administration by country |

See `actual_schema.sql` for full table definitions and column types.

**Note on relationships:** `disease_cases` records region using full WHO region names
(e.g. "African Region"), while `countries.who_region` uses short codes (e.g. "AFRO").
A mapping column was added during cleaning (via a Power Query conditional/custom
column) to connect the two tables:

| Full name | Code |
|---|---|
| African Region | AFRO |
| Eastern Mediterranean Region | EMRO |
| European Region | EURO |
| Region of the Americas | AMRO |
| South-East Asia Region | SEARO |
| Western Pacific Region | WPRO |

## Data Cleaning

- Removed duplicate rows across all tables.
- Dropped/filtered rows with missing or out-of-range `coverage` values (kept 0–100%).
- Filtered out negative values in `cases`.
- Standardized `year` to integer type across all date fields.
- Standardized column names to lowercase/snake_case.
- Built the region-code mapping described above to connect `disease_cases` to
  `countries`.

## Power BI Dashboard

Connected Power BI Desktop directly to the MySQL database (MySQL Connector/NET).
Built a single-page dashboard ("Vaccination Coverage Dashboard") including:

- **Headline KPI card** — Average Vaccine Coverage (%) across all records
- **Top 10 countries by coverage** — bar chart
- **Coverage trend by year (2018–2025)** — line chart, showing a dip around 2020
- **Disease cases by WHO region** — bar chart, showing Eastern Mediterranean and
  Western Pacific regions with the highest case totals

*(Add a screenshot or exported PDF of the dashboard here before submitting.)*

## Exploratory Data Analysis (Python / Google Colab)

A separate notebook (`Vaccination_EDA.ipynb`) performs EDA independent of Power BI,
covering:
- Data overview (shape, types, duplicates, missing values) for all 5 source tables
- Data cleaning (see above)
- **20 charts** following the Univariate → Bivariate → Multivariate structure,
  including a correlation heatmap and pair plot, each with a written explanation of
  the chart choice, the insight found, and its potential business impact.

*(Fill in 2-3 headline findings here once the notebook's insight cells are complete,
e.g. "Coverage dropped sharply in 2020 and partially recovered by 2023" or
"[Region] shows the highest disease case burden despite [coverage level] coverage.")*

## Key Insights

*(Summarize 3-5 findings here, tying back to the brief's business use cases —
public health strategy, disease prevention, resource allocation, and global health
policy. Reference specific charts/numbers from the dashboard and notebook above.)*

## Limitations

- The dataset does not include demographic fields (gender, education level,
  urban/rural), so brief questions relying on those cannot be answered from this data.
- `disease_cases` is recorded at the WHO-region level, not per-country, limiting
  country-level disease-burden analysis.
- `coverage_data_aggregate` is present in the schema but contains no data in this
  dataset.

## How to Reproduce

1. **Database:** run `actual_schema.sql` against MySQL to create the schema, then
   load data into each table (MySQL Workbench Table Data Import Wizard, or
   `LOAD DATA INFILE`).
2. **Power BI:** Get Data → MySQL database → connect with `localhost:3306` and the
   `vaccination_project` database → select all tables → build relationships in
   Model view (auto-detected via `country_code`, plus the manual region-code
   relationship for `disease_cases`).
3. **EDA notebook:** open `Vaccination_EDA.ipynb` in Google Colab, export the 6
   MySQL tables as CSVs, upload them when prompted, and run all cells.

## Files in this repository

| File | Purpose |
|---|---|
| `actual_schema.sql` | SQL DDL matching the database as actually built |
| `Vaccination_EDA.ipynb` | EDA notebook — 20 charts with insights |
| `README.md` | This document |
