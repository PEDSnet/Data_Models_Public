# CDM Ventilator Pilot

## Overview

This project aims to develop the necessary common data model elements to describe mechanical ventilation over time in children with long-term mechanical ventilation dependence. Care for these patients spans inpatient and outpatient context, with multiple unique devices, ventilator modes, interfaces, and settings. These CDM changes will facilitate description of mechanical ventilation in this population but can be applied to children in any context in the health system and for most acute or chronic conditions where mechanical ventilation is required.

We are specifically aiming to describe ventilator weaning over time in this population and so in addition to mechanical ventilation parameters, are also interested in time off of the ventilator each day.  

There are substantial differences in devices, modes of ventilation, and data entry processes within sites and between sites and so we propose piloting these CDM changes at 2 sites and revising approach based on lessons learned in this pilot.

#### Participating Sites

This pilot will involve the following participating sites:
- CCHMC
- CHCO

## CDM Tables

There are several CDM Tables where data will be stored related to ventilator utilization and settings in the PEDSnet Model. 

The tables are listed below:

- [Device Exposure](#device-exposure)
- [Observation](#observation)
- [Measurement](#measurement)
- [Fact Relationship](#fact-relationship)

## Device Exposure

#### Device Mapping

The `Device_Exposure` table is currently being used to store information related to ventilator utilization to allow us to derive a dichtomous variable to understand who received ventilator care versus who did not receive ventilator care. In the current implementation the use of ventilator and the interface type (non-invasive and invasive) is stored at the same time. In this pilot, the use of the ventilator will be documented in the `device_exposure` table and settings/ characteristics like the interface type will be documented in other tables.

For this pilot, please use the following as guide for how to populate Ventilators in the Device Exposure Table: 

Device Name| Device Concept ID|Device Concept Name| unique_device_id
---|--|---|---
Trilogy 100|45759002|Portable electric ventilator|00606959015364 
Trilogy 200|45759002|Portable electric ventilator|00606959022737
Servo-U|45764072|Neonatal/adult intensive-care ventilator|07325710001110
Servo-i|45764072|Neonatal/adult intensive-care ventilator|07325710000823
LTV 1150|45764253|Transport electric ventilator|00845873002726
LTV 1200|45764253|Transport electric ventilator|00845873000913
Trilogy EV300|45759002|Portable electric ventilator|00606959052017
Trilogy Evo|45759002|Portable electric ventilator|00606959061026
VOCSN|45759002|Portable electric ventilator|00850018761161
Astral 150|45759002|Portable electric ventilator|00619498270033
Vivo 65|45759002|Portable electric ventilator|07321822240003
Vivo 45|45759002|Portable electric ventilator|07321822300004
Drager V500|45764072|Neonatal/adult intensive-care ventilator|04048675042266 


For other devices, the National Library of Medicine (NLM) [Global Unique Device Identification Database(GUDID)](https://accessgudid.nlm.nih.gov) can be used to identify the Global Medical Device Nomenclature (GMDN) that maps to a SNOMED concept in the `Device` Vocabulary.

## Observation

The `Observation` table will be used to store ventilator settings associated with devices in the `Device_Exposure` table. Each ventilator setting has a unique `observation_concept_id` and the `value_as_concept_id` field will be used to note the ***taxonomy*** in use for the ventilator setting. 

#### Value as Concept Mapping - Taxonomy

Please use the `Cleveland Clinic Ventilator Mode Map` taxonomy look up to determine the appropirate taxonomy in use at your site. Please contact the Nate Pajor [(nathan.pajor@cchmc.org)](nathan.pajor@cchmc.org) if you require assistance identifying the taxonomy in use. The valueset is as follows:

Concept_Id|Taxonomy Tag|Examples of Ventilator Modes
---|---|---
2000001499|PC-IMV(1)s,s| `PC SIMV`, `BiVent`
2000001500|PC-IMV(2)a,a|`S/T + AVAPS`
2000001504|PC-CMVa|`PC + AVAPS`
2000001505|PC-CSVa|`S + AVAPS`
2000001506|PC-IMV(1)a,s|`T + AVAPS`, `SIMV PRVC`
2000001507|VC-IMV(1)s,s|`VC SIMV`
2000001508|PC-CSVs|`CPAP + PS`
2000001509|PC-CMVa|`PRVC`
2000001510|PC-CMVs|`PC`
2000001511|VC-CMVs|`VC`

**Table 1** in the conventions for the `Observation` table has been updated to include the following concepts as guidance for populating ventilator settings.

**Table 1: Valid Observation concept IDs and Value as concept IDs for PEDSNet v4.5.** 

Concept Name | Observation concept ID | Vocab ID | Value as concept ID | Concept description | Vocab ID| PCORNet Mapping
 --- | --- | --- | --- | --- | ---| ---
Device Interface |2000001495|PEDSnet | See note for Taxonomy in CDM Vent Pilot Guidance | | |
Ventilation Mode |2000001496|PEDSnet | See note for Taxonomy in CDM Vent Pilot Guidance | | |
Ventilator Rate |4108138 |SNOMED | See note for Taxonomy in CDM Vent Pilot Guidance | | |
Inspiratory Pressure |4215838  |SNOMED | See note for Taxonomy in CDM Vent Pilot Guidance | | |
Tidal volume setting  |4220163   |SNOMED | See note for Taxonomy in CDM Vent Pilot Guidance | | |
PEEP setting |4216746   |SNOMED | See note for Taxonomy in CDM Vent Pilot Guidance | | |
Inspiratory time  |4353947    |SNOMED | See note for Taxonomy in CDM Vent Pilot Guidance | | |
Time off vent per day |2000001497 |PEDSnet | See note for Taxonomy in CDM Vent Pilot Guidance | | |

## Measurement

The `Measurement` table will be used to store measured values associated with the ventilator devices stored in the `Device_Exposure` table.

**Table 3** in the conventions for the `Measurement` table has been updated to include the following concepts as guidance for populating measured values associated with ventilator .

**Table 3: Measurement concept IDs for PEDSnet Concepts.**

Domain id|	Measurement concept ID|	Vocab ID|	Value as concept ID	|Concept description|	Vocab ID
---|---|---|---|---|---
Vital|	4101694 	|	See Note 1	||Peak inspiratory pressure| SNOMED
Vital|	44782827 |		See Note 1|	|Expiratory tidal volume| SNOMED	


## Fact Relationship

The `fact_relationship` table is intended to link devices, ventilator settings and measured ventilator values together. Please use the following as guide on how to link records:

#### Settings

For settings stored in the observation table, the following relationships should be used:

Relationship Concept Id|Relationship Concept Name
---|---
32462|Has Setting
32463| Setting Of

#### Measured Values

For measured values stored in the measurement table, the following relationship should be used:

Relationship Concept Id|Relationship Concept Name
---|---
44818792 |Associated with Finding

## Examples

Please see below an example on how data is populated given the guidance for this pilot based on a patient care scenario:

### **Example 1:** Person_id = 123456 on visit_occurrence_id = 78910 was placed on a ventilator in the healthcare delivery setting.

Variable| Source Value
---|---
Ventilator | Trilogy 100
Device Interface | Tracheostomy
Ventilation Mode | PC SIMV
Ventilator Rate| 10 (breaths/min) 
Inspiratory Pressure | 20 (cm H2O)
Tidal volume setting  | 	N/A
PEEP setting | 6 (cm H2O)
Inspiratory time  | 0.8 (s)
Time off vent per day | 4 (hrs/day)
Peak inspiratory pressure| 20 (cm H2O)
Expiratory tidal volume| 95 (mL)

- Based on the Ventilaton Mode, the Mode Tag from the Taxonomy is `PC-IMV(1)s,s`

#### CDM Table Implementation

- One (1) row will be inserted into the `Device_exposure` table. Showing only the relevant columns:

Device_Exposure_id | Person_id | Visit_occurrence_id | device_concept_id | device_type_concept_id |unique_device_id
 --- | --- | --- | --- | --- | --- 
2302 | 123456 | 78910 | 45759002 | 44818707| 00606959015364 

- Two (2) rows will be inserted into the `Measurement` table. Showing only the relevant columns:

Measurement_id | Person_id | Visit_occurrence_id | Measurement_concept_id | Measurement_type_concept_id | Value_as_Number | Value_as_Concept_ID| Unit_Concept_ID
 --- | --- | --- | --- | --- | --- | ---|---
234325 | 123456 | 78910 | 4101694 | 2000000033| 20| | |4212222
239045 | 123456 | 78910 | 44782827 | 2000000033 |95 | | |8587

- Seven (7) rows will be inserted into the `Observation` table. Showing only the relevant columns:

Observation_id | Person_id | Visit_occurrence_id |Observation_type_concept_id |Observation_concept_id| Value_as_Number | Value_as_string|Value_as_Concept_ID| Unit_Concept_ID
 --- | --- | --- | --- | --- | --- | ---|---|---
652349 | 123456 | 78910  | 38000280| 2000001495 ||Tracheostomy| 2000001499||
653643 | 123456 | 78910 | 38000280 |  2000001496 ||PC SIMV|2000001499||
642563 | 123456 |  78910  |38000280 | 4108138 |10|10 (breaths/min) |2000001499|4117833
642464 | 123456 |  78910  | 38000280 | 4215838 |20|20 (cm H2O)|2000001499|4215838
642462 | 123456 |  78910 |  38000280 | 4216746 |6|6 (cm H2O)|2000001499|4212222
642469 | 123456 |  78910 |  38000280 | 4353947 |0.8|0.8 (s)|2000001499|4121007
642489 | 123456 |  78910 |  38000280 | 2000001497|4|4 (hrs/day)|2000001499|8505

To link these these values, use the fact relationship table:


Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
Device | 2302 | Measurement | 234325 |  Asso with finding 
Device | 2302 | Measurement | 239045 |  Asso with finding 
Measurement |  234325 | Device | 2302 |  Asso with finding 
Measurement | 239045 | Device | 2302 |  Asso with finding 
Device | 2302 |Observation|652349| Has Setting
Device | 2302 |Observation|653643| Has Setting
Device | 2302 |Observation|642563| Has Setting
Device | 2302 |Observation|642464|Has Setting
Device | 2302 |Observation|642462|Has Setting
Device | 2302 |Observation|642469| Has Setting
Device | 2302 |Observation|642489|Has Setting
Observation|652349|Device|2302| Setting Of
Observation|653643|Device|2302| Setting Of
Observation|642464|Device|2302| Setting Of
Observation|642462|Device|2302| Setting Of
Observation|642469|Device|2302| Setting Of
Observation|642489|Device|2302| Setting Of
Observation|642563|Device|2302| Setting Of


Because the domain concept id and relationship concept id are integers the following is an example of how this data will be represented:

Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
17 | 2302 | 21 | 234325 |  44818792
17 | 2302 | 21 | 239045 |  44818792
21 |  234325 | 17 | 2302 | 44818792
21 | 239045 |17 | 2302 |  44818792
17 | 2302 |27|652349| 32462
17 | 2302 |27|653643| 32462
17 | 2302 |27|642563| 32462
17 | 2302 |27|642464|32462
17 | 2302 |27|642462|32462
17 | 2302 |27|642469| 32462
17 | 2302 |27|642489|32462
27|652349|17|2302| 32463
27|653643|17|2302| 32463
27|642464|17|2302|32463
27|642462|17|2302| 32463
27|642469|17|2302| 32463
27|642489|17|2302| 32463
27|642563|17|2302| 32463

### **Example 2:** Person_id = 435678 on visit_occurrence_id = 3567 was placed on a ventilator in the healthcare delivery setting.

Variable| Source Value
---|---
Ventilator | Trilogy 100
Device Interface | Tracheostomy
Ventilation Mode | S/T + AVAPS
Ventilator Rate| 10 (breaths/min) 
Inspiratory Pressure | N/A
Tidal volume setting  | 	100 (mL)
PEEP setting | 6 (cm H2O)
Inspiratory time  | 0.8 (s)
Time off vent per day | 4 (hrs/day)
Peak inspiratory pressure| 18 (cm H2O)
Expiratory tidal volume| 95 (mL)

- Based on the Ventilaton Mode, the Mode Tag from the Taxonomy is `PC-IMV(2)a,a`

#### CDM Table Implementation

- One (1) row will be inserted into the `Device_exposure` table. Showing only the relevant columns:

Device_Exposure_id | Person_id | Visit_occurrence_id | device_concept_id | device_type_concept_id |unique_device_id
 --- | --- | --- | --- | --- | --- | 
2303 | 435678 | 3567  | 45759002 | 44818707|00606959015364 

- Two (2) rows will be inserted into the `Measurement` table. Showing only the relevant columns:

Measurement_id | Person_id | Visit_occurrence_id | Measurement_concept_id | Measurement_type_concept_id | Value_as_Number | Value_as_Concept_ID| Unit_Concept_ID
 --- | --- | --- | --- | --- | --- | ---|---
234326 | 435678 | 3567 | 4101694 | 2000000033| 18| | |4212222
239046 | 435678 | 3567 | 44782827 | 2000000033 |95 | | |8587

- Seven (7) rows will be inserted into the `Observation` table. Showing only the relevant columns:

Observation_id | Person_id | Visit_occurrence_id |Observation_type_concept_id |Observation_concept_id| Value_as_Number | Value_as_string|Value_as_Concept_ID| Unit_Concept_ID
 --- | --- | --- | --- | --- | --- | ---|---|---
152349 |  435678 | 3567  | 38000280| 2000001495 ||Tracheostomy| 2000001500||
153643 |  435678 | 3567| 38000280 |  2000001496 ||PC SIMV|2000001500||
142563 |  435678 | 3567  |38000280 | 4108138 |10|10 (breaths/min) |2000001500|4117833
142463 |  435678 | 3567 |  38000280 | 4220163 |10|100 (mL)|2000001500|8587
142462 |  435678 | 3567 |  38000280 | 4216746 |6|6 (cm H2O)|2000001500|4212222
142469 |  435678 | 3567 |  38000280 | 4353947 |0.8|0.8 (s)|20000015009|4121007
142489 |  435678 | 3567 |  38000280 | 2000001497|4|4 (hrs/day)|2000001500|8505

To link these these values, use the fact relationship table:


Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
Device | 2303 | Measurement | 234326 |  Asso with finding 
Device | 2303 | Measurement | 239046 |  Asso with finding 
Measurement |  234326 | Device | 2303 |  Asso with finding 
Measurement | 239046 | Device | 2303 |  Asso with finding 
Device | 2303 |Observation|152349| Has Setting
Device | 2303 |Observation|153643| Has Setting
Device | 2303 |Observation|142563| Has Setting
Device | 2303 |Observation|142463| Has Setting
Device | 2303 |Observation|142462|Has Setting
Device | 2303 |Observation|142469| Has Setting
Device | 2303 |Observation|142489|Has Setting
Observation|152349|Device|2303| Setting Of
Observation|153643|Device|2303| Setting Of
Observation|142464|Device|2303| Setting Of
Observation|142463|Device|2303| Setting Of
Observation|142462|Device|2303| Setting Of
Observation|142469|Device|2303| Setting Of
Observation|142489|Device|2303| Setting Of
Observation|142563|Device|2303| Setting Of


Because the domain concept id and relationship concept id are integers the following is an example of how this data will be represented:

Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
17 | 2303 | 21 | 234326 |  44818792
17 | 2303 | 21 | 239046 |  44818792
21 |  234326 | 17 | 2303 | 44818792
21 | 239046 |17 | 2303 |  44818792
17 | 2303 |27|152349| 32462
17 | 2303 |27|153643| 32462
17 | 2303 |27|142563| 32462
17 | 2303 |27|142463| 32462
17 | 2303 |27|142462|32462
17 | 2303 |27|142469| 32462
17 | 2303 |27|142489|32462
27|152349|17|2303| 32463
27|153643|17|2303| 32463
27|142463|17|2303| 32463
27|142462|17|2303| 32463
27|142469|17|2303| 32463
27|142489|17|2303| 32463
27|142563|17|2303| 32463
