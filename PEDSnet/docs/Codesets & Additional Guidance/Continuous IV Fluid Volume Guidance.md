# Continuous IV Infusion Volume Pilot

## Background
PEDSnet has been receiving more study related requests about the volume of IV fluids patients receive while admitted to the hospital (particularly in the ED and ICU settings) for projects on sepsis and kidney function. 

Currently, in the drug_exposure table, the `effective_drug_dose` field for continuous IV administrations only captures information about the total dose ordered rather than the volume actually administered into a patient.

To that end, we are asking sites to provide **all individual MAR actions for all continuous IV fluid administrations** so that the DCC can use these records to derive total fluid volume administered as:
`(total elapsed time across MAR actions)` X `(infusion rate)` X `(conversion factor to align time units)`

## Site Implementation - Extraction
Please extract MAR records for continuous IV infusions via a separate process such that it will not interfere with the current `drug_exposure` table. 
> 
> In particular, extract **ALL** MAR actions with a frequency indicating continuous (clarity source `ip_frequency.freq_name`). 
> 
> We are **NOT** filtering in or out any particular MAR actions.

Please ensure during extraction you are including the following fields:
> 
> * infusion rate (clarity source `MAR_ADMIN_INFO.INFUSION_RATE`)
> * infusion rate units (clarity source `MAR_ADMIN_INFO.MAR_INF_RATE_UNIT_C`)
> * local identifier for the drug order (clarity source `MAR_ADMIN_INFO.ORDER_MED_ID`)
> * Start datetime of MAR action
> * End datetime of MAR action

## Site Implementation - Transformation & Loading
Please transform and load the extracted MAR action records to the `drug_iv_pilot` table in the [PEDSnet v5.7 DDL](https://data-models-sqlalchemy.research.chop.edu/pedsnet/5.7.0/). 

The `drug_iv_pilot` table duplicates the `drug_exposure` table with the addition of three fields:

### (1) `dose_infusion_rate` 
> 
> * Numeric field
> * The numerical value for the bag's infusion rate.

### (2) `dose_infusion_rate_units` 
> 
> * Text field
> * The unit associated with the bag's infusion rate

### (3) `order_group_id`
> 
> * BigInteger field
> * An ID for grouping individual MAR actions for the same ordered bag together.
> * To avoid any potential PHI, please do not send the source system identifier. Instead, mask the source id using a window function such as 
> 
> `select dense_rank() over (order by order_med_id) as disp_order_group_id ` 
 
Please populate all other `drug_iv_pilot` fields (`drug_concept_id`, `drug_source_value`, etc.) as you typically would when loading meds into the `drug_exposure` table where applicable.

When populating `drug_iv_pilot`, please **do not** break out actions for mixtures into separate records for each drug component in the mixture; just send the MAR actions for the med mixture as a whole.

## Additional Notes

### (1) For any MAR actions targeted and loaded into the `drug_iv_pilot`, please still include its corresponding med administration record in the `drug_exposure` table as normal.

> We would like to compare the `effective_drug_dose` values currently in `drug_exposure` from the established ETL process to our derived `effective_drug_dose` values using `drug_iv_pilot`.

### (2) This pilot will be our first iteration. 
> Changes to this workflow such as loading data into `drug_exposure` instead of `drug_iv_pilot` are possible in future PEDSnet versions, but are dependent on the pilot's results.

### (3) Please inform the PEDSnet DCC if your site has already implemented a process to derive continuous fluid volumes localily.  
> If you are sending us derived `effective_drug_dose` values in the drug_exposure table already, piloting this MAR extraction work may be duplicative.