# PEDSnet Key Data Elements

Last Updated: 2019-10-15

These data elements form part of the **Expectations for Membership** for sites participating in the PEDSnet data network. 

**For at least 15 of these elements, a site must meet the listed criterion for >90% of rows present in the data.**

Domain| Purpose| Data Element Name |Criterion |Status
--- | --- |--- |--- |---
person |Accurate baseline data for age calculation |birth_datetime|<ul><li>Valid date after 01-Jan-1930</li></ul> |<ul><li>Implemented in v34</li><li>Will implement in v35</li></ul>
visit | Ability to determine when specialty care is delivered or specialist makes a diagnosis |care_site_specialty_concept_id or provider_specialty_concept_id|<ul><li> Informative* for face-toface visits (visit_concept_id can be either 9202 or 42898160) </li><li>The specialty `pediatric medicine` is not informative</li></ul>|<ul><li>Implemented in v34</li><li>Will implement in v35</li></ul>
diagnosis | Presence of a standard diagnosis code|condition_concept_id|Informative*| Will implement in v35
diagnosis| Information about source of a diagnosis (e.g. billing,problem list)|condition_type_concept_id |<ul><li>Informative* and matches visit type</li><li>Problem list entries are excluded from match to visit type</li></ul>|<ul><li>Implemented in v34</li><li>Will implement in v35</li></ul>
procedure| Presence of a standard procedure code|procedure_concept_id|<ul><li>Informative*</li><li>May restrict to face-to-face visits (visit_concept_id can be either 9202 or 42898160)</li></ul>|<ul><li>Will implement in v35</li></ul>
procedure| Ability to link a procedure back to a visit visit_occurrence_id |<ul><li>Valid visit</li></ul>| <ul><li> Will implement in v35 </li></ul>
drug | Presence of a standard drug code that conveys at least the active ingredient(s) and the route of administration| drug_concept_id|<ul><li>SCDG or more specific</li><li>Denominator will include drugs where drug_concept_id <> 0</li></ul>|<ul><li>Implemented in v34</li><li>Will implement in v35</li><ul>
drug | Presence of drug dose (either single dose or total quantity) |effective_drug_dose (and unit) or quantity |<ul><li>Informative*</li><li> May initially restrict to oral drugs, or exclude drugs where quantity is not easily quantifiable (e.g., 2-4 puffs a day). Custom formulations will also be excluded. This list will be developed by the DCC when reviewing initial output and discussing with Data Committee.</li>|<ul><li>Will implement in v35</li></ul>
drug |Ability to link a medication back to originating visit| visit_occurrence_id| <ul><li>Valid visit</li><li>Excludes dispensing records</li><li>Will implement in v35</li>
measurement | Presence of a standard test code |measurement_concept_id |<ul><li>Informative*</li><li>All vitals and anthropometric measurements as specified by the ETL conventions are required; other vitals and anthropometrics are flagged as outside acceptable value set</li><li> All sites are required to standardize LOINC codes representing labs specified in the PEDSnet ETL conventions. Other values are flagged as outside acceptable value set</li><li> Remaining labs must be mapped to a standard concept</li><ul>|<ul><li>Will implement in v35</li></ul>
measurement| Ability to link a result back to a visit|visit_occurrence_id|<ul><li>Valid visit</li></ul>|<ul><li> Implemented in v34</li><li>Will implement in v35</li></ul>
measurement| Presence of an interpretable laboratory result|value_as_number or value_as_concept_id|<ul><li> Informative* for laboratory tests</li><li> Priority given to labs specified in the PEDSnet ETL conventions</li></ul>|<ul><li>Will implement in v35</li></ul>
measurement| Ability to assess normal range for quantitative laboratory results| range_high + range_low + range_high_operator_ concept_id + range_low_operator_concept_id | <ul><li>Complete for 80% of laboratory tests where value_as_number > 0</li><li>Priority given to labs specified in the PEDSnet ETL conventions and most common labs to meet PCORnet requirement</li></ul>|<ul><li>Will implement in v35</li></ul>
measurement| Ability to identify specimen on which testing was performed|specimen_concept_id|<ul><li>Informative*</li><li> May initially restrict to labs specified in the PEDSnet ETL conventions and most common labs to meet PCORnet requirement</li></ul>|
payer| Presence of insurance information for visits; used as a proxy for SES |plan_class|<ul><li> Informative* for face-to-face
visits</li></ul>
measurement| For a positive culture, ability to identify the oragnism(s) isolated |organism_concept_id ||<ul><li>Informative*</li></ul>
visit| For ICU admissions, ability to determine ICU type|service_concept_id|<ul><li>Informative*</li></ul>
immunization |Presence of a standard immunization code |immunization_concept_id| <ul><li>Informative*</li><li>May initially restrict to subset of immunizations</li></ul>|<ul><li>Will implement in v35</li></ul>
person | Presence of a (last known) ZIP code for potential use in geocoding|zip|<ul><li>Valid for person.location_id</li><li>zip must not be null and must have correct structure</li></ul>|<ul><li>Implemented in v34</li><li> Will implement in v35</li></ul>
diagnosis| Ability to link a diagnosis to a visit (excepting problem list entries, which may not be visit-based)| visit_occurrence_id |<ul><li>Valid visit with type corresponding to condition_type_concept_id for non-problem-list rows</li></ul>| <ul><li>Will implement in v35</li></ul>

*Informative = not NULL, not one of the PCORnet "flavors of null"; for concept IDs, non-zero; for dates and laboratory values, not implausible
