# Differences between PEDSnet CDM 2.6 and CDM 2.7

## REQUIRED for 2.7.0

Please use the following logic to populate the condition_concept_id, condition_source_concept_id and condition_source_value based on what is available in your source system:

You have in your source system | condition_concept_id	|  condition_source_concept_id|	condition_source_value
---|---|---|---
Any diagnosis that was captured as a term or name (e.g. IMO to SNOMED)|	Corresponding SNOMED concept id	|Corresponding concept for site diagnosis captured (must correspond to ICD9/ICD10 concept mapping)	|Diagnosis Name \| IMO Code \| Diagnosis Code
Any diagnosis that was captured directly as a code (e.g. ICD9/10) by a coder	|Corresponding SNOMED concept id	|Corresponding concept for site diagnosis code (must correspond to ICD9/ICD10 concept mapping)|Diagnosis Name \| IMO Code \| Diagnosis CodeCode

It is required to format the `condition_source_value` as `Diagnosis Name | IMO Code | Diagnosis Code`. For version, 2.6 no site adhered to this convention.

***
## NEW in PEDSnet CDM2.7

#### [1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. Mean Arterial Pressure Values with appopriate unit. Optional.
2. Heart Rate Values with appopriate unit. Optional.
3. Oxygen Saturation Values with appopriate unit. Optional.
4. Respiratory Rate Values with appopriate unit. Optional.

***
