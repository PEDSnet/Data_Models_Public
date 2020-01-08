
# Differences between PEDSnet CDM 3.6 and CDM 3.7

## NEW in PEDSnet CDMv3.7

### New Table
#### [1.20 Hash Token](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md#120-hash_token)
- To support the data linkage effort, we have included and adapted the HASH_TOKEN table from the PCORNetv5.1 CDM. Please store the Datavant hashes to be transmitted to the DCC in this table. For full details please see the conventions document.
 

### NEW Conventions
#### [1.11 Drug Exposure](Pedsnet_CDM_ETL_Conventions.md#111-drug-exposure-1)

***CHANGE: The requirement to calculate a dose basis is removed in PEDSnet v3.7***

**Note 1**: The `effective_drug_dose` is the dose basis.(E.g. 45 mg/kg/dose). This is the discrete dose value from the source data if available. If the discrete dose value is **not** available from the source data, provide the dose information available for the medication.

The dose_unit_concept_id is the unit of the effective dose.

Please use the following logic to populate the effective_dose and dose unit based on what is available in your source system:

Site Information | Effective Drug Dose | Dose Unit Concept Id  | Dose Unit Source Value
--- | --- | --- | ---
Dose Basis (calcualted effective dose) Available  (E.g. 90 mg/kg) | 90 | Corresponding concept for unit (E.g. mg/kg = 9562)| mg/kg
Only Dose Avaiable (E.g. 450 mg)) | 450 | Corresponding Concept for unit (E.g. mg = 8576) |mg
No discrete dosing information | | 0|



#### [1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
***CHANGE: Guidance Updated for***

- ***Lab LOINC codes that are different than PEDSnet LOINC***
- ***Lab LOINC codes that are not a part of the Network Listing***

***See Updated Rows Below:***

**Note 4**: ...

Please use the following table as a guide to determine how to populate the `measurement_source_value`, `measurement_source_concept_id` and `measurement_concept_id` for LAB Values. 

**Note 5**:For lab results, please include the closest result to the **final** result available at the time of your extraction from the source.


You have in your source system |Network Listing Lab| Measurement_source_value| Measurement_source_concept_id | measurement_concept_id
---|---|---|--- | ---
Lab code is institutional-specific code (not CPT/not LOINC) | **Yes**| <ul><li> Local code or</li><li>Local name or</li><li>Local name \| Local code</li></ul> (any above are OK) | 0 (zero) | PEDSnet LOINC code’s concept_id (provided by DCC)
Lab code is CPT code | **Yes** | <ul><li> CPT Code</li><li>Local name or</li><li> Local name \|CPT code</li></ul> (any above are OK) | OMOP’s concept_id for CPT code | PEDSnet’s LOINC code’s concept_id (provided by DCC)
Lab code is LOINC code that is same as PEDSnet’s LOINC code |**Yes**| <ul><li> LOINC Code</li><li>Local name or</li><li> Local name \| LOINC code  </li></ul> (any above are OK) |PEDSnet’s LOINC code’s concept_id (provided by DCC)| PEDSnet’s LOINC code’s concept_id (provided by DCC)
***Lab code is LOINC code that is different than PEDSnet LOINC*** | ***No***|  ***Same as above*** | ***OMOP’s concept_id for your LOINC code*** | ***OMOP’s concept_id for your LOINC code***
***Lab code is LOINC code (and not a part of Network Lab listing)*** |***No*** | ***<ul><li> LOINC Code</li><li>Local name or</li><li> Local name \| LOINC code  </li></ul> (any above are OK)*** |***OMOP’s concept_id for your LOINC code***| ***OMOP’s concept_id for your LOINC code***
Lab code is institutional-specific code (not CPT/not LOINC) | **No** | <ul><li> Local code or</li><li>Local name or</li><li>Local name \| Local code</li></ul> (any above are OK) | 0 (zero) | 0 (zero)
Lab code is CPT code | **No** | <ul><li> CPT Code</li><li>Local name or</li><li> Local name \|CPT code</li></ul> (any above are OK) | OMOP’s concept_id for CPT code | 0 (zero)


## Continued Data Quality Focus for PEDSnet Key Data Elements

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

More information can be found [here.](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet%20Key%20Data%20Elements.md)

#### The DCC will be reaching out for site-focused DQA over the next month, particularly with issues around PCORnet.



