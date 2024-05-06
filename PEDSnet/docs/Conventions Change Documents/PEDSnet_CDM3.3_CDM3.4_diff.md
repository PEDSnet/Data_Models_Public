
# Differences between PEDSnet CDM 3.3 and CDM 3.4


## CHANGES from CDM 3.3.0

#### Specific Table Changes

### [1.4 Care_Site](Pedsnet_CDM_ETL_Conventions.md#14-care_site)
1. Please pay attention to the updated logic for mapping the `speciality_concept_id` due to an underlying change in the vocabulary.

### [1.5 Provider](Pedsnet_CDM_ETL_Conventions.md#15-provider-1)
1. Please pay attention to the updated logic for mapping the `speciality_concept_id` due to an underlying change in the vocabulary.

### [1.7 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Please continue to place all diagnosis codes in the condition_occurrence table and use both the `Maps to` and `Maps to Value` relationship id for mapping conditions to SNOMED. This affects the `condition_concept_id`.

## Increased Data Quality Focus for PEDSnet Key Data Elements

Please continue to work on refining and improving the quality of data for the following domains and fields associated with the [PEDSnet Key Data Elements](docs/PEDSnet%20Key%20Data%20Elements.md):

- `person.birth_datetime`
- `person.location_id`
- `care_site.specialty_concept_id`
- `provider.specialty_concept_id`
- `adt_occurrence.service_concept_id`
- `visit.visit_start_date`
- `visit.visit_end_date`
- `visit_payer.plan_class`
- `condition_occurrence.condition_concept_id`
- `condition_occurrence.condition_type_concept_id`
- `condition_occurrence.visit_occurrence_id`
- `procedure_occurrence.procedure_concept_id`
- `procedure_occurrence.visit_occurrence_id`
- `drug_exposure.drug_concept_id`
- `drug_exposure.effective_drug_dose`
- `drug_exposure.quantity`
- `drug_exposure.visit_occurrence_id`
- `measurement.value_as_number`
- `measurement.value_as_concept_id`
- `measurement.range_high`
- `measurement.range_low`
- `measurement.range_high_operator_concept_id`
- `measurement.range_low_operator_concept_id`
- `measurement_organism.organism_concept_id`
- `immunization.immunization_concept_id`
