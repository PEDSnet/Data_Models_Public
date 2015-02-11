--=============================================================================
--
-- NAME
--
-- i2b2_omop_base_setup_ddls.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 11/19/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
-- Tablespace : I2B2DAT
--
-- DESCRIPTION:
-- Under OMOP_ETL schema, run the below base create table statements.
-- Note: Drop all the tables if exists in this schema OMOP_ETL and recreate
-- by running create statements in particular order mentioned below.
--
--=============================================================================
CREATE TABLE OMOP_ETL.TBL_ERR_MSG
(
  MODULE_NAME  VARCHAR2(150 BYTE),
  ERR_MSG      VARCHAR2(4000 CHAR),
  ERR_TIME     TIMESTAMP(6)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    0
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          32K
            NEXT             32K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
CACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
ENABLE ROW MOVEMENT
/
CREATE TABLE OMOP_ETL.TBL_ERR_MSG_ARCH
(
  MODULE_NAME  VARCHAR2(150 BYTE),
  ERR_MSG      VARCHAR2(4000 CHAR),
  ERR_TIME     TIMESTAMP(6)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    0
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          32K
            NEXT             32K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
CACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
ENABLE ROW MOVEMENT
/
CREATE TABLE OMOP_ETL.OMOP_ERROR_LOG
(
  ERROR_ID            NUMBER(38)                NOT NULL,
  ERROR_PROCESS_ID    NUMBER(38),
  ERROR_LOGTIME       DATE                      DEFAULT NULL,
  ERROR_SERVERNAME    VARCHAR2(100 BYTE),
  ERROR_DATABASENAME  VARCHAR2(100 BYTE),
  ERROR_PACKAGE       VARCHAR2(100 BYTE),
  ERROR_PROCEDURE     VARCHAR2(100 BYTE),
  ERROR_NUMBER        VARCHAR2(20 BYTE),
  ERROR_LINE          NUMBER(38),
  ERROR_MESSAGE       VARCHAR2(1000 BYTE),
  ERROR_COMMENT       VARCHAR2(1000 BYTE),
  ERROR_STATE         NUMBER(38),
  ERROR_SEVERITY      NUMBER(38),
  ERROR_NESTEDLEVEL   NUMBER(38),
  ERROR_USER          VARCHAR2(100 BYTE),
  ERROR_HOST          VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
CREATE GLOBAL TEMPORARY TABLE OMOP_ETL.OMOP_ETL_GEN_MAP
(
  gen_ancestor_concept_id   INTEGER,
  gen_person_id             INTEGER not null,
  gen_start_date            DATE not null,
  gen_end_date              DATE,
  gen_descendant_concept_id INTEGER not null
)
ON COMMIT PRESERVE ROWS
/
CREATE TABLE OMOP_ETL.OMOP_ETL_VOCAB_MAP
(
  GEN_VOC_ANCESTOR_CONCEPT_ID    INTEGER,
  GEN_VOC_DESCENDANT_CONCEPT_ID  INTEGER
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC  
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
CREATE TABLE OMOP_ETL.OMOP_MAPPING
(
  DESTINATION_TABLE      VARCHAR2(50 BYTE)      NOT NULL,
  DESTINATION_COLUMN     VARCHAR2(50 BYTE)      NOT NULL,
  SOURCE_VALUE           VARCHAR2(50 BYTE),
  DESTINATION_VALUE      VARCHAR2(50 BYTE),
  DESTINATION_CODE       NUMBER(38),
  DESTINATION_DESC       VARCHAR2(100 BYTE),
  OBSERVATION_TYPE_CODE  NUMBER(38),
  OBSERVATION_TYPE_DESC  VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
CREATE TABLE OMOP_ETL.OMOP_PROCESS_LOG
(
  PROCESS_ID     NUMBER(38)                     NOT NULL,
  PROCESS_NAME   VARCHAR2(100 BYTE)             NOT NULL,
  START_DATE     DATE                           NOT NULL,
  END_DATE       DATE,
  PROCESS_TIME   INTERVAL DAY(2) TO SECOND(6) GENERATED ALWAYS AS (("END_DATE"-"START_DATE")DAY(9) TO SECOND(6)),
  IS_SUCCESSFUL  VARCHAR2(5 BYTE),
  LOAD_CNT       NUMBER,
  ERROR_CNT      NUMBER
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
CREATE TABLE OMOP_ETL.OMOP_TABLES
(
  TABLE_NAME  VARCHAR2(50 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
CREATE UNIQUE INDEX OMOP_ETL.OMOP_ERROR_LOG_PK ON OMOP_ETL.OMOP_ERROR_LOG
(ERROR_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.OMOP_MAPPING_INDEX ON OMOP_ETL.OMOP_MAPPING
(DESTINATION_TABLE, DESTINATION_COLUMN, SOURCE_VALUE)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.OMOP_PROCESS_LOG_PK ON OMOP_ETL.OMOP_PROCESS_LOG
(PROCESS_ID, START_DATE, PROCESS_NAME)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE OR REPLACE TRIGGER OMOP_ETL.OMOP_ERROR_LOG_TRG 
BEFORE INSERT ON OMOP_ETL.OMOP_ERROR_LOG 
FOR EACH ROW
BEGIN
  <<COLUMN_SEQUENCES>>
  BEGIN
    IF INSERTING AND :NEW.ERROR_ID IS NULL THEN
      SELECT OMOP_ERROR_LOG_SEQ.NEXTVAL INTO :NEW.ERROR_ID FROM SYS.DUAL;
    END IF;
  END COLUMN_SEQUENCES;
END;
/
ALTER TABLE OMOP_ETL.OMOP_ERROR_LOG ADD (
  CONSTRAINT OMOP_ERROR_LOG_PK
  PRIMARY KEY
  (ERROR_ID)
  USING INDEX OMOP_ETL.OMOP_ERROR_LOG_PK
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.OMOP_PROCESS_LOG ADD (
  CONSTRAINT OMOP_PROCESS_LOG_PK
  PRIMARY KEY
  (PROCESS_ID, START_DATE, PROCESS_NAME)
  USING INDEX OMOP_ETL.OMOP_PROCESS_LOG_PK
  ENABLE VALIDATE)
/
CREATE TABLE OMOP_ETL.CARE_SITE
(
  CARE_SITE_ID                   NUMBER(19)     NOT NULL,
  LOCATION_ID                    NUMBER(19),
  ORGANIZATION_ID                NUMBER(19)     NOT NULL,
  PLACE_OF_SERVICE_CONCEPT_ID    NUMBER(10),
  CARE_SITE_SOURCE_VALUE         VARCHAR2(100 BYTE) NOT NULL,
  PLACE_OF_SERVICE_SOURCE_VALUE  VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.CARE_SITE IS 'Information about the site of care.'
/
COMMENT ON COLUMN OMOP_ETL.CARE_SITE.CARE_SITE_ID IS 'A system-generated unique identifier for each care site. A care site is the place where the provider delivered the healthcare to the person.'
/
COMMENT ON COLUMN OMOP_ETL.CARE_SITE.LOCATION_ID IS 'A foreign key to the geographic location in the location table, where the detailed address information is stored.'
/
COMMENT ON COLUMN OMOP_ETL.CARE_SITE.ORGANIZATION_ID IS 'A foreign key to the organization in the organization table, where the detailed information is stored.'
/
COMMENT ON COLUMN OMOP_ETL.CARE_SITE.PLACE_OF_SERVICE_CONCEPT_ID IS 'A foreign key to the predefined concept identifier in the vocabulary reflecting the place of service.'
/
COMMENT ON COLUMN OMOP_ETL.CARE_SITE.CARE_SITE_SOURCE_VALUE IS 'The identifier for the care site as it appears in the source data, stored here for reference.'
/
COMMENT ON COLUMN OMOP_ETL.CARE_SITE.PLACE_OF_SERVICE_SOURCE_VALUE IS 'The source code for the place of service as it appears in the source data, stored here for reference.'
/
CREATE TABLE OMOP_ETL.COHORT
(
  COHORT_ID          NUMBER(19)                 NOT NULL,
  COHORT_CONCEPT_ID  NUMBER(10)                 NOT NULL,
  COHORT_START_DATE  DATE                       NOT NULL,
  COHORT_END_DATE    DATE,
  SUBJECT_ID         NUMBER(19)                 NOT NULL,
  STOP_REASON        VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.COHORT IS 'Person, Provider or Visit cohorts.'
/
COMMENT ON COLUMN OMOP_ETL.COHORT.COHORT_ID IS 'A system-generated unique identifier for each cohort record.'
/
COMMENT ON COLUMN OMOP_ETL.COHORT.COHORT_CONCEPT_ID IS 'A foreign key to a standard cohort concept identifier in the vocabulary. Cohort concepts identify the cohorts: whether they are defined through persons, providers or visits, or any combination thereof.'
/
COMMENT ON COLUMN OMOP_ETL.COHORT.COHORT_START_DATE IS 'The date when the cohort definition criteria for the person, provider or visit first match.'
/
COMMENT ON COLUMN OMOP_ETL.COHORT.COHORT_END_DATE IS 'The date when the cohort definition criteria for the person, provider or visit no longer match or the cohort membership was terminated.'
/
COMMENT ON COLUMN OMOP_ETL.COHORT.SUBJECT_ID IS 'A foreign key to the subject in the cohort. These could be referring to records in the Person, Provider, Visit Occurrence table.'
/
COMMENT ON COLUMN OMOP_ETL.COHORT.STOP_REASON IS 'The reason for the end of a cohort membership other than defined by the cohort definition criteria as it appears in the source data.'
/
CREATE TABLE OMOP_ETL.CONDITION_ERA
(
  CONDITION_ERA_ID            NUMBER(19)        NOT NULL,
  PERSON_ID                   NUMBER(19)        NOT NULL,
  CONDITION_CONCEPT_ID        NUMBER(10)        NOT NULL,
  CONDITION_ERA_START_DATE    DATE              NOT NULL,
  CONDITION_ERA_END_DATE      DATE              NOT NULL,
  CONDITION_TYPE_CONCEPT_ID   NUMBER(10)        NOT NULL,
  CONDITION_OCCURRENCE_COUNT  NUMBER(10)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.CONDITION_ERA IS 'A diagnoses or conditions that over a period of time.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_ERA.CONDITION_ERA_ID IS 'A system-generated unique identifier for each condition era.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_ERA.PERSON_ID IS 'A foreign key identifier to the person who is experiencing the condition during the condition era. The demographic details of that person are stored in the person table.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_ERA.CONDITION_CONCEPT_ID IS 'A foreign key that refers to a standard condition concept identifier in the vocabulary. '
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_ERA.CONDITION_ERA_START_DATE IS 'The start date for the condition era constructed from the individual instances of condition occurrences. It is the start date of the very first chronologically recorded instance of the condition.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_ERA.CONDITION_ERA_END_DATE IS 'The end date for the condition era constructed from the individual instances of condition occurrences. It is the end date of the final continuously recorded instance of the condition.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_ERA.CONDITION_TYPE_CONCEPT_ID IS ' A foreign key to the predefined concept identifier in the vocabulary reflecting the parameters used to construct the condition era. For a detailed current listing of condition types see Appendix B: Condition Type Concepts.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_ERA.CONDITION_OCCURRENCE_COUNT IS 'The number of individual condition occurrences used to construct the condition era.'
/
CREATE UNIQUE INDEX OMOP_ETL.CARE_SITE_PKEY ON OMOP_ETL.CARE_SITE
(CARE_SITE_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.COHORT_PKEY ON OMOP_ETL.COHORT
(COHORT_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.CONDITION_ERA_PKEY ON OMOP_ETL.CONDITION_ERA
(CONDITION_ERA_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
ALTER TABLE OMOP_ETL.CARE_SITE ADD (
  CONSTRAINT CARE_SITE_PKEY
  PRIMARY KEY
  (CARE_SITE_ID)
  USING INDEX OMOP_ETL.CARE_SITE_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.COHORT ADD (
  CONSTRAINT COHORT_PKEY
  PRIMARY KEY
  (COHORT_ID)
  USING INDEX OMOP_ETL.COHORT_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.CONDITION_ERA ADD (
  CONSTRAINT CONDITION_ERA_PKEY
  PRIMARY KEY
  (CONDITION_ERA_ID)
  USING INDEX OMOP_ETL.CONDITION_ERA_PKEY
  ENABLE VALIDATE)
/
CREATE TABLE OMOP_ETL.CONDITION_OCCURRENCE
(
  CONDITION_OCCURRENCE_ID    NUMBER(19)         NOT NULL,
  PERSON_ID                  NUMBER(19)         NOT NULL,
  CONDITION_CONCEPT_ID       NUMBER(10)         NOT NULL,
  CONDITION_START_DATE       DATE               NOT NULL,
  CONDITION_END_DATE         DATE,
  CONDITION_TYPE_CONCEPT_ID  NUMBER(10)         NOT NULL,
  STOP_REASON                VARCHAR2(100 BYTE),
  ASSOCIATED_PROVIDER_ID     NUMBER(19),
  VISIT_OCCURRENCE_ID        NUMBER(19),
  CONDITION_SOURCE_VALUE     VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.CONDITION_OCCURRENCE IS 'A diagnosis or condition that has been recorded about a person at a certain time.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_OCCURRENCE.CONDITION_OCCURRENCE_ID IS 'A system-generated unique identifier for each condition occurrence event.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_OCCURRENCE.PERSON_ID IS 'A foreign key identifier to the person who is experiencing the condition. The demographic details of that person are stored in the person table.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_OCCURRENCE.CONDITION_CONCEPT_ID IS 'A foreign key that refers to a standard condition concept identifier in the vocabulary.  '
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_OCCURRENCE.CONDITION_START_DATE IS 'The date when the instance of the condition is recorded.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_OCCURRENCE.CONDITION_END_DATE IS 'The date when the instance of the Condition is last
recorded.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_OCCURRENCE.CONDITION_TYPE_CONCEPT_ID IS 'A foreign key to the predefined concept identifier in the vocabulary reflecting the source data from which the condition was recorded, the level of standardization, and the type of occurrence. Conditions are defined as primary or secondary diagnoses, problem lists and person statuses. For a detailed current listing of condition types see Appendix B: Condition Type Concepts.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_OCCURRENCE.STOP_REASON IS 'The reason, if available, that the condition was no longer recorded, as indicated in the source data. Valid values include discharged, resolved, etc.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_OCCURRENCE.ASSOCIATED_PROVIDER_ID IS 'A foreign key to the provider in the provider table who was responsible for determining (diagnosing) the condition.'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_OCCURRENCE.VISIT_OCCURRENCE_ID IS 'A foreign key to the visit in the visit table during which the condition was determined (diagnosed).'
/
COMMENT ON COLUMN OMOP_ETL.CONDITION_OCCURRENCE.CONDITION_SOURCE_VALUE IS 'The source code for the condition as it appears in the source data. This code is mapped to a standard condition concept in the vocabulary and the original code is , stored here for reference. Condition source codes are typically ICD-9-CM diagnosis codes from medical claims or discharge status/disposition codes from EHRs.'
/
CREATE TABLE OMOP_ETL.DEATH
(
  PERSON_ID                    NUMBER(19)       NOT NULL,
  DEATH_DATE                   DATE             NOT NULL,
  DEATH_TYPE_CONCEPT_ID        NUMBER(10)       NOT NULL,
  CAUSE_OF_DEATH_CONCEPT_ID    NUMBER(10),
  CAUSE_OF_DEATH_SOURCE_VALUE  VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.DEATH IS 'Time and cause of death of the Person. '
/
COMMENT ON COLUMN OMOP_ETL.DEATH.PERSON_ID IS 'System-generated foreign key identifier to the deceased person. The demographic details of that person are stored in the person table.'
/
COMMENT ON COLUMN OMOP_ETL.DEATH.DEATH_DATE IS 'The date the person deceased. If the precise date including day or month is not known or not allowed, December is used as the default month, and the last day of the month the default day.'
/
COMMENT ON COLUMN OMOP_ETL.DEATH.DEATH_TYPE_CONCEPT_ID IS 'A foreign key referring to the predefined concept identifier in the vocabulary reflecting how the death was represented in the source data.'
/
COMMENT ON COLUMN OMOP_ETL.DEATH.CAUSE_OF_DEATH_CONCEPT_ID IS 'A foreign key referring to a standard concept identifier in the vocabulary for conditions.'
/
COMMENT ON COLUMN OMOP_ETL.DEATH.CAUSE_OF_DEATH_SOURCE_VALUE IS 'The source code for the cause of death as it appears in the source data. This code is mapped to a standard concept in the vocabulary and the original code is , stored here for reference. '
/
CREATE TABLE OMOP_ETL.DRUG_COST
(
  DRUG_COST_ID                   NUMBER(19)     NOT NULL,
  DRUG_EXPOSURE_ID               NUMBER(19)     NOT NULL,
  PAID_COPAY                     NUMBER(8,2),
  PAID_COINSURANCE               NUMBER(8,2),
  PAID_TOWARD_DEDUCTIBLE         NUMBER(8,2),
  PAID_BY_PAYER                  NUMBER(8,2),
  PAID_BY_COORDINATION_BENEFITS  NUMBER(8,2),
  TOTAL_OUT_OF_POCKET            NUMBER(8,2),
  TOTAL_PAID                     NUMBER(8,2),
  INGREDIENT_COST                NUMBER(8,2),
  DISPENSING_FEE                 NUMBER(8,2),
  AVERAGE_WHOLESALE_PRICE        NUMBER(8,2),
  PAYER_PLAN_PERIOD_ID           NUMBER(19)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.DRUG_COST IS 'For each Drug Exposure record additional information about cost and payments.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.DRUG_COST_ID IS 'A system-generated unique identifier for each drug cost record.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.DRUG_EXPOSURE_ID IS 'A foreign key identifier to the drug record for which cost data are recorded. '
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.PAID_COPAY IS 'The amount paid by the person as a fixed contribution to the expenses. Copay does not contribute to the out_of_pocket expenses.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.PAID_COINSURANCE IS 'The amount paid by the person as a joint assumption of risk. Typically, this is a percentage of the expenses defined by the payer plan (policy) after the person''s deductible is exceeded.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.PAID_TOWARD_DEDUCTIBLE IS 'The amount paid by the person that is counted toward the deductible defined by the payer plan (policy).'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.PAID_BY_PAYER IS 'The amount paid by the payer (insurer). If there is more than one payer, several drug_cost records indicate that fact.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.PAID_BY_COORDINATION_BENEFITS IS 'The amount paid by a secondary payer through the coordination of benefits.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.TOTAL_OUT_OF_POCKET IS 'The total amount paid by the person as a share of the expenses, excluding the copay.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.TOTAL_PAID IS 'The total amount paid for the expenses of drug exposure.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.INGREDIENT_COST IS 'The portion of the drug expenses due to the cost charged by the manufacturer for the drug, typically a percentage of the Average Wholesale Price.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.DISPENSING_FEE IS 'The portion of the drug expenses due to the dispensing fee charged by the pharmacy, typically a fixed amount.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.AVERAGE_WHOLESALE_PRICE IS 'List price of a drug set by the manufacturer.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_COST.PAYER_PLAN_PERIOD_ID IS 'A foreign key to the payer_plan_period table, where the details of the payer, plan and family are stored.'
/
CREATE TABLE OMOP_ETL.DRUG_ERA
(
  DRUG_ERA_ID           NUMBER(19)              NOT NULL,
  PERSON_ID             NUMBER(19)              NOT NULL,
  DRUG_CONCEPT_ID       NUMBER(10)              NOT NULL,
  DRUG_ERA_START_DATE   DATE                    NOT NULL,
  DRUG_ERA_END_DATE     DATE                    NOT NULL,
  DRUG_TYPE_CONCEPT_ID  NUMBER(10)              NOT NULL,
  DRUG_EXPOSURE_COUNT   NUMBER(4)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.DRUG_ERA IS 'Association between a Person and a Drug over a specific time period.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_ERA.DRUG_ERA_ID IS 'A system-generated unique identifier for each drug era.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_ERA.PERSON_ID IS 'A foreign key identifier to the person who is subjected to the drug during the drug era. The demographic details of that person are stored in the person table.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_ERA.DRUG_CONCEPT_ID IS 'A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_ERA.DRUG_ERA_START_DATE IS 'The start date for the drug era constructed from the individual instances of drug exposures. It is the start date of the very first chronologically recorded instance of utilization of a drug.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_ERA.DRUG_ERA_END_DATE IS 'The end date for the drug era constructed from the individual instance of drug exposures. It is the end date of the final continuously recorded instance of utilization of a drug.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_ERA.DRUG_TYPE_CONCEPT_ID IS ' A foreign key to the predefined concept identifier in the vocabulary reflecting the parameters used to construct the drug era. For a detailed current listing of drug types see Appendix A: Drug Type Codes.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_ERA.DRUG_EXPOSURE_COUNT IS 'The number of individual drug exposure occurrences used to construct the drug era.'
/
CREATE TABLE OMOP_ETL.DRUG_EXPOSURE
(
  DRUG_EXPOSURE_ID               NUMBER(19)     NOT NULL,
  PERSON_ID                      NUMBER(19)     NOT NULL,
  DRUG_CONCEPT_ID                NUMBER(10)     NOT NULL,
  DRUG_EXPOSURE_START_DATE       DATE           NOT NULL,
  DRUG_EXPOSURE_END_DATE         DATE,
  DRUG_TYPE_CONCEPT_ID           NUMBER(10)     NOT NULL,
  STOP_REASON                    VARCHAR2(100 BYTE),
  REFILLS                        NUMBER(10),
  QUANTITY                       NUMBER(10),
  DAYS_SUPPLY                    NUMBER(10),
  SIG                            VARCHAR2(500 BYTE),
  PRESCRIBING_PROVIDER_ID        NUMBER(19),
  VISIT_OCCURRENCE_ID            NUMBER(19),
  RELEVANT_CONDITION_CONCEPT_ID  NUMBER(10),
  DRUG_SOURCE_VALUE              VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.DRUG_EXPOSURE IS 'Association between a Person and a Drug at a specific time.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.DRUG_EXPOSURE_ID IS 'A system-generated unique identifier for each drug utilization event.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.PERSON_ID IS 'System-generated foreign key identifier for the person who is subjected to the drug. The demographic details of that person are stored in the person table.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.DRUG_CONCEPT_ID IS 'A foreign key that refers to a standard concept identifier in the vocabulary for the drug concept.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.DRUG_EXPOSURE_START_DATE IS 'The start date for the current instance of drug utilization. Valid entries include a start date of a prescription, the date a prescription was filled, or the date on which a drug administration procedure was recorded.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.DRUG_EXPOSURE_END_DATE IS 'The end date for the current instance of drug utilization. It is not available from all sources.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.DRUG_TYPE_CONCEPT_ID IS ' A foreign key to the predefined concept identifier in the vocabulary reflecting the type of drug exposure recorded. It indicates how the drug exposure was represented in the source data: as medication history, filled prescriptions, etc. For a detailed current listing of drug types see Appendix A: Drug Type Codes'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.STOP_REASON IS 'The reason the medication was stopped, where available. Reasons include regimen completed, changed, removed, etc..'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.REFILLS IS 'The number of refills after the initial prescription. The initial prescription is not counted,  Values start with 0.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.QUANTITY IS 'The quantity of drug as recorded in the original prescription or dispensing record.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.DAYS_SUPPLY IS 'The number of days of supply of the medication as recorded in the original prescription or dispensing record.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.SIG IS 'The directions ("signetur") on the drug prescription as recorded in the original prescription (and printed on the container) or dispensing record.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.VISIT_OCCURRENCE_ID IS 'A foreign key to the visit in the visit table during which the drug exposure initiated.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.RELEVANT_CONDITION_CONCEPT_ID IS 'A foreign key to the predefined concept identifier in the vocabulary reflecting the condition that was the cause for initiation of the drug exposure. Note that this is not a direct reference to a specific condition record in the condition table, but rather a condition concept in the vocabulary.'
/
COMMENT ON COLUMN OMOP_ETL.DRUG_EXPOSURE.DRUG_SOURCE_VALUE IS 'The source code for the drug as it appears in the source data. This code is mapped to a standard drug concept in the vocabulary and the original code is , stored here for reference.'
/
CREATE UNIQUE INDEX OMOP_ETL.CONDITION_OCCURRENCE_PKEY ON OMOP_ETL.CONDITION_OCCURRENCE
(CONDITION_OCCURRENCE_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.DEATH_PKEY ON OMOP_ETL.DEATH
(PERSON_ID, DEATH_TYPE_CONCEPT_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.DRUG_COST_PKEY ON OMOP_ETL.DRUG_COST
(DRUG_COST_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.DRUG_ERA_PKEY ON OMOP_ETL.DRUG_ERA
(DRUG_ERA_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.DRUG_EXPOSURE_PKEY ON OMOP_ETL.DRUG_EXPOSURE
(DRUG_EXPOSURE_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
ALTER TABLE OMOP_ETL.CONDITION_OCCURRENCE ADD (
  CONSTRAINT CONDITION_OCCURRENCE_PKEY
  PRIMARY KEY
  (CONDITION_OCCURRENCE_ID)
  USING INDEX OMOP_ETL.CONDITION_OCCURRENCE_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.DEATH ADD (
  CONSTRAINT DEATH_PKEY
  PRIMARY KEY
  (PERSON_ID, DEATH_TYPE_CONCEPT_ID)
  USING INDEX OMOP_ETL.DEATH_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.DRUG_COST ADD (
  CONSTRAINT DRUG_COST_PKEY
  PRIMARY KEY
  (DRUG_COST_ID)
  USING INDEX OMOP_ETL.DRUG_COST_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.DRUG_ERA ADD (
  CONSTRAINT DRUG_ERA_PKEY
  PRIMARY KEY
  (DRUG_ERA_ID)
  USING INDEX OMOP_ETL.DRUG_ERA_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.DRUG_EXPOSURE ADD (
  CONSTRAINT DRUG_EXPOSURE_PKEY
  PRIMARY KEY
  (DRUG_EXPOSURE_ID)
  USING INDEX OMOP_ETL.DRUG_EXPOSURE_PKEY
  ENABLE VALIDATE)
/
CREATE TABLE OMOP_ETL.LOCATION
(
  LOCATION_ID            NUMBER(19)             NOT NULL,
  ADDRESS_1              VARCHAR2(100 BYTE),
  ADDRESS_2              VARCHAR2(100 BYTE),
  CITY                   VARCHAR2(50 BYTE),
  STATE                  VARCHAR2(2 BYTE),
  ZIP                    VARCHAR2(9 BYTE),
  COUNTY                 VARCHAR2(50 BYTE),
  LOCATION_SOURCE_VALUE  VARCHAR2(300 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.LOCATION IS 'Physical addresses.'
/
COMMENT ON COLUMN OMOP_ETL.LOCATION.LOCATION_ID IS 'A system-generated unique identifier for each geographic location.'
/
COMMENT ON COLUMN OMOP_ETL.LOCATION.ADDRESS_1 IS 'The address field 1, typically used for the street address, as it appears in the source data.'
/
COMMENT ON COLUMN OMOP_ETL.LOCATION.ADDRESS_2 IS 'The address field 2, typically used for additional detail such as buildings, suites, floors, as it appears in the source data.'
/
COMMENT ON COLUMN OMOP_ETL.LOCATION.CITY IS 'The city field as it appears in the source data.'
/
COMMENT ON COLUMN OMOP_ETL.LOCATION.STATE IS 'The state field as it appears in the source data.'
/
COMMENT ON COLUMN OMOP_ETL.LOCATION.ZIP IS 'The zip code. For US addresses, valid zip codes can be 3, 5 or 9 digits long, depending on the source data.'
/
COMMENT ON COLUMN OMOP_ETL.LOCATION.COUNTY IS 'The county. The county information is necessary because not all zip codes fall into one and the same county.'
/
COMMENT ON COLUMN OMOP_ETL.LOCATION.LOCATION_SOURCE_VALUE IS 'The verbatim information that is used to uniquely identify the location as it appears in the source data.'
/
CREATE TABLE OMOP_ETL.OBSERVATION
(
  OBSERVATION_ID                 NUMBER(19)     NOT NULL,
  PERSON_ID                      NUMBER(19)     NOT NULL,
  OBSERVATION_CONCEPT_ID         NUMBER(10)     NOT NULL,
  OBSERVATION_DATE               DATE           NOT NULL,
  OBSERVATION_TIME               VARCHAR2(10 BYTE),
  VALUE_AS_NUMBER                NUMBER(14,3),
  VALUE_AS_STRING                VARCHAR2(60 BYTE),
  VALUE_AS_CONCEPT_ID            NUMBER(10),
  UNIT_CONCEPT_ID                NUMBER(10),
  RANGE_LOW                      NUMBER(14,3),
  RANGE_HIGH                     NUMBER(14,3),
  OBSERVATION_TYPE_CONCEPT_ID    NUMBER(10)     NOT NULL,
  ASSOCIATED_PROVIDER_ID         NUMBER(19),
  VISIT_OCCURRENCE_ID            NUMBER(19),
  RELEVANT_CONDITION_CONCEPT_ID  NUMBER(10),
  OBSERVATION_SOURCE_VALUE       VARCHAR2(100 BYTE),
  UNITS_SOURCE_VALUE             VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.OBSERVATION IS 'Symptoms, clinical observations, lab tests etc. about the Person.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.OBSERVATION_ID IS 'A system-generated unique identifier for each observation.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.PERSON_ID IS 'A foreign key identifier to the person about whom the observation was recorded. The demographic details of that person are stored in the person table.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.OBSERVATION_CONCEPT_ID IS 'A foreign key to the standard observation concept identifier in the vocabulary. '
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.OBSERVATION_DATE IS 'The date of the observation'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.OBSERVATION_TIME IS 'The time of the observation'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.VALUE_AS_NUMBER IS 'The observation result stored as a number. This is applicable to observations where the result is expressed as a numeric value.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.VALUE_AS_STRING IS 'The observation result stored as a string. This is applicable to observations where the result is expressed as verbatim text, such as in radiology or pathology report'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.VALUE_AS_CONCEPT_ID IS 'A foreign key to an observation result stored as a concept identifier. This is applicable to observations where the result can be expressed as a standard concept from the vocabulary (e.g., positive/negative, present/absent, low/high, etc.).'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.UNIT_CONCEPT_ID IS 'A foreign key to a standard concept identifier of measurement units in the vocabulary.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.RANGE_LOW IS 'The lower limit of the normal range of the observation. It is not applicable if the observation results are non-numeric or categorical, and must be in the same units of measure as the observation value.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.RANGE_HIGH IS 'The upper limit of the normal range of the observation. It is not applicable if the observation results are non-numeric or categorical, and must be in the same units of measure as the observation value.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.OBSERVATION_TYPE_CONCEPT_ID IS 'A foreign key to the predefined concept identifier in the vocabulary reflecting the type of the observation.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.ASSOCIATED_PROVIDER_ID IS 'A foreign key to the provider in the provider table who was responsible for making the observation.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.VISIT_OCCURRENCE_ID IS 'A foreign key to the visit in the visit table during which the observation was recorded.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.RELEVANT_CONDITION_CONCEPT_ID IS 'A foreign key to the predefined concept identifier in the vocabulary reflecting the condition that was associated with the observation. Note that this is not a direct reference to a specific condition record in the condition table, but rather a condition concept in the vocabulary.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.OBSERVATION_SOURCE_VALUE IS 'The observation code as it appears in the source data. This code is mapped to a standard concept in the vocabulary and the original code is , stored here for reference.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION.UNITS_SOURCE_VALUE IS 'The source code for the unit as it appears in the source data. This code is mapped to a standard unit concept in the vocabulary and the original code is , stored here for reference. '
/
CREATE TABLE OMOP_ETL.OBSERVATION_PERIOD
(
  OBSERVATION_PERIOD_ID          NUMBER(19)     NOT NULL,
  PERSON_ID                      NUMBER(19)     NOT NULL,
  OBSERVATION_PERIOD_START_DATE  DATE           NOT NULL,
  OBSERVATION_PERIOD_END_DATE    DATE           NOT NULL
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.OBSERVATION_PERIOD IS 'Time intervals at which health care information may be available.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION_PERIOD.OBSERVATION_PERIOD_ID IS 'A system-generated unique identifier for each observation period.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION_PERIOD.PERSON_ID IS 'A foreign key identifier to the person for whom the observation period is defined. The demographic details of that person are stored in the person table.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION_PERIOD.OBSERVATION_PERIOD_START_DATE IS 'The start date of the observation period for which data are available from the data source.'
/
COMMENT ON COLUMN OMOP_ETL.OBSERVATION_PERIOD.OBSERVATION_PERIOD_END_DATE IS 'The end date of the observation period for which data are available from the data source.'
/
CREATE UNIQUE INDEX OMOP_ETL.LOCATION_PKEY ON OMOP_ETL.LOCATION
(LOCATION_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.OBSERVATION_PERIOD_PERSON ON OMOP_ETL.OBSERVATION_PERIOD
(PERSON_ID, OBSERVATION_PERIOD_START_DATE)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.OBSERVATION_PERIOD_PKEY ON OMOP_ETL.OBSERVATION_PERIOD
(OBSERVATION_PERIOD_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE INDEX OMOP_ETL.OBSERVATION_PERSON_IDX ON OMOP_ETL.OBSERVATION
(PERSON_ID, OBSERVATION_CONCEPT_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
NOPARALLEL
/
CREATE UNIQUE INDEX OMOP_ETL.OBSERVATION_PKEY ON OMOP_ETL.OBSERVATION
(OBSERVATION_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
ALTER TABLE OMOP_ETL.LOCATION ADD (
  CONSTRAINT LOCATION_PKEY
  PRIMARY KEY
  (LOCATION_ID)
  USING INDEX OMOP_ETL.LOCATION_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.OBSERVATION ADD (
  CONSTRAINT OBSERVATION_PKEY
  PRIMARY KEY
  (OBSERVATION_ID)
  USING INDEX OMOP_ETL.OBSERVATION_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.OBSERVATION_PERIOD ADD (
  CONSTRAINT OBSERVATION_PERIOD_PKEY
  PRIMARY KEY
  (OBSERVATION_PERIOD_ID)
  USING INDEX OMOP_ETL.OBSERVATION_PERIOD_PKEY
  ENABLE VALIDATE)
/
CREATE TABLE OMOP_ETL.ORGANIZATION
(
  ORGANIZATION_ID                NUMBER(19)     NOT NULL,
  PLACE_OF_SERVICE_CONCEPT_ID    NUMBER(10),
  LOCATION_ID                    NUMBER(19),
  ORGANIZATION_SOURCE_VALUE      VARCHAR2(50 BYTE) NOT NULL,
  PLACE_OF_SERVICE_SOURCE_VALUE  VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.ORGANIZATION IS 'Information about health care organizations. '
/
COMMENT ON COLUMN OMOP_ETL.ORGANIZATION.ORGANIZATION_ID IS 'A system-generated unique identifier for each organization. Here, an organization is defined as a collection of one or more care sites that share a single EHR database.'
/
COMMENT ON COLUMN OMOP_ETL.ORGANIZATION.PLACE_OF_SERVICE_CONCEPT_ID IS 'A foreign key that refers to a place of service concept identifier in the vocabulary.'
/
COMMENT ON COLUMN OMOP_ETL.ORGANIZATION.LOCATION_ID IS 'A foreign key to the geographic location of the administrative offices in the location table, where the detailed address information is stored.'
/
COMMENT ON COLUMN OMOP_ETL.ORGANIZATION.ORGANIZATION_SOURCE_VALUE IS 'The identifier for the organization in the source data , stored here for reference.'
/
COMMENT ON COLUMN OMOP_ETL.ORGANIZATION.PLACE_OF_SERVICE_SOURCE_VALUE IS 'The source code for the place of service as it appears in the source data, stored here for reference.'
/
CREATE TABLE OMOP_ETL.PAYER_PLAN_PERIOD
(
  PAYER_PLAN_PERIOD_ID          NUMBER(19)      NOT NULL,
  PERSON_ID                     NUMBER(19)      NOT NULL,
  PAYER_PLAN_PERIOD_START_DATE  DATE            NOT NULL,
  PAYER_PLAN_PERIOD_END_DATE    DATE            NOT NULL,
  PAYER_SOURCE_VALUE            VARCHAR2(100 BYTE),
  PLAN_SOURCE_VALUE             VARCHAR2(100 BYTE),
  FAMILY_SOURCE_VALUE           VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.PAYER_PLAN_PERIOD IS 'Information about the coverage plan of the payer.'
/
COMMENT ON COLUMN OMOP_ETL.PAYER_PLAN_PERIOD.PAYER_PLAN_PERIOD_ID IS 'A system-generated identifier for each unique combination of payer, plan, family code and time span'
/
COMMENT ON COLUMN OMOP_ETL.PAYER_PLAN_PERIOD.PERSON_ID IS 'A foreign key identifier to the person covered by the payer. The demographic details of that person are stored in the person table.'
/
COMMENT ON COLUMN OMOP_ETL.PAYER_PLAN_PERIOD.PAYER_PLAN_PERIOD_START_DATE IS 'The start date of the payer plan period.'
/
COMMENT ON COLUMN OMOP_ETL.PAYER_PLAN_PERIOD.PAYER_PLAN_PERIOD_END_DATE IS 'The end date of the payer plan period defined for the person.'
/
COMMENT ON COLUMN OMOP_ETL.PAYER_PLAN_PERIOD.PAYER_SOURCE_VALUE IS 'The source code for the payer as it appears in the source data.'
/
COMMENT ON COLUMN OMOP_ETL.PAYER_PLAN_PERIOD.PLAN_SOURCE_VALUE IS 'The source code for the person''s coverage plan as it appears in the source data.'
/
COMMENT ON COLUMN OMOP_ETL.PAYER_PLAN_PERIOD.FAMILY_SOURCE_VALUE IS 'The source code for the person''s family as it appears in the source data.'
/
CREATE TABLE OMOP_ETL.PERSON
(
  PERSON_ID               NUMBER(19)            NOT NULL,
  GENDER_CONCEPT_ID       NUMBER(10)            NOT NULL,
  YEAR_OF_BIRTH           NUMBER(10)            NOT NULL,
  MONTH_OF_BIRTH          NUMBER(10),
  DAY_OF_BIRTH            NUMBER(10),
  RACE_CONCEPT_ID         NUMBER(10),
  ETHNICITY_CONCEPT_ID    NUMBER(10),
  LOCATION_ID             NUMBER(19),
  PROVIDER_ID             NUMBER(19),
  CARE_SITE_ID            NUMBER(19),
  PERSON_SOURCE_VALUE     VARCHAR2(100 BYTE),
  GENDER_SOURCE_VALUE     VARCHAR2(50 BYTE),
  RACE_SOURCE_VALUE       VARCHAR2(50 BYTE),
  ETHNICITY_SOURCE_VALUE  VARCHAR2(50 BYTE),
  PN_GESTATIONAL_AGE      NUMBER(4,2),
  PN_TIME_OF_BIRTH        VARCHAR2(10 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.PERSON IS 'Demographic information about a Person (patient).'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.PERSON_ID IS 'System-generated identifier to uniquely identify each PERSON.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.GENDER_CONCEPT_ID IS 'Foreign key that refers to the standard Concept Code in the Dictionary for the Gender of the Person.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.YEAR_OF_BIRTH IS 'The year of birth of the Person. For data sources with date of birth, only the year is extracted. For data sources where the year of birth is not available, the approximate year of birth is derived based on any age group categorization available.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.MONTH_OF_BIRTH IS 'The month of birth of the person. For data sources that provide the precise date of birth, the month is extracted and stored in this field.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.DAY_OF_BIRTH IS 'The day of the month of birth of the person. For data sources that provide the precise date of birth, the day is extracted and stored in this field.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.RACE_CONCEPT_ID IS 'A foreign key that refers to a standard concept identifier in the vocabulary for the race of the person.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.ETHNICITY_CONCEPT_ID IS 'A foreign key that refers to the standard concept identifier in the vocabulary for the ethnicity of the person.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.LOCATION_ID IS 'A foreign key to the place of residency for the person in the location table, where the detailed address information is stored.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.PROVIDER_ID IS 'A foreign key to the primary care provider the person is seeing in the provider table.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.CARE_SITE_ID IS 'A foreign key to the primary care site in the care site table, where the details of the care site are stored.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.PERSON_SOURCE_VALUE IS 'An encrypted key derived from the person identifier in the source data. This is necessary when a drug safety issue requires a link back to the person data at the source dataset. No value with any medical or demographic significance must be stored.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.GENDER_SOURCE_VALUE IS 'The source code for the gender of the person as it appears in the source data. The person gender is mapped to a standard gender concept in the vocabulary and the corresponding concept identifier is, stored here for reference.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.RACE_SOURCE_VALUE IS 'The source code for the race of the person as it appears in the source data. The person race is mapped to a standard race concept in the vocabulary and the original code is, stored here for reference.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.ETHNICITY_SOURCE_VALUE IS 'The source code for the ethnicity of the person as it appears in the source data. The person ethnicity is mapped to a standard ethnicity concept in the vocabulary and the original code is, stored here for reference.'
/
COMMENT ON COLUMN OMOP_ETL.PERSON.PN_GESTATIONAL_AGE IS 'The post-menstrual age in weeks of the person at birth, if known'
/
CREATE TABLE OMOP_ETL.PROCEDURE_COST
(
  PROCEDURE_COST_ID              NUMBER(19)     NOT NULL,
  PROCEDURE_OCCURRENCE_ID        NUMBER(19)     NOT NULL,
  PAID_COPAY                     NUMBER(8,2),
  PAID_COINSURANCE               NUMBER(8,2),
  PAID_TOWARD_DEDUCTIBLE         NUMBER(8,2),
  PAID_BY_PAYER                  NUMBER(8,2),
  PAID_BY_COORDINATION_BENEFITS  NUMBER(8,2),
  TOTAL_OUT_OF_POCKET            NUMBER(8,2),
  TOTAL_PAID                     NUMBER(8,2),
  DISEASE_CLASS_CONCEPT_ID       NUMBER(10),
  REVENUE_CODE_CONCEPT_ID        NUMBER(10),
  PAYER_PLAN_PERIOD_ID           NUMBER(19),
  DISEASE_CLASS_SOURCE_VALUE     VARCHAR2(100 BYTE),
  REVENUE_CODE_SOURCE_VALUE      VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.PROCEDURE_COST IS 'For each Procedure additional information about cost and payments.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.PROCEDURE_COST_ID IS 'A system-generated unique identifier for each procedure cost record.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.PROCEDURE_OCCURRENCE_ID IS 'A foreign key identifier to the procedure record for which cost data are recorded. '
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.PAID_COPAY IS 'The amount paid by the person as a fixed contribution to the expenses. Copay does not contribute to the out_of_pocket expenses.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.PAID_COINSURANCE IS 'The amount paid by the person as a joint assumption of risk. Typically, this is a percentage of the expenses defined by the payer plan (policy) after the person''s deductible is exceeded.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.PAID_TOWARD_DEDUCTIBLE IS 'The amount paid by the person that is counted toward the deductible defined by the payer plan (policy).'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.PAID_BY_PAYER IS 'The amount paid by the payer (insurer). If there is more than one payer, several procedure_cost records indicate that fact.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.PAID_BY_COORDINATION_BENEFITS IS 'The amount paid by a secondary payer through the coordination of benefits.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.TOTAL_OUT_OF_POCKET IS 'The total amount paid by the person as a share of the expenses, excluding the copay.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.TOTAL_PAID IS 'The total amount paid for the expenses of the procedure.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.DISEASE_CLASS_CONCEPT_ID IS 'A foreign key referring to a standard concept identifier in the vocabulary for disease classes, such as DRGs and APCs.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.REVENUE_CODE_CONCEPT_ID IS 'A foreign key referring to a standard concept identifier in the vocabulary for revenue codes.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.PAYER_PLAN_PERIOD_ID IS 'A foreign key to the payer_plan_period table, where the details of the payer, plan and family are stored.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.DISEASE_CLASS_SOURCE_VALUE IS 'The source code for the disease class as it appears in the source data , stored here for reference.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_COST.REVENUE_CODE_SOURCE_VALUE IS 'The source code for the revenue code as it appears in the source data , stored here for reference.'
/
CREATE TABLE OMOP_ETL.PROCEDURE_OCCURRENCE
(
  PROCEDURE_OCCURRENCE_ID        NUMBER(19)     NOT NULL,
  PERSON_ID                      NUMBER(19)     NOT NULL,
  PROCEDURE_CONCEPT_ID           NUMBER(10)     NOT NULL,
  PROCEDURE_DATE                 DATE           NOT NULL,
  PROCEDURE_TYPE_CONCEPT_ID      NUMBER(10)     NOT NULL,
  ASSOCIATED_PROVIDER_ID         NUMBER(19),
  VISIT_OCCURRENCE_ID            NUMBER(19),
  RELEVANT_CONDITION_CONCEPT_ID  NUMBER(10),
  PROCEDURE_SOURCE_VALUE         VARCHAR2(100 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.PROCEDURE_OCCURRENCE IS 'Procedures carried out on the Person.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_OCCURRENCE.PROCEDURE_OCCURRENCE_ID IS 'A system-generated unique identifier for each procedure occurrence.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_OCCURRENCE.PERSON_ID IS 'A foreign key identifier to the person who is subjected to the procedure. The demographic details of that person are stored in the person table.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_OCCURRENCE.PROCEDURE_CONCEPT_ID IS 'A foreign key that refers to a standard procedure concept identifier in the vocabulary. '
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_OCCURRENCE.PROCEDURE_DATE IS 'The date on which the procedure was performed.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_OCCURRENCE.PROCEDURE_TYPE_CONCEPT_ID IS 'A foreign key to the predefined concept identifier in the vocabulary reflecting the type of the procedure. For a detailed current listing of procedure types see Appendix C: Procedure Type Concepts.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_OCCURRENCE.ASSOCIATED_PROVIDER_ID IS 'A foreign key to the provider in the provider table who was responsible for carrying out the procedure.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_OCCURRENCE.VISIT_OCCURRENCE_ID IS 'A foreign key to the visit in the visit table during which the procedure was carried out.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_OCCURRENCE.RELEVANT_CONDITION_CONCEPT_ID IS 'A foreign key to the predefined concept identifier in the vocabulary reflecting the condition that was the cause for initiation of the procedure. Note that this is not a direct reference to a specific condition record in the condition table, but rather a condition concept in the vocabulary.'
/
COMMENT ON COLUMN OMOP_ETL.PROCEDURE_OCCURRENCE.PROCEDURE_SOURCE_VALUE IS 'The source code for the procedure as it appears in the source data. This code is mapped to a standard procedure concept in the vocabulary and the original code is , stored here for reference. Procedure source codes are typically ICD-9-Proc, CPT-4 or HCPCS codes.'
/
CREATE TABLE OMOP_ETL.PROVIDER
(
  PROVIDER_ID             NUMBER(19)            NOT NULL,
  NPI                     VARCHAR2(20 BYTE),
  DEA                     VARCHAR2(20 BYTE),
  SPECIALTY_CONCEPT_ID    NUMBER(10),
  CARE_SITE_ID            NUMBER(19)            NOT NULL,
  PROVIDER_SOURCE_VALUE   VARCHAR2(100 BYTE)    NOT NULL,
  SPECIALTY_SOURCE_VALUE  VARCHAR2(50 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.PROVIDER IS 'Information about health care providers.'
/
COMMENT ON COLUMN OMOP_ETL.PROVIDER.PROVIDER_ID IS 'A system-generated unique identifier for each provider.'
/
COMMENT ON COLUMN OMOP_ETL.PROVIDER.NPI IS 'The National Provider Identifier (NPI) of the provider.'
/
COMMENT ON COLUMN OMOP_ETL.PROVIDER.DEA IS 'The Drug Enforcement Administration (DEA) number of the provider.'
/
COMMENT ON COLUMN OMOP_ETL.PROVIDER.SPECIALTY_CONCEPT_ID IS 'A foreign key to a standard provider''s specialty concept identifier in the vocabulary. '
/
COMMENT ON COLUMN OMOP_ETL.PROVIDER.CARE_SITE_ID IS 'A foreign key to the main care site where the provider is practicing.'
/
COMMENT ON COLUMN OMOP_ETL.PROVIDER.PROVIDER_SOURCE_VALUE IS 'The identifier used for the provider in the source data.rmation that is used to uniquely identify the provider as it appears in the source data , stored here for reference.'
/
COMMENT ON COLUMN OMOP_ETL.PROVIDER.SPECIALTY_SOURCE_VALUE IS 'The source code for the provider specialty as it appears in the source data , stored here for reference.'
/
CREATE INDEX OMOP_ETL.ORGANIZATION_ORAGANIZATION_POS ON OMOP_ETL.ORGANIZATION
(ORGANIZATION_SOURCE_VALUE, PLACE_OF_SERVICE_SOURCE_VALUE)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.ORGANIZATION_PKEY ON OMOP_ETL.ORGANIZATION
(ORGANIZATION_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.PAYER_PLAN_PERIOD_PKEY ON OMOP_ETL.PAYER_PLAN_PERIOD
(PAYER_PLAN_PERIOD_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.PERSON_PKEY ON OMOP_ETL.PERSON
(PERSON_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.PROCEDURE_COST_PKEY ON OMOP_ETL.PROCEDURE_COST
(PROCEDURE_COST_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.PROCEDURE_OCCURRENCE_PKEY ON OMOP_ETL.PROCEDURE_OCCURRENCE
(PROCEDURE_OCCURRENCE_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.PROVIDER_PKEY ON OMOP_ETL.PROVIDER
(PROVIDER_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
ALTER TABLE OMOP_ETL.ORGANIZATION ADD (
  CONSTRAINT ORGANIZATION_PKEY
  PRIMARY KEY
  (ORGANIZATION_ID)
  USING INDEX OMOP_ETL.ORGANIZATION_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.PAYER_PLAN_PERIOD ADD (
  CONSTRAINT PAYER_PLAN_PERIOD_PKEY
  PRIMARY KEY
  (PAYER_PLAN_PERIOD_ID)
  USING INDEX OMOP_ETL.PAYER_PLAN_PERIOD_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.PERSON ADD (
  CONSTRAINT PERSON_PKEY
  PRIMARY KEY
  (PERSON_ID)
  USING INDEX OMOP_ETL.PERSON_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.PROCEDURE_COST ADD (
  CONSTRAINT PROCEDURE_COST_PKEY
  PRIMARY KEY
  (PROCEDURE_COST_ID)
  USING INDEX OMOP_ETL.PROCEDURE_COST_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.PROCEDURE_OCCURRENCE ADD (
  CONSTRAINT PROCEDURE_OCCURRENCE_PKEY
  PRIMARY KEY
  (PROCEDURE_OCCURRENCE_ID)
  USING INDEX OMOP_ETL.PROCEDURE_OCCURRENCE_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.PROVIDER ADD (
  CONSTRAINT PROVIDER_PKEY
  PRIMARY KEY
  (PROVIDER_ID)
  USING INDEX OMOP_ETL.PROVIDER_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.ORGANIZATION ADD (
  CONSTRAINT ORGANIZATION_LOCATION_FK 
  FOREIGN KEY (LOCATION_ID) 
  REFERENCES OMOP_ETL.LOCATION (LOCATION_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.PAYER_PLAN_PERIOD ADD (
  CONSTRAINT PAYER_PLAN_PERIOD_PERSON_FK 
  FOREIGN KEY (PERSON_ID) 
  REFERENCES OMOP_ETL.PERSON (PERSON_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.PERSON ADD (
  CONSTRAINT PERSON_CARE_SITE_FK 
  FOREIGN KEY (CARE_SITE_ID) 
  REFERENCES OMOP_ETL.CARE_SITE (CARE_SITE_ID)
  ENABLE VALIDATE,
  CONSTRAINT PERSON_LOCATION_FK 
  FOREIGN KEY (LOCATION_ID) 
  REFERENCES OMOP_ETL.LOCATION (LOCATION_ID)
  ENABLE VALIDATE,
  CONSTRAINT PERSON_PROVIDER_FK 
  FOREIGN KEY (PROVIDER_ID) 
  REFERENCES OMOP_ETL.PROVIDER (PROVIDER_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.PROCEDURE_COST ADD (
  CONSTRAINT PROCEDURE_COST_PAYER_PLAN_FK 
  FOREIGN KEY (PAYER_PLAN_PERIOD_ID) 
  REFERENCES OMOP_ETL.PAYER_PLAN_PERIOD (PAYER_PLAN_PERIOD_ID)
  ENABLE VALIDATE,
  CONSTRAINT PROCEDURE_COST_PROCEDURE_FK 
  FOREIGN KEY (PROCEDURE_OCCURRENCE_ID) 
  REFERENCES OMOP_ETL.PROCEDURE_OCCURRENCE (PROCEDURE_OCCURRENCE_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.PROVIDER ADD (
  CONSTRAINT PROVIDER_CARE_SITE_FK 
  FOREIGN KEY (CARE_SITE_ID) 
  REFERENCES OMOP_ETL.CARE_SITE (CARE_SITE_ID)
  ENABLE VALIDATE)
/
CREATE TABLE OMOP_ETL.VISIT_OCCURRENCE
(
  VISIT_OCCURRENCE_ID            NUMBER(19)     NOT NULL,
  PERSON_ID                      NUMBER(19)     NOT NULL,
  VISIT_START_DATE               DATE           NOT NULL,
  VISIT_END_DATE                 DATE,
  PLACE_OF_SERVICE_CONCEPT_ID    NUMBER(10)     NOT NULL,
  CARE_SITE_ID                   NUMBER(19),
  PLACE_OF_SERVICE_SOURCE_VALUE  VARCHAR2(100 BYTE),
  PROVIDER_ID                    NUMBER(19)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.VISIT_OCCURRENCE IS 'Visits for health care services of the Person.'
/
COMMENT ON COLUMN OMOP_ETL.VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS 'A system-generated unique identifier for each person''s visit or encounter at a healthcare provider.'
/
COMMENT ON COLUMN OMOP_ETL.VISIT_OCCURRENCE.PERSON_ID IS 'A foreign key identifier to the person for whom the visit is recorded. The demographic details of that person are stored in the person table.'
/
COMMENT ON COLUMN OMOP_ETL.VISIT_OCCURRENCE.VISIT_START_DATE IS 'The start date of the visit.'
/
COMMENT ON COLUMN OMOP_ETL.VISIT_OCCURRENCE.VISIT_END_DATE IS 'The end date of the visit. If this is a one-day visit the end date should match the start date.'
/
COMMENT ON COLUMN OMOP_ETL.VISIT_OCCURRENCE.PLACE_OF_SERVICE_CONCEPT_ID IS 'A foreign key that refers to a place of service concept identifier in the vocabulary.'
/
COMMENT ON COLUMN OMOP_ETL.VISIT_OCCURRENCE.CARE_SITE_ID IS 'A foreign key to the care site in the care site table that was visited.'
/
COMMENT ON COLUMN OMOP_ETL.VISIT_OCCURRENCE.PLACE_OF_SERVICE_SOURCE_VALUE IS 'The source code used to reflect the type or source of the visit in the source data. Valid entries include office visits, hospital admissions, etc. These source codes can also be type-of service codes and activity type codes.'
/
COMMENT ON COLUMN OMOP_ETL.VISIT_OCCURRENCE.PROVIDER_ID IS 'References to Provider ID in Provider Table'
/
CREATE INDEX OMOP_ETL.VISIT_OCCURRENCE_PESON_DATE ON OMOP_ETL.VISIT_OCCURRENCE
(PERSON_ID, VISIT_START_DATE)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.VISIT_OCCURRENCE_PKEY ON OMOP_ETL.VISIT_OCCURRENCE
(VISIT_OCCURRENCE_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
ALTER TABLE OMOP_ETL.VISIT_OCCURRENCE ADD (
  CONSTRAINT VISIT_OCCURRENCE_PKEY
  PRIMARY KEY
  (VISIT_OCCURRENCE_ID)
  USING INDEX OMOP_ETL.VISIT_OCCURRENCE_PKEY
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.VISIT_OCCURRENCE ADD (
  CONSTRAINT VISIT_OCCURRENCE_PERSON_FK 
  FOREIGN KEY (PERSON_ID) 
  REFERENCES OMOP_ETL.PERSON (PERSON_ID)
  ENABLE VALIDATE)
/
CREATE TABLE OMOP_ETL.ERR$_CONDITION_ERA
(
  ORA_ERR_NUMBER$             NUMBER,
  ORA_ERR_MESG$               VARCHAR2(2000 BYTE),
  ORA_ERR_ROWID$              UROWID(4000),
  ORA_ERR_OPTYP$              VARCHAR2(2 BYTE),
  ORA_ERR_TAG$                VARCHAR2(2000 BYTE),
  CONDITION_ERA_ID            VARCHAR2(4000 BYTE),
  PERSON_ID                   VARCHAR2(4000 BYTE),
  CONDITION_CONCEPT_ID        VARCHAR2(4000 BYTE),
  CONDITION_ERA_START_DATE    VARCHAR2(4000 BYTE),
  CONDITION_ERA_END_DATE      VARCHAR2(4000 BYTE),
  CONDITION_TYPE_CONCEPT_ID   VARCHAR2(4000 BYTE),
  CONDITION_OCCURRENCE_COUNT  VARCHAR2(4000 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.ERR$_CONDITION_ERA IS 'DML Error NOLOGGING table for "CONDITION_ERA"'
/
CREATE TABLE OMOP_ETL.ERR$_CONDITION_OCCURRENCE
(
  ORA_ERR_NUMBER$              NUMBER,
  ORA_ERR_MESG$                VARCHAR2(2000 BYTE),
  ORA_ERR_ROWID$               UROWID(4000),
  ORA_ERR_OPTYP$               VARCHAR2(2 BYTE),
  ORA_ERR_TAG$                 VARCHAR2(2000 BYTE),
  CONDITION_OCCURRENCE_ID      VARCHAR2(4000 BYTE),
  PERSON_ID                    VARCHAR2(4000 BYTE),
  CONDITION_CONCEPT_ID         VARCHAR2(4000 BYTE),
  CONDITION_START_DATE         VARCHAR2(4000 BYTE),
  CONDITION_END_DATE           VARCHAR2(4000 BYTE),
  CONDITION_TYPE_CONCEPT_ID    VARCHAR2(4000 BYTE),
  STOP_REASON                  VARCHAR2(4000 BYTE),
  ASSOCIATED_PROVIDER_ID       VARCHAR2(4000 BYTE),
  VISIT_OCCURRENCE_ID          VARCHAR2(4000 BYTE),
  CONDITION_SOURCE_CONCEPT_ID  VARCHAR2(4000 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.ERR$_CONDITION_OCCURRENCE IS 'DML Error NOLOGGING table for "CONDITION_OCCURRENCE"'
/
CREATE TABLE OMOP_ETL.ERR$_DEATH
(
  ORA_ERR_NUMBER$              NUMBER,
  ORA_ERR_MESG$                VARCHAR2(2000 BYTE),
  ORA_ERR_ROWID$               UROWID(4000),
  ORA_ERR_OPTYP$               VARCHAR2(2 BYTE),
  ORA_ERR_TAG$                 VARCHAR2(2000 BYTE),
  PERSON_ID                    VARCHAR2(4000 BYTE),
  DEATH_DATE                   VARCHAR2(4000 BYTE),
  DEATH_TYPE_CONCEPT_ID        VARCHAR2(4000 BYTE),
  CAUSE_OF_DEATH_CONCEPT_ID    VARCHAR2(4000 BYTE),
  CAUSE_OF_DEATH_SOURCE_VALUE  VARCHAR2(4000 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.ERR$_DEATH IS 'DML Error NOLOGGING table for "DEATH"'
/
CREATE TABLE OMOP_ETL.ERR$_OBSERVATION
(
  ORA_ERR_NUMBER$                NUMBER,
  ORA_ERR_MESG$                  VARCHAR2(2000 BYTE),
  ORA_ERR_ROWID$                 UROWID(4000),
  ORA_ERR_OPTYP$                 VARCHAR2(2 BYTE),
  ORA_ERR_TAG$                   VARCHAR2(2000 BYTE),
  OBSERVATION_ID                 VARCHAR2(4000 BYTE),
  PERSON_ID                      VARCHAR2(4000 BYTE),
  OBSERVATION_CONCEPT_ID         VARCHAR2(4000 BYTE),
  OBSERVATION_DATE               VARCHAR2(4000 BYTE),
  OBSERVATION_TIME               VARCHAR2(4000 BYTE),
  VALUE_AS_NUMBER                VARCHAR2(4000 BYTE),
  VALUE_AS_STRING                VARCHAR2(4000 BYTE),
  VALUE_AS_CONCEPT_ID            VARCHAR2(4000 BYTE),
  UNIT_CONCEPT_ID                VARCHAR2(4000 BYTE),
  RANGE_LOW                      VARCHAR2(4000 BYTE),
  RANGE_HIGH                     VARCHAR2(4000 BYTE),
  OBSERVATION_TYPE_CONCEPT_ID    VARCHAR2(4000 BYTE),
  ASSOCIATED_PROVIDER_ID         VARCHAR2(4000 BYTE),
  VISIT_OCCURRENCE_ID            VARCHAR2(4000 BYTE),
  RELEVANT_CONDITION_CONCEPT_ID  VARCHAR2(4000 BYTE),
  OBSERVATION_SOURCE_VALUE       VARCHAR2(4000 BYTE),
  UNITS_SOURCE_VALUE             VARCHAR2(4000 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.ERR$_OBSERVATION IS 'DML Error NOLOGGING table for "OBSERVATION"'
/
CREATE TABLE OMOP_ETL.ERR$_OBSERVATION_PERIOD
(
  ORA_ERR_NUMBER$                NUMBER,
  ORA_ERR_MESG$                  VARCHAR2(2000 BYTE),
  ORA_ERR_ROWID$                 UROWID(4000),
  ORA_ERR_OPTYP$                 VARCHAR2(2 BYTE),
  ORA_ERR_TAG$                   VARCHAR2(2000 BYTE),
  OBSERVATION_PERIOD_ID          VARCHAR2(4000 BYTE),
  PERSON_ID                      VARCHAR2(4000 BYTE),
  OBSERVATION_PERIOD_START_DATE  VARCHAR2(4000 BYTE),
  OBSERVATION_PERIOD_END_DATE    VARCHAR2(4000 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.ERR$_OBSERVATION_PERIOD IS 'DML Error NOLOGGING table for "OBSERVATION_PERIOD"'
/
CREATE TABLE OMOP_ETL.ERR$_PERSON
(
  ORA_ERR_NUMBER$         NUMBER                NOT NULL,
  ORA_ERR_MESG$           VARCHAR2(2000 BYTE),
  ORA_ERR_ROWID$          UROWID(4000),
  ORA_ERR_OPTYP$          VARCHAR2(2 BYTE),
  ORA_ERR_TAG$            VARCHAR2(2000 BYTE)   NOT NULL,
  PERSON_ID               VARCHAR2(4000 BYTE)   NOT NULL,
  GENDER_CONCEPT_ID       VARCHAR2(4000 BYTE),
  YEAR_OF_BIRTH           VARCHAR2(4000 BYTE),
  MONTH_OF_BIRTH          VARCHAR2(4000 BYTE),
  DAY_OF_BIRTH            VARCHAR2(4000 BYTE),
  RACE_CONCEPT_ID         VARCHAR2(4000 BYTE),
  ETHNICITY_CONCEPT_ID    VARCHAR2(4000 BYTE),
  LOCATION_ID             VARCHAR2(4000 BYTE),
  PROVIDER_ID             VARCHAR2(4000 BYTE),
  CARE_SITE_ID            VARCHAR2(4000 BYTE),
  PERSON_SOURCE_VALUE     VARCHAR2(4000 BYTE),
  GENDER_SOURCE_VALUE     VARCHAR2(4000 BYTE),
  RACE_SOURCE_VALUE       VARCHAR2(4000 BYTE),
  ETHNICITY_SOURCE_VALUE  VARCHAR2(4000 BYTE),
  PN_GESTATIONAL_AGE      VARCHAR2(4000 BYTE),
  PN_TIME_OF_BIRTH        VARCHAR2(4000 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.ERR$_PERSON IS 'DML Error NOLOGGING table for "PERSON"'
/
CREATE TABLE OMOP_ETL.ERR$_PROCEDURE_OCCURRENCE
(
  ORA_ERR_NUMBER$                NUMBER,
  ORA_ERR_MESG$                  VARCHAR2(2000 BYTE),
  ORA_ERR_ROWID$                 UROWID(4000),
  ORA_ERR_OPTYP$                 VARCHAR2(2 BYTE),
  ORA_ERR_TAG$                   VARCHAR2(2000 BYTE),
  PROCEDURE_OCCURRENCE_ID        VARCHAR2(4000 BYTE),
  PERSON_ID                      VARCHAR2(4000 BYTE),
  PROCEDURE_CONCEPT_ID           VARCHAR2(4000 BYTE),
  PROCEDURE_DATE                 VARCHAR2(4000 BYTE),
  PROCEDURE_TYPE_CONCEPT_ID      VARCHAR2(4000 BYTE),
  ASSOCIATED_PROVIDER_ID         VARCHAR2(4000 BYTE),
  VISIT_OCCURRENCE_ID            VARCHAR2(4000 BYTE),
  RELEVANT_CONDITION_CONCEPT_ID  VARCHAR2(4000 BYTE),
  PROCEDURE_SOURCE_VALUE         VARCHAR2(4000 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.ERR$_PROCEDURE_OCCURRENCE IS 'DML Error NOLOGGING table for "PROCEDURE_OCCURRENCE"'
/
CREATE TABLE OMOP_ETL.ERR$_VISIT_OCCURRENCE
(
  ORA_ERR_NUMBER$                NUMBER,
  ORA_ERR_MESG$                  VARCHAR2(2000 BYTE),
  ORA_ERR_ROWID$                 UROWID(4000),
  ORA_ERR_OPTYP$                 VARCHAR2(2 BYTE),
  ORA_ERR_TAG$                   VARCHAR2(2000 BYTE),
  VISIT_OCCURRENCE_ID            VARCHAR2(4000 BYTE),
  PERSON_ID                      VARCHAR2(4000 BYTE),
  VISIT_START_DATE               VARCHAR2(4000 BYTE),
  VISIT_END_DATE                 VARCHAR2(4000 BYTE),
  PLACE_OF_SERVICE_CONCEPT_ID    VARCHAR2(4000 BYTE),
  CARE_SITE_ID                   VARCHAR2(4000 BYTE),
  PLACE_OF_SERVICE_SOURCE_VALUE  VARCHAR2(4000 BYTE),
  PROVIDER_ID                    VARCHAR2(4000 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.ERR$_VISIT_OCCURRENCE IS 'DML Error NOLOGGING table for "VISIT_OCCURRENCE"'
/
CREATE TABLE OMOP_ETL.EXCEPTIONS
(
  ROW_ID           UROWID(4000),
  OWNER            VARCHAR2(30 BYTE),
  TABLE_NAME       VARCHAR2(30 BYTE),
  CONSTRAINT_NAME  VARCHAR2(30 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    0
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
CREATE TABLE OMOP_ETL.EXCEPTIONS_HISTORY
(
  PROCESS_ID       NUMBER(38),
  ROW_ID           UROWID(4000),
  OWNER            VARCHAR2(30 BYTE),
  TABLE_NAME       VARCHAR2(30 BYTE),
  CONSTRAINT_NAME  VARCHAR2(30 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    0
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
CREATE UNIQUE INDEX OMOP_ETL.IX_PERSON_PERSON_ID ON OMOP_ETL.ERR$_PERSON
(ORA_ERR_TAG$, PERSON_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   84
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE INDEX OMOP_ETL.IX_PROCEDURE_PERSON_ID ON OMOP_ETL.ERR$_PROCEDURE_OCCURRENCE
(ORA_ERR_TAG$, PROCEDURE_OCCURRENCE_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   84
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE INDEX OMOP_ETL.IX_VISIT_PERSON_ID ON OMOP_ETL.ERR$_VISIT_OCCURRENCE
(ORA_ERR_TAG$, VISIT_OCCURRENCE_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
INITRANS   2
MAXTRANS   84
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE TABLE OMOP_ETL.CONCEPT
(
  CONCEPT_ID        INTEGER                     NOT NULL,
  CONCEPT_NAME      VARCHAR2(500 BYTE)          NOT NULL,
  CONCEPT_LEVEL     NUMBER                      NOT NULL,
  CONCEPT_CLASS     VARCHAR2(60 BYTE)           NOT NULL,
  VOCABULARY_ID     INTEGER                     NOT NULL,
  CONCEPT_CODE      VARCHAR2(40 BYTE)           NOT NULL,
  VALID_START_DATE  DATE                        NOT NULL,
  VALID_END_DATE    DATE                        DEFAULT '31-Dec-2099'         NOT NULL,
  INVALID_REASON    CHAR(1 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.CONCEPT IS 'A list of all valid terminology concepts across domains and their attributes. Concepts are derived from existing standards.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT.CONCEPT_ID IS 'A system-generated identifier to uniquely identify each concept across all concept types.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT.CONCEPT_NAME IS 'An unambiguous, meaningful and descriptive name for the concept.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT.CONCEPT_LEVEL IS 'The level of hierarchy associated with the concept. Different concept levels are assigned to concepts to depict their seniority in a clearly defined hierarchy, such as drugs, conditions, etc. A concept level of 0 is assigned to concepts that are not part of a standard vocabulary, but are part of the vocabulary for reference purposes (e.g. drug form).'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT.CONCEPT_CLASS IS 'The category or class of the concept along both the hierarchical tree as well as different domains within a vocabulary. Examples are ''Clinical Drug'', ''Ingredient'', ''Clinical Finding'' etc.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT.VOCABULARY_ID IS 'A foreign key to the vocabulary table indicating from which source the concept has been adapted.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT.CONCEPT_CODE IS 'The concept code represents the identifier of the concept in the source data it originates from, such as SNOMED-CT concept IDs, RxNorm RXCUIs etc. Note that concept codes are not unique across vocabularies.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT.VALID_START_DATE IS 'The date when the was first recorded.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT.VALID_END_DATE IS 'The date when the concept became invalid because it was deleted or superseded (updated) by a new concept. The default value is 31-Dec-2099.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT.INVALID_REASON IS 'Concepts that are replaced with a new concept are designated "Updated" (U) and concepts that are removed without replacement are "Deprecated" (D).'
/
CREATE TABLE OMOP_ETL.CONCEPT_ANCESTOR
(
  ANCESTOR_CONCEPT_ID       INTEGER             NOT NULL,
  DESCENDANT_CONCEPT_ID     INTEGER             NOT NULL,
  MAX_LEVELS_OF_SEPARATION  NUMBER,
  MIN_LEVELS_OF_SEPARATION  NUMBER
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.CONCEPT_ANCESTOR IS 'A specialized table containing only hierarchical relationship between concepts that may span several generations.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_ANCESTOR.ANCESTOR_CONCEPT_ID IS 'A foreign key to the concept code in the concept table for the higher-level concept that forms the ancestor in the relationship.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_ANCESTOR.DESCENDANT_CONCEPT_ID IS 'A foreign key to the concept code in the concept table for the lower-level concept that forms the descendant in the relationship.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_ANCESTOR.MAX_LEVELS_OF_SEPARATION IS 'The maximum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an optional attribute that is used to simplify hierarchic analysis. '
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_ANCESTOR.MIN_LEVELS_OF_SEPARATION IS 'The minimum separation in number of levels of hierarchy between ancestor and descendant concepts. This is an optional attribute that is used to simplify hierarchic analysis.'
/
CREATE TABLE OMOP_ETL.CONCEPT_RELATIONSHIP
(
  CONCEPT_ID_1      INTEGER                     NOT NULL,
  CONCEPT_ID_2      INTEGER                     NOT NULL,
  RELATIONSHIP_ID   INTEGER                     NOT NULL,
  VALID_START_DATE  DATE                        NOT NULL,
  VALID_END_DATE    DATE                        DEFAULT '31-Dec-2099'         NOT NULL,
  INVALID_REASON    CHAR(1 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.CONCEPT_RELATIONSHIP IS 'A list of relationship between concepts. Some of these relationships are generic (e.g. ''Subsumes'' relationship), others are domain-specific.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_RELATIONSHIP.CONCEPT_ID_1 IS 'A foreign key to the concept in the concept table associated with the relationship. Relationships are directional, and this field represents the source concept designation.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_RELATIONSHIP.CONCEPT_ID_2 IS 'A foreign key to the concept in the concept table associated with the relationship. Relationships are directional, and this field represents the destination concept designation.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_RELATIONSHIP.RELATIONSHIP_ID IS 'The type of relationship as defined in the relationship table.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_RELATIONSHIP.VALID_START_DATE IS 'The date when the the relationship was first recorded.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_RELATIONSHIP.VALID_END_DATE IS 'The date when the relationship became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_RELATIONSHIP.INVALID_REASON IS 'Reason the relationship was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default  value.'
/
CREATE TABLE OMOP_ETL.CONCEPT_SYNONYM
(
  CONCEPT_SYNONYM_ID    INTEGER                 NOT NULL,
  CONCEPT_ID            INTEGER                 NOT NULL,
  CONCEPT_SYNONYM_NAME  VARCHAR2(1000 BYTE)     NOT NULL
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.CONCEPT_SYNONYM IS 'A table with synonyms for concepts that have more than one valid name or description.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_SYNONYM.CONCEPT_SYNONYM_ID IS 'A system-generated unique identifier for each concept synonym.'
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_SYNONYM.CONCEPT_ID IS 'A foreign key to the concept in the concept table. '
/
COMMENT ON COLUMN OMOP_ETL.CONCEPT_SYNONYM.CONCEPT_SYNONYM_NAME IS 'The alternative name for the concept.'
/
CREATE UNIQUE INDEX OMOP_ETL.XPKCONCEPT ON OMOP_ETL.CONCEPT
(CONCEPT_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.XPKCONCEPT_ANCESTOR ON OMOP_ETL.CONCEPT_ANCESTOR
(ANCESTOR_CONCEPT_ID, DESCENDANT_CONCEPT_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.XPKCONCEPT_RELATIONSHIP ON OMOP_ETL.CONCEPT_RELATIONSHIP
(CONCEPT_ID_1, CONCEPT_ID_2, RELATIONSHIP_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.XPKCONCEPT_SYNONYM ON OMOP_ETL.CONCEPT_SYNONYM
(CONCEPT_SYNONYM_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
ALTER TABLE OMOP_ETL.CONCEPT ADD (
  CHECK ( invalid_reason IN ('D', 'U'))
  ENABLE VALIDATE,
  CHECK ( invalid_reason IN ('D', 'U'))
  ENABLE VALIDATE,
  CONSTRAINT XPKCONCEPT
  PRIMARY KEY
  (CONCEPT_ID)
  USING INDEX OMOP_ETL.XPKCONCEPT
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.CONCEPT_ANCESTOR ADD (
  CONSTRAINT XPKCONCEPT_ANCESTOR
  PRIMARY KEY
  (ANCESTOR_CONCEPT_ID, DESCENDANT_CONCEPT_ID)
  USING INDEX OMOP_ETL.XPKCONCEPT_ANCESTOR
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.CONCEPT_RELATIONSHIP ADD (
  CHECK ( invalid_reason IN ('D', 'U'))
  ENABLE VALIDATE,
  CHECK ( invalid_reason IN ('D', 'U'))
  ENABLE VALIDATE,
  CONSTRAINT XPKCONCEPT_RELATIONSHIP
  PRIMARY KEY
  (CONCEPT_ID_1, CONCEPT_ID_2, RELATIONSHIP_ID)
  USING INDEX OMOP_ETL.XPKCONCEPT_RELATIONSHIP
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.CONCEPT_SYNONYM ADD (
  CONSTRAINT XPKCONCEPT_SYNONYM
  PRIMARY KEY
  (CONCEPT_SYNONYM_ID)
  USING INDEX OMOP_ETL.XPKCONCEPT_SYNONYM
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.CONCEPT_ANCESTOR ADD (
  CONSTRAINT CONCEPT_ANCESTOR_FK 
  FOREIGN KEY (ANCESTOR_CONCEPT_ID) 
  REFERENCES OMOP_ETL.CONCEPT (CONCEPT_ID)
  ENABLE VALIDATE,
  CONSTRAINT CONCEPT_DESCENDANT_FK 
  FOREIGN KEY (DESCENDANT_CONCEPT_ID) 
  REFERENCES OMOP_ETL.CONCEPT (CONCEPT_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.CONCEPT_SYNONYM ADD (
  CONSTRAINT CONCEPT_SYNONYM_CONCEPT_FK 
  FOREIGN KEY (CONCEPT_ID) 
  REFERENCES OMOP_ETL.CONCEPT (CONCEPT_ID)
  ENABLE VALIDATE)
/
CREATE TABLE OMOP_ETL.DRUG_APPROVAL
(
  INGREDIENT_CONCEPT_ID  INTEGER                NOT NULL,
  APPROVAL_DATE          DATE                   NOT NULL,
  APPROVED_BY            VARCHAR2(20 BYTE)      DEFAULT 'FDA'                 NOT NULL
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
CREATE TABLE OMOP_ETL.DRUG_STRENGTH
(
  DRUG_CONCEPT_ID           INTEGER             NOT NULL,
  INGREDIENT_CONCEPT_ID     INTEGER             NOT NULL,
  AMOUNT_VALUE              NUMBER,
  AMOUNT_UNIT               VARCHAR2(60 BYTE),
  CONCENTRATION_VALUE       NUMBER,
  CONCENTRATION_ENUM_UNIT   VARCHAR2(60 BYTE),
  CONCENTRATION_DENOM_UNIT  VARCHAR2(60 BYTE),
  VALID_START_DATE          DATE                NOT NULL,
  VALID_END_DATE            DATE                NOT NULL,
  INVALID_REASON            VARCHAR2(1 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
CREATE TABLE OMOP_ETL.RELATIONSHIP
(
  RELATIONSHIP_ID       INTEGER                 NOT NULL,
  RELATIONSHIP_NAME     VARCHAR2(500 BYTE)      NOT NULL,
  IS_HIERARCHICAL       INTEGER                 NOT NULL,
  DEFINES_ANCESTRY      INTEGER                 DEFAULT 1                     NOT NULL,
  REVERSE_RELATIONSHIP  INTEGER
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.RELATIONSHIP IS 'A list of relationship between concepts. Some of these relationships are generic (e.g. "Subsumes" relationship), others are domain-specific.'
/
COMMENT ON COLUMN OMOP_ETL.RELATIONSHIP.RELATIONSHIP_ID IS 'The type of relationship captured by the relationship record.'
/
COMMENT ON COLUMN OMOP_ETL.RELATIONSHIP.RELATIONSHIP_NAME IS 'The text that describes the relationship type.'
/
COMMENT ON COLUMN OMOP_ETL.RELATIONSHIP.IS_HIERARCHICAL IS 'Defines whether a relationship defines concepts into classes or hierarchies. Values are Y for hierarchical relationship or NULL if not'
/
COMMENT ON COLUMN OMOP_ETL.RELATIONSHIP.DEFINES_ANCESTRY IS 'Defines whether a hierarchical relationship contributes to the concept_ancestor table. These are subsets of the hierarchical relationships. Valid values are Y or NULL.'
/
COMMENT ON COLUMN OMOP_ETL.RELATIONSHIP.REVERSE_RELATIONSHIP IS 'Relationship ID of the reverse relationship to this one. Corresponding records of reverse relationships have their concept_id_1 and concept_id_2 swapped.'
/
CREATE TABLE OMOP_ETL.SOURCE_TO_CONCEPT_MAP
(
  SOURCE_CODE              VARCHAR2(40 BYTE)    NOT NULL,
  SOURCE_VOCABULARY_ID     INTEGER              NOT NULL,
  SOURCE_CODE_DESCRIPTION  VARCHAR2(500 BYTE),
  TARGET_CONCEPT_ID        INTEGER              NOT NULL,
  TARGET_VOCABULARY_ID     INTEGER              NOT NULL,
  MAPPING_TYPE             VARCHAR2(20 BYTE),
  PRIMARY_MAP              CHAR(1 BYTE),
  VALID_START_DATE         DATE                 NOT NULL,
  VALID_END_DATE           DATE                 DEFAULT '31-Dec-2099'         NOT NULL,
  INVALID_REASON           CHAR(1 BYTE)
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.SOURCE_TO_CONCEPT_MAP IS 'A map between commonly used terminologies and the CDM Standard Vocabulary. For example, drugs are often recorded as NDC, while the Standard Vocabulary for drugs is RxNorm.'
/
COMMENT ON COLUMN OMOP_ETL.SOURCE_TO_CONCEPT_MAP.SOURCE_CODE IS 'The source code being translated into a standard concept.'
/
COMMENT ON COLUMN OMOP_ETL.SOURCE_TO_CONCEPT_MAP.SOURCE_VOCABULARY_ID IS 'A foreign key to the vocabulary table defining the vocabulary of the source code that is being mapped to the standard vocabulary.'
/
COMMENT ON COLUMN OMOP_ETL.SOURCE_TO_CONCEPT_MAP.SOURCE_CODE_DESCRIPTION IS 'An optional description for the source code. This is included as a convenience to compare the description of the source code to the name of the concept.'
/
COMMENT ON COLUMN OMOP_ETL.SOURCE_TO_CONCEPT_MAP.TARGET_CONCEPT_ID IS 'A foreign key to the concept to which the source code is being mapped.'
/
COMMENT ON COLUMN OMOP_ETL.SOURCE_TO_CONCEPT_MAP.TARGET_VOCABULARY_ID IS 'A foreign key to the vocabulary table defining the vocabulary of the target concept.'
/
COMMENT ON COLUMN OMOP_ETL.SOURCE_TO_CONCEPT_MAP.MAPPING_TYPE IS 'A string identifying the observational data element being translated. Examples include ''DRUG'', ''CONDITION'', ''PROCEDURE'', ''PROCEDURE DRUG'' etc. It is important to pick the appropriate mapping record when the same source code is being mapped to different concepts in different contexts. As an example a procedure code for drug administration can be mapped to a procedure concept or a drug concept.'
/
COMMENT ON COLUMN OMOP_ETL.SOURCE_TO_CONCEPT_MAP.PRIMARY_MAP IS 'A boolean value identifying the primary mapping relationship for those sets where the source_code, the source_concept_type_id and the mapping type is identical (one-to-many mappings). The ETL will only consider the primary map. Permitted values are Y and null.'
/
COMMENT ON COLUMN OMOP_ETL.SOURCE_TO_CONCEPT_MAP.VALID_START_DATE IS 'The date when the mapping instance was first recorded.'
/
COMMENT ON COLUMN OMOP_ETL.SOURCE_TO_CONCEPT_MAP.VALID_END_DATE IS 'The date when the mapping instance became invalid because it was deleted or superseded (updated) by a new relationship. Default value is 31-Dec-2099.'
/
COMMENT ON COLUMN OMOP_ETL.SOURCE_TO_CONCEPT_MAP.INVALID_REASON IS 'Reason the mapping instance was invalidated. Possible values are D (deleted), U (replaced with an update) or NULL when valid_end_date has the default  value.'
/
CREATE TABLE OMOP_ETL.VOCABULARY
(
  VOCABULARY_ID    INTEGER                      NOT NULL,
  VOCABULARY_NAME  VARCHAR2(256 BYTE)           NOT NULL
)
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
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
NOLOGGING 
COMPRESS BASIC 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
COMMENT ON TABLE OMOP_ETL.VOCABULARY IS 'A combination of terminologies and classifications that belong to a Vocabulary Domain.'
/
COMMENT ON COLUMN OMOP_ETL.VOCABULARY.VOCABULARY_ID IS 'Unique identifier for each of the vocabulary sources used in the observational analysis.'
/
COMMENT ON COLUMN OMOP_ETL.VOCABULARY.VOCABULARY_NAME IS 'Elaborative name for each of the vocabulary sources'
/
CREATE INDEX OMOP_ETL.SOURCE_TO_CONCEPT_SOURCE_IDX ON OMOP_ETL.SOURCE_TO_CONCEPT_MAP
(SOURCE_CODE)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.UNIQUE_VOCABULARY_NAME ON OMOP_ETL.VOCABULARY
(VOCABULARY_NAME)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.XPKRELATIONSHIP_TYPE ON OMOP_ETL.RELATIONSHIP
(RELATIONSHIP_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.XPKSOURCE_TO_CONCEPT_MAP ON OMOP_ETL.SOURCE_TO_CONCEPT_MAP
(SOURCE_VOCABULARY_ID, TARGET_CONCEPT_ID, SOURCE_CODE, VALID_END_DATE)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
CREATE UNIQUE INDEX OMOP_ETL.XPKVOCABULARY_REF ON OMOP_ETL.VOCABULARY
(VOCABULARY_ID)
NOLOGGING
TABLESPACE I2B2DAT
PCTFREE    10
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
/
ALTER TABLE OMOP_ETL.RELATIONSHIP ADD (
  CONSTRAINT XPKRELATIONSHIP_TYPE
  PRIMARY KEY
  (RELATIONSHIP_ID)
  USING INDEX OMOP_ETL.XPKRELATIONSHIP_TYPE
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.SOURCE_TO_CONCEPT_MAP ADD (
  CHECK ( invalid_reason IN ('D', 'U'))
  ENABLE VALIDATE,
  CHECK ( primary_map IN ('Y'))
  ENABLE VALIDATE,
  CHECK ( invalid_reason IN ('D', 'U'))
  ENABLE VALIDATE,
  CHECK ( primary_map IN ('Y'))
  ENABLE VALIDATE,
  CONSTRAINT XPKSOURCE_TO_CONCEPT_MAP
  PRIMARY KEY
  (SOURCE_VOCABULARY_ID, TARGET_CONCEPT_ID, SOURCE_CODE, VALID_END_DATE)
  USING INDEX OMOP_ETL.XPKSOURCE_TO_CONCEPT_MAP
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.VOCABULARY ADD (
  CONSTRAINT XPKVOCABULARY_REF
  PRIMARY KEY
  (VOCABULARY_ID)
  USING INDEX OMOP_ETL.XPKVOCABULARY_REF
  ENABLE VALIDATE,
  CONSTRAINT UNIQUE_VOCABULARY_NAME
  UNIQUE (VOCABULARY_NAME)
  USING INDEX OMOP_ETL.UNIQUE_VOCABULARY_NAME
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.SOURCE_TO_CONCEPT_MAP ADD (
  CONSTRAINT SOURCE_TO_CONCEPT_CONCEPT 
  FOREIGN KEY (TARGET_CONCEPT_ID) 
  REFERENCES OMOP_ETL.CONCEPT (CONCEPT_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.CARE_SITE ADD (
  CONSTRAINT CARE_SITE_LOCATION_FK 
  FOREIGN KEY (LOCATION_ID) 
  REFERENCES OMOP_ETL.LOCATION (LOCATION_ID)
  ENABLE VALIDATE,
  CONSTRAINT CARE_SITE_ORGANIZATION_FK 
  FOREIGN KEY (ORGANIZATION_ID) 
  REFERENCES OMOP_ETL.ORGANIZATION (ORGANIZATION_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.CONDITION_ERA ADD (
  CONSTRAINT CONDITION_ERA_PERSON_FK 
  FOREIGN KEY (PERSON_ID) 
  REFERENCES OMOP_ETL.PERSON (PERSON_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.CONDITION_OCCURRENCE ADD (
  CONSTRAINT CONDITION_OCCURRENCE_PERSON_FK 
  FOREIGN KEY (PERSON_ID) 
  REFERENCES OMOP_ETL.PERSON (PERSON_ID)
  ENABLE VALIDATE,
  CONSTRAINT CONDITION_PROVIDER_FK 
  FOREIGN KEY (ASSOCIATED_PROVIDER_ID) 
  REFERENCES OMOP_ETL.PROVIDER (PROVIDER_ID)
  ENABLE VALIDATE,
  CONSTRAINT CONDITION_VISIT_FK 
  FOREIGN KEY (VISIT_OCCURRENCE_ID) 
  REFERENCES OMOP_ETL.VISIT_OCCURRENCE (VISIT_OCCURRENCE_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.DEATH ADD (
  CONSTRAINT DEATH_PERSON_FK 
  FOREIGN KEY (PERSON_ID) 
  REFERENCES OMOP_ETL.PERSON (PERSON_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.DRUG_COST ADD (
  CONSTRAINT DRUG_COST_DRUG_EXPOSURE_FK 
  FOREIGN KEY (DRUG_EXPOSURE_ID) 
  REFERENCES OMOP_ETL.DRUG_EXPOSURE (DRUG_EXPOSURE_ID)
  ENABLE VALIDATE,
  CONSTRAINT DRUG_COST_PAYER_PLAN_PERIOD_FK 
  FOREIGN KEY (PAYER_PLAN_PERIOD_ID) 
  REFERENCES OMOP_ETL.PAYER_PLAN_PERIOD (PAYER_PLAN_PERIOD_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.DRUG_ERA ADD (
  CONSTRAINT DRUG_ERA_PERSON_FK 
  FOREIGN KEY (PERSON_ID) 
  REFERENCES OMOP_ETL.PERSON (PERSON_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.DRUG_EXPOSURE ADD (
  CONSTRAINT DRUG_EXPOSURE_PERSON_FK 
  FOREIGN KEY (PERSON_ID) 
  REFERENCES OMOP_ETL.PERSON (PERSON_ID)
  ENABLE VALIDATE,
  CONSTRAINT DRUG_EXPOSURE_PROVIDER_FK 
  FOREIGN KEY (PRESCRIBING_PROVIDER_ID) 
  REFERENCES OMOP_ETL.PROVIDER (PROVIDER_ID)
  ENABLE VALIDATE,
  CONSTRAINT DRUG_VISIT_FK 
  FOREIGN KEY (VISIT_OCCURRENCE_ID) 
  REFERENCES OMOP_ETL.VISIT_OCCURRENCE (VISIT_OCCURRENCE_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.OBSERVATION ADD (
  CONSTRAINT OBSERVATION_PERSON_FK 
  FOREIGN KEY (PERSON_ID) 
  REFERENCES OMOP_ETL.PERSON (PERSON_ID)
  ENABLE VALIDATE,
  CONSTRAINT OBSERVATION_PROVIDER_FK 
  FOREIGN KEY (ASSOCIATED_PROVIDER_ID) 
  REFERENCES OMOP_ETL.PROVIDER (PROVIDER_ID)
  ENABLE VALIDATE,
  CONSTRAINT OBSERVATION_VISIT_FK 
  FOREIGN KEY (VISIT_OCCURRENCE_ID) 
  REFERENCES OMOP_ETL.VISIT_OCCURRENCE (VISIT_OCCURRENCE_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.OBSERVATION_PERIOD ADD (
  CONSTRAINT OBSERVATION_PERIOD_PERSON_FK 
  FOREIGN KEY (PERSON_ID) 
  REFERENCES OMOP_ETL.PERSON (PERSON_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.PROCEDURE_OCCURRENCE ADD (
  CONSTRAINT PROCEDURE_OCCURRENCE_PERSON_FK 
  FOREIGN KEY (PERSON_ID) 
  REFERENCES OMOP_ETL.PERSON (PERSON_ID)
  ENABLE VALIDATE,
  CONSTRAINT PROCEDURE_PROVIDER_FK 
  FOREIGN KEY (ASSOCIATED_PROVIDER_ID) 
  REFERENCES OMOP_ETL.PROVIDER (PROVIDER_ID)
  ENABLE VALIDATE,
  CONSTRAINT PROCEDURE_VISIT_FK 
  FOREIGN KEY (VISIT_OCCURRENCE_ID) 
  REFERENCES OMOP_ETL.VISIT_OCCURRENCE (VISIT_OCCURRENCE_ID)
  ENABLE VALIDATE)
/
ALTER TABLE OMOP_ETL.CONCEPT_RELATIONSHIP ADD (
  CONSTRAINT CONCEPT_REL_CHILD_FK 
  FOREIGN KEY (CONCEPT_ID_2) 
  REFERENCES OMOP_ETL.CONCEPT (CONCEPT_ID)
  ENABLE VALIDATE,
  CONSTRAINT CONCEPT_REL_PARENT_FK 
  FOREIGN KEY (CONCEPT_ID_1) 
  REFERENCES OMOP_ETL.CONCEPT (CONCEPT_ID)
  ENABLE VALIDATE,
  CONSTRAINT CONCEPT_REL_REL_TYPE_FK 
  FOREIGN KEY (RELATIONSHIP_ID) 
  REFERENCES OMOP_ETL.RELATIONSHIP (RELATIONSHIP_ID)
  ENABLE VALIDATE)
/
















