--=============================================================================
--
-- NAME
--
-- i2b2_chop_readme.txt
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 02/05/2015
--
-- SCHEMA / USER : I2B2ETL
-- I2B2
-- Oracle Database 11gR2
--
-- SETUP ASSUMPTIONS:
-- 1. Make sure I2B2ETL schema/user is created in Oracle database.
-- 2. Make sure OMOP_ETL schema/user exists under same Oracle database.
--
-- DESCRIPTION
-- Follow the below mentioned sequence order of one time execution initially in new
-- schema.
--
--=============================================================================
READ ME

-- Sequence of execution one time for setting up the environment
@ddl/i2b2_chop_base_setup_ddls.sql
@data/i2b2_chop_ont_inserts_1.sql
@data/i2b2_chop_ont_inserts_2.sql
@data/i2b2_chop_ont_inserts_3.sql
@data/i2b2_chop_conceptdim_inserts.sql


-- If there is any issue while executing the above steps, please contact Stephanie Loos.
-- Contact details - Email -   Stephanie.Loos@cchmc.org
--                      Work #    513-803-4350
