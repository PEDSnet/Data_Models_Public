# COVID-19 Cohort ETL Guidance 

*Last Updated: 04-21-2022*

## Background

The COVID-19 pandemic presents a “100 year” challenge to public health, threatening mortality into the hundreds of thousands and severe socioeconomic dislocation.  Although children as a group appear to be less severely affected than older patients, but many important questions remain unanswered.  Little is known about risk factors for severe illness, particularly in young infants, immunocompromised children, and children with chronic pulmonary disease.  Moreover, the role children with mild infection play in transmission, both in the community and in the pediatric workforce, is not well understood.

Recognizing this need, PEDSnet is committing to a rapid response that creates the data substrate for COVID-19 analyses and for pragmatic research, and that builds a pediatric research effort to complement current efforts in basic and adult clinical domains.


## Inclusion Criteria

Both clinical diagnostics and data collection regarding COVID-19 is in flux. In order to capture patients, we will define this cohort with a focus on sensitivity.

Sites have the option of using the `PCORNet` or `Date Based` inclusion criteira based on what is most feasible. Please indicate to the DCC the option your site is using.

### PCORnet Inclusion Criteira
Patients are included if they were:
 
<ul>
    <li>Diagnosed with COVID-19 (determined by institutional mechanisms), <b>OR</b> </li>
    <li>Tested for SARS-CoV-2, <b>OR</b> </li>
    <li>Have Received a COVID-19 Vaccine, <b>OR</b> </li>
    <li>Seen at any visit on or after <b>Jan 01, 2020</b> with Diagnoses of:</li>
    <ul>
        <li>Acute Respiratory Illness (excluding exacerbation of known chronic conditions such as asthma), <b>OR</b></li>
        <li>Fever, <b>OR</b></li>
        <li>Dyspnea, <b>OR</b></li>
        <li>Cough</li>
    </ul>
</ul>

Please use the following codesets to assist with identifying patients in your source data. Please continue to include any code (diagnosis, procedure or lab) you know is in institutional use that meet these categories, as we know that some of the source data mappings may not be so straightforward.

**Codesets:**

<details><summary>COVID-19 - Diagnosis Codes</summary>
 
The codeset below contains both ICD10 and SNOMED codes that may be in use at your institution to identify covid patients:
   
- [COVID-19 Related](Codesets/covid_dx_etl_helpers_codeset.csv)

Some of the codes included in the above codeset are codes were adapted to capture COVID-19 before the creation of a COVID-19 specific code. Because of this, the DCC has observed that there is a lack of specificity in identifying patients. To better capture patients with a COVID-19 diagnosis,the following categories will be used:

- [COVID-19 Specific (Diagnosis and Exposure)](Codesets/covid_dx_specific_codeset.csv)

- [COVID-19 Provisional](Codesets/covid_dx_provisional_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of any of these COVID-19 diagnosis codes can be assigned the inclusion reason `COVID-19 Diagnosis`.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).

</details>

<details><summary>COVID-19 - Test (Procedure/Lab) Codes</summary>

- [COVID-19 Tests](Codesets/covid_test_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of a COVID-19 Test can be assigned the inclusion reasons `COVID-19 Test Positive`, `COVID-19 Test Negative`, or `COVID-19 Test Result Unknown`.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).

- [COVID-19 Serology Tests](Codesets/covid_test_serology_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of a COVID-19 Serology Test can be assigned the inclusion reasons `COVID-19 Test Serology Positive`, `COVID-19 Test Serology Negative`, or `COVID-19 Test Serology Result Unknown `.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).

</details>

<details><summary>COVID-19 - Vaccinations</summary>

- [COVID-19 VACCINES MAPPING GUIDANCE](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#covid-19-vaccines-mapping-guidance)

> **Note**: Patients included in our cohort due to a vaccination can be assigned the inclusion reason `COVID-19 Vaccination`.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).

</details> 
 
<details><summary>Other Dx - Acute Respiratory Illness Codes</summary>

- [Acute Respiratory Distress Syndrome (ARDS)](Codesets/ards_codeset.csv)

- [Bronchitis](Codesets/bronchitis_codeset.csv)

- [Bronchiolitis](Codesets/bronchiolitis_codeset.csv)

- [Pnemonia](Codesets/pneumonia_codeset.csv)

- [Respiratory Distress](Codesets/respiratory_distress_codeset.csv)

- [Respiratory Failure](Codesets/respiratory_failure_codeset.csv)

- [Influenza](Codesets/influenza_codeset.csv)

- [Upper Respiratory Infections](Codesets/uri_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of these diagnosis codes can be assigned the inclusion reason `Visit with Diagnosis List Code`.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).

</details>

<details><summary>Other Dx - Fever Codes</summary>

- [Fever](Codesets/fever_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of these diagnosis codes can be assigned the inclusion reason `Visit with Diagnosis List Code`.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).

</details>

<details><summary>Other Dx - Dyspnea Codes</summary>

- [Dyspnea](Codesets/dyspnea_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of these diagnosis codes can be assigned the inclusion reason `Visit with Diagnosis List Code`.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).

</details>

<details><summary>Other Dx - Cough Codes</summary>

- [Cough](Codesets/cough_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of these diagnosis codes can be assigned the inclusion reason `Visit with Diagnosis List Code`. 
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).

</details>
   

### Date Based Inclusion Criteira

Patients are included if they were:
</ul>
<li>Seen at any visit on or after <b>Jan 01, 2020</b></li></ul>

## Data Submission

To characterize the population, we ask that each site generate a patient list for patients meeting the aforementioned criteira.

We recognize that these patients may not currently exist in the PEDSnet cohort for your site. In this case, please create a *new stable* `person_id` for these patients so that they may be included in the subsequent full data submission.

When making a note of the inclusion criterion met please use the following valueset:

<ul>
For <b>Patients</b>, Use these Value sets:
<ul> 
<li>COVID-19 Diagnosis</li>
<li>COVID-19 Test Positive</li>
<li>COVID-19 Test Negative</li>
<li>COVID-19 Test Result Unknown</li>
<li>COVID-19 Test Serology Positive</li>
<li>COVID-19 Test Serology Negative</li>
<li>COVID-19 Test Serology Result Unknown</li>
<li>COVID-19 Vaccination</li>
<li>COVID-19 Vaccination Unreconciled</li>
<li>Visit with Diagnosis List Code</li>
</ul><br>
For <b>Health Care Workers</b>, Use these Value sets:
<ul>
<li>HCW-COVID-19 Test Positive</li>
<li>HCW-COVID-19 Test Negative</li>
<li>HCW-COVID-19 Test Result Unknown</li>
<li>HCW-COVID-19 Test Serology Positive</li>
<li>HCW-COVID-19 Test Serology Negative</li>
<li>HCW-COVID-19 Test Serology Result Unknown</li>
<li>HCW-COVID-19 Vaccination</li>
<li>HCW-COVID-19 Vaccination Unreconciled</li>
<li>HCW-Visit with Diagnosis List Code</li>
</ul>
</ul>

Additional Notes:

- For patients meeting multiple criteria, include multiple rows.
- If you are unable to determine a positive or negative result for the COVID-19 test, use the `COVID-19 Test Result Unknown` criterion.

Please see the example below for formatting guidelines:

`person_id`|`inclusion_criterion`
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

### Monthly Submission
Using the data resource, we will maintain up to date **Monthly** descriptions of the demographics and major clinical characteristics of COVID-19 cohorts, as well as an overall picture of health care utilization, to inform public health and health system responses.

Please utilize the PEDSnet data submission resource **transfer2.chop.edu** to submit the covid-19 cohort for your site. 

Please use the following convention for submission:

[Site_Name]\_Covid-19\_[Submission_date].extension

## Additional Guidance

### Healthcare Workers

To capture health care workers (HCW), create a record in the observation table using the following concept_ids:

observation\_concept\_id: `756083: Suspected exposure to severe acute respiratory syndrome coronavirus 2 `

value\_as\_concept\_id:`756046: Person Employed as a Healthcare Worker`

Please see the example below for formatting guidelines (with required fields):

`observation table field`|`value`
---|---
`person_id`| `1234`
`observation_concept_id`| `756083`
`osbervation_date`| `Date of suspected exposure (if known) or best estimate`
`observation_type_concept_id`| `38000280`
`value_as_concept_id`|`756046`

### COVID-19 Patients identified outside of EHR

Patients may be identified as having COVID-19 using outside sources (e.g. a site registry, outside lab testing). Because of this diagnosis or testing data may not be available during the ETL.

To identify these patients, create a record in the observation table using the following concept_ids:

observation\_concept\_id: `756083: Suspected exposure to severe acute respiratory syndrome coronavirus 2 `

value\_as\_concept\_id:`44802454:	Information external to care setting`

`observation table field`|`value`
---|---
`person_id`| `1234`
`observation_concept_id`| `756083`
`osbervation_date`| `Date of suspected exposure (if known) or best estimate`
`observation_type_concept_id`| `38000280`
`value_as_concept_id`|`44802454`

### COVID-19 Lab Mapping Guidance

In an effort to standardize the way the COVID-19 test appear in the network, we have chosen to use the following conical mappings for the lab tests. Please include mappings to these in the [PEDSnet Lab Mapping File](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_Labs_Site_Mappings.csv) in the data submission.

`Lab name`|`pedsnet_loinc_code`|`pedsnet_concept_id`
---|---|---
SARS coronavirus 2 RNA [Presence] in Respiratory specimen by NAA with probe detection|94500-6|706163
SARS coronavirus 2 IgG Ab [Presence] in Serum or Plasma by Immunoassay|94507-1|706181
SARS coronavirus 2 IgM Ab [Presence] in Serum or Plasma by Immunoassay|94508-9|706180
SARS coronavirus 2 IgA Ab [Presence] in Serum or Plasma by Immunoassay|94562-6|723473

### COVID-19 Serology Test Mapping Guidance

For the RECOVER/PASC studies there is a need to distinguish the type of protein assessed by COVID-19 Serology tests. LOINC has developed a pre-release that includes codes that would help to standardize the way these tests are represented. However, these concepts are not yet in the OMOP vocabulary. The PEDSnet team has developed temporary mappings to be able to identify the specific proteins assessed by the serology test. Please incorporate the following mappings in your ETL:

`concept_id`|`concept_name`|`LOINC short name`|`concept_code`|`vocabulary_id`
---|---|---|---|---
2000001501|SARS-CoV-2 (COVID-19) N protein IgG Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 nucleocapsid protein Ab.IgG|99596-9|LOINC
2000001502|SARS-CoV-2 (COVID-19) S protein IgG Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 spike protein Ab.IgG|99597-7|LOINC
2000001512|SARS-CoV-2 (COVID-19) N protein IgM Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 nucleocapsid protein Ab.IgM|PEDSnet Generated|LOINC
2000001513|SARS-CoV-2 (COVID-19) S protein IgM Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 spike protein Ab.IgM|PEDSnet Generated|LOINC
2000001514|SARS-CoV-2 (COVID-19) N protein IgA Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 nucleocapsid protein Ab.IgA|PEDSnet Generated|LOINC
2000001515|SARS-CoV-2 (COVID-19) S protein IgA Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 spike protein Ab.IgA|PEDSnet Generated|LOINC

> **NOTE**: If Serology test units (*i.e. IgG/IgM/IgA*) are not specified in your source systems lab info, you can apply the mappings for the **IgG** version of these tests (*as those are the most commonly used*).

### COVID-19 Vaccines Mapping Guidance

The following guidance can be used to assist with mapping procedures, medications and immunization records in the CDM for COVID-19 Vaccines. As a reference, this gudiance has been adapted from the [CDC Guidance](https://www.cdc.gov/vaccines/programs/iis/COVID-19-related-codes.html).

`Vaccine`|	`Procedure_concept_id`|	`Procedure_concept_code`|	`Procedure Vocabulary`|	`Drug_concept_id`|	`Drug Concept Name`|	`Drug Vocabulary`|	`immunization_concept_Id` |`Immunization Concept Name`	|`immunization_concept_code`	|Immunization Vocabulary
---|---|---|---|---|---|---|---|---|---|---|
Pfizer-Biontech|	766238|	91300|	CPT4|	37003436	|SARS-CoV-2 (COVID-19) vaccine, mRNA-BNT162b2 0.1 MG/ML Injectable Suspension|	RxNorm	|724907	|SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 30 mcg/0.3mL dose|	208|	CVX
Pfizer-Biontech|	759736|	91305|	CPT4|	37003436	|Tris-sucrose formula, 30 mcg/0.3 mL for ages 12+|	RxNorm	|702677	|SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 30 mcg/0.3mL dose, tris-sucrose formulation|	217|	CVX
Pfizer-Biontech|	759738|	91307|	CPT4|	37003436	|Tris-sucrose formula, 10 mcg/0.2 mL for ages 5 yrs to < 12 yrs|	RxNorm	|702678	|SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 10 mcg/0.2mL dose, tris-sucrose formulation|	218|	CVX  
Moderna |	766239|	91301|	CPT4	|37003518|	SARS-CoV-2 (COVID-19) vaccine, mRNA-1273 0.2 MG/ML Injectable Suspension|	RxNorm	|724906|	SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 100 mcg/0.5mL dose	|207|	CVX
AstraZeneca |	766240|	91302|	CPT4|	1230962|	AZD1222 Astrazeneca COVID-19 vaccine, DNA, spike protein, chimpanzee adenovirus Oxford 1 (ChAdOx1) vector, preservative free, 5x1010 viral particles/0.5mL dosage, for intramuscular use|	NDC	|724905	|SARS-COV-2 (COVID-19) vaccine, vector non-replicating, recombinant spike protein-ChAdOx1, preservative free, 0.5 mL|	210|	CVX
Janssen|766241|	91303|	CPT4	|739906|	SARS-COV-2 (COVID-19) vaccine, vector - Ad26 100000000000 UNT/ML Injectable Suspension|	RxNorm|	702866|	SARS-COV-2 (COVID-19) vaccine, vector non-replicating, recombinant spike protein-Ad26, preservative free, 0.5 mL	|212|	CVX
Novavax|759735|91304|CPT4		|36119721	|COVID-19 vaccine, recombinant, full-length nanoparticle spike (S) protein, adjuvanted with Matrix-M Injectable Suspension	|RxNorm Extension|0|	SARS-COV-2 (COVID-19) vaccine, Subunit, recombinant spike protein-nanoparticle+Matrix-M1 Adjuvant, preservative free, 0.5mL per dose|211|	CVX
COVID -19 Vaccine (Unknown/Not Specified) |||		|	|	||724904|	SARS-COV-2 (COVID-19) vaccine, UNSPECIFIED	|213|	CVX

## Guidance on Other Study Related Data Points

### FiO2

To record FiO2 vitals for the patient, please use the following conventions to insert a record into the measurement table:

> See **Note 1** in the [**MEASUREMENT**](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#112-measurement-1) section of our ETL Conventions for Mapping Guidance on this `FiO2` information.

### Peripheral oxygen saturation (SpO2)/fraction of inspired oxygen (FiO2)

To record SpO2/FiO2 vitals for the patient, please use the following conventions to insert a record into the measurement table:

> See **Note 1** in the [**MEASUREMENT**](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#112-measurement-1) section of our ETL Conventions for Mapping Guidance on this `SpO2/FiO2` information.

### Chief Complaint

The cheif complaint is often a free text or non-structured field in source systems without any standard terminology. To record this kind of chief complaint for the patient, please use the following observation_concept_id to insert a record into the observation table:

> See **Note 8** in the [**OBSERVATION**](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#19-observation-1) section of our ETL Conventions for Mapping Guidance on this information.

We recognize that chief complaint as defined above may not be available.

### Vaping Status

To record the vaping smoking status for the patient, please use the following conventions to insert a record into the observation table:

> See **Note 9** in the [**OBSERVATION**](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#19-observation-1) section of our ETL Conventions for Mapping Guidance on this information.


### Mechanical Ventilation

To record the mechanical ventilation status for the patient, please use the following conventions to insert a record into the device_exposure table:

> See **Note 1** at the top of the [**DEVICE_EXPOSURE**](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#118-device_exposure) section of our ETL Conventions for Mapping Guidance on this information.
