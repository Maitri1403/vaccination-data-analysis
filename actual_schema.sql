-- ============================================================
-- Vaccination Data Analysis - Actual Database Schema (as built)
-- Star schema: 1 dimension table (countries) + 5 fact tables
-- ============================================================

CREATE DATABASE IF NOT EXISTS vaccination_project;
USE vaccination_project;

-- ------------------------------------------------------------
-- Dimension table: Countries
-- ------------------------------------------------------------
CREATE TABLE countries (
    country_code   VARCHAR(3)  PRIMARY KEY,   -- ISO Alpha-3 code, e.g. 'IND'
    country_name   VARCHAR(100) NOT NULL,
    who_region     VARCHAR(10)                -- e.g. AFRO, EMRO, EURO, AMRO, SEARO, WPRO
);

-- ------------------------------------------------------------
-- Table: coverage_data
-- % of target population vaccinated, by country/year/antigen
-- ------------------------------------------------------------
CREATE TABLE coverage_data (
    id                             INT AUTO_INCREMENT PRIMARY KEY,
    country_code                   VARCHAR(3),
    country_name                   VARCHAR(100),
    year                            INT,
    antigen                         VARCHAR(20),
    antigen_description             VARCHAR(255),
    coverage_category               VARCHAR(50),
    coverage_category_description   VARCHAR(255),
    group_type                      VARCHAR(50),
    target_number                   BIGINT,
    doses                           BIGINT,
    coverage                        DECIMAL(6,2),   -- percentage, e.g. 87.50
    FOREIGN KEY (country_code) REFERENCES countries(country_code)
);

-- ------------------------------------------------------------
-- Table: coverage_data_aggregate
-- Same shape as coverage_data, aggregated by group_type/coverage_category.
-- NOTE: this table is currently EMPTY (0 rows) in the working database.
-- ------------------------------------------------------------
CREATE TABLE coverage_data_aggregate (
    id                     INT AUTO_INCREMENT PRIMARY KEY,
    group_type             VARCHAR(50),
    year                    INT,
    antigen                  VARCHAR(20),
    antigen_description      VARCHAR(255),
    coverage_category        VARCHAR(50),
    target_number             BIGINT,
    doses                      BIGINT,
    coverage                    DECIMAL(6,2)
);

-- ------------------------------------------------------------
-- Table: disease_cases
-- Reported disease case counts, by WHO REGION (not country) / year
-- ------------------------------------------------------------
CREATE TABLE disease_cases (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    region     VARCHAR(100),   -- WHO region full name, e.g. "African Region"
    disease    VARCHAR(100),
    year        INT,
    cases       BIGINT
);

-- ------------------------------------------------------------
-- Table: vaccine_introduction
-- Whether/when a vaccine was introduced in a country's program
-- ------------------------------------------------------------
CREATE TABLE vaccine_introduction (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    country_code  VARCHAR(3),
    country_name  VARCHAR(100),
    who_region    VARCHAR(10),
    year           INT,
    antigen        VARCHAR(20),
    description     VARCHAR(255),   -- vaccine name/type
    intro           VARCHAR(10),    -- Yes/No
    FOREIGN KEY (country_code) REFERENCES countries(country_code)
);

-- ------------------------------------------------------------
-- Table: vaccine_schedule
-- Dose schedules, target populations, age of administration
-- ------------------------------------------------------------
CREATE TABLE vaccine_schedule (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    country_code        VARCHAR(3),
    country_name        VARCHAR(100),
    disease_code         VARCHAR(20),
    disease_description   VARCHAR(255),
    age_administered       VARCHAR(50),
    schedule_rounds         VARCHAR(20),
    scheduler_code           VARCHAR(20),
    geoarea                   VARCHAR(100),
    FOREIGN KEY (country_code) REFERENCES countries(country_code)
);

-- ------------------------------------------------------------
-- Region-code bridge (added during cleaning)
-- disease_cases.region uses full WHO region names (e.g. "African Region"),
-- while countries.who_region uses short codes (e.g. "AFRO"). A mapping
-- column was added in Power Query to connect the two:
--   African Region              -> AFRO
--   Eastern Mediterranean Region -> EMRO
--   European Region              -> EURO
--   Region of the Americas       -> AMRO
--   South-East Asia Region       -> SEARO
--   Western Pacific Region       -> WPRO
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- Indexes
-- ------------------------------------------------------------
CREATE INDEX idx_coverage_year     ON coverage_data(year);
CREATE INDEX idx_coverage_country  ON coverage_data(country_code);
CREATE INDEX idx_cases_year        ON disease_cases(year);
CREATE INDEX idx_intro_country     ON vaccine_introduction(country_code);
