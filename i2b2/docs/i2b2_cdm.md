I2B2 Common Data Model For PEDSnet (Draft)

This document will describe the i2b2 tables that relevant PEDSnet sites should
submit to the PEDSnet Data Coordinating Center for conversion to the PEDSnet
CDM.

As of Feb 12, 2015, there are no column descriptions or notes.

## I2B2 Table

Field | Required | Type | Description | Notes
--- | --- | --- | --- | --- 
c_hlevel | Yes | numeric | Not described |
c_fullname | Yes | varchar | Not described |
c_name | Yes | varchar | Not described |
c_synonym_cd | Yes | varchar | Not described |
c_visualattributes | Yes | varchar | Not described |
c_totalnum | No | numeric | Not described |
c_basecode | No | varchar | Not described |
c_metadataxml | No | varchar | Not described |
c_facttablecolumn | Yes | varchar | Not described |
c_tablename | Yes | varchar | Not described |
c_columnname | Yes | varchar | Not described |
c_columndatatype | Yes | varchar | Not described |
c_operator | Yes | varchar | Not described |
c_dimcode | Yes | varchar | Not described |
c_comment | No | varchar | Not described |
c_tooltip | No | varchar | Not described |
m_applied_path | Yes | varchar | Not described |
update_date | Yes | date | Not described |
download_date | No | date | Not described |
import_date | No | date | Not described |
sourcesystem_cd | No | varchar | Not described |
valuetype_cd | No | varchar | Not described |
m_exclusion_cd | No | varchar | Not described |
c_path | No | varchar | Not described |
c_symbol | No | varchar | Not described |

## CONCEPT_DIMENSION Table

Field | Required | Type | Description | Notes
--- | --- | --- | --- | --- 
concept_path | Yes | varchar | Not described | 
concept_cd | Yes | varchar | Not described |
name_char | No | varchar | Not described |
concept_blob | No | varchar | Not described |
update_date | No | date | Not described |
download_date | No | date | Not described |
import_date | No | date | Not described |
sourcesystem_cd | No | varchar | Not described |
upload_id | No | integer | Not described |


## PATIENT_DIMENSION Table

Field | Required | Type | Description | Notes
--- | --- | --- | --- | --- 
patient_num | Yes | numeric | Not described |
vital_status_cd | No | varchar | Not described |
birth_date | No | date | Not described |
death_date | No | date | Not described |
sex_cd | No | varchar | Not described |
age_in_years_num | No | numeric | Not described |
language_cd | No | varchar | Not described |
race_cd | No | varchar | Not described |
marital_status_cd | No | varchar | Not described |
religion_cd | No | varchar | Not described |
zip_cd | No | varchar | Not described |
statecityzip_path | No | varchar | Not described |
income_cd | No | varchar | Not described |
patient_blob | No | varchar | Not described |
update_date | No | date | Not described |
download_date | No | date | Not described |
import_date | No | date | Not described |
sourcesystem_cd | No | varchar | Not described |
upload_id | No | numeric | Not described |
ethnicity_cd | No | varchar | Not described |

## VISIT_DIMENSION Table

Field | Required | Type | Description | Notes
--- | --- | --- | --- | --- 
encounter_num | Yes | numeric | Not described |
patient_num | Yes | numeric | Not described |
active_status_cd | No | varchar | Not described |
start_date | No | date | Not described |
end_date | No | date | Not described |
inout_cd | No | varchar | Not described |
location_cd | No | varchar | Not described |
location_path | No | varchar | Not described |
length_of_stay | No | numeric | Not described |
visit_blob | No | varchar | Not described |
update_date | No | date | Not described |
download_date | No | date | Not described |
import_date | No | date | Not described |
sourcesystem_cd | No | varchar | Not described |
upload_id | No | numeric | Not described |

## OBSERVATION_FACT Table

Field | Required | Type | Description | Notes
--- | --- | --- | --- | --- 
encounter_num | Yes | numeric | Not described |
patient_num | Yes | numeric | Not described |
concept_cd | Yes | varchar | Not described |
provider_id | Yes | varchar | Not described |
start_date | Yes | date | Not described |
modifier_cd | Yes | varchar | Not described |
instance_num | Yes | numeric | Not described |
valtype_cd | No | varchar | Not described |
tval_char | No | varchar | Not described |
nval_num | No | numeric | Not described |
valueflag_cd | No | varchar | Not described | 
quantity_num | No | numeric | Not described |
units_cd | No | varchar | Not described | 
end_date | No | date | Not described |
location_cd | No | varchar | Not described | 
observation_blob | No | varchar | Not described | 
confidence_num | No | numeric | Not described |
update_date | No | date | Not described |
download_date | No | date | Not described | 
import_date | No | date | Not described | 
sourcesystem_cd | No | varchar | Not described | 
upload_id | No | numeric | Not described |
