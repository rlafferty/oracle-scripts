BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
      OwnName        => 'JAROSODS'
     ,TabName        => 'MLOG$_DEPARTMENT_MAS'
    ,Estimate_Percent  => 10
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => FALSE
    ,No_Invalidate     => FALSE);
END;
/

BEGIN
    SYS.DBMS_STATS.LOCK_TABLE_STATS('JAROSODS', 'MLOG$_DEPARTMENT_MAS');
END;
/

select * from jarosods.date_mas;

BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
      OwnName        => 'JAROSODS'
     ,TabName        => 'MLOG$_WIP_ENTITY_MAS'
    ,Estimate_Percent  => dbms_stats.auto_sample_size
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE 1'
    ,Degree            => 4
    ,Cascade           => FALSE
    ,No_Invalidate     => FALSE);
END;
/

BEGIN
    SYS.DBMS_STATS.LOCK_TABLE_STATS('JAROSODS', 'MLOG$_WIP_ENTITY_MAS');
END;
/

select * from DBA_TAB_STATISTICS 
where OWNER = 'JAROSODS'
and TABLE_NAME like '%MLOG%';
and OBJECT_TYPE NOT IN ('TABLE', 'INDEX', 'PARTITION');