## Differences between PEDSnet CDM2.1 and CDM2.0

## CHANGES from CDM2.1

####Specific Table Changes
####[1.1 Person](Pedsnet_CDM_ETL_Conventions.md#11-person)
1. Addition of `language_concept_id` field to store the concept that corresponds to the person's primary language value as it appears in the source. This column has a list of valid concepts to map to for PEDSnet. This listing may be found [here] (Pedsnet_CDM_ETL_Conventions.md#a2-pedsnet-person-language-concept-mapping-values).
2. Addition of `language_source_value` field to store the person's primary language value as it appears in the source.

####[1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. Additon of `priority_concept_id` field to store the concept that corresponds to the lab priority value as it appears in the source. This column has a list of valid concepts to map to for PEDSnet.
2. Additiong of `priority_source_value` to store the lab priority value as it appears in the source.

***
## NEW in PEDSnet CDM2.2

###NEW Table
####[1.15 Measurement Organism](Pedsnet_CDM_ETL_Conventions.md#115-measurement_organism)
- The measurement organism table contains organism information related to laboratory culture results in the measurement table. This table is CUSTOM to PEDsnet.

###Stable Indentifer requirement
- Stable Identifier requirements have been updated for version 2.2. For PEDSnet CDMv2.2, sites are responsible for creating and storing a mapping from both `person_id` and `visit_occurrence_id` to stable local identifiers. Please see more information [here] (PEDSnet/README.md)

###PEDSnet Vocabulary
- Additional concepts have been added to the  **PEDSnet** vocabulary to accomodate needed concepts for the Healthy Weight Network and Lab priority values. This vocabulary is a supplment to the OMOP v5 vocabulary that contains specfic concepts that apply to PEDSnet data.

***
