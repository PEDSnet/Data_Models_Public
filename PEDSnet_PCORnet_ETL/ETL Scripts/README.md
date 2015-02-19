#The ETL scripts for PEDSnet CDM V1 to PCORnet CDM V1 transformation

## Contents 
### cz\_omop\_pcornet\_concept\_map\_ddl.sql
This document contains the DDL script to create the source-to-concept mapping table (i.e. PEDSnet->PCORnet vocabulary mapping) into database. 

### PEDSnet-PCORnet.sql
This file contains the complete ETL source code, i.e. table-wise SQL queries to extract the PCORnet instance from a given PEDSnet CDM instance and the source-to-concept mapping table. All six queries (Demographic, Enrollment, Encounter, Diagnosis, Procedure, Vital) are in working condition

## Steps for Executing the Scripts 
1. Execute the [PCORnet Schema DDL](https://github.com/PEDSnet/Data_Models/tree/master/PCORnet)
2. Execute the [Mapping table DDL] (cz\_omop\_pcornet\_concept\_map\_ddl.sql) 
3. Populate the mapping table created in Step 2 by importing the [pedsnet\_pcornet\_mappings.txt file] (../pedsnet_pcornet_mappings.txt). The setting for import in PostgreSQL include, format=text, delimiter=|, NULL String=NULL.
4. Execute the [ETL queries](PEDSnet-PCORnet.sql)
