-- This query returns count of messages waiting to be dequeued by queue name 
select q_name, corrid, count(*)
from apps.wf_deferred 
where deq_time is null
group by q_name, corrid

-- This query returns count of messages waiting to be dequeued in total  
select count(*)
from apps.wf_deferred
where deq_time is null

-- This query gives counts for notification and mail statuses 
select status, mail_status, count(*)
from wf_notifications
group by status, mail_status

-- This query gives counts of notifications waiting to be mailed by type 
select message_type, message_name , count(*)
from wf_notifications
where status = 'OPEN'
and mail_status = 'MAIL'
group by message_type, message_name
order by 3 desc

-- This query gives counts of deferred messages by type and state 
select substr(wfd.corrid,1,40) corrid, 
decode(wfd.state, 
0, '0 = Ready', 
1, '1 = Delayed', 
2, '2 = Retained', 
3, '3 = Exception', 
to_char(substr(wfd.state,1,12))) State, 
count(*) COUNT 
from applsys.wf_deferred wfd 
group by wfd.corrid, wfd.state; 

-- This query gives counts of Inbound and Outbound notifications enqueued during a specific time interval 
SELECT   'OUTBOUND' STATUS ,TO_CHAR (deq_time, 'hh24') "TIME", COUNT (*)
    FROM apps.wf_notification_out
   WHERE deq_time > TO_DATE ('02-MAR-2004 23:59:59', 'DD-MON-RRRR HH24:MI:SS')
GROUP BY 'OUTBOUND', TO_CHAR (deq_time, 'hh24')
union all
SELECT   'INBOUND' STATUS ,TO_CHAR (enq_time, 'hh24') "TIME", COUNT (*)
    FROM apps.wf_notification_out
   WHERE enq_time > TO_DATE ('02-MAR-2004 23:00:00', 'DD-MON-RRRR HH24:MI:SS')
GROUP BY 'INBOUND', TO_CHAR (enq_time, 'hh24')

-- This query gives counts of Inbound and Outbound notifications dequeued during a specific time interval 
SELECT   'OUTBOUND' STATUS ,TO_CHAR (deq_time, 'dd/mm/rr hh24') "TIME", COUNT (*)
    FROM apps.wf_notification_out
   WHERE deq_time > TO_DATE ('02-MAR-2004 23:59:59', 'DD-MON-RRRR HH24:MI:SS')
GROUP BY 'OUTBOUND', TO_CHAR (deq_time, 'hh24')
union all
SELECT   trunc(enq_time) "TIME", COUNT (*)
    FROM apps.wf_deferred
   WHERE enq_time > TO_DATE ('02-MAR-2004 23:59:59', 'DD-MON-RRRR HH24:MI:SS')
GROUP BY trunc(enq_time)


-- This query gives counts of errored messages by type and state 
select substr(wfe.corrid,1,40) corrid, 
decode(wfe.state, 
0, '0 = Ready', 
1, '1 = Delayed', 
2, '2 = Retained', 
3, '3 = Exception', 
to_char(substr(wfe.state,1,12))) State, 
count(*) COUNT 
from applsys.wf_error wfe 
group by wfe.corrid, wfe.state; 

-- This query gives counts of outbound messages by type and state 
select substr(corrid,1,15) corrid, 
decode(state, 
0, '0 = Ready', 
1, '1 = Delayed', 
2, '2 = Retained', 
3, '3 = Exception', 
to_char(state)) State, 
count(*) COUNT 
from applsys.WF_NOTIFICATION_OUT 
group by corrid, state; 


-- This query gives records from a particular user/roles worklist 
SELECT 
  NID,
  PRIORITY,
  LANGUAGE,
  MESSAGE_TYPE,
  RECIPIENT_ROLE,
  SUBJECT,
  BEGIN_DATE,
  DUE_DATE,
  END_DATE,
  DISPLAY_STATUS,
  STATUS,
  FROM_USER,
  TO_USER
FROM 
  WF_WORKLIST_V
WHERE 
  (RECIPIENT_ROLE = :b1 or         RECIPIENT_ROLE in         (select WUR.ROLE_NAME          
  				  				   				  			 from WF_USER_ROLES WUR          
															 where WUR.USER_ORIG_SYSTEM = :b3          and
  WUR.USER_ORIG_SYSTEM_ID = :b2          and
  WUR.USER_NAME = :b1))     and
  STATUS = 'OPEN'     order by PRIORITY, BEGIN_DATE DESC
  
  
-- This query counts records eligible to be purged for a specific Workflow Item Type   
select wf_purge.GetPurgeableCount('POXML') 
from dual

-- The following queries gives record counts of the Workflow Tables 
select item_type, count(*)
from wf_item_attribute_values
group by item_type

select corrid, count(*)
from wf_deferred
group by corrid

select corrid, count(*)
from wf_error
group by corrid

select item_type, count(*)
from wf_items
group by item_type

select item_type, activity_status, count(*)
from wf_item_activity_statuses
group by item_type, activity_status

select item_type, activity_status, count(*)
from wf_item_activity_statuses_h
group by item_type, activity_status

select message_type, count(*)
from wf_notifications
group by message_type