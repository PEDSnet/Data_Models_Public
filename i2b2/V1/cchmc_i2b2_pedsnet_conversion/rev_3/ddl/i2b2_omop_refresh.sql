--=============================================================================
--
-- NAME
--
-- i2b2_omop_refresh.sql
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
-- Under OMOP_ETL schema run below mentioned serial order of procedures and
-- packages to complete the PEDSNET OMOP refresh load.
--
-- NOTES
-- Please follow the sequence of execution as specified below.
--
--=============================================================================
alter package I2B2_TO_OMOP_ETL_PKG compile package;
execute I2B2_TO_OMOP_ETL_PKG.sp_I2B2_To_OMOP_ETL;
execute SP_OMOP_PREPARE_STATS;
