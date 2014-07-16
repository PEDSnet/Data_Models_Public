ETL Decisions
===================
This is where we will track all decisions and OMOP/i2B2 rules associated with ETL issues.
For each decision, please provide the following information:

1. Issue Domain: 
2. Description of the issue:
3. Issue # (in GitHub):
4. Decision:
5. OMOP Rule:
6. i2B2 Rule:
7. Completion date (if needed):

*Please use headers with each issue so they are easier to read.  
*Here is a [link](https://help.github.com/articles/markdown-basics) to markdown basics, (i.e. how to format text, create headers, etc.
*Copy and paste the item labels 1-7 from above to fill in information.


##Gender Mapping
1. Issue Domain: Demographics
2. Description of the issue: How is Gender being mapped in all CDMs? PCORnet's CDM allows for multiple NULL values, none of which match current i2b2 or OMOP.
3. Issue # (in GitHub): [#6](https://github.com/PEDSnet/Data_Models/issues/6)
4. Decision:All valid concept IDs will be added in OMOP and i2B2 to match PCORnet CDM. A mapping will be generated from i2B2 to OMOP (with appropriate table with the following elements: OMOP_SOURCE_TABLE OMOP_SOURCE_COLUMN OMOP_COLUMN_VALUE I2B2_CONCEPT_CODE I2B2_CONCEPT_PATH).
5. OMOP Rule: All valid concept IDs will be added in OMOP. [Reference to OMOP CDM is here](https://github.com/PEDSnet/Data_Models/blob/master/OMOP/OMOP_CDM_V4.0.DDL#L283-313)
6. i2B2 Rule: All valid concept IDs will be added in i2B2.  A mapping will be generated from i2b2 to OMOP.
7. Completion date (if needed): 6/30/14

Field Name | Data Type | Predefined value set | Definition & comments | Source |
---------- | --------- | -------------------- | --------------------- | ------ |
SEX | TEXT(2) | A=Ambiguous F=Female M=Male NI=No Information UN=Unknown OT=Other | Administrative Sex | MSCDM with modified field size and value set Source: Administrative Sex (HL7) |


##Ethnicity - Hispanic
1. Issue Domain: Demographics
2. Description of the issue: How is Hispanic ethnicity being defined? (i.e. Cuban, Mexican, Puerto Rican, Central American, or other Spanish Culture/origin, regardless of race)
3. Issue # (in GitHub): [#7](https://github.com/PEDSnet/Data_Models/issues/7)
4. Decision: Keep source data, but PCORnet CDM is "Hispanic or Latino" or "Non-Hispanic or Latino", with the same missing values as normal.
*Hispanic = A person of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regarless of race
5. OMOP Rule: Adhere to PCORnet CDM (see below) [Reference to OMOP CDM is here](https://github.com/PEDSnet/Data_Models/blob/master/OMOP/OMOP_CDM_V4.0.DDL#L283-313)
6. i2B2 Rule: Adhere to PCORnet CDM (see below)
7. Completion date (if needed): 6/30/14

Field Name | Data Type | Predefined value set | Definitions & comments | Source |
---------- | --------- | -------------------- | ---------------------- | ------ |
HISPANIC | TEXT(2) | Y=Yes N=No NI=No Information UN=Unknown OT=Other | A person of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race | MSCDM with modified field size and value set; Compatible with "OMB Hispanic Ethnicity" (Hispanic or Latino, Not Hispanic or Latino) |

##Race - Multiple races
1. Issue Domain: Demographics
2. Description of the issue: This issue involves patients with multiple races/biracial patients.  How are multiple races being handled?  
3. Issue # (in GitHub): [#8](https://github.com/PEDSnet/Data_Models/issues/8)
4. Decision: Race is a single concept across OMOP, i2b2, and PCORnet CDM, meaning there is only one race slot.
*If there are multiple races in the source system:*
*Concatenate all races into one source value (code as "Multiple race")
*Include any code that appears more than two or more times (unless there is only have one visit)
5. OMOP Rule: Follow decision as is above [Reference to OMOP CDM is here](https://github.com/PEDSnet/Data_Models/blob/master/OMOP/OMOP_CDM_V4.0.DDL#L283-L313)
6. i2B2 Rule: Follow decision as is above
7. Completion date (if needed): 6/30/14

Field Name | Data Type | Predefined value set | Definitions & comments | Source |
---------- | --------- | -------------------- | ---------------------- | ------ |
RACE | TEXT(2) | 1=American Indian/Alaska Native 2=Asian 3=Black or African American 4=Native Hawaiian or Other Pacific Islander 5=White **6=Multiple Race** 7=Refuse to answer NI=No Information UN=Unknown OT=Other | Details of categorical definitions: <li>**American Indian or Alaska Native**: A person having origins in any of the original peoples of North and South America (including Central America), and who maintains tribal affiliation or community attachment. </li>  <li>**Asian**: A person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam. </li> <li>**Black or African American**: A person having origins in any of the black racial groups of Africa.</li> <li>  **Native Hawaiian or Other Pacific Islander**: A person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands.</li> <li>  **White**: A person having origins in any of the original peoples of Europe, the Middle East, or North Africa. | MSCDM with modified field size and value set.  Original value set is based upon U.S. Office of Management and Budget (OMB) standard, and is compatible with the 2010 U.S. Census </li> |

