=======
-- Person -> Demographic WITHOUT Biobank_flag
insert into pcornet.demographic (patid, birth_date, birth_time, sex, hispanic, race, biobank_flag, raw_sex, raw_hispanic, raw_race)
select distinct 
	cast(p.person_id as text) as pat_id,
	cast(year_of_birth as text)||(case when month_of_birth is null OR day_of_birth is null then '' else '-'||lpad(cast(month_of_birth as text),2,'0')||'-'||lpad(cast(day_of_birth as text),2,'0') end) as birth_date,	
	null as birth_time,
	coalesce (m1.target_concept,'OT') as Sex,
	coalesce (m2.target_concept,'OT') as Hispanic,
	coalesce (m3.target_concept,'OT') as Race,
	null,
	gender_source_value,
	ethnicity_source_value,
	race_source_value
from
	omop.person p
	left join cz.cz_omop_pcornet_concept_map m1 on case when p.gender_concept_id is null AND m1.source_concept_id is null then true else p.gender_concept_id = m1.source_concept_id end and m1.source_concept_class='Gender'
	left join cz.cz_omop_pcornet_concept_map m2 on case when p.ethnicity_concept_id is null AND m2.source_concept_id is null then true else p.ethnicity_concept_id = m2.source_concept_id end and m2.source_concept_class='Hispanic'
	left join cz.cz_omop_pcornet_concept_map m3 on case when p.race_concept_id is null AND m3.source_concept_id is null then true else p.race_concept_id = m3.source_concept_id end and m3.source_concept_class = 'Race';
>>>>>>> FETCH_HEAD

-- Person -> Demographic WITH Biobank_flag
insert into pcornet.demographic (patid, birth_date, birth_time, sex, hispanic, race, biobank_flag, raw_sex, raw_hispanic, raw_race)
select distinct 
	cast(p.person_id as text) as pat_id,
	cast(year_of_birth as text)||(case when month_of_birth is null OR day_of_birth is null then '' else '-'||lpad(cast(month_of_birth as text),2,'0')||'-'||lpad(cast(day_of_birth as text),2,'0') end) as birth_date,	
	pn_birth_time as birth_time,
	coalesce (m1.target_concept,'OT') as Sex,
	coalesce (m2.target_concept,'OT') as Hispanic,
	coalesce (m3.target_concept,'OT') as Race,
	coalesce (m4.target_concept,'OT') as Biobank_flag,
	gender_source_value,
	ethnicity_source_value,
	race_source_value
from
	omop.person p
	left join omop.observation o on p.person_id = o.person_id and observation_concept_id = 4001345
	left join cz.cz_omop_pcornet_concept_map m1 on case when p.gender_concept_id is null AND m1.source_concept_id is null then true else p.gender_concept_id = m1.source_concept_id end and m1.source_concept_class='Gender'
	left join cz.cz_omop_pcornet_concept_map m2 on case when p.ethnicity_concept_id is null AND m2.source_concept_id is null then true else p.ethnicity_concept_id = m2.source_concept_id end and m2.source_concept_class='Hispanic'
	left join cz.cz_omop_pcornet_concept_map m3 on case when p.race_concept_id is null AND m3.source_concept_id is null then true else p.race_concept_id = m3.source_concept_id end and m3.source_concept_class = 'Race'
	left join cz.cz_omop_pcornet_concept_map m4 on case when o.value_as_concept_id is null AND m4.value_as_concept_id is null then true else o.value_as_concept_id=m4.value_as_concept_id end and m4.source_concept_class = 'Biobank flag'

-- Observation_period -> Enrollment
insert into pcornet.enrollment (patid, enr_start_date, enr_end_date, chart, enr_basis)
select distinct 
	cast(op.person_id as text) as pat_id,
	cast(date_part('year', observation_period_start_date) as text)||'-'||lpad(cast(date_part('month', observation_period_start_date) as text),2,'0')||'-'||lpad(cast(date_part('day', observation_period_start_date) as text),2,'0') as enr_start_date,
	cast(date_part('year', observation_period_end_date) as text)||'-'||lpad(cast(date_part('month', observation_period_end_date) as text),2,'0')||'-'||lpad(cast(date_part('day', observation_period_end_date) as text),2,'0') as enr_end_date,
	coalesce(m1.target_concept,'OT') as chart_avaiability,
	'E' as ENR_basis
from
	omop.observation_period op
	left join omop.observation o on op.person_id = o.person_id and observation_concept_id = 4030450
	left join cz.cz_omop_pcornet_concept_map m1 on case when o.value_as_concept_id is null AND m1.value_as_concept_id is null then true else o.value_as_concept_id = m1.value_as_concept_id end and m1.source_concept_class = 'Chart availability'

-- Visit occurrence -> encounter
insert into pcornet.encounter (
            patid, encounterid, admit_date, admit_time, discharge_date, discharge_time, 
            providerid, facility_location, enc_type, facilityid, discharge_disposition, 
            discharge_status, drg, drg_type, admitting_source, raw_enc_type, 
            raw_discharge_disposition, raw_discharge_status, raw_drg_type, 
            raw_admitting_source)
select distinct 
	cast(v.person_id as text) as pat_id,
	cast(v.visit_occurrence_id as text) as encounterid,
	cast(date_part('year', visit_start_date) as text)||'-'||lpad(cast(date_part('month', visit_start_date) as text),2,'0')||'-'||lpad(cast(date_part('day', visit_start_date) as text),2,'0') as admit_date,
	null as admit_time,
	cast(date_part('year', visit_end_date) as text)||'-'||lpad(cast(date_part('month', visit_end_date) as text),2,'0')||'-'||lpad(cast(date_part('day', visit_end_date) as text),2,'0') as discharge_date,
	null as discharge_time,
	v.provider_id as providerid,
	left(l.zip,3) as facility_location,
	coalesce(m1.target_concept,'OT') as enc_type,
	v.care_site_id as facilityid,
	coalesce(m2.target_concept,'OT') as discharge_disposition,
	coalesce(m3.target_concept,'OT') as discharge_status,
	--case when coalesce(m1.target_concept,'OT') in ('AV','OA') then null else case when o2.observation_source_value~'^[0-9]{0,3}$' then lpad(o2.observation_source_value,3,'0') else 'OT' end end as drg,
	--case when coalesce(m1.target_concept,'OT') in ('AV','OA') then null else case when visit_start_date<'2007-10-01' then '01' else '02' end end as drg_type,
	--case when drg.concept_id is null then 'OT' else drg.concept_code end as drg,
	case when coalesce(m1.target_concept,'OT') in ('AV','OA') then null else o2.value_as_string end as drg,
	case when coalesce(m1.target_concept,'OT') in ('AV','OA') then null else case when visit_start_date<'2007-10-01' then '01' else '02' end end as drg_type,
	coalesce(m4.target_concept,'OT') as admitting_source,
	v.place_of_service_concept_id as raw_enc_type,
	o1.value_as_concept_id as raw_discharge_disposition,
	o3.value_as_concept_id as raw_discharge_status,
	null as raw_drg_type,
	o4.value_as_concept_id as raw_admitting_source
from
	omop.visit_occurrence v
	--left join omop.person p on v.person_id = p.person_id
	left join omop.care_site c on v.care_site_id = c.care_site_id
	left join omop.location l on c.location_id = l.location_id
	left join omop.observation o1 on v.person_id = o1.person_id and o1.observation_concept_id = 44813951
	left join omop.observation o2 on v.person_id = o2.person_id and o2.observation_concept_id = 3040464
	--left join omop.observation drg on drg.concept_id = o2.value_as_concept_id
	left join omop.observation o3 on v.person_id = o3.person_id and o3.observation_concept_id = 4137274
	left join omop.observation o4 on v.person_id = o4.person_id and o4.observation_concept_id = 4145666
	left join cz.cz_omop_pcornet_concept_map m1 on case when v.place_of_service_concept_id is null AND m1.source_concept_id is null then true else v.place_of_service_concept_id = m1.source_concept_id end and m1.source_concept_class='Encounter type'
	left join cz.cz_omop_pcornet_concept_map m2 on case when o1.value_as_concept_id is null AND m2.value_as_concept_id is null then true else o1.value_as_concept_id = m2.value_as_concept_id end and m2.source_concept_class='Discharge disposition'
	left join cz.cz_omop_pcornet_concept_map m3 on case when o3.value_as_concept_id is null AND m3.value_as_concept_id is null then true else o3.value_as_concept_id = m3.value_as_concept_id end and m3.source_concept_class='Discharge status'
	left join cz.cz_omop_pcornet_concept_map m4 on case when o4.value_as_concept_id is null AND m4.value_as_concept_id is null then true else o4.value_as_concept_id = m4.value_as_concept_id end and m4.source_concept_class='Admitting source'

-- condition_occurrence --> Diagnosis
insert into pcornet.diagnosis(
            patid, encounterid, enc_type, admit_date, providerid, dx, dx_type, 
            dx_source, pdx, raw_dx, raw_dx_type, raw_dx_source, raw_pdx)
select distinct 
	cast(person_id as text) as patid,
	cast(visit_occurrence_id as text) encounterid,
	enc.enc_type,
	enc.admit_date,
	enc.providerid,
	c.concept_code as dx,
	'SM' as dx_type,
	null as dx_source,
	null as pdx,
	null as raw_dx,
	null as raw_dx_type,
	null as raw_dx_source,
	null as raw_pdx
from
	omop.condition_occurrence co
	join pcornet.encounter enc on cast(co.visit_occurrence_id as text)=enc.encounterid
	join rz.concept c on co.condition_concept_id=c.concept_id; 

-- procedure_occurrence -> procedure
insert into pcornet.procedure(
            patid, encounterid, enc_type, admit_date, providerid, px, px_type, 
            raw_px, raw_px_type)
select distinct 
	cast(person_id as text) as patid,
	cast(visit_occurrence_id as text) as encounterid,
	enc.enc_type,
	enc.admit_date,
	enc.providerid,
	c.concept_code as px,
	'SM' as px_type,
	null as raw_px,
	null as raw_px_type
from
	omop.procedure_occurrence po
	join pcornet.encounter enc on cast(po.visit_occurrence_id as text)=enc.encounterid
	join rz.concept c on po.procedure_concept_id=c.concept_id;

-- observation --> vital WITHOUT Observation time
insert into pcornet.vital(
            patid, encounterid, measure_date, measure_time, vital_source, 
            ht, wt, diastolic, systolic, original_bmi, bp_position, raw_vital_source, 
            raw_diastolic, raw_systolic, raw_bp_position)
select distinct 
	cast(ob.person_id as text) as patid,
	cast(ob.visit_occurrence_id as text) as encounterid,
	cast(date_part('year', ob.observation_date) as text)||'-'||lpad(cast(date_part('month', ob.observation_date) as text),2,'0')||'-'||lpad(cast(date_part('day', ob.observation_date) as text),2,'0') as measure_date,
	lpad(cast(date_part('hour', ob.observation_time) as text),2,'0')||':'||lpad(cast(date_part('minute', ob.observation_time) as text),2,'0') as measure_time,
	null as vital_source,
	ob_ht.value_as_number as ht,
	ob_wt.value_as_number as wt,
	ob_dia.value_as_number as diastolic,
	ob_sys.value_as_number as systolic,
	ob_bmi.value_as_number as original_bmi,
	coalesce(ob_bp.target_concept,'OT') as bp_position,
	null as raw_vital_source,
	null as raw_diastolic,
	null as raw_systolic,
	null as raw_bp_position
from
	omop.observation ob 
	left join omop.observation ob_ht on ob.visit_occurrence_id = ob_ht.visit_occurrence_id 
		and ob.observation_date = ob_ht.observation_date and ob_ht.observation_concept_id='3023540'
	left join omop.observation ob_wt on ob.visit_occurrence_id = ob_wt.visit_occurrence_id 
		and ob.observation_date = ob_wt.observation_date and ob_wt.observation_concept_id='3013762'
	left join omop.observation ob_sys on ob.visit_occurrence_id = ob_sys.visit_occurrence_id 
		and ob.observation_date = ob_sys.observation_date and ob_sys.observation_concept_id IN ('3018586','3035856','3009395','3004249')
	left join omop.observation ob_dia on ob.visit_occurrence_id = ob_dia.visit_occurrence_id 
		and ob_sys.value_as_concept_id = ob_dia.value_as_concept_id and ob_dia.observation_concept_id IN ('3034703','3019962','3013940','3012888') 
	left join omop.observation ob_bmi on ob.visit_occurrence_id = ob_bmi.visit_occurrence_id 
		and ob.observation_date = ob_bmi.observation_date and ob_bmi.observation_concept_id='3038553'
	left join 
	(select distinct visit_occurrence_id, observation_date, observation_time, target_concept, ob_sub.value_as_string from 
	omop.observation ob_sub inner join cz.cz_omop_pcornet_concept_map m on ob_sub.observation_concept_id = m.source_concept_id AND m.source_concept_class='BP Position') ob_bp
	on ob.visit_occurrence_id = ob_bp.visit_occurrence_id AND trim(ob_bp.value_as_concept_id) = trim(ob_sys.value_as_concept_id)	
	where ob.observation_concept_id IN ('3023540','3013762','3034703','3019962','3013940','3012888','3018586','3035856','3009395','3004249','3038553')
	AND coalesce(ob_ht.value_as_number, ob_wt.value_as_number, ob_dia.value_as_number, 
	ob_sys.value_as_number, ob_bmi.value_as_number) is not null;

-- observation --> vital WITH Observation time
insert into pcornet.vital(
            patid, encounterid, measure_date, measure_time, vital_source, 
            ht, wt, diastolic, systolic, original_bmi, bp_position, raw_vital_source, 
            raw_diastolic, raw_systolic, raw_bp_position)
select distinct 
	cast(ob.person_id as text) as patid,
	cast(ob.visit_occurrence_id as text) as encounterid,
	cast(date_part('year', ob.observation_date) as text)||'-'||lpad(cast(date_part('month', ob.observation_date) as text),2,'0')||'-'||lpad(cast(date_part('day', ob.observation_date) as text),2,'0') as measure_date,
	lpad(cast(date_part('hour', ob.observation_time) as text),2,'0')||':'||lpad(cast(date_part('minute', ob.observation_time) as text),2,'0') as measure_time,
	null as vital_source,
	ob_ht.value_as_number as ht,
	ob_wt.value_as_number as wt,
	ob_dia.value_as_number as diastolic,
	ob_sys.value_as_number as systolic,
	ob_bmi.value_as_number as original_bmi,
	coalesce(ob_bp.target_concept,'OT') as bp_position,
	null as raw_vital_source,
	null as raw_diastolic,
	null as raw_systolic,
	null as raw_bp_position
from
	omop.observation ob 
	left join omop.observation ob_ht on ob.visit_occurrence_id = ob_ht.visit_occurrence_id 
		and ob.observation_date = ob_ht.observation_date and ob.observation_time = ob_ht.observation_time and ob_ht.observation_concept_id='3023540'
	left join omop.observation ob_wt on ob.visit_occurrence_id = ob_wt.visit_occurrence_id 
		and ob.observation_date = ob_wt.observation_date and ob.observation_time = ob_wt.observation_time and ob_wt.observation_concept_id='3013762'
	left join omop.observation ob_sys on ob.visit_occurrence_id = ob_sys.visit_occurrence_id 
		and ob.observation_date = ob_sys.observation_date and ob.observation_time = ob_sys.observation_time and ob_sys.observation_concept_id IN ('3018586','3035856','3009395','3004249')
	left join omop.observation ob_dia on ob.visit_occurrence_id = ob_dia.visit_occurrence_id 
		and ob_sys.value_as_concept_id = ob_dia.value_as_concept_id and ob_dia.observation_concept_id IN ('3034703','3019962','3013940','3012888') 
	left join omop.observation ob_bmi on ob.visit_occurrence_id = ob_bmi.visit_occurrence_id 
		and ob.observation_date = ob_bmi.observation_date and ob.observation_time = ob_bmi.observation_time and ob_bmi.observation_concept_id='3038553'
	left join 
	(select distinct visit_occurrence_id, observation_date, observation_time, target_concept from 
	omop.observation ob_sub inner join cz.cz_omop_pcornet_concept_map m on ob_sub.observation_concept_id = m.source_concept_id AND m.source_concept_class='BP Position') ob_bp
	on ob.visit_occurrence_id = ob_bp.visit_occurrence_id AND trim(ob_bp.value_as_concept_id) = trim(ob_sys.value_as_concept_id)
	where ob.observation_concept_id IN ('3023540','3013762','3034703','3019962','3013940','3012888','3018586','3035856','3009395','3004249','3038553')
	AND coalesce(ob_ht.value_as_number, ob_wt.value_as_number, ob_dia.value_as_number, 
	ob_sys.value_as_number, ob_bmi.value_as_number) is not null;
