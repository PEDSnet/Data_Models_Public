# Differences between PEDSnet CDM2.3 and CDM2.4  ****INCOMPLETE****

## CHANGES from CDM2.3.0

####Network Convention Changes 

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

####[1.7 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence)
1. Updatied Condition_Occurrence Table to reflect inclusion of external injury codes

####[1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. Updated Conventions document to explicitly state to only include final results
2. Updated Covnentions to clarify that lab orders include culture 

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
## NEW in PEDSnet CDM2.3

####[1.6 Visit_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Expanded exlcusion criteria and introduced outpatient concept definitions.

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

###PEDSnet Vocabulary

***
