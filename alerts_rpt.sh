#!/bin/ksh
# alerts_rpt.sh
cd /home/prod/4gl
LOG="../logs/alerts_rpt.log"
#NOTIFY=" bgreen@tranact.com \
#         colby@tranact.com " 
NOTIFY=" bgreen@tranact.com " 
MSG="alerts_rpt.sh "
###############################################################################
date >> $LOG
fglgo alerts_rpt 2>&1|tee -a ${LOG}
echo "Finished alerts_rpt.4gl               " >> ${LOG}
#echo "See ${LOG} for information about process to database..." |tee -a ${LOG}


#mail -s "$MSG - LOGFILE" ${NOTIFY} < ${LOG}
