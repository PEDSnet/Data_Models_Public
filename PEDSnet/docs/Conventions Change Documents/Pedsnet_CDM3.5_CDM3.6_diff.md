
# Differences between PEDSnet CDM 3.5 and CDM 3.6

## NEW in PEDSnet CDM3.6
### NEW Field
#### [1.1 Person](Pedsnet_CDM_ETL_Conventions.md#11-person)
1. `birth_date`. For consistency in the model, we have included the birthdate field. 

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
- `measurement.measurement_concept_id`
- `measurment.visit_occurrence_id`
- `measurement.value_as_number`
- `measurement.value_as_concept_id`
- `measurement.specimen_concept_id  
- `measurement.range_high`
- `measurement.range_low`
- `measurement.range_high_operator_concept_id`
- `measurement.range_low_operator_concept_id`
- `measurement_organism.organism_concept_id`
- `immunization.immunization_concept_id`

More information can be found [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet%20Key%20Data%20Elements.md)



