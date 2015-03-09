  SELECT DECODE (request, 0, 'Holder: ', 'Waiter: ') || sid sess,
         inst_id,
         id1,
         id2,
         lmode,
         request,
         TYPE
    FROM gV$LOCK
   WHERE (id1, id2, TYPE) IN (SELECT id1, id2, TYPE
                                FROM gV$LOCK
                               WHERE request > 0)
ORDER BY id1, request;