BEGIN
  SYS.DBMS_STATS.GATHER_TABLE_STATS (
      OwnName        => 'GETS_DW_SVC'
     ,TabName        => 'SVC_LMS_TD_SIGNOFF_COUNT_AF_MV'
    ,Estimate_Percent  => DBMS_STATS.AUTO_SAMPLE_SIZE
    ,Method_Opt        => 'FOR ALL COLUMNS SIZE AUTO'
    ,GRANULARITY => 'ALL'
    ,Cascade           => TRUE);
END;
/


BEGIN
  SYS.DBMS_STATS.GATHER_DATABASE_STATS (
    Estimate_Percent  => DBMS_STATS.AUTO_SAMPLE_SIZE
    ,GRANULARITY => 'AUTO'
    ,Cascade           => TRUE
,DEGREE =>32
,OPTIONS => 'GATHER AUTO'
);
END;
/



DECLARE
ObjList dbms_stats.ObjectTab;
BEGIN
dbms_stats.gather_schema_stats(ownname=>’GETS_DW_SVC’, objlist=>ObjList, options=>’LIST STALE’);
FOR i in ObjList.FIRST..ObjList.LAST
LOOP
dbms_output.put_line(ObjList(i).ownname || '.' || ObjList(i).ObjName || ' ' || ObjList(i).ObjType || ' ' || ObjList(i).partname);
END LOOP;
END;
/

declare
    m_object_list   dbms_stats.objecttab;
begin
 
    dbms_stats.gather_schema_stats(
        ownname     => 'JAROSODS',
        options     => 'LIST AUTO',
--      options     => 'LIST STALE',
--      options     => 'LIST EMPTY',
        objlist     => m_object_list
    );
 
    for i in 1..m_object_list.count loop
        dbms_output.put_line(
            rpad(m_object_list(i).ownname,30)     ||
            rpad(m_object_list(i).objtype, 6)     ||
            rpad(m_object_list(i).objname,30)     ||
            rpad(m_object_list(i).partname,30)    ||
            rpad(m_object_list(i).subpartname,30) ||
            lpad(m_object_list(i).confidence,4)
        );
    end loop;
end;
/