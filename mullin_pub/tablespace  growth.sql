select 'This report shows Tablespace Growth between the Current Week and Last Week.  Only Tablespaces with an Increase or (Decrease) are included.'
from dual;


select PREV.TABLESPACE_NAME
      ,round((CUR.TOTAL_USED/1024/1024),2) "CURRENT_SIZE"
      ,round((PREV.TOTAL_USED/1024/1024),2) "PRIOR_SIZE"
      ,round(((CUR.TOTAL_USED - PREV.TOTAL_USED)/1024/1024),2) "SIZE_INC"
	  ,round((((CUR.TOTAL_USED - PREV.TOTAL_USED)/PREV.TOTAL_USED) * 100),2) "PCT_INC"
from gesss.gecm_stats_tabspace CUR,
     gesss.gecm_stats_tabspace PREV,
	 gesss.gecm_stats_job CUR_JOB,
	 gesss.gecm_stats_job PREV_JOB
where trunc(CUR_JOB.LAST_RUN_DATE) = trunc(sysdate -1)
and	  trunc(PREV_JOB.LAST_RUN_DATE) = trunc(sysdate -8)
and	  CUR_JOB.JOB_NUM = CUR.JOB_NUM
and	  PREV_JOB.JOB_NUM = PREV.JOB_NUM
and	  CUR.TABLESPACE_NAME(+) = PREV.TABLESPACE_NAME
UNION ALL
select 'TOTAL'
      ,round(sum((CUR.TOTAL_USED/1024/1024)),2) "CURRENT_SIZE"
      ,round(sum((PREV.TOTAL_USED/1024/1024)),2) "PRIOR_SIZE"
      ,round(sum(((CUR.TOTAL_USED - PREV.TOTAL_USED)/1024/1024)),2) "SIZE_INC"
	  ,round((((sum(CUR.TOTAL_USED/1024/1024) - sum(PREV.TOTAL_USED/1024/1024))/sum(PREV.TOTAL_USED/1024/1024)) * 100),2) "PCT_INC"
from gesss.gecm_stats_tabspace CUR,
     gesss.gecm_stats_tabspace PREV,
	 gesss.gecm_stats_job CUR_JOB,
	 gesss.gecm_stats_job PREV_JOB
where trunc(CUR_JOB.LAST_RUN_DATE) = trunc(sysdate -1)
and	  trunc(PREV_JOB.LAST_RUN_DATE) = trunc(sysdate -8)
and	  CUR_JOB.JOB_NUM = CUR.JOB_NUM
and	  PREV_JOB.JOB_NUM = PREV.JOB_NUM
and	  CUR.TABLESPACE_NAME(+) = PREV.TABLESPACE_NAME
group by 'TOTAL';




select last_run_date "Current Week Run Date"
from gesss.gecm_stats_job
where trunc(LAST_RUN_DATE) = trunc(sysdate -1);

select last_run_date "Prior Week Run Date"
from gesss.gecm_stats_job
where trunc(LAST_RUN_DATE) = trunc(sysdate -8);

select CUR.TABLESPACE_NAME
	  , CUR.OBJECT_NAME TABLE_NAME
      ,(CUR.TABLE_SIZE/1024/1024) "CURRENT SIZE MB"
      ,(PREV.TABLE_SIZE/1024/1024) "PRIOR SIZE MB"
      ,((CUR.TABLE_SIZE - PREV.TABLE_SIZE)/1024/1024) "INCREASE SINCE PRIOR MB"
from gesss.gecm_stats_tabdata CUR,
     gesss.gecm_stats_tabdata PREV,
	 gesss.gecm_stats_job CUR_JOB,
	 gesss.gecm_stats_job PREV_JOB
where trunc(CUR_JOB.LAST_RUN_DATE) = trunc(sysdate -1)
and	  trunc(PREV_JOB.LAST_RUN_DATE) = to_date('02/25/2004','mm/dd/rrrr')
and	  CUR_JOB.JOB_NUM = CUR.JOB_NUM
and	  PREV_JOB.JOB_NUM = PREV.JOB_NUM
and	  CUR.TABLESPACE_NAME = PREV.TABLESPACE_NAME(+)
and	  CUR.OBJECT_NAME = PREV.OBJECT_NAME(+)
and   CUR.TABLESPACE_NAME = 'FNDD'


select CUR.TABLESPACE_NAME
	  , CUR.INDEXNAME INDEX_NAME
      ,(CUR.INDEXSIZE /1024/1024) "CURRENT SIZE MB"
      ,(PREV.INDEXSIZE/1024/1024) "PRIOR SIZE MB"
      ,((CUR.INDEXSIZE - PREV.INDEXSIZE)/1024/1024) "INCREASE SINCE PRIOR MB"
from gesss.gecm_stats_tabindex CUR,
     gesss.gecm_stats_tabindex PREV,
	 gesss.gecm_stats_job CUR_JOB,
	 gesss.gecm_stats_job PREV_JOB
where trunc(CUR_JOB.LAST_RUN_DATE) = trunc(sysdate -1)
and	  trunc(PREV_JOB.LAST_RUN_DATE) = to_date('02/25/2004','mm/dd/rrrr')
and	  CUR_JOB.JOB_NUM = CUR.JOB_NUM
and	  PREV_JOB.JOB_NUM = PREV.JOB_NUM
and	  CUR.TABLESPACE_NAME = PREV.TABLESPACE_NAME(+)
and	  CUR.INDEXNAME = PREV.INDEXNAME(+)
and   CUR.TABLESPACE_NAME = 'FNDX'

