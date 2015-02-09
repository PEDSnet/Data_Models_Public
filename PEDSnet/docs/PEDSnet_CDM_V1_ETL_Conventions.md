# ETL Conventions for use with PEDSnet CDM V1.0

The PEDSnet Common Data Model is an evolving specification, based in structure on the OMOP Common Data Model, but expanded to accommodate requirements of both the PCORnet Common Data Model and the primary research cohorts established in PEDSnet.

Version 1 of the PEDSnet CDM reflects the ETL processes developed during the first six months of network development. As such, it closely follows version 1 of the PCORnet CDM. We anticipate that the PEDSnet CDM will expand to include additional data domains such as medication usage, laboratory testing, and other types of clinical observations. However, in order to minimize discordance with the PCORnet CDM, specification of these domains has been deferred until the cognate portion of the PCORnet CDM is developed, or active research in one of the PEDSnet cohorts requires those data types.

This document provides the ETL processing assumptions and conventions developed by the PEDSnet data partners that should be used by a data partner for ensuring common ETL business rules. This document will be modified as new situations are identified, incorrect business rules are identified and replaced, as new analytic use cases impose new/different ETL rules, and as the PEDSnet CDM continues to evolve.

Comments on this specification and ETL rules are welcome. Please send email to pedsnetdcc@email.chop.edu, or contact the PEDSnet project management office (details available via http://www.pedsnet.info).

#### PEDSnet Data Standards and Interoperability Policies:

1. The PEDSnet data network will store data using structures compatible with the PEDSnet Common Data Model (PCDM).

2. The PCDM v1 is based on the Observational Medical Outcomes Partnership (OMOP) data model, version 4. OMOP will be expanded to include the PCORnet and pediatric-specific data standards, as developed by PEDSnet. The next release of PCDM will be based on OMOP CDM Version 5, which incorporates additional requirements for realizing PCORnet CDM V2.

3. A subset of data elements in the PCDM will be identified as principal data elements (PDEs). The PDEs will be used for population-level queries. Data elements which are NOT PDEs will be marked as Optional (ETL at site discretion) or Non-PDE (ETL required, but data need not be transmitted to DCC), and will not be used in queries without prior approval of site.

4. It is anticipated that PEDSnet institutions will make a good faith attempt to obtain as many of the data elements not marked as Optional as possible.

5. The data elements classified as PDEs and those included in the PCDM will be approved by the PEDSnet Executive Committee (comprised of each PEDSnet institution's site principal investigator).

6. Concept IDs are taken from OMOP v4.5 vocabularies for PEDSnet CDM v1, using the complete (restricted) version that includes licensed terminologies such as CPT and others.

7. PCORnet CDM V1.0 requires data elements that are not currently considered "standard concepts". Vocabulary version 4.5 has a new vocabulary (vocabulary_id = 60) that was added by OMOP to capture all of the PCORnet concepts that are not in the standard terminologies. We use concept_ids from vocabulary_id 60 where there are no existing standard concepts. We highlight where we are pulling concept_ids from vocabulary_id 60 in the tables. While terms from vocabulary_id = 60 violates the OMOP rule to use only concept_ids from standard vocabularies (vocabulary 60 is a non-standard vocabulary), this convention enables a clean extraction from PEDSnet CDM to PCORnet CDM.

8. Some source fields may be considered sensitive by data sites. Potential examples include patient_source_value, provider_source_value, care_site_source_value. Many of these fields are used to generate an ID field, such as PATIENT.patient_source_value PATIENT.patient_id, that is used as a primary key in PATIENT and a foreign key in many other tables. Sites are free to obfuscate or not provide source values that are used to create ID variables. Sites must maintain a mapping from the ID variable back to the original site-specific value for local re-identification tasks.

    1. Source fields that contain clinical data, such as source condition occurrence, should be included

    2. The PEDSnet DCC will never release source values to external data partners.

    3. Source value obfuscation techniques may include replacing the real source value with a random number, an encrypted derivative value/string, or some other site-specific algorithm.

9. Date and time fields should be stored as full `datetime` values to avoid ambiguity produced during timezone shifts. This includes those fields claiming specificity like `pn_time_of_birth`, `observation_date`, and `observation_time` (so `observation_time` and `observation_date` should have the same values and `pn_time_of_birth` should have the full date and time of birth, or as much information as is available). These values **should not** include the timezone at which they were collected or be converted into any other timezone. The DCC will add timezone information to records in the warehouse.

10. Regarding the nullability of all source value (string) fields only, the PEDSnet CDM will accommodate the following values, taken from the PCORnet CDM:

Null Name | Definition of each field
 --- | ---
NULL | A data field is not present in the source system
NI = No Information | A data field is present in the source system, but the source value is null or blank
UN = Unknown | A data field is present in the source system, but the source value explicitly denotes an unknown value
OT = Other | A data field is present in the source system, but the source value cannot be mapped to the CDM

***ETL Recommendation:*** Due to PK/FK constraints, the most efficient order for ETL table is location, organization, care_site, provider, person, visit_occurrence, condition_occurrence, observation, procedure_occurrence, and observation_period

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

Field | Required | Description | PEDSnet Conventions
 --- | --- | --- | ---
person_id | Yes | A unique identifier for each person; this is created by each contributing site. | <p>This is not a value found in the EHR.</p> PERSON_ID must be unique for all patients within a single data set.</p><p>Sites may choose to use a sequential value for this field
gender_concept_id | Yes | A foreign key that refers to a standard concept identifier in the Vocabulary for the gender of the person. | Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 12 and vocabulary_id = 60 where noted): <ul><li>Ambiguous: concept_id = 8570</li> <li>Female: concept_id = 8532</li> <li>Male: concept_id = 8507</li> <li>No Information: concept_id = 44814667 (Vocabulary 60)</li> <li>Unknown: concept_id = 8551</li> <li>Other: concept_id = 8521</li></ul>
year_of_birth | Yes | The year of birth of the person. | <p>For data sources with date of birth, the year is extracted. For data sources where the year of birth is not available, the approximate year of birth is derived based on any age group categorization available.</p> Please keep all accurate/real dates (No date shifting)
month_of_birth | No | The month of birth of the person. | <p>For data sources that provide the precise date of birth, the month is extracted and stored in this field.</p> Please keep all accurate/real dates (No date shifting)
day_of_birth | No | The day of the month of birth of the person. | <p>For data sources that provide the precise date of birth, the day is extracted and stored in this field.</p> Please keep all accurate/real dates (No date shifting)
pn_time_of_birth | No | The time of birth at the birth day | <p>Please keep all accurate/real dates (No date shifting)</p> Store and transmit as a full date and time, with as much information as is available and without timezone information or conversion, to avoid ambiguity.
race_concept_id | No | A foreign key that refers to a standard concept identifier in the Vocabulary for the race of the person. | Details of categorical definitions: <ul><li>**-American Indian or Alaska Native**: A person having origins in any of the original peoples of North and South America (including Central America), and who maintains tribal affiliation or community attachment.</li> <li>**-Asian**: A person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam.</li> <li>**-Black or African American**: A person having origins in any of the black racial groups of Africa.</li> <li>**-Native Hawaiian or Other Pacific Islander**: A person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands.</li> <li>**-White**: A person having origins in any of the original peoples of Europe, the Middle East, or North Africa.</li></ul> <p>For patients with multiple races (i.e. biracial), race is considered a single concept, meaning there is only one race slot. If there are multiple races in the source system, concatenate all races into one race_source_value (see below) and use concept_id code as 'Multiple Race.'</p> Predefined values (valid concept_ids found in CONCEPT table where vocabulary_id = 13 and vocabulary_id = 60): <ul><li>American Indian/Alaska Native: concept_id = 8657</li> <li>Asian: concept_id = 8515</li> <li>Black or African American: concept_id = 8516</li> <li>Native Hawaiian or Other Pacific Islander: concept_id = 8557</li> <li>White: concept_id = 8527M</li> <li>ultiple Race: concept_id = 44814659 (vocabulary 60)</li> <li>Refuse to answer: concept_id = 44814660 (vocabulary 60)</li> <li>No Information: concept_id = 44814661 (vocabulary 60)</li> <li>Unknown: concept_id = 8552</li> <li>Other: concept_id = 8522</li></ul>
ethnicity_concept_id | No | A foreign key that refers to the standard concept identifier in the Vocabulary for the ethnicity of the person. | <p>For PEDSnet, a person with Hispanic ethnicity is defined as "A person of Cuban, Mexican, Puerto Rican, South or Central American, or other Spanish culture or origin, regardless of race."</p> Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 44 or vocabulary 60 where noted): <ul><li>Hispanic: concept_id = 38003563</li> <li>Not Hispanic: concept_id = 38003564</li> <li>No Information: concept_id = 44814650 (vocabulary 60)</li> <li>Unknown: concept_id = 44814653 (vocabulary 60)</li> <li>Other: concept_id = 44814649 (vocabulary 60)</li></ul>
location_id | No | A foreign key to the place of residency (ZIP code) for the person in the location table, where the detailed address information is stored.
provider_id | No | Foreign key to the primary care provider the person is seeing in the provider table.| <p>For PEDSnet CDM V1.0: Sites will use site-specific logic to determine the best primary care provider and document how that decision was made (e.g., billing provider).</p> PEDSnet CDM 2.0/OMOP V5, multiple providers may be asserted based on specific use cases that require multiple providers in all provider_id fields.
care_site_id | Yes | A foreign key to the site of primary care in the care_site table, where the details of the care site are stored | For patients who receive care at multiple care sites, use site-specific logic to select a care site that best represents where the patient obtains the majority of their recent care. If a specific site within the institution cannot be identified, use a care_site_id representing the institution as a whole.
pn_gestational_age | No | The post-menstrual age in weeks of the person at birth, if known | Use granularity of age in weeks as is recorded in local EHR.
person_source_value | Yes | An encrypted key derived from the person identifier in the source data. | <p>Insert a pseudo-identifier (random number, encrypted identifier) into the field. Do not insert the actual MRN or PAT_ID from your site. A mapping from the pseudo-identifier for person_source_value in this field to a real patient ID or MRN from the source EHR must be kept at the local site. This mapping is not shared with the data coordinating center. It is used only by the site for re-identification for study recruitment or for data quality review.</p> Sites may consider using the person_id field value in this table as the pseudo-identifier as long as a local mapping from person_id to the real site identifier is maintained.
gender_source_value | No | The source code for the gender of the person as it appears in the source data. | The person's gender is mapped to a standard gender concept in the Vocabulary; the original value is stored here for reference. See gender_concept_id
race_source_value | No | The source code for the race of the person as it appears in the source data. | <p>The person race is mapped to a standard race concept in the Vocabulary and the original value is stored here for reference.</p> For patients with multiple races (i.e. biracial), race is considered a single concept, meaning there is only one race slot. If there are multiple races in the source system, concatenate all races into one source value, and use the conceptt_id for Multiple Race.
ethnicity_source_value | No | The source code for the ethnicity of the person as it appears in the source data. | The person ethnicity is mapped to a standard ethnicity concept in the Vocabulary and the original code is, stored here for reference.

## 1.2 DEATH

The death domain contains the clinical event for how and when a person dies. Living patients should not contain any information in the death table.

Field | Required | Description | PEDSnet Conventions
 --- | --- | --- | ---
person_id | Yes | A foreign key identifier to the deceased person. The demographic details of that person are stored in the person table.| See PERSON.person_id (primary key)
death_date | Yes | The date the person was deceased. | <p>If the precise date including day or month is not known or not allowed, December is used as the default month, and the last day of the month the default day. If no date available, use date recorded as deceased.</p> When the date of death is not present in the source data, use the date the source record was created.
death_type_concept_id | Yes | A foreign key referring to the predefined concept identifier in the Vocabulary reflecting how the death was represented in the source data. | <p>Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 45)</p> <p>select \* from concept where vocabulary_id = 45 yields 8 valid concept_ids. If none are correct, use concept_id = 0</p> <p>Note: Most current ETLs are extracting data from EHR so most likely concept_id to insert here is 38003569 ("Recorded from EHR")</p> Note: These terms only describe the source from which the death was reported. It does not describe our certainty/source of the date of death, which may have been created by one of the heuristics described in death_date.
cause_of_death_concept_id | No | A foreign referring to a standard concept identifier in the Vocabulary for conditions.
cause_of_death_source_value | No | The source code for the cause of death as it appears in the source. This code is mapped to a standard concept in the Vocabulary and the original code is stored here for reference.

#### 1.2.1 Additional Notes

- Each Person may have more than one record of death in the source data. It is OK to insert multiple death records for an individual.
- If the Death Date cannot be precisely determined from the data, the best approximation should be used.

## 1.3 LOCATION

The Location table represents a generic way to capture physical location or address information. Locations are used to define the addresses for Persons and Care Sites. NOTE: In OMOP CDM V5, this table is eliminated so don't spend a lot of time on this table. The most important field is ZIP for location-based queries.

Field | Required | Description | PEDSnet Conventions
 --- | --- | --- | ---
location_id | Yes | A unique identifier for each geographic location. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field
state | No | The state field as it appears in the source data.
zip | No | The zip code. For US addresses, valid zip codes can be 3, 5 or 9 digits long, depending on the source data. | While optional, this is the most important field in this table to support location-based queries.
location_source_value | No | <p>Optional - Do not transmit to DCC.</p> The verbatim information that is used to uniquely identify the location as it appears in the source data. | <p>If location source values are deemed sensitive by your organization, insert a pseudo-identifier (random number, encrypted identifier) into the field. Sites electing to obfuscate location_source_values will keep the mapping between the value in this field and the original clear text location source value. This value is only used for site-level re-identification for study recruitment and for data quality review.</p> Sites may consider using the location_id field value in this table as the pseudo-identifier as long as a local mapping from location_id to the real site identifier is maintained.
address_1 | No | Optional - Do not transmit to DCC
address_2 | No | Optional - Do not transmit to DCC
city | No | Optional - Do not transmit to DCC
county | No | Optional - Do not transmit to DCC

#### 1.3.1 Additional Notes

- Each address or Location is unique and is present only once in the table

## 1.4 CARE_SITE

The Care Site table contains a list of uniquely identified physical or organizational units where healthcare delivery is practiced (offices, wards, hospitals, clinics, etc.). Future definitions of PEDSnet CDM will more precisely define the fields in this table. The most important field in this table is organization_id, which is the tie back to the contributing PEDSnet data partner (CHOP versus Colorado versus St. Louis).

Field | Required | Description | PEDSnet Conventions
 --- | --- | --- | ---
care_site_id | Yes | A unique identifier for each defined location of care within an organization. Here, an organization is defined as a collection of one or more care sites that share a single EHR database. | <p>This is not a value found in the EHR.</p> Sites may choose to use a sequential value for this field
place_of_service_concept_id | No | A foreign key that refers to a place of service concept identifier in the Vocabulary | <p>Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 24 and vocabulary 60 where noted)</p> <p>select \* from concept where vocabulary_id = 24 yields 4 valid concept_ids.</p> If none are correct, use concept_id = 0 <ul><li>Inpatient Hospital Stay: concept_id = 9201</li> <li>Ambulatory Visit: concept_id = 9202</li> <li>Emergency Department: concept_id = 9203</li> <li>Non-Acute Institutional Stay: concept_id = 42898160 (vocabulary 60)</li> <li>Unknown: concept_id = 44814713 (vocabulary 60)</li> <li>Other: concept_id = 44814711 (vocabulary 60)</li> <li>No information: concept_id = 44814712 (vocabulary 60)</li></ul>
location_id | No | A foreign key to the geographic location of the administrative offices of the organization in the location table, where the detailed address information is stored.
care_site_source_value | Yes | The identifier for the organization in the source data, stored here for reference. | <p>If care site source values are deemed sensitive by your organization, insert a pseudo-identifier (random number, encrypted identifier) into the field. Sites electing to obfuscate care site_source_values will keep the mapping between the value in this field and the original clear text location source value. This value is only used for site-level re-identification for study recruitment and for data quality review.</p> <p>For EPIC EHRs, map care_site_id to Clarity Department.</p> Sites may consider using the care_site_id field value in this table as the pseudo-identifier as long as a local mapping from care_site_id to the real site identifier is maintained.
place_of_service_source_value | No | The source code for the place of service as it appears in the source data, stored here for reference.
organization_id | Yes | A foreign key to the organization record. | See ORGANIZATION.organization_id (primary key)

#### 1.4.1 Additional Notes

- Care sites are primarily identified based on the specialty or type of care provided, and secondarily on physical location, if available (e.g. North Satellite Endocrinology Clinic)
- The Care Site Source Value typically contains the name of the Care Site.
- The Place of Service Concepts are based on a catalog maintained by the CMS (see vocabulary for values)

## 1.5 ORGANIZATION

Note: This table will be incorporated into CARE SITE in OMOP CDM V5/PEDSnet CDM V2

Field | Required | Description | PEDSnet Conventions
 --- | --- | --- | ---
organization_id | Yes | A unique identifier for each defined location of care within an organization. Here, an organization is defined as a collection of one or more care sites that share a single EHR database. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field
place_of_service_concept_id | No | A foreign key that refers to a place of service concept identifier in the Vocabulary | <p>Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 14)</p> <p>select \* from concept where vocabulary_id = 14 yields 49 valid concept_ids.</p> <p>If none are correct, use concept_id = 0</p> Make a best-guess mapping.
location_id | No | A foreign key to the geographic location of the administrative offices of the organization in the location table, where the detailed address information is stored.| See LOCATION.location_id (primary key)
place_of_service_source_value | No | The source code for the place of service as it appears in the source data, stored here for reference.
organization_source_value | Yes | A foreign key to the organization record, stored here for reference. | In PEDSnet, expected organizations are Boston, CCHMC, CHOP, Colorado, Nationwide, Nemours, Seattle, and St. Louis.

## 1.6 PROVIDER

The Provider table contains a list of uniquely identified health care providers. These are typically physicians, nurses, etc.

Field | Required | Description | PEDSnet Conventions
 --- | --- | --- | ---
provider_id | Yes | A unique identifier for each provider. Each site must maintain a map from this value to the identifier used for the provider in the source data. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field. See Additional Comments below. Sites should document who they have included as a provider.
specialty_concept_id | No | A foreign key to a standard provider's specialty concept identifier in the Vocabulary. | <p>Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 48)</p> <p>select \* from concept where vocabulary_id = 48 yields 111 valid concept_ids.</p> <p>If none are correct, use concept_id = 0</p> For providers with more than one specialty, use site-specific logic to select one specialty and document the logic used. For example, sites may decide to always assert the \*\*first\*\* specialty listed in their data source.
care_site_id | Yes | A foreign key to the main care site where the provider is practicing. | See CARE_SITE.care_site_id (primary key)
NPI | No | <p>Optional - Do not transmit to DCC.</p> The National Provider Identifier (NPI) of the provider.
DEA | No | <p>Optional - Do not transmit to DCC.</p> The Drug Enforcement Administration (DEA) number of the provider.
provider_source_value | Yes | The identifier used for the provider in the source data, stored here for reference. | <p>Insert a pseudo-identifier (random number, encrypted identifier) into the field. Do not insert the actual PROVIDER_ID from your site. A mapping from the pseudo-identifier for provider_source_value in this field to a real provider ID from the source EHR must be kept at the local site. This mapping is not shared with the data coordinating center. It is used only by the site for re-identification for study recruitment or for data quality review.</p> Sites may consider using the provider_id field value in this table as the pseudo-identifier as long as a local mapping from provider_id to the real site identifier is maintained.
specialty_source_value | No | The source code for the provider specialty as it appears in the source data, stored here for reference. | Optional. May be obfuscated if deemed sensitive by local site.

#### 1.6.1 Additional Notes

- For PEDSnet, a provider is any individual (MD, DO, NP, PA, RN, etc) who is authorized to document care.
- Providers are not duplicated in the table.

## 1.7 VISIT_OCCURRENCE

The visit domain contains the spans of time a person continuously receives medical services from one or more providers at a care site in a given setting within the health care system.

Field | Required | Description | PEDSnet Conventions
 --- | --- | --- | ---
visit_occurrence_id | Yes | A unique identifier for each person's visits or encounter at a healthcare provider. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field. Do not use institutional encounter ID.
person_id | Yes | A foreign key identifier to the person for whom the visit is recorded. The demographic details of that person are stored in the person table.
visit_start_date | Yes | The start date of the visit. | No date shifting
visit_end_date | No | The end date of the visit. | <p>No date shifting.</p> <p>If this is a one-day visit the end date should match the start date.</p> If the encounter is on-going at the time of ETL, this should be null.
provider_id | No | A foreign key to the provider in the provider table who was associated with the visit. | <p>Use attending or billing provider for this field if available, even if multiple providers were involved in the visit. Otherwise, make site-specific decision on which provider to associate with visits and document.</p> **NOTE: this is NOT in OMOP CDM v4, but appears in OMOP CDMv5.**
care_site_id | No | A foreign key to the care site in the care site table that was visited. | See CARE_SITE.care_site_id (primary key)
place_of_service_concept_id | Yes | A foreign key that refers to a place of service concept identifier in the vocabulary. | <p>Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 24).</p> <p>select \* from concept where vocabulary_id = 24 yields 4 valid concept_ids.</p> If none are correct, use concept_id = 0 <ul><li>Inpatient Hospital Stay: concept_id = 9201</li> <li>Ambulatory Visit: concept_id = 9202</li> <li>Emergency Department: concept_id = 9203</li> <li>Long term care visit: concept_id = 42898160</li> <li>Non-Acute Institutional stay: concept_id = 44814710 (Vocabulary 60) </li> <li>Other ambulatory visit: concept_id = 44814711 (Vocabulary 60)</li> <li>Unknown: concept_id = 44814713</li> <li>Other: concept_id = 44814714 (vocabulary 60)</li> <li>No information: concept_id = 44814712 (vocabulary 60)</li></ul>
place_of_service_source_value | No | The source code used to reflect the type or source of the visit in the source data. Valid entries include office visits, hospital admissions, etc. These source codes can also be type-of service codes and activity type codes.

#### 1.7.1 Additional Notes

- The 1/1/2009 date limitation that is used to define a PEDSnet active patient is **NOT** applied to visit_occurrence. All visits, of all types (physical and virtual) are included for an active patient.
- A Visit Occurrence is recorded for each visit to a healthcare facility.
- If a visit includes moving between different place_of_service_concepts (ED -\> inpatient) this should be split into separate visit_occurrences to meet PCORnet's definitions
- Each Visit is standardized by assigning a corresponding Concept Identifier based on the type of facility visited and the type of services rendered.
- At any one day, there could be more than one visit.
- One visit may involve multiple attending or billing providers (e.g. billing, attending, etc), in which case the ETL must specify how a single provider id is selected or leave the provider_id field null.
- One visit may involve multiple care sites, in which case the ETL must specify how a single care_site id is selected or leave the care_site_id field null.

## 1.8 CONDITION_OCCURRENCE

The condition occurrence domain captures records of a disease or a medical condition based on diagnoses, signs and/or symptoms observed by a provider or reported by a patient.

Conditions are recorded in different sources and levels of standardization. For example:

- Medical claims data include ICD-9-CM diagnosis codes that are submitted as part of a claim for health services and procedures.
- EHRs may capture a person's conditions in the form of diagnosis codes and symptoms as ICD-9-CM codes, but may not have a way to capture out-of-system conditions.

Field | Required | Description | PEDSnet Conventions
 --- | --- | --- | ---
condition_occurrence_id | Yes | A unique identifier for each condition occurrence event. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field
person_id | Yes | A foreign key identifier to the person who is experiencing the condition. The demographic details of that person are stored in the person table.
condition_concept_id | Yes | A foreign key that refers to a standard condition concept identifier in the Vocabulary. | <p>Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 1)</p> <p>select \* from concept where vocabulary_id = 1 yields ~400,000 valid concept_ids.</p> If none are correct, use concept_id = 0
condition_start_date | Yes | The date when the instance of the condition is recorded. | No date shifting
condition_end_date | No | The date when the instance of the condition is considered to have ended | <p>No date shifting.</p> If this information is not available, set to NULL.
condition_type_concept_id | Yes | A foreign key to the predefined concept identifier in the Vocabulary reflecting the source data from which the condition was recorded, the level of standardization, and the type of occurrence. For example, conditions may be defined as primary or secondary diagnoses, problem lists and person statuses. | <p>Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 37)</p> <p>select \* from concept where vocabulary_id = 37 yields 67 valid concept_ids.</p> <p>If none are correct, use concept_id = 0</p> If data source only identifies conditions as primary or secondary with no sequence number, use the following concept_ids: <ul><li>Inpatient primary: concept_id = 38000199</li> <li>Inpatient secondary: concept_id = 38000201</li> <li>Outpatient primary: concept_id = 38000230</li> <li>Outpatient secondary: concept_id = 38000231</li></ul>
stop_reason | No | The reason, if available, that the condition was no longer recorded, as indicated in the source data. | <p>Valid values include discharged, resolved, etc. Note that a stop_reason does not necessarily imply that the condition is no longer occurring, and therefore does not mandate that the end date be assigned.</p> Leave blank for billing diagnoses. Possibly will be used for problem list diagnoses in the future.
associated_provider_id | No | A foreign key to the provider in the provider table who was responsible for determining (diagnosing) the condition. | <p>Any valid provider_id allowed (see definition of providers in PROVIDER table)</p> Make a best-guess and document method used. Or leave blank
visit_occurrence_id | No | A foreign key to the visit in the visit table during which the condition was determined (diagnosed).
condition_source_value | No | The source code for the condition as it appears in the source data. This code is mapped to a standard condition concept in the Vocabulary and the original code is, stored here for reference. | Condition source codes are typically ICD-9-CM diagnosis codes from medical claims or discharge status/visit diagnosis codes from EHRs. Use source_to_concept maps to translation from source codes to OMOP concept_ids.<p>If the coding system of the source value is available, the ID of the source coding system should be concatenated to condition_source_value using the following convention: condition_source_value\|\|\|coding_system_id.</p> <p>The coding_sytem_id is an integer found in Table 1 in 1.9.1 additional notes section. For example, a condition source value in ICD-9 should be populated as 93.07\|\|\|6. If your source coding system is not found in this table or is unknown, the source value can be left unchanged.</p> <p>Alternatively, if all of your conditions are from a single source coding system, you may communicate that to the PEDSnet DCC and leave the source value unchanged.</p>|

#### 1.8.1 Additional Notes

- The 1/1/2009 date limitation that is used to define a PEDSnet active patient is \*\*NOT\*\* applied to condition_occurrence. All conditions are included for an active patient. For PEDSnet CDM V1, we limit condition_occurrences to final diagnoses only (not reason-for-visit, , and provisional surgical diagnoses such as those recored in EPIC OPTIME). In EPIC, final diagnoses includes both encounter diagnoses and billing diagnoses, problem lists (all problems, not filtered on "chronic" versus "provisional" unless local practices use this flag as intended).
- Condition records are inferred from diagnostic codes recorded in the source data by a clinician or abstractionist for a specific visit. In the current version of the CDM, problem list entries are not used, nor are diagnoses extracted from unstructured data, such as notes.
- Source code systems, like ICD-9-CM, ICD-10-CM, etc., provide coverage of conditions. However, if the code does not define a condition, but rather is an observation or a procedure, then such information is not stored in the CONDITION_OCCURRENCE table, but in the respective tables instead. An example are ICD-9-CM procedure codes. For example, OMOP source-to-concept table uses the MAPPING_TYPE column to distinguish ICD9 codes that represent procedures rather than conditions.
- Condition source values are mapped to standard concepts for cflowonditions in the Vocabulary. Since the icd9-cm diagnosis codes are notB in the concept table, use the source_to_concept_map table where the icd9_code = source_code and the source_vocabulary_id =2 (icd_9) and target_vocabulatory_id=1 (snomed-ct) to locate the correct condition_concept_id value.
- When the source code cannot be translated into a Standard Concept, a CONDITION_OCCURRENCE entry is stored with only the corresponding source_value and a condition_concept_id of 0.
- Codes written in the process of establishing the diagnosis, such as "question of" of and "rule out", are not represented here.

## 1.9 PROCEDURE_OCCURRENCE

The procedure domain contains records of significant activities or processes ordered by and/or carried out by a healthcare provider on the patient to have a diagnostic and/or therapeutic purpose that are not fully captured in another table (e.g. drug_exposure).

Procedures records are extracted from structured data in Electronic Health Records that capture source procedure codes using CPT-4, ICD-9-CM (Procedures), HCPCS or OPCS-4 procedures as orders.

Field | Required | Description | PEDSnet Conventions
 --- | --- | --- | ---
procedure_occurrence_id | Yes | A system-generated unique identifier for each procedure occurrence | This is not a value found in the EHR. Sites may choose to use a sequential value for this field
person_id | Yes | A foreign key identifier to the person who is subjected to the procedure. The demographic details of that person are stored in the person table.
procedure_concept_id | Yes | A foreign key that refers to a standard procedure concept identifier in the Vocabulary. | <p>Valid Procedure Concepts belong to the "Procedure" domain. Procedure Concepts are based on a variety of vocabularies: SNOMED-CT (vocabulary_id = 1), ICD-9-Procedures (vocabulary_id = 3), CPT-4 (vocabulary_id = 4), and HCPCS (vocabulary_id = 5)</p> <p>Procedures are expected to be carried out within one day. If they stretch over a number of days, such as artificial respiration, usually only the initiation is reported as a procedure (CPT-4 "Intubation, endotracheal, emergency procedure").</p> Procedures could involve the administration of a drug, in which case the procedure is recorded in the procedure table and simultaneously the administered drug in the drug table.
procedure_date | Yes | The date on which the procedure was performed.
procedure_type_concept_id | Yes | A foreign key to the predefined concept identifier in the Vocabulary reflecting the type of source data from which the procedure record is derived. (OMOP vocabulary_id = 38) | <p>Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 38)</p> <p>select \* from concept where vocabulary_id = 38 yields 33 valid concept_ids.</p> If none are correct, use concept_id = 0
associated_provider_id | No | A foreign key to the provider in the provider table who was responsible for carrying out the procedure. | <p>Any valid provider_id allowed (see definition of providers in PROVIDER table)</p> Document how selection was made.
visit_occurrence_id | No | A foreign key to the visit in the visit table during which the procedure was carried out. | See VISIT.visit_occurrence_id (primary key)
relevant_condition_concept_id | No | A foreign key to the predefined concept identifier in the vocabulary reflecting the condition that was the cause for initiation of the procedure. | <p>Note that this is not a direct reference to a specific condition record in the condition table, but rather a condition concept in the vocabulary.</p> Use OMOP vocabulary_id = 1
procedure_source_value | No | The source code for the procedure as it appears in the source data. This code is mapped to a standard procedure concept in the Vocabulary and the original code is stored here for reference. | <p>Procedure_source_value codes are typically ICD-9, ICD-10 Proc, CPT-4, HCPCS, or OPCS-4 codes. All of these codes are acceptable source values.</p> <p>If the coding system of the source value is available, the ID of the source coding system should be concatenated to procedure_source_value using the following convention: procedure_source_value\|\|\|coding_system_id.</p> <p>The coding_sytem_id is an integer found in Table 1 in 1.9.1 additional notes section. For example, a procedure source value in CPT-4 should be populated as 42700\|\|\|1. If your source coding system is not found in this table or is unknown, the source value can be left unchanged.</p> <p>Alternatively, if all of your procedures are from a single source coding system, you may communicate that to the PEDSnet DCC and leave the source value unchanged.</p>|

**Table 1: Standard Procedure concept IDs.**

Concept Name | Procedure concept ID | Vocab ID | Vocab Name
 --- | --- | --- | ---
Completed early periodic screening diagnosis and treatment (epsdt) service (list in addition to code for appropriate evaluation and management service)| 2721031 |5 | HCPCS

#### 1.9.1 Additional notes

- The 1/1/2009 date limitation that is used to define a PEDSnet active patient is \*\*NOT\*\* applied to procedure_occurrence. All procedures are included for an active patient. For PEDSnet CDM V1, we limit procedures_occurrences to billing procedures only (not surgical diagnoses).
- Procedure Concepts are based on a variety of vocabularies: SNOMED-CT, ICD-9-Proc, CPT-4, HCPCS and OPCS-4.
- Procedures could reflect the administration of a drug, in which case the procedure is recorded in the procedure table and simultaneously the administered drug in the drug table.
- The Visit during which the procedure was performed is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
- The Provider carrying out the procedure is recorded through a reference to the PROVIDER table. This information is not always available.

**Table 1: Source coding system.**

ID | Source coding system name | 
--- | --- | 
1 | CPT-4, HCPCS Level I | 
2 | HCPCS, HCPCS Level II |
3 | HCPCS Level III |
4 | CPT Category II |
5 | CPT Category III |
6 | ICD-9, ICD9, ICD-9-CM |
7 | ICD-9-Proc |
8 | ICD-10-PCS |
9 | ICD-11-PCS | 
10 | LOINC |
11 | NDC |
12 | Revenue |
13 | BJC-MED |
14 | NDF-RT Indications |
15 | FDB Indications |
16 | Oxmis |
17 | Read |
18 | ICD-10 |

## 1.10 OBSERVATION

The observation domain captures clinical facts about a patient obtained in the context of examination, questioning or a procedure. For the PEDSnet CDM version 1, the observations listed below are extracted from source data. Please assign the specific concept_ids listed in the table below to these observations as observation_concept_ids. Non-standard PCORnet concepts require concepts that have been entered into an OMOP-generated vocabulary (OMOP provided vocabulary_id = 60). ~~See Appendix for SQL INSERT statements that add the necessary rows in the CONCEPT table to support PCORnet CDM V1.0.~~

NOTE: DRG and DRG Type require special logic/processing described below.

- Height/length in cm (use numeric precision as recorded in EHR)
- Height/length type
- Weight in kg (use numeric precision as recorded in EHR)
- Body mass index in kg/m<sup>2</sup> (extracted only if height and weight are not present)
- Systolic blood pressure in mmHg
    - Where multiple readings are present on the same encounter, create observation records for \*\*ALL\*\* readings
- Diastolic blood pressure in mmHg
    - Where multiple readings are present on the same encounter, create observation records for \*\*ALL\*\* readings
- Blood pressure position is described by the selection of a concept_id that contains the BP position as describe below. For example, in Table 1, concept_id 3018586 is Systolic Blood Pressure, Sitting. This concept_id identifies both the measurement (Systolic BP) and the BP position (sitting).
- Biobank availability
- Admitting source
- Discharge disposition
- Discharge status
- Chart availability
- Vital source
- DRG (requires special logic - see Note 4 below)
- Vital source (not captured in PEDSnet CDM 1.0)

Use the following table to populate observation_concept_ids and (where applicable) value_as_concept_ids for the observations listed above. The vocabulary column is used to highlight non-standard codes from vocabulary 39 and 60 and one newly added standard concept from vocabulary 1.

**Table 2: Observation concept IDs for PCORnet concepts. Concept_ids from vocabulary_id 99 are non-standard codes.**

Concept Name | Observation concept ID | Vocab ID | Value as concept ID | Concept description | Vocab ID
 --- | --- | --- | --- | --- | ---
Biobank flag (see Note 5) | 4001345 | | 4188539 | Yes
Biobank flag | 4001345 | | 4188540 | No
Biobank flag | 4001345 | | NULL | No information
Biobank flag | 4001345 | | 0 | Unknown/Other
Admitting source | 4145666 | | 38004205 | Adult Foster Home
Admitting source | 4145666 | | 38004301 | Assisted Living Facility
Admitting source | 4145666 | | 38004207 | Ambulatory Visit
Admitting source | 4145666 | | 8870 | Emergency Department
Admitting source | 4145666 | | 38004195 | Home Health
Admitting source | 4145666 | | 8536 | Home / Self Care
Admitting source | 4145666 | | 8546 | Hospice
Admitting source | 4145666 | | 38004279 | Other Acute Inpatient Hospital
Admitting source | 4145666 | | 8676 | Nursing Home (Includes ICF)
Admitting source | 4145666 | | 8920 | Rehabilitation Facility
Admitting source | 4145666 | | 44814680 | Residential Facility | 60
Admitting source | 4145666 | | 8863 | Skilled Nursing Facility
Admitting source | 4145666 | | 44814682 | No information | 60
Admitting source | 4145666 | | 44814683 | Unknown | 60
Admitting source | 4145666 | | 44814684 | Other | 60
Discharge disposition (See Note 6) | 44813951 | 1 | 4161979 | Discharged alive
Discharge disposition | 44813951 | 1 | 4216643 | Expired
Discharge disposition | 44813951 | 1 | 44814687 | No information | 60
Discharge disposition | 44813951 | 1 | 44814688 | Unknown | 60
Discharge disposition | 44813951 | 1 | 44814689 | Other | 60
Discharge status (see Note 6) | 4137274 | | 38004205 | Adult Foster Home
Discharge status | 4137274 | | 38004301 | Assisted Living Facility
Discharge status | 4137274 | | 4021968 | Against Medical Advice
Discharge status | 4137274 | | 44814693 | Absent without leave | 60
Discharge status | 4137274 | | 4216643 | Expired
Discharge status | 4137274 | | 38004195 | Home Health
Discharge status | 4137274 | | 8536 | Home / Self Care
Discharge status | 4137274 | | 8546 | Hospice
Discharge status | 4137274 | | 38004279 | Other Acute Inpatient Hospital
Discharge status | 4137274 | | 8676 | Nursing Home (Includes ICF)
Discharge status | 4137274 | | 8920 | Rehabilitation Facility
Discharge status | 4137274 | | 44814701 | Residential Facility | 60
Discharge status | 4137274 | | 8717 | Still In Hospital
Discharge status | 4137274 | | 8863 | Skilled Nursing Facility
Discharge status | 4137274 | | 44814705 | Unknown
Discharge status | 4137274 | | 44814706 | Other
Discharge status | 4137274 | | 44814704 | No information
Chart availability (See Note 5) | 4030450 | | 4188539 | Yes
Chart availability | 4030450 | | 4188540 | No
Chart availability | 4030450 | | 0 | Unknown/Other
Chart availability | 4030450 | | NULL | No information
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
Vital | 3038553 | | See Note 1 | BMI
Vital source | 4481472 | 39 | See Note 3 | Patient reported
Vital source | 38000280 | | See Note 3 | Healthcare delivery setting

**Note 1**: For height, weight and BMI observations, insert the recorded measurement into the value_as_numeric field.

**Note 2**: Systolic and diastolic pressure measurements will generate two observation records one for storing the systolic blood pressure measurement and a second for storing the diastolic blood pressure measurement. Select the right SBP or DBP concept code that also represents the CORRECT recording position (supine, sitting, standing, other/unknown). To tie the two measurements together, use the observation_id assigned to the ***systolic*** blood pressure measurement and insert into the value_as_concept_id field of both observations records (the systolic BP measurement and the diastolic BP measurement records). This will provide a direct linkage between the SBP measurement and its associated DBP measurement.

Example: Person_id = 12345 on visit_occurrence_id = 678910 had orthostatic blood pressure measurements performed as follows:

- Supine: Systolic BP 120; Diastolic BP 60
- Standing: Systolic BP 144; Diastolic BP 72

Four rows will be inserted into the observation table. Showing only the relevant columns:

Observation_id | Person_id | Visit_occurrence_id | Observation_concept_id | Observation_type_concept_id | Value_as_Number | Value_as_String | Value_as_Concept_ID
 --- | --- | --- | --- | --- | --- | --- | ---
66661 | 12345 | 678910 | 3009395 | 38000280 | 120 | | 66661
66662 | 12345 | 678910 | 3013940 | 38000280 | 60 | | 66661
66663 | 12345 | 678910 | 3035856 | 38000280 | 144 | | 66663
66664 | 12345 | 678910 | 3019962 | 38000280 | 72 | | 66663

- Observation_concept_id = 3009395 = systolic BP - supine; observation_concept_id = 3013940 = diastolic BP supine
- Observation_concept_id = 3035856 = systolic BP standing; observation_concept_id = 3019962 = diastolic BP standing
- Observation_type_concept_id = 38000280 (observation recorded from EMR).
- Value_as_concept_id = 66661 links two observations for *supine* BPs to the observation ID of the supine systolic BP.
- Value_as_concept_id = 66663 links two observations for *standing* BPs to the observation ID of the standing systolic BP.

**Note 3**: Vital source concept_ids are used as values for the observation_type_concept_id field

**Note 4**: For DRG, use the following logic (must use vocabulary version 4.5):

- The DRG value must be three digits as text. Put into value_as_string in observation
- For all DRGs, set observation_concept_id = 3040464 (hospital discharge DRG), observation_type_concept_id = 38000280 (observation recorded from EMR)
- To obtain correct value_as_concept_id for the DRG:
    - If the date for the DRG \< 10/1/2007, use concept_class = "DRG", invalid_date = "9/30/2007", invalid_reason = 'D' and the DRG value=CONCEPT.concept_code to query the CONCEPT table for correct concept_id to use as value_as_concept_id.
    - If the date for the DRG \>=10/1/2007, use concept_class = "MS-DRG", invalid_reason = NULL and the DRG value = CONCEPT.concept_code to query the CONCEPT table for the correct concept_id to use as value_as_concept_id.

In addition, the following observations are derived via the DCC (concept_ids to be assigned in future version of this document. However, concept_ids are not needed for ETL since these observations will be derived/calculated using scripts developed by DCC):

- Body mass index in kg/m<sup>2</sup> if not directly extracted
- Height/length z score for age/sex using NHANES 2000 norms for measurements at which the person was <240 months of age. In the absence of a height/length type for the measurement, recumbent length is assumed for ages \<24 months, and standing height thereafter.
- Weight z score for age/sex using NHANES 2000 norms for measurements at which the person was \<240 months of age.
- BMI z score for age/sex using NHANES 2000 norms for visits at which the person was between 20 and 240 months of age.
- Systolic BP z score for age/sex/height using NHBPEP task force fourth report norms.
- Diastolic BP z score for age/sex/height using NHBPEP task force fourth report norms.

**Note 5**: In the Observation table, the biobank flag and chart availability concept_ids can appear multiple times capturing changes in patient consent over time. The temporally most recent observation will be used to determine the current consent status.

**Note 6:** Discharge disposition and discharge status appear only once per visit_occurence. These vales can change across different visit_occurrences. Use the visit_occurrence_id to tie these observations to the corresponding visit.

Field | Required | Description | PEDSnet Conventions
 --- | --- | --- | ---
observation_id | Yes | A unique identifier for each observation. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field
person_id | Yes | A foreign key identifier to the person about whom the observation was recorded. The demographic details of that person are stored in the person table.
observation_concept_id | Yes | A foreign key to the standard observation concept identifier in the Vocabulary. | <p>Valid Observation Concepts belong to the "Observation" domain. Observation Concepts are based mostly on the LOINC vocabulary, with some additions from SNOMED-CT.</p> <p>Observations must have an object represented as a concept, and a finding. A finding (see below) is represented as a concept, a numerical value or a verbatim string or more than one of these.</p> <p>There are three Standard Vocabularies defined for observations:</p> <p>Laboratory tests and values: Logical Observation Identifiers Names and Codes (**LOINC**) (vocabulary_id 6).</p> <p>(FYI: Regenstrief also maintains the **"LOINC Multidimensional Classification"** vocabulary_id 49)</p> <p>Qualitative lab results: A set of SNOMED-CT Qualifier Value concepts (vocabulary_id 1)</p> <p>Laboratory units: Unified Code for Units of Measure (**UCUM**( )vocabulary_id 11)</p> <p>All other findings and observables: SNOMED-CT (vocabulary_id 1).</p> For vital signs, pull information from flow sheet rows (EPIC sites only)
observation_date | Yes | The date of the observation. | <p>No date shifting</p> Store and transmit as a full date and time, with as much information as is available and without timezone information or conversion, to avoid ambiguity.
observation_time | No | The time of the observation. | <p>No date shifting</p> Store and transmit as a full date and time, with as much information as is available and without timezone information or conversion, to avoid ambiguity.
observation_type_concept_id | Yes | A foreign key to the predefined concept identifier in the Vocabulary reflecting the type of the observation. | <p>Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 39)</p> <p>select \* from concept where vocabulary_id = 39 yields 7 valid concept_ids.</p> FOR PEDSnet CDM V1, all of our observations are coming from electronic health records so *set this field to concept_id = 38000280* (observation recorded from EMR). When we get data from patients, we will include the non-standard concept_id = 44814721 from vocabulary 99
value_as_number | No\* (see convention) | The observation result stored as a number. This is applicable to observations where the result is expressed as a numeric value. | Value must be represented as at least one of {value_as_number, value_as_string or values_as_concept_id}. There are a few exceptions in vocabulary id 99 where all three value_as_\* fields are NULL.
value_as_string | No\* (see convention) | The observation result stored as a string. This is applicable to observations where the result is expressed as verbatim text. | Value must be represented as at least one of {value_as_number, value_as_string or values_as_concept_id}. There are a few exceptions in vocabulary id 99 where all three value_as_\* fields are NULL.
value_as_concept_id | No\* (see convention) | A foreign key to an observation result stored as a concept identifier. This is applicable to observations where the result can be expressed as a standard concept from the Vocabulary (e.g., positive/negative, present/absent, low/high, etc.). | Value must be represented as at least one of {value_as_number, value_as_string or values_as_concept_id}. There are a few exceptions in vocabulary id 99 where all three value_as_\* fields are NULL.
unit_concept_id | No | A foreign key to a standard concept identifier of measurement units in the Vocabulary. | <p>Please include valid concept ids (consistent with OMOP CDMv4). Predefined value set (valid concept_ids found in CONCEPT table where vocabulary_id = 11)</p> <p>select \* from concept where vocabulary_id = 11 yields 766 valid concept_ids.</p> <p>If none are correct, use concept_id = 0.</p> For the PEDSnet observation listed above, use the following concept_ids: <ul><li>Centimeters (cm): concept_id = 8582</li> <li>Kilograms (kg): concept_id = 9529</li> <li>Kilograms per square meter (kg/m<sup>2</sup>): concept_id = 9531</li> <li>Millimeters mercury (mmHG): concept_id = 8876</li></ul>
associated_provider_id | No | A foreign key to the provider in the provider table who was responsible for making the observation.
visit_occurrence_id | No | A foreign key to the visit in the visit table during which the observation was recorded.
relevant_condition_concept_id | No | A foreign key to the condition concept related to this observation, if this relationship exists in the source data (*e.g.* indication for a diagnostic test).
observation_source_value | No | The observation code as it appears in the source data. This code is mapped to a standard concept in the Vocabulary and the original code is, stored here for reference.
unit_source_value | No | The source code for the unit as it appears in the source data. This code is mapped to a standard unit concept in the Vocabulary and the original code is, stored here for reference.
range_low | No | <p>Optional - Do not transmit to DCC</p> The lower limit of the normal range of the observation. It is not applicable if the observation results are non-numeric or categorical, and must be in the same units of measure as the observation value.
range_high | No | <p>Optional - Do not transmit to DCC.</p> The upper limit of the normal range of the observation. It is not applicable if the observation results are non-numeric or categorical, and must be in the same units of measure as the observation value.

#### Additional Notes

- The 1/1/2009 date limitation that is used to define a PEDSnet active patient is \*\*NOT\*\* applied to observations. All observations are included for an active patient. For PEDSnet CDM V1, we limit observations to only those that appear in Table 1.
- Observations have a value represented by one of a concept ID, a string, \*\*OR\*\* a numeric value.
- The Visit during which the observation was made is recorded through a reference to the VISIT_OCCURRENCE table. This information is not always available.
- The Provider making the observation is recorded through a reference to the PROVIDER table. This information is not always available.

## OBSERVATION PERIOD

The observation period table is designed to capture the time intervals in which data are being recorded for the person. An observation period is the span of time when a person is expected to have the potential of drug and condition information recorded. This table is used to generate the PCORnet CDM enrollment table.

While analytic methods can be used to calculate gaps in observation periods that will generate multiple records (observation periods) per person, for PEDSnet, the logic has been simplified to generate a single observation period row for each patient.

Field |Required | Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---
observation_period_id | Yes | Integer | A system-generate unique identifier for each observation period | This is not a value found in the EHR. Sites may choose to use a sequential value for this field.
person_id | Yes | Integer | A foreign key identifier to the person who is experiencing the condition. The demographic details of that person are stored in the person table.
observation_period_start_date | Yes | Date | The start date of the observation period for which data are available from the data source | <p>Use the earliest encounter date available for this patient.</p> No date shifting
observation_period_end_date | No | Date | The end date of the observation period for which data are available from the source. | <p>Use the last encounter date available for this patient. If there exists one or more records in the DEATH table for this patient, use the latest date recorded in that table.</p> For patients who are still in the hospital or ED or other facility at the time of data extraction, leave this field NULL.

#### Additional Notes

- Because the 1/1/2009 date limitation for "active patients" is not used to limit visit_occurrance, the start_date of an observation period for an active PEDSnet patient may be prior to 1/1/ 2009.

* * *

**APPENDIX**

**PEDSnet-specific Vocabulary 99 has been supplanted by OMOP-supported Vocabulary 60, which contains all of the additional concept_id codes needed in PEDSnet for PCORnet CDM V1.0**

The INSERT statements that created Vocabulary 99 have been removed from this Appendix based on the current use of Vocabulary 60.

* * *

**Elements for future versions**

Date requested | Requestor | Data request | Target PEDSnet DM Version
 --- | --- | --- | ---
10/24/2014 | Chris Forrest | Prescription meds | 2
10/24/2014 | Chris Forrest | Lab results: A1C, TC, HDL, TG, LDL, glucose insulin | 2
