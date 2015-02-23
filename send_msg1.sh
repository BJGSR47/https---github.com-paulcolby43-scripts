#!/bin/ksh
# send_msg1.sh
cd /home/prod/4gl
LOG="../logs/send_msg1.log"
#NOTIFY=" bgreen@tranact.com \
#         colby@tranact.com " 
NOTIFY=" bgreen@tranact.com " 
MSG="send_msg1.sh "
###############################################################################
touch $LOG
fglgo send_msg1 |tee -a ${LOG}
#echo "Finished send_msg1.4gl               " >> ${LOG}
#echo "See ${LOG} for information about process to database..." |tee -a ${LOG}

#mail -s "$MSG - LOGFILE" ${NOTIFY} < ${LOG}
