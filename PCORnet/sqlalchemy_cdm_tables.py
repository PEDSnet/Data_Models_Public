from sqlalchemy import Column, String, Numeric
from sqlalchemy.schema import PrimaryKeyConstraint
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


class Demographic(Base):
    __tablename__ = 'demographic'
    __table_args__ = (
        PrimaryKeyConstraint('patid', name='demographic_pkey'),
    )

    patid = Column('patid', String(length=1028))
    birth_date = Column('birth_date', String(length=10))
    birth_time = Column('birth_time', String(length=5))
    sex = Column('sex', String(length=2))
    hispanic = Column('hispanic', String(length=2))
    race = Column('race', String(length=2))
    biobank_flag = Column('biobank_flag', String(length=1))
    raw_sex = Column('raw_sex', String(length=1028))
    raw_hispanic = Column('raw_hispanic', String(length=1028))
    raw_race = Column('raw_race', String(length=1028))


class Enrollment(Base):
    __tablename__ = 'enrollment'
    __table_args__ = (
        PrimaryKeyConstraint('patid', 'enr_start_date', 'enr_basis', name='enrollment_pkey'),
    )

    patid = Column('patid', String(length=1028))
    enr_start_date = Column('enr_start_date', String(length=10))
    enr_end_date = Column('enr_end_date', String(length=10))
    chart = Column('chart', String(length=1))
    enr_basis = Column('enr_basis', String(length=1))


class Encounter(Base):
    __tablename__ = 'encounter'
    __table_args__ = (
        PrimaryKeyConstraint('patid', 'encounterid', name='encounter_pkey'),
    )

    patid = Column('patid', String(length=1028))
    encounterid = Column('encounterid', String(length=1028))
    admit_date = Column('admit_date', String(length=10))
    admit_time = Column('admit_time', String(length=5))
    discharge_date = Column('discharge_date', String(length=10))
    discharge_time = Column('discharge_time', String(length=5))
    providerid = Column('providerid', String(length=1028))
    facility_location = Column('facility_location', String(length=3))
    enc_type = Column('enc_type', String(length=2))
    facilityid = Column('facilityid', String(length=1028))
    discharge_disposition = Column('discharge_disposition', String(length=2))
    discharge_status = Column('discharge_status', String(length=2))
    drg = Column('drg', String(length=3))
    drg_type = Column('drg_type', String(length=2))
    admitting_source = Column('admitting_source', String(length=2))
    raw_enc_type = Column('raw_enc_type', String(length=1028))
    raw_discharge_disposition = Column('raw_discharge_disposition', String(length=1028))
    raw_discharge_status = Column('raw_discharge_status', String(length=1028))
    raw_drg_type = Column('raw_drg_type', String(length=1028))
    raw_admitting_source = Column('raw_admitting_source', String(length=1028))


class Diagnosis(Base):
    __tablename__ = 'diagnosis'
    __table_args__ = (
        PrimaryKeyConstraint('patid', 'encounterid', 'dx', 'dx_type', 'raw_dx', name='diagnosis_pkey'),
    )

    patid = Column('patid', String(length=1028))
    encounterid = Column('encounterid', String(length=1028))
    enc_type = Column('enc_type', String(length=2))
    admit_date = Column('admit_date', String(length=10))
    providerid = Column('providerid', String(length=1028))
    dx = Column('dx', String(length=18))
    dx_type = Column('dx_type', String(length=2))
    dx_source = Column('dx_source', String(length=2))
    pdx = Column('pdx', String(length=2))
    raw_dx = Column('raw_dx', String(length=1028))
    raw_dx_type = Column('raw_dx_type', String(length=1028))
    raw_dx_source = Column('raw_dx_source', String(length=1028))
    raw_hispanic = Column('raw_hispanic', String(length=1028))
    raw_pdx = Column('raw_pdx', String(length=1028))


class Procedure(Base):
    __tablename__ = 'procedure'
    __table_args__ = (
        PrimaryKeyConstraint('patid', 'encounterid', 'px', 'px_type', 'raw_px', name='procedure_pkey'),
    )

    patid = Column('patid', String(length=1028))
    encounterid = Column('encounterid', String(length=1028))
    enc_type = Column('enc_type', String(length=2))
    admit_date = Column('admit_date', String(length=10))
    providerid = Column('providerid', String(length=1028))
    px = Column('px', String(length=11))
    px_type = Column('px_type', String(length=2))
    raw_px = Column('raw_px', String(length=1028))
    raw_px_type = Column('raw_px_type', String(length=1028))

class Vital(Base):
    __tablename__ = 'vital'
    __table_args__ = (
        PrimaryKeyConstraint('patid', 'measure_date', 'measure_time', name='vital_pkey'),
    )

    patid = Column('patid', String(length=1028))
    encounterid = Column('encounterid', String(length=1028))
    measure_date = Column('measure_date', String(length=10))
    measure_time = Column('measure_time', String(length=5))
    vital_source = Column('vital_source', String(length=2))
    ht = Column('ht', Numeric(precision=8, scale=2))
    wt = Column('wt', Numeric(precision=8, scale=2))
    diastolic = Column('diastolic', Numeric(precision=4, scale=0))
    systolic = Column('systolic', Numeric(precision=4, scale=0))
    original_bmi = Column('original_bmi', Numeric(precision=8, scale=2))
    bp_position = Column('bp_position', String(length=2))
    raw_vital_source = Column('raw_vital_source', String(length=1028))
    raw_diastolic = Column('raw_diastolic', String(length=1028))
    raw_systolic = Column('raw_systolic', String(length=1028))
    raw_bp_position = Column('raw_bp_position', String(length=1028))
