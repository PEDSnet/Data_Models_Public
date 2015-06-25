--=============================================================================
--
-- NAME
--
-- i2b2_omop_mvs.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 11/19/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- NOTE: Under OMOP_ETL schema, please make sure the following tables have data
-- VOCABULARY, CONCEPT, and SOURCE_TO_CONCEPT_MAP.
--
-- DESCRIPTION:
-- Under OMOP_ETL schema run below materialized views, needed for to load data into
-- condition_occurrence table related with ICD9 codes linked to SNOMED.
-- Drop Materialized view MV_OMOP_DX_CODES and recreate MV_OMOP_DX_CODES
-- with associated data. Create MV_PERSON for to populate base population data
-- based on atleast 1 in person clinical encounter on or after January 1st, 2009
-- and atleast 1 coded diagnoses recorded on or after January 1st, 2009 and
-- is not a test patient for to load data into PEDSNET OMOP CDM base table PERSON.
--
--=============================================================================
DROP MATERIALIZED VIEW MV_OMOP_DX_CODES
/
CREATE MATERIALIZED VIEW MV_OMOP_DX_CODES
PCTUSED    0
PCTFREE    0
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOCACHE
NOLOGGING
COMPRESS BASIC
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
WITH PRIMARY KEY
 USING TRUSTED CONSTRAINTS
AS
SELECT STCM.SOURCE_CODE,
       'ICD9:' || STCM.SOURCE_CODE SOURCE_CODE_I2B2_CD,
       STCM.SOURCE_VOCABULARY_ID,
       SV.VOCABULARY_NAME AS SOURCE_VOCABULARY_NAME,
       STCM.SOURCE_CODE_DESCRIPTION,
       STCM.TARGET_CONCEPT_ID,
       STCM.TARGET_VOCABULARY_ID,
       TV.VOCABULARY_NAME AS TARGET_VOCABULARY_NAME,
       C.CONCEPT_CLASS AS TARGET_CLASS,
       C.CONCEPT_LEVEL AS TARGET_LEVEL,
       C.CONCEPT_CODE AS TARGET_CONCEPT_CODE,
       C.CONCEPT_NAME AS TARGET_CONCEPT_NAME,
       STCM.MAPPING_TYPE,
       STCM.PRIMARY_MAP,
       STCM.VALID_START_DATE,
       STCM.VALID_END_DATE,
       STCM.INVALID_REASON
  FROM SOURCE_TO_CONCEPT_MAP STCM
       INNER JOIN VOCABULARY SV
          ON STCM.SOURCE_VOCABULARY_ID = SV.VOCABULARY_ID
       INNER JOIN VOCABULARY TV
          ON STCM.TARGET_VOCABULARY_ID = TV.VOCABULARY_ID
       INNER JOIN CONCEPT C ON STCM.TARGET_CONCEPT_ID = C.CONCEPT_ID
 WHERE     (STCM.INVALID_REASON <> 'D' OR STCM.INVALID_REASON IS NULL)
       AND (STCM.SOURCE_VOCABULARY_ID = 2)                         -- ICD-9-CM
       AND (STCM.TARGET_VOCABULARY_ID = 1)                           -- SNOMED
       AND (STCM.PRIMARY_MAP = 'Y')
       AND (C.INVALID_REASON IS NULL)
/
COMMENT ON MATERIALIZED VIEW MV_OMOP_DX_CODES IS 'snapshot table for snapshot MV_OMOP_DX_CODES'
/
CREATE MATERIALIZED VIEW MV_PERSON
PCTUSED    0
PCTFREE    0
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOCACHE
NOLOGGING
COMPRESS BASIC
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
WITH PRIMARY KEY
 USING TRUSTED CONSTRAINTS
AS
SELECT DISTINCT
       PD.PATIENT_NUM AS PERSON_ID,
       EXTRACT (YEAR FROM PD.BIRTH_DATE) AS YEAR_OF_BIRTH,
       EXTRACT (MONTH FROM (PD.BIRTH_DATE)) AS MONTH_OF_BIRTH,
       EXTRACT (DAY FROM (PD.BIRTH_DATE)) AS DAY_OF_BIRTH,
       MS.DESTINATION_CODE AS GENDER_CONCEPT_ID,
       MR.DESTINATION_CODE AS RACE_CONCEPT_ID,
       ME.DESTINATION_CODE AS ETHNICITY_CONCEPT_ID,
       UPPER (PD.SEX_CD) AS GENDER_SOURCE_VALUE,
       UPPER (PD.RACE_CD) AS RACE_SOURCE_VALUE,
       UPPER (PD.ETHNICITY_CD) AS ETHNICITY_SOURCE_VALUE,
       CAST (PD.PATIENT_NUM AS VARCHAR2 (100)) AS PERSON_SOURCE_VALUE
  FROM PATIENT_DIMENSION PD
       INNER JOIN
       VISIT_DIMENSION VD
          ON     PD.PATIENT_NUM = VD.PATIENT_NUM
             AND VD.start_date > TO_DATE ('2008-12-31', 'YYYY-MM-DD')
       INNER JOIN OBSERVATION_FACT PARTITION (dx) OBF
          ON PD.PATIENT_NUM = OBF.PATIENT_NUM
       INNER JOIN
       OMOP_Mapping MS
          ON     'PERSON' = MS.Destination_Table
             AND 'GENDER_CONCEPT_ID' = MS.Destination_Column
             AND UPPER (NVL (PD.SEX_CD, 'NULL')) = MS.Source_Value
       INNER JOIN
       OMOP_Mapping MR
          ON     'PERSON' = MR.Destination_Table
             AND 'RACE_CONCEPT_ID' = MR.Destination_Column
             AND UPPER (NVL (PD.RACE_CD, 'NULL')) = MR.Source_Value
       INNER JOIN
       OMOP_Mapping ME
          ON     'PERSON' = ME.Destination_Table
             AND 'ETHNICITY_CONCEPT_ID' = ME.Destination_Column
             AND UPPER (NVL (PD.ETHNICITY_CD, 'NULL')) = ME.Source_Value
/
COMMENT ON MATERIALIZED VIEW MV_PERSON IS 'snapshot table for snapshot MV_PERSON'
/
