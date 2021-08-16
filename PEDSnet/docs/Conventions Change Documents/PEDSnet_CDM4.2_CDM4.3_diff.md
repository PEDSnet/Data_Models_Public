# Differences between PEDSnet CDM 4.2 and CDM 4.3

## **** NEW in PEDSnet CDM v4.3 ****

### [1.12 Measurement](https://github.com/PEDSnet/Data_Models_Public/tree/master/PEDSnet/docs/Conventions%20Docs/v4.3_PEDSnet_CDM_ETL_Conventions.md#112-measurement-1)
- Update of `Note 5` for instructions on how to populate the range_low_operator_concept_id and range_high_operator_concept_id for **Numerical** LAB Values.


|You have in your source system|	range high/ range low	|range high source value / range low source value	|range low/high operator concept id  **\*UPDATED\***|
---|---|---|---
Numerical value Examples: 7,8.2,100|	Numerical Value Examples: 7,8.2,100|	Numerical value Examples: 7,8.2,100	|**4172703** *(Previously 0)*

### [1.18 Device Exposure](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#118-device_exposure)
- Addition of `placement_concept_id` and `placement_source_value`  columns to capture device body site placement location of devices.

### Vocabulary Tables

#### Concept
- Addition of new concepts to store the derived Pediatric Ulcerative Colitis Activity Index (PUCAI) `2000001490` and Pediatric Crohn's Disease Activity Index (PCDAI) ` 2000001491` variables related to the Improve Care Now (ICN) Projects.

#### Drug Strength
- `numerator_value`, `amount_value` an `denominator_value` previously exported incorrectly as exponents (e.g `1e+05`) now exported as numeric values
- `numerator_value` data type changed from `numeric(20,5)` to `numeric (20,0)`

### PEDSnet Vocabulary Distribution

- CHOP has discontinued the use of ShareFile.
- The PEDSnet Vocabulary is now available on [OneDrive](https://chop365-my.sharepoint.com/:u:/g/personal/burrowse_chop_edu/EbuII2aRJE5Pj3mRP3QQl8AB8HyVAhFNrl0O6bRC5-qROA?e=y0onIm). 
- Please use your CHOP AD credentials to log in and access the download.

### [COVID- 19 Updates](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md)

#### COVID-19 Vaccine Mapping

The COVID-19 page has been updated to include mapping helpers for immunization, drug_exposure and procedure_occurrence mapping concepts for COVID-19 vaccinations.

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

Please document submission metadata and any ETL changes for version 4.3 in the [REDCap Project](https://redcap.chop.edu/redcap_v10.3.2/DataEntry/record_status_dashboard.php?pid=38566).

### Sites submitting COVID data with v4.3 submission

For sites submiiting COVID data along with the v4.3 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. Please use the original [COVID Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#initial-patient-list-due-april-3rd-2020). We have included it below for reference.

When making a note of the inclusion criterion met please use the following valueset:

<ul>
<li>COVID-19 Diagnosis</li>
<li>COVID-19 Test Positive</li>
<li>COVID-19 Test Negative</li>
<li>COVID-19 Test Result Unknown</li>
<li>COVID-19 Test Serology Positive</li>
<li>COVID-19 Test Serology Negative</li>
<li>COVID-19 Test Serology Result Unknown</li>
<li>HCW-COVID-19 Test Positive</li>
<li>HCW-COVID-19 Test Negative</li>
<li>HCW-COVID-19 Test Result Unknown</li>
<li>HCW-COVID-19 Test Serology Positive</li>
<li>HCW-COVID-19 Test Serology Negative</li>
<li>HCW-COVID-19 Test Serology Result Unknown</li>
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
6789|COVID-19 Test Result Unknown
9020|Visit with Diagnosis List Code
1294|HCW-COVID-19 Test Positive
2325|HCW-COVID-19 Test Negative
6749|HCW-COVID-19 Test Result Unknown
