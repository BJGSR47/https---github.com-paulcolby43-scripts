#!/bin/sh
#check_rss.sh
# this script monitors the online.log file for RSS failures and recoveries
cd /home/prod/data
LOG=$INFORMIXDIR/tmp/online.log
ALARMFILE=rss_status
#NOTIFY=" al3rts@tranact.com" 
NOTIFY=" barry@tranact.com \
         al3rts@tranact.com" 

# Clear old file
cat /dev/null > ${ALARMFILE}

#  Search for alerts
grep 'DR: ping timeout' ${LOG} >> ${ALARMFILE}
grep 'DR: Receive error' ${LOG} >> ${ALARMFILE}
grep 'DR: Turned off on primary server' ${LOG} >> ${ALARMFILE}
grep 'DR: Cannot connect to secondary server' ${LOG} >> ${ALARMFILE}
grep 'DR: Primary server connected' ${LOG} >> ${ALARMFILE}
grep 'DR: Secondary server needs failure recovery' ${LOG} >> ${ALARMFILE}
grep 'DR: Sending Logical Logs Completed' ${LOG} >> ${ALARMFILE}
grep 'DR: Primary server operational' ${LOG} >> ${ALARMFILE}

#

#
# Send Email to Alert Users
if [ -s ${ALARMFILE} ]; then

#  Log file will be e-mailed to programmers 
   SUBJ="RSS Messages - ALERT"

    mail -s "${SUBJ}" ${NOTIFY} < ${ALARMFILE}
fi
exit
