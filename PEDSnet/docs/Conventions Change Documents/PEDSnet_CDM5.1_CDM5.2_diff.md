# Differences between PEDSnet CDM 5.1 and CDM 5.2

## **** NEW in PEDSnet CDM v5.2 ****

#### Note that for the two new tables below, there is no requirement to populate them for PEDSnet version 5.2. This version is simply rolling out the DDL and ETL guidance for the new tables to begin testing for future versions. 

### 1. Addition of New Table [1.23 Cohort](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v5.2.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#123-cohort-1) to model a patient's clinical trial enrollment. 

> Please follow the `Cohort` link to view table guidance. In addition, please review the [Clinical Trial Participation ETL](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Clinical_Trial_Participation_ETL_Conventions.md) page for additional background.

### 2. Addition of New Table [1.24 Cohort Definition](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v5.2.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#124-cohort_definition) to model individual clinical trials arms referenced by the Cohort table. 

> Please follow the `Cohort Definition` link to view table guidance. In addition, please review the [Clinical Trial Participation ETL](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Clinical_Trial_Participation_ETL_Conventions.md) page for additional background.


## **** Reminders ****

### Sites submitting RECOVER data with v5.2 submission

For sites submiting RECOVER data along with the v5.2 submission, please provide a CSV of patients meeting the RECOVER inclusion criteria with an inclusion reason.

Please use the original [**RECOVER** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/RECOVER%20Cohort.md#data-submission). 

### Sites submitting COVID data with v5.2 submission

For sites submiiting COVID data along with the v5.2 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. 

Please use the original [**COVID** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/COVID-19%20Cohort.md#data-submission).
