# Differences between PEDSnet CDM 5.3 and CDM 5.4

## **** NEW in PEDSnet CDM v5.4 ****

### 3. Update to [1.23 Cohort](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.4_PEDSnet_CDM_ETL_Conventions.md#123-cohort-1) Guidance:


**Updated Guidance for Date Fields:**
> Date and datetime fields can be populated according to cohort-specific guidelines. For example, if a clinical trial involves a specific length of follow up from `cohort_start_date` and `cohort_start_datetime`, this can be computed accordingly.
> 
> If times are not available, datetimes should assert 23:59:59.
> 
> The `withdraw_date/datetime` should remain entirely independent from the `cohort_end_date/datetime` and should remain NULL if the subject never withdrew from the trial.
> 
> `cohort_end_date` definitions will vary across clinical trial designs. In some designs, it can be computed by applying a consistent time window to cohort start date. In other cases, it is trial outcome or milestone dependent. It will be important to prospectively assess data quality for cohort end date, as this information is not always represented in source databases. For example, for the PRoMPT BOLUS study, the cohort_end_date and cohort_end_datetime fields should be equal to the cohort_start_date/datetime fields plus 730 days

**New Guidance on CDM Integration and Data Submission:**
> Please ensure that any submission of a populated cohort.csv file for any study is properly integrated into the rest of the PEDSnet data. This includes 
> 
> 1. subject_ids that are populated with corresponding person_ids in the person table
> 2. All column headers and constraints match the expected DDL specifications
> 3. The cohort.csv file exists within the same zip/tar as all other PEDSnet files
> 4. Previously submitted cohort records remain stable and populated in the cohort table for the duration of the study using them

### 4. Update to [1.24 Cohort Definition](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/Conventions%20Docs/v5.4_PEDSnet_CDM_ETL_Conventions.md#124-cohort_definition) Guidance:

Removal of 2000001561 (PRoMPT BOLUS Clinical Trial​) from the [cohort_definition_id list](https://github.com/PEDSnet/Data_Models_Public/blob/master/PEDSnet/docs/v5.4_PEDSnet_CDM_ETL_Conventions.md#124-cohort_definition) that the DCC maintains 
> Both cohort_definition_ids representing the arms of the PRoMPT BOLUS clinical trial are still going to remain in the list. 2000001561 was removed as we only expect the arms of PRoMPT BOLUS to be used to connect a subject to
> 
> The `cohort_definition.csv` file [linked directly here](https://github.com/Data_Models_Public/Data_Models_Public/blob/master/PEDSnet/docs/Codesets/cohort_definition.csv) and distributed within the PEDSnet Vocabulary will also reflect these changes.

	
## **** Reminders ****

### Sites submitting RECOVER data with v5.4 submission

For sites submiting RECOVER data along with the v5.4 submission, please provide a CSV of patients meeting the RECOVER inclusion criteria with an inclusion reason.

Please use the original [**RECOVER** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/RECOVER%20Cohort.md). 

### Sites submitting COVID data with v5.4 submission

For sites submiiting COVID data along with the v5.4 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. 

Please use the original [**COVID** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/COVID-19%20Cohort.md).
