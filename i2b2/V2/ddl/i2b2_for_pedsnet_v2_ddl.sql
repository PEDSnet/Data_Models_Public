-- Based on https://github.com/PEDSnet/pedsnetcdms/blob/9db9b2dfa8c5176645ee52b4510dc7df1dee58d9/pedsnetcdms/ddloutput/itwobtwocdm/I2B2_CDM_pgsql.ddl
-- Changes therefrom:
-- * patient_dimension table: added gestational_age_num
-- * visit_dimension table: added provider_id, disch_disp_destcd, disch_status_destcd, admit_src_destcd
-- * added provider_dimension table

DROP TABLE IF EXISTS observation_fact;
DROP TABLE IF EXISTS provider_dimension;
DROP TABLE IF EXISTS visit_dimension;
DROP TABLE IF EXISTS patient_dimension;
DROP TABLE IF EXISTS concept_dimension;
DROP TABLE IF EXISTS i2b2;

CREATE TABLE observation_fact (
    provider_id VARCHAR(50) NOT NULL,
    nval_num NUMERIC(18, 5),
    confidence_num NUMERIC(18, 5),
    encounter_num NUMERIC(38, 0) NOT NULL,
    update_date TIMESTAMP WITHOUT TIME ZONE,
    download_date TIMESTAMP WITHOUT TIME ZONE,
    import_date TIMESTAMP WITHOUT TIME ZONE,
    valueflag_cd VARCHAR(50),
    tval_char VARCHAR(255),
    modifier_cd VARCHAR(100) NOT NULL,
    start_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    patient_num NUMERIC(38, 0) NOT NULL,
    end_date TIMESTAMP WITHOUT TIME ZONE,
    instance_num NUMERIC(18, 0) DEFAULT '1' NOT NULL,
    sourcesystem_cd VARCHAR(50),
    concept_cd VARCHAR(50) NOT NULL,
    observation_blob TEXT,
    upload_id NUMERIC(38, 0),
    quantity_num NUMERIC(18, 5),
    valtype_cd VARCHAR(50),
    units_cd VARCHAR(50),
    location_cd VARCHAR(50)
);

CREATE TABLE concept_dimension (
    concept_cd VARCHAR(50) NOT NULL,
    update_date TIMESTAMP WITHOUT TIME ZONE,
    concept_blob TEXT,
    download_date TIMESTAMP WITHOUT TIME ZONE,
    name_char VARCHAR(2000),
    concept_path VARCHAR(700) NOT NULL,
    import_date TIMESTAMP WITHOUT TIME ZONE,
    upload_id NUMERIC(38, 0),
    sourcesystem_cd VARCHAR(50)
);

CREATE TABLE patient_dimension (
    update_date TIMESTAMP WITHOUT TIME ZONE,
    zip_cd VARCHAR(50),
    race_cd VARCHAR(50),
    download_date TIMESTAMP WITHOUT TIME ZONE,
    death_date TIMESTAMP WITHOUT TIME ZONE,
    marital_status_cd VARCHAR(50),
    import_date TIMESTAMP WITHOUT TIME ZONE,
    patient_blob TEXT,
    vital_status_cd VARCHAR(50),
    income_cd VARCHAR(50),
    religion_cd VARCHAR(50),
    sex_cd VARCHAR(50),
    patient_num NUMERIC(38, 0) NOT NULL,
    age_in_years_num NUMERIC(38, 0),
    birth_date TIMESTAMP WITHOUT TIME ZONE,
    upload_id NUMERIC(38, 0),
    statecityzip_path VARCHAR(50),
    language_cd VARCHAR(50),
    ethnicity_cd VARCHAR(50),
    sourcesystem_cd VARCHAR(50),
    gestational_age_num NUMERIC(38)
);

CREATE TABLE i2b2 (
    c_columndatatype VARCHAR(50) NOT NULL,
    c_dimcode VARCHAR(700) NOT NULL,
    c_name VARCHAR(2000) NOT NULL,
    c_facttablecolumn VARCHAR(50) NOT NULL,
    c_basecode VARCHAR(50),
    c_fullname VARCHAR(700) NOT NULL,
    c_tablename VARCHAR(50) NOT NULL,
    update_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    m_exclusion_cd VARCHAR(25),
    c_synonym_cd VARCHAR(1) NOT NULL,
    valuetype_cd VARCHAR(50),
    import_date TIMESTAMP WITHOUT TIME ZONE,
    c_visualattributes VARCHAR(3) NOT NULL,
    c_symbol VARCHAR(50),
    m_applied_path VARCHAR(700) NOT NULL,
    download_date TIMESTAMP WITHOUT TIME ZONE,
    c_operator VARCHAR(10) NOT NULL,
    sourcesystem_cd VARCHAR(50),
    c_hlevel NUMERIC(22, 0) NOT NULL,
    c_columnname VARCHAR(50) NOT NULL,
    c_totalnum NUMERIC(22, 0),
    c_metadataxml TEXT,
    c_tooltip VARCHAR(900),
    c_comment TEXT,
    c_path VARCHAR(700)
);

CREATE TABLE visit_dimension (
    update_date TIMESTAMP WITHOUT TIME ZONE,
    download_date TIMESTAMP WITHOUT TIME ZONE,
    end_date TIMESTAMP WITHOUT TIME ZONE,
    active_status_cd VARCHAR(50),
    import_date TIMESTAMP WITHOUT TIME ZONE,
    upload_id NUMERIC(38, 0),
    patient_num NUMERIC(38, 0) NOT NULL,
    sourcesystem_cd VARCHAR(50),
    inout_cd VARCHAR(50),
    location_path VARCHAR(900),
    length_of_stay NUMERIC(38, 0),
    visit_blob TEXT,
    start_date TIMESTAMP WITHOUT TIME ZONE,
    location_cd VARCHAR(50),
    encounter_num NUMERIC(38, 0) NOT NULL,
    provider_id          NUMERIC(38, 0),
    disch_disp_destcd    VARCHAR(50),
    disch_status_destcd  VARCHAR(50),
    admit_src_destcd     VARCHAR(50)
);

CREATE TABLE provider_dimension
(
    provider_id             VARCHAR(50)     NOT NULL,
    provider_path           VARCHAR(700)    NOT NULL,
    name_char               VARCHAR(850),
    provider_blob           TEXT,
    update_date             TIMESTAMP WITHOUT TIME ZONE,
    download_date           TIMESTAMP WITHOUT TIME ZONE,
    import_date             TIMESTAMP WITHOUT TIME ZONE,
    sourcesystem_cd         VARCHAR(50),
    upload_id               NUMERIC(38),
    gender_cd               VARCHAR(254),
    npi                     VARCHAR(50),
    dea                     VARCHAR(50),
    department_id           NUMERIC(38),
    department_name         VARCHAR(254),
    specialty_source_c      VARCHAR(254),
    specialty_source_value  VARCHAR(254)
);
