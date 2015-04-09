set echo off
set linesize 150
set heading on
set lines 1000

/* Script developed by Jorge Rios Blanco on 30-03-2012 */
/* Oracle locks details                                */
/* TATA Consultancy Services Mexico                    */

column blocker format a11;
column blockee format a10;
column blocker_module format a30;
column blockee_module format a30;

alter session set optimizer_mode=rule;

select a.inst_id,
       a.sid,
       sesa.serial#,
       (select username from gv$session s where s.inst_id=a.inst_id and s.sid=a.sid) blocker,
       (select module from gv$session s where s.inst_id=a.inst_id and s.sid=a.sid) blocker_module ,
       ' is blocking ' Is_Blocking,
       b.inst_id,
       b.sid,
       sesb.serial#,
       (select username from gv$session s where s.inst_id=b.inst_id and s.sid=b.sid) blockee,
       (select module from gv$session s where s.inst_id=b.inst_id and s.sid=b.sid) blockee_module
    from gv$lock a, gv$lock b, gv$session sesa, gv$session sesb
   where
   a.block <>0 and
   b.request > 0
  and a.id1 = b.id1
  and a.id2 = b.id2
  and sesa.sid = a.sid
  and sesa.inst_id = a.inst_id
  and sesb.sid = b.sid
  and sesb.inst_id = b.inst_id
order by 1, 2
/

alter session set optimizer_mode=choose;

exit

