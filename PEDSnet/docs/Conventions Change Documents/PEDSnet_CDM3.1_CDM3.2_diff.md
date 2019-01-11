
# Differences between PEDSnet CDM 3.0 and CDM 3.1

## NEW in PEDSnet CDM3.1

### [1.6 Visit Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Please use the following guidlines for mapping outpatient visits:

Visit Concept Id |Concept Name| Visit Type Inclusion | In Person| Examples/Logic (includes but is not limited to)
--- | --- | --- | --- | ---
9202 |Ambulatory Visit (AV)/Outpatient | In person Outpatient Visits visits where the patient was seen by a physician  |Yes| Office Visits or Appointments
2000000469 |Outpatient Non Physician (OP-Non Physician) | In person Outpatient Visits visits where the patient was **NOT** seen by a physician  |Yes| Lab Visits, Radiology
44814711 |Other ambulatory Visit (OA) | Outpatient visits where the patient was not seen in person.|No| Telemedicine,Telephone, Emails, Refills and Orders Only Encounters

***

## REMINDER

Please continue to work on refining and improving the quality of data for the following domains and fields:

#### [1.4 Care_Site](Pedsnet_CDM_ETL_Conventions.md#14-caresite)
1. `specialty_concept_id`, `specialty_source_concept_id`, `specialty_source_value`

#### [1.5 Provider](Pedsnet_CDM_ETL_Conventions.md#15-provider-1)
1. `specialty_concept_id`, `specialty_source_concept_id`, `specialty_source_value`

#### [1.11 Drug Exposure](Pedsnet_CDM_ETL_Conventions.md#111-drug-exposure-1)
1. `Frequency`
2. `Effective_Dose`
3. Please make an effort to include the inpatient medication order in the drug_exposure table and ***if*** able to please link these orders using the fact relationship table. Below is an example of how to do so:
Example: Person_id = 12345 during their inpatient stay (visit_occurrence_id = 678910) had a medication order for Diazepam Oral Soln 1 MG/ML and it was administered 3 times (every 12 hours).

Four rows will be inserted into the drug_exposure table. Showing only the relevant columns:

drug_exposure_id | Person_id | Visit_occurrence_id | drug_concept_id | drug_type_concept_id |effective_drug_dose
 --- | --- | --- | --- | --- | --- |
1111 | 12345 | 678910 | 19076372 |581373 (Physician Administered-EHR Order)|0.12 |  
1112 | 12345 | 678910 | 19076372 | 38000180 (Inpatient Administration) | 0.12 |
1113 | 12345 | 678910 | 19076372 | 38000180 (Inpatient Administration) |0.12 |
1114 | 12345 | 678910 | 19076372 | 38000180 (Inpatient Administration) |0.12|

- drug_type_concept_id for Inpatient Medication Order = 581373 (Physician administered drug (identified from EHR order))
- drug_type_concept_id for Inpatient Administration= 38000180 (Inpatient Administration)

To link these two values, use the fact relationship table (**OPTIONAL FOR PEDSnet v3.1**):

Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
Drug | 1111 | Drug  | 1112 |  Occurrence of
Drug|  1111 | Drug | 1113 |  Occurrence of
Drug | 1111| Drug |  1114 |  Occurrence of
Drug| 1112 | Drug| 1111 |  Subsumes
Drug| 1113 | Drug | 1111 |  Subsumes
Drug| 1114 | Drug | 1111 |  Subsumes

Because the domain concept id and relationship concept id are integers the following is an example of how this data will be represented:

Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
13 | 1111 | 13 | 1112 |  44818848
13|  1111 | 13 | 1113 |  44818848
13 | 1111| 13 |  1114 | 44818848
13| 1112 | 13 | 1111 |  44818723 
13| 1113 | 13 | 1111 |  44818723 
13| 1114 | 13 | 1111 |  44818723 


#### [1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. `specimen_source_value`
2. `specimen_concept_id`
3. `measurement_source_value` (labs)
4. `range_low` and `range_high` 
