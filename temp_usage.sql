/* Formatted on 8/21/2013 6:19:08 PM (QP5 v5.227.12220.39724) */

  SELECT A.tablespace_name tablespace,
         D.mb_total,
         SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_used,
         D.mb_total - SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_free
    FROM gv$sort_segment A,
         (  SELECT B.INST_ID,
                   B.name,
                   C.block_size,
                   SUM (C.bytes) / 1024 / 1024 mb_total
              FROM gv$tablespace B, gv$tempfile C
             WHERE B.ts# = C.ts# AND B.INST_ID = C.INST_ID
          GROUP BY b.INST_ID, B.name, C.block_size) D
   WHERE A.tablespace_name = D.name AND A.INST_ID = D.INST_ID
GROUP BY A.tablespace_name, D.mb_total;


  SELECT S.sid || ',' || S.serial# sid_serial,
         s.INST_ID,
         S.username,
         S.osuser,
         SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used,
         T.tablespace,
         COUNT (*) statements
    FROM gv$sort_usage T,
         gv$session S,
         dba_tablespaces TBS,
         gv$process P
   WHERE     T.session_addr = S.saddr
         AND t.INST_ID = S.INST_ID
         AND S.paddr = P.addr
         AND S.INST_ID = P.INST_ID
         AND T.tablespace = TBS.tablespace_name
GROUP BY S.sid || ',' || s.serial#,
         s.INST_ID,
         S.username,
         S.osuser,
         TBS.block_size,
         T.tablespace
ORDER BY 5 desc;