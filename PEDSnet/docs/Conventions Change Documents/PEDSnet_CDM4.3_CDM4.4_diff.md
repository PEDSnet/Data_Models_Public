# Differences between PEDSnet CDM 4.3 and CDM 4.4

## **** NEW in PEDSnet CDM v4.4 ****

### [1.3 Location](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.4_PEDSnet_CDM_ETL_Conventions.md#13-location-1)
- Addition of `country_concept_id` column
- Addition of `country_source_value` column
- Addition of `latitude` column
- Addition of `longitude` column
- Addition of `census_block_group` column

### [1.6 Visit_Occurrence](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.4_PEDSnet_CDM_ETL_Conventions.md#16-visit_occurrence)
- Rename of `discharge_to_concept_id` column to `discharged_to_concept_id`
- Rename of `discharge_to_source_value` column to `discharged_to_source_value`

### [1.8 Procedure_Occurrence](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.4_PEDSnet_CDM_ETL_Conventions.md#18-procedure_occurrence)
- Addition of `procedure_end_date` column
- Addition of `procedure_end_datetime` column
- Update to `procedure_type_concept_id` column covention to record Primary and Secondary EHR/Order based procedures.

### [1.9 Observation](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.4_PEDSnet_CDM_ETL_Conventions.md#19-observation-1)
- Addition of `value_source_value` column

### [1.12 Measurement](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.4_PEDSnet_CDM_ETL_Conventions.md#112-measurement-1)
- Addition of `unit_source_concept_id` column.

### [1.18 Device Exposure](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v4.4_PEDSnet_CDM_ETL_Conventions.md#118-device_exposure)
- Addition of `production_id` column. (Corresponds to portion of unique device identifier)
- Addition of `unit_concept_id` column.
- Addition of `unit_source_concept_id` column.
- Addition of `unit_source_value` column.
- Mapping guidance for `placement_concept_id`from the NEST Cardiac Team added to the [NEST Cardiac Stent Page](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/NEST/NEST-CardiacStents.md)



### [COVID- 19 Updates](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/COVID-19%20Cohort.md)

#### Inclusion Criteria Expansion

PCORnet's COVID-19 inclusion criteria (by extension our PEDSnet COVID-19 inclusion criteria) currently includes:

- Persons diagnosed with COVID-19 OR
- Persons with a COVID-19 Test OR
- Persons with a Visit on or after 01-01-2020 with a respiratory like illness

It has now been expanded to include an updated set of labs and criteria:

- Persons with a COVID-19 Vaccine (* ***NEW*** *)

#### COVID Inclusion File Update

If persons are being included for having a covid vaccination, please use the following text to identify them in the COVID Inclusion File.

- COVID-19 Vaccination
- HCW-COVID-19 Vaccination

#### COVID-19 Vaccine Mapping

The COVID-19 page has been updated to include mapping helpers for `immunization`, `drug_exposure` and `procedure_occurrence `mapping concepts for COVID-19 vaccinations.

<details><summary>Click here for table preview</summary>

Procedure_concept_id|	Procedure_concept_code|	Procedure Vocabulary|	Drug_concept_id|	Drug Concept Name|	Drug Vocabulary|	immunization_concept Id |Immunization Concept Name	|immunization_concept_code	|Immunization Vocabulary
---|---|---|---|---|---|---|---|---|---
Pfizer-Biontech|	766238|	91300|	CPT4|	37003436	|SARS-CoV-2 (COVID-19) vaccine, mRNA-BNT162b2 0.1 MG/ML Injectable Suspension|	RxNorm	|724907	|SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 30 mcg/0.3mL dose|	208|	CVX
Moderna |	766239|	91301|	CPT4	|37003518|	SARS-CoV-2 (COVID-19) vaccine, mRNA-1273 0.2 MG/ML Injectable Suspension|	RxNorm	|724906|	SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 100 mcg/0.5mL dose	|207|	CVX
AstraZeneca |	766240|	91302|	CPT4|	1230962|	AZD1222 Astrazeneca COVID-19 vaccine, DNA, spike protein, chimpanzee adenovirus Oxford 1 (ChAdOx1) vector, preservative free, 5x1010 viral particles/0.5mL dosage, for intramuscular use|	NDC	|724905	|SARS-COV-2 (COVID-19) vaccine, vector non-replicating, recombinant spike protein-ChAdOx1, preservative free, 0.5 mL|	210|	CVX
Janssen|766241|	91303|	CPT4	|739906|	SARS-COV-2 (COVID-19) vaccine, vector - Ad26 100000000000 UNT/ML Injectable Suspension|	RxNorm|	702866|	SARS-COV-2 (COVID-19) vaccine, vector non-replicating, recombinant spike protein-Ad26, preservative free, 0.5 mL	|212|	CVX
COVID -19 Vaccine (Unknown/Not Specified) |||		|	|	||724904|	SARS-COV-2 (COVID-19) vaccine, UNSPECIFIED	|213|	CVX

</details>
   
   
## **** Reminders ****

### Submission Metadata and ETL Changes Documentation

Please document submission metadata and any ETL changes for version 4.4 in the [REDCap Project](https://redcap.chop.edu/redcap_v10.3.2/DataEntry/record_status_dashboard.php?pid=38566).

### Sites submitting COVID data with v4.4 submission

For sites submiiting COVID data along with the v4.4 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. Please use the original [COVID Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/COVID-19%20Cohort.md#initial-patient-list-due-april-3rd-2020). We have included it below for reference.

When making a note of the inclusion criterion met please use the following valueset:

<ul>
<li>COVID-19 Diagnosis</li>
<li>COVID-19 Test Positive</li>
<li>COVID-19 Test Negative</li>
<li>COVID-19 Test Result Unknown</li>
<li>COVID-19 Test Serology Positive</li>
<li>COVID-19 Test Serology Negative</li>
<li>COVID-19 Test Serology Result Unknown</li>
<li>COVID-19 Vaccination</li>
<li>HCW-COVID-19 Test Positive</li>
<li>HCW-COVID-19 Test Negative</li>
<li>HCW-COVID-19 Test Result Unknown</li>
<li>HCW-COVID-19 Test Serology Positive</li>
<li>HCW-COVID-19 Test Serology Negative</li>
<li>HCW-COVID-19 Test Serology Result Unknown</li>
<li>HCW-COVID-19 Vaccination</li>
<li>Visit with Diagnosis List Code</li></ul>

Additional Notes:
- For patients meeting multiple criteria, include multiple rows.
- If you are unable to determine a positive or negative result for the COVID-19 test, use the `COVID-19 Test Result Unknown` criterion.

Please see the example below for formatting guidelines:

person_id|inclusion_criterion
---|---
1234|COVID-19 Diagnosis
1234|COVID-19 Test Positive
2345|COVID-19 Test Negative
2345|COVID-19 Vaccination
6789|COVID-19 Test Result Unknown
9020|Visit with Diagnosis List Code
1294|HCW-COVID-19 Test Positive
2325|HCW-COVID-19 Test Negative
2325|HCW-COVID-19 Vaccination
6749|HCW-COVID-19 Test Result Unknown
