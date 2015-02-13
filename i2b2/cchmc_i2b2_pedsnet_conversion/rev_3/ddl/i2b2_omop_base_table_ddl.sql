--=============================================================================
--
-- NAME
--
-- i2b2_omop_base_table_ddl.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 12/11/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
-- Tablespace : I2B2DAT
--
-- DESCRIPTION:
-- Under OMOP_ETL schema, run the below base create table statement.
--
--=============================================================================
CREATE TABLE ERR$_LOCATION
(
  ORA_ERR_NUMBER$        NUMBER,
  ORA_ERR_MESG$          VARCHAR2(2000 BYTE),
  ORA_ERR_ROWID$         UROWID(4000),
  ORA_ERR_OPTYP$         VARCHAR2(2 BYTE),
  ORA_ERR_TAG$           VARCHAR2(2000 BYTE),
  LOCATION_ID            VARCHAR2(4000 BYTE),
  ADDRESS_1              VARCHAR2(4000 BYTE),
  ADDRESS_2              VARCHAR2(4000 BYTE),
  CITY                   VARCHAR2(4000 BYTE),
  STATE                  VARCHAR2(4000 BYTE),
  ZIP                    VARCHAR2(4000 BYTE),
  COUNTY                 VARCHAR2(4000 BYTE),
  LOCATION_SOURCE_VALUE  VARCHAR2(4000 BYTE)
)
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
COMMENT ON TABLE ERR$_LOCATION IS 'DML Error NOLOGGING table for "LOCATION"'
/
