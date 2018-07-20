
# Differences between PEDSnet CDM 2.9 and CDM 3.0

## NEW in PEDSnet CDM3.0

### [1.7 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. We have been made aware that there are a significant amount of conditions that route to a domain of Procedure, Measurement etc. Please **DO NOT** route these conditions to those domains or tables (i.e. Procedure_Occurrence, Measurement). Instead, include all records coming out of our source tables for diagnosis data in the Condition_Cccurrence table. 

### [1.11 Drug Exposure](Pedsnet_CDM_ETL_Conventions.md#111-drug-exposure-1)
1. medDRA Codes were previously unavailable in version 2.9. They will now be available in the 3.0 vocabulary release.
2. Please make an effort to include the inpatient medication order in the drug_exposure table and *if* able to please link these orders using the fact relationship table. Below is an example of how to do so:
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

To link these two values, use the fact relationship table:

Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
Drug | 1111 | Drug  | 1112 |  Occurrance of
Drug|  1111 | Drug | 1113 |  Occurrance of
Drug | 1111| Drug |  1114 |  Occurrance of
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


***

## Reminder

Please continue to work on refining and improving the quality of data for the following domains and fields:

#### [1.4 Care_Site](Pedsnet_CDM_ETL_Conventions.md#14-caresite)
1. `specialty_concept_id`, `specialty_source_concept_id`, `specialty_source_value`

#### [1.5 Provider](Pedsnet_CDM_ETL_Conventions.md#15-provider-1)
1. `specialty_concept_id`, `specialty_source_concept_id`, `specialty_source_value`

#### [1.11 Drug Exposure](Pedsnet_CDM_ETL_Conventions.md#111-drug-exposure-1)
1. `Frequency`
2. `Effective_Dose`

#### [1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. `specimen_source_value`
2. `measurement_source_value` (labs)
3. `range_low` and `range_high` 

