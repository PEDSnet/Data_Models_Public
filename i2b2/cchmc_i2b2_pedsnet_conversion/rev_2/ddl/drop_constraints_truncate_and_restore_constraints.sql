--STEP 1: Drop constraints
SELECT 'alter table '||table_name||' disable constraint '||constraint_name||' cascade;' sqlstatement
            FROM USER_CONSTRAINTS
            WHERE table_name IN
                (
                  'CONCEPT',
                  'CONCEPT_ANCESTOR',
                  'CONCEPT_RELATIONSHIP',
                  'CONCEPT_SYNONYM',
                  'DRUG_APPROVAL',
                  'DRUG_STRENGTH',
                  'RELATIONSHIP',
                  'SOURCE_TO_CONCEPT_MAP',
                  'VOCABULARY'
                )
            ORDER BY 
              constraint_type,
              table_name; 

--STEP 2: Truncate tables use query below for to truncate tables
TRUNCATE TABLE VOCABULARY
/
TRUNCATE TABLE CONCEPT
/
TRUNCATE TABLE RELATIONSHIP
/
TRUNCATE TABLE SOURCE_TO_CONCEPT_MAP
/
TRUNCATE TABLE CONCEPT_ANCESTOR
/
TRUNCATE TABLE DRUG_APPROVAL
/
TRUNCATE TABLE DRUG_STRENGTH
/
TRUNCATE TABLE CONCEPT_RELATIONSHIP
/
TRUNCATE TABLE CONCEPT_SYNONYM
/

--STEP 3: ENABLE CONSTRAINTS use query below to enable constraints
  SELECT 'alter table '||table_name||' enable constraint '||constraint_name ||';' sqlstatement
            FROM USER_CONSTRAINTS
WHERE table_name IN
                (
                  'CONCEPT',
                  'CONCEPT_ANCESTOR',
                  'CONCEPT_RELATIONSHIP',
                  'CONCEPT_SYNONYM',
                  'DRUG_APPROVAL',
                  'DRUG_STRENGTH',
                  'RELATIONSHIP',
                  'SOURCE_TO_CONCEPT_MAP',
                  'VOCABULARY'
                )
            ORDER BY 
              constraint_type,
              table_name;
