-- This query parses the path of data files.  This data can then be used for refresh planning and re-distributing
-- space usage of an instance 
select substr(file_name,instr(file_name,'/',1,1)+1,(instr(file_name,'/',1,2)-instr(file_name,'/',1,1)-1)) mntpnt,
	   substr(file_name,instr(file_name,'/',1,2)+1,(instr(file_name,'/',1,3)-instr(file_name,'/',1,2)-1)) udir,
	   substr(file_name,instr(file_name,'/',1,3)+1,(instr(file_name,'/',1,4)-instr(file_name,'/',1,3)-1)) oracle,
	   substr(file_name,instr(file_name,'/',1,4)+1,(instr(file_name,'/',1,5)-instr(file_name,'/',1,4)-1)) sid,
	   substr(file_name,instr(file_name,'/',1,5)+1,(instr(file_name,'/',1,6)-instr(file_name,'/',1,5)-1)) dir_type,
	   substr(file_name,instr(file_name,'/',1,6)+1,(length(file_name)-instr(file_name,'/',1,6))) filename,
	   bytes/1024/1024 MB
from dba_data_files