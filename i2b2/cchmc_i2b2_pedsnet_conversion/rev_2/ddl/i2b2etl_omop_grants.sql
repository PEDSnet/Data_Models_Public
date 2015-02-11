--=============================================================================
--
-- NAME
--
-- i2b2etl_omop_grants.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 11/19/2014
--
-- SCHEMA / USER : I2B2ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- NOTE: Make sure I2B2ETL schema exists with following basic core tables (patient_dimension,
-- visit_dimension and observation_fact).

-- DESCRIPTION:
-- Run below grant statements from I2B2ETL schema for to give access of basic core 
-- tables to OMOP_ETL schema for to pull data.
-- 
--=============================================================================
GRANT select on I2B2ETL.PATIENT_DIMENSION TO OMOP_ETL
/
GRANT select on I2B2ETL.VISIT_DIMENSION TO OMOP_ETL
/
GRANT select on I2B2ETL.OBSERVATION_FACT TO OMOP_ETL
/
