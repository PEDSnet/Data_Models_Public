
CREATE TABLE cohort (
	cohort_id BIGINT DEFAULT nextval('cohort_cohort_id_seq'::regclass) NOT NULL, 
	cohort_concept_id INTEGER NOT NULL, 
	cohort_start_date DATE NOT NULL, 
	cohort_end_date DATE, 
	subject_id BIGINT NOT NULL, 
	stop_reason VARCHAR(100), 
	CONSTRAINT cohort_pkey PRIMARY KEY (cohort_id)
)


CREATE TABLE location (
	location_id BIGINT DEFAULT nextval('location_location_id_seq'::regclass) NOT NULL, 
	state CHAR(2), 
	zip VARCHAR(9), 
	address_1 VARCHAR(100), 
	address_2 VARCHAR(100), 
	city VARCHAR(50), 
	county VARCHAR(50), 
	location_source_value VARCHAR(300), 
	CONSTRAINT location_pkey PRIMARY KEY (location_id)
)


CREATE TABLE organization (
	organization_id BIGINT DEFAULT nextval('organization_organization_id_seq'::regclass) NOT NULL, 
	place_of_service_concept_id INTEGER, 
	location_id BIGINT, 
	organization_source_value VARCHAR(50) NOT NULL, 
	place_of_service_source_value VARCHAR(100), 
	CONSTRAINT organization_pkey PRIMARY KEY (organization_id), 
	CONSTRAINT organization_location_fk FOREIGN KEY(location_id) REFERENCES location (location_id)
)

CREATE INDEX organization_organization_pos ON organization (organization_source_value, place_of_service_source_value)
CREATE TABLE care_site (
	care_site_id BIGINT DEFAULT nextval('care_site_care_site_id_seq'::regclass) NOT NULL, 
	place_of_service_concept_id INTEGER, 
	location_id BIGINT, 
	care_site_source_value VARCHAR(100) NOT NULL, 
	place_of_service_source_value VARCHAR(100), 
	organization_id BIGINT NOT NULL, 
	CONSTRAINT care_site_pkey PRIMARY KEY (care_site_id), 
	CONSTRAINT care_site_location_fk FOREIGN KEY(location_id) REFERENCES location (location_id), 
	CONSTRAINT care_site_organization_fk FOREIGN KEY(organization_id) REFERENCES organization (organization_id)
)


CREATE TABLE provider (
	provider_id BIGINT DEFAULT nextval('provider_provider_id_seq'::regclass) NOT NULL, 
	specialty_concept_id INTEGER, 
	care_site_id BIGINT NOT NULL, 
	npi VARCHAR(20), 
	dea VARCHAR(20), 
	year_of_birth INTEGER, 
	provider_source_value VARCHAR(100) NOT NULL, 
	specialty_source_value VARCHAR(50), 
	CONSTRAINT provider_pkey PRIMARY KEY (provider_id), 
	CONSTRAINT provider_care_site_fk FOREIGN KEY(care_site_id) REFERENCES care_site (care_site_id)
)


CREATE TABLE person (
	person_id BIGINT DEFAULT nextval('person_person_id_seq'::regclass) NOT NULL, 
	gender_concept_id INTEGER NOT NULL, 
	year_of_birth INTEGER NOT NULL, 
	month_of_birth INTEGER, 
	day_of_birth INTEGER, 
	pn_time_of_birth TIME, 
	race_concept_id INTEGER, 
	ethnicity_concept_id INTEGER, 
	location_id BIGINT, 
	provider_id BIGINT, 
	care_site_id BIGINT NOT NULL, 
	pn_gestational_age NUMERIC(4, 2), 
	person_source_value VARCHAR(100), 
	gender_source_value VARCHAR(50), 
	race_source_value VARCHAR(50), 
	ethnicity_source_value VARCHAR(50), 
	CONSTRAINT person_pkey PRIMARY KEY (person_id), 
	CONSTRAINT person_care_site_fk FOREIGN KEY(care_site_id) REFERENCES care_site (care_site_id), 
	CONSTRAINT person_location_fk FOREIGN KEY(location_id) REFERENCES location (location_id), 
	CONSTRAINT person_provider_fk FOREIGN KEY(provider_id) REFERENCES provider (provider_id)
)


CREATE TABLE observation_period (
	observation_period_id BIGINT DEFAULT nextval('observation_period_observation_period_id_seq'::regclass) NOT NULL, 
	person_id BIGINT NOT NULL, 
	observation_period_start_date DATE NOT NULL, 
	observation_period_end_date DATE NOT NULL, 
	CONSTRAINT observation_period_pkey PRIMARY KEY (observation_period_id), 
	CONSTRAINT observation_period_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)

CREATE UNIQUE INDEX observation_period_person ON observation_period (person_id, observation_period_start_date)
CREATE TABLE death (
	person_id BIGINT NOT NULL, 
	death_date DATE NOT NULL, 
	death_type_concept_id INTEGER NOT NULL, 
	cause_of_death_concept_id INTEGER, 
	cause_of_death_source_value VARCHAR(100), 
	CONSTRAINT death_pkey PRIMARY KEY (person_id, death_type_concept_id), 
	CONSTRAINT death_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)


CREATE TABLE visit_occurrence (
	visit_occurrence_id BIGINT DEFAULT nextval('visit_occurrence_visit_occurrence_id_seq'::regclass) NOT NULL, 
	person_id BIGINT NOT NULL, 
	visit_start_date DATE NOT NULL, 
	visit_end_date DATE, 
	visit_type_concept_id INTEGER NOT NULL, 
	provider_id BIGINT, 
	care_site_id BIGINT, 
	visit_source_value VARCHAR(100), 
	CONSTRAINT visit_occurrence_pkey PRIMARY KEY (visit_occurrence_id), 
	CONSTRAINT visit_occurrence_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)

CREATE INDEX visit_occurrence_person_date ON visit_occurrence (person_id, visit_start_date)
CREATE TABLE condition_era (
	condition_era_id BIGINT DEFAULT nextval('condition_era_condition_era_id_seq'::regclass) NOT NULL, 
	person_id BIGINT NOT NULL, 
	condition_concept_id INTEGER NOT NULL, 
	condition_era_start_date DATE NOT NULL, 
	condition_era_end_date DATE NOT NULL, 
	condition_type_concept_id INTEGER NOT NULL, 
	condition_occurrence_count INTEGER, 
	CONSTRAINT condition_era_pkey PRIMARY KEY (condition_era_id), 
	CONSTRAINT condition_era_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)


CREATE TABLE payer_plan_period (
	payer_plan_period_id BIGINT DEFAULT nextval('payer_plan_period_payer_plan_period_id_seq'::regclass) NOT NULL, 
	person_id BIGINT NOT NULL, 
	payer_plan_period_start_date DATE NOT NULL, 
	payer_plan_period_end_date DATE NOT NULL, 
	payer_source_value VARCHAR(100), 
	plan_source_value VARCHAR(100), 
	family_source_value VARCHAR(100), 
	CONSTRAINT payer_plan_period_pkey PRIMARY KEY (payer_plan_period_id), 
	CONSTRAINT payer_plan_period_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)


CREATE TABLE drug_era (
	drug_era_id BIGINT DEFAULT nextval('drug_era_drug_era_id_seq'::regclass) NOT NULL, 
	person_id BIGINT NOT NULL, 
	drug_concept_id INTEGER NOT NULL, 
	drug_era_start_date DATE NOT NULL, 
	drug_era_end_date DATE NOT NULL, 
	drug_type_concept_id INTEGER NOT NULL, 
	drug_exposure_count NUMERIC(4, 0), 
	CONSTRAINT drug_era_pkey PRIMARY KEY (drug_era_id), 
	CONSTRAINT drug_era_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)


CREATE TABLE drug_exposure (
	drug_exposure_id BIGINT DEFAULT nextval('drug_exposure_drug_exposure_id_seq'::regclass) NOT NULL, 
	person_id INTEGER NOT NULL, 
	drug_concept_id INTEGER NOT NULL, 
	drug_exposure_start_date DATE NOT NULL, 
	drug_exposure_end_date DATE, 
	drug_type_concept_id INTEGER NOT NULL, 
	stop_reason VARCHAR(100), 
	refills INTEGER, 
	quantity INTEGER, 
	days_supply INTEGER, 
	sig VARCHAR(500), 
	prescribing_provider_id BIGINT, 
	visit_occurrence_id BIGINT, 
	relevant_condition_concept_id INTEGER, 
	drug_source_value VARCHAR(100), 
	CONSTRAINT drug_exposure_pkey PRIMARY KEY (drug_exposure_id), 
	CONSTRAINT drug_exposure_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id), 
	CONSTRAINT drug_exposure_provider_fk FOREIGN KEY(prescribing_provider_id) REFERENCES provider (provider_id), 
	CONSTRAINT drug_visit_fk FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
)


CREATE TABLE condition_occurrence (
	condition_occurrence_id BIGINT DEFAULT nextval('condition_occurrence_condition_occurrence_id_seq'::regclass) NOT NULL, 
	person_id BIGINT NOT NULL, 
	condition_concept_id INTEGER NOT NULL, 
	condition_start_date DATE NOT NULL, 
	condition_end_date DATE, 
	condition_type_concept_id INTEGER NOT NULL, 
	stop_reason VARCHAR(100), 
	associated_provider_id BIGINT, 
	visit_occurrence_id BIGINT, 
	condition_source_value VARCHAR(100), 
	CONSTRAINT condition_occurrence_pkey PRIMARY KEY (condition_occurrence_id), 
	CONSTRAINT condition_occurrence_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id), 
	CONSTRAINT condition_provider_fk FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id), 
	CONSTRAINT condition_visit_fk FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
)


CREATE TABLE observation (
	observation_id BIGINT DEFAULT nextval('observation_observation_id_seq'::regclass) NOT NULL, 
	person_id BIGINT NOT NULL, 
	observation_concept_id INTEGER NOT NULL, 
	observation_date DATE NOT NULL, 
	observation_time TIME, 
	observation_type_concept_id INTEGER NOT NULL, 
	value_as_number NUMERIC(14, 3), 
	value_as_string VARCHAR(60), 
	value_as_concept_id INTEGER, 
	unit_concept_id INTEGER, 
	associated_provider_id BIGINT, 
	visit_occurrence_id BIGINT, 
	relevant_condition_concept_id INTEGER, 
	observation_source_value VARCHAR(100), 
	unit_source_value VARCHAR(100), 
	range_low NUMERIC(14, 3), 
	range_high NUMERIC(14, 3), 
	CONSTRAINT observation_pkey PRIMARY KEY (observation_id), 
	CONSTRAINT observation_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id), 
	CONSTRAINT observation_provider_fk FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id), 
	CONSTRAINT observation_visit_fk FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
)

CREATE INDEX observation_person_idx ON observation (person_id, observation_concept_id)
CREATE TABLE procedure_occurrence (
	procedure_occurrence_id BIGINT DEFAULT nextval('procedure_occurrence_procedure_occurrence_id_seq'::regclass) NOT NULL, 
	person_id BIGINT NOT NULL, 
	procedure_concept_id INTEGER NOT NULL, 
	procedure_date DATE NOT NULL, 
	procedure_type_concept_id INTEGER NOT NULL, 
	associated_provider_id BIGINT, 
	visit_occurrence_id BIGINT, 
	relevant_condition_concept_id INTEGER, 
	procedure_source_value VARCHAR(100), 
	CONSTRAINT procedure_occurrence_pkey PRIMARY KEY (procedure_occurrence_id), 
	CONSTRAINT procedure_occurrence_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id), 
	CONSTRAINT procedure_provider_fk FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id), 
	CONSTRAINT procedure_visit_fk FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
)


CREATE TABLE drug_cost (
	drug_cost_id BIGINT DEFAULT nextval('drug_cost_drug_cost_id_seq'::regclass) NOT NULL, 
	drug_exposure_id BIGINT NOT NULL, 
	paid_copay NUMERIC(8, 2), 
	paid_coinsurance NUMERIC(8, 2), 
	paid_toward_deductible NUMERIC(8, 2), 
	paid_by_payer NUMERIC(8, 2), 
	paid_by_coordination_benefits NUMERIC(8, 2), 
	total_out_of_pocket NUMERIC(8, 2), 
	total_paid NUMERIC(8, 2), 
	ingredient_cost NUMERIC(8, 2), 
	dispensing_fee NUMERIC(8, 2), 
	average_wholesale_price NUMERIC(8, 2), 
	payer_plan_period_id BIGINT, 
	CONSTRAINT drug_cost_pkey PRIMARY KEY (drug_cost_id), 
	CONSTRAINT drug_cost_drug_exposure_fk FOREIGN KEY(drug_exposure_id) REFERENCES drug_exposure (drug_exposure_id), 
	CONSTRAINT drug_cost_payer_plan_period_fk FOREIGN KEY(payer_plan_period_id) REFERENCES payer_plan_period (payer_plan_period_id)
)


CREATE TABLE procedure_cost (
	procedure_cost_id BIGINT DEFAULT nextval('procedure_cost_procedure_cost_id_seq'::regclass) NOT NULL, 
	procedure_occurrence_id BIGINT NOT NULL, 
	paid_copay NUMERIC(8, 2), 
	paid_coinsurance NUMERIC(8, 2), 
	paid_toward_deductible NUMERIC(8, 2), 
	paid_by_payer NUMERIC(8, 2), 
	paid_by_coordination_benefits NUMERIC(8, 2), 
	total_out_of_pocket NUMERIC(8, 2), 
	total_paid NUMERIC(8, 2), 
	disease_class_concept_id INTEGER, 
	revenue_code_concept_id INTEGER, 
	payer_plan_period_id BIGINT, 
	disease_class_source_value VARCHAR(100), 
	revenue_code_source_value VARCHAR(100), 
	CONSTRAINT procedure_cost_pkey PRIMARY KEY (procedure_cost_id), 
	CONSTRAINT procedure_cost_payer_plan_fk FOREIGN KEY(payer_plan_period_id) REFERENCES payer_plan_period (payer_plan_period_id), 
	CONSTRAINT procedure_cost_procedure_fk FOREIGN KEY(procedure_occurrence_id) REFERENCES procedure_occurrence (procedure_occurrence_id)
)

