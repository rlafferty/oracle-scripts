-- This is an example of steps required to move database datafiles to a new location 

select tablespace_name,file_name, bytes, bytes/1024/1024 MB
from dba_data_files
where tablespace_name in ('POX','INVX')



shutdown immediate

startup mount

cd /p032/u10/oracle/ssp1/data

unlink invx01.dbf

unlink invx02.dbf

unlink pox01.dbf

unlink pox02.dbf

unlink pox03.dbf

cp -p .invx01.dbf /p032/u02/oracle/ssp1/data

cp -p .invx02.dbf /p032/u02/oracle/ssp1/data

cp -p .pox01.dbf /p032/u05/oracle/ssp1/data

cp -p .pox02.dbf /p032/u05/oracle/ssp1/data

cp -p .pox03.dbf /p032/u05/oracle/ssp1/data

cd /p032/u02/oracle/ssp1/data

ln -s .invx01.dbf::cdev:vxfs: invx01.dbf 

ln -s .invx02.dbf::cdev:vxfs: invx02.dbf

cd /p032/u05/oracle/ssp1/data

ln -s .pox01.dbf::cdev:vxfs: pox01.dbf

ln -s .pox02.dbf::cdev:vxfs: pox02.dbf

ln -s .pox03.dbf::cdev:vxfs: pox03.dbf 

alter database rename file '/p032/u10/oracle/ssp1/data/invx01.dbf' to '/p032/u02/oracle/ssp1/data/invx01.dbf'

alter database rename file '/p032/u10/oracle/ssp1/data/invx02.dbf' to '/p032/u02/oracle/ssp1/data/invx02.dbf'

alter database rename file '/p032/u10/oracle/ssp1/data/pox01.dbf' to '/p032/u05/oracle/ssp1/data/pox01.dbf'

alter database rename file '/p032/u10/oracle/ssp1/data/pox02.dbf' to '/p032/u05/oracle/ssp1/data/pox02.dbf'

alter database rename file '/p032/u10/oracle/ssp1/data/pox03.dbf' to '/p032/u05/oracle/ssp1/data/pox03.dbf'