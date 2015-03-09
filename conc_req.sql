set linesize 300

-- SELECT a.request_id, d.sid, d.serial# ,d.osuser,d.process , c.SPID ,d.inst_id
-- FROM apps.fnd_concurrent_requests a,
-- apps.fnd_concurrent_processes b,
-- gv$process c,
-- gv$session d
-- WHERE a.controlling_manager = b.concurrent_process_id
-- AND c.pid = b.oracle_process_id
-- AND b.session_id=d.audsid
-- AND a.request_id =&req_id
-- AND a.phase_code = 'R';

SELECT ses.sid,  
            ses.serial# ,
            pro.serial# , ses.osuser, ses.process , pro.SPID , pro.inst_id 
       FROM gv$session ses,  
            gv$process pro  
           WHERE ses.paddr = pro.addr  
           		AND ses.inst_id = pro.inst_id
                AND pro.spid IN (SELECT oracle_process_id  
                                           FROM apps.fnd_concurrent_requests  
                                        WHERE request_id = &request_id);