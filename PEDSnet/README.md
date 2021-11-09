## PEDSnet CDM V4.4

The PEDSnet common data model version 4.4 is an update to version 4.3 and includes addtional data elements developed as a part of the network's response to [COVID-19](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md). A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V4.4 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.4_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V4.4 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 4.4

The PEDSnet ETL conventions are described in the [PEDSnet CDM V4.4 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.4_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 4.3

Please see the applicable change document for changes and additions for the v4.4 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/PEDSnet_CDM4.3_CDM4.4_diff.md)

## Site Responsibility for Version 4.4

### Stable Identifiers

For PEDSNet CDMv4.4, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id`, `provider_id` and `care_site_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. `Care_site_id` was added as a stable requirement in November 2020. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id`, `provider_id` and `care_site_id` values to the same person, visit, provider and care site entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 4.4.0` as arguments when running the validator. 

## Reference Materials for Version 4.4

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.4.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.4.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.4.0/ddl/mssql/)

### Vocabulary Data

- v4.4.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.

***
***
***

## PEDSnet CDM V4.3

The PEDSnet common data model version 4.3 is an update to version 4.2 and includes addtional data elements developed as a part of the network's response to [COVID-19](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md). A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V4.3 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.3_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V4.3 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 4.3

The PEDSnet ETL conventions are described in the [PEDSnet CDM V4.3 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.3_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 4.2

Please see the applicable change document for changes and additions for the v4.3 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/PEDSnet_CDM4.2_CDM4.3_diff.md)

## Site Responsibility for Version 4.3

### Stable Identifiers

For PEDSNet CDMv4.3, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id`, `provider_id` and `care_site_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. `Care_site_id` was added as a stable requirement in November 2020. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id`, `provider_id` and `care_site_id` values to the same person, visit, provider and care site entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 4.3.0` as arguments when running the validator. 

## Reference Materials for Version 4.3

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.3.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.3.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.3.0/ddl/mssql/)

### Vocabulary Data

- v4.3.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.

***
***
***
## PEDSnet CDM V4.2

The PEDSnet common data model version 4.2 is an update to version 4.1 and includes addtional data elements developed as a part of the network's response to [COVID-19](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md). A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V4.2 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.2_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V4.2 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 4.2

The PEDSnet ETL conventions are described in the [PEDSnet CDM V4.2 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.2_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 4.1

Please see the applicable change document for changes and additions for the v4.2 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/PEDSnet_CDM4.1_CDM4.2_diff.md)

## Site Responsibility for Version 4.2

### Stable Identifiers

For PEDSNet CDMv4.2, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id`, `provider_id` and `care_site_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. `Care_site_id` was added as a stable requirement in November 2020. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id`, `provider_id` and `care_site_id` values to the same person, visit, provider and care site entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 4.2.0` as arguments when running the validator. 

## Reference Materials for Version 4.2

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.2.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.2.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.2.0/ddl/mssql/)

### Vocabulary Data

- v4.2.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.

***
***
***
## PEDSnet CDM V4.1

The PEDSnet common data model version 4.1 is an update to version 4.0 and includes addtional data elements developed as a part of the network's response to [COVID-19](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md). A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V4.1 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.1_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V4.1 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 4.1

The PEDSnet ETL conventions are described in the [PEDSnet CDM V4.1 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.1_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 4.0

Please see the applicable change document for changes and additions for the v4.1 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/PEDSnet_CDM4.0_CDM4.1_diff.md)

## Site Responsibility for Version 4.1

### Stable Identifiers

For PEDSNet CDMv4.1, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id`, `provider_id` and `care_site_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. `Care_site_id` was added as a stable requirement in November 2020. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id`, `provider_id` and `care_site_id` values to the same person, visit, provider and care site entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 4.1.0` as arguments when running the validator. 

## Reference Materials for Version 4.1

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.1.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.1.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.1.0/ddl/mssql/)

### Vocabulary Data

- v4.1.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.

***
***
***
## PEDSnet CDM V4.0

The PEDSnet common data model version 4.0 is an update to version 3.9 and includes addtional data elements developed as a part of the network's response to [COVID-19](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md). A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V4.0 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.0_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V4.0 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 4.0

The PEDSnet ETL conventions are described in the [PEDSnet CDM V4.0 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.0_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 3.9

Please see the applicable change document for changes and additions for the v4.0 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM3.9_CDM4.0_diff.md)

## Site Responsibility for Version 4.0

### Stable Identifiers

For PEDSNet CDMv4.0, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id`, `provider_id` and `care_site_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. `Care_site_id` was added as a stable requirement in November 2020. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id`, `provider_id` and `care_site_id` values to the same person, visit, provider and care site entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 4.0.0` as arguments when running the validator. 

## Reference Materials for Version 4.0

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.0.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.0.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/4.0.0/ddl/mssql/)

### Vocabulary Data

- v4.0.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.

***
***
***
## PEDSnet CDM V3.9

The PEDSnet common data model version 3.9 is an update to version 3.8 and includes addtional data elements developed as a part of the network's response to [COVID-19](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md). A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.9 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.9_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.9 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.9

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.9 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.9_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 3.8

Please see the applicable change document for changes and additions for the v3.9 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM3.8_CDM3.9_diff.md)

## Site Responsibility for Version 3.9

### Stable Identifiers

For PEDSNet CDMv3.9, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 3.9.0` as arguments when running the validator. 

## Reference Materials for Version 3.9

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.9.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.9.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.9.0/ddl/mssql/)

### Vocabulary Data

- v3.9.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.

***
***
***

## PEDSnet CDM V3.8

The PEDSnet common data model version 3.8 is an update to version 3.7 and includes addtional data elements developed as a part of the network's response to [COVID-19](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md). A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.8 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.8_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.8 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.8

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.8 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.8_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 3.7

Please see the applicable change document for changes and additions for the v3.8 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM3.7_CDM3.8_diff.md)

## Site Responsibility for Version 3.8

### Stable Identifiers

For PEDSNet CDMv3.8, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 3.8.0` as arguments when running the validator. 

## Reference Materials for Version 3.8

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.8.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.8.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.8.0/ddl/mssql/)

### Vocabulary Data

- v3.8.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.
***
***
***

## COVID-19 ETL

PEDSnet has committed to a rapid response that creates the data substrate for COVID-19 analyses and for pragmatic research, and that builds a pediatric research effort to complement current efforts in basic and adult clinical domains.

### ETL Conventions 
For ETL Guidance, please use the documentation [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md).

### Vocabulary Data
There has been a speical release to the vocabulary as a result of new standards and terms. Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.

***
***
***

## PEDSnet CDM V3.7

The PEDSnet common data model version 3.7 is an update to version 3.6. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.7 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.7_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.7 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.7

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.7 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.7_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 3.6

Please see the applicable change document for changes and additions for the v3.7 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM3.6_CDM3.7_diff.md)

## Site Responsibility for Version 3.7

### Stable Identifiers

For PEDSNet CDMv3.7, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 3.7.0` as arguments when running the validator. 

## Reference Materials for Version 3.7

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.7.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.7.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.7.0/ddl/mssql/)

### Vocabulary Data

- v3.7.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***

## PEDSnet CDM V3.6

The PEDSnet common data model version 3.6 is an update to version 3.5. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.6 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.6_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.6 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.6

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.6 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.6_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing! 

### Changes from Version 3.5

Please see the applicable change document for changes and additions for the v3.6 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM3.5_CDM3.6_diff.md)

## Site Responsibility for Version 3.6

### Stable Identifiers

For PEDSNet CDMv3.6, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 3.6.0` as arguments when running the validator. 

## Reference Materials for Version 3.6

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.6.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.6.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.6.0/ddl/mssql/)

### Vocabulary Data

- v3.6.0 Core Vocabulary: lease contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
## PEDSnet CDM V3.5

The PEDSnet common data model version 3.5 is an update to version 3.4. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.5 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.5_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.5 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.5

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.5 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.5_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing!

### Changes from Version 3.4

Please see the applicable change document for changes and additions for the v3.5 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM3.4_CDM3.5_diff.md)

## Site Responsibility for Version 3.5

### Stable Identifiers

For PEDSNet CDMv3.5, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 3.5.0` as arguments when running the validator. 

## Reference Materials for Version 3.5

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.5.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.5.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.5.0/ddl/mssql/)

### Vocabulary Data

- v3.5.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
## PEDSnet CDM V3.4

The PEDSnet common data model version 3.4 is an update to version 3.3. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.4 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.4_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.4 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.4

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.4 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.4_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models/issues). Please also consider contributing! 

### Changes from Version 3.3

Please see the applicable change document for changes and additions for the v3.4 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM3.3_CDM3.4_diff.md)

## Site Responsibility for Version 3.4

### Stable Identifiers

For PEDSNet CDMv3.4, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 3.4.0` as arguments when running the validator. 

## Reference Materials for Version 3.4

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.4.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.4.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.4.0/ddl/mssql/)

### Vocabulary Data

- v3.4.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
## PEDSnet CDM V3.3

The PEDSnet common data model version 3.3 is an update to version 3.2. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.3 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.3_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.3 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.2

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.3 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.3_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 3.3

Please see the applicable change document for changes and additions for the v3.3 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM3.2_CDM3.3_diff.md)

## Site Responsibility for Version 3.3

### Stable Identifiers

For PEDSNet CDMv3.3, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 3.3.0` as arguments when running the validator. 

## Reference Materials for Version 3.3

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.3.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.3.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.3.0/ddl/mssql/)

### Vocabulary Data

- v3.3.1 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
## PEDSnet CDM V3.2

The PEDSnet common data model version 3.2 is an update to version 3.0. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.2 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.2_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.2 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.2

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.2 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.2_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 3.1

Please see the applicable change document for changes and additions for the v3.2 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM3.1_CDM3.2_diff.md)

## Site Responsibility for Version 3.2

### Stable Identifiers

For PEDSNet CDMv3.2, sites are responsible for creating and storing a mapping from both `person_id`,`visit_occurrence_id` and `provider_id` to stable local identifiers. These `person_id` , `visit_occurrence_id` and `provider_id` values **DO NOT** need to be consistent with the values from data transmissions prior to Nov 2015. However, they **DO** have to remain consistent from February 2016 onward. This means that for future data cycles, sites will need to reference the mappings in order to assign the same `person_id`, `visit_occurrence_id` and `provider_id` values to the same person, visit and provider entities. The mappings should not be sent to the DCC.

### Data Validation

Sites are responsible for using the data validation tool on all CSV files before sending them to the DCC. You can download the tool [here](https://github.com/chop-dbhi/data-models-validator/releases/tag/1.0.0) and read about its usage and see sample output [here](https://github.com/chop-dbhi/data-models-validator). This should help to reduce data cycle time by allowing sites to fix most data formatting and type errors before transmission to the DCC.

To verify PEDSnet-format data, use `-model pedsnet` and `-version 3.2.0` as arguments when running the validator. 

## Reference Materials for Version 3.2

### Data Model DDL

- Postgres: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.2.0/ddl/postgresql/)
- Oracle: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.2.0/ddl/oracle/)
- Microsoft SQL Server: [here](https://data-models-sqlalchemy.research.chop.edu/pedsnet/3.2.0/ddl/mssql/)

### Vocabulary Data

- v3.2.1 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
## PEDSnet CDM V3.1

The PEDSnet common data model version 3.1 is an update to version 3.0. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.1 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.1_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.1 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.1

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.1 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.1_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing! 

### Changes from Version 3.0

Please see the applicable change document for changes and additions for the v3.1 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM3.0_CDM3.1_diff.md)

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

- v3.1.0 Core Vocabulary: Please contact the DCC for more information.

If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
## PEDSnet CDM V3.0

The PEDSnet common data model version 3.0 is an update to version 2.9. A full description of the data model and the ETL Conventions is available in the [PEDSnet CDM V3.0 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.0_PEDSnet_CDM_ETL_Conventions.md) file. The PEDSnet CDM V3.0 documentation covers the tables from OMOP which have been part of PEDSnet operation up to this point,including custom tables and columns but the data definition language files include all of the OMOP tables.

### ETL Conventions for Version 3.0

The PEDSnet ETL conventions are described in the [PEDSnet CDM V3.0 ETL Conventions](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v3.0_PEDSnet_CDM_ETL_Conventions.md) file and should be followed as much as possible when extracting data from source systems into the PEDSnet CDM, in order to improve data quality and consistency across the network. These conventions were developed collaboratively and represent the best solutions for existing use cases across PEDSnet, but are still works-in-progress. Please submit any comments [here](https://github.com/PEDSnet/Data_Models_Public/issues). Please also consider contributing!

### Changes from Version 2.9

Please see the applicable change document for changes and additions for the v3.0 data model [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Change%20Documents/Pedsnet_CDM2.9_CDM3.0_diff.md)

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

- v3.0.0 Core Vocabulary: Please contact the DCC for more information.


If you have any questions, please do not hesitate to email pedsnetdcc@email.chop.edu.


***
***
***
