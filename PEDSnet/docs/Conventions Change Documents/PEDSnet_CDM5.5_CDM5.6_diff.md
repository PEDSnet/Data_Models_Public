# Differences between PEDSnet CDM 5.5 and CDM 5.6

## **** NEW in PEDSnet CDM v5.6 ****

### 1. Clarification of [1.07 Condition_Occurrence](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions Docs/v5.6_PEDSnet_CDM_ETL_Conventions.md#17-condition-occurrence) Guidance:

When mapping and populating ICD9/ICD10 codes to condition_source_concept_id, please specify concept_id mappings within the Clinical Modification of ICD (ICD-9-CM and ICD-10-CM vocabularies).

> We realized in previous ETL convention versions that ICD9/ICD10 and ICD-9-CM/ICD-10-CM were used interchangeably in explaining mapping procedure. In the OMOP Vocabulary, ICD9/ICD10 and ICD-9-CM/ICD-10-CM represent unique vocabularies with their own set of concept_id mappings despite both having many of the same source codes.
