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
---------- | --------- | -------------------- | ------------------------------------------------------------- | ------ |
RACE | TEXT(2) | 1=American Indian/Alaska Native 2=Asian 3=Black or African American 4=Native Hawaiian or Other Pacific Islander 5=White **6=Multiple Race** 7=Refuse to answer NI=No Information UN=Unknown OT=Other | Details of categorical definitions: <li>**American Indian or Alaska Native**: A person having origins in any of the original peoples of North and South America (including Central America), and who maintains tribal affiliation or community attachment. </li>  <li>**Asian**: A person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam. </li> <li>**Black or African American**: A person having origins in any of the black racial groups of Africa.</li> <li>  **Native Hawaiian or Other Pacific Islander**: A person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands.</li> <li>  **White**: A person having origins in any of the original peoples of Europe, the Middle East, or North Africa. | MSCDM with modified field size and value set.  Original value set is based upon U.S. Office of Management and Budget (OMB) standard, and is compatible with the 2010 U.S. Census </li> 


##Nullibility field in OMOP CDM
1. Issue Domain: All
2. Description of the issue: All fields are currently nullable.  Two suggestions: Fields neede for natural keys on data loading should not be nullable, Character fields should use empty string instead of null, unless there is a good reason to consider the empty string having some mean distinguishable from null
3. Issue # (in GitHub): [#10](https://github.com/PEDSnet/Data_Models/issues/10)
4. Decision: We will require all sites to always insert a value.  In the presence of a missing value, you must insert one of the four "NULLS" as outlined in the PCORnet CDM:

| Null Name | Definition of each field | 
| ---------- | -------------------------------------------------------------------------------------------------------- |
| NULL | A data field is not present in the source system |
| NI = No Information | A data field is present in the source system, but the source value is null or blank |
| UN = Unknown | A data field is present in the source system , but the source value explicityly denotes an unknown value |
| OT = Other | A data field is present in the source system, but the source value cannot be mapped to the CDM |

5. OMOP Rule: Follow PCORnet CDM as specified above
6. i2B2 Rule: Follow PCORnet CDM as specified above
7. Completion date (if needed): 7/23/14


##Birth Date
1. Issue Domain: Demographics
2. Description of the issue: This issue concerns date shifting for birthdate (and other dates).  How do we best accomplish date shifting to not have PHI, but still allow birth_date for year, month, day?
3. Issue # (in GitHub): [#11](https://github.com/PEDSnet/Data_Models/issues/11)
4. Decision: We will keep all accurate/real dates for now (unshifted), then we will deal with how to release them later.
5. OMOP Rule: N/A
6. i2B2 Rule: N/A
7. Completion date (if needed): 7/23/14


##Observation Period
1. Issue Domain: Enrollment
2. Description of the issue: How do we determine Start/Stop dates and gap intervals for observation period?
3. Issue # (in GitHub): [#12](https://github.com/PEDSnet/Data_Models/issues/12)
4. Decision: Use Minimum/Maximum for observation period, using any information available to you.  We will update the ETL later when a more sophisticated algorithm for enrollment period is complete.
5. OMOP Rule: N/A
6. i2B2 Rule: N/A
7. Completion date (if needed): 7/23/14


##Reason for Visit
1. Issue Domain: Enrollment
2. Description of the issue: What should be done with the reason for visit variable (pat-enc-rsn-visit)?  
3. Issue # (in GitHub): [#13](https://github.com/PEDSnet/Data_Models/issues/13)
4. Decision: 'Reason for visit' is not mapped to a concept id in the PCORnet CDM, therefore this is an optional data point.  Because this is an optional data field, you _do not_ have to extract it.
5. OMOP Rule: If you choose to extract/collect this information, and you don't have a coded 'reason for visit', then they will go into the observations.
6. i2B2 Rule: If you choose to extract/collect this information, then use local conventions (whatever your site does normally).
7. Completion date (if needed): 7/23/14

##Vital Signs in the Final CDM
1. Issue Domain: Vital Signs
2. Description of the issue: The proposal for the final CDM is to include not only the raw weight and height, but also BMI (recorded as a measurement, NOT simply the calculation from the raw numbers).
3. Issue # (in GitHub):[#16](https://github.com/PEDSnet/Data_Models/issues/16)
4. Decision: In the final PEDSnet CDM, BMI should be a flagship derived variable.  Only extract measured BMI from EHRs.  You should only extract BMI if you don't have height and weight.  BMI and Zscores will be derived, and the DCC will generate the procedure for that later.
5. OMOP Rule: N/A
6. i2B2 Rule: N/A
7. Completion date (if needed): 7/23/14


