-- This script generates the DDL to re-create the Indexes in GESSS Schema 
--set serverout on size 100000
declare
 tableOpenHandle NUMBER;
 tableTransHandle NUMBER;
 indexTransHandle NUMBER;
 schemaName VARCHAR2(30);
 tableName VARCHAR2(30);
 tableDDLs sys.ku$_ddls;
 tableDDL sys.ku$_ddl;
 parsedItems sys.ku$_parsed_items;
 remainingLen NUMBER;
--
 BEGIN
--
dbms_output.enable(200000);
--
 -- Open a handle for tables in the current schema.
 tableOpenHandle := dbms_metadata.open('INDEX');
 --
  dbms_metadata.set_filter(tableOpenHandle, 'SCHEMA', 'GESSS');
 -- Retrieve DDLs for all tables in the schema. When the filter is 'NAME_EXPR', the filter value string
 -- must include the SQL operator. This gives the flexibility to use LIKE, IN, NOT IN, subqueries,
 -- dépendant objects such triggers, indexes , grants are not requested.
 dbms_metadata.set_filter(tableOpenHandle, 'NAME_EXPR','IN (Select index_name from dba_indexes where table_name not in (Select table_name from dba_tables where tablespace_name in (''GECUST'',''GECUSTX'')) and tablespace_name in (''GECUST'',''GECUSTX''))');
--
 -- Add the DDL transform so we get SQL creation DDL
 tableTransHandle := dbms_metadata.add_transform(tableOpenHandle, 'DDL');
--
 -- Tell the XSL stylesheet we don't want physical storage information
-- dbms_metadata.set_transform_param(tableTransHandle,
-- 'SEGMENT_ATTRIBUTES', FALSE);
-- that we want a SQL terminator on each DDL.
 dbms_metadata.set_transform_param(tableTransHandle,
 'SQLTERMINATOR', TRUE);
--
 -- Ready to start fetching tables. We use the FETCH_DDL interface
 -- This interface returns a SYS.KU$_DDLS; a table of SYS.KU$_DDL
 -- This is a table because some object types return multiple DDL statements (like types / pkgs
--
 LOOP
 tableDDLs := dbms_metadata.fetch_ddl(tableOpenHandle);
 EXIT WHEN tableDDLs IS NULL; -- exit the loop when all tables have been processed
--
 -- We know here, we have only one DDL per table, but if we want to separate constraints in another
 -- DDL, such ALTER TABLE , so we have to use a loop on TableDDls
 --
 --
 --
 -- We use a loop to display the DDL of the table contained in TableDDLs
 -- because we can’t display more than 255 caracters in one DBMS_OUTPUT
 tableDDL := tableDDLs(1);
 WHILE length(TableDDL.DDLText)>255
 LOOP
 --
 remainingLen := length(TableDDL.DDLText);
 --
 DBMS_OUTPUT.PUT_LINE(substr(TableDDL.ddltext,1,instr(TableDDL.ddltext,' ',(255 - remainingLen),1)));
 TableDDL.ddltext:=substr(TableDDL.ddltext,(instr(TableDDL.ddltext,' ',(255 - remainingLen),1)+1));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE(substr(TableDDL.ddltext,1,255));
--
 END LOOP; -- end of fetching
--
 -- Free resources allocated for table stream.
 dbms_metadata.close(tableOpenHandle);
--
--
 END;