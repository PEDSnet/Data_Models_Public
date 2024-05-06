# Differences between PEDSnet CDM 4.7 and CDM 4.8

## **** NEW in PEDSnet CDM v4.8 ****

### Update(s) to [1.6 visit_occurrence](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.8.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#16-visit_occurrence) Guidance:

1. New Guidance for the `visit_end_date` and `visit_end_datetime` fields following addition of NOT NULL constraint:
    - If no "End Time" exists in the source data:
        - Set `visit_end_date` equal to `visit_start_date`
        - Set `visit_end_datetime` equal to `visit_start_datetime`.

2. New Guidance for `visit_concept_id` field following addition of NOT NULL constraints for End Dates:
    - Any "Inpatient Hospital Admission" encounters that have null "end date(s)" in their source systems, and have their "visit end date(s)" set equal the same value as their "start dates(s)" as outlined in the point above, should have their `visit_concept_id` set to the new **2000001532** (Inpatient Visit - Ongoing) concept id; rather than using the existing 9201 (Inpatient Visit) concept id.
        - This is intended to flag "open" inpatient visits. 

### Update(s) to [1.5 provider](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.8.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#15-provider-1) Guidance:

1. The `specialty_concept_id` field in the PROVIDER` tables now have a NON-NULL constraint added.
    - The concept id value of 38004477 ("Pediatric Medicine") should be used as the default `specialty_concept_id` when no valid mapping exists or their is not specialty information in the source system for the given provider.

### Update(s) to [1.9 observation](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.8.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#19-observation-1) Guidance:

Addition of "Gross Motor Function Classification System" for Cerebral Palsy Data to Observation Domain. 

> For sites using Epic/Clarity, this data may be documented in Flowsheets.
> 
> However their will likely be some internal investigation needed to determine where this data is stored in your sites Data Warehouse.

See the below table for the concept mappings that can be used for this data:

Concept Name | Observation concept ID | Vocab ID | Value as concept ID | Concept description | Vocab ID| PCORNet Mapping
 --- | --- | --- | --- | --- | ---| ---
GMFCS Level|44810949|SNOMED|44810950| GMFCS for Cerebral Palsy level **I**|Condition|
GMFCS Level|44810949|SNOMED|44810951| GMFCS for Cerebral Palsy level **II**|Condition|
GMFCS Level|44810949|SNOMED|44811060| GMFCS for Cerebral Palsy level **III**|Condition|
GMFCS Level|44810949|SNOMED|44811061| GMFCS for Cerebral Palsy level **IV**|Condition|
GMFCS Level|44810949|SNOMED|44811062| GMFCS for Cerebral Palsy level **V**|Condition|

### Update(s) to [1.19 location_history](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.8.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#119-location_history) Guidance:

1. All sites are now required to populate the `location_history` table with at least some data:
    - At a minimum, sites should insert a row for the current address on file for each patient (corresponding to the `person.location_id` value).
        - If you dont have a way fo accessing the true effective start date for the a given patients current address, the most recent visit start date should be used as a default value.
        - The Eff End Date should be null for the current address.

## **** Reminders ****

### Sites submitting RECOVER data with v4.8 submission

For sites submiting RECOVER data along with the v4.8 submission, please provide a CSV of patients meeting the RECOVER inclusion criteria with an inclusion reason.

Please use the original [**RECOVER** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/v4.6/PEDSnet/docs/RECOVER%20Cohort.md#data-submission). 

### Sites submitting COVID data with v4.8 submission

For sites submiiting COVID data along with the v4.8 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. 

Please use the original [**COVID** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/COVID-19%20Cohort.md#data-submission).
