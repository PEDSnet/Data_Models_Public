# ETL Sources

### This document is meant to be a starter for locating information from the various EHR sources for extraction to the PEDSnet data model.


Domain| Epic | Cerner
---|---|---
[1.1 Person](Pedsnet_CDM_ETL_Conventions.md#11-person-1)|<ul><li>patient</li><li>patient_3</li><li>patient_race</li><li>ethnic_background</li></ul>|
[1.2 Death](Pedsnet_CDM_ETL_Conventions.md#12-death-1)|<ul><li>patient</li><li>patient_3</li></ul>|
[1.3 Location](Pedsnet_CDM_ETL_Conventions.md#13-location-1)|<ul><li>patient</li><li>clarity_dep</li></ul>|
[1.4 Caresite](Pedsnet_CDM_ETL_Conventions.md#14-care_site)|<ul><li>clarity_dep</li><li>clarity_dep_2</li></ul>|
[1.5 Provider](Pedsnet_CDM_ETL_Conventions.md#15-provider-1)|<ul><li>clarity_ser</li><li>clarity_emp</li></ul>|
[1.6 Visit Occurrence ](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)|<ul><li>pat_enc</li><li>pat_enc_hsp</li><li>clarity_prc</li></ul>|
[1.7 Condition Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence)|<ul><li>pat_enc_dx</li><li>hsp_acct_dx_list</li><li>problem_list</li><li>clarity_edg</li><li>edg_current_icd9</li><li>edg_current_icd10</li><li>snomed_concept</li></ul>|
[1.8 Procedure Occurrence](Pedsnet_CDM_ETL_Conventions.md#18-procedure_occurrence)|<ul><li>order_proc</li><li>order_proc_3</li><li>clarity_eap</li><li>eap_synonyms</li><li>hsp_acct_cpt_codes</li></ul>|
[1.9 Observation](Pedsnet_CDM_ETL_Conventions.md#19-observation-1)|<ul><li>hsp_acct_mult_drgs</li><li>clarity_drg</li><li>clarity_drg_mpi_id</li><li>social_hx</li></ul>|
[1.10 Observation Period](Pedsnet_CDM_ETL_Conventions.md#110-observation-period-1)|*derived by DCC*|*derived by DCC*
[1.11 Drug Exposure](Pedsnet_CDM_ETL_Conventions.md#111-drug-exposure-1)|<ul><li>order_med</li><li>mar_admin_info</li><li>clarity_medication</li><li>rxnorm_codes</li><li>rx_ndc</li><li>clarity_ndc_codes</li></ul>|
[1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)|<ul><li>ip_flwsht_meas</li><li>ip_flwsht_rec</li><li>  ip_flo_gp_data</li><li>order_proc</li><li>order_results</li><li>clarity_component</li><li>lnc_db_main</li><li>clarity_eap</li><li>eap_synonyms</li></ul>|
[1.13 Fact Relationship](Pedsnet_CDM_ETL_Conventions.md#113-fact-relationship-1)|*derived during ETL*|*derived during ETL*|
[1.14 Visit Payer](Pedsnet_CDM_ETL_Conventions.md#114-visit_payer)|<ul><li>clarity_epp</li><li>clarity_epm</li><li>  v_coverage_payor_plan</li><li>hsp_account</li><li>order_results</li><li>zc_financial_class</li><li>arpb_transactions</li></ul>|
[1.15 Measurement Organism](Pedsnet_CDM_ETL_Conventions.md#115-measurement_organism)|<ul><li>order_results</li><li>order_sensitivity</li><li>clarity_organism</li><li>order_res_comp_cmt</li></ul>|
[1.16 ADT Occurrence](Pedsnet_CDM_ETL_Conventions.md#116-adt_occurrence)|<ul><li>clarity_adt</li><li>clarity_dep</li></ul>|
[1.17 Immunization](Pedsnet_CDM_ETL_Conventions.md#117-immunization-1)|<ul><li>immune</li><li>clarity_immunzatn</li><li>order_proc</li></ul>|
[1.18 Device Exposure](Pedsnet_CDM_ETL_Conventions.md#118-device_exposure)|<ul><li>or_log</li><li>or_imp</li><li>v_log_supplies_implants</li><li>or_imp_implant</li><li>or_imp_explant</li></ul>||
