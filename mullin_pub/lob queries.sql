-- This query identifes the number of times LOB attachments
-- have been accessed. 
select count(*)
from fnd_lob_access

-- This query identifies the counts of LOB's by Program Name 
-- FNDATTCH were loaded thru Core Apps Document form - 
-- FND_HELP are Help Files -
-- export are Temporary LOB's from when records are exported from Core Apps Forms -
-- Blank are uploaded from Web Interface , i.e. iProcurement -
SELECT program_name, COUNT(*) 
FROM applsys.fnd_lobs 
GROUP BY program_name;


-- This query return the file_name , count and Size of LOBs 
-- that have been loaded more then 30 times from Web Interface 				
select file_name, count(*),sum(dbms_lob.getlength(file_data))/1024/1024 Size_MB
from fnd_lobs
where program_name is null
group by file_name
having count(*) > 30

-- This query return the sum of all the LOBs in FND_LOBS in MB 				
select SUM(DBMS_LOB.GETLENGTH(FILE_DATA))/1024/1024
from fnd_lobs
	