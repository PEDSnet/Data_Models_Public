# PEDSnet CDM V2 / Oracle

This folder contains the SQL scripts for Oracle. 

In order to create your instantiation of PEDSnet CDM V2, we recommend following these steps:

1. Create an empty schema.

2. Execute the script `pedsnetv2_oracle_ddl.sql` to create the tables and fields.

3. Load your data into the schema.

4. **Be aware, the current release of the OMOP Vocabulary data (found [here](https://github.com/PEDSnet/Data_Models/tree/master/PEDSnet#omop-v5-vocabulary-for-version-2)) is causing foreign key constraint failures. Please work without the constraints until we can resolve this issue.** Execute the script `pedsnetv2_oracle_constraints.sql` to add the constraints (primary and foreign keys). 

5. Execute the script `pedsnetv2_oracle_indexes.sql` to add the minimum set of indexes we recommend.

Note: you could also apply the constraints and/or the indexes before loading the data, but this will slow down the insertion of the data considerably.

Also note: you can apply the indexes without first applying the constraints, but then we recommend you use the script `pedsnetv2_oracle_indexes_wo_constraints.sql`. (This script will also create the indexes that would normally be automatically created by the primary key constraints.)

In order to load the vocabulary data, unzip the data files into the `vocab_import` folder and run either `omop_vocab_import.bat` (for Windows machines) or `omop_vocab_import.sh` (for Unix machines).
