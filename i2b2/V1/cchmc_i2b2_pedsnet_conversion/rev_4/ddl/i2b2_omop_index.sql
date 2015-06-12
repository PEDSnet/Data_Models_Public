--=============================================================================
--
-- NAME
--
-- i2b2_omop_index.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 12/31/2014
--
-- SCHEMA / USER : OMOP_ETL
--PEDSNET OMOP CDM VERSION : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION:
-- Under OMOP_ETL schema, run below scripts for to drop and recreate
-- OMOP_MAPPING_INDEX for table OMOP_MAPPING.
-- For this release added additional column DESTINATION_VALUE for to make
-- as part of unique index as well.
--
--=============================================================================
DROP INDEX OMOP_MAPPING_INDEX
/
CREATE UNIQUE INDEX OMOP_MAPPING_INDEX ON OMOP_MAPPING
(DESTINATION_TABLE, DESTINATION_COLUMN, SOURCE_VALUE, DESTINATION_VALUE)
NOLOGGING
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
