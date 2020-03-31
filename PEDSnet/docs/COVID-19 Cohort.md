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
 <li>Seen in the Emergency Department (ED) or inpatient setting since Jan 01, 2020 with acute respiratory illness or pnemonia (excluding exacerbation of known chronic conditions such as asthma)</li></ul>



## Vocabulary Snapshot

A **snapsho**t of the vocabulary (an update to the current vocabulary) is available [here](**coming soon**). 

This is version [3.7.2](**coming soon**) of the vocabulary. 

Standaridized codes have been *rapidly* developed to support the identification and coding of covid-19 realted diagnosis, outcomes and testing. Please see below highlighted codes that may be *useful* in identifying the covid-19 cohort.

#### Diagnosis Codes

concept_id|concept_name|concept_code|vocabulary
---|---|---|---
45756093|Emergency use of U07.1 \| Disease caused by severe acute respiratory syndrome coronavirus 2|U07.1|ICD10
45600471|Other coronavirus as the cause of diseases classified elsewhere|B97.29|ICD10CM
45542411|Contact with and (suspected) exposure to other viral communicable diseases|Z20.828|ICD10CM
37311061|Disease caused by severe acute respiratory syndrome coronavirus 2|840539006|SNOMED


#### Procedure/Lab Codes

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

A full listing can be found in the official OHDSI [COVID-19 Vocabulary Release](https://github.com/OHDSI/Covid-19/wiki/Release).

## Data Submission

Using the data resource, we will maintain up to date **(weekly)** descriptions of the demographics and major clinical characteristics of COVID-19 cohorts, as well as an overall picture of health care utilization, to inform public health and health system responses.

Please utilize the PEDSnet data submission resource **transfer2.chop.edu** to submit the covid-19 cohort for your site. 

Please use the following convention for submission:

[Site_Name]\_Covid-19\_[Submission_date].extension
