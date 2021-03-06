# Differences between PEDSnet CDM 3.9 and CDM 4.0

## Care Site ID Stable Requirement

As of v4.0 of PEDSnet, `care_site_id` is now required to be a stable identifier along with `person_id`, `visit_occurrence_id` and `provider_id`.

## Datavant v3.5 Software Links

It is recommended that the DCC and all PEDSnet sites use v3.5 of the Datavant Software to ensure we are all following the same tokenization process. Please contact the DCC for the download link for all platforms (Windows/Linux/Unix).

Please note, there was a v3.6 software available on the Datavant portal that was released on November 2020. As we align ourselves with the Datavant release process, the DCC will announce when it is necessary to upgrade to a newer version and provide release links when possible.

## Submission Metadata and ETL Changes Documentation

Please document submission metadata and any ETL changes for version 4.0 in the PEDSnet Metadata Project. Please contact the DCC for more information.

## Sites submitting COVID data with v4.0 submission

For sites submiiting COVID data along with the v4.0 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. 

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


## Data Quality Focus for Lab Result Mapping

Study-specific data quality work associated with urine protein lab data quality uncovered problems where the information or code in the source value does not match the associated measurement_concept_id. We have reached out to sites about specific issues but the work highlighted the need for a framework for investigating potential mismappings.

### Illustrative examples:

measurement_source_value|measurement_concept_name|Comment
--|--|--
"Urine calcium”|Protein [Mass/volume] in Urine by Test strip|Mismapped component
"Protein total serum”|Protein [Units/volume] in Urine|Mismapped specimen
"35663-4” LOINC for Protein [Mass/volume] in Urine collected for unspecified duration|Protein [Mass/volume] in Urine by Test strip|Mismapped methodology

We would like sites to investigate potential source value and measurement_concept_id mismappings, starting with the following 13 high priority labs:

### Priority labs for 4.0:

Component| Specimen
--|--
RBC|<li>Urine<li>Blood\/Serum<li>CSF
Protein|<li>Urine<li>Blood\/Serum<li>CSF
Glucose|<li>Urine<li>Blood\/Serum<li>CSF
Creatinine|<li>Urine<li>Blood\/Serum
Oxalate|<li>Urine<li>Blood\/Serum
Citrate|<li>Urine<li>Blood\/Serum
pH|<li>Urine<li>Blood\/Serum
  
  
### Other high priority labs:

Component| Specimen
--|--
WBC|<li>Urine<li>Blood\/Serum<li>CSF
Monocytes	|<li>Urine<li>Blood\/Serum<li>CSF
Neutrophils(Segmented,Absolute Neutrophil Count etc)|<li>Urine<li>Blood\/Serum<li>CSF
Sodium|<li>Urine<li>Blood\/Serum
Calcium	|<li>Urine<li>Blood\/Serum
Potassium|	<li>Urine<li>Blood\/Serum

### Guidance for lab mismapping investigation:

#### Potential sources of error:
- Incorrect LOINC, CPT or site specific code provided by internal lab system
- Incorrect LOINC or CPT code manually asserted in ETL process
- Incorrect mapping from LOINC, CPT or site specific code to measurement_concept_id in site-specific lab mapping file

#### Lab mapping checks:

- Ensure that the mappings to measurement_concept_id and specimen_concept_id are correct
  - Check the component and the specimen
  - Note: Please check specimen information included in the measurement_concept_id as well as the specimen_concept_id field
- Ensure that the **granularity** of the lab is maintained in the mapping to measurement_concept_id
  - For example, information about the following should be maintained, if possible:
    - *time aspect (e.g. "24 hour", "12 hour", "random", "spot", or "collected for unspecified duration")*
    - *property (e.g. "mass", or "concentration")*
    - *other information about methodology (e.g. "by test strip")*
- Ensure that **unit information** corresponding to the lab is appropriately mapped to unit_concept_id

#### Process:

- For each component, perform lab mapping checks (above) for:
  - Any **manual or automated assertions** of LOINC/CPT in ETL process (source_to_concept_map or other ETL mapping tables)
  - The **top 10 most frequent** LOINC/CPT or lab/procedure name to measurement_concept_id mappings (i.e., the most frequent source value to measurement_concept_id mappings by number of measurements)
- For any mismapping issues, please prioritize fixes which generalize across labs where possible
- Document lab mapping ETL work using the "Lab Mapping" instrument of the PEDSnet Metadata REDCap form, which will ask for information about:
  - Which components have been checked
  - All measurement_concept_ids identified for each component and specimen
  - Any ETL fixes (including the source and the resolution)
  - Any remaining mismappings or limitations which have not yet been fixed
  
