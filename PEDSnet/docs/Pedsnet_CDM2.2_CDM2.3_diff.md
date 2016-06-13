## Differences between PEDSnet CDM2.2 and CDM2.3

## CHANGES from CDM2.2.0

####Specific Table Changes
####[1.2 Death](Pedsnet_CDM_ETL_Conventions.md#12-death-1)
1. Updated Death time default to 23:59:59 where the time is unknown or is null.

####[1.6 Visit Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Updated the exclusion criteria to exclude future visits.

####[1.7 Condition Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence)
1. Removed "Condition" Domain concept constraint from Condition Occurrence

####[1.9 Observation](Pedsnet_CDM_ETL_Conventions.md#19-observation-1)
1. Updated convention to include outpatient admitting source, discharge disposition and discharge status.

***
## NEW in PEDSnet CDM2.3

####[1.2 Death](Pedsnet_CDM_ETL_Conventions.md#12-death-1)
1. Added `death_cause_id` as the primary key of the death table

####[1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. Temperature value content added with applicable unit conventions
2. Head circumference value  content added with applicable unit conventions
3. Pulmonary Function value content added with applicable unit conventions.

###PEDSnet Vocabulary

Addition of **General Pediatrics/Primary Care** mapping to new PEDSNet concept (2000000063). Previously only the Pediatric Medicine concept(38004477) was present as a possible choice for this mapping.

ABMS Specialty Category | OMOP Supported Concept for Provider ID | OMOP Concept_name | Domain_id | Vocabulary id
--- | --- | --- | --- | ---
General Pediatrics (Primary Care)*|	2000000063|	General Pediatrics|	Provider Specialty|	PEDSNet
Pediatric Medicine**|	38004477|	Pediatric Medicine|	Provider Specialty|	Specialty

Notes:
- General Pediatrics refers to Primary Care
- Pediatric Medicine refers to the default assignment if a site is unable to distinguish which pediatric specialty the care site or provider has an assigned

Addition of **Peak Flow Post** measurement concept. This value did not exist in the OMOP Vocabulary, so the PEDSNet vocabulary was adjusted to accomodate this value.

   concept_class_id   | concept_code | concept_id | concept_level |          concept_name          |  domain_id  | invalid_reason | standard_concept | valid_end_date | valid_start_date | vocabulary_id 
----|------|---|----|----|-----|-----|-----|----|----|------------
 Clinical Observation | PF Post      | 2000000064 |               | Peak flow post bronchodilation | Measurement |                | S                | 2099-12-31     | 2016-06-13       | PEDSnet

***
