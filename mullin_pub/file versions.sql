create table GEDBA.GEDBA_ONSITE_FILE_VERSIONS as
SELECT distinct name, type, upper(substr(text,(instr(text,':',2)+2),((instr(text,' ',1,3) - instr(text,' ',1,2))-1))) filename, substr(text,(instr(text,' ',1,3)+1),((instr(text,' ',1,4) - instr(text,' ',1,3))-1)) file_version
 FROM all_source
 WHERE text like '/* $Header%'

commit;
 
drop table GEDBA.GEDBA_ONSITE_FILE_VERSIONS
 
select a.* 
from ad_files a , gedba.gedba_onsite_file_versions b
where upper(a.FILENAME) = b.filename
 
select *
from gedba.gedba_onsite_file_versions
where upper(filename) in ('ADDDB.PLS')

select filename
from gedba.gedba_onsite_file_versions
where upper(filename) like '%PKH'
group by filename
having count(*) > 1)
order by filename

where upper(filename) like 'ICX%' 


update gedba.gedba_onsite_file_versions
set filename = rtrim(ltrim(FILENAME))

commit

create table gedba.gedba_check_file_versions as
select upper(af.FILENAME)filename, max(afv.VERSION) version
from ad_files af, ad_file_versions afv, ad_check_files acf
where acf.FILE_ID = af.FILE_ID
and   acf.FILE_VERSION_ID = afv.FILE_VERSION_ID
group by upper(af.FILENAME)

select a.filename, a.FILE_VERSION "ALL SOURCE VERSION", b.VERSION "CHECK FILE VERSION"
from gedba.gedba_onsite_file_versions a, gedba.gedba_check_file_versions b
where a.filename = b.filename(+)
--and a.file_version <> b.version
and a.filename in ( select upper(filename)
from ad_files
where upper(filename) like '%ADDDB.PLS%'
group by upper(filename)
having count(*) > 1)

select a.* --upper(filename),  count(*)
from ad_files a
where --upper(filename) = 'AFTZPVTB.PLS'
--exists (select 'Y'
--	    from ad_files b
--		where upper(a.filename) = upper(b.filename)
		--and b.subdir = 'patch/115/sql'
--		and upper(b.filename) in ('ADDDB.PLS',
--							  	  'ADDDS.PLS',
--								  'POSUPBNB.PLS',
--								  'WSHLANGS.PLS',
--								  'XNPORDNS.PLS')
--		group by upper(b.filename)
--		having count(*) > 1)
--and a.subdir = 'patch/115/sql'
		upper(a.filename) in ('ADDDB.PLS',
							  	  'ADDDS.PLS',
								  'POSUPBNB.PLS',
								  'WSHLANGS.PLS',
								  'XNPORDNS.PLS')



group by upper(filename)
having count(*) > 1

select *
from dba_objects
where object_name = 'FVSF133_NOYEAR'