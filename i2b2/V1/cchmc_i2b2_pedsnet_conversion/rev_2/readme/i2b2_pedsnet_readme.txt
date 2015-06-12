--=============================================================================
--
-- NAME
--
-- pedsnet_omop_cdm_v2_readme.txt
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 11/19/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION
-- Follow the below mentioned sequence order of one time execution initially in new
-- schema and refresh sequence.
-- Note: As in this version release the DDL scripts changed for table objects related
-- column datatypes and column sizes, plus used Vocabulary version 4.5 files through
-- PEDSNET OMOP.
--
-- NOTES: SETUP ASSUMPTIONS
-- 1. OMOP_ETL Schema exists. If not then please create.
-- 2. I2B2ETL Schema exists with basic core tables (PATIENT_DIMENSION, VISIT_DIMENSION,
-- OBSERVATION_FACT).
-- 3. Once after below step '@data/i2b2_omop_base_data.sql' is done from your side
-- then disable the constraints for following tables (VOCABULARY, CONCEPT, RELATIONSHIP,
-- SOURCE_TO_CONCEPT_MAP, CONCEPT_ANCESTOR, DRUG_APPROVAL, DRUG_STRENGTH,
-- CONCEPT_RELATIONSHIP, CONCEPT_SYNONYM)and then truncate the following OMOP tables in this order
-- (VOCABULARY, CONCEPT, RELATIONSHIP, SOURCE_TO_CONCEPT_MAP, CONCEPT_ANCESTOR,
-- DRUG_APPROVAL, DRUG_STRENGTH, CONCEPT_RELATIONSHIP, CONCEPT_SYNONYM) and then enable the constraints back.
-- Later make sure the following tables in OMOP_ETL schema are loaded with data in following order
-- for tables(VOCABULARY, CONCEPT, RELATIONSHIP, SOURCE_TO_CONCEPT_MAP, CONCEPT_ANCESTOR,
-- DRUG_STRENGTH, CONCEPT_RELATIONSHIP, CONCEPT_SYNONYM), provided the csv format data in zipped format
-- (Vocabulary_4-5.zip, Concept_4-5.zip, Relationship_4-5.zip, SourceToConceptMap_4-5.zip,
-- ConceptAncestor_4-5.zip, DrugStrength_4-5.zip, ConceptRelationship_4-5.zip, ConceptSynonym_4-5.zip)
-- for to load metadata in above mentioned tables using SSIS tool or SQLLoader from this site
-- https://filetransfer.research.cchmc.org/ under folder 'PEDSNET/OMOP Vocab Data files'.
-- Below provided the steps for to do from your side (as using vocabulary version 4.5 files to load this time):
-- STEP 1: DISABLE CONSTRAINTS use query below to disable constraints
SELECT 'alter table '||table_name||' disable constraint '||constraint_name||' cascade;' sqlstatement
            FROM USER_CONSTRAINTS
            WHERE table_name IN
                (
                  'CONCEPT',
                  'CONCEPT_ANCESTOR',
                  'CONCEPT_RELATIONSHIP',
                  'CONCEPT_SYNONYM',
                  'DRUG_APPROVAL',
                  'DRUG_STRENGTH',
                  'RELATIONSHIP',
                  'SOURCE_TO_CONCEPT_MAP',
                  'VOCABULARY'
                )
            ORDER BY
              constraint_type,
              table_name;
--STEP 2: Truncate tables use query below for to truncate tables
TRUNCATE TABLE VOCABULARY
/
TRUNCATE TABLE CONCEPT
/
TRUNCATE TABLE RELATIONSHIP
/
TRUNCATE TABLE SOURCE_TO_CONCEPT_MAP
/
TRUNCATE TABLE CONCEPT_ANCESTOR
/
TRUNCATE TABLE DRUG_APPROVAL
/
TRUNCATE TABLE DRUG_STRENGTH
/
TRUNCATE TABLE CONCEPT_RELATIONSHIP
/
TRUNCATE TABLE CONCEPT_SYNONYM
/
--STEP 3: ENABLE CONSTRAINTS use query below to enable constraints
  SELECT 'alter table '||table_name||' enable constraint '||constraint_name ||';' sqlstatement
            FROM USER_CONSTRAINTS
WHERE table_name IN
                (
                  'CONCEPT',
                  'CONCEPT_ANCESTOR',
                  'CONCEPT_RELATIONSHIP',
                  'CONCEPT_SYNONYM',
                  'DRUG_APPROVAL',
                  'DRUG_STRENGTH',
                  'RELATIONSHIP',
                  'SOURCE_TO_CONCEPT_MAP',
                  'VOCABULARY'
                )
            ORDER BY
              constraint_type,
              table_name;
-- STEP 4: Load data into these tables in following order (VOCABULARY, CONCEPT, RELATIONSHIP,
-- SOURCE_TO_CONCEPT_MAP, CONCEPT_ANCESTOR, DRUG_STRENGTH, CONCEPT_RELATIONSHIP, CONCEPT_SYNONYM)
-- from the csv files data provided in zipped format (Vocabulary_4-5.zip, Concept_4-5.zip, Relationship_4-5.zip,
-- SourceToConceptMap_4-5.zip, ConceptAncestor_4-5.zip, DrugStrength_4-5.zip, ConceptRelationship_4-5.zip,
-- ConceptSynonym_4-5.zip) for to load metadata in above mentioned tables using SSIS tool or SQLLoader
-- from this site https://filetransfer.research.cchmc.org/ placed under folder 'PEDSNET/OMOP Vocab Data files'.
-- 4. Please note that I have added COMPRESS and PARALLEL options assuming that you
-- all are running Oracle 11gR2. If you have not purchased the licenses for these
-- add-ons then set the scripts to "NOCOMPRESS" and "NOPARALLEL". However, we
-- strongly recommend these options as these are very helpful in the ETL process.
-- 5. The following things were noticed and changed from my side in Version 1 format
-- of PEDSNET OMOP CDM for table objects to make ETL to load data from I2B2 into "OMOP_ETL"
-- schema/user :
-- a. changed data type for field "observation_time" from TIMESTAMP to VARCHAR2(10) in
-- OBSERVATION table for to load data of this format 'HH24:MI:SS'.
-- b. changed data type for field "pn_time_of_birth" from TIMESTAMP to VARCHAR2(10) in
-- PERSON table.
-- c. For "OBSERVATION" table (mapped following concepts to):
-- 1a. Height: mapped to concept_id: 3036277 "Body height" (HT) (vocabulary_id: 6).
-- 1b. Height (unit_concept_id): mapped to concept_id: 8582 "centimeter" (vocabulary_id: 11).
-- 2a. Weight: mapped to 3025315 "Body weight" (WT) (vocabulary_id: 6).
-- 2b. Weight (unit_concept_id): mapped to concept_id: 9529 "kilogram" (vocabulary_id: 11).
-- 3.  Body Mass Index (BMI): mapped to concept_id: 3038553 "Body mass index (BMI) [Ratio]" (vocabulary_id: 6).
-- 4.  Diastolic blood pressure: mapped to concept_id: 36356876 "Diastolic blood pressure" (vocabulary_id: 15).
-- 5.  Systolic blood pressure: mapped to concept_id: 36356919 "Systolic blood pressure" (vocabulary_id: 15).
-- 6.  If from source (I2B2) is blank (NULL) then  storing as blank (NULL) value for field "UNIT_CONCEPT_ID"
-- in OBSERVATION table (for BMI, Diastolic and Systolic BP(s)).
--
--=============================================================================
READ ME

-- Sequence of execution for setting up the environment
@ddl/i2b2etl_omop_grants.sql
@ddl/i2b2_omop_sequences.sql
@ddl/i2b2_omop_procedures.sql
@ddl/i2b2_omop_base_setup_ddls.sql
@data/i2b2_omop_base_data.sql
@ddl/i2b2_omop_mvs.sql
@ddl/i2b2_omop_vws.sql
@ddl/i2b2_omop_packages.sql

-- Sequence of execution for one time loading data
alter package OMOP_ETL.I2B2_TO_OMOP_ETL_PKG compile package;
execute OMOP_ETL.I2B2_TO_OMOP_ETL_PKG.sp_I2B2_To_OMOP_ETL;
execute OMOP_ETL.SP_OMOP_PREPARE_STATS;

-- Refresh sequence
@ddl/i2b2_omop_refresh.sql

-- If there is any issue while executing the above steps, please contact Stephanie Loos.
-- Contact details - Email -   Stephanie.Loos@cchmc.org
--                      Work #    513-803-4350
