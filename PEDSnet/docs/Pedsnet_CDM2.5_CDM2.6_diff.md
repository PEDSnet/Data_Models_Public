# Differences between PEDSnet CDM2.5 and CDM2.6

## CHANGES from CDM2.5.0

#### Specific Table Changes

#### [1.6 Visit_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
2. Addition of `admitting_source_concept_id`.This field was prevsiously marked as optional for v2.5, it is now required if available in version 2.6.
3. Addition of `discharge_to_concept_id`.This field was prevsiously marked as optional for v2.5, it is now required if available in version 2.6.
4. Addition of `admitting_source_value`.This field was prevsiously marked as optional for v2.5, it is now required if available in version 2.6.
2. Addition of `discharge_to_source_value`This field was prevsiously marked as optional for v2.5, it is now required if available in version 2.6.
4. Addition of "Administrative Visit" Visit Type. This is a new concept id option for the visit_concept_id field. Please see NOTE 1 for ETL guidance on the various visit categories.

#### [1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. PCORnet requirement to pull all labs. Please see conventions for detailed instructions and logic on how to populate the measurement table due to this new requirement.
2. FEV/FVC Measurements are now required to be mapped using the lab `measurement_type_concept_id` (44818702).
3. For PEDSNet v2.6 we are using the lab `measurement_type_concept_id` (44818702) to represent all Clinical and Laboratory results from the source.

***
## NEW in PEDSnet CDM2.6

All `*_time` fields will now be renamed to `*_datetime` fields as a result of a change in OMOP v5.1.

### PEDSnet Vocabulary
 concept_id |                 concept_name                 |   domain_id    | concept_class_id | vocabulary_id 
------------|----------------------------------------------|----------------|------------------|---------------
  2000000104 | Adminstrative Visit                     | Visit        | Encounter Type   | PEDSnet

***
