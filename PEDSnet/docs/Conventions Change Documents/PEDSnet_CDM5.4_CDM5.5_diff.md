# Differences between PEDSnet CDM 5.4 and CDM 5.5

## **** NEW in PEDSnet CDM v5.5 ****

### 1. Additional Guidance for [1.11 Drug Exposure](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.4_PEDSnet_CDM_ETL_Conventions.md#111-drug-exposure):

For Patient Reported Drugs records in source EHR system, PEDSnet version 5.5 is now allowing a new drug_type_concept_id option `drug_type_concept_id = 32865 "Patient self-report"` in the drug exposure table. 


> * If participating sites are already sending patient reported drugs, we ask to parse out these records from other drug_type_concept_ids (such as prescriptions) to `drug_type_concept_id = 32865`.
> 
> * PEDSnet version 5.5 providing this new drug_type_concept_id option to prepare for interoperability with PCORnet's upcoming CDM Version 7.0 (coming in the next 12 - 18 months). PCORnet CDM Version 7.0 will have a larger focus on patient reported outcomes and measures.


### 2. Update to [1.24 Cohort Definition](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.4_PEDSnet_CDM_ETL_Conventions.md#124-cohort_definition) Guidance:

Please exclude your cohort_definition table (cohort_definition.csv) from your local running of the infomodels tool and the submission of your PEDSnet data to the CHOP SFTP. 

> The cohort_definition table should be treated as an additional "vocabulary lookup table" (similar to the concept for example) and only needs to be retianed locally. Despite being included in the DDL, cohort_definition should not be included in your final data submission.
> 
> Note that the `cohort_definition.csv` file used to populate your local cohort_definition table can be found [linked directly here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v5.4_PEDSnet_CDM_ETL_Conventions.md#124-cohort_definition) as well as distributed within the Quarterly PEDSnet Vocabulary release.


----
