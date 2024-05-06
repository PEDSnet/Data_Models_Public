## Improve Care Now (ICN) Survey Concept Mapping

Please use the following as a guide for populating ICN Survey Questions and Responses in the `Observation` table.

Concept Name | Smart Data Element ID| Observation Concept ID | Concept description | Value as concept ID|Value as Number
---|--- | --- | --- | --- | ---
Abdominal Pain |EPIC#15881|2000001434|None|2000001435
Abdominal Pain |EPIC#15881|2000001434|Mild|2000001436
Abdominal Pain |EPIC#15881|2000001434|Moderate to Severe|2000001437
Rectal Bleeding|EPIC#16412|2000001438|None|2000001435
Rectal Bleeding|EPIC#16412|2000001438|Small amount only, in <50% of stolls|2000001439
Rectal Bleeding|EPIC#16412|2000001438|Small amount with most stools|2000001440
Rectal Bleeding|EPIC#16412|2000001438|Large amount (>50%  of the stool content)|2000001441
Stool Consistency of most stools|EPIC#RSGI0007A|2000001442|Formed|2000001443
Stool Consistency of most stools|EPIC#RSGI0007A|2000001442|Partially Formed|2000001444
Stool Consistency of most stools|EPIC#RSGI0007A|2000001442|Completely unformed|2000001445
Number of Stools per 24h|EPIC#17766|2000001446|||\*Populate with numeric value from survey
Nocturnal stools (any episode causing awakening)|EPIC#17237|2000001447|No|2000001449
Nocturnal stools (any episode causing awakening)|EPIC#17237|2000001447|Yes|2000001448
Activity Level|EPIC#15880|2000001450|No limitation of activity|2000001451
Activity Level|EPIC#15880|2000001450|Occasional  limitation of activity|2000001452
Activity Level|EPIC#15880|2000001450|Severe restricted activity|2000001453
General well being|EPIC#16507|2000001454|Normal|2000001455
General well being|EPIC#16507|2000001454|Fair|2000001456
General well being|EPIC#16507|2000001454|Poor|2000001457
Abdomen exam| EPIC#17769|2000001458|No tenderness, no mass|2000001459
Abdomen exam| EPIC#17769|2000001458|Tenderness or mass without tenderness|2000001460
Abdomen exam| EPIC#17769|2000001458|Tenderness, involuntary guarding , definite mass|2000001461
Peri-rectal exam|EPIC#17774|2000001462|None asymptomatic tags|2000001463
Peri-rectal exam|EPIC#17774|2000001462|1-2 indolent fistula, scant drainage,  tenderness of abscess|2000001464
Peri-rectal exam|EPIC#17774|2000001462|Active fistula, drainage, tenderness or abscess|2000001465
Erythema nodusum|EPIC#17248|2000001466|Yes|2000001448
Erythema nodusum|EPIC#17248|2000001466|No|2000001449
Pyoderma gangrenosum|EPIC#17252|2000001467|Yes|2000001448
Pyoderma gangrenosum|EPIC#17252|2000001467|No|2000001449
Fever >38.5 x 3 days  in a week|EPIC#17406|2000001468|Yes|2000001448
Fever >38.5 x 3 days  in a week|EPIC#17406|2000001468|No|2000001449
Arthritis|EPIC#17652|2000001469|Yes|2000001448
Arthritis|EPIC#17652|2000001469|No|2000001449
Uveitis|EPIC#11179|2000001470|Yes|2000001448
Uveitis|EPIC#11179|2000001470|No|2000001449
Physicians Global Assessment of Current Disease Status|EPIC#16411|2000001473|Mild|2000001474
Physicians Global Assessment of Current Disease Status|EPIC#16411|2000001473|Quiescent|2000001475
Physicians Global Assessment of Current Disease Status|EPIC#16411|2000001473|Moderate|2000001476
Physicians Global Assessment of Current Disease Status|EPIC#16411|2000001473|Severe|2000001477
Extent of Macroscopic Lower GI Disease|EPIC#17746|2000001478|Colonic only|2000001479
Extent of Macroscopic Lower GI Disease|EPIC#17746|2000001478|Ileal only|2000001480
Extent of Macroscopic Lower GI Disease|EPIC#17746|2000001478|Ileocolonic|2000001481
Extent of Macroscopic Lower GI Disease|EPIC#17746|2000001478|None|2000001482
Extent of Macroscopic Lower GI Disease|EPIC#17746|2000001478|Not assessed|2000001483
Crohn’s disease Phenotype|EPIC#17759|2000001484|Both stricturing and penetrating|2000001485
Crohn’s disease Phenotype|EPIC#17759|2000001484|Inflammatory, non-penetrating, non-stricturing|2000001486
Crohn’s disease Phenotype|EPIC#17759|2000001484|Penetrating|2000001487
Crohn’s disease Phenotype|EPIC#17759|2000001484|Stricturing|2000001488

### Starter Query for EPIC Sites

```sql
SELECT
p.pat_id AS person_id,
sde.CUR_VALUE_DATETIME AS observation_datetime,
cc.name as question_asked, -- map to observation_concept_id
case when cc1.abbreviation is not null then cc1.abbreviation
when cc.Data_type_C = 6 and sv.smrtdta_elem_value = 1 then 'Yes'
when cc.Data_type_C = 6 and sv.smrtdta_elem_value = 0 then 'No'
else sv.SMRTDTA_ELEM_VALUE END as answered_value -- map to value_as_concept_id or value_as_number
FROM  patient p
inner join SMRTDTA_ELEM_DATA sde on p.PAT_ID = sde.record_id_varchar
inner join SMRTDTA_ELEM_VALUE sv on sv.HLV_ID = sde.HLV_ID
inner join CLARITY_CONCEPT cc on cc.concept_id = sde.element_id
left join CLARITY_CONCEPT cc1 on cc1.CONCEPT_ID = sv.SMRTDTA_ELEM_VALUE
WHERE element_id IN
(
'EPIC#15881', -- Abdominal Pain
'EPIC#17766', -- Number of Daily Stools
'EPIC#RSGI0007A',-- Stool Consistency
'EPIC#17237', -- Nocturnal Stools
'EPIC#15880' -- Activity Level
'EPIC#16412', -- Blood in Stool
'EPIC#15880', -- Activity Level
'EPIC#16507', -- Well being
'EPIC#17769', -- Abdomen Exam
'EPIC#17774', -- Peri-Rectal Exam
'EPIC#17248', -- Erythema nodusum
'EPIC#17252', -- pyoderma gangrenosum
'EPIC#17406', -- Fever >38.5 x 3 days  in a week
'EPIC#17652', -- Arthritis
'EPIC#11179', -- Uveitis
'EPIC#16411', -- Physicians Global Assessment of Current Disease Status
'EPIC#17746', -- Extent of macroscopic lower GI disease
'EPIC#17759' -- Crohn’s disease Phenotype
)
ORDER BY 1,2,3
;
```
