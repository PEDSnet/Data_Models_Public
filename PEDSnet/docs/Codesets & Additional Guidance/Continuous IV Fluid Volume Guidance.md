# Continuous IV Infusion Volume Guidance (v3)

## Background
PEDSnet has been receiving more study related requests about the volume of IV fluids that patients receive while admitted to the hospital (particularly in the ED and ICU settings) for projects on sepsis and kidney function. 

Up until PEDSnet version 5.8 (June 2025), in the drug_exposure table, the `effective_drug_dose` field for IV fluid administrations only captured information about the total dose ordered rather than the volume actually administered into a patient. 

To that end, beginning in PEDSnet version 5.9 (Sept 2025), we are asking sites to extract **all individual MAR actions for all intravenous fluid administrations (particularly for continuous infusions and boluses)** and load them into the `drug_exposure` table so that the DCC can derive total fluid volume administered as:

`(elapsed time between subsequent MAR actions on the same order)` X `(infusion rate)` X `(conversion factor to align time units)`

## Site Implementation - Extraction
### Please extract **all MAR Actions**, including **stops** and **pauses**, for **intravenous fluid administrations**, particularly for **continuous infusions and boluses**.
 
In particular, extract **ALL** MAR actions from administrations that have an intravenous route and a frequency that would be used at your site for a continuous infusion or bolus.
> * Examples of fluids of interest include normal saline (e.g. D5 NS, D5 1/2 NS, etc) and crystalloid fluids (e.g. Lactated Ringers, Hartmann's solution).
> * Examples of frequencies that may indicate continous infusions or boluses may the terms "continuous", "once", "one", "bolus", etc.
> * Example of frequencies that would NOT indicate continous infusions or boluses would contain text indicating scheduled intake such as "Once Daily", "EVERY 6 HOURS", "Q6H", etc.

Please ensure during the extraction you are including the following information from the MAR action record:
> 
> * Infusion rate (clarity source `MAR_ADMIN_INFO.INFUSION_RATE`)
> * Infusion rate units (clarity source `MAR_ADMIN_INFO.MAR_INF_RATE_UNIT_C` or `zc_med_unit.name`)
> * Local identifier for the drug order (clarity source `MAR_ADMIN_INFO.ORDER_MED_ID`)
> * MAR Action Name (clarity source `MAR_ACTION_C_NAME`)
> * Datetime of MAR action event (clarity source `MAR_ADMIN_INFO.TAKEN_TIME`)

## Site Implementation - Transformation & Loading
Please transform and load the extracted MAR action records to the `drug_exposure` table such that no MAR actions are filtered out and there is one record for each MAR action on the order.

* To specify which `drug_exposure` records represent a MAR action of an intravenous fluid administration versus other inpatient administrations, we have created a new `concept_id` - `2000001594` "MAR Action of inpatient intravenous fluid administration".

* For each MAR Action record, please set `drug_type_concept_id` = `2000001594` so that the DCC can identify which MAR actions should be grouped to derive total adminstered fluid volumes.

#### The below table specifies where to insert each extracted MAR Action field:

Extracted Field | Target Drug_Exposure Field(s)| Notes|
|--------|--------------------------|------|
`Infusion Rate` | `effective_drug_dose`, `eff_drug_dose_source_value`
`Infusion Rate Units` | `dose_unit_source_value`, `dose_unit_concept_id` | <ul><li>Expected be a "volume / time" unit.</li><li>Populate `dose_unit_concept_id` with the corresponding concept_id for the infusion rate </li</ul>
`Local identifier for the drug order` | `drug_source_value` | <ul><li>Include the text `med_id=` concatenated with the local identifier.</li><li>Use a pipe delimeter to separate from other data in the source value. </li</ul>
`MAR Action Name` | `drug_source_value`| Use a pipe delimeter to separate from other data in the source value 
`Datetime of MAR action event` | `drug_exposure_start_date`, `drug_exposure_start_datetime`
 
* `drug_exposure` fields other than the target fields listed in the table above should be populated in the typical way that inpatient medication administration records are populated.

* The `drug_source_value` should be formatted as follows:
	* `Local identifier for the drug order` | `MAR action name` | Local Drug Code | Local Drug Name
	* Ex: `med_id=200100074|Rate Change|372000|FUROSEMIDE IV INFUSION-FUROSEMIDE 10 MG/ML (UNDILUTED) INJECTION`

* When populating `drug_exposure`, please **do not** break out actions for mixtures into separate records for each drug component in the mixture; just send the MAR actions for the med mixture as a whole.


## PEDSnet DCC Derivation
The PEDSnet DCC has developed a fluid volume derivation which will be integrated into its production data pipeline. 

Once the PEDSnet DCC receives and loads the submitted  `drug_exposure` table, total fluid volume administered will be derived in cases where there are >1 `drug_exposure` records that have

> 1. The same `person_id` and `visit_occurrence_id`
> 2. `drug_type_concept_id` = `2000001594`
> 3. The same `identifier for the drug order` in `drug_source_value`
> 4. An `effective_drug_dose` or `eff_drug_dose_source_value` populated.
> 5. A `dose_unit_concept_id` or `dose_unit_source_value` that is a rate.
> 6. A frequency that does NOT indicate a scheduled intake ("Once Daily", "EVERY 6 HOURS", "Q6H", etc.).

* If an Action has a name that implies that the fluid is being administered (so excluding actions like "STOPPED", "PAUSED", "CANCELLED", etc.), the difference in time between the current and next action on the same order will be used to calculate volume administered. The result will be used to update the `effective_drug_dose` and the `dose_unit_concept_id` will be updated from a rate unit to a volume unit.

* If an Action has a name that implies that the fluid is NOT being administered (like "STOPPED", "PAUSED", "CANCELLED", etc.), then `effective_drug_dose` will be set to 0 and the `dose_unit_concept_id` will still be updated from a rate unit to a volume unit.

* This will only work in cases where there are more than 1 action on an order. In addition, the final action on an order will not have a subequent action to compare the time for and thuss will not be calculated. In most cases, the final MAR action is expected to be a "STOPPED" action which would have a volume anyway.

* Once volumes are derived at the MAR action level, if all of the actions on the same drug order have similar metadata fields (e.g. same `drug_concept_id`, Local Drug Name in `drug_source_value`, etc.), we will attempt to consolidate all MAR action records into a single inpatient administration event. It would take the `min(drug_exposure_start_date)` as the start, the `max(drug_exposure_start_date)` as the end, and the `sum(effective_drug_dose)` as the final effective_drug_dose.