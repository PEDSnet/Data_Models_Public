# COVID-19 Cohort ETL Guidance 

**\**DRAFT - VERSION\****

## Background

The COVID-19 pandemic presents a “100 year” challenge to public health, threatening mortality into the hundreds of thousands and severe socioeconomic dislocation.  Although children as a group appear to be less severely affected than older patients, but many important questions remain unanswered.  Little is known about risk factors for severe illness, particularly in young infants, immunocompromised children, and children with chronic pulmonary disease.  Moreover, the role children with mild infection play in transmission, both in the community and in the pediatric workforce, is not well understood.

Recognizing this need, PEDSnet is committing to a rapid response that creates the data substrate for COVID-19 analyses and for pragmatic research, and that builds a pediatric research effort to complement current efforts in basic and adult clinical domains.


## Inclusion Criteria

Both clinical diagnostics and data collection regarding COVID-19 is in flux. In order to capture patients, we will define this cohort with a focus on sensitivity.

Patients should be included they were:
 
 <ul><li>Diagnosied with COVID-19 (determined by institutional mechanisms) ***OR*** </li>
 <li>Tested for SARS-CoV-2 ***OR***</li>
 <li>Seen in the Emergency Department (ED) or inpatient setting since Jan 01, 2020 with acute respiratory illness(excluding exacerbation of known chronic conditions such as asthma)</li></ul>

**Codesets:**
<details><summary>
Diagnosis Codes</summary>
<p>

concept_id|concept_name|concept_code|vocabulary
---|---|---|---
45756093|Emergency use of U07.1 \| Disease caused by severe acute respiratory syndrome coronavirus 2|U07.1|ICD10
45585955|	Coronavirus infection, unspecified site	|B34.2|ICD10
35205800|Coronavirus infection, unspecified|	B34.2|ICD10CM
45590872|	Coronavirus as the cause of diseases classified to other chapters|B97.2|	ICD10
1567458|	Coronavirus as the cause of diseases classified elsewhere|	B97.2|ICD10CM
45537785|	SARS-associated coronavirus as the cause of diseases classified elsewhere|	B97.21|ICD10CM
45600471|Other coronavirus as the cause of diseases classified elsewhere|B97.29|ICD10CM
45567260|	Pneumonia due to SARS-associated coronavirus|	J12.81|	ICD10CM
45756079|	Severe acute respiratory syndrome [SARS]|	U04|	ICD10
45604597|	Severe acute respiratory syndrome [SARS], unspecified	|U04.9	|ICD10
45542411|Contact with and (suspected) exposure to other viral communicable diseases|Z20.828|ICD10CM
45571329|Contact with and (suspected) exposure to other bacterial communicable diseases|Z20.818|ICD10CM
439676	|Coronavirus infection	|186747009|SNOMED
4092694	|Coronavirus as the cause of diseases classified to other chapters	|186758000	|SNOMED
40380828|	Coronavirus as the cause of diseases classified to other chapters	|187587009|SNOMED
4100065|	Disease due to Coronaviridae	|27619001|SNOMED
320651|Severe acute respiratory syndrome	|398447004	|SNOMED
4248811|	Healthcare associated severe acute respiratory syndrome	|408688009|SNOMED
40479642|	Pneumonia due to Severe acute respiratory syndrome coronavirus|	441590008|SNOMED
40479782|	Exposure to severe acute respiratory syndrome coronavirus|	444482005|SNOMED
45763594|	Middle East respiratory syndrome|651000146102|SNOMED
45765578|	Exposure to coronavirus infection	|702547000|SNOMED
37016927|	Pneumonia caused by Human coronavirus|	713084008|SNOMED
37396171|Severe acute respiratory syndrome of upper respiratory tract|	715882005|SNOMED
44810278|	Exposure to coronavirus infection	|878171000000104|SNOMED

</p>
</details>

<details><summary>Procedure/Lab Codes</summary>
<p>


concept_id|concept_name|concept_code|vocabulary
---|---|---|---
40218805|Testing for SARS-CoV-2 in CDC laboratory|U0001|HCPCS
40218804|Testing for SARS-CoV-2 in non-CDC laboratory|U0002|HCPCS
706163|SARS coronavirus 2 RNA [Presence] in Respiratory specimen by NAA with probe detection|94500-6|LOINC
706170|SARS coronavirus 2 RNA [Presence] in Unspecified specimen by NAA with probe detection|94309-2|LOINC
706158|SARS Coronavirus 2 RNA panel - Respiratory specimen by NAA with probe detection|94531-1|LOINC
706169|SARS Coronavirus 2 RNA panel - Unspecified specimen by NAA with probe detection|94306-8|LOINC
706165|SARS coronavirus+SARS-like coronavirus+SARS coronavirus 2 RNA [Presence] in Respiratory specimen by NAA with probe detection|94502-2|LOINC
700360|Infectious agent detection by nucleic acid (DNA or RNA); severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2) (Coronavirus disease [COVID-19]), amplified probe technique|87635|CPT-4

</p>
</details>


<details><summary>Acute Respiratory Illness Codes</summary>
 
 
[Acute Respiratory Distress Syndrome (ARDS)](Codesets/ards_codeset.csv)

[Bronchitis](Codesets/bronchitis_codeset.csv)

[Bronchiolitis](Codesets/bronchiolitis_codeset.csv)

[Pnemonia](Codesets/pneumonia_codeset.csv)

[Respiratory Distress](Codesets/respiratory_distress_codeset.csv)

[Respiratory Failure](Codesets/respiratory_failure_codeset.csv)

[Influenza](Codesets/influenza_codeset.csv)

[Upper Respiratory Infections](Codesets/uri_codeset.csv)

</details>

## Vocabulary Snapshot
Standaridized codes have been *rapidly* developed to support the identification and coding of covid-19 realted diagnosis, outcomes and testing. A full listing can be found in the official OHDSI [COVID-19 Vocabulary Release](https://github.com/OHDSI/Covid-19/wiki/Release).

A **snapsho**t of the vocabulary (an update to the current vocabulary) is available [here](**coming soon**). 

This is version [3.7.2](**coming soon**) of the vocabulary. 

## Data Submission

### Initial Patient List

To begin to understand the population, we ask that each site generate a patient list for patients meeting the aforementioned criteira.

We recognize that these patients may not currently exist in the PEDSnet cohort for your site. In this case, please create a *new stable* `person_id` for these patients so that they may be included in the subsequent full data submission.

When making a note of the inclusion criterion met please use the following valueset:

<ul>
<li>COVID-19 Diagnosis</li>
<li>COVID-19 Test Positive</li>
<li>COVID-19 Test Negative</li>
<li>COVID-19 Test Result Unknown</li>
<li>ED Admission and Respiratory Diagnosis</li>
<li>Inpatient Admission and Respiratory Diagnosis</li></ul>

Additional Notes:
- For patients meeting multiple criteria, include multiple rows.
- For ED->Inpatient visits with a respiratory diagnosis use the `Inpatient Admission and Respiratory Diagnosis` criterion.
- If you are unable to determine a positive or negative result for the COVID-19 test, use the `COVID-19 Test Result Unknown` criterion.

Please see the example below for formatting guidelines:

person_id|inclusion_criterion
---|---
1234|COVID-19 Diagnosis
1234|COVID-19 Test Positive
2345|COVID-19 Test Negative
6789|COVID-19 Test Result Unknown
9020|ED Admission and Respiratory Diagnosis
2424|Inpatient Admission and Respiratory Diagnosis







### Lab Mapping

In an effort to standardize the way the COVID-19 test appear in the network, we have chosen conical mappings for the lab tests. Please include mappings to these in the [PEDSnet Lab Mapping File](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_Labs_Site_Mappings.csv) in the data submission.

Lab name|pedsnet_loinc_code|pedsnet_concept_id
---|---|---
SARS coronavirus 2 RNA [Presence] in Respiratory specimen by NAA with probe detection|94500-6|706163
SARS coronavirus 2 IgG Ab [Presence] in Serum or Plasma by Immunoassay|94507-1|706181
SARS coronavirus 2 IgM Ab [Presence] in Serum or Plasma by Immunoassay|94508-9|706180


### Weekly Submission
Using the data resource, we will maintain up to date **(weekly)** descriptions of the demographics and major clinical characteristics of COVID-19 cohorts, as well as an overall picture of health care utilization, to inform public health and health system responses.

Please utilize the PEDSnet data submission resource **transfer2.chop.edu** to submit the covid-19 cohort for your site. 

Please use the following convention for submission:

[Site_Name]\_Covid-19\_[Submission_date].extension
