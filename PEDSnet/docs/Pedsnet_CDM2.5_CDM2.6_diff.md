# Differences between PEDSnet CDM2.5 and CDM2.6

## CHANGES from CDM2.5.0

#### Specific Table Changes

#### [1.6 Visit_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
2. Addition of `admitting_source_concept_id`. This field was prevsiously marked as optional for v2.5, it is now required if available in version 2.6. This information should only be populated in the visit_occurrence table as of 2.6. Please do not report this information in the observation table.
3. Addition of `discharge_to_concept_id`. This field was prevsiously marked as optional for v2.5, it is now required if available in version 2.6. This information should only be populated in the visit_occurrence table as of 2.6. Please do not report this information in the observation table.
4. Addition of `admitting_source_value`. This field was prevsiously marked as optional for v2.5, it is now required if available in version 2.6.This information should only be populated in the visit_occurrence table as of 2.6. Please do not report this information in the observation table.
2. Addition of `discharge_to_source_value`. This field was prevsiously marked as optional for v2.5, it is now required if available in version 2.6.This information should only be populated in the visit_occurrence table as of 2.6. Please do not report this information in the observation table.
4. Addition of "Administrative Visit" Visit Type. This is a new concept id option for the visit_concept_id field. Please see NOTE 1 for ETL guidance on the various visit categories.

#### [1.7 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Addition of Note 1 for guidance on populating the condition_concept_id, condition_source_concept_id, condition_source_value. This change was present in the change documentation for v2.3 to v2.4 but not as explicitly defined. Please follow the conventions for version 2.6.


**Note 1**
For the PEDSNet network, we are coding all diagnosis codes to the SNOMED-CT Vocabulary. Research has showed that the IMO to SNOMED native mapping and IMO to ICD to SNOMED OMOP mapping produces highly variable results. For a particular IMO Code, when comparing the two mapping options, the same SNOMED concept id is only produced 25% of the time. See below examples of the mapping differences (IMO-SNOMED, ICD10 and ICD9):

IMO Description | Direct SNOMED | Via ICD 
--- | --- | --- 
Numbness of Toes | Numbness of toe | Altered Sensation of Skin| Direct SNOMED
Cerebellar ataxia/dyskinesia |Cerebellar Disorder |Cerebellar Ataxia
Choking episode | Choking sensation | Finding of head and neck region
Intestional malrotation | Congenital malrotation of intestine | Congenital anomaly of fixation of intestine
Genetic disease carrier status testing| Genetic finding| Genetic disorder carrier
Duchenne muscular dystrophy |Duchenne muscular dystrophy |Hereditary progressive muscular dystrophy

For diagnosis codes, please provide the IMO to SNOMED mapping where it exists in the source system. 

If the IMO to SNOMED mapping is not available in the system, utilize the IMO to ICD to SNOMED OMOP mapping in the vocabulary.

Please use the following logic to populate the `condition_concept_id`, `condition_source_concept_id` and `condition_source_value` based on what is available in your source system:

You have in your source system | condition_concept_id|condition_source_concept_id|condition_source_value
--- | --- | --- | ---
Any diagnosis that was captured as a term or name (e.g. IMO to SNOMED)| Corresponding SNOMED concept id |Corresponding concept for site diagnosis captured (must correspond to ICD9/ICD10 concept mapping) | Diagnosis Name "\|" IMO Code "\|" Diagnosis Code 
Any diagnosis that was captured directly as a code (e.g. ICD9/10) by a coder | Corresponding SNOMED concept id | Corresponding concept for site diagnosis code (must correspond to ICD9/ICD10 concept mapping) | Diagnosis Name "\|" IMO Code "\|" Diagnosis Code


#### [1.9 Observation](Pedsnet_CDM_ETL_Conventions.md#19-observation-1)
1. Admitting source and Discharge Destination information is no longer recorded in the Observation table as of 2.6. Please report this information in the visit_occurrence table.

#### [1.11 Drug Exposure](Pedsnet_CDM_ETL_Conventions.md#111-drug-exposure-1)
1. Updating conventions for route_concept_id mapping guidance to first map to the standard concept (standard_concept='S') in the case where duplicates exists among the 70 valid concept_ids and in all other cases map to the non-standard concept_id.

#### [1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. PCORnet requirement to pull all labs. Please see conventions for detailed instructions and logic on how to populate the measurement table due to this new requirement.
2. FEV/FVC Measurements are now required to be mapped using the lab `measurement_type_concept_id` (44818702).
3. For PEDSNet v2.6 we are using the lab `measurement_type_concept_id` (44818702) to represent all Clinical and Laboratory results from the source.

***
## NEW in PEDSnet CDM2.6

All `*_time` fields will now be renamed to `*_datetime` fields as a result of a change in OMOP v5.1. The following exceptions apply:

- person.time_of_bith renamed to person.birth_datetime
- observation_period.observation_period_start_time will remain unchanged. *(Name change problematic for ORACLE)*
- observation_period.observation_period_end_time will remain unchanged.* (Name change problematic for ORACLE)*

### PEDSnet Vocabulary
 concept_id |                 concept_name                 |   domain_id    | concept_class_id | vocabulary_id 
------------|----------------------------------------------|----------------|------------------|---------------
  2000000104 | Adminstrative Visit                     | Visit        | Encounter Type   | PEDSnet

***
