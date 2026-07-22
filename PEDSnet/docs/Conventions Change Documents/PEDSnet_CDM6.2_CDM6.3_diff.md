# Differences Between PEDSnet CDM 6.2 and CDM 6.3

# **** NEW in PEDSnet CDM v6.3 ****


## 1. condition_type_concept_id — [CONDITION_OCCURRENCE](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#12-condition_occurrence-1)

In PEDSnet v6.2 and prior, the `condition_type_concept_id` holds 3 dimensions: care setting, priority, and type of diagnosis.

Starting in v6.3, **care setting** should be removed from `condition_type_concept_id` and **priority** should be moved to `condition_status_concept_id`. This change impacts the expected value sets for both the `condition_type_concept_id` and `condition_status_concept_id` fields, as detailed below:

- **Care Setting** 
    - No longer to be contained in the `condition_type_concept_id` field
    - In analytics, will be obtained using linkage to visit_occurrence/visit_detail through `visit_(detail)_concept_id`
- **Priority**  
    - Should now be contained in `condition_status_concept_id` 
    - The full list of potential values for `condition_status_concept_id` can be found in the vocabulary **`where vocabulary_id = 'Condition Status'`**
    - Prioritize mapping to a concept differentiating between primary/secondary for final diagnosis, admitting diagnoses are optional but a concept ID is provided below if you wish to include these:
        - 32890 = Admission diagnosis
        - 32902 = Primary Diagnosis *
        - 32908 = Secondary Diagnosis *
            >  \* For outpatient or discharge diagnoses 
- **Type of Diagnosis**
    - Should remain in `condition_type_concept_id`
    - The full list of potential `condition_type_concept_ids` can be found in the vocabulary table **`where domain_id = 'Type Concept' and vocabulary_id = 'Type Concept' and standard_concept = 'S'`**
    - Prioritize differentiating between provider and hospital billing, clinician ordered, and problem list diagnoses:
        - 32874 = Provider billing
        - 32852 = Facility/hospital billing
        - 32833 = Clinician order
        - 32840 = EHR Problem List Entry

> The DCC will add a step to standardize this in the pipeline in the event sites are unable to make this change in their ETL process.

## 2. Pain Scale Inclusion — [MEASUREMENT](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#112-measurement-1)

Starting in v6.3, all sites are expected to include pain scales in the measurement table. This request is driven by the INSPIRE study, which is focused on identifying patients with pediatric chronic primary pain. 

The study team is interested in the following pain scales: 
- **Numeric pain score** (Identified as a priority for the study)
- FLACC (Face, Legs, Activity, Cry, Consolability) total score 
- FLACC component scores, if available 
- (Wong-Baker) FACES pain scale 
- Other pain scores (not listed above)

 All pain scores are expected to have something in `value_source_value`, which could be a numeric value (even if the value is 0), a numeric value with an operator, and/or a string. 

Please see **Note 8** under the [Measurement](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#112-measurement-1) table for specific guidance on how to populate the Measurement table with pain scale data.


# **** Convention Clarifications/Reminders ****

## 1. All date/datetime fields should be reported using the site's local time without attributing a timezone

Datetime fields in particular have a datatype of 'TIMESTAMP WITHOUT TIME ZONE', please ensure you are not including a time zone in your data submission and use the local time of your site (not UTC or similar).

## 2. Domain_id fields should contain a string in sentence case

The `domain_id` field in the [specialty](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#121-specialty-1) and [location_history](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#119-location_history) tables should be a string value, not numeric. We are also requesting that sites use sentence case (first letter capitalized only) to better align with OMOP. For example: 'Person', 'Provider', 'Care site'

> The DCC will add a step to standardize this in the pipeline in the event sites are unable to make this change in their ETL process.

## 3. Drug Metadata Priorities — [DRUG_EXPOSURE](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#111-drug-exposure)

Sites should continue to prioritize the following drug metadata fields for the v6.3 submission cycle if not yet fully implemented:

- **Dose Unit** (`dose_unit_concept_id` / `dose_unit_source_value`)
- **End dates / Duration** (`drug_exposure_end_date` / `days_supply` / `frequency`)

No new fields have been added; this is a priority callout to improve data completeness across the network.

## 4. Mental and Behavioral Health Data

There is no expectation of any changes being made for this version, but sites should begin investigating the following items relating to mental and behavioral heath (MBH) data:

- Begin to look into how MBH services are recorded
    - What visit types, what providers, etc., and how to get those in the PEDSnet data
- Investigate the governance of sensitive MBH data, and whether our existing desensitization process covers your site's needs
