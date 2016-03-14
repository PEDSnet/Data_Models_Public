Data_Models
===========

The home for usage standards for the network's data models: PEDSnet/OMOP, PCORnet, and i2b2 for PEDSnet.

The `master` branch may contain changes that do not apply to the latest released PEDSnet version. Always refer to one of the [official releases](https://github.com/PEDSnet/Data_Models/releases).  For convenience, the DCC will maintain an up-to-date list of release branch and ETL document links here:

PEDSnet Release | ETL Conventions Document
--------|--------------------------
[v2.2 branch](https://github.com/PEDSnet/Data_Models/tree/cb2e737268096320719f759d4e100add14c12af7) | [v2.2 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/cb2e737268096320719f759d4e100add14c12af7/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md)
[v2.1 branch](https://github.com/PEDSnet/Data_Models/tree/66e022adf43a119af52b418a5694aaf6160130e8) | [v2.1 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/66e022adf43a119af52b418a5694aaf6160130e8/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md)
[v2.0 branch](https://github.com/PEDSnet/Data_Models/tree/f42aad3819222e91ed30d4ac52db5441542e218b) | [v2.0 ETL Conventions](https://github.com/PEDSnet/Data_Models/blob/f42aad3819222e91ed30d4ac52db5441542e218b/PEDSnet/V2/docs/Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md)

The [data models DDL service](http://data-models-sqlalchemy.research.chop.edu/) generates official network DDL automatically from the authoritative [definitions for the data models](https://github.com/chop-dbhi/data-models).  Of more esoteric interest is the [intermediate models service](http://data-models-service.research.chop.edu/) that serves the model definitions, mostly to other services.
