--=============================================================================
--
-- NAME
--
-- i2b2_omop_procedures.sql
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
-- Under OMOP_ETL schema run below procedures scripts, needed for to refresh 
-- materialized views,analyze materialized views and gather all table stats 
-- exists under OMOP_ETL schema.
-- 
--=============================================================================
CREATE OR REPLACE PROCEDURE SP_OMOP_MVS_TBL_STATS(p_object_stattype IN VARCHAR2) AS
user_name VARCHAR2(20) := null;
stme VARCHAR2(4000) := Null;
ct NUMBER := 0;
emsg      VARCHAR2(1000);
ert       TIMESTAMP;
begin

SELECT SYS_CONTEXT('USERENV','SESSION_USER') into user_name from DUAL;

if (p_object_stattype = 'MV') then 
--Refreshing MV's
 for i in (Select MVIEW_NAME 
           from ALL_MVIEWS
           order by MVIEW_NAME )
        loop
        
        -- Checking If MView exists
         select count(*) into ct  from  user_objects where object_name=  i.MVIEW_NAME and object_type = 'MATERIALIZED VIEW';
         if ct >0 
         Then 
            ct:= NUll;  
            
        -- compile MV's

                select 'alter materialized view '||i.MVIEW_NAME||' compile '  into stme from dual; 
                --DBMS_OUTPUT.put_line(stme);  
                Execute Immediate stme;
                stme:= null ;
        
        -- refresh MV's                
                select 'alter materialized view '||i.MVIEW_NAME||'  refresh complete '  into stme from dual; 
                --DBMS_OUTPUT.put_line(stme);  
                Execute Immediate stme;
                stme:= null ;
                
                
                  dbms_mview.REFRESH(
                   LIST                 => i.MVIEW_NAME  
                  ,PUSH_DEFERRED_RPC    => FALSE
                  ,REFRESH_AFTER_ERRORS => FALSE
                  ,PURGE_OPTION         => 1
                  ,PARALLELISM          => 4
                  ,ATOMIC_REFRESH       => FALSE
                  );
           

 -- Analyzing Materialized views
 
                                  DBMS_STATS.GATHER_TABLE_STATS ( 
                                   ownname        => user_name 
                                  ,tabname        => i.MVIEW_NAME
                                  ,Estimate_Percent  => DBMS_STATS.AUTO_SAMPLE_SIZE
                                  ,Degree            => 4
                                  ,Cascade           => DBMS_STATS.AUTO_CASCADE
                                  ,No_Invalidate     =>DBMS_STATS.AUTO_INVALIDATE 
                                  ,granularity=> 'AUTO' 
                                  ,method_opt=> 'FOR ALL COLUMNS SIZE AUTO');   
     end if;                                    
  end loop;
end if;

if (p_object_stattype = 'TBL') then

--Analyzing TBL's
 for j in (Select OBJECT_NAME AS TBL_NAME
           from USER_OBJECTS
           WHERE OBJECT_TYPE = 'TABLE'
           order by OBJECT_NAME )
        loop
        
        -- Checking If MView exists
         select count(*) into ct  from  user_objects where object_name=  j.TBL_NAME and object_type = 'TABLE';
         if ct >0 
         Then 
            ct:= NUll;  
       
-- Analyzing user tables
 
                                  DBMS_STATS.GATHER_TABLE_STATS ( 
                                   ownname        => user_name 
                                  ,tabname        => j.TBL_NAME
                                  ,Estimate_Percent  => DBMS_STATS.AUTO_SAMPLE_SIZE
                                  ,Degree            => 4
                                  ,Cascade           => DBMS_STATS.AUTO_CASCADE
                                  ,No_Invalidate     =>DBMS_STATS.AUTO_INVALIDATE 
                                  ,granularity=> 'AUTO' 
                                  ,method_opt=> 'FOR ALL COLUMNS SIZE AUTO');   
           end if;                               
  end loop;
end if;   
EXCEPTION
  WHEN OTHERS THEN
    EMSG := sqlerrm;
    SELECT SYSTIMESTAMP
    INTO ERT
    FROM DUAL;
    INSERT
    INTO TBL_ERR_MSG (MODULE_NAME, ERR_MSG, ERR_TIME)
    VALUES('SP_OMOP_MVS_TBL_STATS',   EMSG,   ERT);
COMMIT;
END SP_OMOP_MVS_TBL_STATS;
/
CREATE OR REPLACE PROCEDURE SP_OMOP_PREPARE_STATS
as
   user_name VARCHAR2(200);
   emsg      VARCHAR2(1000);
   ert       TIMESTAMP;
begin
 select sys_context('USERENV','SESSION_USER') into user_name from dual;
dbms_stats.gather_schema_stats(
ownname=> user_name,
estimate_percent=> DBMS_STATS.AUTO_SAMPLE_SIZE,
block_sample=> FALSE,
method_opt=> 'FOR ALL COLUMNS SIZE AUTO',
degree=> DBMS_STATS.DEFAULT_DEGREE,
granularity=> 'ALL',
cascade=> DBMS_STATS.AUTO_CASCADE,
stattab=> NULL,
statid=> NULL,
options=> 'GATHER',
statown=> NULL,
no_invalidate=> DBMS_STATS.AUTO_INVALIDATE,
gather_temp=> TRUE,
gather_fixed=> FALSE,
force=> TRUE,
obj_filter_list=> NULL);
EXCEPTION
  WHEN OTHERS THEN
    EMSG := sqlerrm;
    SELECT SYSTIMESTAMP
    INTO ERT
    FROM DUAL;
    INSERT
    INTO TBL_ERR_MSG (MODULE_NAME, ERR_MSG, ERR_TIME)
    VALUES('SP_OMOP_PREPARE_STATS',   EMSG,   ERT);
COMMIT;
END SP_OMOP_PREPARE_STATS;
/
