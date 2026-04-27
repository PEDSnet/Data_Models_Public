# Differences Between PEDSnet CDM 6.1 and CDM 6.2

# **** Updated in PEDSnet CDM v6.2 ****


## No DDL Changes

There are no DDL or structural schema changes between PEDSnet version 6.1 and 6.2.


## Updated Conventions

### 1. IMO Term Mapping — [CONDITION_OCCURRENCE](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#12-condition_occurrence-1)

A clarification has been added for sites that use IMO (Intelligent Medical Objects) terminology in their source systems:

- Sites should map IMO terms to the current ICD-9-CM or ICD-10-CM code(s) that were in use at the time of the `visit_start_date` for that encounter.
- The original IMO term (or code) should be retained in `condition_source_value`.
- **Mapping to historical ICD codes is not a site responsibility.** Study teams requiring historical code mappings may perform that mapping on demand — sites are not expected to supply it.

This is a convention clarification only; no vocabulary or schema changes are required.

### 2. New Cohort Definition — [COHORT_DEFINITION](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#124-cohort_definition)

A new cohort definition has been added to the DCC-maintained `cohort_definition` table:

| cohort_definition_id | cohort_definition_name | cohort_definition_description | definition_type_concept_id | cohort_initiation_date |
|---|---|---|---|---|
| 2000001561 | USDHub v1 | Meets inclusion criteria for v1 USDHub cohort | 44807982 (Cohort) | 9/1/2025 |

---

# **** Reminders ****

## Drug Metadata — Priority Fields for v6.2 Submission

For the v6.2 submission cycle, sites are asked to prioritize completeness for the following fields in [DRUG_EXPOSURE](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#111-drug-exposure) where source data is available:

### 1. Dose Unit (`dose_unit_concept_id` / `dose_unit_source_value`)
- Populate `dose_unit_concept_id` with the appropriate UCUM concept for the unit of the administered or prescribed dose.
- Retain the original source unit string in `dose_unit_source_value`.

### 2. End Dates and Duration (`drug_exposure_end_date` / `days_supply`)
- Populate `drug_exposure_end_date` when an end date is available in the source system.
- Populate `days_supply` when a days-supply value is available (particularly for outpatient prescriptions).
- When only a start date is available, calculate `drug_exposure_end_date` as `drug_exposure_start_date + days_supply - 1` where possible.
