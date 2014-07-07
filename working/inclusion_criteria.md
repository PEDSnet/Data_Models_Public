== Determining person inclusion criteria

The goal of this effort is to reach a common set of criteria for identifying persons
from within the overall populations represented in member institutions' health records
who will be included in the PEDSnet overall dataset.  Principles guiding selection include:

* inclusion of persons who are members of affiliated PPRNs, or PEDSnet-sponsored research studies
* inclusion of persons for whom member institutions hold data that would support meaningful research
* realizing the PCORnet goals of diversity and longitudinal data to the extent possible
* recognizing that it is generally easier to exclude persons in the common dataset from specific analyses or studies than it is to strongly constrain the core dataset

As a rapid way to evaluate the effect of some suggested inclusion criteria, the following test queries have been run:
(**Please note, these are abbreviated queries for estimation only; they're not sufficient to use as actual inclusion criteria**)

Criteria | CHOP Count | Colorado Count | CHOP Clarity Query
--- | --- | --- | ---
All patients known to institution | 2168172 | 1363767 | ```select count(distinct pat_id) from patient```
Patients with at least one "face to face" visit | 1315263 | 868537 | ```select count(distinct pat_id) from pat_enc where enc_type_c in (2, 3, 50, 51, 101, 106, 151, 152, 153, 155, 204)```
Patients with at least one visit that generated an order | 1109733 | 904234 | ```select count(distinct a.pat_id) from (select pat_id from order_med om where coalesce(om.order_status_c,1) not in (4,7) union select pat_id from order_proc op where coalesce(op.order_status_c,1) not in (4,7)) a```
Patients with at least one "face to face" visit 2009 or later | 868783 | 627781 | ```select count(distinct pat_id) from pat_enc where contact_date >= to_date('2009-01-01','YYYY-MM-DD') and enc_type_c in (2, 3, 50, 51, 101, 106, 151, 152, 153, 155, 204)```
Patients with at least two "face to face" visits 2009 or later | 713726 | 468532 | ```select count(distinct a.pat_id) from  (select pat_id, count(pat_enc_csn_id) as visits from pat_enc where contact_date >= to_date('2009-01-01','YYYY-MM-DD') and enc_type_c in (2, 3, 50, 51, 101, 106, 151, 152, 153, 155, 204) group by pat_id) a where a.visits >= 2```
Patients with at least one "face to face" visit 2009 or later that generated an order | 716475 | 459448 | ```select count(distinct a.pat_id) from (select om.pat_id from order_med om inner join pat_enc pe on om.pat_enc_csn_id = pe.pat_enc_csn_id where pe.contact_date >= to_date('2009-01-01','YYYY-MM-DD') and enc_type_c in (2, 3, 50, 51, 101, 106, 151, 152, 153, 155, 204) and coalesce(om.order_status_c,1) not in (4,7) union select op.pat_id from order_proc op inner join pat_enc pe on op.pat_enc_csn_id = pe.pat_enc_csn_id where pe.contact_date >= to_date('2009-01-01','YYYY-MM-DD') and enc_type_c in (2, 3, 50, 51, 101, 106, 151, 152, 153, 155, 204) and coalesce(op.order_status_c,1) not in (4,7)) a```
Patients with at least one "face to face" visit 2009 or later that generated an action (med order or lab result; may not capture imaging) | 622672 | 409768 | ```select count(distinct a.pat_id) from (select om.pat_id from order_med om inner join pat_enc pe on om.pat_enc_csn_id = pe.pat_enc_csn_id where pe.contact_date >= to_date('2009-01-01','YYYY-MM-DD') and enc_type_c in (2, 3, 50, 51, 101, 106, 151, 152, 153, 155, 204) and coalesce(om.order_status_c,1) not in (4,7) union select op.pat_id from order_results op inner join pat_enc pe on op.pat_enc_csn_id = pe.pat_enc_csn_id where pe.contact_date >= to_date('2009-01-01','YYYY-MM-DD') and enc_type_c in (2, 3, 50, 51, 101, 106, 151, 152, 153, 155, 204) and coalesce(op.result_status_c,1) not in (5)) a```

Notes:
* Colorado queries include pedsconnect data
* Encounter types used in reference SQL:
   * 2    Walk-in
   * 3    Hospital Encounter
   * 50   Appointment
   * 51   Surgery
   * 101  Office Visit
   * 106  Hospital
   * 151  Inpatient
   * 152  Outpatient
   * 153  Emergency
   * 155  Confidential Visit
   * 204  Sunday Office Visit
