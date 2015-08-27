--=============================================================================
--
-- NAME
--
-- i2b2_omop_sequences.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 11/19/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION:
-- Under OMOP_ETL schema run below sequence statements.
-- If following sequences exists drop and recreate them in below mentioned
-- orders.
--
--=============================================================================
DROP SEQUENCE CONDITION_ERA_SEQ
/
CREATE SEQUENCE CONDITION_ERA_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 1000000
  NOORDER
/
DROP SEQUENCE CONDITION_OCCUR_SEQ
/
CREATE SEQUENCE CONDITION_OCCUR_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
/
DROP SEQUENCE OBSERVATION_PERIOD_SEQ
/
CREATE SEQUENCE OBSERVATION_PERIOD_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
/
DROP SEQUENCE OBSERVATION_SEQ
/
CREATE SEQUENCE OBSERVATION_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
/
DROP SEQUENCE OMOP_ERROR_LOG_SEQ
/
CREATE SEQUENCE OMOP_ERROR_LOG_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
/
DROP SEQUENCE PROCEDURE_OCCUR_SEQ
/
CREATE SEQUENCE PROCEDURE_OCCUR_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER
/