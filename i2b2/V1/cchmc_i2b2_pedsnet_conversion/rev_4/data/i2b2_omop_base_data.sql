--=============================================================================
--
-- NAME
--
-- i2b2_omop_base_data.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 12/31/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION:
-- Under OMOP_ETL schema run below delete/insert statements.
-- For this release, had to change the C4 and update with CPT-4 value to
-- destination_code field in OMOP_MAPPING table and inserted HCPCS destination_code
-- field into OMOP_MAPPING table for to pull data from I2B2 HCPCS codes into OMOP_ETL
-- procedure_occurrence table as well for this release.
--
--=============================================================================
SET DEFINE OFF;
DELETE FROM OMOP_MAPPING
WHERE DESTINATION_TABLE = 'PROCEDURE_OCCURRENCE';
COMMIT;
Insert into OMOP_MAPPING
   (DESTINATION_TABLE, DESTINATION_COLUMN, SOURCE_VALUE, DESTINATION_VALUE, DESTINATION_CODE,
    DESTINATION_DESC)
 Values
   ('PROCEDURE_OCCURRENCE', 'PROCEDURE_TYPE_CONCEPT_ID', 'ORIGPX:MAPPED', 'HCPCS', 38000275,
    'EHR order list entry');
Insert into OMOP_MAPPING
   (DESTINATION_TABLE, DESTINATION_COLUMN, SOURCE_VALUE, DESTINATION_VALUE, DESTINATION_CODE,
    DESTINATION_DESC)
 Values
   ('PROCEDURE_OCCURRENCE', 'PROCEDURE_TYPE_CONCEPT_ID', 'ORIGPX:MAPPED', 'CPT-4', 38000275,
    'EHR order list entry');
COMMIT;
