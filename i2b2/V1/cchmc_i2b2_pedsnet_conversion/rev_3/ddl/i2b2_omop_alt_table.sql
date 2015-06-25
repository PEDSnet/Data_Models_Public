--=============================================================================
--
-- NAME
--
-- i2b2_omop_alt_table.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 12/11/2014
--
-- SCHEMA / USER : OMOP_ETL
--PEDSNET OMOP CDM VERSION : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION:
-- Under OMOP_ETL schema, run below script for to alter field length of ZIP
-- inside LOCATION table from VARCHAR2(9) to VARCHAR2(50) for to hold zip codes
-- data length > 10.
--
--=============================================================================
ALTER TABLE LOCATION
MODIFY ZIP VARCHAR2(50)
/
