# Differences between PEDSnet CDM2.4 and CDM2.5 ****IN PROGRESS****

## CHANGES from CDM2.4.0

####Network Convention Changes 

####Specific Table Changes

####[1.4 Care_Site](Pedsnet_CDM_ETL_Conventions.md#14-care_site)
1. Update of valid value set for `place_of_service_concept_id`. Please map to the following concepts:

concept_id |    concept_name 
--- | ---  | ---            
8782 | Urgent Care Facility
8761 | Rural Health Clinic
8756 | Outpatient Hospital 
 8844 | Other Place of Service
 8892 | Other Inpatient Care
8940 | Office
 8971 | Inpatient Psychiatric Facility
  8717 | Inpatient Hospital |
8716 | Independent Clinic
8870 | Emergency Room - Hospital


####[1.6 Visit_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Addition of Observation Visit Type. This is a new concept id option for the `visit_concept_id` field. Please see **NOTE 2** for ETL guidance. 
1. Addition of `preceding_visit_occurrence_id`. This field is marked as optional. Sites no need to transmit this information.
2. Addition of `admitting_source_concept_id`.This field is marked as optional.This information is already being captured in the `observation table`. Please use the value set defined in the Conventions column. If you do decide to populate this table moving forward please let the DCC know in your provenance files. Transmitting this data in this column will be a requirement in future versions. This change is a result of OMOP v5.1. Pl
3. Addition of `discharge_to_concept_id`.This field is marked as optional.This information is already being captured in the `observation table`. Please use the value set defined in the Conventions column. If you do decide to populate this table moving forward please let the DCC know in your provenance files. Transmitting this data in this column will be a requirement in future versions.This change is a result of OMOP v5.1.
4. Addition of `admitting_source_value`.This field is marked as optional.This information is already being captured in the `observation table`. Please use the value set defined in the Conventions column.If you do decide to populate this table moving forward please let the DCC know in your provenance files. 5ransmitting this data in this column will be a requirement in future versions.This change is a result of OMOP v5.1.
2. Addition of `discharge_to_source_value`.This field is marked as optional.This information is already being captured in the `observation table`. Please use the value set defined in the Conventions column. If you do decide to populate this table moving forward please let the DCC know in your provenance files. Transmitting this data in this column will be a requirement in future versions.This change is a result of OMOP v5.1.

####[1.6 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence)
1. Addition of `condition_status_concept_id`. This field is marked as optional. If populating please use the Final diagnosis concept id:4230359 as no prelminary diagnosis should be reported. This change is a result of OMOP v5.1.
2. Addition of `condition_status_source_value`.This field is marked as optional. If populating please use the 'Final diagnosis' as the source value corresponding to the This field is marked as optional. If populating please use the concept id. This change is a result of OMOP v5.1.
3. Update of valid value set for `condition_type_concept_id`. Please map to the following concepts:
 
 concept_id |                   concept_name                    
------------|---------------------------------------------------
 2000000089 | EHR problem list entry - Order Origin
 2000000090 | EHR problem list entry - Billing Origin
 2000000091 | EHR problem list entry - Claim Origin
 2000000092 | Inpatient header - primary - Order Origin
 2000000093 | Inpatient header - primary - Billing Origin
 2000000094 | Inpatient header - primary - Claim Origin
 2000000095 | Outpatient header - 1st position - Order Origin
 2000000096 | Outpatient header - 1st position - Billing Origin
 2000000097 | Outpatient header - 1st position - Claim Origin
 2000000098 | Inpatient header - 2nd position - Order Origin
 2000000099 | Inpatient header - 2nd position - Billing Origin
 2000000100 | Inpatient header - 2nd position - Claim Origin
 2000000101 | Outpatient header - 2nd position - Order Origin
 2000000102 | Outpatient header - 2nd position - Billing Origin
 2000000103 | Outpatient header - 2nd position - Claim Origin

***

###PEDSnet Vocabulary

The following concepts are new to the PEDSnet vocabulary:

 concept_id |                 concept_name                 |   domain_id    | concept_class_id | vocabulary_id 
------------|----------------------------------------------|----------------|------------------|---------------
  2000000088 | Observation Stay - PCORNet                        | Visit        | Encounter Type   | PEDSnet
 2000000089 | EHR problem list entry - Order Origin             | Type Concept | Condition Type   | PEDSnet
 2000000090 | EHR problem list entry - Billing Origin           | Type Concept | Condition Type   | PEDSnet
 2000000091 | EHR problem list entry - Claim Origin             | Type Concept | Condition Type   | PEDSnet
 2000000092 | Inpatient header - primary - Order Origin         | Type Concept | Condition Type   | PEDSnet
 2000000093 | Inpatient header - primary - Billing Origin       | Type Concept | Condition Type   | PEDSnet
 2000000094 | Inpatient header - primary - Claim Origin         | Type Concept | Condition Type   | PEDSnet
 2000000095 | Outpatient header - 1st position - Order Origin   | Type Concept | Condition Type   | PEDSnet
 2000000096 | Outpatient header - 1st position - Billing Origin | Type Concept | Condition Type   | PEDSnet
 2000000097 | Outpatient header - 1st position - Claim Origin   | Type Concept | Condition Type   | PEDSnet
 2000000098 | Inpatient header - 2nd position - Order Origin    | Type Concept | Condition Type   | PEDSnet
 2000000099 | Inpatient header - 2nd position - Billing Origin  | Type Concept | Condition Type   | PEDSnet
 2000000100 | Inpatient header - 2nd position - Claim Origin    | Type Concept | Condition Type   | PEDSnet
 2000000101 | Outpatient header - 2nd position - Order Origin   | Type Concept | Condition Type   | PEDSnet
 2000000102 | Outpatient header - 2nd position - Billing Origin | Type Concept | Condition Type   | PEDSnet
 2000000103 | Outpatient header - 2nd position - Claim Origin   | Type Concept | Condition Type   | PEDSnet
***
