from sqlalchemy import Column, Integer, String, Numeric, DateTime
from sqlalchemy.schema import PrimaryKeyConstraint, ForeignKeyConstraint, Index
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


class Person(Base):
    __tablename__ = 'person'
    __table_args__ = (
        PrimaryKeyConstraint('person_id', name='person_pkey'),
        ForeignKeyConstraint(['care_site_id'], ['care_site.care_site_id'], name='person_care_site_fk'),
        ForeignKeyConstraint(['location_id'], ['location.location_id'], name='person_location_fk'),
        ForeignKeyConstraint(['provider_id'], ['provider.provider_id'], name='person_provider_fk')
    )

    person_id = Column('person_id', Integer(), nullable=False)
    gender_concept_id = Column('gender_concept_id', Integer(), nullable=False)
    year_of_birth = Column('year_of_birth', Numeric(precision=4, scale=0), nullable=False)
    month_of_birth = Column('month_of_birth', Numeric(precision=2, scale=0))
    day_of_birth = Column('day_of_birth', Numeric(precision=2, scale=0))
    pn_time_of_birth = Column('pn_time_of_birth', DateTime())
    race_concept_id = Column('race_concept_id', Integer())
    ethnicity_concept_id = Column('ethnicity_concept_id', Integer())
    location_id = Column('location_id', Integer())
    provider_id = Column('provider_id', Integer())
    care_site_id = Column('care_site_id', Integer(), nullable=False)
    pn_gestational_age = Column('pn_gestational_age', Numeric(precision=4, scale=2))
    person_source_value = Column('person_source_value', String(length=100), nullable=False)
    gender_source_value = Column('gender_source_value', String(length=50))
    race_source_value = Column('race_source_value', String(length=50))
    ethnicity_source_value = Column('ethnicity_source_value', String(length=50))


class Death(Base):
    __tablename__ = 'death'
    __table_args__ = (
        PrimaryKeyConstraint('person_id', 'death_type_concept_id', name='death_pkey'),
        ForeignKeyConstraint(['person_id'], ['person.person_id'], name='death_person_fk')
    )

    person_id = Column('person_id', Integer(), nullable=False)
    death_date = Column('death_date', DateTime(), nullable=False)
    death_type_concept_id = Column('death_type_concept_id', Integer(), nullable=False, autoincrement=False)
    cause_of_death_concept_id = Column('cause_of_death_concept_id', Integer())
    cause_of_death_source_value = Column('cause_of_death_source_value', String(length=100))


class Location(Base):
    __tablename__ = 'location'
    __table_args__ = (
        PrimaryKeyConstraint('location_id', name='location_pkey'),
    )

    location_id = Column('location_id', Integer(), nullable=False)
    state = Column('state', String(length=2))
    zip = Column('zip', String(length=9))
    location_source_value = Column('location_source_value', String(length=300))
    address_1 = Column('address_1', String(length=100))
    address_2 = Column('address_2', String(length=100))
    city = Column('city', String(length=50))
    county = Column('county', String(length=50))


class CareSite(Base):
    __tablename__ = 'care_site'
    __table_args__ = (
        PrimaryKeyConstraint('care_site_id', name='care_site_pkey'),
        ForeignKeyConstraint(['location_id'], ['location.location_id'], name='care_site_location_fk'),
        ForeignKeyConstraint(['organization_id'], ['organization.organization_id'], name='care_site_organization_fk')
    )

    care_site_id = Column('care_site_id', Integer(), nullable=False)
    place_of_service_concept_id = Column('place_of_service_concept_id', Integer())
    location_id = Column('location_id', Integer())
    care_site_source_value = Column('care_site_source_value', String(length=100), nullable=False)
    place_of_service_source_value = Column('place_of_service_source_value', String(length=100))
    organization_id = Column('organization_id', Integer(), nullable=False)


class Organization(Base):
    __tablename__ = 'organization'
    __table_args__ = (
        PrimaryKeyConstraint('organization_id', name='organization_pkey'),
        ForeignKeyConstraint(['location_id'], ['location.location_id'], name='organization_location_fk'),
        Index('organization_organization_pos', 'organization_source_value', 'place_of_service_source_value')
    )

    organization_id = Column('organization_id', Integer(), nullable=False)
    place_of_service_concept_id = Column('place_of_service_concept_id', Integer())
    location_id = Column('location_id', Integer())
    place_of_service_source_value = Column('place_of_service_source_value', String(length=100))
    organization_source_value = Column('organization_source_value', String(length=50), nullable=False)


class Provider(Base):
    __tablename__ = 'provider'
    __table_args__ = (
        PrimaryKeyConstraint('provider_id', name='provider_pkey'),
        ForeignKeyConstraint(['care_site_id'], ['care_site.care_site_id'], name='provider_care_site_fk')
    )

    provider_id = Column('provider_id', Integer(), nullable=False)
    specialty_concept_id = Column('specialty_concept_id', Integer())
    care_site_id = Column('care_site_id', Integer(), nullable=False)
    npi = Column('npi', String(length=20))
    dea = Column('dea', String(length=20))
    provider_source_value = Column('provider_source_value', String(length=100), nullable=False)
    specialty_source_value = Column('specialty_source_value', String(length=300))


class VisitOccurrence(Base):
    __tablename__ = 'visit_occurrence'
    __table_args__ = (
        PrimaryKeyConstraint('visit_occurrence_id', name='visit_occurrence_pkey'),
        ForeignKeyConstraint(['person_id'], ['person.person_id'], name='visit_occurrence_person_fk'),
        Index('visit_occurrence_person_date', 'person_id', 'visit_start_date')
    )

    visit_occurrence_id = Column('visit_occurrence_id', Integer(), nullable=False)
    person_id = Column('person_id', Integer(), nullable=False)
    visit_start_date = Column('visit_start_date', DateTime(), nullable=False)
    visit_end_date = Column('visit_end_date', DateTime())
    provider_id = Column('provider_id', Integer())
    care_site_id = Column('care_site_id', Integer())
    place_of_service_concept_id = Column('place_of_service_concept_id', Integer(), nullable=False)
    place_of_service_source_value = Column('place_of_service_source_value', String(length=100))


class ConditionOccurrence(Base):
    __tablename__ = 'condition_occurrence'
    __table_args__ = (
        PrimaryKeyConstraint('condition_occurrence_id', name='condition_occurrence_pkey'),
        ForeignKeyConstraint(['person_id'], ['person.person_id'], name='condition_occurrence_person_fk'),
        ForeignKeyConstraint(['associated_provider_id'], ['provider.provider_id'], name='condition_provider_fk'),
        ForeignKeyConstraint(['visit_occurrence_id'], ['visit_occurrence.visit_occurrence_id'], name='condition_visit_fk')
    )

    condition_occurrence_id = Column('condition_occurrence_id', Integer(), nullable=False)
    person_id = Column('person_id', Integer(), nullable=False)
    condition_concept_id = Column('condition_concept_id', Integer(), nullable=False)
    condition_start_date = Column('condition_start_date', DateTime(), nullable=False)
    condition_end_date = Column('condition_end_date', DateTime())
    condition_type_concept_id = Column('condition_type_concept_id', Integer(), nullable=False)
    stop_reason = Column('stop_reason', String(length=100))
    associated_provider_id = Column('associated_provider_id', Integer())
    visit_occurrence_id = Column('visit_occurrence_id', Integer())
    condition_source_value = Column('condition_source_value', String(length=100))


class ProcedureOccurrence(Base):
    __tablename__ = 'procedure_occurrence'
    __table_args__ = (
        PrimaryKeyConstraint('procedure_occurrence_id', name='procedure_occurrence_pkey'),
        ForeignKeyConstraint(['person_id'], ['person.person_id'], name='procedure_occurrence_person_fk'),
        ForeignKeyConstraint(['associated_provider_id'], ['provider.provider_id'], name='procedure_provider_fk'),
        ForeignKeyConstraint(['visit_occurrence_id'], ['visit_occurrence.visit_occurrence_id'], name='procedure_visit_fk')
    )

    procedure_occurrence_id = Column('procedure_occurrence_id', Integer(), nullable=False)
    person_id = Column('person_id', Integer(), nullable=False)
    procedure_concept_id = Column('procedure_concept_id', Integer(), nullable=False)
    procedure_date = Column('procedure_date', DateTime(), nullable=False)
    procedure_type_concept_id = Column('procedure_type_concept_id', Integer(), nullable=False)
    associated_provider_id = Column('associated_provider_id', Integer())
    visit_occurrence_id = Column('visit_occurrence_id', Integer())
    relevant_condition_concept_id = Column('relevant_condition_concept_id', Integer())
    procedure_source_value = Column('procedure_source_value', String(length=100))


class Observation(Base):
    __tablename__ = 'observation'
    __table_args__ = (
        PrimaryKeyConstraint('observation_id', name='observation_pkey'),
        ForeignKeyConstraint(['person_id'], ['person.person_id'], name='observation_person_fk'),
        ForeignKeyConstraint(['associated_provider_id'], ['provider.provider_id'], name='observation_provider_fk'),
        ForeignKeyConstraint(['visit_occurrence_id'], ['visit_occurrence.visit_occurrence_id'], name='observation_visit_fk'),
        Index('observation_person_idx', 'person_id', 'observation_concept_id')
    )

    observation_id = Column('observation_id', Integer(), nullable=False)
    person_id = Column('person_id', Integer(), nullable=False)
    observation_concept_id = Column('observation_concept_id', Integer(), nullable=False)
    observation_date = Column('observation_date', DateTime(), nullable=False)
    observation_time = Column('observation_time', DateTime())
    observation_type_concept_id = Column('observation_type_concept_id', Integer(), nullable=False)
    value_as_number = Column('value_as_number', Numeric(precision=14, scale=3))
    value_as_string = Column('value_as_string', String(length=4000))
    value_as_concept_id = Column('value_as_concept_id', Integer())
    unit_concept_id = Column('unit_concept_id', Integer())
    associated_provider_id = Column('associated_provider_id', Integer())
    visit_occurrence_id = Column('visit_occurrence_id', Integer())
    relevant_condition_concept_id = Column('relevant_condition_concept_id', Integer())
    observation_source_value = Column('observation_source_value', String(length=100))
    unit_source_value = Column('units_source_value', String(length=100))
    range_low = Column('range_low', Numeric(precision=14, scale=3))
    range_high = Column('range_high', Numeric(precision=14, scale=3))


class ObservationPeriod(Base):
    __tablename__ = 'observation_period'
    __table_args__ = (
        PrimaryKeyConstraint('observation_period_id', name='observation_period_pkey'),
        ForeignKeyConstraint(['person_id'], ['person.person_id'], name='observation_period_person_fk'),
        Index('observation_period_person', 'person_id', 'observation_period_start_date', unique=True)
    )

    observation_period_id = Column('observation_period_id', Integer(), nullable=False)
    person_id = Column('person_id', Integer(), nullable=False)
    observation_period_start_date = Column('observation_period_start_date', DateTime(), nullable=False)
    observation_period_end_date = Column('observation_period_end_date', DateTime())


class ConditionEra(Base):
    __tablename__ = 'condition_era'
    __table_args__ = (
        PrimaryKeyConstraint('condition_era_id', name='condition_era_pkey'),
        ForeignKeyConstraint(['person_id'], ['person.person_id'], name='condition_era_person_fk')
    )

    condition_era_id = Column('condition_era_id', Integer(), nullable=False)
    person_id = Column('person_id', Integer(), nullable=False)
    condition_concept_id = Column('condition_concept_id', Integer(), nullable=False)
    condition_era_start_date = Column('condition_era_start_date', DateTime(), nullable=False)
    condition_era_end_date = Column('condition_era_end_date', DateTime(), nullable=False)
    condition_type_concept_id = Column('condition_type_concept_id', Integer(), nullable=False)
    condition_occurrence_count = Column('condition_occurrence_count', Numeric(precision=4, scale=0))


class DrugExposure(Base):
    __tablename__ = 'drug_exposure'
    __table_args__ = (
        PrimaryKeyConstraint('drug_exposure_id', name='drug_exposure_pkey'),
        ForeignKeyConstraint(['person_id'], ['person.person_id'], name='drug_exposure_person_fk'),
        ForeignKeyConstraint(['prescribing_provider_id'], ['provider.provider_id'], name='drug_exposure_provider_fk'),
        ForeignKeyConstraint(['visit_occurrence_id'], ['visit_occurrence.visit_occurrence_id'], name='drug_visit_fk')
    )

    drug_exposure_id = Column('drug_exposure_id', Integer(), nullable=False)
    person_id = Column('person_id', Integer(), nullable=False)
    drug_concept_id = Column('drug_concept_id', Integer(), nullable=False)
    drug_exposure_start_date = Column('drug_exposure_start_date', DateTime(), nullable=False)
    drug_exposure_end_date = Column('drug_exposure_end_date', DateTime())
    drug_type_concept_id = Column('drug_type_concept_id', Integer(), nullable=False)
    stop_reason = Column('stop_reason', String(length=100))
    refills = Column('refills', Numeric(precision=3, scale=0))
    quantity = Column('quantity', Numeric(precision=4, scale=0))
    days_supply = Column('days_supply', Numeric(precision=4, scale=0))
    sig = Column('sig', String(length=500))
    prescribing_provider_id = Column('prescribing_provider_id', Integer())
    visit_occurrence_id = Column('visit_occurrence_id', Integer())
    relevant_condition_concept_id = Column('relevant_condition_concept_id', Integer())
    drug_source_value = Column('drug_source_value', String(length=100))


class DrugEra(Base):
    __tablename__ = 'drug_era'
    __table_args__ = (
        PrimaryKeyConstraint('drug_era_id', name='drug_era_pkey'),
        ForeignKeyConstraint(['person_id'], ['person.person_id'], name='drug_era_person_fk')
    )

    drug_era_id = Column('drug_era_id', Integer(), nullable=False)
    person_id = Column('person_id', Integer(), nullable=False)
    drug_concept_id = Column('drug_concept_id', Integer(), nullable=False)
    drug_era_start_date = Column('drug_era_start_date', DateTime(), nullable=False)
    drug_era_end_date = Column('drug_era_end_date', DateTime(), nullable=False)
    drug_type_concept_id = Column('drug_type_concept_id', Integer(), nullable=False)
    drug_exposure_count = Column('drug_exposure_count', Numeric(precision=4, scale=0))


class PayerPlanPeriod(Base):
    __tablename__ = 'payer_plan_period'
    __table_args__ = (
        PrimaryKeyConstraint('payer_plan_period_id', name='payer_plan_period_pkey'),
        ForeignKeyConstraint(['person_id'], ['person.person_id'], name='payer_plan_period_person_fk')
    )

    payer_plan_period_id = Column('payer_plan_period_id', Integer(), nullable=False)
    person_id = Column('person_id', Integer(), nullable=False)
    payer_plan_period_start_date = Column('payer_plan_period_start_date', DateTime(), nullable=False)
    payer_plan_period_end_date = Column('payer_plan_period_end_date', DateTime(), nullable=False)
    payer_source_value = Column('payer_source_value', String(length=100))
    plan_source_value = Column('plan_source_value', String(length=100))
    family_source_value = Column('family_source_value', String(length=100))


class ProcedureCost(Base):
    __tablename__ = 'procedure_cost'
    __table_args__ = (
        PrimaryKeyConstraint('procedure_cost_id', name='procedure_cost_pkey'),
        ForeignKeyConstraint(['payer_plan_period_id'], ['payer_plan_period.payer_plan_period_id'], name='procedure_cost_payer_plan_fk'),
        ForeignKeyConstraint(['procedure_occurrence_id'], ['procedure_occurrence.procedure_occurrence_id'], name='procedure_cost_procedure_fk')
    )

    procedure_cost_id = Column('procedure_cost_id', Integer(), nullable=False)
    procedure_occurrence_id = Column('procedure_occurrence_id', Integer(), nullable=False)
    paid_copay = Column('paid_copay', Numeric(precision=8, scale=2))
    paid_coinsurance = Column('paid_coinsurance', Numeric(precision=8, scale=2))
    paid_toward_deductible = Column('paid_toward_deductible', Numeric(precision=8, scale=2))
    paid_by_payer = Column('paid_by_payer', Numeric(precision=8, scale=2))
    paid_by_coordination_benefits = Column('paid_by_coordination_benefits', Numeric(precision=8, scale=2))
    total_out_of_pocket = Column('total_out_of_pocket', Numeric(precision=8, scale=2))
    total_paid = Column('total_paid', Numeric(precision=8, scale=2))
    disease_class_concept_id = Column('disease_class_concept_id', Integer())
    revenue_code_concept_id = Column('revenue_code_concept_id', Integer())
    payer_plan_period_id = Column('payer_plan_period_id', Integer())
    disease_class_source_value = Column('disease_class_source_value', String(length=100))
    revenue_code_source_value = Column('revenue_code_source_value', String(length=100))


class DrugCost(Base):
    __tablename__ = 'drug_cost'
    __table_args__ = (
        PrimaryKeyConstraint('drug_cost_id', name='drug_cost_pkey'),
        ForeignKeyConstraint(['drug_exposure_id'], ['drug_exposure.drug_exposure_id'], name='drug_cost_drug_exposure_fk'),
        ForeignKeyConstraint(['payer_plan_period_id'], ['payer_plan_period.payer_plan_period_id'], name='drug_cost_payer_plan_period_fk')
    )

    drug_cost_id = Column('drug_cost_id', Integer(), nullable=False)
    drug_exposure_id = Column('drug_exposure_id', Integer(), nullable=False)
    paid_copay = Column('paid_copay', Numeric(precision=8, scale=2))
    paid_coinsurance = Column('paid_coinsurance', Numeric(precision=8, scale=2))
    paid_toward_deductible = Column('paid_toward_deductible', Numeric(precision=8, scale=2))
    paid_by_payer = Column('paid_by_payer', Numeric(precision=8, scale=2))
    paid_by_coordination_benefits = Column('paid_by_coordination_benefits', Numeric(precision=8, scale=2))
    total_out_of_pocket = Column('total_out_of_pocket', Numeric(precision=8, scale=2))
    total_paid = Column('total_paid', Numeric(precision=8, scale=2))
    ingredient_cost = Column('ingredient_cost', Numeric(precision=8, scale=2))
    dispensing_fee = Column('dispensing_fee', Numeric(precision=8, scale=2))
    average_wholesale_price = Column('average_wholesale_price', Numeric(precision=8, scale=2))
    payer_plan_period_id = Column('payer_plan_period_id', Integer())


class Cohort(Base):
    __tablename__ = 'cohort'
    __table_args__ = (
        PrimaryKeyConstraint('cohort_id', name='cohort_pkey'),
    )

    cohort_id = Column('cohort_id', Integer(), nullable=False)
    cohort_concept_id = Column('cohort_concept_id', Integer(), nullable=False)
    cohort_start_date = Column('cohort_start_date', DateTime(), nullable=False)
    cohort_end_date = Column('cohort_end_date', DateTime())
    subject_id = Column('subject_id', Integer(), nullable=False)
    stop_reason = Column('stop_reason', String(length=100))
