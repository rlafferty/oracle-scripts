SET LINESIZE 155
SET TRIMSPOOL ON
SET TRIMOUT ON
SET PAGESIZE 0


COLUMN username           FORMAT a17    HEAD 'USER ID'                 JUST LEFT
COLUMN description        FORMAT a30    HEAD 'DESCRIPTION'             JUST LEFT
COLUMN lastconnect        FORMAT a30    HEAD 'LAST CONNECTION - TIME'  JUST LEFT

clear breaks

  SELECT user_name username,
         description name,
         --TO_CHAR (b.first_connect, 'MM/DD/RR HH24:MI') firstconnect,
         TO_CHAR (b.last_connect, 'MM/DD/RR HH24:MI') lastconnect
    FROM apps.fnd_user a,
         (  SELECT MIN (first_connect) first_connect,
                   MAX (last_connect) last_connect,
                   last_updated_by user_id
              FROM apps.icx_sessions
          GROUP BY last_updated_by) b
   WHERE     a.user_id = b.user_id
         AND last_connect >= TO_DATE ('&date', 'MM/DD/YYYY')
ORDER BY 1 ASC
/