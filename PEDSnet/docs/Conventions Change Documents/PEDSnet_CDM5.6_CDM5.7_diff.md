# Differences between PEDSnet CDM 5.6 and CDM 5.7

## **** NEW in PEDSnet CDM v5.7 ****

### (1) Update to [1.6 Visit_Occurrence](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.7_PEDSnet_CDM_ETL_Conventions.md#16-visit_occurrence) Guidance

Beginning in version 5.7, the PEDSnet data model will now allow visits marked as **cancelled** in source EHR systems if the following conditions are held:

> 1. The visit has a source value in the EHR containing terms such as "`cancel`", "`no show`", "`not seen`", etc.
> 2. The visit's `visit_occurrence_id` is a foreign key in **at least 1 clinical fact record** in at least one of the following PEDSnet CDM tables:

> - condition_occurrence
> - procedure_occurrence
> - drug_exposure
> - measurement
> - immunization
> - device_exposure
> - observation
> - adt_occurrence
> - measurement_organism

The previously underutilized `visit_source_concept_id` field will be leveraged to distinguish between cancelled and non-cancelled visits.

> - For cancelled visits, please set `visit_source_concept_id` = `2000001590` "Visit flagged as cancelled in source EHR system".
> 
> - For all other visits, please set `visit_source_concept_id` = `0`.

Additional Notes:

> - Internal analyses concluded that generally, if a canceleld visit still has clinical facts associated, then most likely a patient interaction with a provider occurred. The visit may have been incorrectly categorized as cancelled due to administrative error or post-visit quirks in billing.
> 
> - Do not include cancelled visits that only have a foreign key reference from a visit_payer record. Payment information may be captured prior to a visit occurring. Without any other clinical fact records linked, it is not likely that a patient interaction with a provider actually occurred (I.E. the visit is correctly marked as cancelled.


### (2) Introduction of the Continuous Infusion Volume Derivation Pilot
In order for the PEDSnet DCC to derive total administered volumes for continuous IV infusions, we are asking sites pilot the following:

>  1. Extract ALL MAR actions for continuous administrations.
>  2. Load the MAR actions into the `drug_iv_pilot` testing table added to the [PEDSnet DDL for version 5.7](https://data-models-sqlalchemy.research.chop.edu/pedsnet/5.7.0/). 
> 
> The `drug_iv_pilot` table duplicates the structure of the `drug_exposure` table with three additional fields necessary for the derivation: 
> 
>  `dose_infusion_rate` - Numerical value of the bag's infusion rate.
>  
>  `dose_infusion_rate_units` - Unit associated with the bag's infusion rate.
>  
>  `order_group_id` - ID for grouping MAR actions for the same ordered bag together.

 
**Please refer to the [Continuous IV Fluid Volume Guidance](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets%20%26%20Additional%20Guidance/Continuous%20IV%20Fluid%20Volume%20Guidance.md) documentation for for full details.**

> **NOTE** that this pilot should be separate from your current loading of drug administrations in the `drug_exposure` table. **Please still load drug administrations into `drug_exposure` as normal.** 
> 
> We would like to be able to compare between currently loaded `effective_drug_dose` values and our derived `effective_drug_dose` values.


### (3) Guidance on Modeling New OMB Race and Ethnicity Categories 

If your institution has begun collecting race and ethnicity information utilizing the [updated OMB categories](https://www.census.gov/about/our-research/race-ethnicity/standards-updates.html), to align with [OHDSI guidelines](https://forums.ohdsi.org/t/dealing-with-multiple-races-and-other-exceptions/20091/27), please utilize the following guidance for modeling these categories in the PEDSnet Data Model:

- If a patient has a single Race category:
> - Utilize corresponding `race_concept_id` options in the [`person`](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.7_PEDSnet_CDM_ETL_Conventions.md#11-person-1) table.
> - Addition of new `race_concept_id` option for "Middle Eastern or North African" `concept_id` = `38003615`.

- If a patient has multiple Race categories:
> - set `race_concept_id` = `44814659` "Multiple Races" in the [`person`](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.7_PEDSnet_CDM_ETL_Conventions.md#11-person-1) table.
> - Insert 1 record for each selected race category into the [`Observation`](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.7_PEDSnet_CDM_ETL_Conventions.md#19-observation-1) table where `observation_concept_id` = `3050381` ("Race or Ethnicity") and `value_as_concept_id` equals the concept_id representing the individual category.
> - Accepted concepts can be found in the concept table where `vocabulary_id in ("Race","Ethnicity")`.
> - If date of encounter is available for the race and ethnicity information, use that date to populate `observation_date`. Otherwise, set `observation_date` = patient's birth date


### (4) Update to [1.12 Measurement](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.7_PEDSnet_CDM_ETL_Conventions.md#112-measurement-1) Guidance 

To align the vocabulary of the `measurement_concept_id` used for "Inspired Oxygen Concentration" to LOINC, we ask to change the `measurement_concept_id` used from the SNOMED `concept_id` = `4353936` "Inspired oxygen concentration" to the LOINC `concept_id` = `3020716` "Inhaled oxygen concentration".
