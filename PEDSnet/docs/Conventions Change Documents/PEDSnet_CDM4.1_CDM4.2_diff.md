# Differences between PEDSnet CDM 4.1 and CDM 4.2

## **** NEW in PEDSnet CDM v4.2 ****

### [All Tables](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#table-of-contents)
- Update of all ***fact table*** primary and foreign keys to `Big Integer` from `Integer` to support the generation of unique keys for the growing volume of data.

### [1.3 Location](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#13-location)
- Network Constraint for `County` field updated to `Provide when available` from `No`.

### [1.9 Observation](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#19-observation-1)
- Updates for the following concepts:

Current Concept | Current Concept Name| New Concept|New Concept Name
---|---|---|---
2000000039| Current someday smoker-SNOMED International Code| 37395605| Occasional tobacco smoker
4209006|  Heavy Smoker| 762499 | Heavy tobacco smoker
4044778 | Chain Smoker| 762499 | Heavy tobacco smoker
4209585| Moderate Smoker| 762498|Light tobacco smoker|

### [1.20 Hash Token](https://github.com/PEDSnet/Data_Models/blob/v4.2/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#120-hash_token)
- Addition of `token_encryption_key` column.

### [COVID- 19 Updates](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md)

#### COVID-19 Codesets Updates

The following codesets have been updated and can be used as a guide for identfying patients meeting the various COVID-19 criteria at your site:

Codeset| Updates
--- | ---
[COVID-19 Dx](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Codesets/covid_dx_specific_codeset.csv) | Now includes the Multisystem Inflammatory Code (MIS)
[COVID-19 Tests](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Codesets/covid_test_codeset.csv)| Now includes more tests utilized by sites in the network and newer LOINC concepts.
[COVID-19 Serology Tests](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Codesets/covid_test_serology_codeset.csv)| Now includes more tests utilized by sites in the network and newer LOINC concepts.
[Visit With Diagnosis List Codes](https://github.com/PEDSnet/Data_Models/tree/master/PEDSnet/docs/Codesets) | All codesets have been updated to include ICD and SNOMED equivalents.

#### Inclusion List Format

In order to better describe our COVID cohort, please add the following designations to your COVID Inclusion List when identifying patients and healthcare workers (HCW):

<ul>
<li>COVID-19 Test Serology Positive ***NEW***</li>
<li>COVID-19 Test Serology Negative ***NEW***</li>
<li>COVID-19 Test Serology Result Unknown ***NEW***</li>
<li>HCW-COVID-19 Test Serology Positive ***NEW***</li>
<li>HCW-COVID-19 Test Serology Negative ***NEW***</li>
<li>HCW-COVID-19 Test Serology Result Unknown ***NEW***</li></ul>

## **** Reminders ****

### Submission Metadata and ETL Changes Documentation

Please document submission metadata and any ETL changes for version 4.2 in the REDCap Project.

### Sites submitting COVID data with v4.2 submission

For sites submiiting COVID data along with the v4.2 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. Please use the original [COVID Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#initial-patient-list-due-april-3rd-2020). We have included it below for reference.

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
