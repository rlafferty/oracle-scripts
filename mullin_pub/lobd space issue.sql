-- This query return the free space within a block for LOBD tablespace 
select dfs.tablespace_name, ddf.file_name, dfs.file_id,dfs.block_id, dfs.bytes/1024/1024 "FREE SPACE MB", ddf.bytes/1024/1024 "TOTAL SPACE MB"
from dba_free_space dfs, dba_data_files ddf
where dfs.tablespace_name = 'LOBD'
and 
dfs.file_id = ddf.file_id
order by 5 desc, 1
