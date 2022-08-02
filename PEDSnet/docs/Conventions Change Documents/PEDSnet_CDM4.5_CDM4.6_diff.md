# Differences between PEDSnet CDM 4.5 and CDM 4.6

## **** NEW in PEDSnet CDM v4.6 ****

### New Guidance

#### [1.6 VISIT_OCCURRENCE](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#16-visit_occurrence)

- Operating (aka Sugery) and Anesthesia encounters that occur as apart of an Inpatient stay should be rolled up into one Inpatient encounter.
    - This had been an optinal ETL step that we are now making a requirement.

### New Table
#### [1.21 Specialty](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#121-specialty-1)
- In order to better support certain study efforts, we are adding SPECIALTY table to our Data Model. This table will hold information about each of the specialty assocaited with a given provider or care site, and is intended to accomidate intances where a provider or care site has more than one specialty. 

### Expansion of "Codesets" for COVID-19 Cohort

We are expanding the "COVID-19 Lab LOINC Codesets" & "Acute Respiratory Illness Codesets" for in the COVID Cohort in order to include additional Diagnosies that are needed to support the RECOVER Study. 

See the links below to each of the different Cohort Codeset tables that have been updated:

<details><summary>Updated COVID-19 Lab Test Codesets</summary>

- [COVID-19 Tests](../Codesets/covid_test_codeset.csv)

- [COVID-19 Serology Tests](../Codesets/covid_test_serology_codeset.csv)

</details>

<details><summary>Updated Acute Respiratory Illness Codesets</summary>

- [Acute Respiratory Distress Syndrome (ARDS)](../Codesets/ards_codeset.csv)

- [Bronchitis](../Codesets/bronchitis_codeset.csv)

- [Bronchiolitis](../Codesets/bronchiolitis_codeset.csv)

- [Pnemonia](../Codesets/pneumonia_codeset.csv)

- [Respiratory Distress](../Codesets/respiratory_distress_codeset.csv)

- [Respiratory Failure](../Codesets/respiratory_failure_codeset.csv)

- [Influenza](../Codesets/influenza_codeset.csv)

- [Upper Respiratory Infections](../Codesets/uri_codeset.csv)

- [Fever](../Codesets/fever_codeset.csv)

- [Cough](../Codesets/cough_codeset.csv)

 </details>
 
Additinally, see the link below to the full COVID Cohort Specs: 

> [COVID Cohort Documenation](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#pcornet-inclusion-criteira)

### Addition of RECOVER Cohort Specifications

A seperate README document has been created to codify the Cohort Deffinition for the Patient poulation of interest to the RECOVER study. Follow the link below to view this new documenation.

> [RECOVER Cohort Documenation](https://github.com/PEDSnet/Data_Models/blob/v4.6/PEDSnet/docs/RECOVER%20Cohort.md)

That said, the notable changes between the RECOVER and COVID-19 cohorts are as follows:

1. For RECOVER, the start date for all Non-COVID Diagnosis Inclusion Criteria has been expanded to **January 1st, 2019** (rather than starting at 2020).
2. For RECOVER, instances of ["Kawasaki disease"](../Codesets/kawasaki_codeset.csv), ["Myocarditis", or "Pericarditis"](../Codesets/myocarditis_pericarditis_codeset.csv) diagnoses have been added to the inclusion criteria. 

All other conditions of the [RECOVER Cohort](https://github.com/PEDSnet/Data_Models/blob/v4.6/PEDSnet/docs/RECOVER%20Cohort.md) should match that of the [CDC COVID-19 Cohort](https://github.com/PEDSnet/Data_Models/blob/v4.6/PEDSnet/docs/COVID-19%20Cohort.md#pcornet-inclusion-criteira).

## **** Reminders ****

### Submission Metadata and ETL Changes Documentation

Please document submission metadata and any ETL changes for version 4.6 in the [REDCap Project](https://redcap.chop.edu/redcap_v10.3.2/DataEntry/record_status_dashboard.php?pid=38566).

### Sites submitting RECOVER data with v4.6 submission

For sites submiting RECOVER data along with the v4.6 submission, please provide a CSV of patients meeting the RECOVER inclusion criteria with an inclusion reason. 

Please use the original [**RECOVER** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/v4.6/PEDSnet/docs/RECOVER%20Cohort.md#data-submission). 

### Sites submitting COVID data with v4.6 submission

For sites submiiting COVID data along with the v4.6 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. 

Please use the original [**COVID** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#data-submission). 
