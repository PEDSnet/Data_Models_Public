The ETL repository PEDSnet CDM V1 to PCORnet CDM V1 transformation
===============================================================================

This repository contains the documentation and source code (PostgreSQL) to transform an instance of the PEDSnet CDM v1 to an instance of PCORnet CDM v1. 

### pedsnet_pcornet_mappings.csv
This document contains the mappings from PEDSnet vocabulary to PCORnet vocabulary. Each column in this file denotes the following: 
- Source_Concept_Class: Concept class in the OMOP vocabulary (refers to the name of a field in PCORnet model that needs to be encoded into the PCORnet vocabulary) 
- PCORNET_Concept: value as represented in the PCORnet vocabulary
- Standard_Concept_ID: concept_id in the OMOP vocabulary (this columns refers to the observation_concept_id field of the Observation table, in case of PCORnet fields that are recorded as observations in the OMOP model) 
- Value_as_concept: value_as_concept_id field in the the Observation table in PEDsnet (only applicable for fields that are recorded as observations in the PEDSnet CDM)
- Concept_Description: Natural language description of the value


### PEDSnetv1_to_PCORnetv1_ETL_Description.md
This document describes the ETL process to populate each field of the PCORnet model. 

### ETL Scripts
Folder containing the ETL scripts
