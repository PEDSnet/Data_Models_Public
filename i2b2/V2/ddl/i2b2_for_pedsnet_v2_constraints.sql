-- Based on https://github.com/PEDSnet/pedsnetcdms/blob/9db9b2dfa8c5176645ee52b4510dc7df1dee58d9/pedsnetcdms/ddloutput/itwobtwocdm/I2B2_CDM_pgsql.ddl

ALTER TABLE observation_fact ADD CONSTRAINT pk_observation_fact PRIMARY KEY (patient_num, concept_cd, modifier_cd, start_date, encounter_num, instance_num, provider_id) DEFERRABLE;

ALTER TABLE concept_dimension ADD CONSTRAINT pk_concept_dimension PRIMARY KEY (concept_path) DEFERRABLE;

ALTER TABLE patient_dimension ADD CONSTRAINT pk_patient_dimension PRIMARY KEY (patient_num) DEFERRABLE;

ALTER TABLE visit_dimension ADD CONSTRAINT pk_visit_dimension PRIMARY KEY (encounter_num, patient_num) DEFERRABLE;

ALTER TABLE provider_dimension ADD CONSTRAINT pk_provider_dimension PRIMARY KEY (provider_path, provider_id) DEFERRABLE;
