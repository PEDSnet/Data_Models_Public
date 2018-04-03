# Differences between PEDSnet CDM 2.8 and CDM 2.9

## Focus for v2.9

Please work on refinging and improving the quality of data for the following domains and fields:

Drug Exposure
1. Frequency
2. Effective Dose

Measurement Organism
1. Specimen Source Value

Provider
1. Provider Specialty

## CHANGES from CDM 2.8.0

#### Updates to the conventions document

1. Correcting concepts for delivery mode. In the v2.8 conventions, the concept code was erroneously noted as the concept id

Delivery Mode | Vocabulary| Incorrect Value | CORRECT VALUE
---|---|---|---
Born by cesarean section|SNOMED|394699000|4192676
Born by elective cesarean section|SNOMED|395682006|4212794
Born by emergency cesarean section|SNOMED|407615002|4250010
Born by normal vaginal delivery|SNOMED|395683001|4216797
Born by forceps delivery|SNOMED|395681004|4217586
Born by ventouse delivery|SNOMED|407614003|4236293
Born by breech delivery|SNOMED|407613009|4250009


***

***
## NEW in PEDSnet CDM2.9 -- Option

#### [1.17 Immunization](Pedsnet_CDM_ETL_Conventions.md#117-immunization-1)
1. This table has been created to inlcude immunization records for persons in the PEDSnet network. Please see the table specification in the ETL Conventions for guidance on how to populate the table.

***
