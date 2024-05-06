# Differences between PEDSnet CDM 4.8 and CDM 4.9

## **** NEW in PEDSnet CDM v4.9 ****

### Update(s) to [1.9 observation](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.9.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#19-observation-1) Guidance - Part 1:

Additions of "Hunger Vital Signs" data to the Observation Domain.

> For sites using Epic/Clarity, this data may be documented in Flowsheets or Questionnaires.
> 
> However their will likely be some internal investigation needed to determine where this data is stored in your sites Data Warehouse.

- See the below table for the concept mappings that can be used for the "**Hunger Vital Signs # 1**" data:

>observation\_concept\_id|observation\_concept\_name|observation\_type\_concept\_id
>---|---|---
>40192517|Within the past 12 months, were you worried whether your food would run out before you got money to buy more?|38000280
>
>value\_as\_concept\_id|value\_as\_string
>---|---
>4188539|Yes
>4188540|No
>44814653|Unknown

- See the below table for the concept mappings that can be used for the "**Hunger Vital Signs # 2**" data:

>observation\_concept\_id|observation\_concept\_name|observation\_type\_concept\_id
>---|---|---
>40192426|Within the past 12 months, were you worried whether the food you had bought just didn't last and you didn't have money to get more?|38000280

>value\_as\_concept\_id|value\_as\_string
>---|---
>4188539|Yes
>4188540|No
>44814653|Unknown

- See the below table for the concept mappings that can be used for the "**General Food Insecurity Flag**" data:

>observation\_concept\_id|observation\_concept\_name|observation\_type\_concept\_id
>---|---|---
>37116643|Food insecurity (finding)|38000280

>value\_as\_concept\_id|value\_as\_string
>---|---
>4188539|Yes
>4188540|No
>44814653|Unknown

### Update(s) to [1.9 observation](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.9.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#19-observation-1) Guidance - Part 2:

Additions of "Gender Identity", "Preferred Pronouns", and "Sexual Orientation" data to the Observation Domain.

- See the below table for the concept mappings that can be used for "**Gender Identity**" data:

>observation\_concept\_id|observation\_concept\_name|observation\_type\_concept\_id
>---|---|---
>46235215|Gender identity|38000280|
>
>value\_as\_concept\_id|value\_as\_string
>---|---
>36307702|Identifies as female
>36308665|Identifies as male
>36309864|Identifies as non-conforming
>1585351|Closer Gender Description: Genderqueer
>36309198|Female-to-male transsexual
>36309787|Male-to-female transsexual
>36308454|Asked but unknown
>45878142|Other
>
>value\_source\_value|
>---|
>Value's text as appears in source system|
- See the below table for the concept mappings that can be used for "**Preferred Pronouns**" data:

>observation\_concept\_id|observation\_concept\_name|observation\_type\_concept\_id
>---|---|---
>1175108|Personal pronouns - Reported|38000280

>value\_as\_concept\_id|value\_as\_string
>---|---
>1177233|he/him/his/his/himself
>1177256|she/her/her/hers/herself
>1177368|they/them/their/theirs/themselves
>1177374|co/co/cos/cos/coself
>1177317|en/en/ens/ens/enself
>1177363|ey/em/eir/eirs/emself
>1177342|ve/vis/ver/ver/verself
>1177238|xie/hir ("here")/hir/hirs/hirself
>1177202|yo/yo/yos/yos/yoself
>1177280|ze/zir/zir/zirs/zirself
>44814649|other (i.e. pronoun not listed above)
>
>value\_source\_value|
>---|
>Value's text as appears in source system|
- See the below table for the concept mappings that can be used for "**Sexual Orientation**" data:

>observation\_concept\_id|observation\_concept\_name|observation\_type\_concept\_id
>---|---|---
>46235214|Sexual Orientation|38000280
>
>value\_as\_concept\_id|value\_as\_string
>---|---
>36307527|Bisexual
>36303203|Homosexual
>36310681|Heterosexual
>36308454|Asked but unknown
>45877986|Unknown
>45878142|Other
>
>value\_source\_value|
>---|
>Value's text as appears in source system|

### Update(s) to [1.17 Immunization](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v4.9.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#117-immunization-1) Guidance:

1. The `immunization_type_concept_id ` field in has an additional possible value.
    - The concept id value of 32879, for "Internal Registry (not State Immunization Registry)", will now be an acceptable value for `immunization_type_concept_id `. This concept ID can be used to flag a patients pressents on an internal registry for a given Vaccination (specifically COVID-19), without the actual "vaccination date" included (and when no other vaccination info exists for them).

## **** Reminders ****

### Sites submitting RECOVER data with v4.9 submission

For sites submiting RECOVER data along with the v4.8 submission, please provide a CSV of patients meeting the RECOVER inclusion criteria with an inclusion reason.

Please use the original [**RECOVER** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/RECOVER%20Cohort.md#data-submission). 

### Sites submitting COVID data with v4.9 submission

For sites submiiting COVID data along with the v4.9 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. 

Please use the original [**COVID** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/COVID-19%20Cohort.md#data-submission).
