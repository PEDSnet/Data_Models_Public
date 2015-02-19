
CREATE TABLE demographic (
	patid VARCHAR2(1028 CHAR) NOT NULL, 
	birth_date VARCHAR2(10 CHAR), 
	birth_time VARCHAR2(5 CHAR), 
	sex VARCHAR2(2 CHAR), 
	hispanic VARCHAR2(2 CHAR), 
	race VARCHAR2(2 CHAR), 
	biobank_flag VARCHAR2(1 CHAR), 
	raw_sex VARCHAR2(1028 CHAR), 
	raw_hispanic VARCHAR2(1028 CHAR), 
	raw_race VARCHAR2(1028 CHAR), 
	CONSTRAINT demographic_pkey PRIMARY KEY (patid)
)

;

CREATE TABLE vital (
	vitalid INTEGER NOT NULL, 
	patid VARCHAR2(1028 CHAR), 
	encounterid VARCHAR2(1028 CHAR), 
	measure_date VARCHAR2(10 CHAR), 
	measure_time VARCHAR2(5 CHAR), 
	vital_source VARCHAR2(2 CHAR), 
	ht NUMERIC(8, 2), 
	wt NUMERIC(8, 2), 
	diastolic NUMERIC(4, 0), 
	systolic NUMERIC(4, 0), 
	original_bmi NUMERIC(8, 2), 
	bp_position VARCHAR2(2 CHAR), 
	raw_vital_source VARCHAR2(1028 CHAR), 
	raw_diastolic VARCHAR2(1028 CHAR), 
	raw_systolic VARCHAR2(1028 CHAR), 
	raw_bp_position VARCHAR2(1028 CHAR), 
	CONSTRAINT vital_pkey PRIMARY KEY (vitalid)
)

;

CREATE TABLE encounter (
	patid VARCHAR2(1028 CHAR) NOT NULL, 
	encounterid VARCHAR2(1028 CHAR) NOT NULL, 
	admit_date VARCHAR2(10 CHAR), 
	admit_time VARCHAR2(5 CHAR), 
	discharge_date VARCHAR2(10 CHAR), 
	discharge_time VARCHAR2(5 CHAR), 
	providerid VARCHAR2(1028 CHAR), 
	facility_location VARCHAR2(3 CHAR), 
	enc_type VARCHAR2(2 CHAR), 
	facilityid VARCHAR2(1028 CHAR), 
	discharge_disposition VARCHAR2(2 CHAR), 
	discharge_status VARCHAR2(2 CHAR), 
	drg VARCHAR2(3 CHAR), 
	drg_type VARCHAR2(2 CHAR), 
	admitting_source VARCHAR2(2 CHAR), 
	raw_enc_type VARCHAR2(1028 CHAR), 
	raw_discharge_disposition VARCHAR2(1028 CHAR), 
	raw_discharge_status VARCHAR2(1028 CHAR), 
	raw_drg_type VARCHAR2(1028 CHAR), 
	raw_admitting_source VARCHAR2(1028 CHAR), 
	CONSTRAINT encounter_pkey PRIMARY KEY (patid, encounterid)
)

;

CREATE TABLE enrollment (
	patid VARCHAR2(1028 CHAR) NOT NULL, 
	enr_start_date VARCHAR2(10 CHAR) NOT NULL, 
	enr_end_date VARCHAR2(10 CHAR), 
	chart VARCHAR2(1 CHAR), 
	enr_basis VARCHAR2(1 CHAR) NOT NULL, 
	CONSTRAINT enrollment_pkey PRIMARY KEY (patid, enr_start_date, enr_basis)
)

;

CREATE TABLE procedure (
	patid VARCHAR2(1028 CHAR) NOT NULL, 
	encounterid VARCHAR2(1028 CHAR) NOT NULL, 
	enc_type VARCHAR2(2 CHAR), 
	admit_date VARCHAR2(10 CHAR), 
	providerid VARCHAR2(1028 CHAR), 
	px VARCHAR2(11 CHAR) NOT NULL, 
	px_type VARCHAR2(2 CHAR) NOT NULL, 
	raw_px VARCHAR2(1028 CHAR), 
	raw_px_type VARCHAR2(1028 CHAR), 
	CONSTRAINT procedure_pkey PRIMARY KEY (patid, encounterid, px, px_type)
)

;

CREATE TABLE diagnosis (
	patid VARCHAR2(1028 CHAR) NOT NULL, 
	encounterid VARCHAR2(1028 CHAR) NOT NULL, 
	enc_type VARCHAR2(2 CHAR), 
	admit_date VARCHAR2(10 CHAR), 
	providerid VARCHAR2(1028 CHAR), 
	dx VARCHAR2(18 CHAR) NOT NULL, 
	dx_type VARCHAR2(2 CHAR) NOT NULL, 
	dx_source VARCHAR2(2 CHAR), 
	pdx VARCHAR2(2 CHAR), 
	raw_dx VARCHAR2(1028 CHAR), 
	raw_dx_type VARCHAR2(1028 CHAR), 
	raw_dx_source VARCHAR2(1028 CHAR), 
	raw_hispanic VARCHAR2(1028 CHAR), 
	raw_pdx VARCHAR2(1028 CHAR), 
	CONSTRAINT diagnosis_pkey PRIMARY KEY (patid, encounterid, dx, dx_type)
)

;
