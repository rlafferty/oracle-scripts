WITH
-- global lock view
gl AS (
select
inst_id || '-' || sid instsid, id1, id2,
ctime, lmode, block, request
from
gv$lock
),
-- joins the global lock view on itself to identify locks
l AS (
SELECT
l1.instsid holding_session,
l2.instsid waiting_session
FROM
gl l1,
gl l2
WHERE
l1.block > 0
AND l2.request > 0
AND l1.id1=l2.id1
AND l1.id2=l2.id2
),
-- result view (tree of locked sessions)
rs AS (
SELECT
lpad(' ',3*(level-1),' ') || waiting_session running_session
FROM (
-- first insert as in utllockt
(SELECT
'-' holding_session, holding_session waiting_session
FROM
l
MINUS
SELECT
'-', waiting_session
FROM
l
)
UNION ALL
-- second insert as in utllockt
SELECT
holding_session, waiting_session
FROM
l
)
CONNECT BY PRIOR
waiting_session = holding_session
START WITH
holding_session = '-'
),
-- useful session informations
s AS (
SELECT
inst_id, sid, machine, osuser, username,
nvl(sql_id, '-') sql_id, event, wait_class
FROM gv$session
)
-- final tree
SELECT
*
FROM
rs
JOIN
s ON ltrim(rs.running_session)=s.inst_id || '-' || s.sid;