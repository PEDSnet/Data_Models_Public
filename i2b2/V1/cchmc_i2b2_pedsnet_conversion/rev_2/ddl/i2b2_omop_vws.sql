--=============================================================================
--
-- NAME
--
-- i2b2_omop_vws.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 11/19/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- NOTE: Under OMOP_ETL schema, please make sure first this table
-- CONDITION_OCCURRENCE is created.
--
-- DESCRIPTION:
-- Under OMOP_ETL schema run below view script, needed for to load data into
-- condition_era table.
--
--=============================================================================
CREATE OR REPLACE FORCE VIEW OMOP_ETL_GEN_MAP
AS
   SELECT CONDITION_CONCEPT_ID AS gen_ancestor_concept_id,
          PERSON_ID AS gen_person_id,
          CONDITION_START_DATE AS gen_start_date,
          CONDITION_END_DATE AS gen_end_date,
          CONDITION_CONCEPT_ID AS gen_descendant_concept_id
     FROM CONDITION_OCCURRENCE
    WHERE CONDITION_CONCEPT_ID <> 0
/
