# Differences Between PEDSnet CDM 6.0 and CDM 6.1

# **** NEW in PEDSnet CDM v6.1 ****


### There are no DDL or ETL Convention Changes between PEDSnet version 6.0 and 6.1.


# **** Reminders ****
## Please ensure the following ETL enhancements from this past year are implemented for PEDSnet version 6.1 if not yet completed:

### 1. Inclusion of patient-reported medication history records in [DRUG_EXPOSURE](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#111-drug-exposure):
- Utilize `drug_type_concept_id` = `32865` to flag Patient Reported Medication records.
- See [Note 9 of DRUG_EXPOSURE](https://github.com/PEDSnet/Data_Models/blob/v60/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#note-9-1) for additional details.

### 2. Inclusion of additional "raw" PRO/SIOH survey records in [OBSERVATION](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#19-observation-1):
- Utilize `observation_type_concept_id` = `32862` to flag patient survey records.
- See [Note 10 of OBSERVATION](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#note-10) for guidance details.
- See [this GitHub Issue](https://github.com/PEDSnet/Data_Models/issues/499) as an additional implementation resource.

### 3. Inclusion of mother-baby linkage in [FACT_RELATIONSHIP]((https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#113-fact_relationship)):
- Please refer to the following guidance for modeling a mother-baby relationship:

Field | Value |
--------|--------------------------
`domain_concept_id_1` | 56 (person)​
`fact_id_1` | person_id for the Child
`domain_concept_id_2` | 56 (person)​
`fact_id_2` | person_id for the Mother
`Relationship_concept_id` | 581437 (Child to Parent Measurement)​

### 4. Inclusion of IV fluid MAR actions in [DRUG_EXPOSURE](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#111-drug-exposure):
- Utilize `drug_type_concept_id` = `2000001594` to flag IV Fluid MAR Action records.
- See [Continuous IV Fluid Volume Guidance](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Codesets%20%26%20Additional%20Guidance/Continuous%20IV%20Fluid%20Volume%20Guidance.md) and[ Note 9 of DRUG_EXPOSURE](https://github.com/PEDSnet/Data_Models/blob/v60/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#note-9-1) for details.

### 5. Inclusion of external drug records in [DRUG_EXPOSURE](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#111-drug-exposure):
- Utilize `drug_type_concept_id` = `32849` for Medications sourced from a Health Information Exchange.
- Utilize `drug_type_concept_id` = `32810 ` for Medications sourced from a Claims source.
- See [Note 9 of DRUG_EXPOSURE](https://github.com/PEDSnet/Data_Models/blob/v60/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#note-9-1) for additional details.
