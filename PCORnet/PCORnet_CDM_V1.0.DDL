CREATE TABLE demographic (
    patid text,
    birth_date varchar(10),
    birth_time varchar(5),
    sex varchar(2),
    hispanic varchar(2),
    race varchar(2),
    biobank_flag varchar(1),
    raw_sex text,
    raw_hispanic text,
    raw_race text
);

CREATE TABLE enrollment (
    patid text,
    enr_start_date varchar(10),
    enr_end_date varchar(10),
    chart varchar(1),
    enr_basis varchar(1)
);

CREATE TABLE encounter (
    patid text,
    encounterid text,
    admit_date varchar(10),
    admit_time varchar(5),
    discharge_date varchar(10),
    discharge_time varchar(5),
    providerid text,
    facility_location varchar(3),
    enc_type varchar(2),
    facilityid text,
    discharge_disposition varchar(2),
    discharge_status varchar(2),
    drg varchar(3),
    drg_type varchar(2),
    admitting_source varchar(2),
    raw_enc_type text,
    raw_discharge_disposition text,
    raw_discharge_status text,
    raw_drg_type text,
    raw_admitting_source text
);

CREATE TABLE diagnosis (
    patid text,
    encounterid text,
    enc_type varchar(2),
    admit_date varchar(10),
    providerid text,
    dx varchar(18),
    dx_type varchar(2),
    dx_source varchar(2),
    pdx varchar(2),
    raw_dx text,
    raw_dx_type text,
    raw_dx_source text,
    raw_pdx text
);

CREATE TABLE procedure (
    patid text,
    encounterid text,
    enc_type varchar(2),
    admit_date varchar(10),
    providerid text,
    px varchar(11),
    px_type varchar(2),
    raw_px text,
    raw_px_type text
);

CREATE TABLE vital (
    patid text,
    encounterid text,
    measure_date varchar(10),
    measure_time varchar(5),
    vital_source varchar(2),
    ht numeric(8, 2),
    wt numeric(8, 2),
    diastolic numeric(4, 0),
    systolic numeric(4, 0),
    original_bmi numeric(8, 2),
    bp_position varchar(2),
    raw_vital_source text,
    raw_diastolic text,
    raw_systolic text,
    raw_bp_position text
);
