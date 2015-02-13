--=============================================================================
--
-- NAME
--
-- i2b2_omop_packages.sql
--
-- Author : Rajesh Ganta
-- Cincinnati Childrens Hospital Medical Center (CCHMC)
-- Date : 11/19/2014
--
-- SCHEMA / USER : OMOP_ETL
-- PEDSNET OMOP CDM Version : 1.0
-- Oracle Database 11g
--
-- DESCRIPTION:
-- Under OMOP_ETL schema run below packages scripts, for to load data into following
-- tables (PERSON, VISIT_OCCURRENCE, OBSERVATION, CONDITION_OCCURRENCE,
-- PROCEDURE_OCCURRENCE, OBSERVATION_PERIOD, CONDITION_ERA and DEATH).
-- Packages are: 
-- 1. I2B2_TO_OMOP_ETL_PKG: This package calls the below eight packages for to 
-- load data from I2B2ETL into their corresponding tables (PERSON, VISIT_OCCURRENCE, 
-- OBSERVATION, CONDITION_OCCURRENCE, PROCEDURE_OCCURRENCE, OBSERVATION_PERIOD,
-- CONDITION_ERA and DEATH) and truncates required tables and reloads.
-- Package I2B2_TO_OMOP_ETL_PKG does following in order:
-- a) Get next Process_ID from Log table. Serves as ID for entire run.
-- b) Refresh materialized views and analyzing materialized views.
-- c) Disable primary and foreign keys.
-- d) Truncate tables.
-- e) Disable non-unique indexes.
-- f) Execute ETL packages - one for each i2b2 entity (PERSON, VISIT_OCCURRENCE,
-- OBSERVATION, CONDITION_OCCURRENCE, PROCEDURE_OCCURRENCE, OBSERVATION_PERIOD,
-- CONDITION_ERA and DEATH).Pipe rows, parallel load, redirect errors 
-- to ERR$_[TableName]
-- g) Enable non-unique indexes.
-- h) Enable primary and foreign keys.Redirect errors to Exceptions table, log 
-- in Exceptions_History table.
-- i) Delete rows from primary tables that where logged in Exceptions table.
-- j) Enable constraints after delete (includes primary key index).
-- k) Gather table stats.
-- l) Log ETL times and counts in Log table.
-- 2. I2B2_TO_OMOP_PERSON_PKG: This package loads data from I2B2ETL schema into
-- PERSON table.
-- 3. I2B2_TO_OMOP_VISIT_PKG: This package loads data from I2B2ETL schema into 
-- VISIT_OCCURRENCE table.
-- 4. I2B2_TO_OMOP_VITALS_PKG: This package loads data from I2B2ETL schema into
-- OBSERVATION table.
-- 5. I2B2_TO_OMOP_DX_PKG: This package loads data from I2B2ETL schema into
-- CONDITION_OCCURRENCE table.
-- 6. I2B2_TO_OMOP_PROCS_PKG: This package loads data from I2B2ETL schema into
-- PROCEDURE_OCCURRENCE table.
-- 7. I2B2_TO_OMOP_OBSV_PERIOD_PKG: This package loads data from I2B2ETL schema
-- into OBSERVATION_PERIOD table.
-- 8. I2B2_TO_OMOP_CONDERA_PKG: This package loads data from I2B2ETL schema into
-- CONDITION_ERA table.
-- 9. I2B2_TO_OMOP_DEATH_PKG: This package loads data from I2B2ETL schema into
-- DEATH table.
--
--=============================================================================
DROP PACKAGE I2B2_TO_OMOP_ETL_PKG
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
DROP PACKAGE BODY I2B2_TO_OMOP_ETL_PKG
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
DROP PACKAGE I2B2_TO_OMOP_PERSON_PKG
/
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
          PERSON_ID                 NUMBER(38,0),
          YEAR_OF_BIRTH             NUMBER(4,0),
          MONTH_OF_BIRTH            NUMBER(2,0),
          DAY_OF_BIRTH              NUMBER(2,0),
          GENDER_CONCEPT_ID         NUMBER(38,0),
          RACE_CONCEPT_ID           NUMBER(38,0),
          ETHNICITY_CONCEPT_ID      NUMBER(38,0),
          LOCATION_ID               NUMBER(38,0),
          PROVIDER_ID               NUMBER(38,0),
          CARE_SITE_ID              NUMBER(38,0),
          PERSON_SOURCE_VALUE       VARCHAR2(50),
          GENDER_SOURCE_VALUE       VARCHAR2(50),
          RACE_SOURCE_VALUE         VARCHAR2(50),
          ETHNICITY_SOURCE_VALUE    VARCHAR2(50),
          PN_GESTATIONAL_AGE        NUMBER(3,0),
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
DROP PACKAGE BODY I2B2_TO_OMOP_PERSON_PKG
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
PERSON_ID, YEAR_OF_BIRTH, MONTH_OF_BIRTH, 
   DAY_OF_BIRTH, GENDER_CONCEPT_ID, RACE_CONCEPT_ID, 
   ETHNICITY_CONCEPT_ID, 
NULL AS LOCATION_ID,
                    NULL AS PROVIDER_ID,
                    NULL AS CARE_SITE_ID,
PERSON_SOURCE_VALUE,
GENDER_SOURCE_VALUE, RACE_SOURCE_VALUE, 
   ETHNICITY_SOURCE_VALUE,
 NULL AS PN_GESTATIONAL_AGE,
                    NULL AS PN_TIME_OF_BIRTH
FROM MV_PERSON
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
DROP PACKAGE I2B2_TO_OMOP_VISIT_PKG
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
          VISIT_OCCURRENCE_ID        NUMBER(38,0),
          PERSON_ID                NUMBER(38,0),
          VISIT_START_DATE            DATE,
          VISIT_END_DATE            DATE,
          PLACE_OF_SERVICE_CONCEPT_ID   NUMBER(38,0),
          CARE_SITE_ID          NUMBER(38,0),
          PLACE_OF_SERVICE_SOURCE_VALUE VARCHAR2(50),
          PROVIDER_ID            NUMBER(19,0)
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
DROP PACKAGE BODY I2B2_TO_OMOP_VISIT_PKG
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
DROP PACKAGE I2B2_TO_OMOP_VITALS_PKG
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
          --OBSERVATION_ID    NUMBER(38,0),
          PERSON_ID    NUMBER(38,0),
          OBSERVATION_CONCEPT_ID    NUMBER(38,0),
          OBSERVATION_DATE    DATE,
          OBSERVATION_TIME    VARCHAR2(10 BYTE),
          VALUE_AS_NUMBER    FLOAT,
          VALUE_AS_STRING    VARCHAR2(60 BYTE),
          VALUE_AS_CONCEPT_ID    NUMBER(38,0),
          UNIT_CONCEPT_ID    NUMBER(38,0),
        RANGE_LOW            NUMBER(38,0),
        RANGE_HIGH           NUMBER(38,0),
       OBSERVATION_TYPE_CONCEPT_ID    NUMBER(38,0),
         ASSOCIATED_PROVIDER_ID    NUMBER(38,0),
          VISIT_OCCURRENCE_ID    NUMBER(38,0),
         RELEVANT_CONDITION_CONCEPT_ID    NUMBER(38,0),
         OBSERVATION_SOURCE_VALUE    VARCHAR2(50 BYTE),
          UNITS_SOURCE_VALUE    VARCHAR2(50 BYTE)
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
DROP PACKAGE BODY I2B2_TO_OMOP_VITALS_PKG
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
DROP PACKAGE I2B2_TO_OMOP_DX_PKG
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
          --CONDITION_OCCURRENCE_ID    NUMBER(38,0)
          PERSON_ID    NUMBER(38,0),
          CONDITION_CONCEPT_ID    NUMBER(38,0),
          CONDITION_START_DATE    DATE,
          CONDITION_END_DATE    DATE,
          CONDITION_TYPE_CONCEPT_ID    NUMBER(38,0),
          STOP_REASON    VARCHAR2(20 BYTE),
          ASSOCIATED_PROVIDER_ID    NUMBER(38,0),
          VISIT_OCCURRENCE_ID    NUMBER(38,0),
          CONDITION_SOURCE_VALUE    VARCHAR2(50 BYTE)
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
DROP PACKAGE BODY I2B2_TO_OMOP_DX_PKG
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
DROP PACKAGE I2B2_TO_OMOP_PROCS_PKG
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
        --PROCEDURE_OCCURRENCE_ID     NUMBER(38,0),
        PERSON_ID                 NUMBER(38,0),
        PROCEDURE_CONCEPT_ID        NUMBER(38,0),
        PROCEDURE_DATE            DATE,
        PROCEDURE_TYPE_CONCEPT_ID    NUMBER(38,0),
        ASSOCIATED_PROVIDER_ID        NUMBER(38,0),
        VISIT_OCCURRENCE_ID        NUMBER(38,0),
        RELEVANT_CONDITION_CONCEPT_ID    NUMBER(38,0),
        PROCEDURE_SOURCE_VALUE        VARCHAR2(50 BYTE)
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
DROP PACKAGE BODY I2B2_TO_OMOP_PROCS_PKG
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
DROP PACKAGE I2B2_TO_OMOP_OBSV_PERIOD_PKG
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
        --OBSERVATION_PERIOD_ID             NUMBER(38,0),
        PERSON_ID                         NUMBER(38,0),
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
DROP PACKAGE BODY I2B2_TO_OMOP_OBSV_PERIOD_PKG
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
DROP PACKAGE I2B2_TO_OMOP_CONDERA_PKG
/
CREATE OR REPLACE PACKAGE I2B2_TO_OMOP_CONDERA_PKG IS
    -- global constant
    newLine CONSTANT char(1) := chr( 10 ) ;
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

PROCEDURE sp_Load_Data (Is_Successful OUT NUMBER);

PROCEDURE sp_Load_Cond_Era_Tbl(
                        p_commit_interval          number,
                        p_persistence_window          number,
                        p_concept_source             varchar2,
                        p_concept_file               varchar2,
                        p_concept_vocabulary_codes   varchar2,
                        p_concept_classes          varchar2,
                        p_concept_levels          varchar2,
                        p_concept_minsep          varchar2,
                        p_concept_maxsep          varchar2,
                        p_event_schema               varchar2,
                        p_event_table             varchar2,
                        p_event_start_date          varchar2,
                        p_event_end_date          varchar2,
                        p_event_person_id          varchar2,
                        p_event_concept_id          varchar2,
                        p_event_refills              varchar2,
                        p_event_quantity             varchar2,
                        p_event_days                 varchar2,
                        p_event_type                 varchar2,
                        p_vocab_schema               varchar2,
                        p_vocab_con_table            varchar2,
                        p_vocab_anc_table            varchar2,
                        p_vocab_anc_field            varchar2,
                        p_vocab_des_field            varchar2,
                        p_ref_description_value      varchar2,
                        p_ref_vocabulary_name        varchar2,
                        p_era_schema                 varchar2,
                        p_era_table                  varchar2,
                        p_era_id                     varchar2,
                        p_era_start_date             varchar2,
                        p_era_end_date               varchar2,
                        p_era_person_id              varchar2,
                        p_era_concept_id             varchar2,
                        p_era_type                   varchar2,
                        p_era_count                  varchar2
                      , restart_sequence             boolean DEFAULT TRUE
                      , debug                        boolean DEFAULT FALSE
                      );

END I2B2_TO_OMOP_CONDERA_PKG;
/
DROP PACKAGE BODY I2B2_TO_OMOP_CONDERA_PKG
/
CREATE OR REPLACE PACKAGE BODY I2B2_TO_OMOP_CONDERA_PKG is
   
   
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
   
   PROCEDURE sp_condition_era_sequence( p_restart_sequence BOOLEAN DEFAULT TRUE , p_commit_interval NUMBER)
    IS
    /*
       IF restart_squence is TRUE
          drop and create sequence
       ELSE -- restart is false
         IF sequence does not exist
            create sequence
         END IF -- sequence does not exits
       END IF -- restart is TRUE
    */
    lv_execute_string VARCHAR2( 250 );
    sequence_count    NUMBER;
    BEGIN
       IF p_restart_sequence
       THEN
          lv_execute_string := 'drop SEQUENCE CONDITION_ERA_SEQ';
          BEGIN
             execute immediate lv_execute_string;
             EXCEPTION  -- ignore error if sequence did not exist
             WHEN OTHERS THEN
                null;
          END;

          lv_execute_string := 'CREATE SEQUENCE CONDITION_ERA_SEQ '
                            || 'MINVALUE 1 NOMAXVALUE '
                            || 'INCREMENT BY 1 START WITH 1 CACHE '|| p_commit_interval ||' NOORDER  NOCYCLE' ;

          execute immediate lv_execute_string;
       ELSE -- continue using existing sequence
          SELECT count(*)
            INTO sequence_count
            FROM user_sequences
           WHERE sequence_name = 'CONDITION_ERA_SEQ';

          IF sequence_count = 0
          THEN -- sequence does not exist
             lv_execute_string := 'CREATE SEQUENCE CONDITION_ERA_SEQ '
                               || 'MINVALUE 1 NOMAXVALUE '
                               || 'INCREMENT BY 1 START WITH 1 CACHE '|| p_commit_interval ||' NOORDER  NOCYCLE' ;

             execute immediate lv_execute_string;

          END IF; -- sequence exists
       END IF; -- restart
    END sp_condition_era_sequence;


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
      -- Execute Load Condition_Era Table Process
      ----------------------------------------------------------------
          
        g_Err_Comment := 'Execute Load Condition Era Table Process';
        sp_Load_Cond_Era_Tbl(
  p_commit_interval          =>  100000
, p_persistence_window       =>  30
, p_concept_source           => 'N'
, p_concept_file             =>  null
, p_concept_vocabulary_codes =>  NULL
, p_concept_classes          =>  null
, p_concept_levels           =>  NULL
, p_concept_minsep           =>  null
, p_concept_maxsep           =>  null
, p_event_schema             =>  USER
, p_event_table              => 'CONDITION_OCCURRENCE'
, p_event_start_date         => 'CONDITION_START_DATE'
, p_event_end_date           => 'CONDITION_END_DATE'
, p_event_person_id          => 'PERSON_ID'
, p_event_concept_id         => 'CONDITION_CONCEPT_ID'
, p_event_refills            =>  null
, p_event_days               =>  null
, p_event_quantity           =>  null
, p_event_type               => 'CONDITION_TYPE_CONCEPT_ID'
, p_vocab_schema             => 'OMOP_ETL'
, p_vocab_con_table          =>  null
, p_vocab_anc_table          =>  null
, p_vocab_anc_field          =>  null
, p_vocab_des_field          =>  null
, p_ref_vocabulary_name      => 'OMOP Condition Occurrence Type'
, p_ref_description_value    => 'Condition era - 30 days persistence window'
, p_era_schema               =>  USER
, p_era_table                => 'CONDITION_ERA'
, p_era_id                   => 'CONDITION_ERA_ID'
, p_era_start_date           => 'CONDITION_ERA_START_DATE'
, p_era_end_date             => 'CONDITION_ERA_END_DATE'
, p_era_person_id            => 'PERSON_ID'
, p_era_concept_id           => 'CONDITION_CONCEPT_ID'
, p_era_type                 => 'CONDITION_TYPE_CONCEPT_ID'
, p_era_count                => 'CONDITION_OCCURRENCE_COUNT'
, restart_sequence           =>  FALSE 
, debug                      =>  FALSE 
);
        
        COMMIT;
        dbms_output.put_line('I2B2_TO_OMOP_CONDERA_PKG ' || Is_Successful);

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
   
    PROCEDURE sp_Load_Cond_Era_Tbl(
                        p_commit_interval          number,
                        p_persistence_window         number,
                        p_concept_source          varchar2,
                        p_concept_file               varchar2,
                        p_concept_vocabulary_codes   varchar2,
                        p_concept_classes          varchar2,
                        p_concept_levels          varchar2,
                        p_concept_minsep          varchar2,
                        p_concept_maxsep          varchar2,
                        p_event_schema               varchar2,
                        p_event_table              varchar2,
                        p_event_start_date          varchar2,
                        p_event_end_date          varchar2,
                        p_event_person_id          varchar2,
                        p_event_concept_id          varchar2,
                        p_event_refills          varchar2,
                        p_event_quantity             varchar2,
                        p_event_days                 varchar2,
                        p_event_type                 varchar2,
                        p_vocab_schema               varchar2,
                        p_vocab_con_table            varchar2,
                        p_vocab_anc_table            varchar2,
                        p_vocab_anc_field            varchar2,
                        p_vocab_des_field            varchar2,
                        p_ref_description_value      varchar2,
                        p_ref_vocabulary_name        varchar2,
                        p_era_schema                 varchar2,
                        p_era_table                  varchar2,
                        p_era_id                     varchar2,
                        p_era_start_date             varchar2,
                        p_era_end_date               varchar2,
                        p_era_person_id              varchar2,
                        p_era_concept_id             varchar2,
                        p_era_type                   varchar2,
                        p_era_count                  varchar2
                      , restart_sequence             boolean DEFAULT TRUE
                      , debug                        boolean DEFAULT FALSE
                      ) IS

      ----------------------------------------------------------------
      -- Initialize Procedure
      ----------------------------------------------------------------
        
        g_Err_Comment varchar2(100) := 'Initialize Procedure';
        g_Process_Name varchar2(100) := 'I2B2 To COND_ERA Table';
        g_Err_Procedure varchar2(100) := 'sp_Load_Cond_Era_Tbl';
        Is_Successful NUMBER := 0;
        
        g_Err_Comment varchar2(1000) := 'Load OMOP Condition_Era Table';

       lv_source_name                  VARCHAR2(2);      -- local variable to store the source name
       lv_etl_name                     VARCHAR2(20);     -- local variable to store the etl name
       lv_commit_interval              VARCHAR2(20) := p_commit_interval;  -- Commit Interval retrived from Parameter table.
       lv_return_flag                  VARCHAR2(1);      -- Flag to hold the value returned by the called routine
       lv_ref_pers_win                 NUMBER ;          -- local variable to store the Persistence window

       lv_drug_flag                    VARCHAR2(1) := 'N'; -- local variable to store if this is a DRUG run

       /*************************************************************
        * Setup of all the Arrays for BULK SELECT and FORALL LOADING
        *************************************************************/

       TYPE person_id_aat                  IS TABLE OF number                 INDEX BY PLS_INTEGER;
       TYPE concept_id_aat                 IS TABLE OF number                 INDEX BY PLS_INTEGER;
       TYPE start_date_aat                 IS TABLE OF date                   INDEX BY PLS_INTEGER;
       TYPE end_date_aat                   IS TABLE OF date                   INDEX BY PLS_INTEGER;
       TYPE lv_count_aat                   IS TABLE OF number                 INDEX BY PLS_INTEGER;

       in_person_ids                          person_id_aat;
       in_concept_ids                         concept_id_aat;
       in_start_dates                         start_date_aat;
       in_end_dates                           end_date_aat;

       out_person_ids                         person_id_aat;
       out_concept_ids                        concept_id_aat;
       out_start_dates                        start_date_aat;
       out_end_dates                          end_date_aat;
       out_lv_counts                          lv_count_aat;

       out_person_ids_clr                     person_id_aat;
       out_concept_ids_clr                    concept_id_aat;
       out_start_dates_clr                    start_date_aat;
       out_end_dates_clr                      end_date_aat;
       out_lv_counts_clr                      lv_count_aat;

      
       out_indx                                number := 0;

       lv_pers_window                          number := p_persistence_window;

       /*************************************************************
       * Cursor to get the source data
       * from  Condition Era table , from the Intermediate table
       **************************************************************/
      CURSOR get_generic_cur IS
           SELECT   /*+ parallel(DE, 16) */
                     DE.gen_person_Id,
                     DE.gen_start_date,
                     decode(sign(nvl(DE.gen_end_date,DE.gen_start_date)
                                     -DE.gen_start_date),
                                 -1, DE.gen_start_date,
                                  0, DE.gen_start_date,
                                  1, DE.gen_end_date)  as gen_end_date,
                     DE.gen_ancestor_concept_id
            FROM     OMOP_ETL_GEN_MAP DE
            ORDER BY DE.gen_person_id,
                     DE.gen_ancestor_concept_id,
                     DE.gen_start_date asc,
                     decode(sign(nvl(DE.gen_end_date,DE.gen_start_date)
                                                     -DE.gen_start_date),
                                 -1, DE.gen_start_date,
                                  0, DE.gen_start_date,
                                  1, DE.gen_end_date);

       cursor get_cnt_of_view_map is
          select count(*) from OMOP_ETL_GEN_MAP;

       lv_log_type         VARCHAR2(3)   ; -- local variable to store log type (ERR,REJ,WAR,LOG)
       lv_log_code         VARCHAR2(100) ; -- local variable to store error / log messamslr
       lv_log_descr        VARCHAR2(250) ;  -- local variable to store error / log messamslr
       lv_comments         VARCHAR2(250) ;  -- local variable to store the error / log details
       lv_ret_flag_o       VARCHAR2(1)   ;  -- local variable to store the return success/failure code from error/log procedure

       lv_ref_tbl_i        VARCHAR2(30) ;   -- local variable to store the Ref Type Table name
       lv_domain_i         VARCHAR2(20) ;            -- local variable to store the Domain name
       lv_ref_type_descr_i VARCHAR2(120) ;  -- local variable to store the Ref Type
       lv_ref_type_o       NUMBER := 38000247;          -- local variable to get the Ref Type as out parameter

       lv_first_start_dt   Date;            -- local variable to store the start date of the drug exposure
       lv_last_end_dt      Date;            -- local variable to store the end date of the drug exposure

       lv_prev_person_id   Number :=0;      -- local variable to store the previous person id in the cursor loop
       lv_prev_start_dt    Date;            -- local variable to store the previous start date in the cursor loop
       lv_prev_end_dt      Date;            -- local variable to store the previous end date in the cursor loop
       lv_prev_concept_id  Number :=0;      -- local variable to store the previous concept id in the cursor loop

       lv_curr_person_id   Number;          -- local variable to store the current person id in the cursor loop
       lv_curr_start_dt    Date;            -- local variable to store the current start date in the cursor loop
       lv_curr_end_dt      Date;            -- local variable to store the current end date in the cursor loop
       lv_curr_concept_id  Number;          -- local variable to store the current concept id in the cursor loop

       lv_count            Number := 0;     -- local variable to store the occurence count.

       lv_type_value_cnt   Number := 0;
       lv_totalread_cnt    Number := 0;

       lv_type_value_selcnt  Number := 0;

       lv_record_cnt       Number := 0;
       lv_error_msg        Varchar2(2000);
       lv_error_seq        Number := 0;
       lv_fetch_limit      Number := to_number(p_commit_interval);

       lv_execute_string     varchar2(2000);
       lv_cursor_string      varchar2(2000);
       lv_vocab_value      varchar2(1);

       /*************************************
        * Some field definitions needed for *
        * Observations and Procedures.      *
        *************************************/

       TYPE cursor_open IS REF CURSOR;
       get_tabref_type      cursor_open;

       lv_field_1         varchar2(30);
       lv_field_2         varchar2(30);
       lv_field_3         varchar2(30);
       lv_field_4         varchar2(30);
       lv_field_5         varchar2(30);
       lv_field_6         varchar2(30);
       lv_field_7         varchar2(30);

     /*******************************************************************
      *                Possible Errors being generated.
      *******************************************************************/

       wrong_type_value             EXCEPTION;          -- User defined Exception to handle errors in subroutines
       PRAGMA            exception_init(wrong_type_value   , -24381); -- Associate Error Codes with user defined exceptions

       mandatory_value_not_entered  EXCEPTION;          -- User defined Exception to handle errors in subroutines
       PRAGMA            exception_init(mandatory_value_not_entered , -24382); -- Associate Error Codes with user defined exceptions

       vocab_fields_not_provided  EXCEPTION;          -- User defined Exception to handle errors in subroutines
       PRAGMA            exception_init(vocab_fields_not_provided , -24383); -- Associate Error Codes with user defined exceptions

       vocab_file_not_provided  EXCEPTION;          -- User defined Exception to handle errors in subroutines
       PRAGMA            exception_init(vocab_file_not_provided , -24384); -- Associate Error Codes with user defined exceptions

       concept_filename_not_exist EXCEPTION;          -- User defined Exception to handle errors in subroutines
       PRAGMA            exception_init(concept_filename_not_exist , -24385); -- Associate Error Codes with user defined exceptions

       table_or_view_not_exist EXCEPTION;
       PRAGMA            exception_init( table_or_view_not_exist, -00942 );

BEGIN

     /*----------------------------------------------------------------
      *     Check to make sure all Non-optional Fields have values.
      *----------------------------------------------------------------*/

     if (p_commit_interval is null or
         p_persistence_window is null or
         p_concept_source is null or
         p_event_schema is null or
         p_event_table is null or
         p_event_start_date is null or
         p_event_person_id is null or
         p_event_concept_id is null or
         p_ref_description_value is null or
         p_ref_vocabulary_name is NULL or
         p_era_schema is null or
         p_era_table is null or
         p_era_id is null or
         p_era_start_date is null or
         p_era_end_date is null or
         p_era_person_id is null or
         p_era_concept_id is null or
         p_era_type is null or
         p_era_count is null) then

         raise mandatory_value_not_entered;

     end if;


     /*----------------------------------------------------------------
      *     Check to see if this is a DRUG run.
      *----------------------------------------------------------------*/

     if (p_event_days is not null) then
        lv_drug_flag := 'Y';
     end if;


     /*----------------------------------------------------------------
      *     Check to make sure if p_concept_source equal V or C.
      *----------------------------------------------------------------*/

     if p_concept_source = 'V' then  -- Vocabulary
        if (p_concept_vocabulary_codes is null and
            p_concept_classes is null and
            p_concept_levels  is null and
            p_concept_minsep  is null and
            p_concept_maxsep  is null) then

           raise vocab_fields_not_provided;

        end if;
     elsif p_concept_source = 'C' then  -- custom source
        if (p_concept_file is null) then

           raise vocab_file_not_provided;

        end if;
     end if;


/************************************************************************************
     Next three statements are drop... and it doesn't matter if they exist
     or not, the statements are fired and this cleans up pre-tables and pre-views.
 ************************************************************************************/

     lv_execute_string := 'drop table OMOP_ETL_VOCAB_MAP';

     begin
        execute immediate lv_execute_string;
     exception
        WHEN OTHERS THEN
             null;
     end;

     lv_execute_string := 'drop table OMOP_ETL_GEN_MAP';

     begin
        execute immediate lv_execute_string;
     exception
        WHEN OTHERS THEN
             null;
     end;

     lv_execute_string := 'drop view OMOP_ETL_GEN_MAP';

     begin
        execute immediate lv_execute_string;
     exception
        WHEN OTHERS THEN
             null;
     end;

     -- create sequence
     sp_condition_era_sequence( restart_sequence, p_commit_interval );

     /*---------------------------------------------
      *  Get the Ref Type Concept from Vocabulary
      *---------------------------------------------*/

     lv_cursor_string := 'SELECT concept_id' || newLine
                      || '  FROM concept'  || newLine
                      || '  JOIN vocabulary USING( vocabulary_id )'  || newLine
                      || ' WHERE vocabulary_name = ''' || p_ref_vocabulary_name || '''' || newLine
                      || '   AND concept_name = ''' || p_ref_description_value || '''';


     IF DEBUG THEN dbms_output.put_line( lv_cursor_string || newLine ); END IF;

     open get_tabref_type for lv_cursor_string;
     fetch get_tabref_type  into lv_ref_type_o;
     close get_tabref_type;

     lv_ref_pers_win := p_persistence_window;

     IF (p_concept_source = 'V' or p_concept_source = 'C') then
        IF (p_concept_source = 'V') then
           lv_execute_string :=
               'create table OMOP_ETL_VOCAB_MAP '            || newLine ||
               '       PARALLEL(DEGREE 4) '                  || newLine ||
               '       UNRECOVERABLE '                       || newLine ||
               '       AS  '                                 || newLine ||
               '       SELECT     /*+ PARALLEL(ans,4) */  '     || newLine ||
               '               ans.' || p_vocab_anc_field || ' as gen_voc_ancestor_concept_id, ' || newLine ||
               '               ans.' || p_vocab_des_field || ' as gen_voc_descendant_concept_id' || newLine ||
               '       FROM     ' || p_vocab_schema || '.' || p_vocab_anc_table || ' ans,'        || newLine ||
               '               ' || p_vocab_schema || '.' || p_vocab_con_table || ' con '        || newLine ||
               '       WHERE     con.vocabulary_id '           ||
                               case
                                  when p_concept_vocabulary_codes is null
                                  then
                                       'like ''%'' '
                                  else
                                       'IN (' || p_concept_vocabulary_codes || ') '
                                  end                   || newLine ||
               '       AND     con.concept_level '   ||
                               case
                                  when p_concept_levels is null then
                                       'like ''%'' '
                                  else
                                       'IN (' || p_concept_levels || ') '
                                  end                || newLine ||
               '       AND     con.concept_class '   ||
                               case
                                  when p_concept_classes is null then
                                       'like ''%'' '
                                  else
                                       'IN (' || p_concept_classes || ') '
                                  end                || newLine ||
               '       AND     ans.min_levels_of_separation '            ||
                               case
                                  when p_concept_minsep is null then
                                       'like ''%'' '
                                  else
                                       'IN (' || p_concept_minsep || ') '
                                  end                                                    || newLine ||
               '       AND     ans.max_levels_of_separation '                                       ||
                               case
                                  when p_concept_maxsep is null then
                                       'like ''%'' '
                                  else
                                       'IN (' || p_concept_maxsep || ') '
                                  end                                                    || newLine ||
               '       AND     con.concept_id = ans.ancestor_concept_id '                || newLine ||
               '       UNION ALL '                                                       || newLine ||
               '       SELECT    con.concept_id  gen_voc_ancestor_concept_id, '            || newLine ||
               '               con.concept_id  gen_voc_descendant_concept_id '           || newLine ||
               '       FROM    concept con '                                  || newLine ||
               '       WHERE    con.vocabulary_id '                             ||
                               case
                                  when p_concept_vocabulary_codes is null then
                                       'like ''%'' '
                                  else
                                       'IN (' || p_concept_vocabulary_codes || ') '
              end                                                       || newLine ||
               '       AND     con.concept_class '                                       ||
                               case
                                  when p_concept_classes is null then
                                       'like ''%'' '
                                  else
                                       'IN (' || p_concept_classes || ') '
                               end                                                    || newLine ||
               '       AND     con.concept_level '                                       ||
                               case
                                  when p_concept_levels is null then
                                       'like ''%'' '
                                  else
                                       'IN (' || p_concept_levels || ') '
                               end;

          IF DEBUG THEN dbms_output.put_line( lv_execute_string || newLine ); END IF;

          execute immediate lv_execute_string;

        ELSIF (p_concept_source = 'C') then  -- Custom
           lv_execute_string :=
                'CREATE TABLE OMOP_ETL_VOCAB_MAP
                ( '  || newLine ||
                '  GEN_VOC_ANCESTOR_CONCEPT_ID NUMBER, ' || newLine ||
                '  GEN_VOC_DESCENDANT_CONCEPT_ID NUMBER '  || newLine ||
                ') '                                  || newLine ||
                'ORGANIZATION EXTERNAL ( '            || newLine ||
                '  TYPE ORACLE_LOADER '               || newLine ||
                '  DEFAULT DIRECTORY ext_tables '     || newLine ||
                '  ACCESS PARAMETERS ( '              || newLine ||
                '    RECORDS DELIMITED BY NEWLINE '   || newLine ||
                '    FIELDS TERMINATED BY ''|'' '       || newLine ||
                '    MISSING FIELD VALUES ARE NULL '  || newLine ||
                '  ) '                                || newLine ||
                '  LOCATION (''' || p_concept_file || ''') '    || newLine ||
                ') '                                  || newLine ||
                'PARALLEL 5 '                         || newLine ||
                'REJECT LIMIT UNLIMITED';

           IF DEBUG THEN dbms_output.put_line( lv_execute_string || newLine ); END IF;
           execute immediate lv_execute_string;

           lv_execute_string := 'select count(*) from omop_etl_vocab_map';

           begin
              execute immediate lv_execute_string;
           exception
              when OTHERS then
                 raise concept_filename_not_exist;
           end;

        END IF;


        lv_execute_string :=
        'create global temporary table OMOP_ETL_GEN_MAP ' || newLine ||
        --'     parallel 8 ' || newLine ||
        --'     NOLOGGING ' || newLine ||
                ' ON COMMIT PRESERVE ROWS ' || newLine ||
        ' AS SELECT /*+ parallel(A,8) */  ' || newLine ||
        '           map.gen_voc_ancestor_concept_id  AS gen_ancestor_concept_id, ' || newLine ||
        '           A.' || p_event_person_id || '                        AS gen_person_id, ' || newLine ||
        case
        when lv_drug_flag = 'Y'
        then
        '       A.' || p_event_start_date || ' AS gen_start_date, ' || newLine ||
        '       CASE WHEN A.' || p_event_type || ' = 38000179' || newLine ||
        '            THEN a.' || p_event_start_date  || newLine ||
        '            WHEN a.' || p_event_end_date || ' IS NOT NULL ' || newLine ||
        '            THEN greatest( a.' || p_event_start_date || ', a.' || p_event_end_date || ')' || newLine ||
        '            WHEN NVL( a.' || p_event_days || ', 0 ) > 0 ' || newLine ||
        '            THEN a.' || p_event_start_date || ' + a.' || p_event_days || newLine ||
        '            WHEN NVL( a.' || p_event_quantity || ', 0 ) > 0 ' || newLine ||
        '            THEN a.' || p_event_start_date || ' + a.' || p_event_quantity || newLine ||
        '            WHEN NVL( a.' || p_event_refills || ', 0 ) > 0 ' || newLine ||
        '            THEN a.' || p_event_start_date || ' + ( ( 1 + a.' || p_event_refills || ' ) * 30 )' || newLine ||
        '            ELSE a.' || p_event_start_date || ' + 30 ' || newLine ||
        '      END AS gen_end_date,  ' || newLine ||
        '       A.' || p_event_concept_id || '            AS gen_descendant_concept_id '
        when lv_drug_flag = 'N'
        then
        '       A.' || p_event_start_date || ' AS gen_start_date, ' || newLine ||
        '       nvl(A.' || nvl(p_event_end_date, p_event_start_date) || ', A.' || p_event_start_date || ') AS gen_end_date,  ' || newLine ||
        '       A.' || p_event_concept_id || '            AS gen_descendant_concept_id '
        end  || newLine ||
        '   from   ' || p_event_schema || '.' || p_event_table || ' A, OMOP_ETL_VOCAB_MAP map ' || newLine ||
        '   where  map.gen_voc_descendant_concept_id = A.' || p_event_concept_id || ' ' || newLine ||
        '     and  A.' || p_event_concept_id || ' <> 0 ' 
                ;

        IF DEBUG THEN dbms_output.put_line( lv_execute_string || newLine ); END IF;
        execute immediate lv_execute_string;

        lv_type_value_cnt := SQL%ROWCOUNT;


     ELSE /* p_concept_source = N */
        lv_execute_string := 'create or replace view OMOP_ETL_GEN_MAP ' ||
                             '     as select ' ||
                                      '      ' || p_event_concept_id || ' AS gen_ancestor_concept_id, '  ||  newLine ||
                                      '      ' || p_event_person_id  || ' AS gen_person_id, '            || newLine ||
                                      '      ' || p_event_start_date || ' AS gen_start_date, '           || newLine ||
                                      '      ' || nvl(p_event_end_date, p_event_start_date)   || ' AS gen_end_date,  '            || newLine ||
                                      '      ' || p_event_concept_id || ' AS gen_descendant_concept_id ' || newLine ||
                                      '      from ' || p_event_schema || '.' || p_event_table || newLine ||
                                      '      where  ' || p_event_concept_id || ' <> 0 ';

        IF DEBUG THEN dbms_output.put_line( lv_execute_string || newLine ); END IF;
        execute immediate lv_execute_string;

        open get_cnt_of_view_map;
        fetch get_cnt_of_view_map into lv_type_value_cnt;
        close get_cnt_of_view_map;

     END IF;

     open get_generic_cur;
     loop
           fetch get_generic_cur
                 bulk collect into in_person_ids,
                                   in_start_dates,
                                   in_end_dates,
                                   in_concept_ids
                                   limit lv_fetch_limit;

       lv_totalread_cnt := lv_totalread_cnt + in_person_ids.count;

       for lv_i in in_person_ids.FIRST .. in_person_ids.LAST
       loop

          lv_record_cnt      := lv_record_cnt + 1;

          lv_curr_person_id  := in_person_ids(lv_i);
          lv_curr_start_dt   := in_start_dates(lv_i);
          lv_curr_end_dt     := in_end_dates(lv_i);
          lv_curr_concept_id := in_concept_ids(lv_i);

          -- Check if the person id matches between the current row and previous row of the cursor
          IF lv_curr_person_id = lv_prev_person_id THEN

             IF lv_curr_concept_id = lv_prev_concept_id THEN

                IF (lv_last_end_dt + lv_ref_pers_win >= lv_curr_start_dt) THEN

                  IF (lv_curr_start_dt < lv_first_start_dt ) THEN
                      lv_first_start_dt := lv_curr_start_dt;
                   END IF;

                   IF (lv_curr_end_dt > lv_last_end_dt ) THEN
                      lv_last_end_dt := lv_curr_end_dt;
                   END IF;

                   lv_count := lv_count + 1 ;

                ELSE
                   out_indx := out_indx + 1;

                   out_person_ids(out_indx)       := lv_prev_person_id;
                   out_start_dates(out_indx)      := lv_first_start_dt;
                   out_end_dates(out_indx)        := lv_last_end_dt;
                   out_concept_ids(out_indx)      := lv_prev_concept_id;
                   out_lv_counts(out_indx)        := lv_count;

                   lv_count          := 1;
                   lv_first_start_dt := lv_curr_start_dt;
                   lv_last_end_dt    := lv_curr_end_dt;
                END IF;
             ELSE
                out_indx := out_indx + 1;

                out_person_ids(out_indx)       := lv_prev_person_id;
                out_start_dates(out_indx)      := lv_first_start_dt;
                out_end_dates(out_indx)        := lv_last_end_dt;
                out_concept_ids(out_indx)      := lv_prev_concept_id;
                out_lv_counts(out_indx)        := lv_count;

                lv_first_start_dt := lv_curr_start_dt;
                lv_last_end_dt    := lv_curr_end_dt;
                lv_count          := 1;
             END IF;

          ELSE

            -- *------------------------------
            -- * If Prev and Current Persons are different
            -- * And If the current row is not very first row
            -- * of the cursor then Insert a row to Era Table
            -- *--------------------------------

             IF lv_record_cnt <> 1 THEN

                out_indx := out_indx + 1;

                out_person_ids(out_indx)       := lv_prev_person_id;
                out_start_dates(out_indx)      := lv_first_start_dt;
                out_end_dates(out_indx)        := lv_last_end_dt;
                out_concept_ids(out_indx)      := lv_prev_concept_id;
                out_lv_counts(out_indx)        := lv_count;

             END IF;

             lv_first_start_dt := lv_curr_start_dt;
             lv_last_end_dt    := lv_curr_end_dt;
             lv_count          := 1 ;

          END IF;

          lv_prev_person_id  := lv_curr_person_id;
          lv_prev_start_dt   := lv_curr_start_dt;
          lv_prev_end_dt     := lv_curr_end_dt;
          lv_prev_concept_id := lv_curr_concept_id;

       end loop; -- For lv_i in in_person_ids

          -- *------------------------------
          -- * If the current row is the last row of the
          -- * source data then Insert a row to Era Table
          -- *--------------------------------
          -- Assign the cursor's current row of data to local variables

       IF lv_record_cnt = lv_type_value_cnt then
             out_indx := out_indx + 1;

             out_person_ids(out_indx)       := lv_curr_person_id;
             out_start_dates(out_indx)      := lv_first_start_dt;
             out_end_dates(out_indx)        := lv_last_end_dt;
             out_concept_ids(out_indx)      := lv_curr_concept_id;
             out_lv_counts(out_indx)        := lv_count;
       END IF;

       lv_execute_string := 'insert /*+ APPEND NOLOGGING */ ' || newLine ||
                            '       into ' || p_era_schema || '.' || p_era_table || newLine ||
                          '      (' || p_era_id         || ',' || newLine ||
                            '       ' || p_era_concept_id || ',' || newLine ||
                            '       ' || p_era_person_id  || ',' || newLine ||
                            '       ' || p_era_start_date || ',' || newLine ||
                            '       ' || p_era_end_date   || ',' || newLine ||
                            '       ' || p_era_count      || ',' || newLine ||
                            '       ' || p_era_type       || ') ' || newLine ||
                          'VALUES( CONDITION_ERA_SEQ.NEXTVAL, ' || newLine ||
                            '       :1, ' || newLine ||
                            '       :2, ' || newLine ||
                            '       :3, ' || newLine ||
                            '       :4, ' || newLine ||
                            '       :5, ' || newLine ||
                            '       :6)';

       IF DEBUG THEN dbms_output.put_line( lv_execute_string || newLine ); END IF;
       forall indx in out_person_ids.first .. out_person_ids.last
            execute immediate lv_execute_string
                        using out_concept_ids(indx),
                              out_person_ids(indx),
                              out_start_dates(indx),
                              out_end_dates(indx),
                              out_lv_counts(indx),
                              lv_ref_type_o;

       commit;

       lv_type_value_selcnt := lv_type_value_selcnt + out_person_ids.count;

       out_person_ids       := out_person_ids_clr;
       out_start_dates      := out_start_dates_clr;
       out_end_dates        := out_end_dates_clr;
       out_concept_ids      := out_concept_ids_clr;
       out_lv_counts        := out_lv_counts_clr;

       exit WHEN get_generic_cur%NOTFOUND;
     end loop; -- Cursor loop

     commit;

     close get_generic_cur;


      ----------------------------------------------------------------
      -- Log Process
      ----------------------------------------------------------------
      
       -- g_Err_Comment := 'Log Process';
        g_Process_End_Date := SYSTIMESTAMP;

select count(*)
into g_Row_Count
from Condition_Era;

        -- Get error count, success variables
        WITH CTE_ERRORS
        AS
          (
            SELECT NVL(
              (
                SELECT 
                  COUNT(*) ERROR_ROW_CNT
                FROM ERR$_CONDITION_ERA
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

EXCEPTION
    /*------------------------------------------------------------
     * When no Parameter found then write the
     * error details to OMOP_ETL_LOG_TBL table
     *------------------------------------------------------------*/
     WHEN WRONG_TYPE_VALUE THEN
          dbms_output.put_line('**********************************************************************');
          dbms_output.put_line('*** ERROR *** - Type Values need to be defined.');
          dbms_output.put_line('**********************************************************************');
          
           INSERT
    INTO TBL_ERR_MSG (MODULE_NAME, ERR_MSG, ERR_TIME)
    VALUES('SP_LOAD_COND_ERA_TBL',   'Wrong_Type_Value - Type Values need to be defined.',   SYSTIMESTAMP);
COMMIT;

     WHEN MANDATORY_VALUE_NOT_ENTERED THEN
          dbms_output.put_line('**********************************************************************');
          dbms_output.put_line('*** ERROR *** - ALL Mandatory fields not provided.');
          dbms_output.put_line('**********************************************************************');

 INSERT
    INTO TBL_ERR_MSG (MODULE_NAME, ERR_MSG, ERR_TIME)
    VALUES('SP_LOAD_COND_ERA_TBL',   'Mandatory_Value_Not_Entered - ALL Mandatory fields not provided.',   SYSTIMESTAMP);
COMMIT;

     WHEN VOCAB_FIELDS_NOT_PROVIDED THEN
          dbms_output.put_line('**********************************************************************');
          dbms_output.put_line('*** ERROR *** - Vocabulary option has been chosen but NOT one of the ' || newLine ||
                               'Vocab fields has anything in them of the ALL Mandatory fields not provided.');
          dbms_output.put_line('**********************************************************************');

INSERT
    INTO TBL_ERR_MSG (MODULE_NAME, ERR_MSG, ERR_TIME)
    VALUES('SP_LOAD_COND_ERA_TBL',   'Vocab_Fields_Not_Provided - Vocabulary option has been chosen but NOT one of the Vocab fields has anything in them of the ALL Mandatory fields not provided.',   SYSTIMESTAMP);
COMMIT;

     WHEN VOCAB_FILE_NOT_PROVIDED THEN
          dbms_output.put_line('**********************************************************************');
          dbms_output.put_line('*** ERROR *** - Vocabulary File option has been chosen but the ' || newLine ||
                               'Concept File has not been provided as a parameter.');
          dbms_output.put_line('**********************************************************************');

 INSERT
    INTO TBL_ERR_MSG (MODULE_NAME, ERR_MSG, ERR_TIME)
    VALUES('SP_LOAD_COND_ERA_TBL',   'VOCAB_FILE_NOT_PROVIDED - Vocabulary File option has been chosen but the Concept File has not been provided as a parameter.',   SYSTIMESTAMP);
COMMIT;

     WHEN CONCEPT_FILENAME_NOT_EXIST THEN
          dbms_output.put_line('**********************************************************************');
          dbms_output.put_line('*** ERROR *** - Vocabulary File option has been chosen but the ' || newLine ||
                               'Concept File doesn''t exist or permissions where file reside, is not set right.');
          dbms_output.put_line('**********************************************************************');

 INSERT
    INTO TBL_ERR_MSG (MODULE_NAME, ERR_MSG, ERR_TIME)
    VALUES('SP_LOAD_COND_ERA_TBL',   'CONCEPT_FILENAME_NOT_EXIST - Vocabulary File option has been chosen but the Concept File doesn''t exist or permissions where file reside, is not set right.',   SYSTIMESTAMP);
COMMIT;

     WHEN TABLE_OR_VIEW_NOT_EXIST THEN
          dbms_output.put_line('**********************************************************************');
          dbms_output.put_line('*** ERROR *** - Table does not exist ' || newLine ||
                               lv_execute_string );
          dbms_output.put_line('**********************************************************************');

 INSERT
    INTO TBL_ERR_MSG (MODULE_NAME, ERR_MSG, ERR_TIME)
    VALUES('SP_LOAD_COND_ERA_TBL',   'TABLE_OR_VIEW_NOT_EXIST -' || lv_execute_string,   SYSTIMESTAMP);
COMMIT;

END sp_Load_Cond_Era_Tbl;
END I2B2_TO_OMOP_CONDERA_PKG;
/
DROP PACKAGE I2B2_TO_OMOP_DEATH_PKG
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
          PERSON_ID                     NUMBER(38,0),
          DEATH_DATE                DATE,
          DEATH_TYPE_CONCEPT_ID            NUMBER(38,0),
          CAUSE_OF_DEATH_CONCEPT_ID    NUMBER(38,0),
          CAUSE_OF_DEATH_SOURCE_VALUE    VARCHAR2(50)
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
DROP PACKAGE BODY I2B2_TO_OMOP_DEATH_PKG
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
