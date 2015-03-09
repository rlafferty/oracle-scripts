

-- First Load the log file(s) you want to mine.
-- The first one is NEW additional files are ADDFILE 
begin
sys.DBMS_LOGMNR.ADD_LOGFILE (LOGFILENAME => '/t027/u09/oracle/ssd3/log/.redo01g1.log',OPTIONS => sys.DBMS_LOGMNR.NEW);
--sys.DBMS_LOGMNR.ADD_LOGFILE (LOGFILENAME => '/t027/arch01/oracle/ssd3/arch_7.dbf',OPTIONS => sys.DBMS_LOGMNR.ADDFILE);
sys.dbms_logmnr.start_logmnr(options=>sys.dbms_logmnr.dict_from_online_catalog);
end;

-- Then you can view the contents with the applicable criteria 
select *
from V$LOGMNR_CONTENTS 
where seg_name = 'MJM_NOLOG'
order by timestamp desc