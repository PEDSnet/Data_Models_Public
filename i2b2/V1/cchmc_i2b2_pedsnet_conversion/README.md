## How to convert from the CCHMC i2b2 CDM to PEDSnet CDM

The i2b2_chop and rev_[2-5] directories are copied from the CCHMC's Subversion repository, specifically, from here:

https://bmi.cchmc.org/svnx/i2b2/PEDSNet-I2B2/i2b2_pedsnet_cdm/tags

Overview:

* Create the I2B2ETL and OMOP_ETL schemas.
* Run the .sql script in i2b2_chop/ to prepare the I2B2ETL schema.
* Load user data into the I2B2ETL schema.
* Run the .sql scripts from rev2 through rev_5 (in the order specified by the readme files).
* At the end, run the most recent i2b2_omop_refresh.sql (which will refer to the most recent I2B2_TO_OMOP_ETL_PKG).

These notes have been garnered from https://github.com/PEDSnet/Data_Coordinating_Center/issues/80 and a conversation with Parth Divekar and Rajesh Ganta on Feb 4, 2015 at 11AM.

### Create and populate the i2b2 schema

* Manually create the I2B2ETL schema and user.
* Get and unzip the ontology data files into i2b2_chop/ddl/ (or wherever, but adjust paths below):
i2b2_chop_conceptdim_inserts.sql.gz
i2b2_chop_ont_inserts_1.sql.gz
i2b2_chop_ont_inserts_2.sql.gz
i2b2_chop_ont_inserts_3.sql.gz
* Run:

    @i2b2_chop/ddl/i2b2_chop_base_setup_ddls.sql

This creates the I2B2, CONCEPT_DIMENSION, PATIENT_DIMENSION, VISIT_DIMENSION, and OBSERVATION_FACT tables.

* Insert 623 MB of ontology data into the I2B2 table by running:

    @i2b2_chop/data/i2b2_chop_ont_inserts_1.sql -- [182 MB]
    @i2b2_chop/data/i2b2_chop_ont_inserts_2.sql -- [161 MB]
    @i2b2_chop/data/i2b2_chop_ont_inserts_3.sql -- [280 MB]

* Insert the 99 MB CONCEPT_DIMENSION ontology data by running:

    @i2b2_chop/data/i2b2_chop_conceptdim_inserts.sql -- [99 MB]

The ontology loads into the I2B2 and CONCEPT_DIMENSION tables take 51 minutes on the Oracle instance we have available to us.

* Load data into I2B2 tables ... TBD

### Create and populate the PEDSnet CDM tables

For PEDSNET OMOP [I2B2 CHOP -> PEDSNET OMOP], below is the PEDSNET OMOP CCHMC SVN URL link:
https://bmi.cchmc.org/svnx/i2b2/PEDSNet-I2B2/i2b2_pedsnet_cdm/tags/

### rev_2

The .sql files below accomplish steps are adapted from the readme:

After manually creating the OMOP_ETL schema and user, from folder
rev_2 through rev_5, follow the instructions of the corresponding
*_readme.txt file.  This will involve running the .sql files contained
in each rev_N folder, but there may be manual steps.

One thing I'm not sure about is when the vocabulary tables get loaded.

    @rev_2/ddl/i2b2etl_omop_grants.sql  -- same as rev_4 (allow OMOP_ETL to access I2B2ETL.{PATIENT_DIMENSION, VISIT_DIMENSION, OBSERVATION_FACT})
    @rev_2/ddl/i2b2_omop_sequences.sql  -- complementary to rev_3
    @rev_2/ddl/i2b2_omop_procedures.sql  -- unique; refreshes MVs and gathers stats
    @rev_2/ddl/i2b2_omop_base_setup_ddls.sql  -- creates PEDSnet CDM
    @rev_2/data/i2b2_omop_base_data.sql  -- load omop_mapping, omop_tables

    @rev_2/ddl/drop_constraints_truncate_and_restore_constraints.sql -- new script distilled from readme

    @rev_2/ddl/i2b2_omop_mvs.sql  -- create mv_omop_dx_codes, mv_person, needed to load condition_occurrence
    @rev_2/ddl/i2b2_omop_vws.sql  -- create omop_etl_gen_map view, needed to load condition_era
    @rev_2/ddl/i2b2_omop_packages.sql  -- the main code to do the i2b2-to-pedsnet conversion

    -- Sequence of execution for one time loading data
    alter package OMOP_ETL.I2B2_TO_OMOP_ETL_PKG compile package;
    execute OMOP_ETL.I2B2_TO_OMOP_ETL_PKG.sp_I2B2_To_OMOP_ETL;
    execute OMOP_ETL.SP_OMOP_PREPARE_STATS;

    -- Refresh
    @rev_2/ddl/i2b2_omop_refresh.sql  -- ah, this just runs the two previous execute statements

### rev_3

    @rev_3/ddl/i2b2_omop_alt_table.sql  -- modify type of location.zip
    @rev_3/ddl/i2b2_omop_sequences.sql  -- complementary to rev_2 (adds location_seq)
    @rev_3/ddl/i2b2_omop_base_table_ddl.sql  -- ??? some housekeeping thing
    @rev_3/data/i2b2_omop_base_data.sql  -- inserts into omop_mapping table
    @rev_3/ddl/i2b2_omop_mvs.sql  -- recreate mv_person
    @rev_3/ddl/i2b2_omop_packages.sql  -- rewrite of the main code to do the i2b2-to-pedsnet conversion

    -- Load data
    alter package OMOP_ETL.I2B2_TO_OMOP_ETL_PKG compile package;
    execute OMOP_ETL.I2B2_TO_OMOP_ETL_PKG.sp_I2B2_To_OMOP_ETL;
    execute OMOP_ETL.SP_OMOP_PREPARE_STATS;

    -- Refresh
    @rev_3/ddl/i2b2_omop_refresh.sql

### rev_4

    @rev_4/ddl/i2b2etl_omop_grants.sql   -- same as rev_2! (allow OMOP_ETL to access I2B2ETL.{PATIENT_DIMENSION, VISIT_DIMENSION, OBSERVATION_FACT})
    @rev_4/ddl/i2b2_omop_index.sql  -- rebuild omop_mapping_index
    @rev_4/data/i2b2_omop_base_data.sql  -- inserts into omop_mapping table
    @rev_4/ddl/i2b2_omop_packages.sql  -- redefine main code to do the conversion

    -- Sequence of execution for loading data
    alter package OMOP_ETL.I2B2_TO_OMOP_ETL_PKG compile package;
    execute OMOP_ETL.I2B2_TO_OMOP_ETL_PKG.sp_I2B2_To_OMOP_ETL;
    execute OMOP_ETL.SP_OMOP_PREPARE_STATS;

    -- Refresh
    @rev_4/ddl/i2b2_omop_refresh.sql

### rev_5

    @rev_5/ddl/i2b2etl_omop_grants.sql  -- same as rev_4 and rev_2
    @rev_5/data/i2b2_omop_base_data.sql  -- inserts into omop_mapping table
    @rev_5/ddl/i2b2_omop_packages.sql  -- redefine main code to do the conversion

    -- Refresh
    @rev_5/ddl/i2b2_omop_refresh.sql
