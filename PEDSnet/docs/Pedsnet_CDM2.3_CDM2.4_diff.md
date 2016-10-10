# Differences between PEDSnet CDM2.3 and CDM2.4  ****INCOMPLETE****

## CHANGES from CDM2.3.0

####Network Convention Changes 

####[1.2 Death](Pedsnet_CDM_ETL_Conventions.md#12-death-1)
1. Updating death impute concept id query

```
select * from concept 
where (concept_class_id ='Death Imput Type' 
or (vocabulary_id='PCORNet' and concept_class_id='Undefined')) 
and invalid_reason is null)
```

####Specific Table Changes
####[1.6 Visit_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)
1. Updated visit concept id and place of service concept id valid concept id query
```
select * from concept 
where domain_id='Visit' 
or (vocabulary_id='PCORNet' and concept_class_id='Encounter Type')
or (vocabulary_id='PCORNet' and concept_class_id='Undefined') a
nd invalid_reason is null
```
####[1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)
1. Updated Conventions document to explicitly state to only include final results


***
## NEW in PEDSnet CDM2.3

####[1.2 Template](Pedsnet_CDM_ETL_Conventions.md#12-death-1)
1. Template

###PEDSnet Vocabulary

***
