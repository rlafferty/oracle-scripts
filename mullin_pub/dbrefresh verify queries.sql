SELECT * --text_value
FROM wf_notification_attributes
WHERE text_value LIKE '%'||'sss.corporate'||'%'


SELECT text_value
FROM wf_item_attribute_values
WHERE text_value LIKE '%'||'sss.corporate'||'%'

SELECT parameter_name, VALUE
FROM GECM_EPCARD_PARAMETERS
WHERE  parameter_name IN ( 'XML_PO_URL',  'XML_Url', 'SSO_URL','PO_VIEWER_BASE_DIR')


SELECT b.ITEM_SOURCE_NAME, A.URL
FROM ICX_POR_ITEM_SOURCES A, ICX_POR_ITEM_SOURCEs_tl b
WHERE A.ITEM_SOURCE_ID = b.ITEM_SOURCE_ID
AND b.LANGUAGE = 'US'
AND A.url LIKE '%corporate%'

SELECT company, callback_url, authentication_url
FROM ICX_PROCUREMENT_SERVER_SETUP

SELECT function_name,web_host_name--,SUBSTR(web_host_name,1,(LENGTH(web_host_name)-1))
FROM fnd_form_functions
WHERE web_host_name LIKE '%corporate%'

update fnd_form_functions
set web_host_name = replace(web_host_name, '8243','9743')
where web_host_name like '%corporate.ge.com:8243%'

commit



SELECT function_name,web_html_call--,SUBSTR(web_host_name,1,(LENGTH(web_host_name)-1))
FROM fnd_form_functions
WHERE web_html_call LIKE '%corp%'

SELECT fpo.PROFILE_OPTION_NAME, fpov.PROFILE_OPTION_VALUE
FROM fnd_profile_option_values fpov, fnd_profile_options fpo 
WHERE fpov.profile_option_value LIKE '%http:%corporate%'
AND fpov.application_id = fpo.application_id
AND fpov.profile_option_id = fpo.profile_option_id


SELECT *
FROM ecx_hubs
WHERE protocol_address LIKE '%corporate%'

-- DBREFRESH UPDATE STATEMENTS

select *
from ad_appl_tops

delete 
from ad_appl_tops
where appl_top_id = 62

update ad_appl_tops set name = 'corpt028' where name = 'corpp033'

commit

select *
from ad_patch_runs
where apps_system_name = 'sspz'

select *
from fnd_product_groups

select *
from fnd_concurrent_processes
where node_name <> 'CORPT027'

select *
from fnd_concurrent_requests
where logfile_node_name <> 'CORPT027'

select *
from fnd_nodes

select *
from fnd_oam_context_files

select *
from fnd_oam_app_sys_status
where node_name not in ( 'CORPT027', 'CORPT028')

select *
from po_vendor_sites_all
where fax is not null
or fax_area_code is not null

select *
from fnd_dual

select *
from applsys.wf_systems

select *
from applsys.wf_agents

select *
from dba_db_links
where db_link in ('EDW_APPS_TO_WH.CORPORATE.GE.COM', 'APPS_TO_APPS.CORPORATE.GE.COM')

select *
from ITG_HANDLER_EFFECTIVITIES
where nvl(effective_end_date,sysdate+1) > sysdate

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'SITENAME')
and level_id = 10001
and level_value = 0

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ICX_REPORT_SERVER')
and level_id = 10001
and level_value = 0

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ICX_REPORT_CACHE')
and level_id = 10001
and level_value = 0

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ICX_REPORT_IMAGES')
and level_id = 10001
and level_value = 0


select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ICX_REPORT_LAUNCHER')
and level_id = 10001
and level_value = 0

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ICX_REPORT_LINK')
and level_id = 10001
and level_value = 0

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'GEAE_UTL_FILE_IN')
and application_id = (select application_id
	  					   from fnd_profile_options
						   where profile_option_name = 'GEAE_UTL_FILE_IN')
and level_id = 10001
and level_value = 0

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'GEAE_UTL_FILE_OUT')
and application_id = (select application_id
	  					   from fnd_profile_options
						   where profile_option_name = 'GEAE_UTL_FILE_OUT')
and level_id = 10001
and level_value = 0

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'FND_IP_DTD_PATH')
and application_id = (select application_id
	  					   from fnd_profile_options
						   where profile_option_name = 'FND_IP_DTD_PATH')
and level_id = 10001
and level_value = 0

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'GEAE_UTL_FILE_IN')
and application_id = (select application_id
	  					   from fnd_profile_options
						   where profile_option_name = 'GEAE_UTL_FILE_IN')
and level_id = 10001
and level_value = 0

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ATTACHMENT_FILE_DIRECTORY')
and application_id = (select application_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ATTACHMENT_FILE_DIRECTORY')
and level_id = 10001
and level_value = 0

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ECE_IN_FILE_PATH')
and application_id = (select application_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ECE_IN_FILE_PATH')
and level_id = 10003

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ECE_OUT_FILE_PATH')
and application_id = (select application_id
	  					   from fnd_profile_options
						   where profile_option_name = 'ECE_OUT_FILE_PATH')
and level_id = 10003

select *
from fnd_profile_option_values
where profile_option_id = (select profile_option_id
	  					   from fnd_profile_options
						   where profile_option_name = 'GEMS_GEMSIO_TOP_PATH')
and application_id = (select application_id
	  					   from fnd_profile_options
						   where profile_option_name = 'GEMS_GEMSIO_TOP_PATH')
and level_id = 10001


select 'GRANT GEDEV TO '||username v_sql
from dba_users a
where a.default_tablespace = 'GECUST'
and a.username like 'GE%'
and exists (SELECT 'Y'
                FROM DBA_ROLE_PRIVS b
                WHERE b.granted_role = 'GEDEV'
                and       a.username = b.GRANTEE)
                
				
				
-- RESGEN.sh  

select distinct oracle_username from fnd_oracle_userid where read_only_flag = 'A'