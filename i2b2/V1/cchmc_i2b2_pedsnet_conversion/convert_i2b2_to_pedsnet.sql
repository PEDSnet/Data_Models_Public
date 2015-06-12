-- convert_i2b2_to_pedsnet.sql
-- Convert data from the "I2B2 CDM" to the pedsnet CDM.
-- Run the scripts in the proper order from rev_2 through rev_5

@rev_2/ddl/i2b2etl_omop_grants.sql  -- same as rev_4 (allow OMOP_ETL to access I2B2ETL.{PATIENT_DIMENSION, VISIT_DIMENSION, OBSERVATION_FACT})
@rev_2/ddl/i2b2_omop_sequences.sql  -- complementary to rev_3
@rev_2/ddl/i2b2_omop_procedures.sql  -- unique; refreshes MVs and gathers stats
@rev_2/ddl/i2b2_omop_base_setup_ddls.sql  -- creates PEDSnet CDM
@rev_2/data/i2b2_omop_base_data.sql  -- load omop_mapping, omop_tables

@rev_2/ddl/drop_constraints_truncate_and_restore_constraints.sql -- new script distilled from readme

@rev_2/ddl/i2b2_omop_mvs.sql  -- create mv_omop_dx_codes, mv_person, needed to load condition_occurrence
@rev_2/ddl/i2b2_omop_vws.sql  -- create omop_etl_gen_map view, needed to load condition_era
@rev_2/ddl/i2b2_omop_packages.sql  -- the main code to do the i2b2-to-pedsnet conversion

@rev_3/ddl/i2b2_omop_alt_table.sql  -- modify type of location.zip
@rev_3/ddl/i2b2_omop_sequences.sql  -- complementary to rev_2 (adds location_seq)
@rev_3/ddl/i2b2_omop_base_table_ddl.sql  -- ??? some housekeeping thing
@rev_3/data/i2b2_omop_base_data.sql  -- inserts into omop_mapping table
@rev_3/ddl/i2b2_omop_mvs.sql  -- recreate mv_person
@rev_3/ddl/i2b2_omop_packages.sql  -- rewrite of the main code to do the i2b2-to-pedsnet conversion

@rev_4/ddl/i2b2etl_omop_grants.sql   -- same as rev_2! (allow OMOP_ETL to access I2B2ETL.{PATIENT_DIMENSION, VISIT_DIMENSION, OBSERVATION_FACT})
@rev_4/ddl/i2b2_omop_index.sql  -- rebuild omop_mapping_index
@rev_4/data/i2b2_omop_base_data.sql  -- inserts into omop_mapping table
@rev_4/ddl/i2b2_omop_packages.sql  -- redefine main code to do the conversion

@rev_5/ddl/i2b2etl_omop_grants.sql  -- same as rev_4 and rev_2
@rev_5/data/i2b2_omop_base_data.sql  -- inserts into omop_mapping table
@rev_5/ddl/i2b2_omop_packages.sql  -- redefine main code to do the conversion

@rev_5/ddl/i2b2_omop_refresh.sql
