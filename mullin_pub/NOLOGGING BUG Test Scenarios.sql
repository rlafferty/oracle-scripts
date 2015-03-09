-- BUG 2898053 - ORA-14102 OCCURS WHEN CREATE TABLE WITH LOGGING AND NOLOGGING 
CREATE TABLE MJM_TEST (     A NUMBER,     CONSTRAINT EMP_BAK_PK PRIMARY KEY ( A ) USING INDEX     LOGGING ) NOLOGGING;

drop table mjm_test

-- BUG 3039033 - PARTITION SPLIT CAUSING INDEX TO CHANGE FROM NOLOGGING TO LOGGING 
1. Create tablespace users_nolog

     create tablespace users_nolog     datafile '<your_file_path>' size 5M     nologging     online;

Check logging status of tablespace

     select  tablespace_name,logging 
     from dba_tablespaces  
	 where tablespace_name='USERS_NOLOG';

2. Create partition table test2

CREATE TABLE test2  ( 	FIELD1	NUMBER(15) NOT    NULL, 	FIELD2 NUMBER(8) NOT NULL ) 
 pctfree 0 pctused 40  initrans 2 maxtrans 255 	parallel monitoring 	
 partition by range (FIELD2)  subpartition by hash (FIELD1) subpartitions 4  
 store in (users_nolog) 	
( 	partition   part_2003_M02 values less than (20030301) tablespace users_nolog, 	
    partition  part_maxvalue values less than (maxvalue) tablespace users_nolog 	) ;

3. Create index idxtest2

CREATE bitmap INDEX idxtest2 ON test2 (    FIELD2 )  
 pctfree 0 initrans 2 maxtrans 255  	local 	
( 	partition    part_2003_M02 		tablespace users_nolog, 	
    partition part_maxvalue 		tablespace users_nolog 	) 	
parallel nologging ;

4. Load some data

     Insert into test2 values (1, 20010301); 
	 Insert into test2 values (1, 20020300); 
	 Insert into test2 values (1, 00030301); 
	 Insert into test2 values (1, 10040301); 
	 Insert into test2 values (1, 20030405); 
	 Insert into test2 values (1, 20030325); 
	 Insert into test2 values (1, 20030326); 
	 Insert into test2 values (1, 20030505); 
	 Insert into test2 values (1, 20030605); 

5. Check logging status of index

     select index_name,partition_name,subpartition_name,logging  
     from dba_ind_subpartitions 
	 where index_name= 'IDXTEST2';
 
INDEX_NAME                     PARTITION_NAME 	  	 		 SUBPARTITION_NAME              LOG 
------------------------------ ------------------------------ ------------------------------ --- 
IDXTEST2                       PART_2003_M02 				   SYS_SUBP9       				 NO
IDXTEST2                       PART_2003_M02                   SYS_SUBP10     				 NO
IDXTEST2                       PART_2003_M02 				   SYS_SUBP11      				 NO
IDXTEST2                       PART_2003_M02 				   SYS_SUBP12                    NO 


6. Split partition PART_MAXVALUE

   alter table test2   split partition PART_MAXVALUE at (20030401) into (partition PART_2003_M03   tablespace users_nolog nologging subpartitions 4  store in (users_nolog), 
                             partition PART_MAXVALUE tablespace users_nolog  nologging subpartitions 4  store in (users_nolog)  ) ;

Check logging status

     select index_name,partition_name,subpartition_name,logging  
     from dba_ind_subpartitions 
	 where index_name= 'IDXTEST2';

INDEX_NAME                     PARTITION_NAME 				  SUBPARTITION_NAME              LOG 
------------------------------ ------------------------------ ------------------------------ --- 
IDXTEST2                       PART_2003_M02 				  SYS_SUBP9                      NO
IDXTEST2                       PART_2003_M02 				  SYS_SUBP10                     NO
IDXTEST2                       PART_2003_M02 				  SYS_SUBP11                     NO
IDXTEST2                       PART_2003_M02 				  SYS_SUBP12                     NO
IDXTEST2                       PART_2003_M03 				  SYS_SUBP17                     YES
IDXTEST2                       PART_2003_M03 				  SYS_SUBP18                     YES
IDXTEST2                       PART_2003_M03 				  SYS_SUBP19                     YES
IDXTEST2                       PART_2003_M03 				  SYS_SUBP20                     YES
IDXTEST2                       PART_MAXVALUE 				  SYS_SUBP13                     YES
IDXTEST2                       PART_MAXVALUE 				  SYS_SUBP14                     YES
IDXTEST2                       PART_MAXVALUE 				  SYS_SUBP15                     YES
IDXTEST2                       PART_MAXVALUE 				  SYS_SUBP16                     YES

-- BUG 2597533 - PARTITION OBJECT CREATED WITH NOLOGGING AND MODIFIED LATER GENERATES NO REDO 

Create a complex partition table with some of the partitions logging and  the others nologging. 
Create partitioned indexes with mixture of logging and  nologging. 
After a while, drop the index or rebuild the index with logging. 
Alter the  table partitions to logging. Perform some loading and the partitions created as nologging generate no redo. 
An export of the table and import with indexfile option indicates that the  partitions are still nologging. 
Redo dump for the object blocks also show no redo generated and standby  database has corrupted blocks due to these operations. 


-- BUG 2629977 - ALTER INDEX REBUILD NOLOGGING CHANGES LOGGING STATUS 

create table mjm_abc (col1 number); 

create index mjm_ind1 on mjm_abc(col1); 

alter index mjm_ind1 logging; 

select index_name,logging 
from ALL_INDEXES 
where index_name ='MJM_IND1'; 

INDEX_NAME	LOGGING
MJM_IND1	YES

alter index mjm_ind1 rebuild nologging; 

select index_name,logging 
from ALL_INDEXES 
where index_name ='MJM_IND1'; 

INDEX_NAME	LOGGING
MJM_IND1	NO

alter index mjm_ind1 rebuild logging; 

select index_name,logging 
from ALL_INDEXES 
where index_name ='MJM_IND1'; 

INDEX_NAME	LOGGING
MJM_IND1	YES

drop index mjm_ind1

drop table mjm_abc

-- BUG 2032864 - NOLOGGING GENERATE THE SAME OR MORE REDO THEN LOGGING 

drop table zzz; 

create table zzz as select * from sys.source$; 

drop table nlog_bbb; 

select * from v$statname where name='redo size'; 

select sid from v$session where audsid = userenv('sessionid');

alter system switch logfile; 

select v$log.group#, v$log.status, member 
from v$log, v$logfile 	
where v$log.group#=v$logfile.group#; 

select sid, statistic#, value 
from v$sesstat  	
where statistic#=115 and sid=10; 

create table nlog_bbb nologging as  	select * from zzz 	where rownum <100; 

select sid, statistic#, value from v$sesstat  	where statistic#=115 and sid=10; 

ALTER SYSTEM DUMP LOGFILE '<current logfile location>';

Second session:

select sid from v$session where audsid = userenv('sessionid');   

drop table log_aaa; 

alter system switch logfile; 

select v$log.group#, v$log.status, member 
from v$log, v$logfile 	
where v$log.group#=v$logfile.group#; 

select sid, statistic#, value 
from v$sesstat  	
where statistic#=115 and sid=10; 

create table log_aaa as  	select * from zzz 	where rownum <100; 

select sid, statistic#, value 
from v$sesstat  	
where statistic#=115 and sid=10; 

ALTER SYSTEM DUMP LOGFILE '<current logfile location>';

Part of the results:

select sid, statistic#, value from v$sesstat
where statistic#=115 and sid=10;

SID         STATISTIC#      VALUE 
---------- ---------- ----------         
10          115       13592

create table nlog_bbb nologging as
select * from zzz
where rownum <100;

Table created

select sid, statistic#, value 
from v$sesstat 
where statistic#=115 and sid=10;

SID   		STATISTIC#      VALUE 
---------- ---------- ----------         
10         115        33880  <------------- inc by 20288 

select sid, statistic#, value 
from v$sesstat
where statistic#=115 and sid=10;

SID   	    STATISTIC#      VALUE 
---------- ---------- ----------         
10         115        13288

create table log_aaa as
select * from zzz
where rownum <100;

Table created

select sid, statistic#, value 
from v$sesstat
where statistic#=115 and sid=10;

SID   		STATISTIC#      VALUE 
---------- ---------- ----------         
10         115        32800   <-------------inc by 19512  


-- BUG 3665682 - NOLOGGING DOESN'T WORK WITH 'PARTITION' IN DIRECT LOAD INSERT  

A partitioned table is nologging mode by alter table < table_name> nologging

insert /*+ append */ into TABLE2 partition(TABLE2_p1) select * from TABLE1;

If in the direct load you don't specify the partition where the data is going  to be inserted in nologging mode and the redo created is the expected.

insert /*+ append */ into TABLE2 select * from TABLE1;

[The result of redo size]
Case1.(with partition) 

select * 
from v$mystat 
where statistic#=98;        

SID         STATISTIC#      VALUE 
---------- ---------- ----------         
13         98          0    

insert /*+ append */ into direct2 partition(direct1_p1) select * from  direct1;    

select * 
from v$mystat 
where statistic#=98;        

SID         STATISTIC#      VALUE 
---------- ---------- ----------         
13         98       4368

Case2.(without partition) 

select * 
from v$mystat 
where statistic#=98; 

--'redo size'        
SID         STATISTIC#      VALUE 
---------- ---------- ----------         
13         98          0 

insert /*+ append */ into direct2 select * from direct1;

select * 
from v$mystat 
where statistic#=98;        

SID         STATISTIC#      VALUE 
---------- ---------- ----------         
13         98        224 

select PARTITION_NAME, logging 
from user_tab_partitions 
where table_name='DIRECT2';

PARTITION_NAME                 LOGGING 
------------------------------ ------- 
DIRECT1_P1                     NO 
DIRECT1_P2                     NO 
DIRECT1_P3                     NO 
DIRECT1_P4                     NO 

-- BUG 2994527 - ALTER TABLE LOGGING NOT WORKING ON IOT 

Index Organized Tables ( IOT ) created in a NOLOGGING tablespace can not be  altered to have logging turned on. 

create user foo identified by foo; 

grant dba to foo; 

alter user foo default tablespace users; 

connect foo/foo; 

alter tablespace users NOLOGGING; 

CREATE TABLE test(token char(20), doc_id NUMBER, CONSTRAINT  pk_test PRIMARY KEY (token)) ORGANIZATION INDEX  TABLESPACE USERS; 

select table_name,tablespace_name,logging 
from user_tables ; 

select index_name,table_name,tablespace_name,logging 
from user_indexes ; 

alter table test LOGGING; 

select table_name,tablespace_name,logging 
from user_tables ; 

select index_name,table_name,tablespace_name,logging 
from user_indexes ; 

alter tablespace users LOGGING; 

select table_name,tablespace_name,logging 
from user_tables ; 

select index_name,table_name,tablespace_name,logging 
from user_indexes ; 

-- BUG 1302087 - ORA-25182 WHEN CREATING IOT IN A TABLESPACE WITH NOLOGGING OPTION 

alter tablespace users nologging;

Tablespace altered

 
CREATE TABLE TTMMPP_83085_74(GGRROOUUPPBBYY VARCHAR(50), ordercol
INT, INDIV_EXT INT, GROUP_KEY INT, constraint TTMMPP_83085_74_pk   PRIMARY
KEY(GGRROOUUPPBBYY, ordercol, INDIV_EXT))  ORGANIZATION INDEX TABLESPACE
USERS PCTFREE 0; CREATE TABLE TTMMPP_83085_74(GGRROOUUPPBBYY VARCHAR(50), ordercol 

* ERROR at line 1: ORA-25182: feature not currently available for index-organized tables

alter tablespace users  logging;

Tablespace altered

   
CREATE TABLE TTMMPP_83085_74(GGRROOUUPPBBYY VARCHAR(50), ordercol
INT, INDIV_EXT INT, GROUP_KEY INT, constraint TTMMPP_83085_74_pk   PRIMARY
KEY(GGRROOUUPPBBYY, ordercol, INDIV_EXT))  ORGANIZATION INDEX TABLESPACE
USERS PCTFREE 0;

Table created. 


-- BUG 1112786 - INDEXES ARE CREATED WITH NOLOGGING WHICH IS NOT DESIRABLE FOR STANDBY DATABASE  

Need to create index with nologging on a table that is logging
perform inserts into table after cold backup
recover database and apply redo logs
select data from table based on index for data that was entered above


-- BUG - NOLOGGING HAS NO EFFECT FOR DML ON INDEXES 

Test was as follows:   

Table: CD_L_CALL_DATA   
Bitmap index: TEST_CD_I_CALLED_ICIP_ID (on column CD_CALLED_ICIP_ID).   
Load 1000 rows from source table KJB_SOME_CALLS 

Results:   
1. Load into table (logging), no index      
SQL: insert into CD_L_CALL_DATA select * from KJB_SOME_CALLS          where rownum <  1001;      
Redo generated (bytes): 76,716   

2. Load into table (nologging), no index      
SQL: insert into CD_L_CALL_DATA select * from KJB_SOME_CALLS              where rownum <  1001;      
Redo generated (bytes): 74,976      

This is expected as nologging is invalid for conventional path load   

3. Direct path load into table (nologging), no index      
SQL: insert /*+ append */ into CD_L_CALL_DATA select * from              KJB_SOME_CALLS where rownum <  1001;      
Redo generated (bytes): 224   

4. Direct path load into table (logging), no index      
SQL: insert /*+ append */ into CD_L_CALL_DATA select * from              KJB_SOME_CALLS where rownum <  1001;      
Redo generated (bytes): 72,080   

5. Load into table (logging), index (logging)      
SQL: insert into CD_L_CALL_DATA select * from KJB_SOME_CALLS              where rownum <  1001;      
Redo generated (bytes): 376,224      
Calculated redo for index: 300,000   

6. Load into table (nologging), index (logging)      
SQL: insert into CD_L_CALL_DATA select * from KJB_SOME_CALLS              where rownum <  1001;      
Redo generated (bytes): 366688   

7. Load into table (nologging), index (nologging)      
SQL: insert into CD_L_CALL_DATA select * from KJB_SOME_CALLS              where rownum <  1001;      
Redo generated (bytes): 366648 

The above test results lead us to the conclusion that redo is being logged for index changes, 
regardless of the LOGGING attribute on the index.  

-- BUG 3701657  - CTAS NOLOGGING STILL GENERATE SAME AMOUNT OF REDO RECORDS AS LOGGING OPTION. 

 This can be easily tested as following test case I use. 
 - create table test (text varchar2(30)); 
 - insert into test values ('bbbbbbbbbb'); 
 - commit; 
 Test CTAS with LOGGING: 
 - alter system switch logfile; 
 - select * from  v$log; (write down current redo group#) 
 - select member from v$logfile where group#=< above group#>; 
 - create table test_copy logging as select * from test; 
 - commit; 
 - alter system switch logfile; 
 - alter system dump logfile '< member from above>'; 
 Test CTAS with NOLOGGING: 
 - drop table test_copy; 
 - alter system switch logfile; 
 - select * from v$log; (write down current redo group#) 
 - select member from v$logfile where group#=< above group#>; 
 - create table test_copy nologging as select * from test; 
 - commit; 
 - alter system switch logfile; 
 - alter system dump logfile '< member from above>';
 
 Other than looking at the size of redo log you dump out, you can  count the redo records on each logfile by following command.  
 You will find  out  NOLOGGING has same amount as LOGGING (actually NOLOGGING will have one more  redo record than LOGGING) 
 which is contradictionary to the manual as well as  Metalink note 147474.1 where it states the NOLOGGING can be used for CTAS 
 to  reduce the overhead.  
 
 $ grep 'REDO RECORD' your_dump.trc | wc -l 
 
-- BUG  3220835 - EXPORT IGNORES LOGGING SETTING FOR TABLESPACES  
 
 TEST CASE: 
 ---------- 
 Create tablespace amb1 datafile '/testcase/920/abardeen/3407847.995/amb1.dbf'  size 10m extent management local uniform size 1m logging; 
 Create tablespace amb2 datafile '/testcase/920/abardeen/3407847.995/amb2.dbf'  size 10m extent management dictionary default storage (initial 1m next 1m  pctincrease 0) logging;
 
 SQL> select tablespace_name,logging 
      from dba_tablespaces 
	  where tablespace_name  like 'AMB%'
	  
TABLESPACE_NAME                LOGGING 
------------------------------ --------- 
AMB1                          LOGGING 
AMB2                          LOGGING 

exp anita/anita file=full1.dmp log=full1.log full=y rows=n 
imp anita/anita file=full1.dmp log=show.log full=y show=y

From the show=y import log file :

"CREATE TABLESPACE "AMB1" BLOCKSIZE 8192 DATAFILE  '/testcase/920/abardeen/3" "407847.995/amb1.dbf' SIZE 10485760      
EXTENT MANAGEMENT LOCAL  UNIFORM S" "IZE 1048576 ONLINE PERMANENT  NOLOGGING"

"CREATE TABLESPACE "AMB2" BLOCKSIZE 8192 DATAFILE  '/testcase/920/abardeen/3" "407847.995/amb2.dbf' SIZE 10485760      
EXTENT MANAGEMENT DICTIONARY  DEFA" "ULT NOCOMPRESS  STORAGE(INITIAL 1048576 NEXT 1048576 MINEXTENTS 1 MAXEXTENT" "S 505 PCTINCREASE 0) ONLINE PERMANENT  NOLOGGING" 


-- BUG 3050235 - HASH INDEX PARTITIONS REBUILDING WITH NOLOGGING WHEN LOGGING IS SET 

TEST CASE: 
---------- 
SQL> create table scubagear   
(id number, nam varchar2(60))partition by HASH(id)   
partitions 4   
store in (users);

Table created

SQL> select table_name,partition_name 
from user_tab_partitions 
where  table_name='SCUBAGEAR'; . 

TABLE_NAME                     PARTITION_NAME                                     
------------------------------ ------------------------------                     
SCUBAGEAR                      SYS_P26                                            
SCUBAGEAR                      SYS_P27                                            
SCUBAGEAR                      SYS_P28                                            
SCUBAGEAR                      SYS_P25                                            

SQL> create index scubagear_idx on scubagear(id) local nologging;

Index created

SQL> select logging,index_name 
from user_ind_partitions 
where  index_name='SCUBAGEAR_IDX';

LOGGING INDEX_NAME                                                                
------- ------------------------------                                            
NO      SCUBAGEAR_IDX                                                             
NO      SCUBAGEAR_IDX                                                             
NO      SCUBAGEAR_IDX                                                             
NO      SCUBAGEAR_IDX                                                             

SQL> begin   
for i in 1 .. 30000   
loop   
insert into scubagear values(i,'gear');   
end loop;   
end;   
/ 

PL/SQL procedure successfully completed

SQL> alter index scubagear_idx rebuild partition sys_p25;

Index altered

SQL> alter session set nls_date_format='mm-dd-yy hh:mi:ss';
Session altered

SQL>  select unrecoverable_time, unrecoverable_change# 
from v$datafile 
where  file#=3; 

UNRECOVERABLE_TIM UNRECOVERABLE_CHANGE# 
----------------- --------------------- 
07-14-03 11:49:25                446203 

SQL> alter index scubagear_idx logging; 

Index altered

SQL> select logging,inex_name 
from user_ind_partitions 
where  index_name='SCUBAGEAR_IDX';

LOGGING INDEX_NAME                                                                
------- ------------------------------                                            
YES     SCUBAGEAR_IDX                                                             
YES     SCUBAGEAR_IDX                                                             
YES     SCUBAGEAR_IDX                                                             
YES     SCUBAGEAR_IDX                                                             

SQL> alter index scubagear_idx rebuild partition sys_p26; 

Index altered

SQL>  select unrecoverable_time, unrecoverable_change# 
from v$datafile 
where  file#=3;

UNRECOVERABLE_TIM UNRECOVERABLE_CHANGE# 
----------------- --------------------- 
07-14-03 11:51:07                446215 

SQL> alter index scubagear_idx rebuild partition sys_p27 parallel; 

Index altered

SQL>  select unrecoverable_time, unrecoverable_change# 
from v$datafile where  file#=3; 

UNRECOVERABLE_TIM UNRECOVERABLE_CHANGE# 
----------------- --------------------- 
07-14-03 11:51:07                446215 

SQL> spool off; 

-- BUG 2849109 - LOGGING/NOLOGGING REPORTED INCORRECTLY FOR INDEX-ORGANIZED TABLES (IOT) 

Here is sample output from running the testcase included in this bug:

CREATE TABLE iot_table_a (id number, data_col varchar2(30), constraint  pk_iot_a primary key (id))   organization index tablespace indx logging   including id    overflow tablespace users nologging;
CREATE TABLE iot_table_b (id number, data_col varchar2(30), constraint  pk_iot_b primary key (id))   organization index tablespace indx nologging   including id   overflow tablespace users logging;

SQL> select index_name, TABLE_NAME, LOGGING 
from user_indexes;

INDEX_NAME                    TABLE_NAME                    LOG 
------------------------------ ------------------------------ --- 
PK_IOT_A                      IOT_TABLE_A                    NO 
PK_IOT_B                      IOT_TABLE_B                  	 NO 

+++Shouldn't one of them be logging?+++

SQL> select table_name, iot_name,iot_type, logging from user_tables;

TABLE_NAME                    IOT_NAME                      IOT_TYPE    LOG 
------------------------------ ------------------------------ ------------ --- 
IOT_TABLE_A                                                  IOT          YES 
IOT_TABLE_B                                                  IOT          NO 
SYS_IOT_OVER_31779            IOT_TABLE_A                    IOT_OVERFLOW NO 
SYS_IOT_OVER_31782            IOT_TABLE_B                    IOT_OVERFLOW YES

SQL> alter table IOT_TABLE_A logging;

Table altered

SQL> select index_name, TABLE_NAME, LOGGING from user_indexes;

INDEX_NAME                    TABLE_NAME                    LOG 
------------------------------ ------------------------------ --- 
PK_IOT_A                      IOT_TABLE_A                    YES 
PK_IOT_B                      IOT_TABLE_B                    NO 

+++Index logging changed, even though prevous alter table statement didn't  really change the table logging+++

SQL> select table_name, iot_name,iot_type, logging from user_tables;

TABLE_NAME                    IOT_NAME                      IOT_TYPE    LOG 
----------------------------- ------------------------------ ------------ --- 
IOT_TABLE_A                                                  IOT          YES 
IOT_TABLE_B                                                  IOT          NO 
SYS_IOT_OVER_31779            IOT_TABLE_A                    IOT_OVERFLOW NO 
SYS_IOT_OVER_31782            IOT_TABLE_B                    IOT_OVERFLOW YES 

*** 03/13/03 07:56 am *** Here is more sample output:

SQL> alter table IOT_TABLE_A logging;

Table altered.

SQL> select index_name, TABLE_NAME, LOGGING from user_indexes;

INDEX_NAME                    TABLE_NAME                    LOG 
------------------------------ ------------------------------ --- 
PK_IOT_A                      IOT_TABLE_A                    YES 
PK_IOT_B                      IOT_TABLE_B                  	 NO

SQL> select table_name, iot_name,iot_type, logging from user_tables;

TABLE_NAME                    IOT_NAME                      IOT_TYPE     LOG 
------------------------------ ------------------------------ ------------ --- 
IOT_TABLE_A                                                  IOT          YES 
IOT_TABLE_B                                                  IOT          NO 
SYS_IOT_OVER_31779            IOT_TABLE_A                    IOT_OVERFLOW NO 
SYS_IOT_OVER_31782            IOT_TABLE_B                    IOT_OVERFLOW YES 

SQL> select table_name, iot_name,iot_type, logging from user_tables;

TABLE_NAME                     IOT_NAME                       IOT_TYPE     LOG 
------------------------------ ------------------------------ ------------ --- 
IOT_TABLE_A                                                   IOT          YES 
IOT_TABLE_B                                                   IOT          NO 
SYS_IOT_OVER_31995             IOT_TABLE_A                    IOT_OVERFLOW NO 
SYS_IOT_OVER_31998             IOT_TABLE_B                    IOT_OVERFLOW YES 

SQL> alter table IOT_TABLE_A overflow logging; 

Table altered.

SQL> select table_name, iot_name,iot_type, logging from user_tables; 

TABLE_NAME                     IOT_NAME                       IOT_TYPE     LOG 
------------------------------ ------------------------------ ------------ --- 
IOT_TABLE_A                                                   IOT          YES 
IOT_TABLE_B                                                   IOT          NO 
SYS_IOT_OVER_31995             IOT_TABLE_A                    IOT_OVERFLOW NO 
SYS_IOT_OVER_31998             IOT_TABLE_B                    IOT_OVERFLOW YES 

+++Even though alter table statement shows that logging was altered,  user_tables/dba_tables shows that it wasn't+++ 

-- BUG 2896807 - NOLOGGING STATUS OF SUBPARTITIONS RESET WHEN ADDING SUBPARTITION 

TEST CASE: 
---------- 
drop table sales2; 

CREATE TABLE sales2 (item INTEGER, qty INTEGER, store VARCHAR(30), dept NUMBER, sale_date DATE)    
PARTITION BY RANGE (sale_date)    SUBPARTITION BY HASH(item)    SUBPARTITIONS 2 STORE IN (users, users)    
(PARTITION q1_1997       VALUES LESS THAN (TO_DATE('01-apr-1997', 'dd-mon-yyyy')),     
 PARTITION q2_1997       VALUES LESS THAN (TO_DATE('01-jul-1997', 'dd-mon-yyyy')),     
 PARTITION q3_1997       VALUES LESS THAN (TO_DATE('01-oct-1997', 'dd-mon-yyyy'))       
 (SUBPARTITION q3_1997_s1 TABLESPACE users,        
  SUBPARTITION q3_1997_s2 TABLESPACE users,        
  SUBPARTITION q3_1997_s3 TABLESPACE users,        
  SUBPARTITION q3_1997_s4 TABLESPACE users),     
  PARTITION q4_1997       VALUES LESS THAN (TO_DATE('01-jan-1998', 'dd-mon-yyyy'))       
  SUBPARTITIONS 2       STORE IN (users,users),     
  PARTITION q1_1998       VALUES LESS THAN (TO_DATE('01-apr-1998', 'dd-mon-yyyy'))); 

alter table sales2 modify partition q3_1997 nologging; 

alter table sales2 modify partition q3_1997 add subpartition q3_1997_s5 tablespace users ; 

select table_name,partition_name,subpartition_name,logging 
from dba_tab_subpartitions 
where table_name = 'SALES2' 
and partition_name = 'Q3_1997'; 

-- BUG 2683222 - 

PROBLEM: 
--------  
1. Clear description of the problem encountered:
If you create a partitioned table with no loggin on some partitions and then  decide later that you want 
logging on the partitions the you can not change  the logging status with out recreating the table. 

TEST CASE 
========== 

CREATE TABLE "NOL_TEST2" ("AS_OF" DATE, "STORAGE_OBJ_REF_ID1" NUMBER,   CONSTRAINT "PK_TEST1" PRIMARY KEY ("AS_OF", "STORAGE_OBJ_REF_ID1") ENABLE ) ORGANIZATION INDEX  NOCOMPRESS PCTFREE 10 INITRANS 2 MAXTRANS 255 NOLOGGING 
STORAGE( PCTINCREASE 0) TABLESPACE "TOOLS" PCTTHRESHOLD 50 PARTITION BY RANGE ("AS_OF") 
( PARTITION "NOL_TEST_010520011" VALUES LESS THAN (TO_DATE(' 2001-01-06  00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN')) PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE(INITIAL 15728640) TABLESPACE "TOOLS" LOGGING, 
PARTITION "NOL_TEST_071320011" VALUES LESS THAN (TO_DATE(' 2001-07-14  00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))  PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE(INITIAL 15728640) TABLESPACE "TOOLS" NOLOGGING, 
PARTITION "NOL_TEST_072120011" VALUES LESS THAN (TO_DATE(' 2001-07-22  00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))  PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE(INITIAL 15728640) TABLESPACE "TOOLS" NOLOGGING, 
PARTITION "NOL_TEST_072920011" VALUES LESS THAN (TO_DATE(' 2001-07-30  00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))  PCTFREE 10 INITRANS 2 MAXTRANS 255 
STORAGE(INITIAL 15728640) TABLESPACE "TOOLS" NOLOGGING, 
PARTITION "NOL_TEST_MAXVALUE1" VALUES LESS THAN (MAXVALUE)  PCTFREE 10  INITRANS 2  MAXTRANS 255 
STORAGE(INITIAL 15728640) TABLESPACE "TOOLS"  NOLOGGING );

Table Created 

select partition_name,logging 
from user_tab_partitions 
where table_name='NOL_TEST2'; 

PARTITION_NAME                 LOGGING 
------------------------------ ------- 
NOL_TEST_010520011             YES 
NOL_TEST_071320011             NO 
NOL_TEST_072120011             NO 
NOL_TEST_072920011             NO 
NOL_TEST_MAXVALUE1             NO

alter table nol_test2 modify partition NOL_TEST_010520011 NOlogging;

Table altered

select partition_name,logging 
from DBA_tab_partitions 
where table_name='NOL_TEST2'; 

PARTITION_NAME    			  LOGGING 
------------------------------ ------- 
NOL_TEST_010520011             YES 
NOL_TEST_071320011             NO 
NOL_TEST_072120011             NO 
NOL_TEST_072920011             NO 
NOL_TEST_MAXVALUE1             NO 
 
drop TABLE "NOL_TEST2"


-- BUG  2553486 - DIRECT LOAD TO AN IOT GENERATING TOO MUCH REDOLOGS  

TEST CASE: 
---------- 
As Schema Owner:   

drop table source; 
drop table dest; 
drop table dest_iot;   

create table source (col number(11) not null) nologging tablespace users pctfree 0;   

create table dest (col number(11) not null) nologging tablespace users pctfree 0;   

create table dest_iot (col number(11) not null, constraint col_pk primary key (col)) 
organization index nologging tablespace users pctfree 0;   

begin   
for i in 1..100000 loop     
insert into source     values (i+1000000);   
end loop; 
end; 
/   

commit 
/   

As SYS: 

select name, value 
from v$sysstat 
where       statistic#=120;   

NAME                                                                 VALUE 
----------------------------------------------------------------   --------- 
redo blocks written                                                   641480   

As Schema Owner: 

insert /*+ APPEND */ into dest select * from source;

commit;    

As SYS: 

select name, value from v$sysstat where           statistic#=120;   

NAME                                                                 VALUE 
----------------------------------------------------------------   --------- 
redo blocks written                                                   641566   

As Schema Owner: 

insert /*+ APPEND */ into dest_iot select * from      source;

commit;   

As SYS: 

select name, value from v$sysstat where           statistic#=120;   

NAME                                                                 VALUE 
----------------------------------------------------------------   --------- 
redo blocks written                                                   649842   

In summary Redo usage is   

Populate dest           86 
Populate dest_iot       8276 

This is not a bug. . 

Please refer to documentation Oracle9i SQL Reference Release 1 (9.0.1) Part Number A90125-01 
Under the heading "Conventional and Direct-Path INSERT " . 

The target table cannot be index organized or clustered.  . 
where it says  "Direct-path INSERT is subject to a number of restrictions. 
If any of these  restrictions is violated, Oracle executes conventional INSERT serially without  returning any message (unless otherwise noted)"

Hence closing this as not a bug and as an expected behaviour. 

-- BUG - SIMPLE INSERT PERFORMED IN NOLOGGING MODE ON CLOB COLUMN  

SQL> drop table my_clob; 

Table dropped

SQL> CREATE TABLE "MY_CLOB" ("NOME" VARCHAR2(20) NOT NULL,   
"C_NOME" CLOB NOT NULL)   
TABLESPACE users   
STORAGE ( INITIAL 100K NEXT 100K MAXEXTENTS UNLIMITED   
PCTINCREASE 0) LOB("C_NOME") STORE AS ( TABLESPACE   
users   
STORAGE ( INITIAL 1M NEXT 2M MAXEXTENTS UNLIMITED PCTINCREASE   0)   DISABLE  STORAGE IN ROW  NOCACHE  NOLOGGING CHUNK 16K PCTVERSION 10);

Table created

SQL> connect system/manager 
Connected

SQL> select file_id 
from dba_extents 
where owner='JACK' and segment_name='MY_CLOB'; 

FILE_ID 
----------          
9          
9 

SQL> select unrecoverable_change#, unrecoverable_time   
from v$datafile where file#=9;

UNRECOVERABLE_CHANGE# UNRECOVER 
--------------------- ---------            
6.5270E+12 26-JUN-03

SQL> connect jack/jack 
Connected

SQL> INSERT INTO MY_CLOB VALUES ('sdasdasdada', 'adfasdfasdfasdfasdf');

1 row created

SQL> commit;

Commit complete

SQL> connect system/manager 

Connected

SQL> select unrecoverable_change#, unrecoverable_time   
from v$datafile where file#=9; 

UNRECOVERABLE_CHANGE# UNRECOVER 
--------------------- ---------            
6.5270E+12 08-AUG-03 

-- BUG 2998634 - CTAS WITH NOLOGGING OPTION GENERATES REDO  

TEST CASE: 
---------- 
1. Backup the database using RMAN run {allocate channel d1 type disk;        
   backup        incremental level = 0        (database include current controlfile) ; } 
   
2. create table nolog_table as select * from dba_users nologging; 

3. Backup all the archive logs. . run { allocate channel d1 type disk; backup ( archivelog all delete input); } 

4. Restore and recover the database. . run { shutdown immediate; startup nomount; sql "alter database mount"; allocate channel d1 type disk;        restore database ;        recover database ;        sql "alter database open"; }

After this, the nolog_table is still there with all the data.

-- BUG 1387271 - EXPORT DOES NOT TAKE THE INDEX NOLOGGING CORRECTLY  


TESTCASE:
sqlplus /nolog < < EOF 
connect system/manager 
drop user jack cascade; 
create user jack identified by jack; 
grant connect, resource to jack; 
connect jack/jack 
create table a ( a number primary key); 
select index_name, logging from user_indexes; 
set heading off set feedback off set termout off 
spool uit.sql 
select 'alter index '|| index_name || ' nologging;' 
from user_indexes; 

spool off set heading on set feedback on set termout on select index_name, logging 
from user_indexes; 
EOF 
exp userid=system/manager owner=jack file=exp.dmp sqlplus /nolog < < EOF 

connect jack/jack 
drop table a; 
EOF 

imp userid=system/manager fromuser=jack touser=jack file=exp.dmp sqlplus /nolog < < EOF 

connect jack/jack 

select index_name, logging from user_indexes; 

EOF  

-- BUG 3294246 - UNRECOVERABLE_CHANGE# NOT UPDATED IN V$DATAFILE IN NOARCHIVELOG MODE 

TEST CASE: 
---------- 

select file#, unrecoverable_change#, unrecoverable_time 
from v$datafile
where unrecoverable_time is not null
order by unrecoverable_time desc

FILE#	UNRECOVERABLE_CHANGE#	UNRECOVERABLE_TIME
11		0						9/16/2004 9:13:25 AM
17		0						9/16/2004 9:13:25 AM
21		0						9/16/2004 9:13:25 AM
22		0						9/16/2004 9:13:25 AM


create table mjm_nolog tablespace users nologging as select * from dba_objects  where rownum <500; 

select *
from mjm_nolog

select file#, unrecoverable_change#, unrecoverable_time 
from v$datafile
where unrecoverable_time is not null
order by unrecoverable_time desc

FILE#	UNRECOVERABLE_CHANGE#	UNRECOVERABLE_TIME
11		0						9/16/2004 9:13:25 AM
17		0						9/16/2004 9:13:25 AM
21		0						9/16/2004 9:13:25 AM
22		0						9/16/2004 9:13:25 AM

insert /*+ append nologging */ into mjm_nolog select * from dba_objects where rownum < 500; 

rollback;

select file#, unrecoverable_change#, unrecoverable_time 
from v$datafile
where unrecoverable_time is not null
order by unrecoverable_time desc

FILE#	UNRECOVERABLE_CHANGE#	UNRECOVERABLE_TIME
7		8230187059757			11/11/2004 4:29:37 PM
11		0						9/16/2004 9:13:25 AM
17		0						9/16/2004 9:13:25 AM
21		0						9/16/2004 9:13:25 AM
22		0						9/16/2004 9:13:25 AM


insert into mjm_nolog select * from dba_objects where rownum < 500; 

select file#, unrecoverable_change#, unrecoverable_time 
from v$datafile
where unrecoverable_time is not null
order by unrecoverable_time desc

FILE#	UNRECOVERABLE_CHANGE#	UNRECOVERABLE_TIME
7		8230187059757			11/11/2004 4:29:37 PM
11		0						9/16/2004 9:13:25 AM
17		0						9/16/2004 9:13:25 AM
21		0						9/16/2004 9:13:25 AM
22		0						9/16/2004 9:13:25 AM

drop table mjm_nolog

select *
from v$database

-- BUG 2674102 - DIRECT LOAD IS STILL CAUSING REDO LOGGING  

Direct load with APPEND hint on table and index with nologging in tablespace  with nologging is still generating alot of redo. 


-- BUG 1517311 - APPEND HINT ON TABLE WITH NOLOGGING ATTRIBUTE IGNORED FROM WITHIN PL/SQL

Create a table with nologging first, then: 

----------- 
DECLARE       i   number; 

BEGIN    

EXECUTE IMMEDIATE 'TRUNCATE TABLE BOB_MSTFCST'; 

for i in 1..170000 loop      
INSERT /*+ append */ INTO BOB_MSTFCST b (fcsty,fcclr,fcdim,fcfyr,fcfpr,fcqtys)          
	   	   		  	 	  		values (to_char(i), 'CLR', 'dim', 'siz', 'yy','pr',123);    
end loop;    

commit;

END;

/

 