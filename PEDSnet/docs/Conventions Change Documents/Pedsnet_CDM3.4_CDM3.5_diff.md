
# Differences between PEDSnet CDM 3.4 and CDM 3.5

## CHANGES from CDM 3.4.0

#### Specific Table Changes
#### [1.3 Location](Pedsnet_CDM_ETL_Conventions.md#13-location-1)
1. Please transmit **CITY** information to the DCC. Previously this field was noted as a "Do not transmit to the DCC" field.
2. Please trasmit **9 digit zip codes** if available.

#### [1.17 Immunization](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md#117-immunization-1)
- The immunization table has been updated to include the following fieds:
1. imm_recorded_date 
2. imm_recorded_datetime
3. imm_manufacturer	
4. imm_lot_num	
5. imm_exp_date	
6. imm_exp_datetime
7. immunization_type_concept_id
8. imm_body_site_concept_id
9. imm_body_site_source_value 

Please see the conventions document for full details.

## NEW in PEDSnet CDM3.5
### NEW Table
#### [1.19 Location History](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v3.5.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md#119-location_history)
- In reponse to the PCORNetv5 addition of the LDS_ADDRESS_HISTORY table we have included and adapted the OHDSI location_history table. For full details please see the conventions document.

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





