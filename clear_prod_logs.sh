#!/bin/ksh
##########clear_prod_logs.sh###########################################
# Shell script to clear informix logs older than 6 days. These are    #
# logs from the production database stored in /bkupi. If they are not #
# cleared, they will fill the file system and the prod backup scripts #
# will start failing.                                                 #
#######################################################################
NOTIFY=" barry@tranact.com \
         colby@tranact.com \
         scott@tranact.com \
         bj@tranact.com " 
MSG="`hostname` - clear_prod_logs.sh "
LOGFILE="/home/swx/inf_logs/clear_prod_logs.log"
echo -e "=======$0============================= \n"  | tee ${LOGFILE}
chmod 666 ${LOGFILE}
  #-----------delete log files----------------------------------
  echo -e "Delete log files older than 6 days old... \n" | tee -a ${LOGFILE}
  find /bkupi -name "llog-*.ont*" -type f -mtime +5 -exec rm {} \;
  #-------------------------------------------------------------
#FCNT=`ls -l /bkupi/llog-*.ont* | wc -l` | tee -a ${LOGFILE}
echo -e "Log file count is " `ls -l /bkupi/llog-*.ont* | wc -l` "\n" |tee -a ${LOGFILE}
echo -e "clear_prod_logs.sh ended at: `date` \n"|tee -a ${LOGFILE}

mail -s "$MSG - LOGFILE" ${NOTIFY} < ${LOGFILE}
sleep 3
exit 0
