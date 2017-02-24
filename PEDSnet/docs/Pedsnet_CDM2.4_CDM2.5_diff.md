# Differences between PEDSnet CDM2.4 and CDM2.5 ****IN PROGRESS****

## CHANGES from CDM2.4.0

####Network Convention Changes 

####Source Value Alignment

####Specific Table Changes

####[1.6 Visit_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Addition of Observation Visit Type. This is a new concept id option for the `visit_concept_id` field. Please see **NOTE 2** for ETL guidance. 
1. Addition of `preceding_visit_occurrence_id`. This field is marked as optional. Sites no need to transmit this information.
2. Addition of `admitting_source_concept_id`.This field is marked as optional.This information is already being captured in the `observation table`. If you do decide to populate this table moving forward please let the DCC know in your provenance files. Transmitting this data in this column will be a requirement in future versions. This change is a result of OMOP v5.1. Pl
3. Addition of `discharge_to_concept_id`.This field is marked as optional.This information is already being captured in the `observation table`. If you do decide to populate this table moving forward please let the DCC know in your provenance files. Transmitting this data in this column will be a requirement in future versions.This change is a result of OMOP v5.1.
4. Addition of `admitting_source_value`.This field is marked as optional.This information is already being captured in the `observation table`. If you do decide to populate this table moving forward please let the DCC know in your provenance files. 5ransmitting this data in this column will be a requirement in future versions.This change is a result of OMOP v5.1.
2. Addition of `discharge_to_source_value`.This field is marked as optional.This information is already being captured in the `observation table`. If you do decide to populate this table moving forward please let the DCC know in your provenance files. Transmitting this data in this column will be a requirement in future versions.This change is a result of OMOP v5.1.

####[1.6 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence)
1. Addition of `condition_status_concept_id`. This field is marked as optional. If populating please use the Final diagnosis concept id:4230359 as no prelminary diagnosis should be reported. This change is a result of OMOP v5.1.
2. Addition of `condition_status_source_value`.This field is marked as optional. If populating please use the 'Final diagnosis' as the source value corresponding to the This field is marked as optional. If populating please use the concept id. This change is a result of OMOP v5.1.

***

## NEW in PEDSnet CDM2.5



###PEDSnet Vocabulary

The following concepts are new to the PEDSnet vocabulary:

 concept_id |                 concept_name                 |   domain_id    | concept_class_id | vocabulary_id 
------------|----------------------------------------------|----------------|------------------|---------------
 
***
