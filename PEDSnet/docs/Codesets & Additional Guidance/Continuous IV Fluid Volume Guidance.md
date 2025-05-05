# Continuous IV Infusion Volume Pilot (v2)

## Background
PEDSnet has been receiving more study related requests about the volume of IV fluids patients receive while admitted to the hospital (particularly in the ED and ICU settings) for projects on sepsis and kidney function. 

Currently, in the drug_exposure table, the `effective_drug_dose` field for continuous IV administrations only captures information about the total dose ordered rather than the volume actually administered into a patient.

To that end, we are asking sites to provide **all individual MAR actions for all intravenous fluid administrations (particularly for continuous frequencies and boluses)** so that the DCC can use these records to derive total fluid volume administered as:
`(total elapsed time across MAR actions)` X `(infusion rate)` X `(conversion factor to align time units)`

## Site Implementation - Extraction
Please extract your IV MAR actions via a separate process such that it will not interfere with the current `drug_exposure` table. 
> 
> In particular, extract **ALL** MAR actions from administrations that have an intravenous route and a frequency indicating continuous or bolus. If easier, the site can submit all actions from intravenous administrations without filtering and the DCC can filter for specific frequencies.
> 
> We are **NOT** filtering in or out any particular actions types. Please include all actions, including stops.

Please ensure during the extraction you are including the Action's:
> 
> * Infusion rate (clarity source `MAR_ADMIN_INFO.INFUSION_RATE`)
> * Infusion rate units (clarity source `MAR_ADMIN_INFO.MAR_INF_RATE_UNIT_C` or `zc_med_unit.name`)
> * Local identifier for the drug order (clarity source `MAR_ADMIN_INFO.ORDER_MED_ID`)
> * Datetime of MAR action event (clarity source `MAR_ADMIN_INFO.TAKEN_TIME`)
> * MAR Action Name (clarity source `MAR_ACTION_C_NAME`)

## Site Implementation - Transformation & Loading
Please transform and load the extracted MAR action records to the `drug_iv_pilot` table in the [PEDSnet v5.8 DDL](https://data-models-sqlalchemy.research.chop.edu/pedsnet/5.8.0/). 

The `drug_iv_pilot` table DDL is based off of the `drug_exposure` table with a few changes:

### (1) `drug_pilot_id` 
> 
> * Integer field
> * Arbitrary ID for Table's Primary Key
> * equivalent to `drug_exposure_id` in the `drug_exposure` table

### (2) `dose_infusion_rate` 
> 
> * Numeric field
> * The numerical value for the bag's infusion rate.

### (3) `dose_infusion_rate_units` 
> 
> * Text field
> * The unit associated with the bag's infusion rate
> * Expected to most likely be a "volume / time"

### (4) `order_group_id`
> 
> * BigInteger field
> * An ID for grouping individual MAR actions for the same ordered bag together.
> * To avoid any potential PHI, please do not send the source system identifier. Instead, mask the source id using a window function such as 
> 
> `select dense_rank() over (order by order_med_id) as disp_order_group_id`

### (5) `mar_action_name` 
> 
> * Text field
> * Text value for the MAR's action type
> * Examples include New Bag, Rate Verify, etc.

 
Please populate all other `drug_iv_pilot` fields (`drug_concept_id`, `drug_source_value`, etc.) as you typically would when loading meds into the `drug_exposure` table where applicable.

When populating `drug_iv_pilot`, please **do not** break out actions for mixtures into separate records for each drug component in the mixture; just send the MAR actions for the med mixture as a whole.

At minimum, please populate the following fields in the table when present:

> * `drug_pilot_id`
> * `person_id`
> * `visit_occurrence_id`
> * `drug_exposure_start_date`
> * `drug_exposure_start_datetime` 
> * `drug_concept_id`
> * `drug_source_value`
> * `drug_type_concept_id`
> * `order_group_id` 
> * `mar_action_name` 
> * `dose_infusion_rate`
> * `dose_infusion_rate_units`

## Additional Notes

### (1) For any MAR actions targeted and loaded into the `drug_iv_pilot`, please still include its corresponding med administration record in the `drug_exposure` table as normal.

> We would like to compare the `effective_drug_dose` values currently in `drug_exposure` from the established ETL process to our derived `effective_drug_dose` values using `drug_iv_pilot`.

### (2) You are not required to perform any mapping or referencing between the `drug_iv_pilot`and `drug_exposure` tables.
> These tables should be kept independent from one another. Please do not include any Foreign Key references between drug_exposure and drug_iv_pilot.
 
### (3) This pilot will be our second iteration. 
> Changes to this workflow such as loading data into `drug_exposure` instead of `drug_iv_pilot` are possible in future PEDSnet versions, but are dependent on the pilot's results.

### (4) Please inform the PEDSnet DCC if your site has already implemented a process to derive continuous fluid volumes localily.  
> If you are sending us derived `effective_drug_dose` values in the drug_exposure table already, piloting this MAR extraction work may be duplicative.