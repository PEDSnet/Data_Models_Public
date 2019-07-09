# PEDSnet Key Data Elements

Last Updated: 2019-06-20

These data elements form part of the **Expectations for Membership** for sites participating in the PEDSnet data network. 

**For at least 15 of these elements, a site must meet the listed criterion for >90% of rows present in the data.**

Variable |	PEDSnet CDM Domain	|Purpose	|Data Element Name	|Criterion
--- | --- |--- |--- |---
Age	|person	|Accurate baseline data for age calculation|	birth_datetime	|Valid date after 01-Jan-1930
5-digit Zip Code|	person|	Presence of a (last known) ZIP code for potential use in geocoding	|zip	|Valid for person.location_id
Clinician Specialty|	visit|	Ability to determine when specialty care is delivered or specialist makes a diagnosis|	care_site_specialty_concept_id or provider_specialty_concept_id |	Informative* for face-to-face visits
Type of ICU	|visit|	For ICU admissions, ability to determine ICU type	|service_concept_id|	Informative*
Hospitalization LOS ***(Pending Data Committee approval)***|	visit|	Presence of duration data for high-acuity admissions|	visit_end_date - visit_start_date |	> 1 for ICU visits
Payer|	payer	|Presence of insurance information for visits; used as a proxy for SES|	plan_class|	Informative* for face-to-face visits
Diagnosis Code|	diagnosis|	Presence of a standard diagnosis code|	condition_concept_id	|Informative*
Diagnosis Code Source	|diagnosis|	Information about source of a diagnosis (e.g. billing, problem list)|	condition_type_concept_id|	Informative* and matches visit type
Diagnosis Code Link to a Visit|diagnosis	|Ability to link a diagnosis to a visit (excepting problem list entries, which may not be visit-based)|	visit_occurrence_id	|Valid visit with type corresponding to condition_type_concept_id for non-problem-list rows
Procedure Code|	procedure|	Presence of a standard procedure code	|procedure_concept_id|	Informative*
Procedure Code Link to a Visit	|procedure|	Ability to link a procedure back to a visit|	visit_occurrence_id	|Valid visit
Medication Ingredient and Route of Administration|	drug|	Presence of a standard drug code that conveys at least the active ingredient(s) and the route of administration|	drug_concept_id	|SCDG or more specific
Medication Dose|	drug	|Presence of drug dose (either single dose or total quantity)|	effective_drug_dose or quantity	|Informative*
Medication Link to a Visit|	drug|	Ability to link a medication back to originating visit (not used for dispensing records)|	visit_occurrence_id	|Valid visit
Laboratory Test Code|	measurement|	Presence of a standard test code|	measurement_concept_id	|Informative*
Link of Laboratory Test to a Visit|	measurement	|Ability to link a result back to a visit|	visit_occurrence_id	|Valid visit
Valid Laboratory Test Results|	measurement|	Presence of an interpretable laboratory result	|value_as_number or value_as_concept_id	|Informative* for laboratory tests
Normal Range for Laboratory Test Results|	measurement|	Ability to assess normal range for quantitative laboratory results|	range_high + range_low + range_high_operator_concept_id + range_low_operator_concept_id	|Complete for 80% of laboratory tests where value_as_number > 0
Name of Isolated Organisms|	measurement|	For a positive culture, ability to identify the oragnism(s) isolated|	organism_concept_id|	Informative*
Immunization|	immunization|	Presence of a standard immunization code|	immunization_concept_id	|Informative*

*Informative = not NULL, not one of the PCORnet "flavors of null"; for concept IDs, non-zero; for dates and laboratory values, not implausible
