# PEDSnet CDM V2 / SQL Server

This folder contains the SQL scripts for SQL Server. 

In order to create your instantiation of the PEDSnet CDM V2, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `pedsnetv2_sql_server_ddl.sql` to create the tables and fields.

3. Load your data into the schema.

4. **Be aware, the current release of the OMOP Vocabulary data (found [here](https://github.com/PEDSnet/Data_Models/tree/master/PEDSnet#omop-v5-vocabulary-for-version-2)) is causing some constraint failures. Please ignore and work without the constraints until we can resolve this issue.**Execute the script `pedsnetv2_sql_server_constraints.sql` to add the constraints (primary and foreign keys). 

5. Execute the script `pedsnetv2_sql_server_indexes.sql` to add the minimum set of indexes we recommend.

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.

In order to load the vocabulary data, unzip the data files into the vocab_import directory and run `omop_vocab_import.sql`.
