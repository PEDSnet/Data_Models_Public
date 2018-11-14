## Differences between PEDSnet CDM2.2 and CDM2.3

## CHANGES from CDM2.2.0

####Network Convention Changes 
*(taken directly from conventions document)*

10.
**For populating `'*_source_concept_id'` (where there exists non-null values in the source) use the following Logic :**

  **Populate `'*_source_concept_id'` (i.e. non-zero) if the source_value is drawn from a standard vocabulary in OMOP**.
       
Please use your local system knowledge to determine this or use the following criteria : All the values in the source_value field should be drawn from the concept_code in the concept table (for a given/relevant domain_id and a given vocabulary_id).
    
  **ELSE Use 0** 
      
 (usually the case when the sites need to "manually" map the foo_source_value to foo_concept_id)
 
11.
**For populating `*_source_value` please make a best effort to provide "human readable" values rather than a coded value where possible from the source.**

  Example for `gender_source_value`, the source value at your site may be `1` for Female and `2` for Male. Please provide the label value of `Female` and `Male`.
 

####Specific Table Changes
####[1.2 Death](Pedsnet_CDM_ETL_Conventions.md#12-death-1)
1. Updated Death time default to 23:59:59 where the time is unknown or is null.

####[1.6 Visit Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Updated the exclusion criteria to exclude future visits.

####[1.7 Condition Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence)
1. Removed "Condition" Domain concept constraint from Condition Occurrence
2. `Condition_source_concept_id` values must correspond to ICD9/ICD10 concept mapping **ONLY**
3. `Condition_source_value` must be reported in the following pipe delimited structure: "Diagnosis Name | Diagnosis Code"

####[1.9 Observation](Pedsnet_CDM_ETL_Conventions.md#19-observation-1)
1. Sites should include inpatient and outpatient admitting source, discharge disposition and discharge status where available.
2. Sites should provide tobacco information from the primary source of data capture at their respective site.

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
