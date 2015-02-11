--=============================================================================
--
-- NAME
--
-- i2b2_chop_base_setup_ddls.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 02/05/2015
--
-- SCHEMA / USER : I2B2ETL
-- I2B2
-- Oracle Database 11gR2
-- Tablespace : I2B2DAT
--
-- DESCRIPTION:
-- 1. Create I2B2ETL schema in Oracle database and also make sure OMOP_ETL schema 
-- exists under same Oracle database, then run the below base create table statements.
-- 2. In this file contains create table statements with indexes for tables I2B2, 
-- CONCEPT_DIMENSION, PATIENT_DIMENSION, VISIT_DIMENSION and OBSERVATION_FACT.
-- 3. Granting 'SELECT' option for above i2b2 tables data to OMOP_ETL schema
-- [PEDSNet OMOP Common Data Model] table(s) structured.
--
--=============================================================================
SET DEFINE OFF;
CREATE TABLE I2B2
(
  C_HLEVEL            NUMBER(22)                NOT NULL,
  C_FULLNAME          VARCHAR2(700 BYTE)        NOT NULL,
  C_NAME              VARCHAR2(2000 BYTE)       NOT NULL,
  C_SYNONYM_CD        CHAR(1 BYTE)              NOT NULL,
  C_VISUALATTRIBUTES  CHAR(3 BYTE)              NOT NULL,
  C_TOTALNUM          NUMBER(22),
  C_BASECODE          VARCHAR2(50 BYTE),
  C_METADATAXML       CLOB,
  C_FACTTABLECOLUMN   VARCHAR2(50 BYTE)         NOT NULL,
  C_TABLENAME         VARCHAR2(50 BYTE)         NOT NULL,
  C_COLUMNNAME        VARCHAR2(50 BYTE)         NOT NULL,
  C_COLUMNDATATYPE    VARCHAR2(50 BYTE)         NOT NULL,
  C_OPERATOR          VARCHAR2(10 BYTE)         NOT NULL,
  C_DIMCODE           VARCHAR2(700 BYTE)        NOT NULL,
  C_COMMENT           CLOB,
  C_TOOLTIP           VARCHAR2(900 BYTE),
  M_APPLIED_PATH      VARCHAR2(700 BYTE)        NOT NULL,
  UPDATE_DATE         DATE                      DEFAULT sysdate               NOT NULL,
  DOWNLOAD_DATE       DATE                      DEFAULT sysdate,
  IMPORT_DATE         DATE                      DEFAULT sysdate,
  SOURCESYSTEM_CD     VARCHAR2(50 BYTE),
  VALUETYPE_CD        VARCHAR2(50 BYTE),
  M_EXCLUSION_CD      VARCHAR2(25 BYTE),
  C_PATH              VARCHAR2(700 BYTE),
  C_SYMBOL            VARCHAR2(50 BYTE)
)
LOB (C_METADATAXML) STORE AS (
  TABLESPACE  I2B2DAT
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  NOLOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                  FLASH_CACHE      DEFAULT
                  CELL_FLASH_CACHE DEFAULT
                 ))
LOB (C_COMMENT) STORE AS (
  TABLESPACE  I2B2DAT
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  NOLOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                  FLASH_CACHE      DEFAULT
                  CELL_FLASH_CACHE DEFAULT
                 ))
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
NOCOMPRESS 
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
MONITORING
/
CREATE TABLE CONCEPT_DIMENSION
(
  CONCEPT_PATH     VARCHAR2(700 BYTE)           NOT NULL,
  CONCEPT_CD       VARCHAR2(50 BYTE)            NOT NULL,
  NAME_CHAR        VARCHAR2(2000 BYTE),
  CONCEPT_BLOB     CLOB,
  UPDATE_DATE      DATE,
  DOWNLOAD_DATE    DATE,
  IMPORT_DATE      DATE,
  SOURCESYSTEM_CD  VARCHAR2(50 BYTE),
  UPLOAD_ID        NUMBER(38)
)
LOB (CONCEPT_BLOB) STORE AS (
  TABLESPACE  I2B2DAT
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  NOLOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                  FLASH_CACHE      DEFAULT
                  CELL_FLASH_CACHE DEFAULT
                 ))
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
MONITORING
/
CREATE INDEX CD_UPLOADID_IDX ON CONCEPT_DIMENSION
(UPLOAD_ID)
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
/
CREATE UNIQUE INDEX CONCEPT_DIMENSION_PK ON CONCEPT_DIMENSION
(CONCEPT_PATH)
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
/
ALTER TABLE CONCEPT_DIMENSION ADD (
  CONSTRAINT CONCEPT_DIMENSION_PK
  PRIMARY KEY
  (CONCEPT_PATH)
  USING INDEX CONCEPT_DIMENSION_PK
  ENABLE VALIDATE)
/
CREATE TABLE PATIENT_DIMENSION
(
  PATIENT_NUM        NUMBER(38)                 NOT NULL,
  VITAL_STATUS_CD    VARCHAR2(50 BYTE),
  BIRTH_DATE         DATE,
  DEATH_DATE         DATE,
  SEX_CD             VARCHAR2(50 BYTE),
  AGE_IN_YEARS_NUM   NUMBER(38),
  LANGUAGE_CD        VARCHAR2(50 BYTE),
  RACE_CD            VARCHAR2(50 BYTE),
  MARITAL_STATUS_CD  VARCHAR2(50 BYTE),
  RELIGION_CD        VARCHAR2(50 BYTE),
  ZIP_CD             VARCHAR2(50 BYTE),
  STATECITYZIP_PATH  VARCHAR2(700 BYTE),
  INCOME_CD          VARCHAR2(50 BYTE),
  PATIENT_BLOB       CLOB,
  UPDATE_DATE        DATE,
  DOWNLOAD_DATE      DATE,
  IMPORT_DATE        DATE,
  SOURCESYSTEM_CD    VARCHAR2(50 BYTE),
  UPLOAD_ID          NUMBER(38),
  ETHNICITY_CD       VARCHAR2(200 BYTE)
)
LOB (PATIENT_BLOB) STORE AS (
  TABLESPACE  I2B2DAT
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                  FLASH_CACHE      DEFAULT
                  CELL_FLASH_CACHE DEFAULT
                 ))
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
CREATE INDEX PATD_UPLOADID_IDX ON PATIENT_DIMENSION
(UPLOAD_ID)
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
CREATE UNIQUE INDEX PATIENT_DIMENSION_PK ON PATIENT_DIMENSION
(PATIENT_NUM)
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
CREATE INDEX PD_IDX_ALLPATIENTDIM ON PATIENT_DIMENSION
(PATIENT_NUM, VITAL_STATUS_CD, BIRTH_DATE, DEATH_DATE, SEX_CD, 
AGE_IN_YEARS_NUM, LANGUAGE_CD, RACE_CD, MARITAL_STATUS_CD, RELIGION_CD, 
ZIP_CD, INCOME_CD)
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
CREATE INDEX PD_IDX_DATES ON PATIENT_DIMENSION
(PATIENT_NUM, VITAL_STATUS_CD, BIRTH_DATE, DEATH_DATE)
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
CREATE INDEX PD_IDX_STATECITYZIP ON PATIENT_DIMENSION
(STATECITYZIP_PATH, PATIENT_NUM)
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
ALTER TABLE PATIENT_DIMENSION ADD (
  CONSTRAINT PATIENT_DIMENSION_PK
  PRIMARY KEY
  (PATIENT_NUM)
  USING INDEX PATIENT_DIMENSION_PK
  ENABLE VALIDATE)
/
GRANT SELECT ON PATIENT_DIMENSION TO OMOP_ETL
/
CREATE TABLE VISIT_DIMENSION
(
  ENCOUNTER_NUM     NUMBER(38)                  NOT NULL,
  PATIENT_NUM       NUMBER(38)                  NOT NULL,
  ACTIVE_STATUS_CD  VARCHAR2(50 BYTE),
  START_DATE        DATE,
  END_DATE          DATE,
  INOUT_CD          VARCHAR2(50 BYTE),
  LOCATION_CD       VARCHAR2(50 BYTE),
  LOCATION_PATH     VARCHAR2(900 BYTE),
  LENGTH_OF_STAY    NUMBER(38),
  VISIT_BLOB        CLOB,
  UPDATE_DATE       DATE,
  DOWNLOAD_DATE     DATE,
  IMPORT_DATE       DATE,
  SOURCESYSTEM_CD   VARCHAR2(50 BYTE),
  UPLOAD_ID         NUMBER(38)
)
LOB (VISIT_BLOB) STORE AS (
  TABLESPACE  I2B2DAT
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING
      STORAGE    (
                  INITIAL          64K
                  NEXT             1M
                  MINEXTENTS       1
                  MAXEXTENTS       UNLIMITED
                  PCTINCREASE      0
                  BUFFER_POOL      DEFAULT
                  FLASH_CACHE      DEFAULT
                  CELL_FLASH_CACHE DEFAULT
                 ))
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
CREATE BITMAP INDEX IDX_BMP_SRC_CD ON VISIT_DIMENSION
(SOURCESYSTEM_CD)
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
CREATE INDEX IDX_VISITDIM_ENCOUNTER ON VISIT_DIMENSION
(ENCOUNTER_NUM)
LOGGING
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
CREATE INDEX VD_UPLOADID_IDX ON VISIT_DIMENSION
(UPLOAD_ID)
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
/
CREATE INDEX VISITDIM_EN_PN_LP_IO_SD_IDX ON VISIT_DIMENSION
(ENCOUNTER_NUM, PATIENT_NUM, LOCATION_PATH, INOUT_CD, START_DATE, 
END_DATE, LENGTH_OF_STAY)
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
/
CREATE INDEX VISITDIM_STD_EDD_IDX ON VISIT_DIMENSION
(START_DATE, END_DATE)
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
/
ALTER TABLE VISIT_DIMENSION ADD (
  CONSTRAINT VISIT_DIMENSION_PK
  PRIMARY KEY
  (ENCOUNTER_NUM, PATIENT_NUM)
  USING INDEX VISITDIM_EN_PN_LP_IO_SD_IDX
  ENABLE VALIDATE)
/
GRANT SELECT ON VISIT_DIMENSION TO OMOP_ETL
/
CREATE TABLE OBSERVATION_FACT
(
  ENCOUNTER_NUM     NUMBER(38)                  NOT NULL,
  PATIENT_NUM       NUMBER(38)                  NOT NULL,
  CONCEPT_CD        VARCHAR2(50 BYTE)           NOT NULL,
  PROVIDER_ID       VARCHAR2(50 BYTE)           NOT NULL,
  START_DATE        DATE                        NOT NULL,
  MODIFIER_CD       VARCHAR2(100 BYTE)          DEFAULT '@'                   NOT NULL,
  INSTANCE_NUM      NUMBER(18)                  DEFAULT '1'                   NOT NULL,
  VALTYPE_CD        VARCHAR2(50 BYTE),
  TVAL_CHAR         VARCHAR2(255 BYTE),
  NVAL_NUM          NUMBER(18,5),
  VALUEFLAG_CD      VARCHAR2(50 BYTE),
  QUANTITY_NUM      NUMBER(18,5),
  UNITS_CD          VARCHAR2(50 BYTE),
  END_DATE          DATE,
  LOCATION_CD       VARCHAR2(50 BYTE),
  OBSERVATION_BLOB  CLOB,
  CONFIDENCE_NUM    NUMBER(18,5),
  UPDATE_DATE       DATE,
  DOWNLOAD_DATE     DATE,
  IMPORT_DATE       DATE,
  SOURCESYSTEM_CD   VARCHAR2(50 BYTE),
  UPLOAD_ID         NUMBER(38)
)
LOB (OBSERVATION_BLOB) STORE AS (
  TABLESPACE  I2B2DAT
  ENABLE      STORAGE IN ROW
  CHUNK       8192
  RETENTION
  NOCACHE
  LOGGING)
COMPRESS BASIC 
TABLESPACE I2B2DAT
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          17179869168K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOLOGGING
PARTITION BY LIST (SOURCESYSTEM_CD)
(  
  PARTITION VITALS VALUES ('NONADT-VITALS', 'ADT-VITALS')
    LOGGING
    NOCOMPRESS 
    TABLESPACE I2B2DAT
    LOB (OBSERVATION_BLOB) STORE AS (
      TABLESPACE  I2B2DAT
      ENABLE      STORAGE IN ROW
      CHUNK       8192
      RETENTION
      NOCACHE
      LOGGING
          STORAGE    (
                      INITIAL          64K
                      NEXT             1M
                      MINEXTENTS       1
                      MAXEXTENTS       UNLIMITED
                      PCTINCREASE      0
                      BUFFER_POOL      DEFAULT
                      FLASH_CACHE      DEFAULT
                      CELL_FLASH_CACHE DEFAULT
                     ))
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
                FLASH_CACHE      DEFAULT
                CELL_FLASH_CACHE DEFAULT
               ),  
  PARTITION DX VALUES ('ADT-DX', 'NONADT-DX')
    LOGGING
    NOCOMPRESS 
    TABLESPACE I2B2DAT
    LOB (OBSERVATION_BLOB) STORE AS (
      TABLESPACE  I2B2DAT
      ENABLE      STORAGE IN ROW
      CHUNK       8192
      RETENTION
      NOCACHE
      LOGGING
          STORAGE    (
                      INITIAL          64K
                      NEXT             1M
                      MINEXTENTS       1
                      MAXEXTENTS       UNLIMITED
                      PCTINCREASE      0
                      BUFFER_POOL      DEFAULT
                      FLASH_CACHE      DEFAULT
                      CELL_FLASH_CACHE DEFAULT
                     ))
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
                FLASH_CACHE      DEFAULT
                CELL_FLASH_CACHE DEFAULT
               ),  
  PARTITION PROCS VALUES ('ADT-PROCS', 'NONADT-PROCS')
    LOGGING
    NOCOMPRESS 
    TABLESPACE I2B2DAT
    LOB (OBSERVATION_BLOB) STORE AS (
      TABLESPACE  I2B2DAT
      ENABLE      STORAGE IN ROW
      CHUNK       8192
      RETENTION
      NOCACHE
      LOGGING
          STORAGE    (
                      INITIAL          64K
                      NEXT             1M
                      MINEXTENTS       1
                      MAXEXTENTS       UNLIMITED
                      PCTINCREASE      0
                      BUFFER_POOL      DEFAULT
                      FLASH_CACHE      DEFAULT
                      CELL_FLASH_CACHE DEFAULT
                     ))
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
                FLASH_CACHE      DEFAULT
                CELL_FLASH_CACHE DEFAULT
               ),  
  PARTITION DRGS VALUES ('ADT-DRGS', 'NONADT-DRGS')
    NOLOGGING
    COMPRESS BASIC 
    TABLESPACE I2B2DAT
    LOB (OBSERVATION_BLOB) STORE AS (
      TABLESPACE  I2B2DAT
      ENABLE      STORAGE IN ROW
      CHUNK       8192
      RETENTION
      NOCACHE
      LOGGING
          STORAGE    (
                      INITIAL          64K
                      NEXT             1M
                      MINEXTENTS       1
                      MAXEXTENTS       UNLIMITED
                      PCTINCREASE      0
                      BUFFER_POOL      DEFAULT
                      FLASH_CACHE      DEFAULT
                      CELL_FLASH_CACHE DEFAULT
                     ))
    PCTFREE    10
    INITRANS   1
    MAXTRANS   255
    STORAGE    (
                INITIAL          64K
                NEXT             1M
                MINEXTENTS       1
                MAXEXTENTS       UNLIMITED
                BUFFER_POOL      DEFAULT
                FLASH_CACHE      DEFAULT
                CELL_FLASH_CACHE DEFAULT
               )
)
NOCACHE
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
MONITORING
/
CREATE INDEX FACT_CNPT_PAT_ENCT_IDX ON OBSERVATION_FACT
(CONCEPT_CD, INSTANCE_NUM, PATIENT_NUM, ENCOUNTER_NUM)
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
/
CREATE INDEX FACT_NOLOB ON OBSERVATION_FACT
(PATIENT_NUM, START_DATE, CONCEPT_CD, ENCOUNTER_NUM, INSTANCE_NUM, 
NVAL_NUM, TVAL_CHAR, VALTYPE_CD, MODIFIER_CD, VALUEFLAG_CD, 
PROVIDER_ID, QUANTITY_NUM, UNITS_CD, END_DATE, LOCATION_CD, 
CONFIDENCE_NUM, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD, 
UPLOAD_ID)
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
/
CREATE INDEX FACT_PATCON_DATE_PRVD_IDX ON OBSERVATION_FACT
(PATIENT_NUM, CONCEPT_CD, START_DATE, END_DATE, ENCOUNTER_NUM, 
INSTANCE_NUM, PROVIDER_ID, NVAL_NUM, VALTYPE_CD)
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
/
CREATE INDEX IDX_OBSFACT_CONCEPT ON OBSERVATION_FACT
(CONCEPT_CD)
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
/
CREATE INDEX IDX_OBSFACT_ENCOUNTER ON OBSERVATION_FACT
(ENCOUNTER_NUM)
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
PARALLEL ( DEGREE DEFAULT INSTANCES 1 )
/
CREATE UNIQUE INDEX OBSERVATION_FACT_PK ON OBSERVATION_FACT
(PATIENT_NUM, CONCEPT_CD, MODIFIER_CD, START_DATE, ENCOUNTER_NUM, 
INSTANCE_NUM, PROVIDER_ID)
LOGGING
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
ALTER TABLE OBSERVATION_FACT ADD (
  CONSTRAINT OBSERVATION_FACT_PK
  PRIMARY KEY
  (PATIENT_NUM, CONCEPT_CD, MODIFIER_CD, START_DATE, ENCOUNTER_NUM, INSTANCE_NUM, PROVIDER_ID)
  USING INDEX OBSERVATION_FACT_PK
  ENABLE VALIDATE)
/
GRANT SELECT ON OBSERVATION_FACT TO OMOP_ETL
/
