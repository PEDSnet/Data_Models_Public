## PEDSnet CDM V3.1

The PEDSnet common data model version 3.1 is an update to version 3.0. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.1 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v3.1.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.1 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.1

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.1 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v3.1.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here(https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).
### Changes from Version 3.1

Please see the applicable change document for changes and additions for the v3.1 data model [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM3.0_CDM3.1_diff.md)

## Site Responsibility for Version 3.1

### Stable Identifiers

For PEDSNet CDMv3.1, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 3.1.0` as arguments when running the validator. 

## Reference Materials for Version 3.1

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.1.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.1.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.1.0/ddl/mssql/)

### Vocabulary Data

- v3.1.0 Core Vocabulary: [here](https://chop.sharefile.com/d-s7f75b87b6bb4fad8)

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
## PEDSnet CDM V3.0

The PEDSnet common data model version 3.0 is an update to version 2.9. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.0 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v3.0.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.0 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.0

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.0 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v3.0.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here(https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).
### Changes from Version 3.0

Please see the applicable change document for changes and additions for the v3.0 data model [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM2.9_CDM3.0_diff.md)

## Site Responsibility for Version 3.0

### Stable Identifiers

For PEDSNet CDMv3.0, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 3.0.0` as arguments when running the validator. 

## Reference Materials for Version 3.0

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.0.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.0.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.0.0/ddl/mssql/)

### Vocabulary Data

- v3.0.0 Core Vocabulary: [here](https://chop.sharefile.com/d-sc5e4647cc8e42f1a)
If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***

## PEDSnet CDM V2.9

The PEDSnet common data model version 2.9 is an update to version 2.8. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V2.9 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.9.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V2.9 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 2.9

The PEDSnet ETL conventions are described in the [PEDSnet CDM V2.9 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.9.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here(https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).
### Changes from Version 2.9

Please see the applicable change document for changes and additions for the v2.9 data model [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM2.8_CDM2.9_diff.md)

## Site Responsibility for Version 2.9

### Stable Identifiers

For PEDSNet CDMv2.9, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 2.9.0` as arguments when running the validator. 

## Reference Materials for Version 2.9

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.9.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.9.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.9.0/ddl/mssql/)

### Vocabulary Data

- v2.9.0 Core Vocabulary: [here](https://chop.sharefile.com/d-sb118e0c51244be6b)
If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
## PEDSnet CDM V2.8

The PEDSnet common data model version 2.8 is an update to version 2.7. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V2.8 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.8.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V2.7 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 2.8

The PEDSnet ETL conventions are described in the [PEDSnet CDM V2.8 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.8.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here(https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).
### Changes from Version 2.8

Please see the applicable change document for changes and additions for the v2.8 data model [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM2.7_CDM2.8_diff.md)

## Site Responsibility for Version 2.8

### Stable Identifiers

For PEDSNet CDMv2.8, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 2.8.0` as arguments when running the validator. 

## Reference Materials for Version 2.8

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.8.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.8.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.8.0/ddl/mssql/)

### Vocabulary Data

- v2.8.0 Core Vocabulary: [here](https://chop.sharefile.com/d-s4a050d0aea84843a)
If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
## PEDSnet CDM V2.7

The PEDSnet common data model version 2.7 is an update to version 2.6. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V2.7 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.7.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V2.7 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 2.7

The PEDSnet ETL conventions are described in the [PEDSnet CDM V2.7 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.7.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here(https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).
### Changes from Version 2.7

Please see the applicable change document for changes and additions for the v2.7 data model [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM2.6_CDM2.7_diff.md)

## Site Responsibility for Version 2.7

### Stable Identifiers

For PEDSNet CDMv2.7, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 2.7.0` as arguments when running the validator. 

## Reference Materials for Version 2.7

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.7.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.7.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.7.0/ddl/mssql/)

### Vocabulary Data

- v2.7.1 Core Vocabulary: [here](https://chop.sharefile.com/d-scd4044d7c7d4a60a)
If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
## PEDSnet CDM V2.6

The PEDSnet common data model version 2.6 is an update to version 2.5. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V2.6 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.6.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V2.6 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 2.6

The PEDSnet ETL conventions are described in the [PEDSnet CDM V2.6 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.6.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here(https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).
### Changes from Version 2.6

Please see the applicable change document for changes and additions for the v2.6 data model [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM2.5_CDM2.6_diff.md)

## Site Responsibility for Version 2.6

### Stable Identifiers

For PEDSNet CDMv2.6, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 2.6.0` as arguments when running the validator. 

## Reference Materials for Version 2.6

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.6.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.6.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.6.0/ddl/mssql/)

### Vocabulary Data

- v2.6.1 Core Vocabulary: [here](https://chop.sharefile.com/d-s1af791df3ad45d68)
If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***


## PEDSnet CDM V2.5

The PEDSnet common data model version 2.5 is an update to version 2.4. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V2.5 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.5.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V2.5 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 2.5

The PEDSnet ETL conventions are described in the [PEDSnet CDM V2.5 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.5.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here(https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).
### Changes from Version 2.4

Please see the applicable change document for changes and additions for the v2.5 data model [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM2.4_CDM2.5_diff.md)

## Site Responsibility for Version 2.5

### Stable Identifiers

For PEDSNet CDMv2.5, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 2.1.0` as arguments when running the validator. To verify i2b2-for-PEDSnet-format data, use `-model i2b2_pedsnet` and `-version 2.0.0` as arguments.

## Reference Materials for Version 2.5

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.5.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.5.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.5.0/ddl/mssql/)

### Vocabulary Data

- v2.5.1 Core Vocabulary: [here](https://chop.sharefile.com/d-s67a4bdea3204436b)
If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***


## PEDSnet CDM V2.4

The PEDSnet common data model version 2.4 is an update to version 2.3. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V2.4 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.4.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V2.4 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 2.4

The PEDSnet ETL conventions are described in the [PEDSnet CDM V2.4 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v2.4.0_1/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).

### Changes from Version 2.3

Please see the applicable change document for changes and additions for the v2.4 data model [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM2.3_CDM2.4_diff.md)

## Site Responsibility for Version 2.4

### Stable Identifiers

For PEDSNet CDMv2.4, sites are responsible for creating and storing a mapping from both `person_id` and `visit_occurrence_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id` and `visit_occurrence_id` values to the same person and visit entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 2.1.0` as arguments when running the validator. To verify i2b2-for-PEDSnet-format data, use `-model i2b2_pedsnet` and `-version 2.0.0` as arguments.

## Reference Materials for Version 2.4

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.4.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.4.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.4.0/ddl/mssql/)

### Vocabulary Data

- v2.4.0 Core Vocabulary: [here] (https://chop.sharefile.com/d-s7c124afdf9740e78)

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.
***
***
***
## PEDSnet CDM V2.3

The PEDSnet common data model version 2.3 is an update to version 2.2. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V2.3 ETL Conventions](docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V2.3 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 2.3

The PEDSnet ETL conventions are described in the [PEDSnet CDM V2.3 ETL Conventions](docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).

### Changes from Version 2.2

Please see the applicable change document for changes and additions for the v2.3 data model [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM2.2_CDM2.3_diff.md)

## Site Responsibility for Version 2.3

### Stable Identifiers

For PEDSNet CDMv2.3, sites are responsible for creating and storing a mapping from both `person_id` and `visit_occurrence_id` to stable local identifiers. These `person_id` and `visit_occurrence_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id` and `visit_occurrence_id` values to the same person and visit entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 2.1.0` as arguments when running the validator. To verify i2b2-for-PEDSnet-format data, use `-model i2b2_pedsnet` and `-version 2.0.0` as arguments.

## Reference Materials for Version 2.3

### Data Model DDL

- Postgres: [here] (https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.3.0/ddl/postgresql/)
- Oracle: [here] (https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.3.0/ddl/oracle/)
- Microsoft SQL Server: [here] (https://data-models-sqlalchemy.research.chop.edu/pedsnet/2.3.0/ddl/mssql/)

### Vocabulary Data

- v2.3.0 Core Vocabulary: [here](https://chop.sharefile.com/d-s9e5beff4c82444d9)

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.
***
***
***
## PEDSnet CDM V2.2

The PEDSnet common data model version 2.2 is an update to version 2. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V2.2 ETL Conventions](docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V2.2 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 2.2

The PEDSnet ETL conventions are described in the [PEDSnet CDM V2.2 ETL Conventions](docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).

## Site Responsibility for Version 2.2

### Stable Identifiers

For PEDSNet CDMv2.2, sites are responsible for creating and storing a mapping from both `person_id` and `visit_occurrence_id` to stable local identifiers. These `person_id` and `visit_occurrence_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id` and `visit_occurrence_id` values to the same person and visit entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 2.1.0` as arguments when running the validator. To verify i2b2-for-PEDSnet-format data, use `-model i2b2_pedsnet` and `-version 2.0.0` as arguments.

## Reference Materials for Version 2.2

### Data Model DDL

- Postgres: [here](http://dmsa.a0b.io/pedsnet/2.2.0/ddl/postgresql/)
- Oracle: [here](http://dmsa.a0b.io/pedsnet/2.2.0/ddl/oracle/)
- Microsoft SQL Server: [here](http://dmsa.a0b.io/pedsnet/2.2.0/ddl/mssql/)

### Vocabulary Data

- v2.2.0 Core Vocabulary:***link coming soon***
- GPI supplement (Medispan sites only): ***link coming soon***

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.
***
***
***

## PEDSnet CDM V2.1

The PEDSnet common data model version 2.1 is an update to version 2. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V2.1 ETL Conventions](docs/Pedsnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V2.1 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables. Those tables not documented are still in a draft state.

### ETL Conventions for Version 2.1

The PEDSnet ETL conventions are described in the [PEDSnet CDM V2.1 ETL Conventions](docs/Pedsnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).

## Site Responsibility for Version 2.1

### Stable Identifiers

For PEDSNet CDMv2.1, sites are responsible for creating and storing a mapping from both `person_id` and `visit_occurrence_id` to stable local identifiers. These `person_id` and `visit_occurrence_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from now on. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id` and `visit_occurrence_id` values to the same person and visit entities. The mappings should not be sent to the DCC, so the DCC will have no way of verifying the work until the next data cycle (in February).

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 2.1.0` as arguments when running the validator. To verify i2b2-for-PEDSnet-format data, use `-model i2b2_pedsnet` and `-version 2.0.0` as arguments.

## Reference Materials for Version 2.1

### Data Model DDL

- Postgres: https://upenn.box.com/s/tnowmeo0sy5gj6m9446q1ivs99kw4xxd
- Oracle: https://upenn.box.com/s/jn3bivxq7k7ylj9m6jvwsle9wz8l1pjx
- Microsoft SQL Server: https://upenn.box.com/s/02swf4dz3l52ck582uqlkpdae55f30sd

### Vocabulary Data

- v2.1.1 Core Vocabulary: https://upenn.box.com/s/txrcn5s6ridq8w46chvoyrri7gul84ca
- GPI supplement (Medispan sites only): https://upenn.box.com/s/2oatwfqt1otnj9aeo2jwfge8or1k8v9g

Please note that the above v2.1.1 Core Vocabulary data is a patch-level update from the originally released v2.1.0 Core Vocabulary data. This patch-level update removes a small number of concept relation records, which referenced non-existent concepts, from the v2.1.0 release and adds the Measurement Type domain record. This change is *NOT* critical, but it does allow the full set of intended foreign key constraints to be applied without error on the vocabulary tables, which was not possible with the v2.1.0 release (see [here](https://github.com/PEDSnet/Data_Models/issues/197#issuecomment-153871511) for details). Also, this change *IS* backwards compatible (no changes were made to the core concept table), so any work you have already done on your ETL for this round will absolutely continue to function with the new vocabulary data.

The process for updating your vocabulary with the newly released data is as follows:

1. Download the v2.1.1 Core Vocabulary files from https://upenn.box.com/s/txrcn5s6ridq8w46chvoyrri7gul84ca
2. Remove the constraints from your data model using the following code:
    - Postgres: http://dmsa.a0b.io/pedsnet/2.1.0/drop/postgresql/constraints/
    - Oracle: http://dmsa.a0b.io/pedsnet/2.1.0/drop/oracle/constraints/
    - MS SQL Server: http://dmsa.a0b.io/pedsnet/2.1.0/drop/mssql/constraints/
3. Delete the data from your vocabulary tables.
4. Load the new data into your vocabulary tables (note that if you are a Medispan site, you will also have to reload the GPI supplement, which has not changed and is still available at https://upenn.box.com/s/2oatwfqt1otnj9aeo2jwfge8or1k8v9g)
5. Reapply the constraints to your data model using the following code:
    - Postgres: http://dmsa.a0b.io/pedsnet/2.1.0/ddl/postgresql/constraints/
    - Oracle: http://dmsa.a0b.io/pedsnet/2.1.0/ddl/oracle/constraints/
    - MS SQL Server: http://dmsa.a0b.io/pedsnet/2.1.0/ddl/mssql/constraints/

Please complete this process as soon as you are able, so that we are all using the same vocabulary data moving forward. As a reminder, these files are for the November 2015 data cycle, with a data upload/completion date of November 30, 2015, and date of January 01, 2016 for availability of the data and DQA results.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.

***
***
***


## PEDSnet CDM V2

The PEDSnet common data model version2 is based on the OMOP CDM V5. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V2 ETL Conventions](V2/docs/Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md) file. The PEDSnet CDM V2 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point, but the data definition language files include all of the OMOP tables. Those tables not documented are still in a draft state.

### ETL Conventions for Version 2

The PEDSnet ETL conventions are described in the [PEDSnet CDM V2 ETL Conventions](V2/docs/Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).

## Site Responsibility for Version 2
###Stable Identifiers

For PEDSNet CDMv2, sites are responsible for sending stable person_id and visit_occurrence_id identifiers for their dataset. How this is implemented at a particular site, is up to the sites discretion. The value must be stable over time for each data transfer to the DCC.

### Database Dialects for Version 2

DDL scripts for creating the PEDSnet CDM V2 will be available soon!

- PostgreSQL *link coming soon*
- MySQL *link coming soon*
- Oracle *link coming soon*
- MS SQL Server *link coming soon*

### Changes from OMOP CDM V5

#### Field additions and deletions

1. Utilize the `time_of_birth` field as a Datetime field where the full date of the birth is stored.
2. Utilize the ETL conventions document's appendix to populate the Care_Site `specialty_concept_id`.
3. Utilize the ETL conventions document's appendix to populate the Provider `specialty_concept_id`.
4. Add `visit_start_time' and `visit_end_time` fields to the visit table.
5. Add `death_time` field to the `death` table.
6. Add `condition_start_time' and `condition_end_time` fields to the condition_occurrence table.
7. Add `procedure_time` field to the `procedure_occurrence` table.
8. Add `observation_period_start_time` and `observation_period_end_time` fields to the observation_period table.
9. Change field orders within some tables.

## Original OMOP files

The original OMOP CDM and Vocabulary V5 specification is included in [docs](V2/docs) directory for reference.

##OMOP v5 Vocabulary for Version 2:

The corresponding version of the vocabulary for PEDSNet CDM Version 2 can be found here: https://upenn.app.box.com/s/g5m9xzffjncr6lgiq34dxd6bh1wx5c52 **Please note:** We have found some issues with the existing vocabulary dataset and are addressing them with OHDSI. These will not effect your work, but you may see some constraints fail to build when you create the CDM schema. (Specifically, some foreign key constraints that target the `concept` table and the `drug_strength` table's primary key.) We will update with more information when available.

***
***
***



## PEDSnet CDM V1

The PEDSnet common data model is based on the OMOP CDM V4. A full description of the data model is available in the [PEDSnet CDM V1](V1/docs/PEDSnet_CDM_V1.md) file. A description of PEDSnet ETL conventions for the CDM is available in the [PEDSnet CDM V1 ETL Conventions](V1/docs/PEDSnet_CDM_V1_ETL_Conventions.md) file. The most recent versions of these files are also available in MS Word (.docx) format and a Word "DocDiff" is included to highlight the most recent changes (all in the [docs](V1/docs) directory). The PEDSnet CDM V1 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point, but the data definition language files here include all of the OMOP tables. Those tables not documented are still in a draft state.

### ETL Conventions

The PEDSnet ETL conventions are described in the [PEDSnet CDM V1 ETL Conventions](V1/docs/PEDSnet_CDM_V1_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! Find advice and instructions for contributing (or maintaining a separate version with your own annotations) [here](CONTRIBUTING.md).

### Database Dialects

DDL scripts for creating the PEDSnet CDM V1 (and the rest of the OMOP tables, which are in draft state), are available for:

- PostgreSQL at [PEDSnet_CDM_V1_pgsql.ddl](V1/PEDSnet_CDM_V1_pgsql.ddl)
- MySQL at [PEDSnet_CDM_V1_mysql.ddl](V1/PEDSnet_CDM_V1_mysql.ddl)
- Oracle at [PEDSnet_CDM_V1_oracle.ddl](V1/PEDSnet_CDM_V1_oracle.ddl)
- MS SQL Server at [PEDSnet_CDM_V1_mssql.ddl](V1/PEDSnet_CDM_V1_mssql.ddl)

These scripts were generated by creating a declarative representation of the CDM using [SQLAlchemy](http://www.sqlalchemy.org/) syntax and programmatically converting it into dialect-specific DDL. For this reason, the scripts are not yet fully tested. Please report any issues [here](https://github.com/PEDSnet/pedsnetcdms/issues).

DDL for the PEDSnet CDM V1 table and column comments (based on the OMOP CDM V4 comments) are available at [PEDSnet_CDM_V1_comments.ddl](V1/PEDSnet_CDM_V1_comments.ddl). The syntax should work on PostgreSQL and Oracle, but not on MySQL or MS SQL Server.

Since these files were created, the DDL generation code has moved to the [PEDSnet/pedsnetcdms](https://github.com/PEDSnet/pedsnetcdms) repository. Please look there for further work on that process.

### Changes from OMOP CDM V4

#### Field additions and deletions

1. Add `pn_time_of_birth` and `pn_gestational_age` fields to the `person` table.
2. Add `provider_id` field to the `visit_occurrence` table.
3. Change field orders within some tables.

#### Null constraint changes

1. Make `person_source_value` on the `person` table `NOT NULL` for consistency in updates.
2. Make `care_site_source_value` on the `care_site` table `NOT NULL` for consistency in updates.
3. Make `provider_source_value` on the `provider` table `NOT NULL` for consistency in updates.
4. Make `care_site_id` on the `person` table `NOT NULL` for consistency in updates based on organization.
5. Make `organization_source_value` on the `organization` table `NOT NULL` for consistency in updates.
6. Make `visit_end_date` on the `visit_occurrence` table nullable to allow for visits which are ongoing at time of data extraction.

#### Data type changes

1. Increase many `VARCHAR` (or equivalent) max values to allow for more verbose data.
2. Change most primary keys (except on `organization` and `care_site`) from `INTEGER` to `BIGINT` (or equivalent) to accomodate more data.
3. Change foreign keys from `INTEGER` to `BIGINT` (or equivalent) to match the new `BIGINT` primary key data type.
4. Make primary keys auto-incrementing (except in Oracle) to emphasize that the values in those fields should not have any inherent meaning.
5. Interpret `DATE` types as strictly for storing dates without times.

## OMOP Vocabulary V4.5

The PEDSnet CDM concept IDs are taken from OMOP v4.5 vocabularies, using the complete ('restricted') version that includes licensed terminologies such as CPT and others. OMOP Vocabulary V4.5 uses the same DDL as V4. The V4 DDL has been translated into the various DDL dialects and included here for convenience. The V4.5 data in csv format is available for download [here](https://drive.google.com/uc?export=download&id=0Bzgq_ix-rkw7ZFpBR0lYcVk4WUU).

### Database Dialects

- PostgreSQL at [OMOP_Vocabulary_V4_pgsql.ddl](V1/OMOP_Vocabulary_V4_pgsql.ddl)
- MySQL at [OMOP_Vocabulary_V4_mysql.ddl](V1/OMOP_Vocabulary_V4_mysql.ddl)
- Oracle at [OMOP_Vocabulary_V4_oracle.ddl](V1/OMOP_Vocabulary_V4_oracle.ddl)
- MS SQL Server at [OMOP_Vocabulary_V4_mssql.ddl](V1/OMOP_Vocabulary_V4_mssql.ddl)

As for the PEDSnet CDM, these scripts were programmatically generated and are not yet fully tested. Please report any issues [here](https://github.com/PEDSnet/pedsnetcdms/issues).

DDL for the OMOP Vocabulary V4 table and column comments are available at [OMOP_Vocabulary_V4_comments.ddl](V1/OMOP_Vocabulary_V4_comments.ddl). The syntax should work on PostgreSQL and Oracle, but not on MySQL or MS SQL Server.

Since these files were created, the DDL generation code has moved to the [PEDSnet/pedsnetcdms](https://github.com/PEDSnet/pedsnetcdms) repository. Please look there for further work on that process.

### Changes from OMOP Vocabulary V4

The only changes made to the original OMOP Vocabulary V4 DDL were made to support automated DDL generation or because the automated generation process doesn't support some dialect specific feature. These include:

1. Addition of a primary key on the `drug_approval` table using the `ingredient_concept_id` column (SQLAlchemy table defintions require a primary key).
2. Addition of a compound primary key on the `drug_strength` table using the `drug_concept_id`, `ingredient_concept_id`, and `valid_end_date` columns (SQLAlchemy table definitions require a foreign key).
3. Interpretation of `DATE` types as strictly for storing dates without times.
4. Removal of `LOGGING` and `MONITORING` keywords from table definitions and `USING INDEX` and `LOGGING` keywords from primary key constraint definitions in the Oracle DDL.

## Original OMOP files

The original OMOP CDM and Vocabulary V4 specification and DDL files, as well as the Vocabulary V4.5 release notes, are included in [docs](V1/docs) directory for reference.
