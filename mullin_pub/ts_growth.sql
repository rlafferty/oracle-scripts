select PREV.TABLESPACE_NAME
    ,round((CUR.TOTAL_USED/1024/1024),2) "CURRENT_SIZE"
    ,round((PREV.TOTAL_USED/1024/1024),2) "PRIOR_SIZE"
    ,round(((CUR.TOTAL_USED - PREV.TOTAL_USED)/1024/1024),2) "SIZE_INC"
    ,round((((CUR.TOTAL_USED - PREV.TOTAL_USED)/PREV.TOTAL_USED) * 100),2) "PCT_INC"
from gesss.gecm_stats_tabspace CUR,
     gesss.gecm_stats_tabspace PREV,
     gesss.gecm_stats_job CUR_JOB,
     gesss.gecm_stats_job PREV_JOB
where CUR_JOB.JOB_NUM = (Select max(job_num)
                         from gesss.gecm_stats_job
                         where trunc(LAST_RUN_DATE) = trunc(sysdate -1))
and  PREV_JOB.JOB_NUM = (Select max(job_num)
                         from gesss.gecm_stats_job
                         where trunc(LAST_RUN_DATE) = trunc(sysdate -8))
and       CUR_JOB.JOB_NUM = CUR.JOB_NUM
and       PREV_JOB.JOB_NUM = PREV.JOB_NUM
and       CUR.TABLESPACE_NAME(+) = PREV.TABLESPACE_NAME
and       CUR.TABLESPACE_NAME not like 'SMU%'
order by 4 desc;