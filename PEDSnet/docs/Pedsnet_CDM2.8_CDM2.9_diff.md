# DRAFT - WORKING DOCUMENT

# Differences between PEDSnet CDM 2.8 and CDM 2.9

## Focus for v2.9

Please work on refining and improving the quality of data for the following domains and fields:

#### Drug Exposure
1. Frequency
2. Effective Dose

#### Measurement Organism
1. Specimen Source Value

#### Provider
1. Provider Specialty

## CHANGES from CDM 2.8.0

#### Required updates to the conventions document

1. Correcting concepts for delivery mode. In the v2.8 conventions, the concept code was erroneously noted as the concept id

Delivery Mode | Vocabulary| Incorrect Value | CORRECT VALUE
---|---|---|---
Born by cesarean section|SNOMED|394699000|4192676
Born by elective cesarean section|SNOMED|395682006|4212794
Born by emergency cesarean section|SNOMED|407615002|4250010
Born by normal vaginal delivery|SNOMED|395683001|4216797
Born by forceps delivery|SNOMED|395681004|4217586
Born by ventouse delivery|SNOMED|407614003|4236293
Born by breech delivery|SNOMED|407613009|4250009

2. Correcting the logic for mapping custom procedure codes.

Site Information | procedure_concept_id|procedure_source_concept_id|procedure_source_value
  --- | --- | --- | ---
Custom Procedure Coding (That a site has knowledge of corresponding to a standard code but requires manual mapping) |**Corresponding CPT-4, ICD-9-CM (Procedures),ICD-10 (Procedures), HCPCS or OPCS-4 concept id**  | **0** | Procedure Name \| Custom Procedure Code

***

***
## NEW in PEDSnet CDM2.9 -- Optional 

#### The following fields and conventions have been included as optional mappings and columns for v2.9 as a result of changes required by PCORNet V4.0. Please do not feel obligated to make these changes. They are optional for v2.9. We anticipate that these will be required values for PEDSnet v3.0.

#### Condition Occurrence
1. Present on Admission Column

#### Observation
1. Addition of Primary and Secondary DRG Concept Ids to observation type concept id

#### Visit Payer
1. Addition of visit_payer_type_concept_id for Primary and Secondary Payer status

#### Measurement Organism
1. Addition of specimen_concept_id
2. Updated convention for specimen_source_value (pipe delimited SPECIMEN TYPE|SPECIMEN SOURCE) 
Eg. "URINE|CATHETER"

#### Drug Exposure
1. Addition of dispense as written Column
***
