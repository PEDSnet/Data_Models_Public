-- Based on https://github.com/PEDSnet/pedsnetcdms/blob/9db9b2dfa8c5176645ee52b4510dc7df1dee58d9/pedsnetcdms/ddloutput/itwobtwocdm/I2B2_CDM_pgsql.ddl
-- Changes:
-- * Knocked out a bunch of indexes since our transform will not make use of them

CREATE INDEX ix_observation_fact_concept_cd ON observation_fact(concept_cd varchar_pattern_ops);
CREATE INDEX ix_observation_fact_modifier_cd ON observation_fact(modifier_cd varchar_pattern_ops);
CREATE INDEX ix_observation_fact_patient_num ON observation_fact(patient_num);
CREATE INDEX ix_observation_fact_provider_id ON observation_fact(provider_id varchar_pattern_ops);

CREATE INDEX ix_concept_dimension_concept_path ON concept_dimension (concept_path varchar_pattern_ops);
CREATE INDEX ix_concept_dimension_upload_id ON concept_dimension (upload_id);

CREATE INDEX ix_patient_dimension_patient_num ON patient_dimension (patient_num);
CREATE INDEX ix_patient_dimension_patient_num_vital_status_cd_birth__0f03 ON patient_dimension (patient_num, vital_status_cd varchar_pattern_ops, birth_date, death_date);
CREATE INDEX ix_patient_dimension_statecityzip_path_patient_num ON patient_dimension (statecityzip_path varchar_pattern_ops, patient_num);
CREATE INDEX ix_patient_dimension_upload_id ON patient_dimension (upload_id);

CREATE INDEX ix_visit_dimension_encounter_num ON visit_dimension (encounter_num);
CREATE INDEX ix_visit_dimension_encounter_num_patient_num ON visit_dimension (encounter_num, patient_num);
CREATE INDEX ix_visit_dimension_sourcesystem_cd ON visit_dimension (sourcesystem_cd varchar_pattern_ops);
CREATE INDEX ix_visit_dimension_start_date_end_date ON visit_dimension (start_date, end_date);
CREATE INDEX ix_visit_dimension_upload_id ON visit_dimension (upload_id);

CREATE INDEX pd_idx_name_char ON provider_dimension(provider_id, name_char);
CREATE INDEX pd_idx_statecityzip ON patient_dimension(statecityzip_path, patient_num);
CREATE INDEX prod_uploadid_idx ON provider_dimension(upload_id);
