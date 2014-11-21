The ETL scripts for PEDSnet CDM V1 to PCORnet CDM V1 transformation
===============================================================================

### cz_omop_pcornet_concept_map_ddl.sql
This document contains the DDL script to create the source-to-concept mapping table (i.e. PEDSnet->PCORnet vocabulary mapping) into database. In addition, each site is required to manually load the [pedsnet_pcornet_mappings.csv file] (../pedsnet_pcornet_mappings.csv) into this table. The PostgreSQL setting for importing the file include: format=csv, header=check.

### pcornet_schema_ddl.sql
This is the script to generate the pcornet schema in a PostgreSQL database. For this script to run without errors, the 'rosita' username must be replaced by the name of the user of your OMOP database. Important: running this script will permanently erase all data in the existing pcornet schema.

### PEDSnet-PCORnet.sql
This file contains the complete ETL source code, i.e. table-wise SQL queries to extract the PCORnet instance from a given PEDSnet CDM instance and the source-to-concept mapping table 



