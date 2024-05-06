
# Differences between PEDSnet CDM 3.2 and CDM 3.3

## Increased Data Quality Focus

Please continue to work on refining and improving the quality of data for the following domains and fields:

- care_site or provider `specialty_concept_id` for 9202 visits
- valid `drug_concept_id` for prescriptions in drug_exposure
- valid `visit_occurrence_id`’s in procedure_occurrence
- Ensure `drug_concept_id` at least at SCDG level (where `drug_concept_id` <> 0)


## CHANGES from CDM 3.2.0

#### Specific Table Changes

#### [1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. Correction to PEDSnet convention language for measurement value_as_number and value_as_concept_id. The language erronerously referred to value_as_string that has been removed from the measurement table.

#### [1.17 Immunization](Pedsnet_CDM_ETL_Conventions.md#117-immunization-1)
1. Correction to table header with logic on logic populating the `immunization_concept_id`, `immunization_source_concept_id` and `immunization_source_value` based on what is available in your source system:

**OLD** 

Site Information | procedure_concept_id|procedure_source_concept_id|procedure_source_value
--- | --- | --- | ---

**NEW** 

Site Information | immunization_concept_id|immunization_source_concept_id|immunization_source_value
--- | --- | --- | ---
