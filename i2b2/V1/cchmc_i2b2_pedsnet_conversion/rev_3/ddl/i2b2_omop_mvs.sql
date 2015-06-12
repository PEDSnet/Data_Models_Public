--=============================================================================
--
-- NAME
--
-- i2b2_omop_mvs.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 12/11/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- NOTE: Under OMOP_ETL schema, make sure you have select privilege's to pull
-- data from I2B2ETL schema from tables (PATIENT_DIMENSION,VISIT_DIMENSION and
-- OBSERVATION_FACT)
--
-- DESCRIPTION:
-- Under OMOP_ETL schema run below materialized view script, for this release
-- added "ZIP" field.
--
--=============================================================================
DROP MATERIALIZED VIEW MV_PERSON
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
       UPPER (PD.ZIP_CD) AS ZIP,
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
