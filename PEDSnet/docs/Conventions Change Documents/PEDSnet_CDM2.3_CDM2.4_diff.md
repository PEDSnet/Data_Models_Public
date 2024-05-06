# Differences between PEDSnet CDM2.3 and CDM2.4

## CHANGES from CDM2.3.0

####Network Convention Changes 

1. `Provider.provider_id` now required as stable field across submissions.

####Source Value Alignment
All source values must follow the `NAME | CODE` convention.

- [1.7 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence) **NOTE 1**
- [1.8 Procedure_Occurrence](Pedsnet_CDM_ETL_Conventions.md#18-procedure_occurrence) **NOTE 1** 
- [1.11 Drug_Exposure]( Pedsnet_CDM_ETL_Conventions.md#111-drug-exposure-1) **NOTE 6** 
- [Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1) **NOTE 4** 


####Specific Table Changes
####[1.2 Death](Pedsnet_CDM_ETL_Conventions.md#12-death-1)
1. Updating death impute concept id query

```
select * from concept 
where (concept_class_id ='Death Imput Type' 
or (vocabulary_id='PCORNet' and concept_class_id='Undefined')) 
and invalid_reason is null)
```
####[1.6 Visit_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Updated visit concept id and place of service concept id valid concept id query
   ```
   select * from concept 
   where domain_id='Visit' 
   or (vocabulary_id='PCORNet' and concept_class_id='Encounter Type')
   or (vocabulary_id='PCORNet' and concept_class_id='Undefined') 
   and invalid_reason is null
   ```
2. Expanded exlcusion criteria and introduced outpatient concept definitions.

```
(Taken from conventions document)
 Exclusions:
  
 1. Future Vists
 2. Cancelled Visits (where the patient was not seen)
 
**Note 1:**
 For Outpatient visits, please use the following logic to assign visit concept ids:
 
 ```
Visit Concept Id |Concept Name| Visit Type Inclusion
 --- | --- | ---
 9202 |Ambulatory Visit (AV) |Outpatient Visits where the patient was seen in person 
 44814711|Other ambulatory Visit (OA) | All other outpatient visits
 
####[1.7 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence)
1. Updated Condition_Occurrence Table to reflect inclusion of external injury codes
2. Updated instructions on how to populate the table based on physician diagnsois as opposed to billing/coder diagnosis.
 ```
 For the PEDSNet network, please provide clinical physician based diagnosis as opposed to billing or claim based diangosis data.
 ```
3. Updated conventions for `condition_source_concept_id` and `condition_concept_id`

- Condition source concept id: ICD codes
- Condition concept id: IMO -> SNOMED (no ICD intermediary mappings)

####[1.11 Drug_Exposure](Pedsnet_CDM_ETL_Conventions.md#111-drug-exposure-1)
1. Updated RxNorm Term Type Mapping order (NOTE 5)
 - BPCK (Branded Pack)
 - GPCK (Clinical Pack)
 - SBD (Branded Drug, Quant Branded Drug)
 - SCD (Clinical Drug, Quant Clinical Drug)
 - SBDF (Branded Drug Form)
 - SCDF (Clinical Drug Form)
 - MIN (Ingredient)
 - SBDC
 - SCDC
 - PIN (Ingredient)
 - IN (Ingredient)
 

####[1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. Updated Conventions document to explicitly state to only include final results
2. Updated Conventions to clarify that lab orders include culture orders

 ```
 (Taken from conventions document)
 ....
 Lab Procedures (including a Lab Panel Order and Culture Orders)
 ```
3. Updated `value_as_concept_id` query

```
select * from concept 
where domain_id='Meas Value' 
and concept_class_id='Qualifier Value' 
and standard_concept='S'
```


***

## NEW in PEDSnet CDM2.4


 ####[1.16 ADT Occurrence](Pedsnet_CDM_ETL_Conventions.md#116-adt_occurrence)
 1. Created a new table to store ICU admission information.

###PEDSnet Vocabulary

The following concepts are new to the PEDSnet vocabulary:

 concept_id |                 concept_name                 |   domain_id    | concept_class_id | vocabulary_id 
------------|----------------------------------------------|----------------|------------------|---------------
 2000000083 | Admission                                    | ADT Event Type | ADT Event Type   | PEDSnet
 2000000084 | Discharge                                    | ADT Event Type | ADT Event Type   | PEDSnet
 2000000085 | Transfer in                                  | ADT Event Type | ADT Event Type   | PEDSnet
 2000000086 | Transfer out                                 | ADT Event Type | ADT Event Type   | PEDSnet
 2000000087 | Census                                       | ADT Event Type | ADT Event Type   | PEDSnet
 2000000065 | Service Type                                 | Metadata       | Domain           | Domain
 2000000066 | Service Type                                 | Metadata       | Concept Class    | Concept Class
 2000000081 | ADT Event Type                               | Metadata       | Concept Class    | Concept Class
 2000000082 | ADT Event Type                               | Metadata       | Domain           | Domain
 2000000067 | Critical Care                                | Service Type   | Service Type     | PEDSnet
 2000000068 | Intermediate care                            | Service Type   | Service Type     | PEDSnet
 2000000069 | Acute care                                   | Service Type   | Service Type     | PEDSnet
 2000000070 | Observation care                             | Service Type   | Service Type     | PEDSnet
 2000000071 | Surgical site (includes OR, ASC)             | Service Type   | Service Type     | PEDSnet
 2000000072 | Procedural service                           | Service Type   | Service Type     | PEDSnet
 2000000073 | Behavioral health                            | Service Type   | Service Type     | PEDSnet
 2000000074 | Rehabilitative service (includes PT, OT, ST) | Service Type   | Service Type     | PEDSnet
 2000000075 | Specialty service                            | Service Type   | Service Type     | PEDSnet
 2000000076 | Radiology                                    | Service Type   | Service Type     | PEDSnet
 2000000077 | Hospital Outpatient                          | Service Type   | Service Type     | PEDSnet
 2000000078 | PICU                                         | Service Type   | Service Type     | PEDSnet
 2000000079 | CICU                                         | Service Type   | Service Type     | PEDSnet
 2000000080 | NICU                                         | Service Type   | Service Type     | PEDSnet
(23 rows)


***
