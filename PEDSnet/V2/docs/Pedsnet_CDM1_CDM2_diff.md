## Differences between PEDSnet CDM1 and CDM2

## CHANGES from CDM1
####[1.1 Person](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#11-person-1)
1. Data Type Column included in the table 
2. `pn_time_of_birth` field renamed to `time_of_birth`
3. `time_of_birth` field is now Datetime. See convention document for instructions.
4. Fields are marked as necessary for the PCORNET transformation (`person_id`,`year_of_birth`,`month_of_birth`,`time_of_birth`,`race_concept_id`,`ethnicity_concept_id`,`race_source_value`,`ethnicity_source_value`)
5. The logic to link to the respective vocabularies has changed. However, previously mapped concept ids are consistent for gender,race and ethnicity. See the Vocabulary Notes [below] (Pedsnet_CDM1_CDM2_diff.md#vocabulary-v5-notes) for clarification.
 
####[1.2 Death](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#12-death-1)
1. Data Type Column included in the table 
2. Addition of `death_time` Datetime field. See convention document for instructions.
3. Addition of `cause_source_concept_id` field. See convention document for instructions.
4. The logic to link to the cause of death vocabulary has changed. See the Vocabulary Notes [below] (Pedsnet_CDM1_CDM2_diff.md#vocabulary-v5-notes) for clarification.

####[1.3 Location](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#13-location-1)
1. Data Type Column included in the table
2. Fields are marked as necessary for the PCORNET transformation (`location_id`,`zip`)

####[1.4 Caresite](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#14-care_site)
1. Data Type Column included in the table 
2. Fields are marked as necessary for the PCORNET transformation (`care_site_id`,`location_id`)
3. Addition of `specialty_concept_id` field. See convention document for instructions.
4. Addition of `care_site_name` field. See convention document for instructions.
5. Removal of `organization_id` column.

####[1.5 Provider](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#15-provider-1)
1. Data Type Column included in the table 
2. Updated instructions on how to map specialty values for the `specialty_concept_id`.
3. Addition of `provider_name` field. See convention document for instructions.
4. Addition of `gender_concept_id` and `gender_source_Value` fields. See convention document for instructions.
5. Additon of `specialty_source_concept_id` field. See convention document for instructions.

####[1.6 Visit Occurrence ](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#16-visit_occurrence)
1. Data Type Column included in the table 
2. Addition of `visit_start_time` and `visit_end_time` columns to visit_occurrence.See convention document for instructions. These fields are custom to PEDSnet.
3. Fields are marked as necessary for the PCORNET transformation (`visit_occurrence_id`,`visit_start_date`,`visit_end_date`,`care_site_id`,`provider_id`,`place_of_service_concept_id`)
4. Removal of `place_of_service_concept_id`. `Visit_concept_id` is used in its place
5. Addition of `visit_soruce_concept_id` and `visit_source_value` fields.
6. Use of FACT_RELATIONSHIP table to link ED->Inpatient Vists that have been split. See convention document for instructions.

####[1.7 Condition Occurrence](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#17-condition_occurrence)
1. Data Type Column included in the table 
2. Addition of `condition_start_time` and `condition_end_time` columns to condition_occurrence.See convention document for instructions. These fields are custom to PEDSnet.
3. `associated_provider_id` field renamed to `provider_id`
4. Addition of `condition_source_concept_id` field. See convention document for instructions.
5. Fields are marked as necessary for the PCORNET transformation (`condition_occurrence_id`,`condition_start_date`,`condition_concept_id`,`visit_occurrence_id`,`condition_source_value`,`condition_source_concept_id`)
6. The logic to link to the condition source value and condition type source value to a standard vocabulary has changed. See the Vocabulary Notes [below] (Pedsnet_CDM1_CDM2_diff.md#vocabulary-v5-notes) for clarification.
7. Problem list diagnosis are now included in CDM V2.

####[1.8 Procedure Occurrence](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#18-procedure_occurrence)
1. Data Type Column included in the table 
2. Addition of `procedure_time` field to procedure_occurrence.See convention document for instructions. These fields are custom to PEDSnet.
3. `associated_provider_id` field renamed to `provider_id`
4. Addition of `procedure_source_concept_id` field. See convention document for instructions.
5. Removal of `relevant_condition_concept_id` field
6. Addition of `modifier_concept_id` and `modifier_source_value`. See convention document for instructions.
7. Addition of `quantity` field. 
8.  Fields are marked as necessary for the PCORNET transformation (`procedure_occurrence_id`,`procedure_date`,`procedure_concept_id`,`visit_occurrence_id`,`procedure_source_value`,`procedure_source_concept_id`)
9. The logic to link to the procedure source value and condition type source value to a standard vocabulary has changed. See the Vocabulary Notes [below] (Pedsnet_CDM1_CDM2_diff.md#vocabulary-v5-notes) for clarification.

####[1.9 Observation](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#19-observation-1)
1. Data Type Column included in the table 
2. This table no longer includes vitals(bps), vital information or Heights/Weights. For CDM V2, it only includes (DRG (requires special logic - see Note 1), Tobacco Status (see Note 4), PROs (information and format will be provided by the DCC)) Vitals, Vital information, heights and weights have moved to the [Measurement] (Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#112-measurement-draft) table.
3. Some concept mapping values have changed. Please reference the conventions document.
4. DRG Logic has changed. (Concept_class_id as opposed to Concept_class)
5. Removal of `relevant_condition_conept_id` field.
6. Removal of `range_high` and `range_low` fields.
7. Addition of `qualfiier_concept_id` and `qualifier_source_value` field. See convention document for instructions.
8. `associated_provider_id` field renamed to `provider_id`
9. Addition of `observation_source_concept_id` field

####[1.10 Observation Period](Pedsnet_CDM_V2_OMOPV5_ETL_Conventions.md#110-observation-period-1)
1. Data Type Column included in the table 
2. Addition of `osbervation_period_start_time` and `observation_period_end_time` columns to osbervation_period.See convention document for instructions. These fields are custom to PEDSnet.
3. Fields are marked as necessary for the PCORNET transformation (`person_id`,`observation_period_start_date`,`observation_period_start_time`,`observation_period_end_date`,
`observation_period_send_time`)

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

The Standardized Vocabularies are undergoing a constant revision and improvement. Therefore, only significant structural changes are listed in the following.

**Changes to Conventions**

Concept Designation as Standard, Classification and Source
- Source Concepts: In contrast to V4.0 of the Standardized Vocabularies, there is no longer a distinction between source codes and Concepts. All source codes now have their own Concept. However, in order to distinguish between codes that are used to represent a clinical entity in the data tables, Concepts are now designated Standard Concepts or Source Concepts.
For some vocabularies, source codes did have records in the Concept table, such as VA Product, RxNorm Concept Classes “Drug Form”, SNOMED Concepts other than Condition and Procedure. These Concept had a concept_level = 0. The concept_id of these non-standard Concepts has been preserved between the versions.
- Standard Concepts: These Concepts were available in previous versions of the Standardized Vocabularies. They were designated through a concept_level value greater than 0. The concept_id of Standard Concepts has been preserved between the versions.
- Classification Concepts: Like the Standard Concepts, the Classification Concepts existed in V4.0 of the Standardized Vocabulary. Their concept_level was typically 3 for drug classifications, 1-5 for MedDRA (Condition Classification) and 1-2 for SNOMED Procedure Classifications. Their concept_id has been preserved as well.

Mapping between source and Standard Concepts.
- Each source code has now a representation as a Source Concept, and the mapping is achieved through the CONCEPT_RELATIONSHIP table. A new relationship_id = “Maps to” (reverse_relationship_id = “Mapped from”) links the Source to the Standard Concepts.
- The SOURCE_TO_CONCEPT_MAP table is no longer used, and therefore no longer populated in the Standardized Vocabularies. However, it still can be used to map local source codes for specific ETL procedures using non-public vocabularies not supported here.

For full documentation on the vocabulary changes, please reference the OHDSI website: [http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:changes_from_version_4] (http://www.ohdsi.org/web/wiki/doku.php?id=documentation:vocabulary:changes_from_version_4)

