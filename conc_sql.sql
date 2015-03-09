select b.sql_id, a.sid, a.serial#, b.sql_text
   from gv$session a, gv$sqlarea b
    where a.sql_address=b.address
     and a.inst_id = b.inst_id
     and a.sid = &sid
     and a.inst_id = &inst_id;