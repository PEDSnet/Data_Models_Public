
# !!!DRAFT!!!

# Differences between PEDSnet CDM 3.1 and CDM 3.2

## UPDATED in PEDSnet CDM3.2

### [1.6 Visit Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Name change for `admitting_source_*` columns to `admitted_from_*`

Old Name | New Name
---|---
admitting_source_concept_id|admitted_from_concept_id
admitting_source_value|admitted_from_source_value

2. For ***Urgent Care*** isits, please map to the `9203 - Emergency Visit` `visit_concept_id` and utilize the `care_site.place_of_service_concept_id` = `8782 - Urgent Care`

### [1.7 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Please use the following convention to map the `condition_type_concept_id` as it relates to conditions documented at the visit.

Visit_concept_id | Condition_type_concept_id
--- | ---
9201 (Inpatient)| Inpatient header 
9202 (Outpatient) | Outpatient header 
9203 (Emergency)| ED **NEW CONCEPT ID - TBD** 
2000000048 (ED to Inpatient)| Inpatient header 
2000000088 (Observation)| Inpatient header 

***Note:*** For sites that are splitting the ED to Inpatient) encounters into 1 "9203- Emergency" visit and 1 "9201- Inpatient" visit, not using the "2000000048- ED to Inpatient" visit type, apply diagnosis values from the inpatient setting to the "9203-Emergency visit" with an inpatient condition_type_concept_id. 

### [1.8 Procedure_Occurrence](Pedsnet_CDM_ETL_Conventions.md#18-procedure_occurrence) **NOTE 1**
1. Please include procedure codes (CPT/HCPCS/LOINC) for ancillary therapies (Speech, Physical, Occupational etc) where it is available at your site.

## NEW in PEDSnet CDM3.2
### [1.18 Device Exposure](Pedsnet_CDM_ETL_Conventions.md#118-device_exposure)
1.This table has been created to capture information about a person's exposure to a foreign physical object or instrument which is used for diagnostic or therapeutic purposes through a mechanism beyond chemical action. Devices include implantable objects (e.g. pacemakers, stents, artificial joints), medical equipment and supplies (e.g. bandages, crutches, syringes), other instruments used in medical procedures (e.g. sutures, defibrillators) and material used in clinical care (e.g. adhesives, body material, dental material, surgical material).

***

## REMINDER

Please continue to work on refining and improving the quality of data for the following domains and fields:

#### [1.11 Drug Exposure](Pedsnet_CDM_ETL_Conventions.md#111-drug-exposure-1)
1. Please make an effort to include both the inpatient medication order and the inpatient medication administration record as **separate entries** in the drug_exposure table and ***if*** able to please link these orders using the fact relationship table.

#### [1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. `specimen_source_value`
2. `specimen_concept_id`
3. `measurement_source_value` (labs)
4. `range_low` and `range_high` 
