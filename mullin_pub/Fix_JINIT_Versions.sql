select * from apps.wf_resources
where name =  'WF_PLUGIN_VERSION' 

update WF_RESOURCES
set text = '1.3.1.25'
where name =  'WF_PLUGIN_VERSION' 
and language <> 'US'
 
commit

select * from apps.wf_resources
where name =  'WF_CLASSID' 

update WF_RESOURCES
set text = 'CAFECAFE-0013-0001-0025-ABCDEFABCDEF'
where name =  'WF_CLASSID' 
and language <> 'US'