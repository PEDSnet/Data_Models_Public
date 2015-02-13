--=============================================================================
--
-- NAME
--
-- i2b2_omop_packages.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 12/11/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION:
-- For this release did following changes:
-- A. For below mentioned points #1 to #7 packages had to change the column 
-- length sizes inside package specification of "t_I2B2_Row" types.
-- B. Created new I2B2_TO_OMOP_LOCATION_PKG (LOCATION) package for to load data 
-- from I2B2ETL schema into LOCATION table.
-- C. Inside package body of I2B2_TO_OMOP_ETL_PKG, added execute call package 
-- script of LOCATION package for to load data into LOCATION table first and then
-- load data into other tables in following order (PERSON, VISIT_OCCURRENCE, 
-- OBSERVATION, CONDITION_OCCURRENCE, PROCEDURE_OCCURRENCE, OBSERVATION_PERIOD,
-- CONDITION_ERA and DEATH) through other packages.
--
-- Under OMOP_ETL schema run below packages scripts as mentioned in order below:
-- 1. I2B2_TO_OMOP_PERSON_PKG: This package loads data from I2B2ETL schema into
-- PERSON table.
-- 2. I2B2_TO_OMOP_VISIT_PKG: This package loads data from I2B2ETL schema into 
-- VISIT_OCCURRENCE table.
-- 3. I2B2_TO_OMOP_VITALS_PKG: This package loads data from I2B2ETL schema into
-- OBSERVATION table.
-- 4. I2B2_TO_OMOP_DX_PKG: This package loads data from I2B2ETL schema into
-- CONDITION_OCCURRENCE table.
-- 5. I2B2_TO_OMOP_PROCS_PKG: This package loads data from I2B2ETL schema into
-- PROCEDURE_OCCURRENCE table.
-- 6. I2B2_TO_OMOP_OBSV_PERIOD_PKG: This package loads data from I2B2ETL schema
-- into OBSERVATION_PERIOD table.
-- 7. I2B2_TO_OMOP_DEATH_PKG: This package loads data from I2B2ETL schema into
-- DEATH table.
-- 8. I2B2_TO_OMOP_LOCATION_PKG: This package loads data from I2B2ETL schema into
-- LOCATION table.
-- 9. I2B2_TO_OMOP_ETL_PKG: This package calls the below nine packages for to 
-- load data from I2B2ETL into their corresponding tables (PERSON, VISIT_OCCURRENCE, 
-- OBSERVATION, CONDITION_OCCURRENCE, PROCEDURE_OCCURRENCE, OBSERVATION_PERIOD,
-- CONDITION_ERA , DEATH and LOCATION) and truncates required tables and reloads.
-- Package I2B2_TO_OMOP_ETL_PKG does following in order:
-- a) Get next Process_ID from Log table. Serves as ID for entire run.
-- b) Refresh materialized views and analyzing materialized views.
-- c) Disable primary and foreign keys.
-- d) Truncate tables.
-- e) Disable non-unique indexes.
-- f) Execute ETL packages - one for each i2b2 entity (PERSON, VISIT_OCCURRENCE,
-- OBSERVATION, CONDITION_OCCURRENCE, PROCEDURE_OCCURRENCE, OBSERVATION_PERIOD,
-- CONDITION_ERA, DEATH and LOCATION).Pipe rows, parallel load, redirect errors 
-- to ERR$_[TableName]
-- g) Enable non-unique indexes.
-- h) Enable primary and foreign keys.Redirect errors to Exceptions table, log 
-- in Exceptions_History table.
-- i) Delete rows from primary tables that where logged in Exceptions table.
-- j) Enable constraints after delete (includes primary key index).
-- k) Gather table stats.
-- l) Log ETL times and counts in Log table.
--
--=============================================================================
CREATE OR REPLACE PACKAGE "I2B2_TO_OMOP_PERSON_PKG" 
AS
   
    -- ==============================================================
    -- DECLARE PACKAGE VARIABLES
    -- ==============================================================
   
      -- Process variables
      g_Process_ID                    NUMBER; 
      g_Process_Name                  VARCHAR2 (100);
      g_Process_Start_Date            DATE;
      g_Process_End_Date              DATE;
      g_Row_Count                     NUMBER (12);
      g_ErrorRow_Count                NUMBER (12);
      g_Is_Successful_txt             VARCHAR2 (5);
      
      -- Error variables
      g_Err_ServerName                VARCHAR2 (100);
      g_Err_DatabaseName              VARCHAR2 (100);
      g_Err_Package                   VARCHAR2 (100);
      g_Err_Procedure                 VARCHAR2 (100);
      g_Err_Num                       VARCHAR2 (20);
      g_Err_Line                      NUMBER;
      g_Err_Msg                       VARCHAR2 (1000);
      g_Err_Comment                   VARCHAR2 (1000);
      g_Err_User                      VARCHAR2 (100);
      g_Err_Host                      VARCHAR2 (100);   

    
    -- ==============================================================
    -- DECLARE PACKAGE TYPES
    -- ==============================================================
      
      -- Declare type table to be returned by pipelined function
      TYPE t_I2B2_Table IS TABLE OF I2B2_TO_OMOP_PERSON_PKG.t_I2B2_Row;
      v_I2B2_Table t_I2B2_Table;
      
      -- Declare row type to be returned
      TYPE t_I2B2_Row IS RECORD
        (
          PERSON_ID                 NUMBER(19),
          YEAR_OF_BIRTH             NUMBER(10),
          MONTH_OF_BIRTH            NUMBER(10),
          DAY_OF_BIRTH              NUMBER(10),
          GENDER_CONCEPT_ID         NUMBER(10),
          RACE_CONCEPT_ID           NUMBER(10),
          ETHNICITY_CONCEPT_ID      NUMBER(10),
          LOCATION_ID               NUMBER(19),
          PROVIDER_ID               NUMBER(19),
          CARE_SITE_ID              NUMBER(19),
          PERSON_SOURCE_VALUE       VARCHAR2(100),
          GENDER_SOURCE_VALUE       VARCHAR2(50),
          RACE_SOURCE_VALUE         VARCHAR2(50),
          ETHNICITY_SOURCE_VALUE    VARCHAR2(50),
          PN_GESTATIONAL_AGE        NUMBER(4,2),
          PN_TIME_OF_BIRTH        VARCHAR2(10)
        );
        
      -- Declare type ref cursor for parallel instances of cursor used in pipelined function 
      TYPE t_I2B2_Table_cur IS REF CURSOR RETURN t_I2B2_Row;


    -- ==============================================================
    -- DECLARE PACKAGE PROCEDURES
    -- ==============================================================
      
      PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER);
      PROCEDURE sp_Load_Person_Tbl(Is_Successful OUT NUMBER);
      
      
    -- ==============================================================
    -- DECLARE PACKAGE FUNCTIONS
    -- ==============================================================
      
      FUNCTION sf_I2B2_Patient_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
        RETURN t_I2B2_Table PIPELINED
        PARALLEL_ENABLE(PARTITION i_I2B2_Table_cur BY ANY);
END I2B2_TO_OMOP_PERSON_PKG;
/
CREATE OR REPLACE PACKAGE BODY "I2B2_TO_OMOP_PERSON_PKG" 
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
  -- FUNCTION: sf_I2B2_Patient_Table_Blk
  -- ==============================================================
   
   FUNCTION sf_I2B2_Patient_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
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
      END sf_I2B2_Patient_Table_Blk;
  

  -- ==============================================================
  -- PROCEDURE: sp_Load_Data
  -- ==============================================================

   PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER) 
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
      -- Execute Load Person Table Process
      ----------------------------------------------------------------
          
        g_Err_Comment := 'Execute Load Person Table Process';
        sp_Load_Person_Tbl(Is_Successful);
        
        COMMIT;
        dbms_output.put_line('I2B2_TO_PERSON_PKG ' || Is_Successful);
    
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
  -- PROCEDURE: sp_Load_Person_Tbl
  -- ==============================================================

   PROCEDURE sp_Load_Person_Tbl(Is_Successful OUT NUMBER) 
   AS
     
    BEGIN
            
      ----------------------------------------------------------------
      -- Initialize Procedure
      ----------------------------------------------------------------
        
        g_Err_Comment := 'Initialize Procedure';
        g_Process_Name := 'I2B2 To Person Table';
        g_Err_Procedure := 'sp_Load_Person_Tbl';
        Is_Successful := 0;
        
      
      ----------------------------------------------------------------
      -- Load OMOP Person Table
      ----------------------------------------------------------------
       
        g_Err_Comment := 'Load OMOP Person Table';

        BEGIN
          
          INSERT /*+parallel append */
          INTO PERSON 
            (
              PERSON_ID, 
              YEAR_OF_BIRTH,
              MONTH_OF_BIRTH,
              DAY_OF_BIRTH,
              GENDER_CONCEPT_ID,
              RACE_CONCEPT_ID,
              ETHNICITY_CONCEPT_ID,
              LOCATION_ID,
              PROVIDER_ID,
              CARE_SITE_ID,
              PERSON_SOURCE_VALUE,
              GENDER_SOURCE_VALUE,
              RACE_SOURCE_VALUE,
              ETHNICITY_SOURCE_VALUE,
              PN_GESTATIONAL_AGE,
              PN_TIME_OF_BIRTH
            )
          SELECT
            PERSON_ID,
            YEAR_OF_BIRTH,
            MONTH_OF_BIRTH,
            DAY_OF_BIRTH,
            GENDER_CONCEPT_ID,
            RACE_CONCEPT_ID,
            ETHNICITY_CONCEPT_ID,
            LOCATION_ID,
            PROVIDER_ID,
            CARE_SITE_ID,
            PERSON_SOURCE_VALUE,
            GENDER_SOURCE_VALUE,
            RACE_SOURCE_VALUE,
            ETHNICITY_SOURCE_VALUE,
            PN_GESTATIONAL_AGE,
            PN_TIME_OF_BIRTH
          FROM TABLE 
            (I2B2_TO_OMOP_PERSON_PKG.sf_I2B2_Patient_Table_Blk
              (CURSOR 
                (SELECT 
MP.PERSON_ID, MP.YEAR_OF_BIRTH, MP.MONTH_OF_BIRTH, 
   MP.DAY_OF_BIRTH, MP.GENDER_CONCEPT_ID, MP.RACE_CONCEPT_ID, 
   MP.ETHNICITY_CONCEPT_ID, 
LOC.LOCATION_ID,
                    NULL AS PROVIDER_ID,
                    NULL AS CARE_SITE_ID,
MP.PERSON_SOURCE_VALUE,
MP.GENDER_SOURCE_VALUE, 
MP.RACE_SOURCE_VALUE, 
   MP.ETHNICITY_SOURCE_VALUE,
 NULL AS PN_GESTATIONAL_AGE,
                    NULL AS PN_TIME_OF_BIRTH
FROM MV_PERSON MP,
      LOCATION LOC
WHERE LTRIM(MP.ZIP) = LTRIM(LOC.ZIP(+))
                )
              )
            )
            LOG ERRORS INTO ERR$_PERSON(g_Process_ID)
            REJECT LIMIT UNLIMITED;
          
          g_Row_Count := g_Row_Count + SQL%ROWCOUNT;
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
                FROM ERR$_PERSON
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
                  FROM ERR$_PERSON
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
    dbms_output.put_line('I2B2_TO_PERSON_PKG ' || Is_Successful);
    
    END sp_Load_Person_Tbl; 
END I2B2_TO_OMOP_PERSON_PKG;
/
CREATE OR REPLACE PACKAGE "I2B2_TO_OMOP_VISIT_PKG" 
AS
   
    -- ==============================================================
    -- DECLARE PACKAGE VARIABLES
    -- ==============================================================
   
      -- Process variables
      g_Process_ID                    NUMBER; 
      g_Process_Name                  VARCHAR2 (100);
      g_Process_Start_Date            DATE;
      g_Process_End_Date              DATE;
      g_Row_Count                     NUMBER (12);
      g_ErrorRow_Count                NUMBER (12);
      g_Is_Successful_txt             VARCHAR2 (5);
      
      -- Error variables
      g_Err_ServerName                VARCHAR2 (100);
      g_Err_DatabaseName              VARCHAR2 (100);
      g_Err_Package                   VARCHAR2 (100);
      g_Err_Procedure                 VARCHAR2 (100);
      g_Err_Num                       VARCHAR2 (20);
      g_Err_Line                      NUMBER;
      g_Err_Msg                       VARCHAR2 (1000);
      g_Err_Comment                   VARCHAR2 (1000);
      g_Err_User                      VARCHAR2 (100);
      g_Err_Host                      VARCHAR2 (100);   

    
    -- ==============================================================
    -- DECLARE PACKAGE TYPES
    -- ==============================================================
      
      -- Declare type table to be returned by pipelined function
      TYPE t_I2B2_Table IS TABLE OF I2B2_TO_OMOP_VISIT_PKG.t_I2B2_Row;
      v_I2B2_Table t_I2B2_Table;
      
      -- Declare row type to be returned
      TYPE t_I2B2_Row IS RECORD
        (
          VISIT_OCCURRENCE_ID        NUMBER(19),
          PERSON_ID                NUMBER(19),
          VISIT_START_DATE            DATE,
          VISIT_END_DATE            DATE,
          PLACE_OF_SERVICE_CONCEPT_ID   NUMBER(10),
          CARE_SITE_ID          NUMBER(19),
          PLACE_OF_SERVICE_SOURCE_VALUE VARCHAR2(100),
          PROVIDER_ID            NUMBER(19)
        );
        

        
      -- Declare type ref cursor for parallel instances of cursor used in pipelined function 
      TYPE t_I2B2_Table_cur IS REF CURSOR RETURN t_I2B2_Row;
      
      
    -- ==============================================================
    -- DECLARE PACKAGE PROCEDURES
    -- ==============================================================
      
      PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER);
      PROCEDURE sp_Load_Visit_Tbl (Is_Successful OUT NUMBER);

    
    -- ==============================================================
    -- DECLARE PACKAGE FUNCTIONS
    -- ==============================================================
      
      -- Declare function to return pipelined table
      FUNCTION sf_I2B2_Visit_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur) 
        RETURN t_I2B2_Table PIPELINED
        PARALLEL_ENABLE(PARTITION i_I2B2_Table_cur BY ANY);


END I2B2_TO_OMOP_VISIT_PKG;
/
CREATE OR REPLACE PACKAGE BODY "I2B2_TO_OMOP_VISIT_PKG" 
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
  -- FUNCTION: sf_I2B2_Visit_Table_Blk
  -- ==============================================================
   
   FUNCTION sf_I2B2_Visit_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
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
      END sf_I2B2_Visit_Table_Blk;
    
 
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
      -- Execute Load Visit Table Process
      ----------------------------------------------------------------
          
        g_Err_Comment := 'Execute Load Visit Table Process';
        sp_Load_Visit_Tbl(Is_Successful);
        
        COMMIT;
        dbms_output.put_line('I2B2_TO_VISIT_PKG ' || Is_Successful);

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
  -- PROCEDURE: sp_Load_Visit_Tbl
  -- ==============================================================

   PROCEDURE sp_Load_Visit_Tbl(Is_Successful OUT NUMBER)
   AS
  
    BEGIN
            
      ----------------------------------------------------------------
      -- Initialize Procedure
      ----------------------------------------------------------------
        
        g_Err_Comment := 'Initialize Procedure';
        g_Process_Name := 'I2B2 To Visit Table';
        g_Err_Procedure := 'sp_Load_Visit_Tbl';
        Is_Successful := 0;
        
        DECLARE
          v_sysdate DATE := SYSDATE;
          v_systimestamp TIMESTAMP := SYSTIMESTAMP;
          v_date DATE;
          v_number NUMBER(10);
          BEGIN
            -- Print the current date and timestamp
            DBMS_OUTPUT.PUT_LINE('START_TIME: ' || v_systimestamp);
         END;


          ----------------------------------------------------------------
          -- Load OMOP Visit Table
          ----------------------------------------------------------------
           
            g_Err_Comment := 'Load OMOP Visit Table';
            
            BEGIN
              
              INSERT /*+parallel append */ 
              INTO VISIT_OCCURRENCE  
                (
                  VISIT_OCCURRENCE_ID,
                  PERSON_ID,
                  VISIT_START_DATE,
                  VISIT_END_DATE,
                  PLACE_OF_SERVICE_CONCEPT_ID,
                  CARE_SITE_ID,
                  PLACE_OF_SERVICE_SOURCE_VALUE,
                  PROVIDER_ID
                )
              SELECT
                VISIT_OCCURRENCE_ID,
                PERSON_ID,
                VISIT_START_DATE,
                VISIT_END_DATE,
                PLACE_OF_SERVICE_CONCEPT_ID,
                CARE_SITE_ID,
                PLACE_OF_SERVICE_SOURCE_VALUE,
                PROVIDER_ID
              FROM TABLE 
                (I2B2_TO_OMOP_VISIT_PKG.sf_I2B2_Visit_Table_Blk
                  (CURSOR 
                    (SELECT      V.ENCOUNTER_NUM               AS            VISIT_OCCURRENCE_ID,
                        V.PATIENT_NUM       AS                      PERSON_ID,
                        V.START_DATE          AS                    VISIT_START_DATE,
                        V.END_DATE              AS                  VISIT_END_DATE,
                        OMAP.DESTINATION_CODE     AS                PLACE_OF_SERVICE_CONCEPT_ID,
                        NULL                        AS              CARE_SITE_ID,
                        V.INOUT_CD                  AS              PLACE_OF_SERVICE_SOURCE_VALUE,
                        NULL                   AS   PROVIDER_ID
                      FROM I2B2ETL.VISIT_DIMENSION V
                        INNER JOIN PERSON PN
                          ON V.PATIENT_NUM = PN.PERSON_ID
                        INNER JOIN OMOP_MAPPING OMAP                
                          ON 'VISIT' = OMAP.DESTINATION_TABLE
                            AND    'PLACE_OF_SERVICE_CONCEPT_ID' = OMAP.DESTINATION_COLUMN
                            AND V.INOUT_CD = OMAP.SOURCE_VALUE
                    )
                  )
                )
                LOG ERRORS INTO ERR$_VISIT_OCCURRENCE(g_Process_ID)
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
                FROM ERR$_VISIT_OCCURRENCE
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
                  FROM ERR$_VISIT_OCCURRENCE
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
    dbms_output.put_line('I2B2_TO_VISIT_PKG ' || Is_Successful);
    
    END sp_Load_Visit_Tbl; 
END I2B2_TO_OMOP_VISIT_PKG;
/
CREATE OR REPLACE PACKAGE "I2B2_TO_OMOP_VITALS_PKG"
AS

    -- ==============================================================
    -- DECLARE PACKAGE VARIABLES
    -- ==============================================================

      -- Process variables
      g_Process_ID                    NUMBER;
      g_Process_Name                  VARCHAR2 (100);
      g_Process_Start_Date            DATE;
      g_Process_End_Date              DATE;
      g_Row_Count                     NUMBER (12);
      g_ErrorRow_Count                NUMBER (12);
      g_Is_Successful_txt             VARCHAR2 (5);

      -- Error variables
      g_Err_ServerName                VARCHAR2 (100);
      g_Err_DatabaseName              VARCHAR2 (100);
      g_Err_Package                   VARCHAR2 (100);
      g_Err_Procedure                 VARCHAR2 (100);
      g_Err_Num                       VARCHAR2 (20);
      g_Err_Line                      NUMBER;
      g_Err_Msg                       VARCHAR2 (1000);
      g_Err_Comment                   VARCHAR2 (1000);
      g_Err_User                      VARCHAR2 (100);
      g_Err_Host                      VARCHAR2 (100);


    -- ==============================================================
    -- DECLARE PACKAGE TYPES
    -- ==============================================================

      -- Declare type table to be returned by pipelined function
      TYPE t_I2B2_Table IS TABLE OF I2B2_TO_OMOP_VITALS_PKG.t_I2B2_Row;
      v_I2B2_Table t_I2B2_Table;

      -- Declare row type to be returned
      TYPE t_I2B2_Row IS RECORD
        (
          --OBSERVATION_ID    NUMBER(19),
          PERSON_ID    NUMBER(19),
          OBSERVATION_CONCEPT_ID    NUMBER(10),
          OBSERVATION_DATE    DATE,
          OBSERVATION_TIME    VARCHAR2(10 BYTE),
          VALUE_AS_NUMBER    NUMBER(14,3),
          VALUE_AS_STRING    VARCHAR2(60 BYTE),
          VALUE_AS_CONCEPT_ID    NUMBER(10),
          UNIT_CONCEPT_ID    NUMBER(10),
        RANGE_LOW            NUMBER(14,3),
        RANGE_HIGH           NUMBER(14,3),
       OBSERVATION_TYPE_CONCEPT_ID    NUMBER(10),
         ASSOCIATED_PROVIDER_ID    NUMBER(19),
          VISIT_OCCURRENCE_ID    NUMBER(19),
         RELEVANT_CONDITION_CONCEPT_ID    NUMBER(10),
         OBSERVATION_SOURCE_VALUE    VARCHAR2(100 BYTE),
          UNITS_SOURCE_VALUE    VARCHAR2(100 BYTE)
          );

      -- Declare type ref cursor for parallel instances of cursor used in pipelined function
      TYPE t_I2B2_Table_cur IS REF CURSOR RETURN t_I2B2_Row;


    -- ==============================================================
    -- DECLARE PACKAGE PROCEDURES
    -- ==============================================================

      PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER);
      PROCEDURE sp_Load_Vitals_Tbl (Is_Successful OUT NUMBER);


    -- ==============================================================
    -- DECLARE PACKAGE FUNCTIONS
    -- ==============================================================

      -- Declare function to return pipelined table
      FUNCTION sf_I2B2_Vitals_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
        RETURN t_I2B2_Table PIPELINED
        PARALLEL_ENABLE(PARTITION i_I2B2_Table_cur BY ANY);


END I2B2_TO_OMOP_VITALS_PKG;
/
CREATE OR REPLACE PACKAGE BODY "I2B2_TO_OMOP_VITALS_PKG"
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
                    (SELECT DISTINCT 
            OBF.PATIENT_NUM             PERSON_ID,
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
CREATE OR REPLACE PACKAGE "I2B2_TO_OMOP_DX_PKG" 
AS
   
    -- ==============================================================
    -- DECLARE PACKAGE VARIABLES
    -- ==============================================================
   
      -- Process variables
      g_Process_ID                    NUMBER; 
      g_Process_Name                  VARCHAR2 (100);
      g_Process_Start_Date            DATE;
      g_Process_End_Date              DATE;
      g_Row_Count                     NUMBER (12);
      g_ErrorRow_Count                NUMBER (12);
      g_Is_Successful_txt             VARCHAR2 (5);
      
      -- Error variables
      g_Err_ServerName                VARCHAR2 (100);
      g_Err_DatabaseName              VARCHAR2 (100);
      g_Err_Package                   VARCHAR2 (100);
      g_Err_Procedure                 VARCHAR2 (100);
      g_Err_Num                       VARCHAR2 (20);
      g_Err_Line                      NUMBER;
      g_Err_Msg                       VARCHAR2 (1000);
      g_Err_Comment                   VARCHAR2 (1000);
      g_Err_User                      VARCHAR2 (100);
      g_Err_Host                      VARCHAR2 (100);   

    
    -- ==============================================================
    -- DECLARE PACKAGE TYPES
    -- ==============================================================
      
      -- Declare type table to be returned by pipelined function
      TYPE t_I2B2_Table IS TABLE OF I2B2_TO_OMOP_DX_PKG.t_I2B2_Row;
      v_I2B2_Table t_I2B2_Table;
      
      -- Declare row type to be returned
      TYPE t_I2B2_Row IS RECORD
        (
          --CONDITION_OCCURRENCE_ID    NUMBER(19)
          PERSON_ID    NUMBER(19),
          CONDITION_CONCEPT_ID    NUMBER(10),
          CONDITION_START_DATE    DATE,
          CONDITION_END_DATE    DATE,
          CONDITION_TYPE_CONCEPT_ID    NUMBER(10),
          STOP_REASON    VARCHAR2(100 BYTE),
          ASSOCIATED_PROVIDER_ID    NUMBER(19),
          VISIT_OCCURRENCE_ID    NUMBER(19),
          CONDITION_SOURCE_VALUE    VARCHAR2(100 BYTE)
        );
        
      -- Declare type ref cursor for parallel instances of cursor used in pipelined function 
      TYPE t_I2B2_Table_cur IS REF CURSOR RETURN t_I2B2_Row;
      
      
    -- ==============================================================
    -- DECLARE PACKAGE PROCEDURES
    -- ==============================================================
      
      PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER);
      PROCEDURE sp_Load_DX_Tbl (Is_Successful OUT NUMBER);

    
    -- ==============================================================
    -- DECLARE PACKAGE FUNCTIONS
    -- ==============================================================
      
      -- Declare function to return pipelined table
      FUNCTION sf_I2B2_DX_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur) 
        RETURN t_I2B2_Table PIPELINED
        PARALLEL_ENABLE(PARTITION i_I2B2_Table_cur BY ANY);


END I2B2_TO_OMOP_DX_PKG;
/
CREATE OR REPLACE PACKAGE BODY "I2B2_TO_OMOP_DX_PKG" 
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
  -- FUNCTION: sf_I2B2_DX_Table_Blk
  -- ==============================================================
   
   FUNCTION sf_I2B2_DX_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
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
      END sf_I2B2_DX_Table_Blk;
    
 
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
      -- Execute Load DX Table Process
      ----------------------------------------------------------------
          
        g_Err_Comment := 'Execute Load DX Table Process';
        sp_Load_DX_Tbl(Is_Successful);
        
        COMMIT;
        dbms_output.put_line('I2B2_TO_DX_PKG ' || Is_Successful);

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
  -- PROCEDURE: sp_Load_DX_Tbl
  -- ==============================================================

   PROCEDURE sp_Load_DX_Tbl(Is_Successful OUT NUMBER)
   AS
  
    BEGIN
            
      ----------------------------------------------------------------
      -- Initialize Procedure
      ----------------------------------------------------------------
        
        g_Err_Comment := 'Initialize Procedure';
        g_Process_Name := 'I2B2 To DX Table';
        g_Err_Procedure := 'sp_Load_DX_Tbl';
        Is_Successful := 0;
        
   
        ----------------------------------------------------------------
        -- Load OMOP DX Table
        ----------------------------------------------------------------
                    
          ----------------------------------------------------------------
          -- Load OMOP Observation Table
          ----------------------------------------------------------------
           
            g_Err_Comment := 'Load OMOP Observation Table';
             
            BEGIN
              
              INSERT /*+parallel append */
              INTO CONDITION_OCCURRENCE  
                (
                  CONDITION_OCCURRENCE_ID,
                  PERSON_ID,
                  CONDITION_CONCEPT_ID,
                  CONDITION_START_DATE,
                  CONDITION_END_DATE,
                  CONDITION_TYPE_CONCEPT_ID,
                  STOP_REASON,
                  ASSOCIATED_PROVIDER_ID,
                  VISIT_OCCURRENCE_ID,
                  CONDITION_SOURCE_VALUE
                )
              SELECT
                  CONDITION_OCCUR_SEQ.NEXTVAL CONDITION_OCCURRENCE_ID,
                  PERSON_ID,
                  CONDITION_CONCEPT_ID,
                  CONDITION_START_DATE,
                  CONDITION_END_DATE,
                  CONDITION_TYPE_CONCEPT_ID,
                  STOP_REASON,
                  ASSOCIATED_PROVIDER_ID,
                  VISIT_OCCURRENCE_ID,
                  CONDITION_SOURCE_VALUE
              FROM TABLE 
                (I2B2_TO_OMOP_DX_PKG.sf_I2B2_DX_Table_Blk
                  (CURSOR 
                    (SELECT DISTINCT
                      OBF.PATIENT_NUM                     PERSON_ID,
                      DX.TARGET_CONCEPT_ID                CONDITION_CONCEPT_ID,   
                      OBF.START_DATE                      CONDITION_START_DATE,
                      OBF.END_DATE                        CONDITION_END_DATE,
                      A.DESTINATION_CODE                  CONDITION_TYPE_CONCEPT_ID,
                      NULL                                STOP_REASON,
                      NULL                                ASSOCIATED_PROVIDER_ID,
                      OBF.ENCOUNTER_NUM                   VISIT_OCCURRENCE_ID,
                      OBF.CONCEPT_CD                      CONDITION_SOURCE_VALUE
                    FROM I2B2ETL.OBSERVATION_FACT PARTITION (DX) OBF
                      INNER JOIN PERSON PN
                       ON OBF.PATIENT_NUM = PN.PERSON_ID
                      INNER JOIN MV_OMOP_DX_CODES DX
                        ON OBF.CONCEPT_CD = DX.SOURCE_CODE_I2B2_CD
                      INNER JOIN OMOP_MAPPING A
                        ON  'CONDITION_OCCURRENCE' = A.DESTINATION_TABLE
                        AND 'CONDITION_TYPE_CONCEPT_ID' = A.DESTINATION_COLUMN
                        AND OBF.MODIFIER_CD = A.SOURCE_VALUE
                    WHERE 
                      OBF.MODIFIER_CD IN ('PDX:P','PDX:OT')
                    )
                  )
                )
                LOG ERRORS INTO ERR$_CONDITION_OCCURRENCE(g_Process_ID)
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
    dbms_output.put_line('I2B2_TO_DX_PKG ' || Is_Successful);
    
    END sp_Load_DX_Tbl; 
END I2B2_TO_OMOP_DX_PKG;
/
CREATE OR REPLACE PACKAGE "I2B2_TO_OMOP_PROCS_PKG" 
AS
   
    -- ==============================================================
    -- DECLARE PACKAGE VARIABLES
    -- ==============================================================
   
      -- Process variables
      g_Process_ID                    NUMBER; 
      g_Process_Name                  VARCHAR2 (100);
      g_Process_Start_Date            DATE;
      g_Process_End_Date              DATE;
      g_Row_Count                     NUMBER (12);
      g_ErrorRow_Count                NUMBER (12);
      g_Is_Successful_txt             VARCHAR2 (5);
      
      -- Error variables
      g_Err_ServerName                VARCHAR2 (100);
      g_Err_DatabaseName              VARCHAR2 (100);
      g_Err_Package                   VARCHAR2 (100);
      g_Err_Procedure                 VARCHAR2 (100);
      g_Err_Num                       VARCHAR2 (20);
      g_Err_Line                      NUMBER;
      g_Err_Msg                       VARCHAR2 (1000);
      g_Err_Comment                   VARCHAR2 (1000);
      g_Err_User                      VARCHAR2 (100);
      g_Err_Host                      VARCHAR2 (100);   

    
    -- ==============================================================
    -- DECLARE PACKAGE TYPES
    -- ==============================================================
      
      -- Declare type table to be returned by pipelined function
      TYPE t_I2B2_Table IS TABLE OF I2B2_TO_OMOP_PROCS_PKG.t_I2B2_Row;
      v_I2B2_Table t_I2B2_Table;
      
      -- Declare row type to be returned
      TYPE t_I2B2_Row IS RECORD
        (
        --PROCEDURE_OCCURRENCE_ID     NUMBER(19),
        PERSON_ID                 NUMBER(19),
        PROCEDURE_CONCEPT_ID        NUMBER(10),
        PROCEDURE_DATE            DATE,
        PROCEDURE_TYPE_CONCEPT_ID    NUMBER(10),
        ASSOCIATED_PROVIDER_ID        NUMBER(19),
        VISIT_OCCURRENCE_ID        NUMBER(19),
        RELEVANT_CONDITION_CONCEPT_ID    NUMBER(10),
        PROCEDURE_SOURCE_VALUE        VARCHAR2(100 BYTE)
        );
        
      -- Declare type ref cursor for parallel instances of cursor used in pipelined function 
      TYPE t_I2B2_Table_cur IS REF CURSOR RETURN t_I2B2_Row;
      
      
    -- ==============================================================
    -- DECLARE PACKAGE PROCEDURES
    -- ==============================================================
      
      PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER);
      PROCEDURE sp_Load_Procs_Tbl (Is_Successful OUT NUMBER);

    
    -- ==============================================================
    -- DECLARE PACKAGE FUNCTIONS
    -- ==============================================================
      
      -- Declare function to return pipelined table
      FUNCTION sf_I2B2_PROCS_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur) 
        RETURN t_I2B2_Table PIPELINED
        PARALLEL_ENABLE(PARTITION i_I2B2_Table_cur BY ANY);


END I2B2_TO_OMOP_PROCS_PKG;
/
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
                    (SELECT DISTINCT
              OBF.PATIENT_NUM          PERSON_ID,
              CNPT.CONCEPT_ID              PROCEDURE_CONCEPT_ID,   
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
              AND OBF.MODIFIER_CD = A.SOURCE_VALUE
          WHERE 
              OBF.MODIFIER_CD IN ('ORIGPX:MAPPED')
        AND  CNPT.vocabulary_id = 4 -- CPT-4
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
CREATE OR REPLACE PACKAGE "I2B2_TO_OMOP_OBSV_PERIOD_PKG" 
AS
   
    -- ==============================================================
    -- DECLARE PACKAGE VARIABLES
    -- ==============================================================
   
      -- Process variables
      g_Process_ID                    NUMBER; 
      g_Process_Name                  VARCHAR2 (100);
      g_Process_Start_Date            DATE;
      g_Process_End_Date              DATE;
      g_Row_Count                     NUMBER (12);
      g_ErrorRow_Count                NUMBER (12);
      g_Is_Successful_txt             VARCHAR2 (5);
      
      -- Error variables
      g_Err_ServerName                VARCHAR2 (100);
      g_Err_DatabaseName              VARCHAR2 (100);
      g_Err_Package                   VARCHAR2 (100);
      g_Err_Procedure                 VARCHAR2 (100);
      g_Err_Num                       VARCHAR2 (20);
      g_Err_Line                      NUMBER;
      g_Err_Msg                       VARCHAR2 (1000);
      g_Err_Comment                   VARCHAR2 (1000);
      g_Err_User                      VARCHAR2 (100);
      g_Err_Host                      VARCHAR2 (100);   

    
    -- ==============================================================
    -- DECLARE PACKAGE TYPES
    -- ==============================================================
      
      -- Declare type table to be returned by pipelined function
      TYPE t_I2B2_Table IS TABLE OF I2B2_TO_OMOP_OBSV_PERIOD_PKG.t_I2B2_Row;
      v_I2B2_Table t_I2B2_Table;
      
      -- Declare row type to be returned
      TYPE t_I2B2_Row IS RECORD
        (
        --OBSERVATION_PERIOD_ID             NUMBER(19),
        PERSON_ID                         NUMBER(19),
        OBSERVATION_PERIOD_START_DATE           DATE,
        OBSERVATION_PERIOD_END_DATE             DATE
        );
        
      -- Declare type ref cursor for parallel instances of cursor used in pipelined function 
      TYPE t_I2B2_Table_cur IS REF CURSOR RETURN t_I2B2_Row;
      
      
    -- ==============================================================
    -- DECLARE PACKAGE PROCEDURES
    -- ==============================================================
      
      PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER);
      PROCEDURE sp_Load_Obsv_Period_Tbl (Is_Successful OUT NUMBER);

    
    -- ==============================================================
    -- DECLARE PACKAGE FUNCTIONS
    -- ==============================================================
      
      -- Declare function to return pipelined table
      FUNCTION sf_I2B2_OBSV_PERIOD_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur) 
        RETURN t_I2B2_Table PIPELINED
        PARALLEL_ENABLE(PARTITION i_I2B2_Table_cur BY ANY);


END I2B2_TO_OMOP_OBSV_PERIOD_PKG;
/
CREATE OR REPLACE PACKAGE BODY "I2B2_TO_OMOP_OBSV_PERIOD_PKG" 
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
  -- FUNCTION: sf_I2B2_OBSV_PERIOD_Table_Blk
  -- ==============================================================
   
   FUNCTION sf_I2B2_OBSV_PERIOD_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
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
      END sf_I2B2_OBSV_PERIOD_Table_Blk;
    
 
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
      -- Execute Load Observation_Period Table Process
      ----------------------------------------------------------------
          
        g_Err_Comment := 'Execute Load OBSV_PERIOD Table Process';
        sp_Load_Obsv_Period_Tbl(Is_Successful);
        
        COMMIT;
        dbms_output.put_line('I2B2_TO_OBSV_PERIOD_PKG ' || Is_Successful);

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
  -- PROCEDURE: sp_Load_Obsv_Period_Tbl
  -- ==============================================================

   PROCEDURE sp_Load_Obsv_Period_Tbl(Is_Successful OUT NUMBER)
   AS
  
    BEGIN
            
      ----------------------------------------------------------------
      -- Initialize Procedure
      ----------------------------------------------------------------
        
        g_Err_Comment := 'Initialize Procedure';
        g_Process_Name := 'I2B2 To OBSV_PERIOD Table';
        g_Err_Procedure := 'sp_Load_Obsv_Period_Tbl';
        Is_Successful := 0;
        
   
        ----------------------------------------------------------------
        -- Load OMOP Observation_Period Table
        ----------------------------------------------------------------
                    
          ----------------------------------------------------------------
          -- Load OMOP Observation_Period Table
          ----------------------------------------------------------------
           
            g_Err_Comment := 'Load OMOP Observation_Period Table';
             
            BEGIN
              
              INSERT /*+parallel append */
              INTO OBSERVATION_PERIOD
               (
                OBSERVATION_PERIOD_ID,
        PERSON_ID,
        OBSERVATION_PERIOD_START_DATE,
                OBSERVATION_PERIOD_END_DATE     
             ) 
             SELECT 
                 OBSERVATION_PERIOD_SEQ.NEXTVAL  OBSERVATION_PERIOD_ID,
                 PERSON_ID,
                 OBSERVATION_PERIOD_START_DATE,
                 OBSERVATION_PERIOD_END_DATE 
             FROM TABLE 
                (I2B2_TO_OMOP_OBSV_PERIOD_PKG.sf_I2B2_OBSV_PERIOD_Table_Blk
                  (CURSOR 
                    (select 
patient_num as person_id,
observation_period_start_date,
observation_period_end_date
from (
select  vd.patient_num,  
extract (year from vd.start_Date) as start_date_year,
to_Date(min(vd.start_Date),'dd-mon-rrrr') as observation_period_start_date, 
case when to_date(max(vd.end_date),'dd-mon-rrrr')  is null 
then to_date('12/31/'||extract (year from vd.start_Date),'mm/dd/yyyy') 
else to_date(max(vd.end_date),'dd-mon-rrrr')  
end as observation_period_end_date
from i2b2etl.observation_fact partition (vitals) vt 
inner join i2b2etl.visit_dimension vd 
 on vt.encounter_num=vd.encounter_num 
inner join person pn
on vd.patient_num = pn.person_id
group by vd.patient_num
,extract (year from vd.start_Date)
)
           )
                  )
                )
                LOG ERRORS INTO ERR$_OBSERVATION_PERIOD(g_Process_ID)
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
                FROM ERR$_OBSERVATION_PERIOD
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
                  FROM ERR$_OBSERVATION_PERIOD
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
    dbms_output.put_line('I2B2_TO_OMOP_OBSV_PERIOD_PKG ' || Is_Successful);
    
    END sp_Load_Obsv_Period_Tbl; 
END I2B2_TO_OMOP_OBSV_PERIOD_PKG;
/
CREATE OR REPLACE PACKAGE "I2B2_TO_OMOP_DEATH_PKG" 
AS
   
    -- ==============================================================
    -- DECLARE PACKAGE VARIABLES
    -- ==============================================================
   
      -- Process variables
      g_Process_ID                    NUMBER; 
      g_Process_Name                  VARCHAR2 (100);
      g_Process_Start_Date            DATE;
      g_Process_End_Date              DATE;
      g_Row_Count                     NUMBER (12);
      g_ErrorRow_Count                NUMBER (12);
      g_Is_Successful_txt             VARCHAR2 (5);
      
      -- Error variables
      g_Err_ServerName                VARCHAR2 (100);
      g_Err_DatabaseName              VARCHAR2 (100);
      g_Err_Package                   VARCHAR2 (100);
      g_Err_Procedure                 VARCHAR2 (100);
      g_Err_Num                       VARCHAR2 (20);
      g_Err_Line                      NUMBER;
      g_Err_Msg                       VARCHAR2 (1000);
      g_Err_Comment                   VARCHAR2 (1000);
      g_Err_User                      VARCHAR2 (100);
      g_Err_Host                      VARCHAR2 (100);   

    
    -- ==============================================================
    -- DECLARE PACKAGE TYPES
    -- ==============================================================
      
      -- Declare type table to be returned by pipelined function
      TYPE t_I2B2_Table IS TABLE OF I2B2_TO_OMOP_DEATH_PKG.t_I2B2_Row;
      v_I2B2_Table t_I2B2_Table;
      
      -- Declare row type to be returned
      TYPE t_I2B2_Row IS RECORD
        (
          PERSON_ID                     NUMBER(19),
          DEATH_DATE                DATE,
          DEATH_TYPE_CONCEPT_ID            NUMBER(10),
          CAUSE_OF_DEATH_CONCEPT_ID    NUMBER(10),
          CAUSE_OF_DEATH_SOURCE_VALUE    VARCHAR2(100)
        );
        
      -- Declare type ref cursor for parallel instances of cursor used in pipelined function 
      TYPE t_I2B2_Table_cur IS REF CURSOR RETURN t_I2B2_Row;


    -- ==============================================================
    -- DECLARE PACKAGE PROCEDURES
    -- ==============================================================
      
      PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER);
      PROCEDURE sp_Load_Death_Tbl(Is_Successful OUT NUMBER);
      
      
    -- ==============================================================
    -- DECLARE PACKAGE FUNCTIONS
    -- ==============================================================
      
      FUNCTION sf_I2B2_Death_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
        RETURN t_I2B2_Table PIPELINED
        PARALLEL_ENABLE(PARTITION i_I2B2_Table_cur BY ANY);


END I2B2_TO_OMOP_DEATH_PKG;
/
CREATE OR REPLACE PACKAGE BODY "I2B2_TO_OMOP_DEATH_PKG" 
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
  -- FUNCTION: sf_I2B2_Death_Table_Blk
  -- ==============================================================
   
   FUNCTION sf_I2B2_Death_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
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
      END sf_I2B2_Death_Table_Blk;
  

  -- ==============================================================
  -- PROCEDURE: sp_Load_Data
  -- ==============================================================

   PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER) 
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
      -- Execute Load Death Table Process
      ----------------------------------------------------------------
          
        g_Err_Comment := 'Execute Load Death Table Process';
        sp_Load_Death_Tbl(Is_Successful);
        
        COMMIT;
        dbms_output.put_line('I2B2_TO_DEATH_PKG ' || Is_Successful);
    
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
  -- PROCEDURE: sp_Load_Death_Tbl
  -- ==============================================================

   PROCEDURE sp_Load_Death_Tbl(Is_Successful OUT NUMBER) 
   AS
     
    BEGIN
            
      ----------------------------------------------------------------
      -- Initialize Procedure
      ----------------------------------------------------------------
        
        g_Err_Comment := 'Initialize Procedure';
        g_Process_Name := 'I2B2 To Death Table';
        g_Err_Procedure := 'sp_Load_Death_Tbl';
        Is_Successful := 0;
        
      
      ----------------------------------------------------------------
      -- Load OMOP Death Table
      ----------------------------------------------------------------
       
        g_Err_Comment := 'Load OMOP Death Table';

        BEGIN
          
          INSERT /*+parallel append */
          INTO DEATH 
            (
              PERSON_ID, 
              DEATH_DATE,
              DEATH_TYPE_CONCEPT_ID,
              CAUSE_OF_DEATH_CONCEPT_ID,
              CAUSE_OF_DEATH_SOURCE_VALUE
            )
          SELECT
            PERSON_ID, 
        DEATH_DATE,
        DEATH_TYPE_CONCEPT_ID,
        CAUSE_OF_DEATH_CONCEPT_ID,
            CAUSE_OF_DEATH_SOURCE_VALUE
          FROM TABLE 
            (I2B2_TO_OMOP_DEATH_PKG.sf_I2B2_Death_Table_Blk
              (CURSOR 
                (SELECT DISTINCT 
                        PD.PATIENT_NUM         PERSON_ID,
             PD.DEATH_DATE,
             MS.DESTINATION_CODE     DEATH_TYPE_CONCEPT_ID,
             NULL             CAUSE_OF_DEATH_CONCEPT_ID,
             NULL                     CAUSE_OF_DEATH_SOURCE_VALUE
             FROM I2B2ETL.PATIENT_DIMENSION PD
         INNER JOIN PERSON PN
         ON PD.PATIENT_NUM = PN.PERSON_ID
         INNER JOIN OMOP_MAPPING MS
         ON 'DEATH' = MS.DESTINATION_TABLE
         AND 'DEATH_TYPE_CONCEPT_ID' = MS.DESTINATION_COLUMN
         AND UPPER(PD.VITAL_STATUS_CD) = UPPER(MS.SOURCE_VALUE)
         AND PD.DEATH_DATE IS NOT NULL
                )
              )
            )
            LOG ERRORS INTO ERR$_DEATH(g_Process_ID)
            REJECT LIMIT UNLIMITED;
          
          g_Row_Count := g_Row_Count + SQL%ROWCOUNT;
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
                FROM ERR$_DEATH
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
                  FROM ERR$_DEATH
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
    dbms_output.put_line('I2B2_TO_DEATH_PKG ' || Is_Successful);
    
    END sp_Load_Death_Tbl; 
END I2B2_TO_OMOP_DEATH_PKG;
/
CREATE OR REPLACE PACKAGE I2B2_TO_OMOP_LOCATION_PKG 
AS
   
    -- ==============================================================
    -- DECLARE PACKAGE VARIABLES
    -- ==============================================================
   
      -- Process variables
      g_Process_ID                    NUMBER; 
      g_Process_Name                  VARCHAR2 (100);
      g_Process_Start_Date            DATE;
      g_Process_End_Date              DATE;
      g_Row_Count                     NUMBER (12);
      g_ErrorRow_Count                NUMBER (12);
      g_Is_Successful_txt             VARCHAR2 (5);
      
      -- Error variables
      g_Err_ServerName                VARCHAR2 (100);
      g_Err_DatabaseName              VARCHAR2 (100);
      g_Err_Package                   VARCHAR2 (100);
      g_Err_Procedure                 VARCHAR2 (100);
      g_Err_Num                       VARCHAR2 (20);
      g_Err_Line                      NUMBER;
      g_Err_Msg                       VARCHAR2 (1000);
      g_Err_Comment                   VARCHAR2 (1000);
      g_Err_User                      VARCHAR2 (100);
      g_Err_Host                      VARCHAR2 (100);   

    
    -- ==============================================================
    -- DECLARE PACKAGE TYPES
    -- ==============================================================
      
      -- Declare type table to be returned by pipelined function
      TYPE t_I2B2_Table IS TABLE OF I2B2_TO_OMOP_LOCATION_PKG.t_I2B2_Row;
      v_I2B2_Table t_I2B2_Table;
      
      -- Declare row type to be returned
      TYPE t_I2B2_Row IS RECORD
        (
          --LOCATION_ID                     NUMBER(19),
          ADDRESS_1                VARCHAR2(100),
          ADDRESS_2           VARCHAR2(100),
          CITY                   VARCHAR2(50),
          STATE               VARCHAR2(2),
          ZIP               VARCHAR2(50),
          COUNTY                   VARCHAR2(50),
          LOCATION_SOURCE_VALUE        VARCHAR2(300)
        );
        
      -- Declare type ref cursor for parallel instances of cursor used in pipelined function 
      TYPE t_I2B2_Table_cur IS REF CURSOR RETURN t_I2B2_Row;


    -- ==============================================================
    -- DECLARE PACKAGE PROCEDURES
    -- ==============================================================
      
      PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER);
      PROCEDURE sp_Load_Location_Tbl(Is_Successful OUT NUMBER);
      
      
    -- ==============================================================
    -- DECLARE PACKAGE FUNCTIONS
    -- ==============================================================
      
      FUNCTION sf_I2B2_Location_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
        RETURN t_I2B2_Table PIPELINED
        PARALLEL_ENABLE(PARTITION i_I2B2_Table_cur BY ANY);


END I2B2_TO_OMOP_LOCATION_PKG;
/
CREATE OR REPLACE PACKAGE BODY "I2B2_TO_OMOP_LOCATION_PKG" 
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
  -- FUNCTION: sf_I2B2_Location_Table_Blk
  -- ==============================================================
   
   FUNCTION sf_I2B2_Location_Table_Blk(i_I2B2_Table_cur t_I2B2_Table_cur)
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
      END sf_I2B2_Location_Table_Blk;
  

  -- ==============================================================
  -- PROCEDURE: sp_Load_Data
  -- ==============================================================

   PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER) 
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
      -- Execute Load Location Table Process
      ----------------------------------------------------------------
          
        g_Err_Comment := 'Execute Load Location Table Process';
        sp_Load_Location_Tbl(Is_Successful);
        
        COMMIT;
        dbms_output.put_line('I2B2_TO_LOCATION_PKG ' || Is_Successful);
    
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
  -- PROCEDURE: sp_Load_Location_Tbl
  -- ==============================================================

   PROCEDURE sp_Load_Location_Tbl(Is_Successful OUT NUMBER) 
   AS
     
    BEGIN
            
      ----------------------------------------------------------------
      -- Initialize Procedure
      ----------------------------------------------------------------
        
        g_Err_Comment := 'Initialize Procedure';
        g_Process_Name := 'I2B2 To Location Table';
        g_Err_Procedure := 'sp_Load_Location_Tbl';
        Is_Successful := 0;
        
      
      ----------------------------------------------------------------
      -- Load OMOP Location Table
      ----------------------------------------------------------------
       
        g_Err_Comment := 'Load OMOP Location Table';

        BEGIN
          
          INSERT /*+parallel append */
          INTO LOCATION 
            (
              LOCATION_ID, 
              ADDRESS_1,
              ADDRESS_2,
              CITY,
              STATE,
              ZIP,
              COUNTY,
              LOCATION_SOURCE_VALUE
            )
          SELECT
           LOCATION_SEQ.NEXTVAL LOCATION_ID, 
           ADDRESS_1,
       ADDRESS_2,
       CITY,
       STATE,
       ZIP,
       COUNTY,
           LOCATION_SOURCE_VALUE
          FROM TABLE 
            (I2B2_TO_OMOP_LOCATION_PKG.sf_I2B2_Location_Table_Blk
              (CURSOR 
                (SELECT DISTINCT 
                   NULL AS ADDRESS_1, 
               NULL AS ADDRESS_2, 
               NULL AS CITY, 
               NULL AS STATE, 
               ZIP, 
               NULL AS COUNTY, 
               NULL AS LOCATION_SOURCE_VALUE
             FROM MV_PERSON
                 WHERE ZIP IS NOT NULL
                )
              )
            )
            LOG ERRORS INTO ERR$_LOCATION(g_Process_ID)
            REJECT LIMIT UNLIMITED;
          
          g_Row_Count := g_Row_Count + SQL%ROWCOUNT;
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
                FROM ERR$_LOCATION
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
                  FROM ERR$_LOCATION
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
    dbms_output.put_line('I2B2_TO_LOCATION_PKG ' || Is_Successful);
    
    END sp_Load_Location_Tbl; 
END I2B2_TO_OMOP_LOCATION_PKG;
/
CREATE OR REPLACE PACKAGE "I2B2_TO_OMOP_ETL_PKG" 
AS
   
    -- ==============================================================
    -- DECLARE PACKAGE VARIABLES
    -- ==============================================================
   
      -- Process variables 
      g_Process_ID                    NUMBER;
      g_Process_Name                  VARCHAR2 (100);
      g_Process_Start_Date            DATE;
      g_Process_End_Date              DATE;
      g_Is_Successful                 NUMBER (1);
      g_Is_Successful_txt             VARCHAR2 (5);
      g_Row_Count                     NUMBER (12);
      g_ErrorRow_Count                NUMBER (12);
      
      -- Error variables
      g_Err_ServerName                VARCHAR2 (100);
      g_Err_DatabaseName              VARCHAR2 (100);
      g_Err_Package                   VARCHAR2 (100);
      g_Err_Procedure                 VARCHAR2 (100);
      g_Err_Num                       VARCHAR2 (20);
      g_Err_Line                      NUMBER;
      g_Err_Msg                       VARCHAR2 (1000);
      g_Err_Comment                   VARCHAR2 (1000);
      g_Err_User                      VARCHAR2 (100);
      g_Err_Host                      VARCHAR2 (100);
      

    -- ==============================================================
    -- DECLARE PACKAGE PROCEDURES
    -- ==============================================================
         
      PROCEDURE sp_I2B2_To_OMOP_ETL;


END I2B2_TO_OMOP_ETL_PKG;
/
CREATE OR REPLACE PACKAGE BODY "I2B2_TO_OMOP_ETL_PKG" 
AS
   
  
  -- ==============================================================
  -- PROCEDURE: sp_Initialize
  -- ==============================================================
      /*
        Initializes global variables, grabs new ProcessID which
        is identifier for entire execution.
      */
    
    PROCEDURE sp_Initialize 
    AS
    
    BEGIN
     
      ----------------------------------------------------------------
      -- Init Process Variables
      ----------------------------------------------------------------

        -- Init ProcessID
        SELECT 
          CASE WHEN MAX(PROCESS_ID) IS NULL THEN 1 ELSE MAX(PROCESS_ID) + 1 END PROCESS_ID
        INTO g_Process_ID
        FROM
          OMOP_PROCESS_LOG;
          
        -- Init Procedure Specific Variables
        g_Process_Name := 'I2B2 To OMOP ETL';
        g_Process_Start_Date := SYSDATE;
        g_Is_Successful := 0;
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
  -- PROCEDURE: sp_I2B2_To_OMOP_ETL
  -- ==============================================================

   PROCEDURE sp_I2B2_To_OMOP_ETL 
   AS
  
   BEGIN
   
        ----------------------------------------------------------------
        -- Initialize Process
        ----------------------------------------------------------------
        
          g_Err_Procedure := 'sp_I2B2_To_OMOP_ETL';
          g_Err_Comment := 'Initialize Process';
          sp_Initialize;
        

        ----------------------------------------------------------------
        -- Refresh MV Views and Analyze MV Views
        ----------------------------------------------------------------
        
          g_Err_Comment := 'Refresh MV Views and Analyze MV Views';      
            
          SP_OMOP_MVS_TBL_STATS('MV');
        
        ----------------------------------------------------------------
        -- Disable Constraints
        ----------------------------------------------------------------
        
          g_Err_Comment := 'Disable Constraints';
          
          DECLARE
            l_SQLstatement VARCHAR2(32000);
          CURSOR c_Cursor 
          IS
            SELECT 'alter table '||C.table_name||' disable constraint '||C.constraint_name||' cascade' sqlstatement
            FROM USER_CONSTRAINTS C
              INNER JOIN OMOP_TABLES T
                ON C.TABLE_NAME = T.TABLE_NAME
            WHERE 
              constraint_type IN ('P','R')
            ORDER BY 
              constraint_type,
              C.table_name;
          BEGIN
          
              FOR r_CursorRow IN c_Cursor 
              LOOP
                l_SQLstatement := r_CursorRow.sqlstatement;
                DBMS_OUTPUT.PUT_LINE(l_SQLstatement);
                EXECUTE IMMEDIATE (l_SQLstatement);
              END LOOP;
          END;
          
          COMMIT;
          
          
        ----------------------------------------------------------------
        -- Truncate Tables
        ----------------------------------------------------------------
        
          g_Err_Comment := 'Truncate Tables';
          
          EXECUTE IMMEDIATE 'TRUNCATE TABLE EXCEPTIONS';
          
          DECLARE
            l_SQLstatement VARCHAR2(32000);
          CURSOR c_Cursor 
          IS
            SELECT 'TRUNCATE TABLE ' || TABLE_NAME sqlstatement
            FROM OMOP_TABLES;
          BEGIN
          
              FOR r_CursorRow IN c_Cursor 
              LOOP
                l_SQLstatement := r_CursorRow.sqlstatement;
                DBMS_OUTPUT.PUT_LINE(l_SQLstatement);
                EXECUTE IMMEDIATE (l_SQLstatement);
              END LOOP;
          END;
          
          COMMIT;
          

        ----------------------------------------------------------------
        -- Disable NonUnique Indexes
        ----------------------------------------------------------------
        
          g_Err_Comment := 'Disable NonUnique';
        
          DECLARE
            l_SQLstatement VARCHAR2(32000);
          CURSOR c_Cursor 
          IS
           
            SELECT 'ALTER INDEX ' || index_name || ' UNUSABLE' sqlstatement
            FROM USER_INDEXES C
              INNER JOIN OMOP_TABLES T
                ON C.TABLE_NAME = T.TABLE_NAME
            WHERE
              UNIQUENESS = 'NONUNIQUE';
          BEGIN
          
              FOR r_CursorRow IN c_Cursor 
              LOOP
                l_SQLstatement := r_CursorRow.sqlstatement;
                DBMS_OUTPUT.PUT_LINE(l_SQLstatement);
                EXECUTE IMMEDIATE (l_SQLstatement);
              END LOOP;
          END; 
              
          COMMIT;
          
      
      ----------------------------------------------------------------
      -- Execute ETL Packages
      ----------------------------------------------------------------
    	----------------------------------------------------------------
    	-- Execute I2B2 To Location Table Package
    	----------------------------------------------------------------
              
              g_Err_Comment := 'Execute I2B2 To Location Table Package';
              
              BEGIN 
                I2B2_TO_OMOP_LOCATION_PKG.sp_Load_Data (g_Is_Successful);
                g_Row_Count := g_Row_Count +  I2B2_TO_OMOP_LOCATION_PKG.g_Row_Count;
                g_ErrorRow_Count := g_ErrorRow_Count +  I2B2_TO_OMOP_LOCATION_PKG.g_ErrorRow_Count;
                
              END;
              
              IF g_Is_Successful <> 0 THEN 
                raise_application_error( -20001, 'Sub procedure in error.' );
              END IF;
              
          
        ----------------------------------------------------------------
        -- Execute I2B2 To Person Table Package
        ----------------------------------------------------------------
          
          g_Err_Comment := 'Execute I2B2 To Person Table Package';
          
          BEGIN 
            I2B2_TO_OMOP_PERSON_PKG.sp_Load_Data (g_Is_Successful);
            g_Row_Count := g_Row_Count +  I2B2_TO_OMOP_PERSON_PKG.g_Row_Count;
            g_ErrorRow_Count := g_ErrorRow_Count +  I2B2_TO_OMOP_PERSON_PKG.g_ErrorRow_Count;
            
          END;
          
          IF g_Is_Successful <> 0 THEN 
            raise_application_error( -20001, 'Sub procedure in error.' );
          END IF;
          
          
        ----------------------------------------------------------------
        -- Execute I2B2 To Visit Table Package
        ----------------------------------------------------------------
          
          g_Err_Comment := 'Execute I2B2 To Visit Table Package';
          
          BEGIN 
            I2B2_TO_OMOP_VISIT_PKG.sp_Load_Data (g_Is_Successful);
            g_Row_Count := g_Row_Count + I2B2_TO_OMOP_VISIT_PKG.g_Row_Count;
            g_ErrorRow_Count := g_ErrorRow_Count + I2B2_TO_OMOP_VISIT_PKG.g_ErrorRow_Count;
            
          END;
          
          IF g_Is_Successful <> 0 THEN
            raise_application_error( -20001, 'Sub procedure in error.' );
          END IF;
          
           
        ----------------------------------------------------------------
        -- Execute I2B2 To Vitals Table Package
        ----------------------------------------------------------------
          
          g_Err_Comment := 'Execute I2B2 To VITALS Table Package';
          
          BEGIN 
            I2B2_TO_OMOP_VITALS_PKG.sp_Load_Data (g_Is_Successful);
            g_Row_Count := g_Row_Count + I2B2_TO_OMOP_VITALS_PKG.g_Row_Count;
            g_ErrorRow_Count := g_ErrorRow_Count + I2B2_TO_OMOP_VITALS_PKG.g_ErrorRow_Count;
            
          END;
          
          IF g_Is_Successful <> 0 THEN
            raise_application_error( -20001, 'Sub procedure in error.' );
          END IF;
          

        ----------------------------------------------------------------
        -- Execute I2B2 To DX Table Package
        ----------------------------------------------------------------
          
          g_Err_Comment := 'Execute I2B2 To DX Table Package';
          
          BEGIN 
            I2B2_TO_OMOP_DX_PKG.sp_Load_Data (g_Is_Successful);
            g_Row_Count := g_Row_Count + I2B2_TO_OMOP_DX_PKG.g_Row_Count;
            g_ErrorRow_Count := g_ErrorRow_Count + I2B2_TO_OMOP_DX_PKG.g_ErrorRow_Count;
            
          END;
          
          IF g_Is_Successful <> 0 THEN
            raise_application_error( -20001, 'Sub procedure in error.' );
          END IF;


        ----------------------------------------------------------------
        -- Execute I2B2 To PROCS Table Package
        ----------------------------------------------------------------
          
          g_Err_Comment := 'Execute I2B2 To PROCS Table Package';
          
          BEGIN 
            I2B2_TO_OMOP_PROCS_PKG.sp_Load_Data (g_Is_Successful);
            g_Row_Count := g_Row_Count + I2B2_TO_OMOP_PROCS_PKG.g_Row_Count;
            g_ErrorRow_Count := g_ErrorRow_Count + I2B2_TO_OMOP_PROCS_PKG.g_ErrorRow_Count;
            
          END;
          
          IF g_Is_Successful <> 0 THEN
            raise_application_error( -20001, 'Sub procedure in error.' );
          END IF;

        ----------------------------------------------------------------
        -- Execute I2B2 To OBSERVATION_PERIOD Table Package
        ----------------------------------------------------------------
          
          g_Err_Comment := 'Execute I2B2 To OBSV_PERIOD Table Package';
          
          BEGIN 
            I2B2_TO_OMOP_OBSV_PERIOD_PKG.sp_Load_Data (g_Is_Successful);
            g_Row_Count := g_Row_Count + I2B2_TO_OMOP_OBSV_PERIOD_PKG.g_Row_Count;
            g_ErrorRow_Count := g_ErrorRow_Count + I2B2_TO_OMOP_OBSV_PERIOD_PKG.g_ErrorRow_Count;
            
          END;
          
          IF g_Is_Successful <> 0 THEN
            raise_application_error( -20001, 'Sub procedure in error.' );
          END IF;

     
         ----------------------------------------------------------------
         -- Execute I2B2 To CONDITION_ERA Table Package
         ----------------------------------------------------------------
           
           g_Err_Comment := 'Execute I2B2 To CONDITION_ERA Table Package';
           
           BEGIN 
             I2B2_TO_OMOP_CONDERA_PKG.sp_Load_Data (g_Is_Successful);
             g_Row_Count := g_Row_Count + I2B2_TO_OMOP_CONDERA_PKG.g_Row_Count;
             g_ErrorRow_Count := g_ErrorRow_Count + I2B2_TO_OMOP_CONDERA_PKG.g_ErrorRow_Count;
             
           END;
           
           IF g_Is_Successful <> 0 THEN
             raise_application_error( -20001, 'Sub procedure in error.' );
           END IF;
 

         ----------------------------------------------------------------
         -- Execute I2B2 To DEATH Table Package
         ----------------------------------------------------------------
           
           g_Err_Comment := 'Execute I2B2 To DEATH Table Package';
           
           BEGIN 
             I2B2_TO_OMOP_DEATH_PKG.sp_Load_Data (g_Is_Successful);
             g_Row_Count := g_Row_Count + I2B2_TO_OMOP_DEATH_PKG.g_Row_Count;
             g_ErrorRow_Count := g_ErrorRow_Count + I2B2_TO_OMOP_DEATH_PKG.g_ErrorRow_Count;
             
           END;
           
           IF g_Is_Successful <> 0 THEN
             raise_application_error( -20001, 'Sub procedure in error.' );
           END IF;

        ----------------------------------------------------------------
        -- Enable Indexes
        ----------------------------------------------------------------
          
          g_Err_Comment := 'Enable Indexes';
          
         DECLARE
            l_SQLstatement VARCHAR2(32000);
          CURSOR c_Cursor 
          IS
           
            SELECT 'ALTER INDEX ' || index_name || ' REBUILD' sqlstatement
            FROM USER_INDEXES C
              INNER JOIN OMOP_TABLES T
                ON C.TABLE_NAME = T.TABLE_NAME
            WHERE
              UNIQUENESS = 'NONUNIQUE';
          
          BEGIN
          
              FOR r_CursorRow IN c_Cursor 
              LOOP
                l_SQLstatement := r_CursorRow.sqlstatement;
                DBMS_OUTPUT.PUT_LINE(l_SQLstatement);
                EXECUTE IMMEDIATE (l_SQLstatement);
              END LOOP;
          END;
          
          COMMIT;
          
        
        ----------------------------------------------------------------
        -- Enable Constraints
        ----------------------------------------------------------------

          g_Err_Comment := 'Enable Constraints'; 
         
          DECLARE
            l_SQLstatement VARCHAR2(32000);
          CURSOR c_Cursor 
          IS
           
            SELECT 'alter table '||C.table_name||' enable constraint '||C.constraint_name || ' EXCEPTIONS into EXCEPTIONS' sqlstatement
            FROM USER_CONSTRAINTS C
              INNER JOIN OMOP_TABLES T
                ON C.TABLE_NAME = T.TABLE_NAME
            WHERE 
              constraint_type IN ('P','R')
            ORDER BY 
              constraint_type,
              C.table_name; 
          
          BEGIN
          
              FOR r_CursorRow IN c_Cursor 
              LOOP
                BEGIN
                  l_SQLstatement := r_CursorRow.sqlstatement;
                  DBMS_OUTPUT.PUT_LINE(l_SQLstatement);
                  EXECUTE IMMEDIATE (l_SQLstatement);
                EXCEPTION
                  WHEN OTHERS
                  THEN
                    g_Is_Successful := -1;
                END;
              END LOOP;
          END;
          
          COMMIT;
          
        
        ----------------------------------------------------------------
        -- Delete Exception Rows
        ----------------------------------------------------------------
        
          g_Err_Comment := 'Delete Exception Rows';
          
          
          DECLARE
            l_SQLstatement VARCHAR2(32000);
          CURSOR c_Cursor 
          IS
            SELECT 'DELETE FROM ' || TABLE_NAME || ' WHERE ' || TABLE_NAME || '.ROWID IN (SELECT ROW_ID FROM EXCEPTIONS)' sqlstatement
            FROM OMOP_TABLES;
          BEGIN
          
              FOR r_CursorRow IN c_Cursor 
              LOOP
                l_SQLstatement := r_CursorRow.sqlstatement;
                DBMS_OUTPUT.PUT_LINE(l_SQLstatement);
                EXECUTE IMMEDIATE (l_SQLstatement);
              END LOOP;
          END;

          COMMIT;
          
          
        ----------------------------------------------------------------
        -- Enable Constraints After Delete
        ----------------------------------------------------------------

          g_Err_Comment := 'Enable Constraints After Delete'; 
         
          DECLARE
            l_SQLstatement VARCHAR2(32000);
          CURSOR c_Cursor 
          IS
           
            SELECT 'alter table '||C.table_name||' enable constraint '||C.constraint_name || ' EXCEPTIONS into EXCEPTIONS' sqlstatement
            FROM USER_CONSTRAINTS C
              INNER JOIN OMOP_TABLES T
                ON C.TABLE_NAME = T.TABLE_NAME
            WHERE 
              constraint_type IN ('P','R')
            ORDER BY 
              constraint_type,
              C.table_name; 
          
          BEGIN
          
              FOR r_CursorRow IN c_Cursor 
              LOOP
                l_SQLstatement := r_CursorRow.sqlstatement;
                DBMS_OUTPUT.PUT_LINE(l_SQLstatement);
                EXECUTE IMMEDIATE (l_SQLstatement);
              END LOOP;
          END;
          
          COMMIT;
          
        
        ----------------------------------------------------------------
        -- Analyze Table objects stats
        ----------------------------------------------------------------
        
          g_Err_Comment := 'Analyze Table objects stats';      
            
          SP_OMOP_MVS_TBL_STATS('TBL');
          
        ----------------------------------------------------------------
        -- Log process in OMOP_PROCESS_LOG
        ----------------------------------------------------------------
          
          g_Is_Successful_txt := 'TRUE';
          g_Process_End_Date := SYSTIMESTAMP;
          
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
          
          dbms_output.put_line('I2B2_TO_OMOP_ETL_PKG ' || g_Is_Successful);
          COMMIT;
          
          
        ----------------------------------------------------------------
        -- Log process Exception History
        ----------------------------------------------------------------
          
          INSERT INTO EXCEPTIONS_HISTORY(
            PROCESS_ID,
            ROW_ID,    
            OWNER,        
            TABLE_NAME,    
            CONSTRAINT_NAME)
          SELECT
            g_Process_ID,
            ROW_ID,    
            OWNER,        
            TABLE_NAME,    
            CONSTRAINT_NAME
          FROM EXCEPTIONS;

          COMMIT;

    
    ----------------------------------------------------------------
    -- Exception Error Handling
    ----------------------------------------------------------------
    
    EXCEPTION
      WHEN OTHERS
      THEN
        
        -- Get Error Variables
        g_Is_Successful := -1;
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
          IS_SUCCESSFUL)
        VALUES(
          g_Process_ID,
          g_Process_Name,
          g_Process_Start_Date,
          g_Process_End_Date,
          g_Is_Successful_txt);
  
      COMMIT;
    
    
      -- Log process Exception History
      INSERT INTO EXCEPTIONS_HISTORY(
          PROCESS_ID,
          ROW_ID,    
          OWNER,        
          TABLE_NAME,    
          CONSTRAINT_NAME)
        SELECT
          g_Process_ID,
          ROW_ID,     
          OWNER,        
          TABLE_NAME,    
          CONSTRAINT_NAME
        FROM EXCEPTIONS;
      
      COMMIT;
    
   END sp_I2B2_To_OMOP_ETL;
END I2B2_TO_OMOP_ETL_PKG;
/


