# Differences between PEDSnet CDM 4.6 and CDM 4.7

## **** NEW in PEDSnet CDM v4.6 ****

### New Guidance

Update(s) to [1.7 CONDITION_OCCURRENCE](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.7.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#17-condition_occurrence) Guidance:

1. Addition of Standardization around `condition_type_concept_id` for sites sourcing Data from Epic/Clarity.
    - This guidance can be found in **Note 4** in the  [CONDITION_OCCURRENCE](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.7.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#17-condition_occurrence) documentation section.

2. Adding a note about special handling for the `condition_type_concept_id` field that sites "Rolling Up" encounters in their ETL Logic will need to follow.
    - This guidance can be found in **Note 5** in the  [CONDITION_OCCURRENCE](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.7.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#17-condition_occurrence) documentation section.

Update(s) to [1.8 PROCEDURE_OCCURRENCE
](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.7.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#18-procedure_occurrence) Guidance:

1. Addition of Standardization around `procedure_type_concept_id` for sites sourcing Data from Epic/Clarity.
    - This guidance can be found in **Note 2** in the  [PROCEDURE_OCCURRENCE](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.7.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#18-procedure_occurrence) documentation section.

2. Removal of SNOMED-CT Vocabulary concepts (i.e. vocabulary\_id = SNOMED) from acceptable set of concept_ids for `procedure_concept_id`
    - OMOP doesn't accept SNOMED Vocabulary Concepts for `procedure_concept_id`, so we are making this adjustment to conform to that standard.
    - To Date none of our sites had been using SNOMED concepts for `procedure_concept_id` in their submissions, so this change should have no material impact.

Update(s) to [1.17 Immunization](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.7.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#117-immunization-1) Guidance:

1. Additional of `2000001531` to possible value for `immunization_type_concept_id`. 
    - This type concept id value was added to account for data from Unverified Health Information Exchange/Registry Data; for sites that are able to provide it.

## **** Reminders ****

### Submission Metadata and ETL Changes Documentation

Please document submission metadata and any ETL changes for version 4.6 in the [REDCap Project](https://redcap.chop.edu/redcap_v10.3.2/DataEntry/record_status_dashboard.php?pid=38566).

### Sites submitting RECOVER data with v4.6 submission

For sites submiting RECOVER data along with the v4.6 submission, please provide a CSV of patients meeting the RECOVER inclusion criteria with an inclusion reason.

Please use the original [**RECOVER** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/v4.6/PEDSnet/docs/RECOVER%20Cohort.md#data-submission). 

### Sites submitting COVID data with v4.6 submission

For sites submiiting COVID data along with the v4.6 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. 

Please use the original [**COVID** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).
