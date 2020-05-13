# COVID-19 Cohort ETL Guidance 

## Background

The COVID-19 pandemic presents a “100 year” challenge to public health, threatening mortality into the hundreds of thousands and severe socioeconomic dislocation.  Although children as a group appear to be less severely affected than older patients, but many important questions remain unanswered.  Little is known about risk factors for severe illness, particularly in young infants, immunocompromised children, and children with chronic pulmonary disease.  Moreover, the role children with mild infection play in transmission, both in the community and in the pediatric workforce, is not well understood.

Recognizing this need, PEDSnet is committing to a rapid response that creates the data substrate for COVID-19 analyses and for pragmatic research, and that builds a pediatric research effort to complement current efforts in basic and adult clinical domains.


## Inclusion Criteria

Both clinical diagnostics and data collection regarding COVID-19 is in flux. In order to capture patients, we will define this cohort with a focus on sensitivity.

Sites have the option of using the `PCORNet` or `Date Based` inclusion criteira based on what is most feasible. Please indicate to the DCC the option your site is using.

### PCORnet Inclusion Criteira
Patients are included if they were:
 
 <ul><li>Diagnosed with COVID-19 (determined by institutional mechanisms) ***OR*** </li>
 <li>Tested for SARS-CoV-2 ***OR***</li>
 <li>Seen at any visit on or after Jan 01, 2020 with acute respiratory illness(excluding exacerbation of known chronic conditions such as asthma) *OR* fever *OR* cough *OR* dyspnea</li></ul>

Please use the following codesets to assist with identifying patients in your source data. Please continue to include any code (diagnosis, procedure or lab) you know is in institutional use that meet these categories, as we know that some of the source data mappings may not be so straightforward.

**Codesets:**
<details><summary>Diagnosis Codes</summary>
 
 
 - The codeset below contains both ICD10 and SNOMED codes that may be in use at your institution to identify covid patients:
   
   [COVID-19 Related](Codesets/covid_dx_etl_helpers_codeset.csv)
   
 
- Some of the codes included in the above codeset are codes were adapted to capture COVID-19 before the creation of a COVID-19 specific code. Because of this, the DCC has observed that there is a lack of specificity in identifying patients. To better capture patients with a COVID-19 diagnosis,the following categories will be used:

   [COVID-19 Specific (Diagnosis and Exposure)](Codesets/covid_dx_specific_codeset.csv)

   [COVID-19 Provisional](Codesets/covid_dx_provisional_codeset.csv)
   
   *Note: These codesets are used as a reference for the Table 1 reporting.*

</details>

<details><summary>Procedure/Lab Codes</summary>
<p>


concept_id|concept_name|concept_code|vocabulary
---|---|---|---
40218805|Testing for SARS-CoV-2 in CDC laboratory|U0001|HCPCS
40218804|Testing for SARS-CoV-2 in non-CDC laboratory|U0002|HCPCS
700360|Infectious agent detection by nucleic acid (DNA or RNA); severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2) (Coronavirus disease [COVID-19]), amplified probe technique|87635|CPT-4
706163|SARS coronavirus 2 RNA [Presence] in Respiratory specimen by NAA with probe detection|94500-6|LOINC
706170|SARS coronavirus 2 RNA [Presence] in Unspecified specimen by NAA with probe detection|94309-2|LOINC
706158|SARS Coronavirus 2 RNA panel - Respiratory specimen by NAA with probe detection|94531-1|LOINC
706169|SARS Coronavirus 2 RNA panel - Unspecified specimen by NAA with probe detection|94306-8|LOINC
706165|SARS coronavirus+SARS-like coronavirus+SARS coronavirus 2 RNA [Presence] in Respiratory specimen by NAA with probe detection|94502-2|LOINC
706160|SARS coronavirus 2 RdRp gene [Presence] in Respiratory specimen by NAA with probe detection	|94534-5|	LOINC
706161|SARS coronavirus 2 N gene [Presence] in Respiratory specimen by NAA with probe detection	|94533-7|	LOINC
706159|SARS-related coronavirus+MERS coronavirus RNA [Presence] in Respiratory specimen by NAA with probe detection	|94532-9|	LOINC
706171|SARS-like coronavirus N gene [Presence] in Unspecified specimen by NAA with probe detection	|94310-0|	LOINC
706168|SARS coronavirus 2 ORF1ab region [Cycle Threshold #] in Unspecified specimen by NAA with probe detection	|94511-3	|LOINC
706172|SARS-like coronavirus N gene [Cycle Threshold #] in Unspecified specimen by NAA with probe detection	|94313-4	|LOINC
706173|SARS coronavirus 2 RdRp gene [Presence] in Unspecified specimen by NAA with probe detection|	94314-2	|LOINC
706166|SARS coronavirus 2 E gene [Cycle Threshold #] in Unspecified specimen by NAA with probe detection	|94509-7|	LOINC
706155|SARS coronavirus 2 N gene [Cycle Threshold #] in Unspecified specimen by Nucleic acid amplification using primer-probe set N2|94312-6|	LOINC
706157|SARS coronavirus 2 N gene [Cycle Threshold #] in Unspecified specimen by Nucleic acid amplification using primer-probe set N1|94311-8	|LOINC
706157|SARS coronavirus 2 N gene [Cycle Threshold #] in Unspecified specimen by NAA with probe detection|	94510-5|	LOINC
706154|SARS coronavirus 2 N gene [Presence] in Unspecified specimen by Nucleic acid amplification using primer-probe set N2	|94308-4	|LOINC
706156|SARS coronavirus 2 N gene [Presence] in Unspecified specimen by Nucleic acid amplification using primer-probe set N1	|94307-6	|LOINC
706175|SARS coronavirus 2 N gene [Presence] in Unspecified specimen by NAA with probe detection	|94316-7|	LOINC
706181|SARS coronavirus 2 IgG Ab [Presence] in Serum or Plasma by Rapid immunoassay	|94507-1|	LOINC
706177|SARS coronavirus 2 IgG Ab [Units/volume] in Serum or Plasma by Immunoassay	|94505-5|	LOINC
706180|SARS coronavirus 2 IgM Ab [Presence] in Serum or Plasma by Rapid immunoassay	|94508-9|	LOINC
706178|SARS coronavirus 2 IgM Ab [Units/volume] in Serum or Plasma by Immunoassay|	94506-3|	LOINC
0|SARS coronavirus 2 IgG+IgM Ab [Presence] in Serum or Plasma by Immunoassay	|94547-7	|LOINC
706176|SARS coronavirus 2 IgG and IgM panel - Serum or Plasma Qualitative by Rapid immunoassay	|94503-0|	LOINC
706179|SARS coronavirus 2 IgG and IgM panel - Serum or Plasma by Immunoassay|	94504-8	|LOINC

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

<details><summary>Fever</summary>
<p>

concept_id|concept_name|concept_code|vocabulary
---|---|---|---
35211386|Other specified fever|	R50.8| ICD10CM
35211385|Drug induced fever|	R50.2| ICD10CM
45597190|Febrile nonhemolytic transfusion reaction|	R50.84| ICD10CM
35211387|Fever, unspecified|	R50.9| ICD10CM
45577799|Simple febrile convulsion|	R56.00| ICD10CM
4249735 | Febrile transfusion reaction | 73301000     | SNOMED
437663 | Fever                        | 386661006    | SNOMED
377101 | Simple febrile seizure       | 432354000    | SNOMED
4226022 | Drug-induced hyperpyrexia    | 405543000    | SNOMED

</p>
</details>

<details><summary>Dyspnea</summary>
<p>

concept_id|concept_name|concept_code|vocabulary
---|---|---|---
45534422|Shortness of breath|R06.02|ICD10CM
312437 | Dyspnea      | 267036007    | SNOMED

</p>
</details>

<details><summary>Cough</summary>
<p>

concept_id|concept_name|concept_code|vocabulary
---|---|---|---
35211275|Cough|R05|ICD10CM
254761 | Cough        | 49727002     | SNOMED


</p>
</details>

### Date Based Inclusion Criteira

Patients are included if they were:
</ul>
<li>Seen at any visit on or after Jan 01, 2020</li></ul>

## Vocabulary Snapshot -- Latest update May 11,2020
Standaridized codes have been *rapidly* developed to support the identification and coding of covid-19 realted diagnosis, outcomes and testing. A full listing can be found in the official OHDSI [COVID-19 Vocabulary Release](https://github.com/OHDSI/Covid-19/wiki/Release).

A **snapsho**t of the vocabulary (an update to the current vocabulary) is available [here](https://chop.sharefile.com/d-s2642eb37ee04ea38). 

This is version [3.7.3](https://chop.sharefile.com/d-sbeb43cefe594305b) of the vocabulary. 

## Data Submission

### Initial Patient List (Due April 3rd, 2020)

To begin to understand the population, we ask that each site generate a patient list for patients meeting the aforementioned criteira.

We recognize that these patients may not currently exist in the PEDSnet cohort for your site. In this case, please create a *new stable* `person_id` for these patients so that they may be included in the subsequent full data submission.

When making a note of the inclusion criterion met please use the following valueset:

<ul>
<li>COVID-19 Diagnosis</li>
<li>COVID-19 Test Positive</li>
<li>COVID-19 Test Negative</li>
<li>COVID-19 Test Result Unknown</li>
<li>HCW-COVID-19 Test Positive</li>
<li>HCW-COVID-19 Test Negative</li>
<li>HCW-COVID-19 Test Result Unknown</li>
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

### Weekly Submission (Starting April 10th, 2020)
Using the data resource, we will maintain up to date **(weekly)** descriptions of the demographics and major clinical characteristics of COVID-19 cohorts, as well as an overall picture of health care utilization, to inform public health and health system responses.

Please utilize the PEDSnet data submission resource **transfer2.chop.edu** to submit the covid-19 cohort for your site. 

Please use the following convention for submission:

[Site_Name]\_Covid-19\_[Submission_date].extension

### Healthcare Workers

To capture health care workers (HCW), create a record in the observation table using the following concept_ids:

observation_concept_id: `756083: Suspected exposure to severe acute respiratory syndrome coronavirus 2 `
value_as_concept_id:`756046: Person Employed as a Healthcare Worker`

Please see the example below for formatting guidelines (with required fields):

observation table field|value
---|---
person_id| `1234`
observation_concept_id| `756083`
osbervation_date| `Date of suspected exposure (if known) or best estimate`
observation_type_concept_id| `38000280`
value_as_concept_id|`756046`

### COVID-19 Patients identified outside of EHR

Patients may be identified as having COVID-19 using outside sources (e.g. a site registry, outside lab testing). Because of this diagnosis or testing data may not be available during the ETL.

To identify these patients, create a record in the observation table using the following concept_ids:

observation_concept_id: `756083: Suspected exposure to severe acute respiratory syndrome coronavirus 2 `
value_as_concept_id:`44802454:	Information external to care setting`

observation table field|value
---|---
person_id| `1234`
observation_concept_id| `756083`
osbervation_date| `Date of suspected exposure (if known) or best estimate`
observation_type_concept_id| `38000280`
value_as_concept_id|`44802454`

### Lab Mapping

In an effort to standardize the way the COVID-19 test appear in the network, we have chosen conical mappings for the lab tests. Please include mappings to these in the [PEDSnet Lab Mapping File](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_Labs_Site_Mappings.csv) in the data submission.

Lab name|pedsnet_loinc_code|pedsnet_concept_id
---|---|---
SARS coronavirus 2 RNA [Presence] in Respiratory specimen by NAA with probe detection|94500-6|706163
SARS coronavirus 2 IgG Ab [Presence] in Serum or Plasma by Immunoassay|94507-1|706181
SARS coronavirus 2 IgM Ab [Presence] in Serum or Plasma by Immunoassay|94508-9|706180

## NEW Data Elements

### FiO2
To record FiO2 vitals for the patient, please use the following conventions to insert a record into the **measurement** table:

measurement_concept_id|concept_code|concept_name|
---|---|---
4353936|	250774007|	Inspired oxygen concentration

### Peripheral oxygen saturation (SpO2)/fraction of inspired oxygen (FiO2) 

To record SpO2/FiO2 vitals for the patient, please use the following conventions to insert a record into the **measurement** table:

measurement_concept_id|concept_code|concept_name|
---|---|---
2000001422|SpO2/FiO2|	Peripheral oxygen saturation/fraction of inspired oxygen

### Chief Complaint

The cheif complaint is often a free text or non-structured field in source systems without any standard terminology. To record this kind of chief complaint for the patient, please use the following **observation_concept_id** to insert a record into the **observation** table:

observaton_concept_id|concept_name
---|---
42894222| EHR Chief Complaint

Please make an effort to redact any potential PHI.

We recognize that chief complaint as defined above may not be available. If reporting admission diagnosis, please use on the following **condition_type_concept_id** (depending where this information is coming from in the source system) to insert a record into the **condition_occurrence** table:

condition_type_concept_id|concept_name
---|---
 2000001423 | Admission Diagnosis - Order
 2000001424 | Admission Diagnosis - Billing
 2000001425 | Admission Diagnosis - Claim

### Vaping Status

To record the vaping smoking status for the patient, please use the following conventions to insert a record into the **observation** table:

Concept Name	|Observation concept ID|	Value as concept ID	|Concept description|	Vocab ID
---|---|---|---|---
Electronic cigarette user|	36716478|42536422| Electronic cigarette liquid containing nicotine| SNOMED
Electronic cigarette user|	36716478|42536421| Electronic cigarette liquid without nicotine| SNOMED
Electronic cigarette user|	36716478|42536420| Electronic cigarette liquid (if nicotine type is not known)|SNOMED

### Mechanical Ventilation
To record the mechanical ventilation status for the patient, please use the following conventions to insert a record into the **device_exposure** table:

device_concept_id|concept_code|concept_name|ventilation type
---|---|---|---
4044008|	129121000|	Tracheostomy tube|invasive
4097216|	26412008|	Endotracheal tube|invasive
4138614|	425826004	|BiPAP oxygen nasal cannula| non-invasive
45761494|	467645007|	CPAP nasal oxygen cannula| non-invasive
4224038|336623009|Oxygen nasal cannula| non-invasive
4139525|426854004|High flow oxygen nasal cannula| non-invasive
45768222|	706226000	|Continuous positive airway pressure/Bilevel positive airway pressure mask| non-invasive
4222966|	336602003|	Oxygen mask|non-invasive
40493026|	449071006|	Mechanical ventilator (if unable to distinguish the type)| N/A

