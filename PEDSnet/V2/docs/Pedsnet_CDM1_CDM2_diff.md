## Differences between CDM1 and CDM2

## Changes from CDM1
####[1.1 Person](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#11-person-1)
1. Data Type Column included in the table 
2. `pn_time_of_birth` field renamed to `time_of_birth`
3. `time_of_birth` field is now Datetime. (Instructions: Do not include timezone. Please keep all accurate/real dates (No date shifting). If there is no time associated with the date assert midnight.)
4. Fields are marked as necessary for the PCORNET transformation (`person_id`,`year_of_birth`,`month_of_birth`,`time_of_birth`,`race_concept_id`,`ethnicity_concept_id`,`race_source_value`,`ethnicity_source_value`)
5. The logic to link to the respective vocabularies has changed. However, previously mapped concept ids are consistent for gender,race and ethnicity. See the Vocabulary Notes [below] (Pedsnet_CDM1_CDM2_diff.md) for clarification.
 
####[1.2 Death](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#12-death-1)
1. Data Type Column included in the table 
2. Addition of `death_time` Datetime field. See convention document for instructions.
3. Addition of `cause_source_concept_id` field. See convention document for instructions.
4. The logic to link to the cause of death vocabulary has changed. See the Vocabulary Notes [below] (Pedsnet_CDM1_CDM2_diff.md) for clarification.

####[1.3 Location](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#13-location-1)
1. Data Type Column included in the table
2. Fields are marked as necessary for the PCORNET transformation (`location_id`,`zip`)

####[1.4 Caresite](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#14-care_site)
1. Data Type Column included in the table 
2. Fields are marked as necessary for the PCORNET transformation (`care_site_id`,`location_id`)

####[1.5 Provider](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#15-provider-1)
1. Data Type Column included in the table 

####[1.6 Visit Occurrence ](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#16-visit_occurrence)
1. Data Type Column included in the table 

####[1.7 Condition Occurrence](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#17-condition_occurrence)
1. Data Type Column included in the table 

####[1.8 Procedure Occurrence](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#18-procedure_occurrence)
1. Data Type Column included in the table 

####[1.9 Observation](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#19-observation-1)
1. Data Type Column included in the table 

####[1.10 Observation Period](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#110-observation-period-1)
1. Data Type Column included in the table 

***
## DELETED from PEDSNet CDM2

#### [1.5 Organization -- VERSION 1 ONLY] (V1/docs/PEDSnet_CDM_V1_ETL_Conventions.md#15-organization)
- This table has been removed from OMOP V5 (subsequently PEDSnet CDM v2).

***
## NEW in PEDSnet CDM2

#### [Table of Contents](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/V2/docs/Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#table-of-contents)
- We've added the table of contents to make nagivation in the document easier.

####[1.11 Drug Exposure](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#111-drug-exposure-draft)
- This table is new to the data model.
- The drug exposure domain captures any biochemical substance that is introduced in any way to a patient. This can be evidence of prescribed, over the counter, administered (IV, intramuscular, etc), immunizations or dispensed medications. These events could be linked to procedures or encounters where they are administered or associated as a result of the encounter. We will exclude cancelled medications orders and missed medication administrations.
- Please refer to the conventions document for specific instructions on guidance for field population.
 
####[1.12 Measurement](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#112-measurement-draft)
- This table is new to the data model.
- The measurement domain captures measurement orders and measurement results.
- Specifically this table includes:
   - Height/length in cm (use numeric precision as recorded in EHR)
   - Height/length type
   - Weight in kg (use numeric precision as recorded in EHR)
   - Body mass index in kg/m<sup>2</sup> (extracted only if height and weight are not present)
   - Systolic blood pressure in mmHg
   - Diastolic blood pressure in mmHg
   - Vital source
   - Component Level Labs (Network list pending)
- Please refer to the conventions document for specific instructions on guidance for field population.


####[1.13 Fact Relationship](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#113-fact-relationship-1)
- This table is new to the data model.
- The fact relationship domain contains details of the relationships between facts within one domain or across two domains, and the nature of the relationship. Examples of types of possible fact relationships include: BP relationships (linking systolic and diastolic blood pressures or linking previously split ED->Inpatient Visits)
- Please refer to the conventions document for specific instructions on guidance for field population.

####[1.14 Visit Payer](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#114-visit_payer)
- This table is new to the data model.
- The visit payer table documents insurance information as it relates to a visit in visit_occurrence. For this reason the key of this table will be visit_occurrence_id and plan_id.This table is CUSTOM to Pedsnet.
- Please refer to the conventions document for specific instructions on guidance for field population.

 ####[Appendix] (Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#a1-abms-specialty-category-to-omop-v5-specialty-mapping)
- This appendix is new to the data model.
- Please use the values present to map care site and provider specialty.
- This list is derived from the ABMS Specilaty Listing, which can be found [here] (http://www.abms.org/member-boards/specialty-subspecialty-certificates/)


####Vocabulary V5 Notes

