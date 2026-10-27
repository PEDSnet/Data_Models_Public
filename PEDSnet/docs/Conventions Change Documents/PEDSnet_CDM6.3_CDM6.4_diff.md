# Differences Between PEDSnet CDM 6.3 and CDM 6.4

# **** NEW in PEDSnet CDM v6.4 ****

## 1. Added Vocabulary Tables 

In accordance with the [OMOP v5.5 CDM](https://forums.ohdsi.org/t/omop-cdm-v5-5-release/25881) release, 3 new vocabulary tables have been added to the PEDSnet CDM v6.4:
- [PACK_CONTENT](https://ohdsi.github.io/CommonDataModel/cdm55.html#pack_content): The PACK_CONTENT table contains structured content of drug packs.
- [CONCEPT_METADATA](https://ohdsi.github.io/CommonDataModel/cdm55.html#concept_metadata): The concept_metadata table stores metadata for each concept from the concept table.
- [CONCEPT_RELATIONSHIP_METADATA](https://ohdsi.github.io/CommonDataModel/cdm55.html#concept_relationship_metadata): The concept_relationship_metadata table stores metadata for each relationship between concepts from the concept_relationship table.

No ETL changes are required for these added tables at this time, but note that they will be present in the `vocabulary` schema for PEDSnet v6.4 and have been added to the [v6.4 DDL.](https://data-models-sqlalchemy.research.chop.edu/pedsnet/6.4.0/)


## 2. Asthma Score Inclusion - [OBSERVATION](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v6.4_PEDSnet_CDM_ETL_Conventions.md#19-observation-1)
Starting in v6.4, sites will pilot the inclusion of asthma scores in the observation table with intent to refine in the following cycles. 

Please explore inclusion of the following asthma score measures: 
- Pediatric Asthma Score (PAS) 
- Pediatric Asthma Severity Score (PASS)
- Pediatric Respiratory Assessment Measure (PRAM)

## 3. Removal of Suggested Language Mapping

In PEDSnet v6.3 and prior, we had provided a list of most common languages spoken at sites. 

Starting in v6.4, we are asking that sites **map all available languages** to a standard concept in the vocabulary. Any ETL processes applying a manual mapping of language according to the outdated list should be revised to map as many languages as possible in the [PERSON](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v6.4_PEDSnet_CDM_ETL_Conventions.md#11-person-1) table.   

## 4. Mental and Behavioral Health Data

Starting in v6.4, sites should confirm inclusion/completeness of data for Mental and Behavioral Health (MBH) services as discovered in the previous exploratory data cycles. 

What the DCC will be looking for:
- Visits with psychology, psychiatry, or counseling according to provider or care site specialty
- Capture of MBH-related diagnoses, using [Mental Health Clusters](https://pedsnet.org/metadata/entities/conceptset/4d653292-fc6a-4638-bfde-dae51edee7f9) as a foundation
- Visits with source values mentioning counseling or cognitive therapy
- Billable procedure codes for counseling or cognitive therapy


# **** Convention Clarifications/Reminders ****

## 1. All date/datetime fields should be reported using the site's local time without attributing a timezone

Datetime fields in particular have a datatype of 'TIMESTAMP WITHOUT TIME ZONE', please ensure you are not including a time zone in your data submission and use the local time of your site (not UTC or similar). 

## 2. condition_type_concept_id — [CONDITION_OCCURRENCE](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v6.4_PEDSnet_CDM_ETL_Conventions.md#12-condition_occurrence-1)

Minor adjustments have been made to the expected value sets for both the `condition_type_concept_id` and `condition_status_concept_id` fields, as detailed below:


- **condition_status_concept_id**  
    - This field should contain information on the priority (ie. primary, secondary) of the diagnosis or point during the visit the diagnosis was given (ie. admission) 
    - The full list of potential values for `condition_status_concept_id` can be found in the vocabulary **`where vocabulary_id = 'Condition Status'`**
    - Prioritize mapping to a concept differentiating between primary/secondary for final diagnosis; admitting diagnoses are optional but a concept ID is provided below if you wish to include these:
        - 32890 = Admission diagnosis
        - 32902 = Primary Diagnosis
        - 32908 = Secondary Diagnosis 
        - 32893 = Confirmed diagnosis (best for problem list)
- **condition_type_concept_id**
    - This field should contain information on the source of the diagnosis (ie. billed, order, claim, problem list)
    - The full list of potential `condition_type_concept_ids` can be found in the vocabulary table **`where domain_id = 'Type Concept' and vocabulary_id = 'Type Concept' and standard_concept = 'S'`**
    - Prioritize differentiating between provider and hospital billing, clinician ordered, and problem list diagnoses:
        - 32874 = Provider billing
        - 32852 = Facility/hospital billing
        - 32833 = Clinician order
        - 32840 = EHR Problem List Entry
        - 32810 = Claim

Please see **Note 2** under the [CONDITION_OCCURRENCE](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v6.4_PEDSnet_CDM_ETL_Conventions.md#12-condition_occurrence-1) table for additional guidance on how to populate these fields.

> The DCC will add a step to standardize this in the pipeline in the event sites are unable to make this change in their ETL process.

## 3. Pain Scale Inclusion — [MEASUREMENT](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v6.4_PEDSnet_CDM_ETL_Conventions.md#112-measurement-1)

Starting in v6.3, **ALL sites** are expected to include pain scales in the measurement table. This request is driven by the INSPIRE study, which is focused on identifying patients with pediatric chronic primary pain. 

The study team is particularly interested in **Numeric pain scores**

 All pain scores are expected to have something in `value_source_value`, which could be a numeric value (even if the value is 0), a numeric value with an operator, and/or a string. 

 If the result of a pain score is recorded as 0/indicating lack of pain, please include the score with a `value_as_number` of 0. It is known that some systems will not prompt for a score if no pain is present. Please leave `value_as_number` empty (NULL) if you are able to discern whether a patient has declined assessment or similar (non-verbal, no information, etc.).

Please see **Note 8** under the [Measurement](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v6.4_PEDSnet_CDM_ETL_Conventions.md#112-measurement-1) table for specific guidance on how to populate the Measurement table with pain scale data.


## 4. Drug Metadata Priorities — [DRUG_EXPOSURE](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v6.4_PEDSnet_CDM_ETL_Conventions.md#111-drug-exposure)

Sites should continue to prioritize the following drug metadata fields for the v6.4 submission cycle if not yet fully implemented:

- **Dose Unit** (`dose_unit_concept_id` / `dose_unit_source_value`)
- **End dates / Duration** (`drug_exposure_end_date` / `days_supply` / `frequency`)

No new fields have been added; this is a priority callout to improve data completeness across the network.

