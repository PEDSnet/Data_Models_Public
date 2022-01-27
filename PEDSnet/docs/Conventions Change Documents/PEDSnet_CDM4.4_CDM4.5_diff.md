# Differences between PEDSnet CDM 4.4 and CDM 4.5

## **** NEW in PEDSnet CDM v4.5 ****

### [CDM Ventilator Pilot](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/CDM%20Ventilator%20Pilot/Ventilator%20Pilot%20Guidance.md)

For v4.5, there is a Ventilator Pilot aiming to develop the necessary common data model elements to describe mechanical ventilation over time in children with long-term mechanical ventilation dependence

This pilot will involve the following participating sites:

- CCHMC
- CHCO

For more information and conventions see the [CDM Ventilator Pilot Guidance](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/CDM%20Ventilator%20Pilot/Ventilator%20Pilot%20Guidance.md)

### [COVID- 19 Updates](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md)

#### COVID-19 Vaccine Mapping

The COVID-19 page has been updated to include mapping helpers for `immunization`, `drug_exposure` and `procedure_occurrence `mapping concepts for COVID-19 vaccinations.

<details><summary>Click here for table preview</summary>

Procedure_concept_id|	Procedure_concept_code|	Procedure Vocabulary|	Drug_concept_id|	Drug Concept Name|	Drug Vocabulary|	immunization_concept Id |Immunization Concept Name	|immunization_concept_code	|Immunization Vocabulary
---|---|---|---|---|---|---|---|---|---
Pfizer-Biontech|	766238|	91300|	CPT4|	37003436	|SARS-CoV-2 (COVID-19) vaccine, mRNA-BNT162b2 0.1 MG/ML Injectable Suspension|	RxNorm	|724907	|SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 30 mcg/0.3mL dose|	208|	CVX
Pfizer-Biontech|	759736|	91305|	CPT4|	37003436	|Tris-sucrose formula, 30 mcg/0.3 mL for ages 12+|	RxNorm	|702677	|SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 30 mcg/0.3mL dose, tris-sucrose formulation|	217|	CVX
Pfizer-Biontech|	759738|	91307|	CPT4|	37003436	|Tris-sucrose formula, 10 mcg/0.2 mL for ages 5 yrs to < 12 yrs|	RxNorm	|702678	|SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 10 mcg/0.2mL dose, tris-sucrose formulation|	218|	CVX  
Moderna |	766239|	91301|	CPT4	|37003518|	SARS-CoV-2 (COVID-19) vaccine, mRNA-1273 0.2 MG/ML Injectable Suspension|	RxNorm	|724906|	SARS-COV-2 (COVID-19) vaccine, mRNA, spike protein, LNP, preservative free, 100 mcg/0.5mL dose	|207|	CVX
AstraZeneca |	766240|	91302|	CPT4|	1230962|	AZD1222 Astrazeneca COVID-19 vaccine, DNA, spike protein, chimpanzee adenovirus Oxford 1 (ChAdOx1) vector, preservative free, 5x1010 viral particles/0.5mL dosage, for intramuscular use|	NDC	|724905	|SARS-COV-2 (COVID-19) vaccine, vector non-replicating, recombinant spike protein-ChAdOx1, preservative free, 0.5 mL|	210|	CVX
Janssen|766241|	91303|	CPT4	|739906|	SARS-COV-2 (COVID-19) vaccine, vector - Ad26 100000000000 UNT/ML Injectable Suspension|	RxNorm|	702866|	SARS-COV-2 (COVID-19) vaccine, vector non-replicating, recombinant spike protein-Ad26, preservative free, 0.5 mL	|212|	CVX
COVID -19 Vaccine (Unknown/Not Specified) |||		|	|	||724904|	SARS-COV-2 (COVID-19) vaccine, UNSPECIFIED	|213|	CVX

</details>
   
#### COVID-19 Serology Test Mappings

For the RECOVER/PASC studies there is a need to distinguish the type of protein assessed by COVID-19 Serology tests. LOINC has developed a pre-release that includes codes that would help to standardize the way these tests are represented. However, these concepts are not yet in the OMOP vocabulary. The PEDSnet team has developed temporary mappings to be able to identify the specific proteins assessed by the serology test. Please incorporate the following mappings in your ETL:
   
concept_id|concept_name|LOINC short name|concept_code|vocabulary_id
---|---|---|---|---
2000001501|SARS-CoV-2 (COVID-19) N protein IgG Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 nucleocapsid protein Ab.IgG|99596-9|LOINC
2000001502|SARS-CoV-2 (COVID-19) S protein IgG Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 spike protein Ab.IgG|99597-7|LOINC
2000001512|SARS-CoV-2 (COVID-19) N protein IgM Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 nucleocapsid protein Ab.IgM|PEDSnet Generated|LOINC
2000001513|SARS-CoV-2 (COVID-19) S protein IgM Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 spike protein Ab.IgM|PEDSnet Generated|LOINC
2000001514|SARS-CoV-2 (COVID-19) N protein IgA Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 nucleocapsid protein Ab.IgA|PEDSnet Generated|LOINC
2000001515|SARS-CoV-2 (COVID-19) S protein IgA Ab [Presence] in Serum or Plasma by Immunoassay|SARS coronavirus 2 spike protein Ab.IgA|PEDSnet Generated|LOINC


## **** Reminders ****

### Submission Metadata and ETL Changes Documentation

Please document submission metadata and any ETL changes for version 4.5 in the [REDCap Project](https://redcap.chop.edu/redcap_v10.3.2/DataEntry/record_status_dashboard.php?pid=38566).

### Sites submitting COVID data with v4.5 submission

For sites submiiting COVID data along with the v4.5 submission, please provide a CSV of patients meeting the COVID inclusion criteria with an inclusion reason. Please use the original [COVID Inclusion List format](https://github.com/PEDSnet/Data_Models/blob/master/PEDSnet/docs/COVID-19%20Cohort.md#initial-patient-list-due-april-3rd-2020). We have included it below for reference.

When making a note of the inclusion criterion met please use the following valueset:

<ul>
<li>COVID-19 Diagnosis</li>
<li>COVID-19 Test Positive</li>
<li>COVID-19 Test Negative</li>
<li>COVID-19 Test Result Unknown</li>
<li>COVID-19 Test Serology Positive</li>
<li>COVID-19 Test Serology Negative</li>
<li>COVID-19 Test Serology Result Unknown</li>
<li>COVID-19 Vaccination</li>
<li>HCW-COVID-19 Test Positive</li>
<li>HCW-COVID-19 Test Negative</li>
<li>HCW-COVID-19 Test Result Unknown</li>
<li>HCW-COVID-19 Test Serology Positive</li>
<li>HCW-COVID-19 Test Serology Negative</li>
<li>HCW-COVID-19 Test Serology Result Unknown</li>
<li>HCW-COVID-19 Vaccination</li>
<li>Visit with Diagnosis List Code</li></ul>

Additional Notes:
- For patients meeting multiple criteria, include multiple rows.
- If you are unable to determine a positive or negative result for the COVID-19 test, use the `COVID-19 Test Result Unknown` criterion.

Please see the example below for formatting guidelines:

person_id|inclusion_criterion
---|---
1234|COVID-19 Diagnosis
1234|COVID-19 Test Positive
2345|COVID-19 Test Negative
2345|COVID-19 Vaccination
6789|COVID-19 Test Result Unknown
9020|Visit with Diagnosis List Code
1294|HCW-COVID-19 Test Positive
2325|HCW-COVID-19 Test Negative
2325|HCW-COVID-19 Vaccination
6749|HCW-COVID-19 Test Result Unknown
