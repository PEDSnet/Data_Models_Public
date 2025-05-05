# Differences between PEDSnet CDM 5.7 and CDM 5.8

## **** NEW in PEDSnet CDM v5.8 ****

### (1) Additional Guidance for [1.11 Drug Exposure](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.8_PEDSnet_CDM_ETL_Conventions.md#111-drug_exposure):

Begininng in PEDSnet version 5.5, we specified the new `drug_type_concept_id = 32865` "Patient self-report" to represent Patient Reported Drugs (in clarity where `order_med.order_class_c represents "Historical Med"`).

When providing patient reported drugs, in order to delineate the difference between the date range the patient reported taking the drug from the date the drug history was recorded in the EHR system, please use the following guidance:
> 
> * Set `drug_exposure_order_date/datetime` to the date in which the patient reported drug was recorded in the EHR system.
> 
> * Use `drug_exposure_start_date/datetime` and `drug_exposure_end_date/datetime` to specify the date range in which the patient reported taking the drug. Leave `drug_exposure_end_date/datetime` NULL if no end date is specified.
> 
> * If the patient reported drug record does not specify a date range or start date, then also set `drug_exposure_start_date/datetime` to the date in which the patient reported drug was recorded in the EHR system in order to fulfill the field's Non Null Constraint.

### (2) Continuation of the [Continuous Infusion Volume Derivation Pilot](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets%20%26%20Additional%20Guidance/Continuous%20IV%20Fluid%20Volume%20Guidance.md)

We are continuing the Continuous Infusion Volume Derivation Pilot introduced in PEDSnet version 5.7. Based on the results from the first pilot cycle, we made slight changes and included some additional guidance:

1. DDL changes to the `drug_iv_pilot` table:
	* Changing the name of table's primary key from `drug_exposure_id` to `drug_pilot_id` in order to differentiate from the drug_exposure table's `drug_exposure_id`.
	* Inclusion of `mar_action_name` field. 

2. Guidance Clarification on MAR action extraction
	* When targeting which drug admins' MARs to extract, we are interested in intravenous administrations, particularly **continuous frequencies and boluses**. If easier, the site can submit all actions from intravenous administrations without filtering and the DCC can filter.	* Please extract **ALL** MAR actions for such administration events, **including STOPPED actions**.

3. Guidance Clarification on MAR action loading to the `drug_iv_pilot` table
 
 * At minimum, please populate the following fields in the table when present:

> * `drug_pilot_id` (Arbitrary ID for Table's Primary Key)
> * `person_id`
> * `visit_occurrence_id`
> * `drug_exposure_start_date` (The MAR action's taken_time)
> * `drug_exposure_start_datetime` (The MAR action's taken_time)
> * `drug_concept_id`
> * `drug_source_value`
> * `drug_type_concept_id`
> * `order_group_id` (MAR action's `ORDER_MED_ID` used to link actions to the same order)
> * `mar_action_name` (Text value for the action type like New Bag, Rate Verify, etc.)
> * `dose_infusion_rate`(Numerical value for the infusion rate of that action)
> * `dose_infusion_rate_units` (Text for the infusion rate unit, most likely a "volume / time" unit)

* **Please still load drug administrations into `drug_exposure` as normal.** 
* Please keep the MARs loaded to `drug_iv_pilot` separate from your current loading of drug administrations in the `drug_exposure` table. You are not required to perform any mapping or referencing between the `drug_iv_pilot`and `drug_exposure` tables.

**Please refer to the [Continuous IV Fluid Volume Guidance](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Codesets%20%26%20Additional%20Guidance/Continuous%20IV%20Fluid%20Volume%20Guidance.md) documentation for for full details.**


### (3) Fix to [1.16 ADT Occurrence](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.8_PEDSnet_CDM_ETL_Conventions.md#116-adt_occurrence) DDL:

It was identified that the PEDSnet DDL did not have Foreign Key Constraints on `prior_adt_occurrence_id` and `next_adt_occurrence_id` referencing `adt_occurrence_id` despite the foreign key relationship being explicitly definted in the ETL Specifications.
> 
> Going forward, `prior_adt_occurrence_id` and `next_adt_occurrence_id` will have a Foreign Key Constraint applied and reference other `adt_occurrence_id` values in the `adt_occurence` table.
> 
> Populating these two fields are optional and the enforcement of the foreign key should not impact sites who are already populating them per ETL specification guidance.