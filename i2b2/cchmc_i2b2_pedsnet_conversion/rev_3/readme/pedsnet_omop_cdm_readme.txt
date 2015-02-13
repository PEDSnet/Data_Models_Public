--=============================================================================
--
-- NAME
--
-- pedsnet_omop_cdm_readme.txt
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 12/11/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION
-- For this release, follow below mentioned sequence order of execution under 
-- schema OMOP_ETL and refresh sequence.
--
-- Note: 
-- 1. As in this version release used Vocabulary version 4.5 files through 
-- PEDSNET OMOP. 
-- 2. If vocabulary files data is not loaded into these tables from your side
--(VOCABULARY, CONCEPT, RELATIONSHIP, SOURCE_TO_CONCEPT_MAP, CONCEPT_ANCESTOR, 
-- DRUG_STRENGTH, CONCEPT_RELATIONSHIP, CONCEPT_SYNONYM), provided the 
-- csv format data in zipped format (Vocabulary_4-5.zip, Concept_4-5.zip, 
-- Relationship_4-5.zip, SourceToConceptMap_4-5.zip, ConceptAncestor_4-5.zip, 
-- DrugStrength_4-5.zip, ConceptRelationship_4-5.zip, ConceptSynonym_4-5.zip) 
-- for to load metadata in above mentioned tables use SSIS tool or SQLLoader. 
-- Below is the weburl link for to download the zip files: 
-- https://filetransfer.research.cchmc.org/ under folder 'PEDSNET/OMOP Vocab Data files'.
-- 
-- NOTES: SETUP ASSUMPTIONS 
-- 1. OMOP_ETL Schema exists. If not then please create.
-- 2. I2B2ETL Schema exists with basic core tables (PATIENT_DIMENSION, VISIT_DIMENSION,
-- OBSERVATION_FACT).
--
--=============================================================================
READ ME

-- Sequence of execution for this release
@ddl/i2b2_omop_alt_table.sql
@ddl/i2b2_omop_sequences.sql
@ddl/i2b2_omop_base_table_ddl.sql
@data/i2b2_omop_base_data.sql
@ddl/i2b2_omop_mvs.sql
@ddl/i2b2_omop_packages.sql

-- Sequence of execution for loading data
alter package OMOP_ETL.I2B2_TO_OMOP_ETL_PKG compile package; 
execute OMOP_ETL.I2B2_TO_OMOP_ETL_PKG.sp_I2B2_To_OMOP_ETL;
execute OMOP_ETL.SP_OMOP_PREPARE_STATS;

-- Refresh sequence
@ddl/i2b2_omop_refresh.sql

-- If there is any issue while executing the above steps, please contact Stephanie Loos.   
-- Contact details - Email -   Stephanie.Loos@cchmc.org
--                      Work #    513-803-4350




