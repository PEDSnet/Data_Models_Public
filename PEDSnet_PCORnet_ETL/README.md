#The ETL repository PEDSnet CDM V1 to PCORnet CDM V1 transformation

This repository contains the documentation and source code (PostgreSQL) to transform an instance of the PEDSnet CDM v1 to an instance of PCORnet CDM v1. 

## pedsnet\_pcornet\_mappings.xls 
This document contains the mappings from PEDSnet vocabulary to PCORnet vocabulary. Each column in this file denotes the following: 
- Source\_Concept\_Class: Concept class in the OMOP vocabulary (refers to the name of a field in PCORnet model that needs to be encoded into the PCORnet vocabulary) 
- PCORNET_Concept: value as represented in the PCORnet vocabulary
- Standard\_Concept\_ID: concept\_id in the OMOP vocabulary (this columns refers to the observation\_concept_id field of the Observation table, in case of PCORnet fields that are recorded as observations in the OMOP model) 
- Value\_as\_concept: value\_as\_concept\_id field in the the Observation table in PEDsnet (only applicable for fields that are recorded as observations in the PEDSnet CDM)
- Concept\_Description: Natural language description of the value

## pedsnet\_pcornet\_mappings.txt
This document is a text version of the pedsnet\_pcornet\_mappings.xls file. The fields are pipe-delimited. 

## PEDSnetv1\_to\_PCORnetv1\_ETL\_Description.md
This document describes the ETL process to populate each field of the PCORnet model. (Work in Progress)

## ETL Scripts
Folder containing the ETL scripts
