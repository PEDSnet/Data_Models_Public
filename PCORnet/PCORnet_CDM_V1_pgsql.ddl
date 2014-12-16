
CREATE TABLE encounter (
	patid VARCHAR(1028) NOT NULL, 
	encounterid VARCHAR(1028) NOT NULL, 
	admit_date VARCHAR(10), 
	admit_time VARCHAR(5), 
	discharge_date VARCHAR(10), 
	discharge_time VARCHAR(5), 
	providerid VARCHAR(1028), 
	facility_location VARCHAR(3), 
	enc_type VARCHAR(2), 
	facilityid VARCHAR(1028), 
	discharge_disposition VARCHAR(2), 
	discharge_status VARCHAR(2), 
	drg VARCHAR(3), 
	drg_type VARCHAR(2), 
	admitting_source VARCHAR(2), 
	raw_enc_type VARCHAR(1028), 
	raw_discharge_disposition VARCHAR(1028), 
	raw_discharge_status VARCHAR(1028), 
	raw_drg_type VARCHAR(1028), 
	raw_admitting_source VARCHAR(1028), 
	CONSTRAINT encounter_pkey PRIMARY KEY (patid, encounterid)
)

;

CREATE TABLE enrollment (
	patid VARCHAR(1028) NOT NULL, 
	enr_start_date VARCHAR(10) NOT NULL, 
	enr_end_date VARCHAR(10), 
	chart VARCHAR(1), 
	enr_basis VARCHAR(1) NOT NULL, 
	CONSTRAINT enrollment_pkey PRIMARY KEY (patid, enr_start_date, enr_basis)
)

;

CREATE TABLE diagnosis (
	patid VARCHAR(1028) NOT NULL, 
	encounterid VARCHAR(1028) NOT NULL, 
	enc_type VARCHAR(2), 
	admit_date VARCHAR(10), 
	providerid VARCHAR(1028), 
	dx VARCHAR(18) NOT NULL, 
	dx_type VARCHAR(2) NOT NULL, 
	dx_source VARCHAR(2), 
	pdx VARCHAR(2), 
	raw_dx VARCHAR(1028) NOT NULL, 
	raw_dx_type VARCHAR(1028), 
	raw_dx_source VARCHAR(1028), 
	raw_hispanic VARCHAR(1028), 
	raw_pdx VARCHAR(1028), 
	CONSTRAINT diagnosis_pkey PRIMARY KEY (patid, encounterid, dx, dx_type, raw_dx)
)

;

CREATE TABLE procedure (
	patid VARCHAR(1028) NOT NULL, 
	encounterid VARCHAR(1028) NOT NULL, 
	enc_type VARCHAR(2), 
	admit_date VARCHAR(10), 
	providerid VARCHAR(1028), 
	px VARCHAR(11) NOT NULL, 
	px_type VARCHAR(2) NOT NULL, 
	raw_px VARCHAR(1028) NOT NULL, 
	raw_px_type VARCHAR(1028), 
	CONSTRAINT procedure_pkey PRIMARY KEY (patid, encounterid, px, px_type, raw_px)
)

;

CREATE TABLE vital (
	patid VARCHAR(1028) NOT NULL, 
	encounterid VARCHAR(1028), 
	measure_date VARCHAR(10) NOT NULL, 
	measure_time VARCHAR(5) NOT NULL, 
	vital_source VARCHAR(2), 
	ht NUMERIC(8, 2), 
	wt NUMERIC(8, 2), 
	diastolic NUMERIC(4, 0), 
	systolic NUMERIC(4, 0), 
	original_bmi NUMERIC(8, 2), 
	bp_position VARCHAR(2), 
	raw_vital_source VARCHAR(1028), 
	raw_diastolic VARCHAR(1028), 
	raw_systolic VARCHAR(1028), 
	raw_bp_position VARCHAR(1028), 
	CONSTRAINT vital_pkey PRIMARY KEY (patid, measure_date, measure_time)
)

;

CREATE TABLE demographic (
	patid VARCHAR(1028) NOT NULL, 
	birth_date VARCHAR(10), 
	birth_time VARCHAR(5), 
	sex VARCHAR(2), 
	hispanic VARCHAR(2), 
	race VARCHAR(2), 
	biobank_flag VARCHAR(1), 
	raw_sex VARCHAR(1028), 
	raw_hispanic VARCHAR(1028), 
	raw_race VARCHAR(1028), 
	CONSTRAINT demographic_pkey PRIMARY KEY (patid)
)

;
