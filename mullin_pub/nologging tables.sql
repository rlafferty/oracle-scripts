
-- This query return tables that were created with the No Logging Option 
Select owner, table_name, logging, temporary, duration, last_analyzed, num_rows
from dba_tables 
where logging = 'NO'