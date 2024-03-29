# RECOVER Cohort Guidance

## Background

RECOVER is a Project focused on analyzing the COVID-19 outbreak as well as the long term health impacts of the pandemic.

The RECOVER Cohort is a proper "super-set" of our [CDC COVID-19 Cohort](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md). This means that it will contain all patients specifed in that original cohort, however it will also include an additional set of patients that the [CDC COVID-19 Cohort](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md) us not capturing.

The Documenation that follows is intended to provide PEDSnet sites with an overview of the full sepcifications for this new RECOVER Cohort.

> That said, the RECOVER Team themselves also have a Confulence instance stood up that contains their own documenation for those interested (link to that documenation [**HERE**](https://nyc-cdrn.atlassian.net/wiki/spaces/REC/pages/2987098226/Cohort+Inclusion+Criteria)); though you may need to request access via that link before you can view.

## Inclusion Criteria

Patients are included if they were:
 
<ul>
    <li>Diagnosed with COVID-19 (determined by institutional mechanisms), <b>OR</b> </li>
    <li>Tested for SARS-CoV-2, <b>OR</b> </li>
    <li>Have Received a COVID-19 Vaccine, <b>OR</b> </li>
    <li>Seen at any visit on or after <b>Jan 01, 2019</b> with Diagnoses of:</li>
    <ul>
        <li>Kawasaki disease, <b>OR</b></li>
        <li>Myocarditis/Pericarditis</li>
    </ul>
<b>.. OR ..</b> 
    <li>Seen at any visit on or after <b>Jan 01, 2019</b> with Diagnoses of:</li>
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
   
- [COVID-19 Related](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/covid_dx_etl_helpers_codeset.csv)

Some of the codes included in the above codeset are codes were adapted to capture COVID-19 before the creation of a COVID-19 specific code. Because of this, the DCC has observed that there is a lack of specificity in identifying patients. To better capture patients with a COVID-19 diagnosis,the following categories will be used:

- [COVID-19 Specific (Diagnosis and Exposure)](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/covid_dx_specific_codeset.csv)

- [COVID-19 Provisional](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/covid_dx_provisional_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of any of these COVID-19 diagnosis codes can be assigned the inclusion reason `COVID-19 Diagnosis`.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).
</details>

<details><summary>COVID-19 - Test (Procedure/Lab) Codes</summary>

- [COVID-19 Tests](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/covid_test_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of a COVID-19 Test can be assigned the inclusion reasons `COVID-19 Test Positive`, `COVID-19 Test Negative`, or `COVID-19 Test Result Unknown`.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission).

- [COVID-19 Serology Tests](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/covid_test_serology_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of a COVID-19 Serology Test can be assigned the inclusion reasons `COVID-19 Test Serology Positive`, `COVID-19 Test Serology Negative`, or `COVID-19 Test Serology Result Unknown `.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission)).

</details>

<details><summary>COVID-19 - Vaccinations</summary>

- [COVID-19 VACCINES MAPPING GUIDANCE](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#covid-19-vaccines-mapping-guidance)

> **Note**: Patients included in our cohort due to a vaccination can be assigned the inclusion reason `COVID-19 Vaccination`.
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/RECOVER%20Cohort.md#data-submission).

</details>


<details><summary>Kawasaki Dx - Kawasaki disease Codes</summary>

- [Kawasaki Codes](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/kawasaki_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of these diagnosis codes can be assigned the inclusion reason `Visit with Kawasaki Diagnosis Code`. 
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/RECOVER%20Cohort.md#data-submission).

</details>

<details><summary>Myocarditis/Pericarditis Dx - Myocarditis/Pericarditis Codes</summary>

- [Myocarditis/Pericarditis Codes](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/myocarditis_pericarditis_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of these diagnosis codes can be assigned the inclusion reason `Visit with Myocarditis/Pericarditis Diagnosis Code`. 
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/RECOVER%20Cohort.md#data-submission).

</details>

<details><summary>Other Dx - Acute Respiratory Illness Codes</summary>
 
 
- [Acute Respiratory Distress Syndrome (ARDS)](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/ards_codeset.csv)

- [Bronchitis](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/bronchitis_codeset.csv)

- [Bronchiolitis](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/bronchiolitis_codeset.csv)

- [Pnemonia](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/pneumonia_codeset.csv)

- [Respiratory Distress](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/respiratory_distress_codeset.csv)

- [Respiratory Failure](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/respiratory_failure_codeset.csv)

- [Influenza](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/influenza_codeset.csv)

- [Upper Respiratory Infections](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/uri_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of these diagnosis codes can be assigned the inclusion reason `Visit with Diagnosis List Code`. 
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/RECOVER%20Cohort.md#data-submission).

</details>

<details><summary>Other Dx - Fever Codes</summary>

- [Fever](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/fever_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of these diagnosis codes can be assigned the inclusion reason `Visit with Diagnosis List Code`. 
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/RECOVER%20Cohort.md#data-submission).

</details>

<details><summary>Other Dx - Dyspnea Codes</summary>

- [Dyspnea](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/dyspnea_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of these diagnosis codes can be assigned the inclusion reason `Visit with Diagnosis List Code`. 
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/RECOVER%20Cohort.md#data-submission).

</details>

<details><summary>Other Dx - Cough Codes</summary>

- [Cough](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/cough_codeset.csv)

> **Note**: Patients included in our cohort due to an occurence of these diagnosis codes can be assigned the inclusion reason `Visit with Diagnosis List Code`. 
> 
> More on these "Inclusion Criteria" Categories, linked [here](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/RECOVER%20Cohort.md#data-submission).

</details>
   

### Date Based Inclusion Criteira

Patients are included if they were:
</ul>
<li>Seen at any visit on or after <b>Jan 01, 2019</b></li></ul>

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
<li><b>Visit with Myocarditis/Pericarditis Diagnosis</b></li>
<li><b>Visit with Kawasaki Diagnosis</b></li>
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
<li><b>HCW-Visit with Myocarditis/Pericarditis Diagnosis</b></li>
<li><b>HCW-Visit with Kawasaki Diagnosis</b></li>
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
8843|HCW-Visit with Myocarditis/Pericarditis Diagnosis Code
1927|Visit with Kawasaki Diagnosis Code
1294|HCW-COVID-19 Test Positive
2325|HCW-COVID-19 Test Negative
2325|HCW-COVID-19 Vaccination
6749|HCW-COVID-19 Test Result Unknown

### Monthly Submission

Using the data resource, we will maintain up to date **Monthly** descriptions of the demographics and major clinical characteristics of RECOVER cohorts, as well as an overall picture of health care utilization, to inform public health and health system responses, and to identify the longer outcomes of the COVID-19 pandemic.

Please utilize the PEDSnet data submission resource **transfer2.chop.edu** to submit the RECOVER cohort for your site. 

Please use the following convention for submission:

[Site_Name]\_RECOVER\_[Submission_date].extension

## Additional Guidance

For Additional COVID-19 Related Guidance, please refere to the "Additional Guidance" section of the COVID-19 Cohort Documenation, linked below:

> [COVID-19 Cohort - "Additional Guidance"](https://github.com/PEDSnet/Data_Models/blob/v4.6/PEDSnet/docs/COVID-19%20Cohort.md#additional-guidance)
