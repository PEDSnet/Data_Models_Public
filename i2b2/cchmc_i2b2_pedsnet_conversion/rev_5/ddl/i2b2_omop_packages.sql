--=============================================================================
--
-- NAME
--
-- i2b2_omop_packages.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 02/06/2015
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION:
-- For this release did following changes:
-- Added logic for to load data DRGs (Diagnosis Related Groups)[CMSDRG, MSDRG]
-- codes from I2B2ETL schema into OBSERVATION table.
--
-- Under OMOP_ETL schema run below package body script:
-- I2B2_TO_OMOP_VITALS_PKG: This package loads data of 
-- (Vitals (BP,WT,HT) and DRGs(CMSDRG, MSDRG)) codes data from I2B2ETL schema into 
-- OBSERVATION table.
--
--=============================================================================
SET DEFINE OFF;
CREATE OR REPLACE PACKAGE BODY OMOP_ETL."I2B2_TO_OMOP_VITALS_PKG"
AS


  -- ==============================================================
  -- PROCEDURE: sp_Initialize
  -- ==============================================================

    PROCEDURE sp_Initialize
    AS

    BEGIN

      ----------------------------------------------------------------
      -- Init Process Variables
      ----------------------------------------------------------------

        -- Init ProcessID Variable
        g_Process_ID := I2B2_TO_OMOP_ETL_PKG.g_Process_ID;

        -- Init Procedure Specific Variables
        g_Process_Name := NULL;
        g_Process_Start_Date := SYSDATE;
        g_Process_End_Date := NULL;
        g_Is_Successful_txt := NULL;
        g_Row_Count := 0;
        g_ErrorRow_Count := 0;

    ----------------------------------------------------------------
    -- Init Error Variables
    ----------------------------------------------------------------

        -- Init ServerName
        SELECT sys_context('USERENV','SERVER_HOST') INTO g_Err_ServerName FROM dual;
        -- Init DatabaseName
        SELECT sys_context('USERENV','INSTANCE_NAME') INTO g_Err_DatabaseName FROM dual;
        -- Init PackageName
        g_Err_Package := $$PLSQL_UNIT;
        -- Init User
        SELECT sys_context('USERENV','OS_USER') INTO g_Err_User FROM dual;
        -- Init HostName
        SELECT sys_context('USERENV','HOST') INTO g_Err_Host FROM dual;

    END sp_Initialize;


  -- ==============================================================
  -- FUNCTION: sf_I2B2_Vitals_Table_Blk
  -- ==============================================================

   FUNCTION sf_I2B2_Vitals_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
        RETURN t_I2B2_Table PIPELINED
        PARALLEL_ENABLE(PARTITION i_I2B2_Table_cur BY ANY)

   IS

      -- Declare instance of cursor return row
      v_I2B2_Table_cur         i_I2B2_Table_cur%ROWTYPE;

      -- Declare type and instance of table to hold bulk collect return rows
      TYPE Data_Input_Set IS TABLE OF t_I2B2_Row;
      vcol_Data_Input_Set Data_Input_Set;
      v_output_record t_I2B2_Row;

      BEGIN
        LOOP

            -- Bulk collect rows in collection instance
            FETCH i_I2B2_Table_cur
            BULK COLLECT INTO vcol_Data_Input_Set
            LIMIT 20000;

            -- Interate through bulk collection instance
            FOR i IN 1 .. vcol_Data_Input_Set.COUNT
            LOOP

              -- Pipe current row
              v_I2B2_Table_cur  := vcol_Data_Input_Set(i);
              PIPE ROW (v_I2B2_Table_cur);

            END LOOP;


        EXIT WHEN vcol_Data_Input_Set.COUNT < 20000;
        END LOOP;
        CLOSE i_I2B2_Table_cur;

        RETURN;
      END sf_I2B2_Vitals_Table_Blk;


  -- ==============================================================
  -- PROCEDURE: sp_Load_Data
  -- ==============================================================

   PROCEDURE sp_Load_Data(Is_Successful OUT NUMBER)
   AS

   BEGIN


      ----------------------------------------------------------------
      -- Initialize Process
      ----------------------------------------------------------------

        g_Err_Procedure := 'sp_Load_Data';
        g_Err_Comment := 'Initialize Process';
        Is_Successful := 0;
        sp_Initialize;


      ----------------------------------------------------------------
      -- Execute Load Vitals Table Process
      ----------------------------------------------------------------

        g_Err_Comment := 'Execute Load Vitals Table Process';
        sp_Load_Vitals_Tbl(Is_Successful);

        COMMIT;
        dbms_output.put_line('I2B2_TO_Vitals_PKG ' || Is_Successful);

    ----------------------------------------------------------------
    -- Exception Error Handling
    ----------------------------------------------------------------

    EXCEPTION
      WHEN OTHERS
      THEN

        -- Get Error Variables
        Is_Successful := -1;
        g_Is_Successful_txt := 'FALSE';
        g_Process_End_Date := SYSTIMESTAMP;
        g_Err_Num := SQLCODE;
        g_Err_Msg := SQLERRM;
        g_Err_Line := $$plsql_line;

        -- Log Error
        INSERT INTO OMOP_ERROR_LOG
          (
            ERROR_PROCESS_ID,
            ERROR_LOGTIME,
            ERROR_SERVERNAME,
            ERROR_DATABASENAME,
            ERROR_PACKAGE,
            ERROR_PROCEDURE,
            ERROR_NUMBER,
            ERROR_LINE,
            ERROR_MESSAGE,
            ERROR_COMMENT,
            ERROR_USER,
            ERROR_HOST
          )
        SELECT
          g_Process_ID              ERROR_PROCESS_ID,
          g_Process_Start_Date      ERROR_LOGTIME,
          g_Err_ServerName          ERROR_SERVERNAME,
          g_Err_DatabaseName        ERROR_DATABASENAME,
          g_Err_Package             ERROR_PACKAGE,
          g_Err_Procedure           ERROR_PROCEDURE,
          g_Err_Num                 ERROR_NUMBER,
          g_Err_Line                ERROR_LINE,
          g_Err_Msg                 ERROR_MESSAGE,
          g_Err_Comment             ERROR_COMMENT,
          g_Err_User                ERROR_USER,
          g_Err_Host                ERROR_HOST
        FROM dual;

        -- Log process in OMOP_PROCESS_LOG
        INSERT INTO OMOP_PROCESS_LOG(
          PROCESS_ID,
          PROCESS_NAME,
          START_DATE,
          END_DATE,
          IS_SUCCESSFUL,
          LOAD_CNT,
          ERROR_CNT)
        VALUES(
          g_Process_ID,
          g_Process_Name,
          g_Process_Start_Date,
          g_Process_End_Date,
          g_Is_Successful_txt,
          g_Row_Count,
          g_ErrorRow_Count);

    COMMIT;

   END sp_Load_Data;


  -- ==============================================================
  -- PROCEDURE: sp_Load_Vitals_Tbl
  -- ==============================================================

   PROCEDURE sp_Load_Vitals_Tbl(Is_Successful OUT NUMBER)
   AS

    BEGIN

      ----------------------------------------------------------------
      -- Initialize Procedure
      ----------------------------------------------------------------

        g_Err_Comment := 'Initialize Procedure';
        g_Process_Name := 'I2B2 To Vitals Table';
        g_Err_Procedure := 'sp_Load_Vitals_Tbl';
        Is_Successful := 0;


        ----------------------------------------------------------------
        -- Load OMOP Vitals Table
        ----------------------------------------------------------------

            g_Err_Comment := 'Load OMOP Observation Table';

            BEGIN

              INSERT /*+parallel append */
              INTO OBSERVATION
                (
                  OBSERVATION_ID,
                  PERSON_ID,
                  OBSERVATION_CONCEPT_ID,
                  OBSERVATION_DATE,
                  OBSERVATION_TIME,
                  VALUE_AS_NUMBER,
                  VALUE_AS_STRING,
                  VALUE_AS_CONCEPT_ID,
                  UNIT_CONCEPT_ID,
             RANGE_LOW,
             RANGE_HIGH,
                  OBSERVATION_TYPE_CONCEPT_ID,
              ASSOCIATED_PROVIDER_ID,
                  VISIT_OCCURRENCE_ID,
             RELEVANT_CONDITION_CONCEPT_ID,
                  OBSERVATION_SOURCE_VALUE,
                  UNITS_SOURCE_VALUE                )
              SELECT
                  OBSERVATION_SEQ.NEXTVAL OBSERVATION_ID,
                  PERSON_ID,
                  OBSERVATION_CONCEPT_ID,
                  OBSERVATION_DATE,
                  OBSERVATION_TIME,
                  VALUE_AS_NUMBER,
                  VALUE_AS_STRING,
                  VALUE_AS_CONCEPT_ID,
                  UNIT_CONCEPT_ID,
             RANGE_LOW,
             RANGE_HIGH,
                  OBSERVATION_TYPE_CONCEPT_ID,
              ASSOCIATED_PROVIDER_ID,
                  VISIT_OCCURRENCE_ID,
             RELEVANT_CONDITION_CONCEPT_ID,
                  OBSERVATION_SOURCE_VALUE,
                  UNITS_SOURCE_VALUE   
              FROM TABLE
                (I2B2_TO_OMOP_VITALS_PKG.sf_I2B2_Vitals_Table_Blk
                  (CURSOR
                    (SELECT     OBF.PATIENT_NUM             PERSON_ID,
            A.DESTINATION_CODE             OBSERVATION_CONCEPT_ID,
            OBF.START_DATE                 OBSERVATION_DATE,
            TO_CHAR(OBF.START_DATE, 'HH24:MI:SS')     OBSERVATION_TIME,
            CASE WHEN OBF.CONCEPT_CD = 'WT' AND OBF.UNITS_CD = 'lbs' THEN
            ROUND((OBF.NVAL_NUM * 0.45359237),2)
            WHEN OBF.CONCEPT_CD = 'HT' AND OBF.UNITS_CD = 'in' THEN
            ROUND((OBF.NVAL_NUM * 2.54),2)
            ELSE OBF.NVAL_NUM
            END                     VALUE_AS_NUMBER,
            OBF.TVAL_CHAR                VALUE_AS_STRING,
            NULL                     VALUE_AS_CONCEPT_ID,
            B.DESTINATION_CODE            UNIT_CONCEPT_ID,
            NULL                    RANGE_LOW,
            NULL                    RANGE_HIGH,
            A.OBSERVATION_TYPE_CODE            OBSERVATION_TYPE_CONCEPT_ID,
            NULL                    ASSOCIATED_PROVIDER_ID,
            OBF.ENCOUNTER_NUM            VISIT_OCCURRENCE_ID,
            NULL                    RELEVANT_CONDITION_CONCEPT_ID,
            OBF.CONCEPT_CD                OBSERVATION_SOURCE_VALUE,
            OBF.UNITS_CD                UNITS_CODE_SOURCE
            FROM I2B2ETL.OBSERVATION_FACT PARTITION (vitals) OBF
            INNER JOIN PERSON PN
               ON OBF.PATIENT_NUM = PN.PERSON_ID
            INNER JOIN OMOP_MAPPING A
                ON  'OBSERVATION' = A.DESTINATION_TABLE
                AND 'OBSERVATION_CONCEPT_ID' = A.DESTINATION_COLUMN
                AND UPPER(NVL(OBF.CONCEPT_CD,'NULL')) = A.SOURCE_VALUE
            INNER JOIN OMOP_MAPPING B
                ON  'OBSERVATION' = B.DESTINATION_TABLE
                AND 'UNIT_CONCEPT_ID' = B.DESTINATION_COLUMN
                AND UPPER(NVL(OBF.UNITS_CD,'NULL')) = B.SOURCE_VALUE
 UNION
 SELECT
 OBF.PATIENT_NUM   PERSON_ID,
 A.DESTINATION_CODE OBSERVATION_CONCEPT_ID,
 OBF.START_DATE OBSERVATION_DATE,
 TO_CHAR(OBF.START_DATE, 'HH24:MI:SS') OBSERVATION_TIME,
 NULL VALUE_AS_NUMBER,
 SUBSTR (OBF.CONCEPT_CD,INSTR (OBF.CONCEPT_CD,':',1,1) + 1) VALUE_AS_STRING,
 OBF.VALUE_AS_CONCEPT_ID,
 NULL   UNIT_CONCEPT_ID,
 NULL   RANGE_LOW,
 NULL   RANGE_HIGH,
 A.OBSERVATION_TYPE_CODE   OBSERVATION_TYPE_CONCEPT_ID,
 NULL   ASSOCIATED_PROVIDER_ID,
 OBF.ENCOUNTER_NUM    VISIT_OCCURRENCE_ID,
 NULL    RELEVANT_CONDITION_CONCEPT_ID,
 OBF.CONCEPT_CD    OBSERVATION_SOURCE_VALUE,
 NULL    UNITS_CODE_SOURCE
FROM (select  aa.encounter_num, aa.patient_num, aa.concept_cd, aa.start_date, cnpt.concept_name, cnpt.concept_code, cnpt.concept_id as value_as_concept_id
from i2b2etl.observation_fact partition (drgs) aa,
concept cnpt
where ltrim(cnpt.concept_code) = ltrim(replace(aa.concept_cd, 'MSDRG:',''))
and aa.concept_cd like 'MS%'
and cnpt.vocabulary_id = 40
and cnpt.concept_class = 'MS-DRG'
and cnpt.invalid_reason is null
union
select aa.encounter_num, aa.patient_num, aa.concept_cd, aa.start_date, cnpt.concept_name, cnpt.concept_code, cnpt.concept_id as value_as_concept_id
from i2b2etl.observation_fact partition (drgs) aa,
concept cnpt
where ltrim(cnpt.concept_code) = ltrim(replace(aa.concept_cd, 'CMSDRG:',''))
and aa.concept_cd like 'CMS%'
and cnpt.vocabulary_id = 40
and cnpt.concept_class = 'DRG'
and cnpt.invalid_reason = 'D') OBF
INNER JOIN PERSON PN
   ON OBF.PATIENT_NUM = PN.PERSON_ID
INNER JOIN OMOP_MAPPING A
  ON 'OBSERVATION' = A.DESTINATION_TABLE
  AND 'OBSERVATION_CONCEPT_ID' = A.DESTINATION_COLUMN
  AND  SUBSTR (OBF.CONCEPT_CD, 1,INSTR (OBF.CONCEPT_CD,':',1,1)-1) = A.SOURCE_VALUE
                    )
                  )
                )
                LOG ERRORS INTO ERR$_OBSERVATION(g_Process_ID)
                REJECT LIMIT UNLIMITED;

              g_Row_Count := g_Row_Count + SQL%ROWCOUNT;
              DBMS_OUTPUT.PUT_LINE('ROW OUTPUT: ' || SQL%ROWCOUNT);
              DBMS_OUTPUT.PUT_LINE('ROW OUTPUT: ' || g_Row_Count);

              COMMIT;

            END;


      ----------------------------------------------------------------
      -- Log Process
      ----------------------------------------------------------------

        g_Err_Comment := 'Log Process';
        g_Process_End_Date := SYSTIMESTAMP;

        -- Get error count, success variables
        WITH CTE_ERRORS
        AS
          (
            SELECT NVL(
              (
                SELECT
                  COUNT(*) ERROR_ROW_CNT
                FROM ERR$_OBSERVATION
                WHERE (ORA_ERR_TAG$ = g_Process_ID)
                GROUP BY
                  ORA_ERR_TAG$
              )
              ,0) ERROR_ROW_CNT
                FROM DUAL
          )
        SELECT
            CASE
            WHEN ERROR_ROW_CNT > 0
              THEN 'FALSE'
            ELSE 'TRUE'
            END                         IS_SUCCESSFUL_TXT,
            ERROR_ROW_CNT               ERROR_ROW_CNT
        INTO g_Is_Successful_txt, g_ErrorRow_Count
        FROM CTE_ERRORS;

        -- Log process in OMOP_PROCESS_LOG
        INSERT INTO OMOP_PROCESS_LOG(
          PROCESS_ID,
          PROCESS_NAME,
          START_DATE,
          END_DATE,
          IS_SUCCESSFUL,
          LOAD_CNT,
          ERROR_CNT)
        VALUES(
          g_Process_ID,
          g_Process_Name,
          g_Process_Start_Date,
          g_Process_End_Date,
          g_Is_Successful_txt,
          g_Row_Count,
          g_ErrorRow_Count);

      COMMIT;


    ----------------------------------------------------------------
    -- Exception Error Handling
    ---------------------------------------------------------------

    EXCEPTION
      WHEN OTHERS
      THEN

        -- Get Error Variables
        Is_Successful := -1;
        g_Is_Successful_txt := 'FALSE';
        g_Process_End_Date := SYSTIMESTAMP;
        g_Err_Num := SQLCODE;
        g_Err_Msg := SQLERRM;
        g_Err_Line := $$plsql_line;


        -- Log Error
        INSERT INTO OMOP_ERROR_LOG
          (
            ERROR_PROCESS_ID,
            ERROR_LOGTIME,
            ERROR_SERVERNAME,
            ERROR_DATABASENAME,
            ERROR_PACKAGE,
            ERROR_PROCEDURE,
            ERROR_NUMBER,
            ERROR_LINE,
            ERROR_MESSAGE,
            ERROR_COMMENT,
            ERROR_USER,
            ERROR_HOST
          )
        SELECT
          g_Process_ID              ERROR_PROCESS_ID,
          g_Process_Start_Date      ERROR_LOGTIME,
          g_Err_ServerName          ERROR_SERVERNAME,
          g_Err_DatabaseName        ERROR_DATABASENAME,
          g_Err_Package             ERROR_PACKAGE,
          g_Err_Procedure           ERROR_PROCEDURE,
          g_Err_Num                 ERROR_NUMBER,
          g_Err_Line                ERROR_LINE,
          g_Err_Msg                 ERROR_MESSAGE,
          g_Err_Comment             ERROR_COMMENT,
          g_Err_User                ERROR_USER,
          g_Err_Host                ERROR_HOST
        FROM dual;

        ----------------------------------------------------------------
        -- Log Process In Error
        ----------------------------------------------------------------

          g_Err_Comment := 'Log Process In Error';

          -- Get error count, success variables
          WITH CTE_ERRORS
          AS
            (
              SELECT NVL(
                (
                  SELECT
                    COUNT(*) ERROR_ROW_CNT
                  FROM ERR$_OBSERVATION
                  WHERE (ORA_ERR_TAG$ = g_Process_ID)
                  GROUP BY
                    ORA_ERR_TAG$
                )
                ,0) ERROR_ROW_CNT
                  FROM DUAL
            )
          SELECT
              'FALSE'                     IS_SUCCESSFUL_TXT,
              ERROR_ROW_CNT               ERROR_ROW_CNT
          INTO g_Is_Successful_txt, g_ErrorRow_Count
          FROM CTE_ERRORS;

          -- Log process in OMOP_PROCESS_LOG
          INSERT INTO OMOP_PROCESS_LOG(
            PROCESS_ID,
            PROCESS_NAME,
            START_DATE,
            END_DATE,
            IS_SUCCESSFUL,
            LOAD_CNT,
            ERROR_CNT)
          VALUES(
            g_Process_ID,
            g_Process_Name,
            g_Process_Start_Date,
            g_Process_End_Date,
            g_Is_Successful_txt,
            g_Row_Count,
            g_ErrorRow_Count);

    COMMIT;
    dbms_output.put_line('I2B2_TO_Vitals_PKG ' || Is_Successful);

    END sp_Load_Vitals_Tbl;
END I2B2_TO_OMOP_VITALS_PKG;
/

