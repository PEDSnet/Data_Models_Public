# ETL conventions for use with i2b2 targeting PEDSnet CDM V2.0

***Does not yet address meds (drug exposure domain)***

Notes:

1. See also https://github.com/PEDSnet/Data_Models/tree/master/PEDSnet/V2, especially https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/V2/docs/Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md.

2. Representation of null, empty, or non-conforming values:

Null Name | Definition of each field
 --- | ---
'NI' = No Information | A data field is present in the source system, but the source value is null or blank
'UN' = Unknown | A data field is present in the source system, but the source value explicitly denotes an unknown value
'OT' = Other | A data field is present in the source system, but the source value cannot be mapped to the CDM

* * *
## Table of Contents
####[1.1 PATIENT_DIMENSION](i2b2_pedsnet_v2_etl_conventions.md#11-patient_dimension-1)
####[1.2 PROVIDER_DIMENSION](i2b2_pedsnet_v2_etl_conventions.md#12-provider_dimension-1)
####[1.3 VISIT_DIMENSION](i2b2_pedsnet_v2_etl_conventions.md#13-visit_dimension-1)
####[1.4 CONCEPT_DIMENSION](i2b2_pedsnet_v2_etl_conventions.md#14-concept_dimension-1)
####[1.5 OBSERVATION_FACT](i2b2_pedsnet_v2_etl_conventions.md#15-observation_fact-1)
* * *

## 1.1 PATIENT_DIMENSION

The `patient_dimension` table is used to populate the PEDSnet `person`, `death`, and `location` tables.

Field |Required | Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---
age_in_years_num | No | Integer | Age in years | 
birth_date | Yes* | Datetime | Birth date and time | For data sources where the year of birth is not available, the approximate year of birth should be derived based on any age group categorization available.
death_date | No | Datetime | Death date and time | 
download_date | No | Datetime | Date the data was downloaded from the source system | Not used.
ethnicity_cd | No | Varchar | Ethnicity | Possible values include 'NOTHISPANIC', 'HISPANIC', 'NI', 'UN', and 'OT'.
gestational_age_num | No | Integer | Gestational age in weeks | Specify NULL if not known.
import_date | No | Datetime | Date data was imported into i2b2 CDM | Not used.
income_cd | No | Varchar | Income | Not used.
language_cd | No | Varchar | Primary language spoken | Not used.
marital_status_cd | No | Varchar | Marital status | Not used.
patient_blob | No | Varchar | XML containing additional patient description | Not used.
patient_num | Yes* | Integer | A unique, stable pseudo-identifier for the patient. | This is not a value found in the EHR.<p>PATIENT_NUM must be unique for all patients within a single data set, and it must be stable across across data extractions.  A mapping from the pseudo-identifier in this field to a real patient ID or MRN from the source EHR must be kept at the local site. This mapping is not shared with the data coordinating center. It is used only by the site for re-identification for study recruitment or for data quality review.
race_cd | No* | Varchar | Race | Possible values include 'amer.Indian', 'asian', 'asian/pac. isl', 'black', 'white', 'multi', 'refused', 'ni', 'ot', or 'unk'. ('unk' is not a typo; use 'unk instead of 'un' to represent 'unknown').<p> Details of categorical definitions: <ul><li>**-American Indian or Alaska Native**: A person having origins in any of the original peoples of North and South America (including Central America), and who maintains tribal affiliation or community attachment.</li> <li>**-Asian**: A person having origins in any of the original peoples of the Far East, Southeast Asia, or the Indian subcontinent including, for example, Cambodia, China, India, Japan, Korea, Malaysia, Pakistan, the Philippine Islands, Thailand, and Vietnam.</li> <li>**-Black or African American**: A person having origins in any of the black racial groups of Africa.</li> <li>**-Native Hawaiian or Other Pacific Islander**: A person having origins in any of the original peoples of Hawaii, Guam, Samoa, or other Pacific Islands.</li> <li>**-White**: A person having origins in any of the original peoples of Europe, the Middle East, or North Africa.</li></ul> <p>For patients with multiple races (i.e. biracial), race is considered a single concept, meaning there is only one race slot. If there are multiple races in the source system, use 'multi.'
religion_cd | No | Varchar | Religion | Not used.
sex_cd | Yes | Varchar | Gender | Possible values include 'M', 'F', 'UN', 'NI', and 'OT'.
sourcesystem_cd | No | Varchar | Source system for the data | Not used.
statecityzip_path | No | Varchar | State | 2-character state abbreviation.  If the address is not in the US, please prepend the country name followed by a colon.
update_date | No | Datetime | Date the row was updated by the source system (date is obtained from the source system) | Not used.
upload_id | No | Integer | A numeric id given to the upload | Not used.
vital_status_cd | No | Varchar | Vital status | Possible values are 'Alive', 'Deceased', or 'Not Recorded' (in contrast to standard i2b2 usage of this field).
zip_cd | No | Varchar | Zip code | Prefer 5-digit zip codes.  If the address is not in the US (as indicated by the statecityzip_path field), the zip code will be available in a source value field but will not be used as a US zip code.

\* Fields marked with an asterisk are important for responding to PCORNet queries. If sites have any information on this filed in the source EHR then these fields should be populated in the i2b2 CDM instance.


## 1.2 PROVIDER_DIMENSION

The `provider_dimension` table is used to populated the PEDSnet `provider` table.

Field |Required | Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---
dea | No | Varchar | The Drug Enforcement Administration (DEA) number of the provider. | Do not transmit to the DCC
department_id | No | Integer | Department ID | Not used.
department_name | No | Varchar | Department name | Not used.
download_date | No | Datetime | Date the data was downloaded from the source system | Not used.
gender_cd | No | Varchar | Gender of the provider | 
import_date | No | Datetime | Date data was imported into i2b2 CDM | Not used.
name_char | No | Varchar | Name of provider | Do not transmit to the DCC
npi | No | Varchar | The National Provider Identifier (NPI) of the provider. | Do not transmit to the DCC
provider_blob | No | Varchar | XML containing additional provider information | Not used.  This would be a possible location for provider care_site in the future.
provider_id | No | Varchar | A unique, stable pseudo-identifier for the provider | This is not a value found in the EHR.<p>PROVIDER_ID must be unique for all providers within a single data set, and it must be stable across across data extractions.  A mapping from the pseudo-identifier in this field to a real provider ID from the source EHR must be kept at the local site. This mapping is not shared with the data coordinating center. Sites should document who they have included as a provider.
provider_path | No | Varchar | description | Not used.  This would be a possible location for provider care_site in the future.
sourcesystem_cd | No | Varchar | Coded value for the data source system | Not used.
specialty_source_c | No | Varchar | Code for specialty | This is a number represented as a string that is looked up in the `specialty_c` column of the `tbl_provider_map` table during the i2b2-to-PEDSnet transformation.
specialty_source_value | No | Varchar | The source code for the provider specialty as it appears in the source data, stored here for reference. | Optional. May be obfuscated if deemed sensitive by local site.
update_date | No | Datetime | Date the row was updated by the source system (date is obtained from the source system) | Not used.
upload_id | No | Integer | A numeric id given to the upload | Not used.

#### 1.2.1 Additional Notes

- For PEDSnet, a provider is any individual (MD, DO, NP, PA, RN, etc) who is authorized to document care.
- Providers are not duplicated in the table.

## 1.3 VISIT_DIMENSION

The `visit_dimension` table is used to populate the PEDSnet
`visit_occurrence` and `observation` tables.  (For the latter,
admitting source, discharge status, and discharge disposition records
are created from `visit_dimension`).

Field |Required | Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---
active_status_cd | No | Varchar | Whether the visit is ongoing or not | Not used.
admit_src_destcd | No | Varchar | Admitting source | <p>Possible values: 'ADMITTING_SOURCE:AV', 'ADMITTING_SOURCE:ED', 'ADMITTING_SOURCE:HH', 'ADMITTING_SOURCE:HO', 'ADMITTING_SOURCE:HS', 'ADMITTING_SOURCE:IP', 'ADMITTING_SOURCE:NH', 'ADMITTING_SOURCE:SN', 'ADMITTING_SOURCE:NI', 'ADMITTING_SOURCE:OT', and 'ADMITTING_SOURCE:UN'.</p>  <p>These values correspond to the admitting source values in Table 1 in the [Observation section](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/V2/docs/Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#19-observation-1) of the PEDSnet ETL Conventions document.</p>
disch_disp_destcd | No | Varchar | Discharge disposition | <p>Possible values: 'DISCHARGE_DISPOSITION:A', 'DISCHARGE_DISPOSITION:E', 'DISCHARGE_DISPOSITION:NI', 'DISCHARGE_DISPOSITION:OT', and 'DISCHARGE_DISPOSITION:UN'.</p>  <p>These values correspond to the discharge disposition values in Table 1 in the [Observation section](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/V2/docs/Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#19-observation-1) of the PEDSnet ETL Conventions document.</p>
disch_status_destcd | No | Varchar | Discharge status | <p>Possible values: 'DISCHARGE_STATUS:AM', 'DISCHARGE_STATUS:AW', 'DISCHARGE_STATUS:EX', 'DISCHARGE_STATUS:HH', 'DISCHARGE_STATUS:HO', 'DISCHARGE_STATUS:HS', 'DISCHARGE_STATUS:IP', 'DISCHARGE_STATUS:NH', 'DISCHARGE_STATUS:RH', 'DISCHARGE_STATUS:RS', 'DISCHARGE_STATUS:SH', 'DISCHARGE_STATUS:SN', 'DISCHARGE_STATUS:NI', 'DISCHARGE_STATUS:OT', and 'DISCHARGE_STATUS:UN'.</p> <p>These values correspond to the discharge status values in Table 1 in the [Observation section](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/V2/docs/Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#19-observation-1) of the PEDSnet ETL Conventions document.</p>
download_date | No | Datetime | Date the data was downloaded from the source system | Not used.
encounter_num | Yes* | Integer | A unique identifier for each patient visit or encounter at a healthcare provider. | This is not a value found in the EHR. Sites may choose to use a sequential value for this field. Do not use institutional encounter ID.
end_date | No* | Datetime | The end date and time of the visit. | <p>No date shifting.  If the encounter is on-going at the time of ETL, this should be null. If there is no time associated with the source date, use midnight.
import_date | No | Datetime | Date data was imported into i2b2 CDM | Not used.
inout_cd | Yes* | Varchar | The type or source of the visit (place of service) | <p>Possible values: 'ED' (emergency department), 'IP' (in-patient), 'AV' (ambulatory visit), 'OA' (other ambulatory visit), 'OP' (outpatient), 'OT' (other), 'UN' (unknown), or NULL (no information).</p>  <p>This field does not currently accept 'NI' (no information).</p>
length_of_stay | No | Integer | Length of stay in days, rounded to nearest day | Not used.
location_cd | No | Varchar | Location code | Not used.
location_path | No | Varchar | Location path | Not used.
patient_num | Yes* | Integer | A foreign key to the patient in the patient_dimension table who was associated with the visit. | 
provider_id | No* | Varchar | A foreign key to the provider in the provider_dimension table who was associated with the visit. | <p>Use attending or billing provider for this field if available, even if multiple providers were involved in the visit. Otherwise, make site-specific decision on which provider to associate with visits and document.</p> *NOTE: this is NOT required in OMOP CDM v4, but appears in OMOP CDMv5.*
sourcesystem_cd | No | Varchar | Coded value for the data source system | Not used.
start_date | Yes* | Datetime | The start date and time of the visit. | No date shifting. Full date and time. If there is no time associated with the source date, use midnight.
update_date | No | Datetime | Date the row was updated by the source system (date is obtained from the source system) | Not used.
upload_id | No | Integer | A numeric id given to the upload | Not used.
visit_blob | No | Varchar | XML containing other visit information | Not used.

\* Fields marked with an asterisk are important for responding to PCORNet queries. If sites have any information on this filed in the source EHR then these fields should be populated in the i2b2 CDM instance.

#### 1.3.1 Additional Notes

- Currently there is no care site information associated with visits.  In the future, this could perhaps be stored in the `location_cd` or `location_path` fields.


## 1.4 CONCEPT_DIMENSION

The `concept_dimension` table is *not used* in the generation of PEDSnet data.

Field |Required | Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---
concept_blob | No | Varchar | XML containing other information about a concept | Not used.
concept_cd | No | Varchar | Concept code | Not used.
concept_path | No | Varchar | Concept path | Not used.
download_date | No | Datetime | Date the data was downloaded from the source system | Not used.
import_date | No | Datetime | Date data was imported into i2b2 CDM | Not used.
name_char | No | Varchar | Concept name | Not used.
sourcesystem_cd | No | Varchar | Coded value for the data source system | Not used.
update_date | No | Datetime | Date the row was updated by the source system (date is obtained from the source system) | Not used.
upload_id | No | Integer | A numeric id given to the upload | Not used.


## 1.5 OBSERVATION_FACT

The `observation_fact` table is used to populate the PEDSnet `observation`, `measurement`, `condition_occurrence` and `procedure_occurrence` tables.

Field |Required | Data Type | Description | PEDSnet Conventions
 --- | --- | --- | --- | ---
concept_cd | Yes | Varchar | Type/concept of observation | Possible values: <ul><li>'ICD9:\*' (for condition/diagnosis, i.e. `modifier_cd` in 'PDX:P', 'PDX:OT', 'DX_SOURCE:HC')</li><li>'ICD9:\*', 'CPT:\*', 'HCPCS:\*', 'MSDRG:\*', or 'CMSDRG:\*' (for procedure, i.e. `modifier_cd` equal to 'ORIGPX:MAPPED')</li><li>'DIASTOLIC', 'SYSTOLIC', 'WT', 'HT', or 'ORIGINAL_BMI' (numerical measurements; `modifier_cd` irrelevant).</li><li>'LOINC:\*' (for labs -- `modifier_cd` irrelevant)</li></ul>  <p>The coding system entries (e.g. 'XXX:YYY') have values YYY that are valid for the specified coding system XXX.  The coding system values must exist as valid `concept_code` values in the PEDSnet V2 vocabulary concept table, constrained by the appropriate `vocabulary_id` ('DRG'), `concept_class_id` ('DRG' for CMDRG, 'MS-DRG' for MSDRG), and `invalid_reason` ('D' for CMSDRG, NULL for MSDRG).</p>
confidence_num | No | Float | Assessment of data accuracy | Not used.
download_date | No | Datetime | Date the data was downloaded from the source system | Not used.
encounter_num | No | Varchar | Foreign key referring to `visit_occurrence.encounter_num` | 
end_date | No | Datetime | End date/time of the observation | Used when populating the condition_occurrence table; otherwise not used.
import_date | No | Datetime | Date data was imported into i2b2 CDM | Not used.
instance_num | No | Varchar | Encoded instance number that allows more that one modifier to be provided for each `concept_cd`. Each row will have a different `modifier_cd` but a similar `instance_num`. | Not used.
location_cd | No | Varchar | A code representing the hospital associated with this visit. | Not used.
modifier_cd | No | Varchar | Modifier code for a concept | Possible values: <ul><li>For condition/diagnosis: 'PDX:P' (primary condition), 'PDX:OT' (secondary condition), or 'DX_SOURCE:HC' (EHR problem list entry).</li><li>For procedure: value must be 'ORIGPX:MAPPED'.</li></ul>
nval_num | No | Varchar | A numerical value | Contains a numerical value when `valtype_cd` = 'N'
observation_blob | No | Varchar | Extra information about an observation | For labs measurements (`concept_cd` like 'LOINC:%'), this contains a semi-colon-separated list of labs attributes: '.*reference_low:([^;]+);reference_high:([^;]+);[^;]+;proc_id:([^;]+);proc_name:([^;]+);[^;]+;[^;]+;component_name:([^;]+)'
patient_num | No | Varchar | A foreign key to the patient in the `patient_dimension` table who was associated with the visit. | 
provider_id | No | Varchar | A foreign key to the provider in the `provider_dimension` table who was associated with the visit or observation. | Any valid `provider_id` allowed (see definition of providers in PROVIDER table).  Document how selection was made.
quantity_num | No | Varchar | Quantity of `nval_num` | Not used.
sourcesystem_cd | No | Varchar | Coded value for the data source system | Not used.
start_date | No | Datetime | Start date/time of the observation | No date shifting.
tval_char | No | Varchar | Text value or modifier of an observation | When `valtype_cd` = “T”, stores the text value of the observation.  When `valtype_cd` = “N”: <ul><li>E = Equals</li><li>NE = Not equal</li><li>L = Less Than</li><li>LE = Less than and Equal to</li><li>G = Greater Than</li><li>GE = Greater than and Equal to</ul>
units_cd | No | Varchar | Units in which a numeric measurement is expressed | Possible values: <ul><li>'in' or 'cm' (for `concept_cd` 'HT').</li><li>'lbs' or 'kg' (for `concept_cd` 'WT').</li><li>'mm Hg' (for `concept_cd` 'SYSTOLIC' or 'DIASTOLIC')</li></ul><p>For 'in' and 'lbs', case is significant.</p>
update_date | No | Datetime | Date the row was updated by the source system (date is obtained from the source system) | Not used.
upload_id | No | Integer | A numeric id given to the upload | Not used.
valtype_cd | No | Varchar | Data type of the observation | Possible values: <ul><li>N = Numeric</li><li>T = Text (enums/short messages) </li></ul>  <p>Determines whether the observation value is placed in `nval_num` or `tval_char`.</p>
valueflag_cd | No | Varchar | Contains metadata about the value | <p>Not used in PEDSnet v2.</p><p><i>In i2b2, it is used in conjunction with `valtype_cd` = “B”, “NLP”, “N”, or “T”.  When `valtype_cd` = “B” or “NLP” it is used to indicate whether or not the blob field is encrypted ("X" means encrypted).  When `valtype_cd` = “N” or “T”, it is used to flag outlying or abnormal values ("H" = high, "L" = low, "A" = abnormal).</i></p>
