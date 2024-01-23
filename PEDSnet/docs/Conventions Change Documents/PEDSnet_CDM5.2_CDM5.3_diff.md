# Differences between PEDSnet CDM 5.2 and CDM 5.3

## **** NEW in PEDSnet CDM v5.3 ****

### 1. Updates to [1.8 Procedure Occurrence](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#18-procedure-occurrence) Guidance:

Change of guidance for populating `procedure_concept_id` and `procedure_source_concept_id`.

> After presenting several options on how to harmonize PEDSnet Standards with OMOP Standards for populating procedure data in the  [1/5/2024 Data Models Meeting](https://github.com/PEDSnet/Data_Models/blob/master/Data_Models_Meetings/2024/DMWG_20240105.pptx), we have agreed on the following "Have your cake and eat it too" Standard:

**`procedure_concept_id`**  
> 
> * Prioritize concepts that are standard and valid (I.E. `standard_concept = 'S'` AND `current date < valid_end_date` AND `invalid_reason is NULL`) over concepts in the CPT-4, ICD-9-CM, ICD-10, HCPCS or OPCS-4 vocabularies.
> 
> * This guidance aligns more with the current OMOP 5.4 [procedure concept id standards](http://ohdsi.github.io/CommonDataModel/cdm54.html#PROCEDURE_OCCURRENCE)
> 
> * NOTE that at this time we are NOT restricting to concepts with `domain_id = 'Procedure'` in order to allow mappings for all variety of Ordered or Billed procedures (for example lab orders that may map to a concept with `domain_id = 'Measurement'`)

**`procedure_source_concept_id`**

> * Prioritize concepts that are in the CPT-4, ICD-9-CM, ICD-10, HCPCS or OPCS-4 vocabularies over concepts that are standard and valid.
> 
> * This guidance aligns with PEDSnet guidance for `procedure_concept_id` standards prior to version 5.3.

See details on how to represent procedure\_concept\_id, procedure\_source\_concept\_id, and procedure\_source\_value given source codes below:

> Site Information|procedure\_concept\_id|procedure\_source\_concept\_id|procedure\_source_value
> --- | --- | --- | ---
> Codes sourced from Ordered or Billed procedures using the CPT-4, ICD-9-CM (Procedures), ICD-10 (Procedures), HCPCS or OPCS-4 vocabularies.| Utilize the concept\_relationship table's "Maps to" relationship\_id to map the CPT-4, ICD-9-CM, ICD-10, HCPCS or OPCS-4 code's corresponding concept\_id to a standard concept\_id. NOTE that Standard concepts will always have a "Maps to" relationship\_id with itself in the concept\_relationship table and thus the ETL logic should remain the same regardless of whether the initial code's concept\_id is Standard or not.|Corresponding CPT-4, ICD-9-CM (Procedures),ICD-10 (Procedures), HCPCS or OPCS-4 concept\_id regardless of whether the concept\_id is both Standard and Valid.| Procedure Name \| Procedure Source Code
> Codes sourced from Ordered or Billed procedures using Custom Procedure Coding or Coding in a vocabulary outside of CPT-4, ICD-9-CM, ICD-10, HCPCS or OPCS-4. | If the code has a corresponding concept_id in the vocabulary that is both Standard and Valid, please use that concept\_id. If the code has a corresponding concept\_id but that concept is not standard and valid, utilize the concept\_relationship table's "Maps to" relationship\_id to map to a valid and standard concept\_id. If the code does not have a corresponding concept\_id, utilize local mappings used at your instituion for billing to get to a code with a concept in the Vocabulary and use the concept\_relationship table's "Maps to" relationship\_id to map to a valid and standard concept\_id. If none of the above are options for your code then utilize manual mapping logic to map the code to the most closely representative standard and valid concept. | Corresponding or most closely representave CPT-4, ICD-9-CM (Procedures),ICD-10 (Procedures), HCPCS or OPCS-4 concept\_id regardless of whether the concept\_id is both Standard and Valid. If no representative code exists then set equal to 0.  | Procedure Name \| Custom Procedure Code


### 2. Update to [1.6 Visit Occurrence](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#16-visit_occurrence) Guidance:

Additional data required for populating `visit_source_value`.

> As a first step towards creating a system for "rolling up" inpatient visits, please add any additional metadata to the `visit_source_value` field that can help differentiate "Inpatient Non-Admissions" from typical inpatient or outpatient visits. In particualr, we are looking to differentiate the following visits:
> 
> * Dialysis
> * Day Surgery
> * Infusion
> * Day Medicine / Day Hospital
> 
> Please use a pipe delimeter `|` to separate any new data found to identify inpatient non-admissions from data that is already mapped to `visit_source_value`. 
> 
> For Sites using the Clarity Data Model, the following data elements may be useful in probing for such information:
> 
> * `zc_disp_enc_type.name` (Encounter Type)
> * `zc_pat_class.name` (ADT Class)
> * `zc_hosp_admsn_type.name` (Hospital Admission Type)
> * `clarity_prc.prc_name` (Visit Type)
> 
> Other information such as department name or department type may be useful in probing for the inpatient non-admissions visit categories listed above.
> 
> NOTE that this additional data is only needed for visits that are suspicious of being inpatient non-admissions. If easier for sites, this additional data can be added for ALL visits, but is not necesary.
> 



### 3. Update to [1.23 Cohort](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#123-cohort-1) Data Model:

Change in Cohort Table's Primary Key.

> The Cohort table's primary key will now also include the field `cohort_start_datetime` and thus each record requires a unique combination of `cohort_definition_id` + `subject_id` + `cohort_start_datetime`.
> 
> `cohort_start_datetime` was added to allow cases where a patient may be enrolled in a signle arm of a clincal trial multiple times at different dates.
> 
> This Data Model change will be reflected in the [PEDSnet v5.3 DDL](https://data-models-sqlalchemy.research.chop.edu/pedsnet/5.3.0/).

### 4. Update to [1.24 Cohort Definition](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#18-procedure-occurrence) Guidance:

Release of CSV file to populate the Cohort Definition Table Locally. 

> Each record of the Cohort Definition table represents a unique clinical trial arm used in studies within PEDSnet. These trial arms and their IDs will be maintained at the DCC and distributed for sites to populate locally. 
> 
> 
> For consistency in updates and ease of use of sites populating, we will be distributing a `cohort_definition.csv` file within the quarterly Vocabulary Release for sites to populate their local tables with. 
> 
> The current list will also be kept in [Note 1 of the Cohort Table Conventions] (https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#124-cohort_definition).
> 
> \*** Note that `cohort_definition_id` is part of the primary key for the Cohort table and therefore needs to be populated in the Cohort_Definition to be properly referenced in Cohort. ***


	
	
## **** Reminders ****

### Sites submitting RECOVER data with v5.3 submission

For sites submiting RECOVER data along with the v5.3 submission, please provide a CSV of patients meeting the RECOVER inclusion criteria with an inclusion reason.

Please use the original [**RECOVER** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/RECOVER%20Cohort.md#data-submission). 

### Sites submitting COVID data with v5.3 submission

For sites submiiting COVID data along with the v5.3 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. 

Please use the original [**COVID** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).
