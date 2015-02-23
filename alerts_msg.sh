#!/bin/ksh
# alerts_msg.sh
cd /home/prod/4gl
LOG="../logs/alerts_msg.log"
#NOTIFY=" bgreen@tranact.com \
#         colby@tranact.com " 
NOTIFY=" bgreen@tranact.com " 
MSG="alerts_msg.sh "
###############################################################################
touch $LOG
fglgo alerts 2>&1 |tee -a ${LOG}
#echo "Finished alerts_msg.4gl               " >> ${LOG}
#echo "See ${LOG} for information about process to database..." |tee -a ${LOG}


#mail -s "$MSG - LOGFILE" ${NOTIFY} < ${LOG}
