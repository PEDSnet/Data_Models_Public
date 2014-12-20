
CREATE TABLE encounter (
	patid VARCHAR(1028) NOT NULL, 
	encounterid VARCHAR(1028) NOT NULL, 
	admit_date VARCHAR(10) NULL, 
	admit_time VARCHAR(5) NULL, 
	discharge_date VARCHAR(10) NULL, 
	discharge_time VARCHAR(5) NULL, 
	providerid VARCHAR(1028) NULL, 
	facility_location VARCHAR(3) NULL, 
	enc_type VARCHAR(2) NULL, 
	facilityid VARCHAR(1028) NULL, 
	discharge_disposition VARCHAR(2) NULL, 
	discharge_status VARCHAR(2) NULL, 
	drg VARCHAR(3) NULL, 
	drg_type VARCHAR(2) NULL, 
	admitting_source VARCHAR(2) NULL, 
	raw_enc_type VARCHAR(1028) NULL, 
	raw_discharge_disposition VARCHAR(1028) NULL, 
	raw_discharge_status VARCHAR(1028) NULL, 
	raw_drg_type VARCHAR(1028) NULL, 
	raw_admitting_source VARCHAR(1028) NULL, 
	CONSTRAINT encounter_pkey PRIMARY KEY (patid, encounterid)
)

;

CREATE TABLE enrollment (
	patid VARCHAR(1028) NOT NULL, 
	enr_start_date VARCHAR(10) NOT NULL, 
	enr_end_date VARCHAR(10) NULL, 
	chart VARCHAR(1) NULL, 
	enr_basis VARCHAR(1) NOT NULL, 
	CONSTRAINT enrollment_pkey PRIMARY KEY (patid, enr_start_date, enr_basis)
)

;

CREATE TABLE diagnosis (
	patid VARCHAR(1028) NOT NULL, 
	encounterid VARCHAR(1028) NOT NULL, 
	enc_type VARCHAR(2) NULL, 
	admit_date VARCHAR(10) NULL, 
	providerid VARCHAR(1028) NULL, 
	dx VARCHAR(18) NOT NULL, 
	dx_type VARCHAR(2) NOT NULL, 
	dx_source VARCHAR(2) NULL, 
	pdx VARCHAR(2) NULL, 
	raw_dx VARCHAR(1028) NULL, 
	raw_dx_type VARCHAR(1028) NULL, 
	raw_dx_source VARCHAR(1028) NULL, 
	raw_hispanic VARCHAR(1028) NULL, 
	raw_pdx VARCHAR(1028) NULL, 
	CONSTRAINT diagnosis_pkey PRIMARY KEY (patid, encounterid, dx, dx_type)
)

;

CREATE TABLE [procedure] (
	patid VARCHAR(1028) NOT NULL, 
	encounterid VARCHAR(1028) NOT NULL, 
	enc_type VARCHAR(2) NULL, 
	admit_date VARCHAR(10) NULL, 
	providerid VARCHAR(1028) NULL, 
	px VARCHAR(11) NOT NULL, 
	px_type VARCHAR(2) NOT NULL, 
	raw_px VARCHAR(1028) NULL, 
	raw_px_type VARCHAR(1028) NULL, 
	CONSTRAINT procedure_pkey PRIMARY KEY (patid, encounterid, px, px_type)
)

;

CREATE TABLE vital (
	patid VARCHAR(1028) NOT NULL, 
	encounterid VARCHAR(1028) NULL, 
	measure_date VARCHAR(10) NOT NULL, 
	measure_time VARCHAR(5) NOT NULL, 
	vital_source VARCHAR(2) NULL, 
	ht NUMERIC(8, 2) NULL, 
	wt NUMERIC(8, 2) NULL, 
	diastolic NUMERIC(4, 0) NULL, 
	systolic NUMERIC(4, 0) NULL, 
	original_bmi NUMERIC(8, 2) NULL, 
	bp_position VARCHAR(2) NULL, 
	raw_vital_source VARCHAR(1028) NULL, 
	raw_diastolic VARCHAR(1028) NULL, 
	raw_systolic VARCHAR(1028) NULL, 
	raw_bp_position VARCHAR(1028) NULL, 
	CONSTRAINT vital_pkey PRIMARY KEY (patid, measure_date, measure_time)
)

;

CREATE TABLE demographic (
	patid VARCHAR(1028) NOT NULL, 
	birth_date VARCHAR(10) NULL, 
	birth_time VARCHAR(5) NULL, 
	sex VARCHAR(2) NULL, 
	hispanic VARCHAR(2) NULL, 
	race VARCHAR(2) NULL, 
	biobank_flag VARCHAR(1) NULL, 
	raw_sex VARCHAR(1028) NULL, 
	raw_hispanic VARCHAR(1028) NULL, 
	raw_race VARCHAR(1028) NULL, 
	CONSTRAINT demographic_pkey PRIMARY KEY (patid)
)

;
