# Differences between PEDSnet CDM 2.7 and CDM 2.8

## CHANGES from CDM 2.7.0

#### Specific Table Changes

#### [1.8 Procedure_Occurrence](Pedsnet_CDM_ETL_Conventions.md#18-procedure_occurrence)
1. Update to the valid concepts for the `procedure_type_concept_id` to include instructions for `procedure_occurrence` records that are coming from billing records in the source.
2. Removal of `qualifier_source_value` field.

#### [1.9 Observation](Pedsnet_CDM_ETL_Conventions.md#19-observation-1)
1. Addition of delivery mode value to the observation table. Please see the conventions for valid `observation_concept_id` and `value_as_concept_id` values.

#### [1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. Addition of reporting of birth weight, height and head circumference values. When reporting these values the `measurement_type_concept_id` (44818704) that refers to patient reported values should be used.

***

***
## NEW in PEDSnet CDM2.8

#### [1.17 Immunization](Pedsnet_CDM_ETL_Conventions.md#117-immunization-1)
1. This table has been created to inlcude immunization records for persons in the PEDSnet network. Please see the table specification in the ETL Conventions for guidance on how to populate the table.

***
