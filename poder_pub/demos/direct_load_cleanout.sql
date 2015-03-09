--DROP TABLE t;
--CREATE TABLE t (a CHAR(100)) PCTFREE 99 PCTUSED 1 TABLESPACE users;
--@seg2 T
--@gts T

TRUNCATE TABLE t;

INSERT /*+ APPEND */ INTO t SELECT 'x' FROM dual CONNECT BY LEVEL <= 1000;
--@dump 4 99316 Start
--@dump 4 99317 Start

ALTER SYSTEM FLUSH BUFFER_CACHE;

COMMIT;
--@dump 4 99316 Start
--@dump 4 99317 Start

--@ev 10203 2
--@ev 10200 1
--@ev 10046 8

SELECT COUNT(*) FROM t;
--@dump 4 99316 Start
--@dump 4 99317 Start
