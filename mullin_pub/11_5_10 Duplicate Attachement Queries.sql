-- Count of Duplicate Reqs to PO's Since 11.5.10 
select count(*)
from gedba_dupl_lobs
where trunc(po_prg_update) > to_date('05/14/2006','mm/dd/rrrr');

-- Count of Duplicate Reqs to PO's prior to 11.5.10 
select count(*)
from gedba_dupl_lobs
where trunc(po_prg_update) < to_date('05/14/2006','mm/dd/rrrr');

-- Add column to GEDBA_DUPL_LOBS to store File Size 
alter table gedba_dupl_lobs
add  size_mb number;

-- Update Duplicate Reqs to PO's to add File Size 
update gedba_dupl_lobs gdl
set gdl.size_mb = (select (dbms_lob.getlength(fl.file_data))/1024/1024
			      from applsys.fnd_lobs fl
				  where fl.file_id = gdl.pol_media_id);

commit;				  

-- Get the total size of Duplicate Reqs to PO's since 11.5.10 
select sum(size_mb)
from gedba_dupl_lobs
where trunc(po_prg_update) > to_date('05/14/2006','mm/dd/rrrr');

-- Get the total size of Duplicate Reqs to PO's prior to 11.5.10 
select sum(size_mb)
from gedba_dupl_lobs
where trunc(po_prg_update) < to_date('05/14/2006','mm/dd/rrrr');

-- Count of Duplicate Blankets to Releases Since 11.5.10 
select count(*)
from gedba_dupl_ship_lobs
where trunc(po_prg_update) > to_date('05/14/2006','mm/dd/rrrr');

-- Count of Duplicate Blankets to Releases Prior to 11.5.10 
select count(*)
from gedba_dupl_ship_lobs
where trunc(po_prg_update) < to_date('05/14/2006','mm/dd/rrrr');

-- Add column to GEDBA_DUPL_SHIP_LOBS to store File Size 
alter table gedba_dupl_ship_lobs
add  size_mb number;

-- Update Duplicate Blankets to Releases to add File Size 
update gedba_dupl_ship_lobs gdl
set gdl.size_mb = (select (dbms_lob.getlength(fl.file_data))/1024/1024
			      from applsys.fnd_lobs fl
				  where fl.file_id = gdl.pol_media_id);

commit;				  

-- Get the total size of Duplicate Blankets to Releases since 11.5.10 
select sum(size_mb)
from gedba_dupl_ship_lobs
where trunc(po_prg_update) > to_date('05/14/2006','mm/dd/rrrr');

-- Get the total size of Duplicate Blankets to Releases since 11.5.10 
select sum(size_mb)
from gedba_dupl_ship_lobs
where trunc(po_prg_update) < to_date('05/14/2006','mm/dd/rrrr');
