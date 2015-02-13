--=============================================================================
--
-- NAME
--
-- i2b2_omop_sequences.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 12/11/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION:
-- Under OMOP_ETL schema run below sequence statement, needed for to load into
-- LOCATION table.
--
--=============================================================================
CREATE SEQUENCE LOCATION_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
/
