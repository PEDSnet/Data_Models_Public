# Differences between PEDSnet CDM 4.9 and CDM 5.0

## **** NEW in PEDSnet CDM v5.0 ****

### Update(s) to [1.9 observation](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v5.0.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#19-observation-1) Guidance:

Additions of "**PHQ**" (**P**atient **H**ealth **Q**uestionnaire) data to the Observation Domain.

> For sites using Epic/Clarity, this data may be documented in Questionnaires or Flowsheets.
> 
> However their will likely be some internal investigation needed to determine where this data is stored in your sites Data Warehouse.

- See the below table for the concept mappings that can be used for the "**PHQ-2**" data:

>observation\_concept\_id|observation\_concept\_name|observation\_type\_concept\_id
>---|---|---
>3042924|Little interest or pleasure in doing things in **last 2 weeks**<br/><br/>(a.k.a PHQ Question 1)| 38000280
>3045858|Feeling down, depressed, or hopeless in last **2 weeks**<br/><br/>(a.k.a PHQ Question 2)|38000280
>40758879|Patient Health Questionnaire 2 item (PHQ-2) total score|38000280
>
> And for the anser values, use:
>
>value\_as\_concept\_id|value\_as\_number|value\_as\_string|vocabulary_id
>---|---|---|---
>45883172|0|Not at all|LOINC
>45879886|1|Several days|LOINC
>45878994|2|More than half the days|LOINC
>45882010|3|Nearly every day|LOINC
>44814653||Unknown|PCORNet
>44814650||Null|PCORNet

- See the below table for the concept mappings that can be used for the "**PHQ-9**" data:

>observation\_concept\_id|observation\_concept\_name|observation\_type\_concept\_id
>---|---|---
>3042924|Little interest or pleasure in doing things in last 2 weeks<br/><br/>(a.k.a PHQ Question 1)|38000280
>3045858|Feeling down, depressed, or hopeless in last 2 weeks<br/><br/>(a.k.a PHQ Question 2)|38000280
>3045933|Trouble falling or staying asleep, or sleeping too much in last 2 weeks<br/><br/>(a.k.a PHQ Question 3)|38000280
>3044964|Feeling tired or having little energy in last 2 weeks<br/><br/>(a.k.a PHQ Question 4)|38000280
>3044098|Poor appetite or overeating in last 2 weeks<br/><br/>(a.k.a PHQ Question 5)|38000280
>3043801|Feeling bad about yourself - or that you are a failure or have let yourself or your family down in last 2 weeks<br/><br/>(a.k.a PHQ Question 6)|38000280
>3045019|Trouble concentrating on things, such as reading the newspaper or watching television in last 2 weeks<br/><br/>(a.k.a PHQ Question 7)|38000280
>3043785|Moving or speaking so slowly that other people could have noticed. Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual in last 2 weeks<br/><br/>(a.k.a PHQ Question 8)|38000280
>3043462|Thoughts that you would be better off dead, or of hurting yourself in some way in last 2 weeks<br/><br/>(a.k.a PHQ Question 9)|38000280
>3042932|Patient Health Questionnaire 9 item (PHQ-9) total score|38000280
>
> And for the anser values, use:
>
>value\_as\_concept\_id|value\_as\_number|value\_as\_string|vocabulary_id
>---|---|---|---
>45883172|0|Not at all|LOINC
>45879886|1|Several days|LOINC
>45878994|2|More than half the days|LOINC
>45882010|3|Nearly every day|LOINC
>44814653||Unknown (use for any other responce than those above)|PCORNet
>44814650||Null|PCORNet

### Addition of New Table [1.22 Location FIPS](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v5.0.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#13-location-1) Guidance:

All census block group data should be ETL'ed into the `Location_FIPs` table instead of the `Location` table. 

The new `Location_FIPs` table:
> 1. Allows the specification of whether a FIPS code is from the 2010 or 2020 census (and eventually 2030)  
> 2. Allows for one location_id to link to 1 or more FIPS codes (which is a possiblity between censuses)
> 3. Provides the most flexibility by explicitly allowing for different levels of census granularity
> 4. Extends, rather than modifies, location representations in the OMOP CDM 
> 5. Has a similar structure to the output of the DeGauss Tool 


Implementation Notes

> 1. The parsing out of a FIPS code is structured by level of granularity as defined in the diagram below:
> ![](https://customer.precisely.com/servlet/rtaImage?eid=ka06g000001hQNJ&feoid=00N6g00000TynF6&refid=0EM6g0000010wuS)
> 2. We are only expecting a location's FIPS code to be down to the **census block group** level of granularity (only first digit of block) Therefore, a properly modeled census block group code would be a row in the table with `geocode_state` + `geocode_county` + `geocode_tract` + `geocode_group` populated
> 3. The `geocode_block` field (representing last three digits of a FIPS code) is avaialbe to populate but not required.
> 4. Both 2020 and 2010 census FIPS codes to be populated if possible.

| Field|Type|Description|Required?
|----|----|----|----
| geocode_id        | BigInt  | primary key for the table                                                 | Yes 
| location_id       | BigInt  | foreign key to the location table                                         | Yes 
| geocode_state     | VarChar | first 2 characters of a FIPS code that represents a state                 | Yes 
| geocode_county    | VarChar | next 3 characters of a FIPS code that represents a county                 | Yes 
| geocode_tract     | VarChar | next 6 characters of a FIPS code that represents a census tract           | Yes 
| geocode_group     | VarChar | next 1 character of a FIPS code that represents a block group             | Yes
| geocode_block     | VarChar | final 3 characters of a FIPS code that represents a block                 |  No 
| geocode_year      | Int     | specify the census year associated with the geocode (eg '2010',  '2020' ) |   Yes 
| geocode_shapefile | VarChar | the name of the shapefile used in the geocoding process                   |  No 

### Update(s) to [1.3 Location](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v5.0.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#13-location-1) Guidance:

Removal of the `census_block_group` field
> With the implementation of the new `Location_FIPS` table, the location table no longer needs to contain the `census_block_group` field. All FIPS codes used to represent census geoid information should be routed and formatted into the `Location_FIPS` table.
> 
> This change will put the PEDSnet location table back into Full OMOP Compliance

### Update(s) to [1.20 Hash Token](https://github.com/PEDSnet/Data_Models/blob/pedsnet_v5.0.0_1/PEDSnet/docs/PEDSnet_CDM_ETL_Conventions.md#120-hash_token) Guidance:

Per the PCORnet 6.1 updates, additional seed data elements are needed to populate additional hash tokens

New seed data elements used to populate tokens:

> email address
> 
> phone number
> 
> As pediatric patients' email and phone number information is significantly less standardized than adult patients (for example, a pediatric patient may have their own personal email/phone or a parent/guardian's), we will leave any logic needed to pick a pediatric patient's email and phone number to the discretion of each site.

Addition of new fields to the hash token table:

`token_06` 
`token_07` 
`token_08` 
`token_09` 
`token_12`
	`token_14` 
	`token_15` 
	`token_17`
	`token_18`
	`token_23`
	`token_24`
	`token_25` 
	`token_26`
	`token_29`
	`token_30` 
	`token_101` 
	`token_102` 
	`token_103` 
	`token_104` 
	`token_105` 
	`token_106` 
	`token_107` 
	`token_108` 
	`token_109` 
	`token_110` 
	`token_111` 
	
> Note that each one of these new tokens represents some permutation of a already existing patient data seeds and the new seed data elements email address and phone number.

> 
> We are currently still waiting on implementation guidance from DataVant and PCORnet on how to populate each of these new tokens. We will be in contact once the token generation specificaitons are released and may pivot the timelines of populating these new fields based on the release date of those specifications. 

	
	
## **** Reminders ****

### Sites submitting RECOVER data with v5.0 submission

For sites submiting RECOVER data along with the v5.0 submission, please provide a CSV of patients meeting the RECOVER inclusion criteria with an inclusion reason.

Please use the original [**RECOVER** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/RECOVER%20Cohort.md#data-submission). 

### Sites submitting COVID data with v5.0 submission

For sites submiiting COVID data along with the v5.0 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. 

Please use the original [**COVID** Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/Study%20Cohorts/COVID-19%20Cohort.md#data-submission).
