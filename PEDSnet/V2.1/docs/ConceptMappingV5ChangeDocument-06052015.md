
## Concept Mapping Changes for the V5 OMOP Vocabulary

Table | Column | OLD PEDSNet Convention | NEW PEDSNet Convention
--- | --- | --- | ---
person | gender_concept_id |<ul><li>Ambiguous: concept_id = 8570</li> <li>Female: concept_id = 8532</li> <li>Male: concept_id = 8507</li> <li>No Information: concept_id = 44814667 (Vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 8551</li> <li>Other: concept_id = 8521</li></ul>|<ul><li>Ambiguous: concept_id = 44814664 </li> <li>Female: concept_id = 8532</li> <li>Male: concept_id = 8507</li> <li>No Information: concept_id = 44814650 (Vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653</li> <li>Other: concept_id = 44814649</li></ul>
person | race_concept_id | <ul><li>American Indian/Alaska Native: concept_id = 8657</li> <li>Asian: concept_id = 8515</li> <li>Black or African American: concept_id = 8516</li> <li>Native Hawaiian or Other Pacific Islander: concept_id = 8557</li> <li>White: concept_id = 8527</li> <li>Multiple Race: concept_id = 44814659 (vocabulary_id='PCORNet')</li> <li>Refuse to answer: concept_id = 44814660 (vocabulary_id='PCORNet')</li> <li>No Information: concept_id = 44814661 vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 8552</li> <li>Other: concept_id = 8522</li></ul> |  <ul><li>American Indian/Alaska Native: concept_id = 8657</li> <li>Asian: concept_id = 8515</li> <li>Black or African American: concept_id = 8516</li> <li>Native Hawaiian or Other Pacific Islander: concept_id = 8557</li> <li>White: concept_id = 8527</li> <li>Multiple Race: concept_id = 44814659 (vocabulary_id='PCORNet')</li> <li>Refuse to answer: concept_id = 44814660 (vocabulary_id='PCORNet')</li> <li>No Information: concept_id = 44814650 vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653</li> <li>Other: concept_id = 44814649</li></ul>
care_site | place_of_service_concept_id |<ul><li>Inpatient Hospital Stay: concept_id = 9201</li> <li>Ambulatory Visit: concept_id = 9202</li> <li>Emergency Department: concept_id = 9203</li> <li>Non-Acute Institutional Stay: concept_id = 42898160 (vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814713 (vocabulary_id='PCORNet')</li> <li>Other: concept_id = 44814711 (vocabulary_id='PCORNet')</li> <li>No information: concept_id = 44814712 (vocabulary_id='PCORNet')</li></ul> | <ul><li>Inpatient Hospital Stay: concept_id = 9201</li> <li>Ambulatory Visit: concept_id = 9202</li> <li>Emergency Department: concept_id = 9203</li> <li>Long Term Care Visit = 42898160 </li><li>Other ambulatory Visit = 44814711</li> <li>Non-Acute Institutional Stay: concept_id = 44814710 (vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653 (vocabulary_id='PCORNet')</li> <li>Other: concept_id =  44814649 (vocabulary_id='PCORNet')</li> <li>No information: concept_id =  44814650(vocabulary_id='PCORNet')</li></ul>
provider | gender_concept_id |<ul><li>Ambiguous: concept_id = 8570</li> <li>Female: concept_id = 8532</li> <li>Male: concept_id = 8507</li> <li>No Information: concept_id = 44814667 (Vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 8551</li> <li>Other: concept_id = 8521</li></ul>|<ul><li>Ambiguous: concept_id = 44814664 </li> <li>Female: concept_id = 8532</li> <li>Male: concept_id = 8507</li> <li>No Information: concept_id = 44814650 (Vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653</li> <li>Other: concept_id = 44814649</li></ul>
Visit | visit_concept_id |  <ul><li>Inpatient Hospital Stay: concept_id = 9201</li> <li>Ambulatory Visit: concept_id = 9202</li> <li>Emergency Department: concept_id = 9203</li> <li>Non-Acute Institutional Stay: concept_id = 42898160</li> <li>Unknown: concept_id = 44814713</li> <li>Other: concept_id = 44814711 (vocabulary_id='PCORNet')</li> <li>No information: concept_id = 44814712 (vocabulary_id='PCORNet')</li></ul>| <ul><li>Inpatient Hospital Stay: concept_id = 9201</li> <li>Ambulatory Visit: concept_id = 9202</li> <li>Emergency Department: concept_id = 9203</li> <li>Long Term Care Visit = 42898160 </li><li>Other ambulatory Visit = 44814711</li> <li>Non-Acute Institutional Stay: concept_id = 44814710 (vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653 (vocabulary_id='PCORNet')</li> <li>Other: concept_id =  44814649 (vocabulary_id='PCORNet')</li> <li>No information: concept_id =  44814650(vocabulary_id='PCORNet')</li></ul>|


Concept Mapping changes to the PCORNet observations

**Table 1: Observation concept IDs for PCORnet concepts.**

Concept Name | Observation concept ID | |OLD Value as concept ID | New Value as concept ID| Concept description | Vocab ID
 --- | --- | --- | --- | --- | --- | ---
Admitting source | 4145666 |  | 44814682 | 44814650 | No information | PCORNet
Admitting source | 4145666 |  | 44814683 |44814653 | Unknown | PCORNet
Admitting source | 4145666 | | 44814684 | 44814649 | Other | PCORNet
Discharge disposition | 44813951 | |44814687 | 44814650 | No information | PCORNet
Discharge disposition | 44813951 || 44814688 | 44814653 | Unknown | PCORNet
Discharge disposition | 44813951 || 44814689 | 44814649 | Other | PCORNet
Discharge status | 4137274 | | 44814705 |  44814653 | Unknown | PCORNet
Discharge status | 4137274 | | 44814706 |  44814649 | Other | PCORNet
Discharge status | 4137274 | | 44814704 |  44814650 | No information | PCORNet
Biobank flag | 4001345 | No information| NULL |44814650 | No information  |PCORNet
Biobank flag | 4001345 | Unknown/Other |0| 44814653 | Unknown | PCORNet
Biobank flag | 4001345 | Unknown/Other |0| 44814649 | Other | PCORNet
Chart availability | 4030450 | No information| NULL |44814650 |No information  |PCORNet
Chart availability | 4030450 | Unknown/Other |0| 44814653 | Unknown | PCORNet
Chart availability  | 4030450 |Unknown/Other |0| 44814649 | Other | PCORNet
Tobacco Use |*concept id pending* |No information| NULL |44814650 |No information  |PCORNet
Tobacco Use |*concept id pending* |Unknown/Other |0| 44814653 | Unknown | PCORNet
Tobacco Use |*concept id pending* | Unknown/Other |0| 44814649 | Other | PCORNet
Tobacco Type |*concept id pending* | No information| NULL |44814650 |No information  |PCORNet
Tobacco Type |*concept id pending* |  Unknown/Other |0| 44814653 | Unknown | PCORNet
Tobacco Type |*concept id pending* |Unknown/Other |0| 44814649 | Other | PCORNet
 		 
