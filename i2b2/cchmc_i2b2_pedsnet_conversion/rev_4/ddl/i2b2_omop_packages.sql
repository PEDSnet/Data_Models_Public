--=============================================================================
--
-- NAME
--
-- i2b2_omop_packages.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 12/31/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION:
-- For this release did following changes:
-- Added logic for to load data HCPCS procedure codes from I2B2ETL schema
-- into PROCEDURE_OCCURRENCE table.
--
-- Under OMOP_ETL schema run below package body script:
-- I2B2_TO_OMOP_PROCS_PKG: This package loads data of (CPT-4 (C4) and HCPCS) 
-- procedure codes from I2B2ETL schema into PROCEDURE_OCCURRENCE table.
--
--=============================================================================
CREATE OR REPLACE PACKAGE BODY "I2B2_TO_OMOP_PROCS_PKG" 
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
  -- FUNCTION: sf_I2B2_PROCS_Table_Blk
  -- ==============================================================
   
   FUNCTION sf_I2B2_PROCS_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
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
      END sf_I2B2_PROCS_Table_Blk;
    
 
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
      -- Execute Load PROCS Table Process
      ----------------------------------------------------------------
          
        g_Err_Comment := 'Execute Load PROCS Table Process';
        sp_Load_PROCS_Tbl(Is_Successful);
        
        COMMIT;
        dbms_output.put_line('I2B2_TO_PROCS_PKG ' || Is_Successful);

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
  -- PROCEDURE: sp_Load_PROCS_Tbl
  -- ==============================================================

   PROCEDURE sp_Load_PROCS_Tbl(Is_Successful OUT NUMBER)
   AS
  
    BEGIN
            
      ----------------------------------------------------------------
      -- Initialize Procedure
      ----------------------------------------------------------------
        
        g_Err_Comment := 'Initialize Procedure';
        g_Process_Name := 'I2B2 To PROCS Table';
        g_Err_Procedure := 'sp_Load_PROCS_Tbl';
        Is_Successful := 0;
        
   
        ----------------------------------------------------------------
        -- Load OMOP PROCS Table
        ----------------------------------------------------------------
                    
          ----------------------------------------------------------------
          -- Load OMOP Procedure_Occurrence Table
          ----------------------------------------------------------------
           
            g_Err_Comment := 'Load OMOP Procedure_Occurrence Table';
             
            BEGIN
              
              INSERT /*+parallel append */
              INTO PROCEDURE_OCCURRENCE
               (
                PROCEDURE_OCCURRENCE_ID,
                PERSON_ID,
                PROCEDURE_CONCEPT_ID,
                PROCEDURE_DATE,
                PROCEDURE_TYPE_CONCEPT_ID,
                ASSOCIATED_PROVIDER_ID,
                VISIT_OCCURRENCE_ID,
                RELEVANT_CONDITION_CONCEPT_ID,
                PROCEDURE_SOURCE_VALUE
             ) 
             SELECT 
                 PROCEDURE_OCCUR_SEQ.NEXTVAL  PROCEDURE_OCCURRENCE_ID,
                 PERSON_ID,
               PROCEDURE_CONCEPT_ID,
               PROCEDURE_DATE,
               PROCEDURE_TYPE_CONCEPT_ID,
               ASSOCIATED_PROVIDER_ID,
               VISIT_OCCURRENCE_ID,
               RELEVANT_CONDITION_CONCEPT_ID,
                   PROCEDURE_SOURCE_VALUE
             FROM TABLE 
                (I2B2_TO_OMOP_PROCS_PKG.sf_I2B2_PROCS_Table_Blk
                  (CURSOR 
                    (
       SELECT 
              OBF.PATIENT_NUM                    PERSON_ID,
              CNPT.CONCEPT_ID                 PROCEDURE_CONCEPT_ID,   
              OBF.START_DATE                  PROCEDURE_DATE,
              A.DESTINATION_CODE              PROCEDURE_TYPE_CONCEPT_ID,
              NULL                            ASSOCIATED_PROVIDER_ID,
              OBF.ENCOUNTER_NUM               VISIT_OCCURRENCE_ID,
              NULL                            RELEVANT_CONDITION_CONCEPT_ID,
              OBF.CONCEPT_CD                  PROCEDURE_SOURCE_VALUE
          FROM I2B2ETL.OBSERVATION_FACT PARTITION (PROCS) OBF
           INNER JOIN PERSON PN
               ON OBF.PATIENT_NUM = PN.PERSON_ID
           INNER JOIN CONCEPT CNPT
              ON OBF.CONCEPT_CD  = 'CPT:' || CNPT.CONCEPT_CODE
           INNER JOIN OMOP_MAPPING A
              ON  'PROCEDURE_OCCURRENCE' = A.DESTINATION_TABLE
              AND 'PROCEDURE_TYPE_CONCEPT_ID' = A.DESTINATION_COLUMN
              AND 'CPT-4' = A.DESTINATION_VALUE
              AND OBF.MODIFIER_CD = A.SOURCE_VALUE
          WHERE 
              OBF.MODIFIER_CD IN ('ORIGPX:MAPPED')
          AND CNPT.vocabulary_id = 4 -- CPT-4
       UNION
       SELECT 
              OBF.PATIENT_NUM                 PERSON_ID,
              CNPT.CONCEPT_ID                 PROCEDURE_CONCEPT_ID,   
              OBF.START_DATE                  PROCEDURE_DATE,
              A.DESTINATION_CODE              PROCEDURE_TYPE_CONCEPT_ID,
              NULL                            ASSOCIATED_PROVIDER_ID,
              OBF.ENCOUNTER_NUM               VISIT_OCCURRENCE_ID,
              NULL                            RELEVANT_CONDITION_CONCEPT_ID,
              OBF.CONCEPT_CD                  PROCEDURE_SOURCE_VALUE
          FROM I2B2ETL.OBSERVATION_FACT PARTITION (PROCS) OBF
           INNER JOIN PERSON PN
               ON OBF.PATIENT_NUM = PN.PERSON_ID
           INNER JOIN CONCEPT CNPT
              ON OBF.CONCEPT_CD  = 'HCPCS:' || CNPT.CONCEPT_CODE
           INNER JOIN OMOP_MAPPING A
              ON  'PROCEDURE_OCCURRENCE' = A.DESTINATION_TABLE
              AND 'PROCEDURE_TYPE_CONCEPT_ID' = A.DESTINATION_COLUMN
              AND 'HCPCS' = A.DESTINATION_VALUE
              AND OBF.MODIFIER_CD = A.SOURCE_VALUE
          WHERE 
              OBF.MODIFIER_CD IN ('ORIGPX:MAPPED')
          AND CNPT.vocabulary_id = 5 --HCPCS
           )
                  )
                )
                LOG ERRORS INTO ERR$_PROCEDURE_OCCURRENCE(g_Process_ID)
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
                FROM ERR$_PROCEDURE_OCCURRENCE
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
                  FROM ERR$_PROCEDURE_OCCURRENCE
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
    dbms_output.put_line('I2B2_TO_PROCS_PKG ' || Is_Successful);
    
    END sp_Load_PROCS_Tbl; 
END I2B2_TO_OMOP_PROCS_PKG;
/
