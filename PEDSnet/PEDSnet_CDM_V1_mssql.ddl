
CREATE TABLE cohort (
	cohort_id INTEGER NOT NULL IDENTITY(1,1), 
	cohort_concept_id INTEGER NOT NULL, 
	cohort_start_date DATETIME NOT NULL, 
	cohort_end_date DATETIME NULL, 
	subject_id INTEGER NOT NULL, 
	stop_reason VARCHAR(100) NULL, 
	CONSTRAINT cohort_pkey PRIMARY KEY (cohort_id)
)

;

CREATE TABLE location (
	location_id INTEGER NOT NULL IDENTITY(1,1), 
	state VARCHAR(2) NULL, 
	zip VARCHAR(9) NULL, 
	location_source_value VARCHAR(300) NULL, 
	address_1 VARCHAR(100) NULL, 
	address_2 VARCHAR(100) NULL, 
	city VARCHAR(50) NULL, 
	county VARCHAR(50) NULL, 
	CONSTRAINT location_pkey PRIMARY KEY (location_id)
)

;

CREATE TABLE organization (
	organization_id INTEGER NOT NULL IDENTITY(1,1), 
	place_of_service_concept_id INTEGER NULL, 
	location_id INTEGER NULL, 
	place_of_service_source_value VARCHAR(100) NULL, 
	organization_source_value VARCHAR(50) NOT NULL, 
	CONSTRAINT organization_pkey PRIMARY KEY (organization_id), 
	CONSTRAINT organization_location_fk FOREIGN KEY(location_id) REFERENCES location (location_id)
)

;
CREATE INDEX organization_organization_pos ON organization (organization_source_value, place_of_service_source_value);

CREATE TABLE care_site (
	care_site_id INTEGER NOT NULL IDENTITY(1,1), 
	place_of_service_concept_id INTEGER NULL, 
	location_id INTEGER NULL, 
	care_site_source_value VARCHAR(100) NOT NULL, 
	place_of_service_source_value VARCHAR(100) NULL, 
	organization_id INTEGER NOT NULL, 
	CONSTRAINT care_site_pkey PRIMARY KEY (care_site_id), 
	CONSTRAINT care_site_location_fk FOREIGN KEY(location_id) REFERENCES location (location_id), 
	CONSTRAINT care_site_organization_fk FOREIGN KEY(organization_id) REFERENCES organization (organization_id)
)

;

CREATE TABLE provider (
	provider_id INTEGER NOT NULL IDENTITY(1,1), 
	specialty_concept_id INTEGER NULL, 
	care_site_id INTEGER NOT NULL, 
	npi VARCHAR(20) NULL, 
	dea VARCHAR(20) NULL, 
	provider_source_value VARCHAR(100) NOT NULL, 
	specialty_source_value VARCHAR(300) NULL, 
	CONSTRAINT provider_pkey PRIMARY KEY (provider_id), 
	CONSTRAINT provider_care_site_fk FOREIGN KEY(care_site_id) REFERENCES care_site (care_site_id)
)

;

CREATE TABLE person (
	person_id INTEGER NOT NULL IDENTITY(1,1), 
	gender_concept_id INTEGER NOT NULL, 
	year_of_birth NUMERIC(4, 0) NOT NULL, 
	month_of_birth NUMERIC(2, 0) NULL, 
	day_of_birth NUMERIC(2, 0) NULL, 
	pn_time_of_birth DATETIME NULL, 
	race_concept_id INTEGER NULL, 
	ethnicity_concept_id INTEGER NULL, 
	location_id INTEGER NULL, 
	provider_id INTEGER NULL, 
	care_site_id INTEGER NOT NULL, 
	pn_gestational_age NUMERIC(4, 2) NULL, 
	person_source_value VARCHAR(100) NOT NULL, 
	gender_source_value VARCHAR(50) NULL, 
	race_source_value VARCHAR(50) NULL, 
	ethnicity_source_value VARCHAR(50) NULL, 
	CONSTRAINT person_pkey PRIMARY KEY (person_id), 
	CONSTRAINT person_care_site_fk FOREIGN KEY(care_site_id) REFERENCES care_site (care_site_id), 
	CONSTRAINT person_location_fk FOREIGN KEY(location_id) REFERENCES location (location_id), 
	CONSTRAINT person_provider_fk FOREIGN KEY(provider_id) REFERENCES provider (provider_id)
)

;

CREATE TABLE death (
	person_id INTEGER NOT NULL, 
	death_date DATETIME NOT NULL, 
	death_type_concept_id INTEGER NOT NULL, 
	cause_of_death_concept_id INTEGER NULL, 
	cause_of_death_source_value VARCHAR(100) NULL, 
	CONSTRAINT death_pkey PRIMARY KEY (person_id, death_type_concept_id), 
	CONSTRAINT death_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)

;

CREATE TABLE observation_period (
	observation_period_id INTEGER NOT NULL IDENTITY(1,1), 
	person_id INTEGER NOT NULL, 
	observation_period_start_date DATETIME NOT NULL, 
	observation_period_end_date DATETIME NULL, 
	CONSTRAINT observation_period_pkey PRIMARY KEY (observation_period_id), 
	CONSTRAINT observation_period_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)

;
CREATE UNIQUE INDEX observation_period_person ON observation_period (person_id, observation_period_start_date);

CREATE TABLE visit_occurrence (
	visit_occurrence_id INTEGER NOT NULL IDENTITY(1,1), 
	person_id INTEGER NOT NULL, 
	visit_start_date DATETIME NOT NULL, 
	visit_end_date DATETIME NULL, 
	provider_id INTEGER NULL, 
	care_site_id INTEGER NULL, 
	place_of_service_concept_id INTEGER NOT NULL, 
	place_of_service_source_value VARCHAR(100) NULL, 
	CONSTRAINT visit_occurrence_pkey PRIMARY KEY (visit_occurrence_id), 
	CONSTRAINT visit_occurrence_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)

;
CREATE INDEX visit_occurrence_person_date ON visit_occurrence (person_id, visit_start_date);

CREATE TABLE payer_plan_period (
	payer_plan_period_id INTEGER NOT NULL IDENTITY(1,1), 
	person_id INTEGER NOT NULL, 
	payer_plan_period_start_date DATETIME NOT NULL, 
	payer_plan_period_end_date DATETIME NOT NULL, 
	payer_source_value VARCHAR(100) NULL, 
	plan_source_value VARCHAR(100) NULL, 
	family_source_value VARCHAR(100) NULL, 
	CONSTRAINT payer_plan_period_pkey PRIMARY KEY (payer_plan_period_id), 
	CONSTRAINT payer_plan_period_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)

;

CREATE TABLE drug_era (
	drug_era_id INTEGER NOT NULL IDENTITY(1,1), 
	person_id INTEGER NOT NULL, 
	drug_concept_id INTEGER NOT NULL, 
	drug_era_start_date DATETIME NOT NULL, 
	drug_era_end_date DATETIME NOT NULL, 
	drug_type_concept_id INTEGER NOT NULL, 
	drug_exposure_count NUMERIC(4, 0) NULL, 
	CONSTRAINT drug_era_pkey PRIMARY KEY (drug_era_id), 
	CONSTRAINT drug_era_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)

;

CREATE TABLE condition_era (
	condition_era_id INTEGER NOT NULL IDENTITY(1,1), 
	person_id INTEGER NOT NULL, 
	condition_concept_id INTEGER NOT NULL, 
	condition_era_start_date DATETIME NOT NULL, 
	condition_era_end_date DATETIME NOT NULL, 
	condition_type_concept_id INTEGER NOT NULL, 
	condition_occurrence_count NUMERIC(4, 0) NULL, 
	CONSTRAINT condition_era_pkey PRIMARY KEY (condition_era_id), 
	CONSTRAINT condition_era_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id)
)

;

CREATE TABLE drug_exposure (
	drug_exposure_id INTEGER NOT NULL IDENTITY(1,1), 
	person_id INTEGER NOT NULL, 
	drug_concept_id INTEGER NOT NULL, 
	drug_exposure_start_date DATETIME NOT NULL, 
	drug_exposure_end_date DATETIME NULL, 
	drug_type_concept_id INTEGER NOT NULL, 
	stop_reason VARCHAR(100) NULL, 
	refills NUMERIC(3, 0) NULL, 
	quantity NUMERIC(4, 0) NULL, 
	days_supply NUMERIC(4, 0) NULL, 
	sig VARCHAR(500) NULL, 
	prescribing_provider_id INTEGER NULL, 
	visit_occurrence_id INTEGER NULL, 
	relevant_condition_concept_id INTEGER NULL, 
	drug_source_value VARCHAR(100) NULL, 
	CONSTRAINT drug_exposure_pkey PRIMARY KEY (drug_exposure_id), 
	CONSTRAINT drug_exposure_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id), 
	CONSTRAINT drug_exposure_provider_fk FOREIGN KEY(prescribing_provider_id) REFERENCES provider (provider_id), 
	CONSTRAINT drug_visit_fk FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
)

;

CREATE TABLE condition_occurrence (
	condition_occurrence_id INTEGER NOT NULL IDENTITY(1,1), 
	person_id INTEGER NOT NULL, 
	condition_concept_id INTEGER NOT NULL, 
	condition_start_date DATETIME NOT NULL, 
	condition_end_date DATETIME NULL, 
	condition_type_concept_id INTEGER NOT NULL, 
	stop_reason VARCHAR(100) NULL, 
	associated_provider_id INTEGER NULL, 
	visit_occurrence_id INTEGER NULL, 
	condition_source_value VARCHAR(100) NULL, 
	CONSTRAINT condition_occurrence_pkey PRIMARY KEY (condition_occurrence_id), 
	CONSTRAINT condition_occurrence_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id), 
	CONSTRAINT condition_provider_fk FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id), 
	CONSTRAINT condition_visit_fk FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
)

;

CREATE TABLE procedure_occurrence (
	procedure_occurrence_id INTEGER NOT NULL IDENTITY(1,1), 
	person_id INTEGER NOT NULL, 
	procedure_concept_id INTEGER NOT NULL, 
	procedure_date DATETIME NOT NULL, 
	procedure_type_concept_id INTEGER NOT NULL, 
	associated_provider_id INTEGER NULL, 
	visit_occurrence_id INTEGER NULL, 
	relevant_condition_concept_id INTEGER NULL, 
	procedure_source_value VARCHAR(100) NULL, 
	CONSTRAINT procedure_occurrence_pkey PRIMARY KEY (procedure_occurrence_id), 
	CONSTRAINT procedure_occurrence_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id), 
	CONSTRAINT procedure_provider_fk FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id), 
	CONSTRAINT procedure_visit_fk FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
)

;

CREATE TABLE observation (
	observation_id INTEGER NOT NULL IDENTITY(1,1), 
	person_id INTEGER NOT NULL, 
	observation_concept_id INTEGER NOT NULL, 
	observation_date DATETIME NOT NULL, 
	observation_time DATETIME NULL, 
	observation_type_concept_id INTEGER NOT NULL, 
	value_as_number NUMERIC(14, 3) NULL, 
	value_as_string VARCHAR(4000) NULL, 
	value_as_concept_id INTEGER NULL, 
	unit_concept_id INTEGER NULL, 
	associated_provider_id INTEGER NULL, 
	visit_occurrence_id INTEGER NULL, 
	relevant_condition_concept_id INTEGER NULL, 
	observation_source_value VARCHAR(100) NULL, 
	units_source_value VARCHAR(100) NULL, 
	range_low NUMERIC(14, 3) NULL, 
	range_high NUMERIC(14, 3) NULL, 
	CONSTRAINT observation_pkey PRIMARY KEY (observation_id), 
	CONSTRAINT observation_person_fk FOREIGN KEY(person_id) REFERENCES person (person_id), 
	CONSTRAINT observation_provider_fk FOREIGN KEY(associated_provider_id) REFERENCES provider (provider_id), 
	CONSTRAINT observation_visit_fk FOREIGN KEY(visit_occurrence_id) REFERENCES visit_occurrence (visit_occurrence_id)
)

;
CREATE INDEX observation_person_idx ON observation (person_id, observation_concept_id);

CREATE TABLE procedure_cost (
	procedure_cost_id INTEGER NOT NULL IDENTITY(1,1), 
	procedure_occurrence_id INTEGER NOT NULL, 
	paid_copay NUMERIC(8, 2) NULL, 
	paid_coinsurance NUMERIC(8, 2) NULL, 
	paid_toward_deductible NUMERIC(8, 2) NULL, 
	paid_by_payer NUMERIC(8, 2) NULL, 
	paid_by_coordination_benefits NUMERIC(8, 2) NULL, 
	total_out_of_pocket NUMERIC(8, 2) NULL, 
	total_paid NUMERIC(8, 2) NULL, 
	disease_class_concept_id INTEGER NULL, 
	revenue_code_concept_id INTEGER NULL, 
	payer_plan_period_id INTEGER NULL, 
	disease_class_source_value VARCHAR(100) NULL, 
	revenue_code_source_value VARCHAR(100) NULL, 
	CONSTRAINT procedure_cost_pkey PRIMARY KEY (procedure_cost_id), 
	CONSTRAINT procedure_cost_payer_plan_fk FOREIGN KEY(payer_plan_period_id) REFERENCES payer_plan_period (payer_plan_period_id), 
	CONSTRAINT procedure_cost_procedure_fk FOREIGN KEY(procedure_occurrence_id) REFERENCES procedure_occurrence (procedure_occurrence_id)
)

;

CREATE TABLE drug_cost (
	drug_cost_id INTEGER NOT NULL IDENTITY(1,1), 
	drug_exposure_id INTEGER NOT NULL, 
	paid_copay NUMERIC(8, 2) NULL, 
	paid_coinsurance NUMERIC(8, 2) NULL, 
	paid_toward_deductible NUMERIC(8, 2) NULL, 
	paid_by_payer NUMERIC(8, 2) NULL, 
	paid_by_coordination_benefits NUMERIC(8, 2) NULL, 
	total_out_of_pocket NUMERIC(8, 2) NULL, 
	total_paid NUMERIC(8, 2) NULL, 
	ingredient_cost NUMERIC(8, 2) NULL, 
	dispensing_fee NUMERIC(8, 2) NULL, 
	average_wholesale_price NUMERIC(8, 2) NULL, 
	payer_plan_period_id INTEGER NULL, 
	CONSTRAINT drug_cost_pkey PRIMARY KEY (drug_cost_id), 
	CONSTRAINT drug_cost_drug_exposure_fk FOREIGN KEY(drug_exposure_id) REFERENCES drug_exposure (drug_exposure_id), 
	CONSTRAINT drug_cost_payer_plan_period_fk FOREIGN KEY(payer_plan_period_id) REFERENCES payer_plan_period (payer_plan_period_id)
)

;
