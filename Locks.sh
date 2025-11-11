#!/bin/bash

# Set environment variables
. /xx/xx/xx/xx/ORBITDEV.env     # Set your Oracle env file
DATE="$(date +'%Y-%m-%d_%H-%M-%S')"
OUTFILE="/tmp/db_locks_${DATE}.txt"

# Email details
MAILTO="skovur@uchicago.edu sandeep.bomma@orbitanalytics.com meeravali.shaik@orbitanalytics.com arun.velicheti@orbitanalytics.com deepak.ubale@orbitanalytics.com rajinikanth.nukala@orbitanalytics.com"   # Update email IDs
SUBJECT="Oracle Lock Report (XXORB Blocking > 30 mins)"

# Run SQL query
sqlplus -s "/as sysdba" <<EOF > "$OUTFILE"

SET LINESIZE 200
SET PAGESIZE 100
SET TRIM ON
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING ON

COLUMN blocking_sid         FORMAT 99999         HEADING 'Blocking|SID'
COLUMN blocking_serial      FORMAT 99999         HEADING 'Blocking|Serial#'
COLUMN blocking_user        FORMAT A15           HEADING 'Blocking|User'
COLUMN blocking_status      FORMAT A10           HEADING 'Blocking|Status'
COLUMN blocking_duration    FORMAT 9999          HEADING 'Blocking|Duration(Min)'
COLUMN blocking_event       FORMAT A30           HEADING 'Blocking|Wait Event'
COLUMN blocked_sid          FORMAT 99999         HEADING 'Blocked|SID'
COLUMN blocked_serial       FORMAT 99999         HEADING 'Blocked|Serial#'
COLUMN blocked_user         FORMAT A15           HEADING 'Blocked|User'
COLUMN blocked_status       FORMAT A10           HEADING 'Blocked|Status'
COLUMN blocked_event        FORMAT A30           HEADING 'Blocked|Wait Event'
COLUMN blocking_sql         FORMAT A100          HEADING 'Blocking SQL Text'

PROMPT
PROMPT ========================= Blocking Sessions Longer than 30 Minutes for User XXORB =========================
PROMPT

SELECT 
    s1.sid                        AS blocking_sid,
    s1.serial#                    AS blocking_serial,
    s1.username                   AS blocking_user,
    s1.status                     AS blocking_status,
    ROUND(s1.last_call_et / 60)  AS blocking_duration,
    s1.event                      AS blocking_event,
    
    s2.sid                        AS blocked_sid,
    s2.serial#                    AS blocked_serial,
    s2.username                   AS blocked_user,
    s2.status                     AS blocked_status,
    s2.event                      AS blocked_event,
    
    q.sql_text                    AS blocking_sql
FROM 
    v\$session s1
JOIN 
    v\$session s2 ON s1.sid = s2.blocking_session
LEFT JOIN 
    v\$sql q ON s1.sql_id = q.sql_id
WHERE 
    s2.blocking_session IS NOT NULL
    AND (s1.username = 'XXORB' OR s2.username = 'XXORB')
    AND s1.last_call_et > 1800
ORDER BY 
    s1.sid;

EOF

# Only send mail if blocking sessions are found
if [ -s "$OUTFILE" ]; then
    mailx -s "$SUBJECT" "$MAILTO" < "$OUTFILE"
fi


"
