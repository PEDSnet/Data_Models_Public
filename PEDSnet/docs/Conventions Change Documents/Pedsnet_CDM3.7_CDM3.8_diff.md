
# Differences between PEDSnet CDM 3.7 and CDM 3.8

Version 3.8 is an update to version 3.7 and includes addtional data elements developed as a part of the network's response to COVID-19.

## NEW in PEDSnet CDMv3.8 (non - COVID-19 Data Elements)

### NEW Conventions

#### Inclusion Criteria
The inclusion criteria has been updated to include **Telemedicine** visits as a meaningful *physical interation* with a clinician. This change requires changes to the [Person](Pedsnet_CDM_ETL_Conventions.md#11-person-1), [Visit_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence) and [Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence) tables.

#### [1.1 Person](Pedsnet_CDM_ETL_Conventions.md#11-person-1)

The following concept_id has been addded to the table of `Visit_concept_ids`:

Visit Type|	Visit_concept_id
---|---
Interactive Telemedicine Service|581399

#### [1.6 Visit_Occurrence](Pedsnet_CDM_ETL_Conventions.md#16-visit_occurrence)

Table 1 has been edited to include the **Telemedicine** concept_id and logic has been adjusted for the `Other ambulatory Visit (OA)` concept.

Visit Concept Id|	Concept Name|		Visit Type Inclusion	|	In Person	|	Examples/Logic (includes but is not limited to)
---|---|---|---|---
...|...|...|...|...|....|
581399| Telehealth|Use of video and other electronic communications to connect clinicians, including pediatric specialists, to patients in their own communities.|Yes||
44814711|Other ambulatory Visit (OA)	|Outpatient visits where the patient was not seen in person.|	No	|**Telephone, Emails, Refills and Orders Only Encounters**|
...|...|...|...|...|....|

#### [1.7 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence)

- To capture diagnosis for telemedicine please use the outpatient header concepts.

## NEW in PEDSnet CDMv3.8 (COVID-19 Data Elements)

### NEW Conventions

#### [1.7 Condition_Occurrence](Pedsnet_CDM_ETL_Conventions.md#17-condition_occurrence)

To reporting admission diagnosis, please use on the following **condition_type_concept_id** (depending where this information is coming from in the source system) to insert a record into the **condition_occurrence** table:

condition_type_concept_id|concept_name
---|---
 2000001423 | Admission Diagnosis - Order
 2000001424 | Admission Diagnosis - Billing
 2000001425 | Admission Diagnosis - Claim


#### [1.9 Observation](Pedsnet_CDM_ETL_Conventions.md#19-observation-1)

The following concepts have been added to **Table 1** as valid concepts for `observation_concept_id`:

Concept Name|	Observation concept ID	|Vocab ID|	Value as concept ID	|Concept description	|Vocab ID	|PCORNet Mapping
---|---|---|---|---|---|---
Suspected exposure to severe acute respiratory syndrome coronavirus 2|756083|OMOP Extension| 756046|Person Employed as a Healthcare Worker|OMOP Extension
Suspected exposure to severe acute respiratory syndrome coronavirus 2|756083|OMOP Extension|44802454|Information external to care setting|SNOMED
EHR Chief Complaint|42894222|Condition Type |||||
Electronic cigarette user|	36716478|SNOMED|42536422| Electronic cigarette liquid containing nicotine| SNOMED
Electronic cigarette user|	36716478|SNOMED|42536421| Electronic cigarette liquid without nicotine| SNOMED
Electronic cigarette user|	36716478|SNOMED|42536420| Electronic cigarette liquid (if nicotine type is not known)|SNOMED

The following notes have been added:

***Note 6**:
To capture health care workers (HCW), create a record in the observation table using the following concept_ids:

observation_concept_id: `756083: Suspected exposure to severe acute respiratory syndrome coronavirus 2 `
value_as_concept_id:`756046: Person Employed as a Healthcare Worker`

Please see the example below for formatting guidelines (with required fields):

observation table field|value
---|---
person_id| `1234`
observation_concept_id| `756083`
osbervation_date| `Date of suspected exposure (if known) or best estimate`
observation_type_concept_id| `38000280`
value_as_concept_id|`756046`

***Note 7**:
Patients may be identified as having COVID-19 using outside sources (e.g. a site registry, outside lab testing). Because of this diagnosis or testing data may not be available during the ETL.

To identify these patients, create a record in the observation table using the following concept_ids:

observation_concept_id: `756083: Suspected exposure to severe acute respiratory syndrome coronavirus 2 `
value_as_concept_id:`44802454:	Information external to care setting`

observation table field|value
---|---
person_id| `1234`
observation_concept_id| `756083`
osbervation_date| `Date of suspected exposure (if known) or best estimate`
observation_type_concept_id| `38000280`
value_as_concept_id|`44802454`

***Note 8**:
The cheif complaint is often a free text or non-structured field in source systems without any standard terminology. To record this kind of chief complaint for the patient, please use the following **observation_concept_id** to insert a record into the **observation** table:

observaton_concept_id|concept_name
---|---
42894222| EHR Chief Complaint

***Note 9**:

To record the vaping smoking status for the patient, please use the following conventions to insert a record into the **observation** table:

Concept Name	|Observation concept ID|	Value as concept ID	|Concept description|	Vocab ID
---|---|---|---|---
Electronic cigarette user|	36716478|42536422| Electronic cigarette liquid containing nicotine| SNOMED
Electronic cigarette user|	36716478|42536421| Electronic cigarette liquid without nicotine| SNOMED
Electronic cigarette user|	36716478|42536420| Electronic cigarette liquid (if nicotine type is not known)|SNOMED


#### [1.12 Measurement](Pedsnet_CDM_ETL_Conventions.md#112-measurement-1)

The following concepts have been added to **Table 3** as valid concepts for `observation_concept_id`:

Domain id|	Measurement concept ID	|Vocab ID	|Value as concept ID|	Concept description	|Vocab ID
---|---|---|---|---|---
Vital|4353936|SNOMED|See note 1|Inspired oxygen concentration (FiO2)
Vital|2000001422|PEDSnet|See note 1|Peripheral oxygen saturation/fraction of inspired oxygen(SpO2/FiO2)

#### [1.18 Device_Exposure](Pedsnet_CDM_ETL_Conventions.#118-device_exposure)

- Table description updated to include mechanical ventilation in additon to other noted items.

**Note 1** added:

To record the mechanical ventilation status for the patient, please use the following conventions to insert a record into the **device_exposure** table:

device_concept_id|concept_code|concept_name|ventilation type
---|---|---|---
4044008|	129121000|	Tracheostomy tube|invasive
4097216|	26412008|	Endotracheal tube|invasive
4138614|	425826004	|BiPAP oxygen nasal cannula| non-invasive
45761494|	467645007|	CPAP nasal oxygen cannula| non-invasive
4224038|336623009|Oxygen nasal cannula| non-invasive
4139525|426854004|High flow oxygen nasal cannula| non-invasive
45768222|	706226000	|Continuous positive airway pressure/Bilevel positive airway pressure mask| non-invasive
4222966|	336602003|	Oxygen mask|non-invasive
40493026|	449071006|	Mechanical ventilator (if unable to distinguish the type)| N/A

## Continued Data Quality Focus for PEDSnet Key Data Elements

Please continue to work on refining and improving the quality of data for the following domains and fields associated with the [PEDSnet Key Data Elements](docs/PEDSnet%20Key%20Data%20Elements.md):

- `person.birth_datetime`
- `person.location_id`
- `care_site.specialty_concept_id`
- `provider.specialty_concept_id`
- `adt_occurrence.service_concept_id`
- `visit.visit_start_date`
- `visit.visit_end_date`
- `visit_payer.plan_class`
- `condition_occurrence.condition_concept_id`
- `condition_occurrence.condition_type_concept_id`
- `condition_occurrence.visit_occurrence_id`
- `procedure_occurrence.procedure_concept_id`
- `procedure_occurrence.visit_occurrence_id`
- `drug_exposure.drug_concept_id`
- `drug_exposure.effective_drug_dose`
- `drug_exposure.quantity`
- `drug_exposure.visit_occurrence_id`
- `measurement.measurement_concept_id`
- `measurment.visit_occurrence_id`
- `measurement.value_as_number`
- `measurement.value_as_concept_id`
- `measurement.specimen_concept_id  
- `measurement.range_high`
- `measurement.range_low`
- `measurement.range_high_operator_concept_id`
- `measurement.range_low_operator_concept_id`
- `measurement_organism.organism_concept_id`
- `immunization.immunization_concept_id`

More information can be found [here.](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/PEDSnet%20Key%20Data%20Elements.md)

#### The DCC will be reaching out for site-focused DQA over the next month, particularly with issues around PCORnet.



