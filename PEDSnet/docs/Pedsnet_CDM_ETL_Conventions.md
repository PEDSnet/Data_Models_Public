# ETL Conventions for use with PEDSnet CDM v2.3 OMOP V5

The PEDSnet Common Data Model is an evolving specification, based in structure on the OMOP Common Data Model, but expanded to accommodate requirements of both the PCORnet Common Data Model and the primary research cohorts established in PEDSnet.

Version 2.3 of the PEDSnet CDM reflects the ETL processes developed after several iterations of network development. As such, it proposes to align with version 3 of the PCORnet CDM.

This document provides the ETL processing assumptions and conventions developed by the PEDSnet data partners that should be used by a data partner for ensuring common ETL business rules. This document will be modified as new situations are identified, incorrect business rules are identified and replaced, as new analytic use cases impose new/different ETL rules, and as the PEDSnet CDM continues to evolve.

Comments on this specification and ETL rules are welcome. Please send email to pedsnetdcc@email.chop.edu, or contact the PEDSnet project management office (details available via http://www.pedsnet.info).

#### PEDSnet Data Standards and Interoperability Policies:
 
1. The PEDSnet data network will store data using structures compatible with the PEDSnet Common Data Model (PCDM).

2. The PEDSnet CDM v2.3 is based on the Observational Medical Outcomes Partnership (OMOP) data model, version 5. 

3. A subset of data elements in the PCDM will be identified as principal data elements (PDEs). The PDEs will be used for population-level queries. Data elements which are NOT PDEs will be marked as Optional (ETL at site discretion) or Non-PDE (ETL required, but data need not be transmitted to DCC), and will not be used in queries without prior approval of site.

4. It is anticipated that PEDSnet institutions will make a good faith attempt to obtain as many of the data elements not marked as Optional as possible.

5. The data elements classified as PDEs and those included in the PCDM will be approved by the PEDSnet Executive Committee (comprised of each PEDSnet institution's site principal investigator).

6. Concept IDs are taken from OMOP 5 vocabularies for PEDSnet CDM v2.3, using the complete (restricted) version that includes licensed terminologies such as CPT and others.

7. PCORnet CDM v3 requires data elements that are not currently considered "standard concepts". Vocabulary version 5 has a new vocabulary (vocabulary_id=PCORNet) that was added by OMOP to capture all of the PCORnet concepts that are not in the standard terminologies. We use concept_ids from vocabulary_id=PCORNet where there are no existing standard concepts. We highlight where we are pulling concept_ids from vocabulary_id=PCORNet in the tables. While terms from vocabulary_id=PCORNet violates the OMOP rule to use only concept_ids from standard vocabularies vocabulary_id=PCORNet is a non-standard vocabulary), this convention enables a clean extraction from PEDSnet CDM to PCORnet CDM.

8. Some source fields may be considered sensitive by data sites. Potential examples include patient_source_value, provider_source_value, care_site_source_value. Many of these fields are used to generate an ID field, such as PERSON.patient_source_value PERSON.person_id, that is used as a primary key in PERSON and a foreign key in many other tables. Sites are free to obfuscate or not provide source values that are used to create ID variables. Sites must maintain a mapping from the ID variable back to the original site-specific value for local re-identification tasks.

    1. Source fields that contain clinical data, such as source condition occurrence, should be included

    2. The PEDSnet DCC will never release source values to external data partners.

    3. Source value obfuscation techniques may include replacing the real source value with a random number, an encrypted derivative value/string, or some other site-specific algorithm.

9. The PCORnet CDM has specific definitons for null values (as seen below). For the PEDSNet CDM, please use the following logic on which concept value to use for `source_concept_id` fields where there are null values in the source `*_source_value`.

Null Name | Definition of each field
 --- | ---
NULL | A data field is not present in the source system. Note. This is not a 'NULL' string but the NULL value.
'NI' = No Information | A data field is present in the source system, but the source value is null or blank
'UN' = Unknown | A data field is present in the source system, but the source value explicitly denotes an unknown value
'OT' = Other | A data field is present in the source system, but the source value cannot be mapped to the CDM

10.
**For populating `'*_source_concept_id'` (where there exists non-null values in the source) use the following Logic :**

  **Populate `'*_source_concept_id'` (i.e. non-zero) if the source_value is drawn from a standard vocabulary in OMOP**.
       
Please use your local system knowledge to determine this or use the following criteria : All the values in the source_value field should be drawn from the concept_code in the concept table (for a given/relevant domain_id and a given vocabulary_id).
    
  **ELSE Use 0** 
      
 (usually the case when the sites need to "manually" map the foo_source_value to foo_concept_id)

11.
**For populating `*_source_value` please make a best effort to provide "human readable" values rather than a coded value where possible from the source.**

  Example for `gender_source_value`, the source value at your site may be `1` for Female and `2` for Male. Please provide the label value of `Female` and `Male`.
 

***ETL Recommendation:*** Due to PK/FK constraints, the most efficient order for ETL table is location, care_site, provider, person, visit_occurrence, condition_occurrence, observation, procedure_occurrence,measurement,measurement_organism,drug exposure

* * *
## Table of Contents
####[1.1 Person](Pedsnet_CDM_ETL_Conventions.md#11-person-1)

####[1.2 Death](Pedsnet_CDM_ETL_Conventions.md#12-death-1)

####[1.3 Location](Pedsnet_CDM_ETL_Conventions.md#13-location-1)

####[1.4 Caresite](Pedsnet_CDM_ETL_Conventions.md#14-care_site)

####[1.5 Provider](Pedsnet_CDM_ETL_Conventions.md#15-provider-1)

####[1.6 Visit Occurrence ](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)

####[1.7 Condition Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence)

####[1.8 Procedure Occurrence](Pedsnet_CDM_ETL_Conventions.md#18-procedure_occurrence)

####[1.9 Observation](Pedsnet_CDM_ETL_Conventions.md#19-observation-1)

####[1.10 Observation Period](Pedsnet_CDM_ETL_Conventions.md#110-observation-period-1)

####[1.11 Drug Exposure](Pedsnet_CDM_ETL_Conventions.md#111-drug-exposure-1)

####[1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)

####[1.13 Fact Relationship](Pedsnet_CDM_ETL_Conventions.md#113-fact-relationship-1)

####[1.14 Visit Payer](Pedsnet_CDM_ETL_Conventions.md#114-visit_payer)

####[1.15 Measurement Organism](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md#115-measurement_organism)

####[Appendix] (Pedsnet_CDM_ETL_Conventions.md#a1-abms-specialty-category-to-omop-v5-specialty-mapping)

* * *
#### Data Extraction Guide

Please use the table headings as a guide in extracting and submitting data. These specifications are indicative of DCC and Network Requirements. All fields must be submitted to the DCC even if you are not submitting data in a field. Here are examples of how the specification should be interpreted:

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
 Field Name | <ul><li>Yes</li></ul>|<ul><li>Yes</li></ul>| Data Type | Description| PEDSnet Conventions
 
 - **The above example indicates the data in this field is required by both the DCC and Network. It absolutely must be provided in the data submission.**
 
Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
 Field Name | <ul><li>No</li></ul>|<ul><li>Provide When Available</li></ul>| Data Type | Description| PEDSnet Conventions
 
 - **The above example indicates the data in this field is required by Network if it is populated or available at your site. If it is available it must provided in the data submission.**
 
Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
 Field Name | <ul><li>No</li></ul>|<ul><li>Site Preference</li></ul>| Data Type | Description| PEDSnet Conventions
 
 - **The above example indicates the data in this field is not required by the DCC or Network. A site may choose to send this information if they desire to do so.**
 
Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
 Field Name | <ul><li>No</li></ul>|<ul><li>Optional</li></ul>| Data Type | Description| PEDSnet Conventions
 
 - **The above example indicates the data in this field is truly optional for submission. A site may choose to send this information if they desire to do so.**

* * *
## 1.1 PERSON

The person domain contains records that uniquely identify each patient in the source data who is time at-risk to have clinical observations recorded within the source systems. Each person record has associated demographic attributes, which are assumed to be constant for the patient throughout the course of their periods of observation. All other patient-related data domains have a foreign-key reference to the person domain.

PEDSnet uses a specific definition of an active PEDSnet patient. Only patients who meet the PEDSnet definition of an active patient should be included in this table. The criteria for identifying an active patient are:

- Has a unique identifier AND

- At least 1 "in person" clinical encounter on or after January 1, 2009 AND

- At least 1 coded diagnoses recorded on or after January 1, 2009 AND

- Is not a test patient or a research-only patient

The definition of an "in person" clinical encounter remains heuristic -any encounter type that involves a meaningful \*\*physical\*\* interaction with a clinician that involved clinical content. An encounter for a suture removal or a telephone encounter or a lab blood draw does not meet this definition.

**NOTE: While the 1/1/2009 date and "in person" clinical encounter restrictions apply to defining an active PEDSnet patient, once a patient has met this criteria, PEDSnet will extract *ALL* available clinical encounters/clinical data of any type across all available dates. That is, 1/1/2009 and 1 'in person' clinical encounter applies only to defining the active patient cohort. It does NOT apply to data extraction on active patients.**

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
person_id | Yes | Yes| Integer | A unique identifier for each person; this is created by each contributing site. | <p>This is not a value found in the EHR.</p> PERSON_ID must be unique for all patients within a single data set.</p><p>**SITE RESPONSIBILITY: This field must remain a stable identifier across submissions to the DCC.**</p> <p>A mapping from the person_id to a real patient ID or MRN from the source EHR must be kept at the local site. This mapping is not shared with the data coordinating center. It is used only by the site for re-identification for study recruitment or for data quality review.</p>
gender_concept_id | Yes |Yes|  Integer |  A foreign key that refers to a standard concept identifier in the Vocabulary for the gender of the person. | Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table select \* from concept where ((domain_id='Gender' and concept_class_id='Gender')or (domain_id='Observation' and vocabulary_id='PCORNet' and concept_class_id in ('Gender','Undefined'))) and concept_code not in ('Sex-F','Sex-M') and invalid_reason is null: <ul><li>Ambiguous: concept_id = 44814664 </li> <li>Female: concept_id = 8532</li> <li>Male: concept_id = 8507</li> <li>No Information: concept_id = 44814650 (Vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653</li> <li>Other: concept_id = 44814649</li></ul>
gender_source_concept_id | Yes | Yes|  Integer | A foreign key to the gender concept that refers to the code used in the source.|  <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>
year_of_birth | Yes |Yes|  Integer |  The year of birth of the person. | <p>For data sources with date of birth, the year is extracted. For data sources where the year of birth is not available, the approximate year of birth is derived based on any age group categorization available.</p> Please keep all accurate/real dates (No date shifting)
month_of_birth | No |Provide When Available|  Integer | The month of birth of the person. | <p>For data sources that provide the precise date of birth, the month is extracted and stored in this field.</p> Please keep all accurate/real dates (No date shifting)
day_of_birth | No |Provide When Available|  Integer | The day of the month of birth of the person. | <p>For data sources that provide the precise date of birth, the day is extracted and stored in this field.</p> Please keep all accurate/real dates (No date shifting)
time_of_birth | No |Provide When Available|  Datetime |  The birth date and time | <p>Do not include timezone.</p> Please keep all accurate/real dates (No date shifting). If there is no time associated with the date assert midnight.
race_concept_id | Yes |Yes|  Integer |  A foreign key that refers to a standard concept identifier in the Vocabulary for the race of the person. | Details of categorical definitions: <ul><li>**-American Indian or Alaska Native**: A person having origins in any of the original peoples of North and South America (including Central America), and who maintains tribal affiliation or community attachment.</li> <li>**-Asian**: A person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam.</li> <li>**-Black or African American**: A person having origins in any of the black racial groups of Africa.</li> <li>**-Native Hawaiian or Other Pacific Islander**: A person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands.</li> <li>**-White**: A person having origins in any of the original peoples of Europe, the Middle East, or North Africa.</li></ul> <p>For patients with multiple races (i.e. biracial), race is considered a single concept, meaning there is only one race slot. If there are multiple races in the source system, concatenate all races into one race_source_value (see below) and use concept_id code as 'Multiple Race.'</p> Predefined values (valid concept_ids found in CONCEPT table where ((domain_id='Race' and vocabulary_id = 'Race') or (vocabulary_id='PCORNet' and concept_class_id='Undefined') or concept_id in (44814659,44814660)) and invalid_reason is null: <ul><li>American Indian/Alaska Native: concept_id = 8657</li> <li>Asian: concept_id = 8515</li> <li>Black or African American: concept_id = 8516</li> <li>Native Hawaiian or Other Pacific Islander: concept_id = 8557</li> <li>White: concept_id = 8527</li> <li>Multiple Race: concept_id = 44814659 (vocabulary_id='PCORNet')</li> <li>Refuse to answer: concept_id = 44814660 (vocabulary_id='PCORNet')</li> <li>No Information: concept_id = 44814650 vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653</li> <li>Other: concept_id = 44814649</li></ul>
race_source_concept_id| Yes |Yes|  Integer| A foreign key to the race concept that refers to the code used in the source.| <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>
ethnicity_concept_id | Yes | Yes|  Integer | A foreign key that refers to the standard concept identifier in the Vocabulary for the ethnicity of the person. | <p>For PEDSnet, a person with Hispanic ethnicity is defined as "A person of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race."</p> Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id ='Ethnicity' or (vocabulary_id=PCORNet and concept_class_id='Undefined) where noted): <ul><li>Hispanic: concept_id = 38003563</li> <li>Not Hispanic: concept_id = 38003564</li> <li>No Information: concept_id = 44814650 (vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653 (vocabulary_id='PCORNet')</li> <li>Other: concept_id = 44814649 (vocabulary_id='PCORNet')</li></ul>
ethnicity_source_concept_id | Yes | Yes|Integer | A foreign key to the ethnicity concept that refers to the code used in the source.| <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>
location_id | No |Provide When Available| Integer |  A foreign key to the place of residency (ZIP code) for the person in the location table, where the detailed address information is stored.
provider_id | No |Provide When Available| Integer |  Foreign key to the primary care provider the person is seeing in the provider table.| <p>For PEDSnet CDM v2.3.0: Sites will use site-specific logic to determine the best primary care provider and document how that decision was made (e.g., billing provider).</p>
care_site_id | Yes |Yes| Integer |  A foreign key to the site of primary care in the care_site table, where the details of the care site are stored | For patients who receive care at multiple care sites, use site-specific logic to select a care site that best represents where the patient obtains the majority of their recent care. If a specific site within the institution cannot be identified, use a care_site_id representing the institution as a whole.
pn_gestational_age | No |Provide When Available| Integer |  The post-menstrual age in weeks of the person at birth, if known | Use granularity of age in weeks as is recorded in local EHR.
person_source_value | No |Provide When Available|  Varchar |  An encrypted key derived from the person identifier in the source data. | <p>Insert a unique pseudo-identifier (random number, encrypted identifier) into the field. Do not insert the actual MRN or PAT_ID from your site. A mapping from the pseudo-identifier for person_source_value in this field to a real patient ID or MRN from the source EHR must be kept at the local site. This mapping is not shared with the data coordinating center. It is used only by the site for re-identification for study recruitment or for data quality review.</p>
gender_source_value | Yes |Yes|  Varchar |  The source code for the gender of the person as it appears in the source data. | The person's gender is mapped to a standard gender concept in the Vocabulary; the original value is stored here for reference. See gender_concept_id
race_source_value | Yes |Yes|  Varchar |  The source code for the race of the person as it appears in the source data. | <p>The person race is mapped to a standard race concept in the Vocabulary and the original value is stored here for reference.</p> For patients with multiple races (i.e. biracial), race is considered a single concept, meaning there is only one race slot. If there are multiple races in the source system, concatenate all races into one source value, and use the concept_id for Multiple Race.
ethnicity_source_value | Yes |Yes|  Varchar |  The source code for the ethnicity of the person as it appears in the source data. | The person ethnicity is mapped to a standard ethnicity concept in the Vocabulary and the original code is, stored here for reference.
language_concept_id|Yes| Yes| Integer | A foreign key that refers to the standard concept identifier in the Vocabulary for the language of the person.| <p>For PEDSNet, please map your source codes to acceptable language values in [appendix 2](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md#a2-pedsnet-person-language-concept-mapping-values) **If there is not a mapping for the source code in the network language mapping, use concept_id = 44814649 (Other PCORNet Vocabulary)**</p>|
language_source_concept_id| Yes| Yes | Integer | A foreign key to the language concept that refers to the code used in the source.|<p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>
language_source_value| Yes| Yes| Varchar | The source code for the language of the person as it appears in the source data | The person language is mapped to a standard language concept in the Vocabulary and the original code is stored here for reference.

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

## 1.2 DEATH

The death domain contains the clinical event for how and when a person dies. Living patients should not contain any information in the death table.

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
death_cause_id | Yes | Yes | Integer | A unique identifier for each death cause occurrence | This is not a value found in the EHR. Sites may choose to use a sequential value for this field
person_id | Yes | Yes |   Integer | A foreign key identifier to the deceased person. The demographic details of that person are stored in the person table.| See PERSON.person_id (primary key)
death_date | Yes |Yes|   Date | The date the person was deceased. | <p>If the precise date including day or month is not known or not allowed, December is used as the default month, and the last day of the month the default day. If no date available, use date recorded as deceased.</p> When the date of death is not present in the source data, use the date the source record was created.
death_time | Yes |Yes|   Datetime | The date the person was deceased. |<p>**This field is custom to PEDSnet**</p> <p>If the precise date including day or month is not known or not allowed, December is used as the default month, and the last day of the month the default day. If no date available, use date recorded as deceased.</p> <p>When the date of death is not present in the source data, use the date the source record was created. If there is no time associated with the date assert '23:59:59'.</p>
death_type_concept_id | Yes | Yes|  Integer | A foreign key referring to the predefined concept identifier in the Vocabulary reflecting how the death was represented in the source data. | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where domain_id ='Death Type')</p> <p>select \* from concept where concept_class_id ='Death Type' yields 9 valid concept_ids. If none are correct, use concept_id = 0</p> <p>Note: Most current ETLs are extracting data from EHR. The common concept_id to insert here is <ul><li>38003569 ("EHR record patient status "Deceased")</li></ul>. Please assert <ul><li>No information: concept_id =  44814650</li></ul> where there is no information in the source</p> **Note**: These terms only describe the source from which the death was reported. It does not describe our certainty/source of the date of death, which may have been created by one of the heuristics described in death_date.
cause_concept_id | No |Provide When Available|   Integer | A foreign referring to a standard concept identifier in the Vocabulary for conditions. | 
cause_source_value | No |Provide When Available|   Varchar | The source code for the cause of death as it appears in the source. This code is mapped to a standard concept in the Vocabulary and the original code is stored here for reference.
cause_source_concept_id | No |Provide When Available| Integer | A foreign key to the vocabulary concept that refers to the code used in the source.| This links to the concept id of the vocabulary of the cause of death concept id as stored in the source. For example, if the cause of death is "Acute myeloid leukemia, without mention of having achieved remission" which has an icd9 code of 205.00 the cause source concept id is 44826430 which is the icd9 code concept that corresponds to the diagnosis 205.00.  <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>
death_impute_concept_id| Yes | Yes| Varchar | A foreign key referring to a standard concept identifier in the vocabulary for death imputation. | p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where concept_class_id ='Death Imput Type')</p> <p>select \* from concept where (concept_class_id ='Death Imput Type' or (vocabulary_id='PCORNet' and concept_class_id='Undefined')) and invalid_reason is null) yields 8 valid concept_ids. If none are correct, use concept_id = 0</p> <ul> <li>Both month and day imputed: 2000000034</li><li>Day imputed: 2000000035</li><li>Month imputed: 2000000036</li><li>Full Date imputed: 2000000038</li><li>Not imputed:2000000037 </li> <li>No Information: concept_id = 44814650 (Vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653</li> <li>Other: concept_id = 44814649</li></ul></p>

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.2.1 Additional Notes

- Each Person may have more than one record of death in the source data. It is OK to insert multiple death records for an individual.
- If the Death Date cannot be precisely determined from the data, the best approximation should be used.

## 1.3 LOCATION

The Location domain represents a generic way to capture physical location or address information. Locations are used to define the addresses for Persons and Care Sites. The most important field is ZIP for location-based queries.

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
location_id | Yes | Yes | Integer | A unique identifier for each geographic location. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field
state | No |Provide When Available|  Varchar | The state field as it appears in the source data.
zip | No|Provide When Available|  Varchar | The zip code. For US addresses, valid zip codes can be 3, 5 or 9 digits long, depending on the source data. | While optional, this is the most important field in this table to support location-based queries.
location_source_value | No |Provide When Available|  Varchar | <p>Optional - Do not transmit to DCC.</p> The verbatim information that is used to uniquely identify the location as it appears in the source data. | <p>If location source values are deemed sensitive by your organization, insert a pseudo-identifier (random number, encrypted identifier) into the field. Sites electing to obfuscate location_source_values will keep the mapping between the value in this field and the original clear text location source value. This value is only used for site-level re-identification for study recruitment and for data quality review.</p> Sites may consider using the location_id field value in this table as the pseudo-identifier as long as a local mapping from location_id to the real site identifier is maintained.
address_1 | No | NO| Varchar | |Do not transmit to DCC
address_2 | No | NO| Varchar | | Do not transmit to DCC
city | No |NO |Varchar | |Do not transmit to DCC
county | No |NO| Varchar | |Do not transmit to DCC

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.3.1 Additional Notes

- Each address or Location is unique and is present only once in the table
- Locations in this table are restricted to locations that are applicable to persons and care_sites in the Pedsnet cohort at each site. When external data is implemented, valid(data containing) locations may be expanded beyond locations of those only present in clinical tables.

## 1.4 CARE_SITE

The Care Site domain contains a list of uniquely identified physical or organizational units where healthcare delivery is practiced (offices, wards, hospitals, clinics, etc.).

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
care_site_id | Yes | Yes | Integer | A unique identifier for each defined location of care within an organization. Here, an organization is defined as a collection of one or more care sites that share a single EHR database. | <p>This is not a value found in the EHR.</p> Sites may choose to use a sequential value for this field
care_site_name | No |Provide When Available|  Varchar | The description of the care site | 
place_of_service_concept_id | No |Provide When Available|   Integer | A foreign key that refers to a place of service concept identifier in the Vocabulary | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where domain_id='Visit' or (vocabulary_id='PCORNet' and concept_class_id='Encounter Type') or (vocabulary_id='PCORNet' and concept_class_id='Undefined' and not concept_code ~ '-ED\|-IP\|-AV') and invalid_reason is null)</p> <p>select \* from concept where domain_id='Visit' or (vocabulary_id='PCORNet' and concept_class_id='Encounter Type') or (vocabulary_id='PCORNet' and concept_class_id='Undefined') and invalid_reason is null yields 10 valid concept_ids.</p> If none are correct, use concept_id = 0 <ul><li>Inpatient Hospital Stay: concept_id = 9201</li> <li>Ambulatory Visit: concept_id = 9202</li> <li>Emergency Department: concept_id = 9203</li> <li>Long Term Care Visit = 42898160 </li><li>Other ambulatory Visit = 44814711</li> <li>Non-Acute Institutional Stay: concept_id = 44814710 )</li><li>Emergency Department Admit to Inpatient Hospital Stay (If sites are unable to split the encounter) = 2000000048</li> <li>Unknown: concept_id = 44814653 </li> <li>Other: concept_id =  44814649 </li> <li>No information: concept_id =  44814650</li></ul>
location_id | No |Provide When Available|   Integer | A foreign key to the geographic location of the administrative offices of the organization in the location table, where the detailed address information is stored.
care_site_source_value | Yes  | Yes|  Varchar | The identifier for the organization in the source data, stored here for reference. | <p>If care site source values are deemed sensitive by your organization, insert a pseudo-identifier (random number, encrypted identifier) into the field. Sites electing to obfuscate care site_source_values will keep the mapping between the value in this field and the original clear text location source value. This value is only used for site-level re-identification for study recruitment and for data quality review.</p> <p>For EPIC EHRs, map care_site_id to Clarity Department.</p> Sites may consider using the care_site_id field value in this table as the pseudo-identifier as long as a local mapping from care_site_id to the real site identifier is maintained.
place_of_service_source_value | No |Provide When Available|  Varchar | The source code for the place of service as it appears in the source data, stored here for reference.
specialty_concept_id|No|Provide When Available| Integer|The specialty of the department linked to a standard specialty concept as it appears in the Vocabulary | <p>Care sites could have one or more specialties or a Care site could have no specialty information.</p><p>**Valid specialty concept ids for PEDSnet are found in the [appendix] (https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md#a1-abms-specialty-category-to-omop-v5-specialty-mapping)**</p><p>**Please use the following rules:**</p><ul><li><p> If care site specialty information is unavailable, please follow the convention on reporting values that are unknown,null or unavailable. </p></li><li><p> If a care site has a single specialty associated with it, sites should link the specialty to the **valid specialty concepts as assigned in the [appendix] (https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md#a1-abms-specialty-category-to-omop-v5-specialty-mapping)**. If the specialty does not correspond to a value in this listing, please use the NUCC Listing (vocabulary_id='NUCC') provided in the vocabulary as a reference. </p></li><li><p> If there are multiple specialties associated with a particular care site and sites are not able to assign a specialty value on the visit occurrence level, sites should use the specialty concept id=38004477 "Pediatric Medicine". </p></li><li><p> If there are multiple specialties associated with a particular care site and this information is attainable, sites should document the strategy used to obtain this information and the strategy used to link the correct care site/specialty pair for each visit occurrence. Sites should also link the specialty to the **valid specialty concepts as assigned in the [appendix] (https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md#a1-abms-specialty-category-to-omop-v5-specialty-mapping)**</p> If the specialty does not correspond to a value in this listing, please use the NUCC Listing (vocabulary_id='NUCC') provided in the vocabulary as a reference. </li></ul>|
specialty_source_value| No |Provide When Available|  Varchar | The source code for the specialty as it appears in the source data, stored here for reference.

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.4.1 Additional Notes

- Care sites are primarily identified based on the specialty or type of care provided, and secondarily on physical location, if available (e.g. North Satellite Endocrinology Clinic)
- The Place of Service Concepts are based on a catalog maintained by the CMS (see vocabulary for values)

## 1.5 PROVIDER

The Provider domain contains a list of uniquely identified health care providers. These are typically physicians, nurses, etc.

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
provider_id | Yes |Yes|  Integer | A unique identifier for each provider. Each site must maintain a map from this value to the identifier used for the provider in the source data. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field. See Additional Comments below. Sites should document who they have included as a provider.
provider_name | No | NO| Varchar | A description of the provider | DO NOT TRANSMIT TO DCC
gender_concept_id | No | Provide When Available|Integer | The gender of the provider | A foreign key to the concept that refers to the code used in the source.|Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table select \* from concept where domain_id='Gender'): <ul><li>Ambiguous: concept_id = 44814664 </li> <li>Female: concept_id = 8532</li> <li>Male: concept_id = 8507</li> <li>No Information: concept_id = 44814650 (Vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653</li> <li>Other: concept_id = 44814649</li></ul>
specialty_concept_id | No | Provide When Available| Integer | A foreign key to a standard provider's specialty concept identifier in the Vocabulary. | <p>Please map the source data to the mapped provider specialty concept associated with the American Medical Board of Specialties as seen in [**Appendix A1**](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md#a1-abms-specialty-category-to-omop-v5-specialty-mapping). Predefined value set (valid concept_ids found in CONCEPT table where domain_id='Provider Specialty' and  vocabulary_id in ('Specialty', 'ABMS','NUCC','PEDsnet'))</p> <p>select \* from concept where domain_id ='Provider Specialty' and vocabulary_id in ('Specialty', 'ABMS','NUCC','PEDsnet') and invalid_reason is null yields 1025 valid concept_ids.</p> <p>If none are correct, use concept_id = 0</p> For providers with more than one specialty, use site-specific logic to select one specialty and document the logic used. For example, sites may decide to always assert the \*\*first\*\* specialty listed in their data source. As a first guide please use the ABMS and PEDsnet vocabulary specialty listing listing to map your specialtity values. If the specialty does not correspond to a value in these listings, please use the NUCC Listing (vocabulary_id='NUCC') provided in the vocabulary as a reference.
care_site_id | Yes |Yes|  Integer | A foreign key to the main care site where the provider is practicing. | See CARE_SITE.care_site_id (primary key)
year_of_birth | No |Provide When Available| Integer | The year of birth of the provider||
NPI | No |  Varchar |Site Preference| The National Provider Identifier (NPI) of the provider. |
DEA | No |  Varchar | Site Preference|The Drug Enforcement Administration (DEA) number of the provider. |
provider_source_value | Yes |Yes|  Varchar | The identifier used for the provider in the source data, stored here for reference. | <p>Insert a pseudo-identifier (random number, encrypted identifier) into the field. Do not insert the actual PROVIDER_ID from your site. A mapping from the pseudo-identifier for provider_source_value in this field to a real provider ID from the source EHR must be kept at the local site. This mapping is not shared with the data coordinating center. It is used only by the site for re-identification for study recruitment or for data quality review.</p> Sites may consider using the provider_id field value in this table as the pseudo-identifier as long as a local mapping from provider_id to the real site identifier is maintained.
specialty_source_value | No |Provide When Available|  Varchar | The source code for the provider specialty as it appears in the source data, stored here for reference. | Optional. May be obfuscated if deemed sensitive by local site.
specialty_source_concept_id | No |Provide When Available| Integer | A foreign key to a concept that refers to the code used in the source.| If providing this information, sites should document how they determine the specialty associated with the provider. **Valid specialty concept ids for PEDSnet are found in the [appendix] (https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Pedsnet_CDM_ETL_Conventions.md#a1-abms-specialty-category-to-omop-v5-specialty-mapping)** If the specialty does not correspond to a value in this listing, please use the NUCC Listing (vocabulary_id='NUCC') provided in the vocabulary as a reference.  <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>
gender_source_value | No |Provide When Available| Varchar | The source value for the provider gender.
gender_source_concept_id | No |Provide When Available| Integer | The gender of the provider as represented in the source that maps to a concept in the vocabulary| <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.5.1 Additional Notes

- For PEDSnet, a provider is any individual (MD, DO, NP, PA, RN, etc) who is authorized to document care.
- Providers are not duplicated in the table.

## 1.6 VISIT_OCCURRENCE

The visit occurrence domain contains the spans of time a person continuously receives medical services from one or more providers at a care site in a given setting within the health care system.

Exclusions:

1. Future Vists

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
visit_occurrence_id | Yes |Yes|  Integer | A unique identifier for each person's visits or encounter at a healthcare provider. |<p>This is not a value found in the EHR.</p> VISIT_OCCURRENCE_ID must be unique for all patients within a single data set.</p><p>**SITE RESPONSIBILITY: This field must remain a stable identifier across submissions to the DCC.**</p> <p>A mapping from the visit occurrence id to a real patient encounter from the source EHR must be kept at the local site. This mapping is not shared with the data coordinating center. It is used only by the site for re-identification for study recruitment or for data quality review.  Do not use institutional encounter ID.</p>
person_id | Yes|Yes|  Integer | A foreign key identifier to the person for whom the visit is recorded. The demographic details of that person are stored in the person table.
visit_start_date | Yes|Yes|  Date | The start date of the visit. | No date shifting. Full date.
visit_end_date | No |Provide When Available| Date | The end date of the visit. | <p>No date shifting. Full date.</p> <p>If this is a one-day visit the end date should match the start date.</p> If the encounter is on-going at the time of ETL, this should be null.
visit_start_time |Yes |Yes|  Datetime | The start date of the visit. | No date shifting.  Full date and time. **If there is no time associated with the date assert midnight for the start time**
visit_end_time | No |Provide When Available| Datetime | The end date of the visit. | <p>No date shifting.</p> <p>If this is a one-day visit the end date should match the start date.</p> If the encounter is on-going at the time of ETL, this should be null.  Full date and time. **If there is no time associated with the date assert 11:59:59 pm for the end time**
provider_id | No |Provide When Available|  Integer | A foreign key to the provider in the provider table who was associated with the visit. | <p>Use attending or billing provider for this field if available, even if multiple providers were involved in the visit. Otherwise, make site-specific decision on which provider to associate with visits and document.</p> **NOTE: this is NOT required in OMOP CDM v4, but appears in OMOP CDMv5.**
care_site_id | No |Provide When Available| Integer | A foreign key to the care site in the care site table that was visited. | See CARE_SITE.care_site_id (primary key)
visit_concept_id | Yes |Yes| Integer | A foreign key that refers to a place of service concept identifier in the vocabulary. | <p>**In PEDSnet CDM v1, this field was previously called place_of_service_concept_id**</p><p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where domain_id='Visit' or (vocabulary_id='PCORNet' and concept_class_id='Encounter Type') or (vocabulary_id='PCORNet' and concept_class_id='Undefined'and not concept_code ~ '-ED\|-IP\|-AV') and invalid_reason is null).</p> <p>select \* from concept where domain_id='Visit' or (vocabulary_id='PCORNet' and concept_class_id='Encounter Type' and not concept_code ~ '-ED\|-IP\|-AV') or (vocabulary_id='PCORNet' and concept_class_id='Undefined' and not concept_code ~ '-ED\|-IP\|-AV') and invalid_reason is null yields 10 valid concept_ids.</p> If none are correct, use concept_id = 0 <ul><li>Inpatient Hospital Stay: concept_id = 9201</li> <li>Ambulatory Visit: concept_id = 9202</li> <li>Emergency Department: concept_id = 9203</li> <li>Long Term Care Visit = 42898160 </li><li>Other ambulatory Visit = 44814711</li> <li>Non-Acute Institutional Stay: concept_id = 44814710 )</li><li>Emergency Department Admit to Inpatient Hospital Stay (If sites are unable to split the encounter) = 2000000048</li> <li>Unknown: concept_id = 44814653 </li> <li>Other: concept_id =  44814649 </li> <li>No information: concept_id =  44814650</li></ul>
visit_type_concept_id | Yes |Yes| Integer | A foreign key to the predefined concept identifier in the standard vocabulary reflecting the type of source data from which the visit record is derived.| <p> select \* from concept where concept_class_id='Visit Type' yields 3 valid concept_ids.</p> If none are correct, user concept_id=0. The majority of visits should be type 'Visit derived from EHR record' which is concept_id=44818518
visit_source_value | No |Provide When Available| Varchar | The source code used to reflect the type or source of the visit in the source data. Valid entries include office visits, hospital admissions, etc. These source codes can also be type-of service codes and activity type codes.
visit_source_concept_id | No |Provide When Available| Integer | A foreign key to a concept that refers to the code used in the source. | If a site is using HCPS or CPT for their visit source value, the standard concept id that maps to the particular vocabulary can be used here.  <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.6.1 Additional Notes

- The 1/1/2009 date limitation that is used to define a PEDSnet active patient is **NOT** applied to visit_occurrence. All visits, of all types (physical and virtual) are included for an active patient.
- A Visit Occurrence is recorded for each visit to a healthcare facility.
- **If a visit includes moving between different visit_concepts (ED -\> inpatient) this should be split into separate visit_occurrence records to meet PCORnet's definitions**.

**To show the relationship of the split (ED -\> inpatient) encounter, use the FACT_RELATIONSHIP table**.

An example of this is below:

**VISIT_OCCURRENCE**

visit_occurrence_id | person_id |    visit_start_date    |     visit_end_date     | provider_id | care_site_id | place_of_service_concept_id | place_of_service_source_value 
---------------------|-----------|---------|------------------------|-------------|--------------|------|---------------
35022489 |    209846 | 2011-11-14 17:36:00-05 | 2011-11-14 22:25:00-05 |        2238 |          322 |                        9203 | Emergency
35022490 |    209846 | 2011-11-14 22:25:00-05 | 2011-11-15 16:33:00-05 |        2238 |           43 |                        9201 | Emergency

**FACT_RELATIONSHIP**

Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
Visit | 35022489| Visit | 35022490|  Occurs before
Visit | 35022490 | Visit | 35022489 | Occurs after 

Because the domain_concept_id and relationship_concept_id are actually numeric values the following is an example of how the table is stored:

Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
8| 35022489| 8 | 35022490|  44818881
8 | 35022490 | 8 | 35022489 | 44818783

- Operating and Anesthesia encounters that occur as apart of the Inpatient stay should be rolled up into one Inpatient encounter.
- Each Visit is standardized by assigning a corresponding Concept Identifier based on the type of facility visited and the type of services rendered.
- At any one day, there could be more than one visit.
- One visit may involve multiple attending or billing providers (e.g. billing, attending, etc), in which case the ETL must specify how a single provider id is selected or leave the provider_id field null.
- One visit may involve multiple care sites, in which case the ETL must specify how a single care_site id is selected or leave the care_site_id field null.


## 1.7 CONDITION_OCCURRENCE

The condition occurrence domain captures records of a disease or a medical condition based on diagnoses, signs and/or symptoms observed by a provider or reported by a patient.

Conditions are recorded in different sources and levels of standardization. For example:

- Medical claims data include ICD-9-CM diagnosis codes that are submitted as part of a claim for health services and procedures.
- EHRs may capture a person's conditions in the form of diagnosis codes and symptoms as ICD-9-CM or ICD-10-CM codes, but may not have a way to capture out-of-system conditions.
- EHRs may also capture External Injury codes in different place in the source system. These types of codes are also to be included.

**Note 1:**
Please use the following logic to populate the `condition_concept_id`, `condition_source_concept_id` and `condition_source_value` based on what is available in your source system:

Site Information | condition_concept_id|condition_source_concept_id|condition_source_value
--- | --- | --- | ---
Any diagnosis that was captured as a term or name (e.g. IMO to SNOMED)| Corresponding SNOMED concept id |Corresponding concept for site diagnosis captured (must correspond to ICD9/ICD10 concept mapping) | Diagnosis Name "\|" Diagnosis Code
Any diagnosis that was captured directly as a code (e.g. ICD9/10) by a coder | Corresponding SNOMED concept id | Corresponding concept for site diagnosis code (must correspond to ICD9/ICD10 concept mapping) | Diagnosis Name "\|" Diagnosis Code

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
condition_occurrence_id | Yes |Yes| Integer | A unique identifier for each condition occurrence event. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field
person_id | Yes |Yes| Integer | A foreign key identifier to the person who is experiencing the condition. The demographic details of that person are stored in the person table.
condition_concept_id | Yes |Yes| Integer | A foreign key that refers to a standard condition concept identifier in the Vocabulary. | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id ='SNOMED')</p> <p>select \* from concept where vocabulary_id ='SNOMED'  yields ~440,000 valid concept_ids.</p> If none are correct, use concept_id = 0
condition_start_date | Yes |Yes| Date| The date when the instance of the condition is recorded. | No date shifting.  
condition_end_date | No |Provide When Available| Date| The date when the instance of the condition is considered to have ended | <p>No date shifting.</p> If this information is not available, set to NULL. 
condition_start_time | Yes |Yes| Datetime | The date and time when the instance of the condition is recorded. | No date shifting.  Full date and time. **If there is no time associated with the date assert midnight for the start time**
condition_end_time | No |Provide When Available| Datetime | The date and time when the instance of the condition is considered to have ended | <p>No date shifting.</p> If this information is not available, set to NULL.  Full date and time.  **If there is no time associated with the date assert 11:59:59 pm for the end time**
condition_type_concept_id | Yes |Yes| Integer | A foreign key to the predefined concept identifier in the Vocabulary reflecting the source data from which the condition was recorded, the level of standardization, and the type of occurrence. For example, conditions may be defined as primary or secondary diagnoses, problem lists and person statuses. | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where domain_id ='Condition Type')</p> <p>select \* from concept where concept_class_id ='Condition Type' yields 99 valid concept_ids.</p> <p>If none are correct, use concept_id = 0</p>**For the primary diagnosis for the inpatient or outpatient setting (may be identified as Dx#1 in a source system), Please use concepts the following concepts:** <ul><li>Inpatient header - primary: concept_id = 38000199</li><li>Outpatient header - 1st position: concept_id = 38000230</li></ul>**All other diagnosis that is not the primary (or Dx#1) in the inpatient or outpatient setting should correspond to the following concept ids:**<ul><li>Inpatient header - 2nd position: concept_id = 38000201</li>  <li>Outpatient header - 2nd position: concept_id = 38000231</li> </ul>**For diagnosis from the problem list, please use the following concept id:**<ul><li>EHR problem list entry: 38000245</li></ul>
stop_reason | No |Provide When Available| Varchar | The reason, if available, that the condition was no longer recorded, as indicated in the source data. | <p>Valid values include discharged, resolved, etc. Note that a stop_reason does not necessarily imply that the condition is no longer occurring, and therefore does not mandate that the end date be assigned.</p>
provider_id | No |Provide When Available| Integer | A foreign key to the provider in the provider table who was responsible for determining (diagnosing) the condition. | **In PEDSnet CDM v1, this field was previously called associated_provider_id**<p>Any valid provider_id allowed (see definition of providers in PROVIDER table)</p> Make a best-guess and document method used. Or leave blank
visit_occurrence_id | No | Provide When Available|Integer | A foreign key to the visit in the visit table during which the condition was determined (diagnosed).
condition_source_value | Yes |Yes| Varchar | The source code for the condition as it appears in the source data. This code is mapped to a standard condition concept in the Vocabulary and the original code is, stored here for reference. | Condition source codes are typically ICD-9-CM or ICD-10-CM diagnosis codes from medical claims or discharge status/visit diagnosis codes from EHRs. Use source_to_concept maps to translation from source codes to OMOP concept_ids. **Please include the diagnosis name and source code when populating this field, by using the pipe delimiter "\|" when concatenating values.** Example: 	Diagnosis Name "\|" Diagnosis Code
condition_source_concept_id | No |Provide When Available| Integer | A foreign key to a condition concept that refers to the code used in the source| As a standard convention this code must correspond to the ICD9/ICD10 concept mapping of the source value only. For example, if the condition is "Acute myeloid leukemia, without mention of having achieved remission" which has an icd9 code of 205.00 the condition source concept id is 44826430 which is the icd9 code concept that corresponds to the diagnosis 205.00. <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.7.1 Additional Notes

- The 1/1/2009 date limitation that is used to define a PEDSnet active patient is \*\*NOT\*\* applied to condition_occurrence. All conditions are included for an active patient. For PEDSnet CDM v2.3, we limit condition_occurrences to final diagnoses only (not reason-for-visit and provisional surgical diagnoses such as those recored in EPIC OPTIME). In EPIC, final diagnoses includes both encounter diagnoses and billing diagnoses, problem lists (all problems, not filtered on "chronic" versus "provisional" unless local practices use this flag as intended). Medical History diagnosis are optional.
- Condition records are inferred from diagnostic codes recorded in the source data by a clinician or abstractionist for a specific visit. In the current version of the CDM, diagnoses extracted from unstructured data (such as notes) are not included.
- Source code systems, like ICD-9-CM, ICD-10-CM, etc., provide coverage of conditions. However, if the code does not define a condition, but rather is an observation or a procedure, then such information is not stored in the CONDITION_OCCURRENCE table, but in the respective tables instead. An example are ICD-9-CM procedure codes. For example, OMOP source-to-concept table uses the MAPPING_TYPE column to distinguish ICD9 codes that represent procedures rather than conditions.
- Condition source values are mapped to standard concepts for conditions in the Vocabulary. For mapping ICD9 Codes to SNOMED, use the concept_relationship table where the icd9_code = concept_id_1 and relationship_id='Maps to'. Concept_id_2 will be the SNOMED concept_id mapping you need to populate the condition_concept_id.

- When the source code cannot be translated into a Standard Concept, a CONDITION_OCCURRENCE entry is stored with only the corresponding source_value and a condition_concept_id of 0.
- Codes written in the process of establishing the diagnosis, such as "question of" of and "rule out", are not represented here.

## 1.8 PROCEDURE_OCCURRENCE

The procedure occurrence domain contains records of significant activities or processes ordered by and/or carried out by a healthcare provider on the patient to have a diagnostic and/or therapeutic purpose that are not fully captured in another table (e.g. drug_exposure).

Procedures records are extracted from structured data in Electronic Health Records that capture source procedure codes using CPT-4, ICD-9-CM (Procedures),ICD-10 (Procedures), HCPCS or OPCS-4 procedures as orders.

More specifically the procedure occurrence domain is intended to stores information about activity or processes involving a patient that has a billable code. This includes but is not limited to the following:
- LOS Codes ((Eg. 99123) This code may not Not necessarily be a CPT and could require local mapping )
- Lab Procedures (including a Lab Panel Order)
- Surgery Procedures
- Imaging Procedures

Notes:
**Only instantiated procedures are included in this table. Please exclude cancelled procedures**
**For CPT Codes, only include codes that are included in the standard CPT4 vocabulary from the distributed vocabulary**

**Note 1:**
Please use the following logic to populate the `procedure_concept_id`, `procedure_source_concept_id` and `procedure_source_value` based on what is available in your source system:

Site Information | procedure_concept_id|procedure_source_concept_id|procedure_source_value
--- | --- | --- | ---
Procedure codes using CPT-4, ICD-9-CM (Procedures),ICD-10 (Procedures), HCPCS or OPCS-4 procedures as orders | Corresponding CPT-4, ICD-9-CM (Procedures),ICD-10 (Procedures), HCPCS or OPCS-4 concept id |Corresponding CPT-4, ICD-9-CM (Procedures),ICD-10 (Procedures), HCPCS or OPCS-4 concept id | Procedure Name \| Procedure Source Code
Custom Procedure Coding (That a site has knowledge of corresponding to a standard code but requires manual mapping) | 0 | Corresponding CPT-4, ICD-9-CM (Procedures),ICD-10 (Procedures), HCPCS or OPCS-4 concept id  |Procedure Name \| Custom Procedure Code

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
procedure_occurrence_id | Yes |Yes| Integer | A system-generated unique identifier for each procedure occurrence | This is not a value found in the EHR. Sites may choose to use a sequential value for this field
person_id | Yes |Yes| Integer | A foreign key identifier to the person who is subjected to the procedure. The demographic details of that person are stored in the person table.
procedure_concept_id | Yes |Yes| Integer | A foreign key that refers to a standard procedure concept identifier in the Vocabulary. | <p>Valid Procedure Concepts belong to the "Procedure" domain. Procedure Concepts are based on a variety of vocabularies: SNOMED-CT (vocabulary_id ='SNOMED'), ICD-9-Procedures (vocabulary_id ='ICD9Proc'),ICD-10-Procedures (vocabulary_id ='ICD10PCS' **NOT YET AVAILABLE**), CPT-4 (vocabulary_id ='CPT4' ), and HCPCS (vocabulary_id ='HCPCS')</p> <p>Procedures are expected to be carried out within one day. If they stretch over a number of days, such as artificial respiration, usually only the initiation is reported as a procedure (CPT-4 "Intubation, endotracheal, emergency procedure").</p> Procedures could involve the administration of a drug, in which case the procedure is recorded in the procedure table and simultaneously the administered drug in the drug table.
modifier_concept_id | No |Provide When Available| Integer | A foreign key to a standard concept identifier for a modifier to the procedure (e.g. bilateral) |  <p>Valid Modifier Concepts belong to the "Modifier" concept class. select /* from concept where concept_class_id like '%Modifier%'. </p>
quantity | No |Provide When Available|Float |The quantity of procedures ordered or administered.
procedure_date | Yes | Yes|Date | The date on which the procedure was performed. 
procedure_time | Yes | Yes|Datetime | The date and time on which the procedure was performed. If there is no time associated with the date assert midnight. | **This field is a custom PEDSnet field**
procedure_type_concept_id | Yes |Yes| Integer | A foreign key to the predefined concept identifier in the Vocabulary reflecting the type of source data from which the procedure record is derived. (OMOP vocabulary_id = 'Procedure Type') | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 'Procedure Type')</p> <p>select \* from concept where vocabulary_id ='Procedure Type' yields 93 valid concept_ids.</p>Please map all procedures to the following concept:<ul><li> EHR order list entry: 38000275 </li></ul>
provider_id | No | Provide When Available|Integer | A foreign key to the provider in the provider table who was responsible for carrying out the procedure. | <p>Any valid provider_id allowed (see definition of providers in PROVIDER table)</p> Document how selection was made.
visit_occurrence_id | No |Provide When Available| Integer | A foreign key to the visit in the visit table during which the procedure was carried out. | See VISIT.visit_occurrence_id (primary key)
procedure_source_value | Yes |Yes| Varchar | The source code for the procedure as it appears in the source data. This code is mapped to a standard procedure concept in the Vocabulary and the original code is stored here for reference. | Procedure_source_value codes are typically ICD-9, ICD-10 Proc, CPT-4, HCPCS, or OPCS-4 codes. All of these codes are acceptable source values.Please also include the procedure name. See Note 1.
procedure_source_concept_id | No |Provide When Available| Integer | A foreign key to a procedure concept that refers to the code used in the source.| For example, if the procedure is "Anesthesia for procedures on eye; lens surgery" in the source which has a concept code in the vocabulary that is 2100658. The procedure source concept id will be 2100658.  <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>
modifier_source_value | No |Provide When Available| Varchar | The source code for the modifier as it appears in the source data.
qualifier_source_value|No | Provider When Available | Varchar | The source code for the qualifier as it appears in the source data.

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.8.1 Additional notes

- The 1/1/2009 date limitation that is used to define a PEDSnet active patient is \*\*NOT\*\* applied to procedure_occurrence. All procedures are included for an active patient. For PEDSnet CDM v2.3, we limit procedures_occurrences to billing procedures only (not surgical diagnoses).
- Procedure Concepts are based on a variety of vocabularies: SNOMED-CT, ICD-9-Proc, ICD-10-Proc, CPT-4, HCPCS and OPCS-4.
- Procedures could reflect the administration of a drug, in which case the procedure is recorded in the procedure table and simultaneously the administered drug in the drug table.
- The Visit during which the procedure was performed is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
- The Provider carrying out the procedure is recorded through a reference to the PROVIDER table. This information is not always available.

## 1.9 OBSERVATION

The observation domain captures clinical facts about a patient obtained in the context of examination, questioning or a procedure. The observation domain supports capture of data not represented by other domains, including unstructured measurements, medical history and family history. For the PEDSnet CDM version 2.3, the observations listed below are extracted from source data. Please assign the specific concept_ids listed in the table below to these observations as observation_concept_ids. Non-standard PCORnet concepts require concepts that have been entered into an OMOP-generated vocabulary (OMOP provided vocabulary_id ='PCORNet').

NOTE: DRG and DRG Type require special logic/processing described below.

- Admitting source (Inpatient and outpatient visit types where available)
- Discharge disposition (Inpatient and outpatient visit types where available)
- Discharge status (Inpatient and outpatient visit types where available)
- DRG (requires special logic - see Note 1 below)
- Tobacco Information (see Note 4)

Use the following table to populate observation_concept_ids for the observations listed above. The vocabulary column is used to highlight non-standard codes from vocabulary_id='Observation Type' and vocabulary_id='PCORNet' and one newly added standard concept from vocabulary_id='SNOMED'.

**Table 1: Observation concept IDs for PCORnet concepts. The vocabulary id 'PCORNet' contains concept specific to PCORNet requirements and standards.**

Concept Name | Observation concept ID | Vocab ID | Value as concept ID | Concept description | Vocab ID| PCORNet Mapping
 --- | --- | --- | --- | --- | ---| ---
Admitting source | 4145666 | | 44814670 | Adult Foster Home
Admitting source | 4145666 | | 44814671 | Assisted Living Facility
Admitting source | 4145666 | | 44814672 | Ambulatory Visit
Admitting source | 4145666 | | 8870 | Emergency Department
Admitting source | 4145666 | | 44814674 | Home Health
Admitting source | 4145666 | | 44814675 | Home / Self Care
Admitting source | 4145666 | | 8546 | Hospice
Admitting source | 4145666 | | 38004279 | Other Acute Inpatient Hospital
Admitting source | 4145666 | | 44814678 | Nursing Home (Includes ICF)
Admitting source | 4145666 | | 44814679 | Rehabilitation Facility
Admitting source | 4145666 | | 44814680 | Residential Facility | PCORNet
Admitting source | 4145666 | | 8863 | Skilled Nursing Facility
Admitting source | 4145666 | | 44814650 | No information | PCORNet
Admitting source | 4145666 | | 44814653 | Unknown | PCORNet
Admitting source | 4145666 | | 44814649 | Other | PCORNet
Discharge disposition (See Note 3) | 44813951 | SNOMED | 4161979 | Discharged alive
Discharge disposition | 44813951 | SNOMED | 4216643 | Expired
Discharge disposition | 44813951 | SNOMED | 44814650 | No information | PCORNet
Discharge disposition | 44813951 | SNOMED | 44814653 | Unknown | PCORNet
Discharge disposition | 44813951 | SNOMED | 44814649 | Other | PCORNet
Discharge status (see Note 3) | 4137274 | | 38004205 | Adult Foster Home
Discharge status | 4137274 | | 38004301 | Assisted Living Facility
Discharge status | 4137274 | | 4021968 | Against Medical Advice
Discharge status | 4137274 | | 44814693 | Absent without leave | PCORNet
Discharge status | 4137274 | | 4216643 | Expired
Discharge status | 4137274 | | 38004195 | Home Health
Discharge status | 4137274 | | 8536 | Home / Self Care
Discharge status | 4137274 | | 8546 | Hospice
Discharge status | 4137274 | | 38004279 | Other Acute Inpatient Hospital
Discharge status | 4137274 | | 8676 | Nursing Home (Includes ICF)
Discharge status | 4137274 | | 8920 | Rehabilitation Facility
Discharge status | 4137274 | | 44814701 | Residential Facility | PCORNet
Discharge status | 4137274 | | 8717 | Still In Hospital
Discharge status | 4137274 | | 8863 | Skilled Nursing Facility
Discharge status | 4137274 | | 44814653 | Unknown | PCORNet
Discharge status | 4137274 | | 44814649 | Other | PCORNet
Discharge status | 4137274 | | 44814650 | No information | PCORNet
Tobacco |4005823| |4005823 |Tobacco User | | 01 = Current user
Tobacco |4005823| |45765920 |  Never used Tobacco| |02 = Never
Tobacco |4005823| |45765917|  Ex-tobacco user| |03 = Quit/Former Smoker
Tobacco |4005823| |4030580 | Non-smoker's second hand smoke syndrome| |04 = Passive or environmental exposure
Tobacco |4005823| |2000000040 ||| 06 = Not asked
Tobacco |4005823| |44814650 |No information | PCORNet | NI
Tobacco |4005823| |44814653| Unknown| PCORNet | OT
Tobacco |4005823| |44814649| Other| PCORNet| UN
Tobacco Type |4219336 |Multiple Response allowed |4298794 |Smoker | | 01 = Smoked tobacco only
Tobacco Type |4219336 |Multiple Response allowed |4224317 |Pipe smoking tobacco | | 01 = Smoked tobacco only
Tobacco Type |4219336 |Multiple Response allowed |4282779 |Cigarette smoking tobacco | | 01 = Smoked tobacco only
Tobacco Type |4219336 | Multiple Response allowed|4132133 |Cigar smoking tobacco | | 01 = Smoked tobacco only
Tobacco Type |4219336 |Multiple Response allowed |4218197 |Snuff tobacco | | 02 = Non-smoked tobacco only
Tobacco Type |4219336 | Multiple Response allowed|4219234 |Chewing tobacco | | 02 = Non-smoked tobacco only
Tobacco Type |4219336 | |45765920 |Never used tobacco | | 04 = None
Tobacco Type |4219336 | |45765917 |Ex tobacco user | | 04 = None
Tobacco Type |4219336 | |4030580 | Non-smoker's second hand smoke syndrome| |04 = Passive or environmental exposure/None
Tobacco Type |4219336 | | 44814650 |No information | PCORNet| NI
Tobacco Type |4219336 | |44814653| Unknown| PCORNet | OT
Tobacco Type |4219336 | |44814649| Other| PCORNet| UN
Smoking |4275495 | |42709996 |Smokes tobacco daily| | 01 = Current everyday smoker
Smoking |4275495 | |2000000039|Occasional tobacco smoker - SNOMED International Code|PEDSNet | 02 = current some day smoker
Smoking |4275495 | |4310250|Ex-smoker| | 03 = Former smoker
Smoking |4275495 | |4144272|Never smoked tobacco| | 04 = Never smoker
Smoking |4275495 | |4298794|Smoker| | 05 = Smoker, current status unknown
Smoking |4275495 | |4141786|Tobacco smoking consumption(status) unknown| | 06 = Unknown if ever smoked
Smoking |4275495 |**USE AS DEFAULT FOR CATEGORY** |4044778|Chain smoker | | 07 = Heavy tobacco smoker
Smoking |4275495 | |4209006|Heavy smoker (over 20 per day)| | 07 = Heavy tobacco smoker
Smoking |4275495 |**USE ONLY IF QUANTITY OF CIGARETTES IS KNOWN** |4209585|Moderate smoker (20 or less per day)| | 08 = Light tobacco smoker
Smoking |4275495 | | 44814650 |No information | PCORNet| NI
Smoking |4275495 | |44814653| Unknown| PCORNet | OT
Smoking |4275495 | |44814649| Other| PCORNet| UN



**Note 1**: For DRG, use the following logic (must use vocabulary version 5):

- The DRG value must be three digits as text. Put into value_as_string in observation
- For all DRGs, set observation_concept_id = 3040464 (hospital discharge DRG)
- To obtain correct value_as_concept_id for the DRG:
    - If the date for the DRG \< 10/1/2007, use concept_class_id = "DRG", invalid_date = "9/30/2007", invalid_reason = 'D' and the DRG value=CONCEPT.concept_code to query the CONCEPT table for correct concept_id to use as value_as_concept_id.
    - If the date for the DRG \>=10/1/2007, use concept_class_id = "MS-DRG", invalid_reason = NULL and the DRG value = CONCEPT.concept_code to query the CONCEPT table for the correct concept_id to use as value_as_concept_id.
- If your site has **APR-DRGs** please include these in the observation table. We have requested the APR-DRG vocabulary to be incorporated as apart of the OMOP standard vocabulary. 

**Note 2:** 
- For each inpatient encounter or in some cases the outpatient encounter, there can be 1 admit source, 1 discharge disposition, 1 discharge status, 1 or more DRG
  (May not be 1:1:1:1 if patients still admitted (therefore no discharge disposition, discharge details or DRG yet))
- There should **NOT** be discharges without admission.
- For each emergency dept (ED) encounters, these 4 records *may* also be populated but this is *optional*.
- For outpatient encounters (OT, OA), these 4 records may be populated

**Note 3:** Please provide tobacco information from the primary source of data capture at your site. If tobacco information is available at the visit level, please provide this information. If it is not, sites are welcomed to make a high level assertion about tobacco use and tobacco type information for individuals in the cohort.

<a name="observation-note-4"/>**Note 4:** Below are examples of how the observation table and the fact relationship table would be populated for tobacco, smoking and tobacco type scenarios. In the case where tobacco information is recorded at a visit but there is missing information for tobacco, smoking or tobacco type please assert. The PEDSnet standard relationship concept id for linking tobacco items will be *0*. This concept id was chosen as there was not a specific concept id that exists in the standard vocabulary that adequately defined an appropriate relationship for linking the tobacco items.

*Example 1:*

Patient 1 smokes 5 cigarettes per day and does not use non-smoked tobacco

Observation table:

Observation ID|	Person ID|	Observation concept id|	Value as concept id
---|---|---|---
0001|	1|	4005823|	4005823
0002|	1|	4219336|	4282779
0003|	1|	4275495|	4209585


Fact relationship:

Domain_concept_id_1|	Fact_id_1|	Domain_concept_id_2|	Fact_id_2	|relationship_concept_id
---|---|---|---|---
27|	0001|	27	|0002	|0
27 |0001|	27|	0003|	0

*Example 2:*
Patient 2 smokes 25-40 cigarettes per day and also chews tobacco

Observation table:

Observation ID|	Person ID|	Observation concept id|	Value as concept id
---|---|---|---
0004|	2|	4005823|	4005823
0005|	2|	4219336	|4282779
0006|	2|	4219336	|4219234
0007|	2|	4275495	|4209006

Fact relationship:

Domain_concept_id_1|	Fact_id_1|	Domain_concept_id_2|	Fact_id_2	|relationship_concept_id
---|---|---|---|---
27	|0004|	27	|0005|	0
27|	0004|	27	|0006|	0
27|	0004|	27	|0007|	0

*For more examples, or if you have a specific scenario that you have a question about, please contact the DCC.*

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
observation_id | Yes |Yes| Integer |  A unique identifier for each observation. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field
person_id | Yes |Yes| Integer | A foreign key identifier to the person about whom the observation was recorded. The demographic details of that person are stored in the person table.|
observation_concept_id | Yes |Yes| Integer | A foreign key to the standard observation concept identifier in the Vocabulary. | Lab results and vitals are not stored in this table in V5 but are stored in the Measurement table.
observation_date | Yes |Yes| Date | The date of the observation. | No date shifting.  Full date and time. If there is no time associated with the date assert midnight.
observation_time | No |Provide When Available| Datetime | The time of the observation. | No date shifting.  Full date and time. If there is no time associated with the date assert midnight.
observation_type_concept_id | Yes |Yes| Integer | A foreign key to the predefined concept identifier in the Vocabulary reflecting the type of the observation. | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id ='Observation Type')</p> <p>select \* from concept where vocabulary_id = 'Observation Type' yields 11 valid concept_ids.</p> FOR PEDSnet CDM v2.3, all of our observations are coming from electronic health records so *set this field to concept_id = 38000280* (observation recorded from EMR). When we get data from patients, we will include the concept_id = 44814721
value_as_number |No (see convention) |Provide When Available| Float | The observation result stored as a number. This is applicable to observations where the result is expressed as a numeric value. | Value must be represented as at least one of {value_as_number, value_as_string or values_as_concept_id}. There are a few exceptions in vocabulary id PCORNet where all three value_as_\* fields are NULL.
value_as_string | No (see convention) | Provide When Available|Varchar | The observation result stored as a string. This is applicable to observations where the result is expressed as verbatim text. | Value must be represented as at least one of {value_as_number, value_as_string or values_as_concept_id}. There are a few exceptions in vocabulary id PCORNet where all three value_as_\* fields are NULL.
value_as_concept_id | No (see convention) |Provide When Available| Integer | A foreign key to an observation result stored as a concept identifier. This is applicable to observations where the result can be expressed as a standard concept from the Vocabulary (e.g., positive/negative, present/absent, low/high, etc.). | Value must be represented as at least one of {value_as_number, value_as_string or values_as_concept_id}. There are a few exceptions in vocabulary id PCORNet where all three value_as_\* fields are NULL.
qualifier_concept_id | No |Provide When Available| Integer | A foreign key to standard concept identifier for a qualifier (e.g severity of drug-drug interaction alert) | <p>Predefined value set (valid concept_ids found in CONCEPT table where domain_id='Observation' and concept_class_id ='Qualifier Value')</p> <p>select \* from concept where domain_id='Observation' and concept_class_id ='Qualifier Value' yields 10496 valid concept_ids.</p> <p>If none are correct, use concept_id = 0.</p>
unit_concept_id | No | Provide When Available|Integer | A foreign key to a standard concept identifier of observation units in the Vocabulary. | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where domain_id='Unit' and vocabulary_id ='UCUM')</p> <p>select \* from concept where domain_id='Unit' and vocabulary_id ='UCUM' yields 971 valid concept_ids.</p> <p>If none are correct, use concept_id = 0.</p>
provider_id | No | Provide When Available|Integer | A foreign key to the provider in the provider table who was responsible for making the observation.
visit_occurrence_id | No |Provide When Available| Integer | A foreign key to the visit in the visit table during which the observation was recorded.
observation_source_value | No |Provide When Available| Varchar | The observation code as it appears in the source data. This code is mapped to a standard concept in the Vocabulary and the original code is, stored here for reference.
observation_source_concept_id| No |Provide When Available|Integer | A foreign key to a concept that refers to the code used in the source. | <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>
unit_source_value | No |Provide When Available| Integer | The source code for the unit as it appears in the source data. This code is mapped to a standard unit concept in the Vocabulary and the original code is, stored here for reference.
qualifier_source_value |No |Provide When Available| Varchar | The source value associated with a qualifier to characterize the observation

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.9.1 Additional Notes

- The 1/1/2009 date limitation that is used to define a PEDSnet active patient is \*\*NOT\*\* applied to observations. All observations are included for an active patient. For PEDSnet CDM v2.3, we limit observations to only those that appear in Table 1.
- Observations have a value represented by one of a concept ID, a string, \*\*OR\*\* a numeric value.
- The Visit during which the observation was made is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
- The Provider making the observation is recorded through a reference to the PROVIDER table. This information is not always available.
- Observations obtained using standardized methods (e.g. laboratory assays) that produce discrete results are recorded by preference in the MEASUREMENT table.

## 1.10 OBSERVATION PERIOD

The observation period domain is designed to capture the time intervals in which data are being recorded for the person. An observation period is the span of time when a person is expected to have a clinical fact represented in the PEDSNet version 2.3 data model. This table is used to generate the PCORnet CDM enrollment table.

While analytic methods can be used to calculate gaps in observation periods that will generate multiple records (observation periods) per person, for PEDSnet, the logic has been simplified to generate a single observation period row for each patient. This logic can be found [here] (https://github.com/PEDSnet/dcc-loader/blob/master/load-data/generate_obs_period.psql)

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
Observation_period_id | Yes |Yes| Integer | A system-generate unique identifier for each observation period | This is not a value found in the EHR. Sites may choose to use a sequential value for this field.
person_id | Yes |Yes| Integer | A foreign key identifier to the person who is experiencing the condition. The demographic details of that person are stored in the person table.
Observation_period_start_date | Yes |Yes| Date | The start date of the observation period for which data are available from the data source | <p>Use the earliest clinical fact date available for this patient.</p> No date shifting.  
Observation_period_end_date | Yes | Yes|Date | The end date of the observation period for which data are available from the source. | <p>Use the latest clinical fact date available for this patient. If there exists one or more records in the DEATH table for this patient, use the latest date recorded in that table.</p> 
Observation_period_start_time | Yes | Yes|Datetime | The start date of the observation period for which data are available from the data source | <p>Use the earliest clinical fact time available for this patient.</p> No date shifting.  Full date and time. **If there is no time associated with the date assert midnight for the start time**
Observation_period_end_time | Yes |Yes| Datetime | The end date of the observation period for which data are available from the source. | <p>Use the latest clinical fact time available for this patient. If there exists one or more records in the DEATH table for this patient, use the latest date recorded in that table.</p> For patients who are still in the hospital or ED or other facility at the time of data extraction, leave this field NULL.  Full date and time.  **If there is no time associated with the date assert 11:59:59 pm for the end time**

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.10.1 Additional Notes

- Because the 1/1/2009 date limitation for "active patients" is not used to limit visit_occurrence, the start_date of an observation period for an active PEDSnet patient may be prior to 1/1/ 2009.


## 1.11 DRUG EXPOSURE

The drug exposure domain captures any biochemical substance that is introduced in any way to a patient. This can be evidence of prescribed, over the counter, administered (IV, intramuscular, etc), immunizations or dispensed medications. These events could be linked to procedures or encounters where they are administered or associated as a result of the encounter.

EHRs may store medications in different vocabularies (GPI,NDC etc). 

Exclusions:

1. Cancelled Medication Orders
2. Missed Medication administrations

**Note 1**: The `effective_drug_dose` is the dose basis.(E.g. 45 mg/kg/dose). This is the discrete dose value from the source data if available. If the discrete dose value is **not** available from the source data, then compute the dose basis by looking for a weight observation **+/- 60 days of the date of the medication**. (E.g. Total Amount/**(divided by)**Weight) (Dose per kg)

The dose_unit_concept_id is the unit of the effective dose.

Please use the following logic to populate the effective_dose and dose unit based on what is available in your source system:

Site Information | Effective Drug Dose | Dose Unit Concept Id  | Dose Unit Source Value
--- | --- | --- | ---
Pre-calculated effective dose available  (E.g. 90 mg/kg) | 90 | Corresponding concept for unit (E.g. mg/kg = 9562)| mg/kg
Site is able to compute effective dose (E.g. Dose 500 mg and  Available Weight +/- 60 days is 54.43 kg) | 9.18 | Corresponding concept for unit (E.g. mg/kg = 9562) | mg
Site is not able to compute effective dose( E.g. Site Only has dose (E.g. 450 mg)) | 450 | Corresponding Concept for unit (E.g. mg = 8576) |mg
No discrete dosing information | | 0|
 

**Note 2**: The quantity is the actual dose given. (E.g. 450 mg for 10 kg patient) Extract numbers as much as possible , full value should be a part of the xml sig field.

**Note 3**: For dispensing records, compute the dose basis by looking for a weight observation +/- 60 days of the dispensed date.

**Note 4:** For the sig, encode the value using XML. 

<ul> <li> Element 1: Actual SIG from source data </li> <li> Element 2: Raw "Supply/Quantity" (Examples: "1 bottle" "10 ml Bottle" "1 pack"</li> <li>Element 3: Refills</li></ul>

```xml
    <XML>
    <SIG>1/2 capful in 4 oz clear liquid</SIG>
    <QUANTITY>1 jar</QUANTITY>
    <REFILLS>2</REFILLS>
    </XML>
```
**Note 5:** If there are multiple RxNorm mappings associate with a mapping, choose the mapping in the following order and stop when you find your first match.

1. SBD
2. SCD
3. MIN
4. PIN
5. IN

**Note 6**: Please use the following table as a guide to determine how to populate the `drug_source_value`, `drug_source_concept_id` and `drug_concept_id` for Drug Exposure Values

You have in your source system | Drug_source_value| Drug_source_conept_id | Drug_concept_id
---|---|---|---
Drug code is GPI/Multum/Other code | <ul><li> GPI/Multum/Other Code</li><li>Local name \| GPI/Multum/Other</li></ul> (any above are OK) | OMOP’s concept_id for GPI/Multum/Other code | RxNorm code that corresponds to a mapping from `concept_relationship`
Drug code is RxNorm | <ul><li> RxNorm Code</li><li>Local name or</li><li>Local name \| RxNorm code</li></ul> (any above are OK) |Corresponding RxNorm concept_id mapping| Corresponding RxNorm concept_id mapping|

**Note 7**: For medication administration events, please store all events as single drug exposure entries.


Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
 drug_exposure_id | Yes |Yes| Integer | A system-generated unique identifier for each drug exposure | This is not a value found in the EHR. Sites may choose to use a sequential value for this field.
person_id | Yes |Yes|Integer | A foreign key identifier to the person who is experiencing the condition. The demographic details of that person are stored in the person table.
drug_concept_id| Yes |Yes| Integer | A foreign key that refers to a standard drug concept identifier in the Vocabulary. | Valid drug concept IDs are mapped to RxNorm using the source to concept map table to transform source codes (GPI, NDC etc to the RxNorm target). In the event of multiple RxNorm mappings please see Note 5. See note 6 for guide.
drug_exposure_start_date| Yes |Yes| Date |The start date of the utilization of the drug. The start date of the prescription, the date the prescription was filled, the date a drug was dispensed or the date on which a drug administration procedure was recorded are acceptable. | If the start date of the drug is null in the source system, use the ordering date as the start date. No date shifting. 
drug_exposure_end_date| No |Provide When Available|Date | The end date of the utilization of the drug | No date shifting.
drug_exposure_order_date| No | Provider When available| Date | The order date of the drug | No date shifting.
drug_exposure_start_time| Yes |Yes| Datetime |The start date and time of the utilization of the drug. The start date of the prescription, the date the prescription was filled, the date a drug was dispensed or the date on which a drug administration procedure was recorded are acceptable. | No date shifting. Full date and time. **If there is no time associated with the date assert midnight for the start time**|
drug_exposure_end_time| No |Provide When Available|Datetime | The end date and time of the utilization of the drug | No date shifting. Full date and time.  **If there is no time associated with the date assert 11:59:59 pm for the end time**|
drug_exposure_order_time| No | Provider When available| Datetime | The order date and time of the drug |If the start datetime of the drug is null in the source system, use the ordering datetime as the start datetime. No date shifting.Full date and time. **If there is no time associated with the date assert midnight for the start time**
drug_type_concept_id| Yes | Yes|Integer | A foreign key to a standard concept identifier of the type of drug exposure in the Vocabulary as represented in the source data | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where concept_class_id ='Drug Type')</p> <p>select \* from concept where domain_id ='Drug Type' yields 13 valid concept_ids.</p> <p>If none are correct, use concept_id = 0.</p> For the PEDSnet drug types listed above, use the following concept_ids: <ul><li>Prescription dispensed in pharmacy (dispensed meds pharma information): concept_id = 38000175</li> <li>Inpatient administration (MAR entries): concept_id = 38000180</li> <li>Prescription written: concept_id = 38000177</li></ul>
stop_reason| No | Provide When Available|Varchar | The reason, if available, where the medication was stopped, as indicated in the source data. | <p>Valid values include therapy completed, changed, removed, side effects, etc. Note that a stop_reason does not necessarily imply that the medication is no longer being used at all, and therefore does not mandate that the end date be assigned.</p>
refills| No | Provide When Available|Integer | The number of refills after the initial prescription| See Note 2. Extract numbers as much as possible , full value should be a part of the xml sig field.|
quantity| No |Provide When Available| Integer | The quantity of the drugs as recorded in the original prescription or dispensing record| See Note 2. Extract numbers as much as possible , full value should be a part of the xml sig field.|
days_supply| No |Provide When Available| Integer | The number of days of supply the medication as recorded in the original prescription or dispensing record||
sig| No | Provide When Available|CLOB (XML Structure) | The directions on the drug prescription as recorded in the original prescription (and printed on the container) or the dispensing record| See Note 4|
route_concept_id| No |Provide When Available| Integer | A foreign key that refers to a standard administration route concept identifier in the Vocabulary. | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where domain_id='Route')</p> <p>select * from concept where domain_id='Route' and invalid_reason is null and standard_concept='S' yields 22 valid concept_ids.</p> <p>If none are correct, use concept_id = 0.</p>
effective_drug_dose| No |Provide When Available| Float | Numerical value of drug dose for this drug_exposure record| See note 1|
eff_drug_dose_source_value| No |Provide When Available| Varchar | The drug dose for this drug_exposure record as it appears in the source| |
dose_unit_concept_id| No |Provide When Available| Integer | A foreign key to a predefined concept in the Standard Vocabularies reflecting the unit the effective drug_dose value is expressed|<p>**See note 1**</p> <p> Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = UCUM)</p> select * from concept where vocabulary_id = 'UCUM' yields 971 valid concept_ids.|
lot_number| No |Site preference| Varchar | An identifier to determine where the product originated||
provider_id| No |Provide When Available|  Integer | A foreign key to the provider in the provider table who initiated (prescribed) the drug exposure |<p>Any valid provider_id allowed (see definition of providers in PROVIDER table)</p> Document how selection was made.
visit_occurrence_id| No |Provide When Available|  Integer | A foreign key to the visit in the visit table during which the drug exposure initiated. | See VISIT.visit_occurrence_id (primary key)
drug_source_value| No|Provide When Available|  Varchar | The source drug value as it appears in the source data. The source is mapped to a standard RxNorm concept and the original code is stored here for reference.| Please be sure to include your source code and the drug name in this field. This will be useful in the event that there is no RxNorm mapping for your local medication code. Please use the pipe delimiter "\|" when concatenating values. See note 6.
drug_source_concept_id| No |Provide When Available|  Integer | A foreign key to a drug concept that refers to the code used in the source | In this case, if you are transforming drugs from GPI or NDC to RXNorm. The concept id that corresponds to the GPI or NDC value for the drug belongs here. See note 6.  <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>
route_source_value| No|Provide When Available|  Varchar |The information about the route of administration as detailed in the source ||
dose_unit_source_value| No|Provide When Available|  Varchar | The information about the dose unit as detailed in the source ||
frequency| No | Optional | Varchar | The frequency information as available from the source ||

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.11.1 Additional Notes

- The 1/1/2009 date limitation that is used to define a PEDSnet active patient is \*\*NOT\*\* applied to drug exposures. All drug exposures are included for an active patient. 
- The Visit during which the drug exposure was initiated by is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
- The Provider initiating the drug exposure is recorded through a reference to the PROVIDER table. This information is not always available.

## 1.12 MEASUREMENT

The measurement domain captures measurement orders and measurement results. The measurement domain can contain laboratory results and vital signs.

Specifically this table includes:
- Height/length in cm (use numeric precision as recorded in EHR)
- Height/length type
- Weight in kg (use numeric precision as recorded in EHR)
- Temperature in degrees Celsius
- Head Circumference in cm (use numeric precision as recorded in EHR)
- FVC in liters
- FVC pre (if recorded differently) in liters
- FVC post in liters
- FEV 1 in liters
- FEV 1 pre (if recorded differently) in liters
- FEV 1 post in liters
- FEF 25-75 in liters per minute
- FEF 25-75 pre (if recorded differently) in liters per minute
- FEF 25-75 post in liters per minute
- Peak Flow (PF) in milliteres per second
- Peak Flow post in milliteres per second
- Body mass index in kg/m<sup>2</sup> (extracted only if height and weight are not present)
- Systolic blood pressure in mmHg
    - Where multiple readings are present on the same encounter, create measurement records for \*\*ALL\*\* readings
- Diastolic blood pressure in mmHg
    - Where multiple readings are present on the same encounter, create measurement records for \*\*ALL\*\* readings
- Blood pressure position is described by the selection of a concept_id that contains the BP position as describe below. For example, in Table 1, concept_id 3018586 is Systolic Blood Pressure, Sitting. This concept_id identifies both the measurement (Systolic BP) and the BP position (sitting).
- Vital source
- Component Level Labs. The Lab Listing and PEDSNet LOINC Mapping can be found [here] (https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_Component_Loinc_Mapping.xlsx)

**Table 3: Measurement concept IDs for PCORnet concepts. Concept_ids from vocabulary_id 99 are non-standard codes.**

Domain id | Observation concept ID | Vocab ID | Value as concept ID | Concept description | Vocab ID
 --- | --- | --- | --- | --- | ---
Vital | 3013762 | | See Note 1 | Weight
Vital | 3023540 | | See Note 1 | Height
Vital | 3034703 | | See Note 2 | Diastolic Blood Pressure - Sitting
Vital | 3019962 | | See Note 2 | Diastolic Blood Pressure - Standing
Vital | 3013940 | | See Note 2 | Diastolic Blood Pressure - Supine
Vital | 3012888 | | See Note 2 | Diastolic BP Unknown/Other
Vital | 3018586 | | See Note 2 | Systolic Blood Pressure - Sitting
Vital | 3035856 | | See Note 2 | Systolic Blood Pressure - Standing
Vital | 3009395 | | See Note 2 | Systolic Blood Pressure - Supine
Vital | 3004249 | | See Note 2 | Systolic BP Unknown/Other
Vital | 2000000041 | | See Note 3 | Weight for age z score NHANES
Vital | 2000000042 | | See Note 3 | Height for age z score NHANES
Vital | 2000000043 | | See Note 3 | BMI for age z score NHANES
Vital | 2000000044 | | See Note 3 | Weight for age z score WHO
Vital | 2000000045 | | See Note 3 | Height for age z score WHO
Vital | 2000000046 | | See Note 3 | Systolic BP for age/height Z score NCBPEP
Vital | 2000000047 | | See Note 3 | Diastolic BP for age/height Z score NCBPEP
Vital | 3020891 || See Note 1 | Temperature 
Vital | 3001537|| See Note 1| Head Circumference
Vital | 3020158|| See Note 1|  FVC
Vital | 3037879|| See Note 1|  FVC pre (if recorded differently)
Vital | 3001668|| See Note 1|  FVC post
Vital | 3024653|| See Note 1| FEV 1
Vital | 3005025|| See Note 1|  FEV 1 pre (if recorded differently)
Vital | 3023550|| See Note 1|  FEV 1 post
Vital | 42868460|| See Note 1|  FEF 25-75
Vital | 42868461|| See Note 1|  FEF 25-75 pre (if recorded differently)
Vital | 42868462|| See Note 1|  FEF 25-75 post
Vital | 3023329|| See Note 1|  Peak Flow (PF)
Vital | 2000000064|| See Note 1|  Peak Flow post
Measurement Type | 44818704 | Measurement Type | See Note 3 | Patient reported
Measurement Type | 2000000032| Measurement Type | See Note 3 | Vital sign from device direct feed
Measurement Type | 2000000033| Measurement Type | See Note 3 | Vital sign from healthcare delivery setting
Measurement Type | 44818702| Measurement Type | See Note 4 | Lab Result

**Note 1**: For height, weight, temperature, head circumference, BMI and Pulmary Function measurements, insert the recorded measurement into the value_as_number field.

<a name="measurement-note-2"/>**Note 2**: Systolic and diastolic pressure measurements will generate two observation records one for storing the systolic blood pressure measurement and a second for storing the diastolic blood pressure measurement. Select the right SBP or DBP concept code that also represents the CORRECT recording position (supine, sitting, standing, other/unknown). To tie the two measurements together (the systolic BP measurement and the diastolic BP measurement records), use the FACT_RELATIONSHIP table.

Example: Person_id = 12345 on visit_occurrence_id = 678910 had orthostatic blood pressure measurements performed in the healthcare delivery setting as follows:

- Supine: Systolic BP 120; Diastolic BP 60
- Standing: Systolic BP 144; Diastolic BP 72

Four rows will be inserted into the measurement table. Showing only the relevant columns:

Measurement_id | Person_id | Visit_occurrence_id | measurement_concept_id | measurement_type_concept_id | Value_as_Number | Value_as_Concept_ID
 --- | --- | --- | --- | --- | --- | --- | ---
66661 | 12345 | 678910 | 3009395 | 2000000033| 120 | |
66662 | 12345 | 678910 | 3013940 | 2000000033 | 60 | |
66663 | 12345 | 678910 | 3035856 | 2000000033 | 144 | |
66664 | 12345 | 678910 | 3019962 | 2000000033 | 72 | |

- Measurement_concept_id = 3009395 = systolic BP - supine; measurement_concept_id = 3013940 = diastolic BP supine
- Measurement_concept_id = 3035856 = systolic BP standing; measurement_concept_id = 3019962 = diastolic BP standing
- measurement_type_concept_id = 2000000033 (Vital Sign from healthcare delivery setting).

To link these two values, use the fact relationship table:

Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
Measurement | 66661 | Measurement | 66662 |  Asso with finding 
Measurement | 66662 | Measurement | 66661 |  Asso with finding 
Measurement | 66663 | Measurement | 66664 |  Asso with finding 
Measurement | 666624 | Measurement | 66663 |  Asso with finding 

Because the domain concept id and relationship concept id are integers the following is an example of how this data will be represented:

Domain_concept_id_1 | fact_id_1 | Domain_concept_id_2 | fact_id_2 | relationship_concept_id
--- | --- | --- | --- | ---
21 | 66661 | 21 | 66662 |  44818792 
21 | 66662 | 21 | 66661 |  44818792 
21 | 66663 | 21 | 66664 |  44818792 
21 | 666624 | 21 | 66663 | 44818792


- Two rows in the FACT_RELATIONSHIP table link the *supine*  diastolic BP to the supine systolic BP.
- Two rows in the FACT_RELATIONSHIP table link the *standing* diastolic BP to the standing systolic BP.

**Note 3**: Measurement type concept_ids are used as values for the measurement_type_concept_id field.
In addition, the following observations are derived via the DCC (concept_ids to be assigned in future version of this document. However, concept_ids are not needed for ETL since these observations will be derived/calculated using scripts developed by DCC):

- Body mass index in kg/m<sup>2</sup> if not directly extracted
- Height/length z score for age/sex using NHANES 2000 norms for measurements at which the person was <240 months of age. In the absence of a height/length type for the measurement, recumbent length is assumed for ages \<24 months, and standing height thereafter.
- Weight z score for age/sex using NHANES 2000 norms for measurements at which the person was \<240 months of age.
- BMI z score for age/sex using NHANES 2000 norms for visits at which the person was between 20 and 240 months of age.
- Systolic BP z score for age/sex/height using NHBPEP task force fourth report norms.
- Diastolic BP z score for age/sex/height using NHBPEP task force fourth report norms.

**Note 4**: Please use the following table as a guide to determine how to populate the `measurement_source_value`, `measurement_source_concept_id` and `measurement_concept_id` for LAB Values

You have in your source system | Measurement_source_value| Measurement_source_concept_id | measurement_concept_id
---|---|---|---
Lab code is institutional-specific code (not CPT/not LOINC) |<ul><li> Local code or</li><li>Local name or</li><li>Local code \| Local name</li></ul> (any above are OK) | 0 (zero) | PEDSnet LOINC code’s concept_id (provided by DCC)
Lab code is CPT code | <ul><li> CPT Code</li><li>Local name or</li><li> Local name \|CPT code</li></ul> (any above are OK) | OMOP’s concept_id for CPT code | PEDSnet’s LOINC code’s concept_id (provided by DCC)
Lab code is LOINC code that is same as PEDSnet’s LOINC code | <ul><li> LOINC Code</li><li>Local name or</li><li> Local name \| LOINC code  </li></ul> (any above are OK) |PEDSnet’s LOINC code’s concept_id (provided by DCC)| PEDSnet’s LOINC code’s concept_id (provided by DCC)
Lab code is LOINC code that is different than PEDSnet LOINC | Same as above | OMOP’s concept_id for your LOINC code | PEDSnet’s LOINC code’s concept_id (provided by DCC)

**Note 5**: Please use the following table as a guide to determine how to populate the `range_low`,`range_low_source_value`,`range_low_operator_concept_id`, `range_high`, `range_high_source_value` and `range_low_operator_concept_id` for LAB Values

You have in your source system | range high/ range low | range high source value / range low source value | range low/high operator concept id
--- | --- | ---| ---
Numerical value `Examples: 7,8.2,100` | Numerical Value `Examples: 7,8.2,100` | Numerical value `Examples: 7,8.2,100`|0
Limits `Examples: <2, >100, less than 5` | Numerical Value of the limit `Examples: 2, 100, 5`| Limits `Examples: <2, >100, less than 5` | Corresponding concept to the modifier `Examples:4171756,4172704 ,4171756 `
Categorical/Qualitative Value `Examples: HIGH,LOW,POSITIVE,NEGATIVE`||Categorical/Qualitative Value `Examples: HIGH,LOW,POSITIVE,NEGATIVE`|0

**Note 6**: Please only include final Lab Results.

Exclusions:

1. Cancelled Lab orders
2. Lab orders that are 'NOT DONE' or 'INCOMPLETE'

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
measurement_id | Yes |Yes|  Integer | A system-generated unique identifier for each measurement | This is not a value found in the EHR. Sites may choose to use a sequential value for this field.
person_id | Yes |Yes|  Integer | A foreign key identifier to the person who the measurement is being documented for. The demographic details of that person are stored in the person table.
measurement_concept_id | Yes |Yes|  Integer | A foreign key to the standard measurement concept identifier in the Vocabulary. | <p>Valid Measurement Concepts belong to the "Measurement" domain. Measurement Concepts are based mostly on the LOINC vocabulary, with some additions from SNOMED-CT.</p> <p>Measurement must have an object represented as a concept, and a finding. A finding (see below) is represented as a concept, a numerical value or a verbatim string or more than one of these.</p> <p>There are three Standard Vocabularies defined for measurements:</p> <p>Laboratory tests and values: Logical Observation Identifiers Names and Codes (**LOINC**) (Vocabulary_id=LOINC).</p> <p>(FYI: Regenstrief also maintains the **"LOINC Multidimensional Classification"** Vocabulary_id=LOINC Hierarchy)</p> <p>Qualitative lab results: A set of SNOMED-CT Qualifier Value concepts (vocabulary_id=SNOMED)</p> <p>Laboratory units: Unified Code for Units of Measure (**UCUM**( )Vocabulary_id=UCUM)</p> <p>All other findings and observables: SNOMED-CT (Vocabulary_id=SNOMED).</p> For vital signs, pull information from flow sheet rows (EPIC sites only). For lab values, please see Note 4.
measurement_date|  Yes |Yes|  Date | The date of the measurement.|For lab orders, this should be the specimen collection time. No date shifting.
measurement_time|  Yes |Yes|  Datetime | The time of the measurement. | For lab orders, this should be the specimen collection time. No date shifting.  Full date and time. If there is no time associated with the date assert midnight.
measurement_order_date| No| Provide When Available| Date | This field applies to Lab Orders only. This is the date the lab was ordered in the source. | No date shifting.
measurement_order_time| No| Provide When Available| Datetime | This field applies to Lab Orders only. This is the time the lab was ordered in the source. | No date shifting. Full date and time. If there is no time associated with the date assert midnight.
measurement_result_date| No | Provide When Available| Date | This field applies to Lab Orders only. This is the date the lab resulted in the source. | No date shifting.
measurement_result_time| No| Provide When Available| Datetime | This field applies to Lab Orders only. This is the time the lab resulted in the source. | No date shifting. Full date and time. If there is no time associated with the date assert midnight.
measurement_type_concept_id | Yes |Yes|  Integer | A foreign key to the predefined concept identifier in the Vocabulary reflecting the type of the measurement. | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id =Meas Type)</p> <p>select \* from concept where vocabulary_id ='Meas Type' or domain_id='Meas Type' yields 7 valid concept_ids.</p> For Pedsnet CDM v2.3, please use the following: <ul><li>Vital Sign from healthcare delivery setting= 2000000033</li><li>Vital Sign from healthcare device= 2000000032</li><li>Lab result =  44818702</li><li>Pathology finding = 44818703</li><li>Patient reported value = 44818704</li> <li> Derived Value = 45754907</li></ul> 
operator_concept_id| No|Provide When Available|  Integer | A foreign key identifier to the mathematical operator that is applied to the value_as_number.Operators are <, ≤, =, ≥, >| Valid operator concept id are found in the concept table <p> select \* from concept where domain_id='Meas Value Operator' yields 5 valid concept ids. <ul> <li> Operator <= : 4171754 </li> <li> Operator >= : 4171755      </li> <li> Operator < : 4171756 </li> <li> Operator =   4172703 </li> <li> Operator > : 4172704 </li> </ul>|
value_as_number | No (see convention) | Provide When Available| Float | The measurement result stored as a number. This is applicable to measurements where the result is expressed as a numeric value. | Value must be represented as at least one of {value_as_number, value_as_string or values_as_concept_id}.
value_as_concept_id | No (see convention) |Provide When Available|  Integer | A foreign key to an observation result stored as a concept identifier. This is applicable to observations where the result can be expressed as a standard concept from the Vocabulary (e.g., positive/negative, present/absent, low/high, etc.). | Value must be represented as at least one of {value_as_number, value_as_string or values_as_concept_id}. Valid concepts are found in the concept table <p> select \* from concept where domain_id='Meas Value' yields 86 valid concept ids.</p>
unit_concept_id | No |Provide When Available|  Integer | A foreign key to a standard concept identifier of measurement units in the Vocabulary. | <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = UCUM)</p> <p>select \* from concept where vocabulary_id = 'UCUM' yields 971 valid concept_ids.</p> <p>If none are correct, use concept_id = 0.</p> For the PEDSnet measurements listed above, use the following concept_ids: <ul><li>Centimeters (cm): concept_id = 8582</li> <li>Kilograms (kg): concept_id = 9529</li> <li>Kilograms per square meter (kg/m<sup>2</sup>): concept_id = 9531</li> <li>Millimeters mercury (mmHG): concept_id = 8876</li> <li>degree Celsius (C): 8653</li> <li>Liters (L): 8519 </li><li>Liters per minute (L/min): 8698 </li><li>Milliliters per second (mL/sec): 44777614 </li></ul>
range_low | No | Provide When Available| Float |  The lower limit of the normal range of the measurement. It is not applicable if the observation results are non-numeric or categorical, and must be in the same units of measure as the measurement value.
range_low_source_value | No | Provide When Available| Varchar |  The lower limit of the normal range of the measurement as it appears in the source. | See note 5
range_low_operator_concept_id | No | Optional | Integer|A foreign key to the modifier of lower limit of the normal range of the measurement as it appears in the source as a concept identifier. | See note 5
range_high | No | Provide When Available| Float | The upper limit of the normal range of the measurement. It is not applicable if the observation results are non-numeric or categorical, and must be in the same units of measure as the measurement value.
range_high_source_value | No | Provide When Available| Varchar | The upper limit of the normal range of the measurement as it appears in the source. | See note 5
range_high_operator_concept_id | No | Optional | Integer||A foreign key to the modifier of higher limit of the normal range of the measurement as it appears in the source as a concept identifier. | See note 5
provider_id | No | Provide When Available| Integer | A foreign key to the provider in the provider table who was responsible for making the measurement.
visit_occurrence_id | No |Provide When Available|  Integer | A foreign key to the visit in the visit table during which the observation was recorded.
measurement_source_value | Yes |Yes|  Varchar | The measurement name as it appears in the source data. This code is mapped to a standard concept in the Standardized Vocabularies and the original code is, stored here for reference.| This is the name of the value as it appears in the source system. Please use the pipe delimiter "\|" when concatenating values. For lab values, please see Note 4.
measurement_source_concept_id| No| Provide When Available| Integer | A foreign key to a concept that refers to the code used in the source.| This is the concept id that maps to the source value in the standard vocabulary. <p>**If there is not a mapping for the source code in the standard vocabulary, use concept_id = 0**</p>
unit_source_value| No| Provide When Available| Varchar | The source code for the unit as it appears in the source data. This code is mapped to a standard unit concept in the Standardized Vocabularies and the original code is, stored here for reference.| Raw unit value (Ounces,Inches etc) For lab values, please see Note 4.
value_source_value| Yes |Yes|  Varchar | The source value associated with the structured value stored as numeric or concept. This field can be used in instances where the source data are transformed|<ul> <li>For BP values include the raw 'systolic/diastolic' value E.g. 120/60</li><li>If there are transformed values (E.g. Weight,Height, Head Circumference, Pulmonary Function Values and Temperature) please insert the raw data before transformation.</li></ul> For Categorical/Qualitative Lab result values, please use this field to store the raw result from the source.
specimen_source_value| No| Provide When Available| Varchar | This field is applicable for lab values only. This source value for the specimen source as it appears in the source||
priority_concept_id| No| Provide When Available | Integer| This field applies to Lab Orders only. A foreign key to a concept that refers to the lab priority as described in the source|<p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where domain_id='Procedure' and vocabulary_id='PEDSnet' and concept_class_id='Qualifier Value')</p> <p>select \* from concept where (domain_id='Procedure' and vocabulary_id='PEDSnet' and concept_class_id='Qualifier Value') or (vocabulary_id='PCORNet' and concept_class_id='Undefined')  yields 7 valid concept_ids.</p> For Pedsnet CDM v2.3, please use the following: <ul><li>Expedited (includes Today)=2000000059 </li><li>STAT (includes ASAP)=2000000060</li><li>Routine = 2000000061 </li><li>Timed = 2000000062 </li><li>No Information: concept_id = 44814650 vocabulary_id='PCORNet')</li> <li>Unknown: concept_id = 44814653</li> <li>Other: concept_id = 44814649</li></ul> 
priority_source_value| No| Provide When Available |  Varchar|This field applies to Lab Orders only. The lab priority as described in the source|

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.12.1 Additional Notes

- The 1/1/2009 date limitation that is used to define a PEDSnet active patient is \*\*NOT\*\* applied to measurements. All measurements are included for an active patient. For PEDSnet CDM V2.3, we limit measurements to only those that appear in Table 3 (for vital signs).
- Measurements have a value represented by one of a concept ID, a string, \*\*OR\*\* a numeric value.
- The Visit during which the measurement was made is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
- The Provider making the measurement is recorded through a reference to the PROVIDER table. This information is not always available.

## 1.13 FACT RELATIONSHIP

The fact relationship domain contains details of the relationships between facts within one domain or across two domains, and the nature of the relationship. Examples of types of possible fact relationships include: person relationships (mother-child linkage), care site relationships (representing the hierarchical organization structure of facilities within health systems), drug exposures provided due to associated indicated condition, devices used during the course of an associated procedure, and measurements derived from an associated specimen. All relationships are directional, and each relationship is represented twice symmetrically within the fact relationship table. 

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
Domain_concept_id_1|Yes|Yes| Integer |	The concept representing the domain of fact one, from which the corresponding table can be inferred.| Predefined value set: <ul><li>Visit domain (ED->Inpatient linking) = 8</li><li>Measurement domain (blood pressure linking) = 21</li><li>Observation domain (tobacco linking) = 27</li></ul>
Fact_id_1|	Yes |Yes| Integer |The unique identifier in the table corresponding to the domain of fact one.| 
Domain_concept_id_2|Yes |Yes| Integer |	The concept representing the domain of fact two, from which the corresponding table can be inferred.| Predefined value set: <ul><li>Visit domain (ED->Inpatient linking) = 8</li><li>Measurement domain (blood pressure linking) = 21</li><li>Observation domain (tobacco linking) = 27</li></ul>
Fact_id_2 |	Yes |Yes| Integer |	The unique identifier in the table corresponding to the domain of fact two.
Relationship_concept_id	|Yes |Yes| Integer |A foreign key to a standard concept identifier of relationship in the Standardized Vocabularies.| Predefined value set: <ul><li>Occurs before (ED Visit) = 44818881</li><li>Occurs after (Inpatient Visit) = 44818783</li><li>Associated with finding (blood pressures) = 44818792</li><li>No matching concept (tobacco) = 0</li></ul>

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.13.1 Additional Notes
- Blood Pressure Systolic and Diastolic Blood Pressure Values will be mapped using the fact relationship table. See [Note 2 in the Measurement section](Pedsnet_CDM_ETL_Conventions.md#measurement-note-2) for instructions.
- ER Visits that result in an Inpatient Encounter will be mapped using the fact relationship table. See [Additional Notes in the Visit Occurrence section](Pedsnet_CDM_ETL_Conventions.md#161-additional-notes) for instructions.
- Tobacco, smoking and tobacco type associations will be mapped using the fact relationship table. See [Note 4 in the Observation section](Pedsnet_CDM_ETL_Conventions.md#observation-note-4) for instructions.

## 1.14 VISIT_PAYER

The visit payer table documents insurance information as it relates to a visit in visit_occurrence. For this reason the key of this table will be visit_occurrence_id and visit_payer_id. **This table is CUSTOM to Pedsnet.**

**Note 1**: There can be multiple payers (primary/secondary) for a single visit. If you are able to obtain multiple payer information at your site please populate the visit payer table with this information. If you are not able to obtain secondary or additional payers for your visit occurrences at your site, please populate the primary payer and inform the DCC.

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
visit_payer_id | Yes |Yes|  Integer |A system-generated unique identifier for each visit payer relationship. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field.
visit_occurrence_id | Yes |Yes| Integer | A foreign key to the visit in the visit table where the payer was billed for the visit.
plan_name | Yes |Yes|  Varchar| The untransformed payer/plan name from the source data
plan_type | No |Provide When Available|  Varchar |  A standardized interpretation of the plan structure | Please only map your plan type to the following categories: <ul> <li>HMO</li> <li>PPO</li> <li>POS</li> <li>Fee for service</li><li> Other/Unknown </li></ul> If the categories are unclear, please work with your billing department or local experts to determine how to map plans to these values.
plan_class | Yes |Yes|  Varchar | A list of the "payment sources" most often used in demographic analyses| Please map your plan type to the following categories: <ul> <li>Private/Commercial</li> <li>Medicaid/sCHIP</li> <li>Medicare</li> <li>Other public</li> <li>Self-pay</li> <li>Other/Unknown</li></ul> Please work with your billing department or local experts to determine how to map plans to these values.

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.14.1 Additional Notes
- If you cannot map your plan to any of the above values for plan_type or plan_class, please map them to Other/unknown, and inform the DCC if the above list of values is not complete or sufficient.

## 1.15 MEASUREMENT_ORGANISM

The measurement organism table contains organism information related to laboratory culture results in the measurement table. **This table is CUSTOM to Pedsnet.**

**Note 1**: There can be multiple organisms for a single culture laboratory result.

Field |NOT Null Constraint |Network Requirement |Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---| ---
meas_organism_id | Yes |Yes|  Integer |A system-generated unique identifier for each organism culture relationship. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field.
measurement_id | Yes |Yes| Integer | A foreign key to the lab result in the measurement table where the organism was observed.
person_id|	Yes |Yes|	Integer|	A foreign key identifier to the person who the measurement is being documented for. The demographic details of that person are stored in the person table.|	
visit_occurrence_id| No |Provide When Available| Integer | A foreign key to the visit where the culture lab was ordered|
organism_concept_id| Yes |Yes|  Integer| A foreign key to a standard concept identifier for the organism in the Vocabulary.| <p>Please include valid concept ids (consistent with OMOP CDMv5). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = SNOMED and concept_class_id= Organism and standard_concept=S)</p> <p>select \* from concept where vocabulary_id ='SNOMED' and concept_class_id='Organism' and standard_concept='S' yields 33039 valid concept_ids.</p>
organism_source_value | Yes |Yes|  Varchar | The organism value as it appears in the source.
positivity_time| No| Optional | Datetime| The estimated date and time of initial growth as reported in the source.|

**If a field marked as "Provide when available" for the network requirement is not available at your site, please relay this information to the DCC**

#### 1.15.1 Additional Notes
- The time to positivity field is marked as optional. Please inform the DCC in the provenance files if this data is available at your site.


* * *

##***APPENDIX***

**PEDSnet-specific is supported by OMOP-supported Vocabulary id=PCORNet, which contains all of the additional concept_id codes needed in PEDSnet for PCORnet CDM V1.0 and 2.0**

### A1. ABMS Specialty Category to OMOP V5 Specialty Mapping
http://www.abms.org/member-boards/specialty-subspecialty-certificates/

ABMS Specialty Category | OMOP Supported Concept for Provider ID | OMOP Concept_name | Domain_id | Vocabulary id
--- | --- | --- | --- | ---
Addiction Psychiatry |38004498 | Addiction Medicine | Provider Specialty | Specialty   
Adolescent Medicine |45756747 |Adolescent Medicine|Provider Specialty | ABMS
Adult Congenital Heart Disease |45756748  |Adult Congenital Heart Disease|Provider Specialty |  ABMS
Advanced Heart Failure and Transplant Cardiology |45756749 |Advanced Heart Failure and Transplant Cardiology|  Provider Specialty | ABMS
Aerospace Medicine |45756750 |Aerospace Medicine| Provider Specialty | ABMS
Allergy and Immunology | 38004448 | Allergy/Immunology                | Provider Specialty | Specialty    
Anesthesiology |38004450 | Anesthesiology   | Provider Specialty | Specialty    
Anesthesiology Critical Care Medicine |45756751 |Anesthesiology Critical Care Medicine|Provider Specialty | Specialty
Blood Banking/Transfusion Medicine |45756752|Blood Banking/Transfusion Medicine|Provider Specialty |  ABMS
Brain Injury Medicine |45756753 |Brain Injury Medicine|Provider Specialty |  ABMS
Cardiology |38004451 | Cardiology                       | Provider Specialty | Specialty 
Cardiovascular Disease |45756754 |Cardiovascular Disease|Provider Specialty |  ABMS
Child Abuse Pediatrics |45756755 |Child Abuse Pediatrics |Provider Specialty |  ABMS
Child and Adolescent Psychiatry |45756756|Child and Adolescent Psychiatry|Provider Specialty |  ABMS
Clinical Biochemical Genetics |45756757|Clinical Biochemical Genetics|Provider Specialty |  ABMS
Clinical Cardiac Electrophysiology |45756758|Clinical Cardiac Electrophysiology |Provider Specialty |  ABMS
Clinical Cytogenetics |45756759 |Clinical Cytogenetics|Provider Specialty |  ABMS
Clinical Genetics (MD) |45756760|Clinical Genetics (MD)|Provider Specialty |  ABMS
Clinical Informatics |45756761|Clinical Informatics|Provider Specialty |  ABMS
Clinical Molecular Genetics |45756762|Clinical Molecular Genetics|Provider Specialty |  ABMS
Clinical Neurophysiology |45756763|Clinical Neurophysiology |Provider Specialty |  ABMS
Colon and Rectal Surgery | 38004471 | Colorectal Surgery              | Provider Specialty | Specialty   
Complex General Surgical Oncology |45756764|Complex General Surgical Oncology| Provider Specialty | ABMS
Congenital Cardiac Surgery |45756765|Congenital Cardiac Surgery |Provider Specialty |  ABMS
Critical Care Medicine | 38004500 | Critical care (intensivist)      | Provider Specialty | Specialty    
Cytopathology |45756766|Cytopathology |Provider Specialty |  ABMS
Dermatology  |38004452 | Dermatology                        | Provider Specialty | Specialty    
Dermatopathology |45756767|Dermatopathology|Provider Specialty |  ABMS
Developmental-Behavioral Pediatrics |45756768|Developmental-Behavioral Pediatrics|Provider Specialty |  ABMS
Diagnostic Radiology |45756769|Diagnostic Radiology|Provider Specialty |  ABMS
Emergency Medical Services |45756770|Emergency Medical Services|Provider Specialty |  ABMS
Emergency Medicine | 38004510 | Emergency Medicine         | Provider Specialty | Specialty   
Endocrinology, Diabetes and Metabolism |45756771  |Endocrinology, Diabetes and Metabolism|Provider Specialty |  ABMS
Epilepsy |45756772   |Epilepsy|Provider Specialty |  ABMS
General Family Medicine | 38004453 | Family Practice                           | Provider Specialty | Specialty   
Female Pelvic Medicine and Reconstructive Surgery|45756773 |Female Pelvic Medicine and Reconstructive Surgery| Provider Specialty | ABMS
Forensic Psychiatry |45756775|Forensic Psychiatry|Provider Specialty |  ABMS
Gastroenterology |38004455 | Gastroenterology                    | Provider Specialty | Specialty   
General Pediatrics (Primary Care)* |2000000063 |General Pediatrics        | Provider Specialty | PEDSNet   
Geriatric Medicine | 38004478 | Geriatric Medicine                   | Provider Specialty | Specialty   
Geriatric Psychiatry |45756776|Geriatric Psychiatry|Provider Specialty |  ABMS
Gynecologic Oncology |38004513 | Gynecology/Oncology              | Provider Specialty | Specialty    
Hematology | 38004501 | Hematology                           | Provider Specialty | Specialty   
Hospice and Pallative Medicine |45756777 |Hospice and Pallative Medicine|Provider Specialty |  ABMS
Infectious Disease | 38004484 | Infectious Disease                | Provider Specialty | Specialty   
General Internal Medicine | 38004456 | Internal Medicine| Provider Specialty | Specialty   
Internal Medicine - Critical Care Medicine |45756778|Internal Medicine - Critical Care Medicine|Provider Specialty |  ABMS
Interventional Cardiology |45756779 |Interventional Cardiology|Provider Specialty |  ABMS
Interventional Radiology and Diagnostic Radiology |38004511 | Interventional Radiology | Provider Specialty | Specialty   
Maternal and Fetal Medicine |45756780|Maternal and Fetal Medicine |Provider Specialty |  ABMS
Medical Biochemical Genetics |45756781|Medical Biochemical Genetics|Provider Specialty |  ABMS
Medical Genetics and Genomics |45756782 |Medical Genetics and Genomics|Provider Specialty |  ABMS
Medical Oncology |38004507 | Medical Oncology | Provider Specialty | Specialty   
Medical Physics |45756783|Medical Physics|Provider Specialty |  ABMS
Medical Toxicology|45756784|Medical Toxicology|Provider Specialty |  ABMS
Molecular Genetic Pathology |45756785|Molecular Genetic Pathology|Provider Specialty |  ABMS
Neonatal-Perinatal Medicine |45756786|Neonatal-Perinatal Medicine|Provider Specialty |  ABMS
Nephrology | 38004479 | Nephrology                   | Provider Specialty | Specialty   
Neurodevelopmental Disabilities |45756787|Neurodevelopmental Disabilities|Provider Specialty |  ABMS
Neurological Surgery | 38004459 | Neurosurgery                    | Provider Specialty | Specialty   
General Neurology | 38004458 | Neurology                                     | Provider Specialty | Specialty   
Neurology with Special Qualification in Child Neurology |45756788|Neurology with Special Qualification in Child Neurology|Provider Specialty |  ABMS
Neuromuscular Medicine |45756789|Neuromuscular Medicine|Provider Specialty |  ABMS
Neuropathology |45756790 |Neuropathology|Provider Specialty |  ABMS
Neuroradiology |45756791|Neuroradiology|Provider Specialty |  ABMS
Neurotology |45756792|Neurotology|Provider Specialty |  ABMS
Nuclear Medicine |38004476 | Nuclear Medicine                  | Provider Specialty | Specialty   
Nuclear Radiology |45756793 |Nuclear Radiology|Provider Specialty |  ABMS
Obstetrics and Gynecology | 38004461 | Obstetrics/Gynecology              | Provider Specialty | Specialty   
Occupational Medicine |38004492 | Occupational Therapy              | Provider Specialty | Specialty   
Ophthalmology |  38004463 | Ophthalmology                       | Provider Specialty | Specialty     
Orthopaedic Sports Medicine |45756794|Orthopaedic Sports Medicine|Provider Specialty |  ABMS
Orthopedics/Orthopaedic Surgery |38004465 |Orthopedics/Orthopedic Surgery                | Provider Specialty | Specialty   
Otolaryngology | 38004449 | Otolaryngology                           | Provider Specialty | Specialty   
Pain Medicine | 38004494 | Pain Management                           | Provider Specialty | Specialty   
Pathology |38004466 | Pathology                                  | Provider Specialty | Specialty   
Pathology - Anatomic |45756795|Pathology - Anatomic| Provider Specialty | ABMS
Pathology - Chemical |45756796|Pathology - Chemical | Provider Specialty | ABMS
Pathology - Clinical |45756797|Pathology - Clinical| Provider Specialty | ABMS
Pathology - Forensic |45756798|Pathology - Forensic| Provider Specialty | ABMS
Pathology - Hematology |45756799|Pathology - Hematology| Provider Specialty | ABMS
Pathology - Medical Microbiology |45756800 |Pathology - Medical Microbiology| Provider Specialty | ABMS
Pathology - Molecular Genetic |45756801|Pathology - Molecular Genetic| Provider Specialty | ABMS
Pathology - Pediatric |45756802|Pathology - Pediatric | Provider Specialty | ABMS
Pathology-Anatomic/Pathology-Clinical |45756803|Pathology-Anatomic/Pathology-Clinical | Provider Specialty | ABMS
Pediatric Medicine** | 38004477 | Pediatric Medicine               | Provider Specialty | Specialty   
Pediatric Anesthesiology |45756804|Pediatric Anesthesiology| Provider Specialty | ABMS
Pediatric Cardiology |45756805|Pediatric Cardiology | Provider Specialty | ABMS
Pediatric Critical Care Medicine |45756806|Pediatric Critical Care Medicine| Provider Specialty | ABMS
Pediatric Dermatology |45756807|Pediatric Dermatology| Provider Specialty | ABMS
Pediatric Emergency Medicine |45756808|Pediatric Emergency Medicine| Provider Specialty | ABMS
Pediatric Endocrinology |45756809|Pediatric Endocrinology| Provider Specialty | ABMS
Pediatric Gastroenterology |45756810 |Pediatric Gastroenterology | Provider Specialty | ABMS
Pediatric Hematology-Oncology |45756811 |Pediatric Hematology-Oncology| Provider Specialty | ABMS
Pediatric Infectious Diseases |45756812 |Pediatric Infectious Diseases| Provider Specialty | ABMS
Pediatric Nephrology |45756813 |Pediatric Nephrology| Provider Specialty | ABMS 
Pediatric Otolaryngology |45756814|Pediatric Otolaryngology | Provider Specialty | ABMS
Pediatric Pulmonology |45756815|Pediatric Pulmonology | Provider Specialty | ABMS
Pediatric Radiology |45756816|Pediatric Radiology| Provider Specialty | ABMS
Pediatric Rehabilitation Medicine |45756817|Pediatric Rehabilitation Medicine| Provider Specialty | ABMS
Pediatric Rheumatology |45756818|Pediatric Rheumatology| Provider Specialty | ABMS
Pediatric Surgery |45756819|Pediatric Surgery| Provider Specialty | ABMS
Pediatric Transplant Hepatology |45756820|Pediatric Transplant Hepatology | Provider Specialty | ABMS
Pediatric Urology|45756821|Pediatric Urology| Provider Specialty | ABMS
Physical Medicine and Rehabilitation |38004468 | Physical Medicine And Rehabilitation | Provider Specialty | Specialty   
Plastic Surgery | 38004467 | Plastic And Reconstructive Surgery  | Provider Specialty | Specialty    
Plastic Surgery Within the Head and Neck |45756822|Plastic Surgery Within the Head and Neck| Provider Specialty | ABMS
Preventative Medicine | 38004503 | Preventive Medicine                | Provider Specialty | Specialty   
Psychiatry |38004469 | Psychiatry                             | Provider Specialty | Specialty   
Psychosomatic Medicine |45756823 |Psychosomatic Medicine | Provider Specialty | ABMS
Public Health and General Preventive Medicine |45756824|Public Health and General Preventive Medicine| Provider Specialty | ABMS
Pulmonary Disease | 38004472 | Pulmonary Disease         | Provider Specialty | Specialty   
Radiation Oncology |38004509 | Radiation Oncology    | Provider Specialty | Specialty   
Radiology |45756825|Radiology| Provider Specialty | ABMS
Reproductive Endocrinology/Infertility |45756826|Reproductive Endocrinology/Infertility| Provider Specialty | ABMS
Rheumatology |38004491 | Rheumatology                  | Provider Specialty | Specialty   
Sleep Medicine |45756827|Sleep Medicine| Provider Specialty | ABMS
Spinal Cord Injury Medicine| concept id requested |Spinal Cord Injury Medicine | Provider Specialty | ABMS|
Sports Medicine |45756828|Sports Medicine| Provider Specialty | ABMS
General Surgery | 38004447 | General Surgery            | Provider Specialty | Specialty   
Surgery of the Hand | 38004480 | Hand Surgery                  | Provider Specialty | Specialty   
Surgical Critical Care |45756829|Surgical Critical Care | Provider Specialty | ABMS
Thoracic Surgery | 38004473 | Thoracic Surgery                  | Provider Specialty | Specialty     
Thoracic and Cardiac Surgery |45756830|Thoracic and Cardiac Surgery| Provider Specialty | ABMS
Transplant Hepatology |45756831|Transplant Hepatology| Provider Specialty | ABMS
Undersea and Hyperbaric Medicine |45756832 |Undersea and Hyperbaric Medicine| Provider Specialty | ABMS
Urology | 38004474 | Urology                                   | Provider Specialty | Specialty   
Vascular and Interventional Radiology |45756833|Vascular and Interventional Radiology| Provider Specialty | ABMS
Vascular Neurology |45756834|Vascular Neurology| Provider Specialty | ABMS
Vascular Surgery | 38004496 | Vascular Surgery           | Provider Specialty | Specialty   

**NOTES:**
- General Pediatrics refers to Primary Care
- Pediatric Medicine refers to the default assignment if a site is unable to distinguish which pediatric specialty the care site or provider has an assigned

### A2. PEDSNet Person Language Concept Mapping Values

The below langauge listing is representative of the top 10 spoken languages of each of the 8 contributing sites. This list standard list will be used to map language values for consistency.

Language|concept_id|concept_name|domain_id|concept_class_id|standard_concept
---|---|---|---|---|---|---|---|---|---|---|---|---
Amharic|4182354|Amharic language|Observation|Qualifier Value|S
Arabic|4181374|Arabic language| Observation|Qualifier Value|S
Bengali|4052786|Bengali language|Observation|Qualifier Value|S
Burmese|4181727|Burmese language|Observation|Qualifier Value|S
Bosnian|40481563|Bosnian language|Observation|Qualifier Value|S
Cape Verde Creole|44814649 | Other        | Observation | Undefined        |                  | 
Chinese|4182948|Chinese Language|Observation|Qualifier Value|S
Chinese(Cantonese)|4177463|Cantonese Chinese dialect|Observation|Qualifier Value|S
Chinese(Mandarin)| 4181724| Mandarin dialect | Observation|Qualifier Value|S
English|4180186|English Language|Observation|Qualifier Value|S
French|4180190|French Language|Observation|Qualifier Value|S
Haitian/Creole|44802876| Haitian Creole Language|Observation|Qualifier Value|S
Japanese|4181524|Japanese Language|Observation|Qualifier Value|S
Korean|4175771|Korean Language|Observation|Qualifier Value|S
Mandarin| 4181724| Mandarin dialect | Observation|Qualifier Value|S
Nepali|4175908|Nepali language|Observation|Qualifier Value|S
No information| 44814650 | No information|Observation | Undefined|S                                                                                                                            
None|44814650 | No information|Observation | Undefined|S                                   
null|44814650 | No information|Observation | Undefined|S                                   
Other|44814649 | Other        | Observation | Undefined        |                  | 
Other Language|44814649 | Other        | Observation | Undefined        |                  | 
Other/Unknown|44814649 | Other        | Observation | Undefined        |                  | 
Portuguese|4181536 | Portuguese language                                 | Observation | Qualifier Value  | S
Russian|4181539 | Russian language                    | Observation | Qualifier Value  | S  
Sign|40483152 | Sign language                                               | Observation        | Qualifier Value   | S
Sign Language|40483152 | Sign language                                               | Observation        | Qualifier Value   | S
Somali|4182350 | Somali language                    | Observation | Qualifier Value  | S
Spanish|4182511 | Spanish language                    | Observation | Qualifier Value  | S
Unable to Collect| 44814650 | No information|Observation | Undefined|S        
Unknown | 44814653 | Unknown|  Observation | Undefined|S      
Vietnamese|4181526 | Vietnamese language                    | Observation | Qualifier Value  | S



* * *
