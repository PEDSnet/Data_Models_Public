# Differences Between PEDSnet CDM 5.8 and CDM 5.9

# **** NEW in PEDSnet CDM v5.9 ****

## (1) Additional ETL Guidance for [1.09 Observation](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v5.9_PEDSnet_CDM_ETL_Conventions.md#19-observation-1):

In PEDSnet version 5.9, we are expanding the list of `Social Determinants of Health (SDOH)` and `Patient Reported Outcome (PRO)` surveys to include in the observation table. Please see the linked csv files below for the full lists of survey questions:

* [SDOH Surveys](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets%20%26%20Additional%20Guidance/SDOH_survey_codes.csv)
* [PRO PROMIS Surveys](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets%20%26%20Additional%20Guidance/PRO_PROMIS_survey_codes.csv)

#### Sites are not expected to have representation for all surveys and questions in their source EHR system.

In order to ease the burden of identifying and extracting this additional survey information (names, questions, and answers), sites are encouraged to only extract and submit the raw, unmapped survey information. When received, the PEDSnet DCC will map the survey information to standard pedsnet concepts where applicable. The PEDSnet DCC will attempt to map any observation record that meets the following conditions:

 1. `observation_type_concept_id` = `32862` (Patient filled survey)
 2. `observation_concept_id` = `0` (Unmapped)

#### Please refer below on how to model raw survey data such that the DCC can map to standard concepts: 


Field | Site Responsibility | PEDSnet DCC Responsibility | 
--------|--------------------------|-----------
`observation_id` | Populate with typical primary key value. |
`person_id` | Populate with the `person_id` who answered the survey question.|
`visit_occurrence_id` | Populate with the `visit_occurrence_id` that the survey was taken during (if available).|
`provider_id` | Populate with the `provider_id` who administered the survey (if available).|
`observation_date` / `observation_datetime` | Set Date fields equal to the date/datetime that the survey question was answered or completed. |
`observation_concept_id` | Set `observation_concept_id` = 0 | DCC will use `observation_source_value` to map the raw question name to a standard LOINC concept (if applicable).
`observation_source_concept_id` | Leave NULL | DCC will use `observation_source_value` to map the raw survey name to a standard LOINC concept (if available and applicable).
`observation_source_value` | Please include the question text and the name of the survey that the question belongs to (if available), separated by a pipe delimiter when concatenating. For Example: `Question Text \| Survey Name` | 
`observation_type_concept_id`| Set `observation_type_concept_id` = `32862` (Patient filled survey) |
`value_source_value` | Raw answer to the survey question. <ul><li> If a numerical response is expected (such as number of days, raw score, t-score, etc.), then populate with the numerical value cast as a string. </li> <li> If a text response is expected, then populate with the corresponding text value. </li> <li> If a text response is expected, but only an integer answer exists, there may be a ZC category list table that can be joined to in order to obtain the integer's corresponding text value. In such cases, concatenate the text response with the integer response cast to a string and separate with a pipe delimeter. For Example: `Text Answer \| Integer Answer`</li> </ul> | 
`value_as_concept_id` | Leave NULL | DCC will use the values from `value_source_value` to map the raw answer text to a standard LOINC concept (if applicable).
`value_as_string` | Leave NULL | DCC will extract text from `value_source_value` to populate.
`value_as_number` | Leave NULL | DCC will extract any numerical values from `value_source_value` to populate.

#### Additional Notes on Surveys:
1. Prioritize including surveys for Depression, Anxiety, Food and Housing Stability, and Alcohol Use.

2.  Sites are **encouraged not to modify any code** for surveys that have already been mapped to standard concepts for previous PEDSnet versions (PHQ-2, PHQ-9, Hunger Vital Signs, Food Insecurity).

3. For additional help on where and how to extract these surveys, the [SDOH Surveys](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Codesets%20%26%20Additional%20Guidance/SDOH_survey_codes.csv) and [PRO PROMIS Surveys](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Codesets%20%26%20Additional%20Guidance/PRO_PROMIS_survey_codes.csv) files also include columns indicating where pilot sites found these surveys in their source system.

## (2) Additional Guidance for [1.11 Drug Exposure](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#111-drug-exposure):

In PEDSnet version 5.9, we are adding two new `drug_type_concept_id` values to model additional external drug records sourced from the Data Exchange Repository (DXR).

* #### For drug records from a Health Information Exchange (HIE): 
	* Set `drug_type_concept_id` = `32849` (Health Information Exchange Record)
	* Examples include unverified Epic Care Everywhere records or records sourced from Regional/State HIEs.


* #### For non-dispensed drug records from an external claims source:
	* Set `drug_type_concept_id` = `32810` (Claim)
	* If the claim indicates that the drug has been `dispensed` at a pharmacy, please use  `drug_type_concept_id` = `38000175` (Prescription Dispensed in Pharmacy) instead.


## (3) Guidance for Modeling Mother-Child Relationships:

#### If maternal and delivery information exists in your source EHR system, then: 

1. Ensure that both the Mother and Child have a record in the [person](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#11-person-1) table​ (in case the mother is not currently included in your PEDSnet Cohort).

2. Create a record in the [fact_relationship]((https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v5.9_PEDSnet_CDM_ETL_Conventions.md#113-fact_relationship)) to model the relationship​ as follows:

Field | Value |
--------|--------------------------
`domain_concept_id_1` | 56 (person)​
`fact_id_1` | person_id for the Child
`domain_concept_id_2` | 56 (person)​
`fact_id_2` | person_id for the Mother
`Relationship_concept_id` | 581437 (Child to Parent Measurement)​

## (4) Finalized Guidance for Modeling MAR Actions for Deriving Continuous Infusion Volumes
Based on lessons learned from the Continuous Infusion Volume Derivation Pilot taking place in PEDSnet version 5.7 and 5.8, we are now finalizing guidance for extracting MAR actions and loading them into the `drug_exposure` table. The PEDSnet DCC will then use the individual fluid administration MAR actions to derive the total volume administered when an infusion rate and rate unit are present.

### Data Extraction 
Please extract **all MAR Actions** (including stops and pauses) for **intravenous fluid administrations**, particularly for **continuous infusions and boluses**.

Please be sure to extract the following data for each MAR action:

1. Infusion rate (clarity source `MAR_ADMIN_INFO.INFUSION_RATE`)
2. Infusion rate units (clarity source `MAR_ADMIN_INFO.MAR_INF_RATE_UNIT_C` or `zc_med_unit.name`)
3. Local identifier for the drug order (clarity source `MAR_ADMIN_INFO.ORDER_MED_ID`)
4. MAR Action Name (clarity source `MAR_ACTION_C_NAME`)
5. Datetime of MAR action event (clarity source `MAR_ADMIN_INFO.TAKEN_TIME`)

### Transformation & Loading
Starting in PEDSnet version 5.9, we have removed the `drug_iv_pilot` table from the DDL. Fluid MAR Actions should now be loaded into the `drug_exposure` table such that there is one record for each MAR action.

* To specify which `drug_exposure` records represent a MAR action of an intravenous fluid administration versus other inpatient administrations, we have created a new `concept_id` - `2000001594` "MAR Action of inpatient intravenous fluid administration".

* For each MAR Action record, please set `drug_type_concept_id` = `2000001594` so that the DCC can identify which MAR actions should be grouped to derive total adminstered fluid volumes.

#### The below table specifies where to insert each extracted MAR Action field:

Extracted Field | Target Drug_Exposure Field(s)| Notes|
|--------|--------------------------|------|
`Infusion Rate` | `effective_drug_dose`, `eff_drug_dose_source_value`
`Infusion Rate Units` | `dose_unit_source_value`, `dose_unit_concept_id` | `dose_unit_concept_id`  populated with corresponding concept_id for the infusion rate.
`Local identifier for the drug order` | `drug_source_value` | Include the text `med_id=` concatenated with the local identifier. Use a pipe delimeter to separate from other data in the source value. 
`MAR Action Name` | `drug_source_value`| Use a pipe delimeter to separate from other data in the source value 
`Datetime of MAR action event` | `drug_exposure_start_date`, `drug_exposure_start_datetime`
 
* `drug_exposure` fields other than the target fields listed in the table above should be populated in the typical way that inpatient medication administration records are populated.

* The `drug_source_value` should be formatted as follows:
	* `Local identifier for the drug order` | `MAR action name` | Local Drug Code | Local Drug Name
	* Ex: `med_id=200100074|Rate Change|372000|FUROSEMIDE IV INFUSION-FUROSEMIDE 10 MG/ML (UNDILUTED) INJECTION`

#### Please refer to the [Continuous IV Fluid Volume Guidance](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets%20%26%20Additional%20Guidance/Continuous%20IV%20Fluid%20Volume%20Guidance.md) documentation for for further details.
