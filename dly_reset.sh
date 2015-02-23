#!/bin/ksh
# dly_reset.sh
cd /home/prod/4gl
LOG="../logs/dly_reset.log"
#NOTIFY=" barry@tranact.com \
#         colby@tranact.com " 
NOTIFY=" barry@tranact.com \
         scott@tranact.com \
         bj@tranact.com " 

###############################################################################
date > $LOG
fglgo dly_reset |tee -a ${LOG}
echo "Finished dly_reset.4gl               " >> ${LOG}
echo "See ${LOG} for information about process to database..." |tee -a ${LOG}
  SUBJ="dly_reset.sh PROCESS LOG `hostname`"

#   cat $LOG | awk 'sub("$", "\r")' | \
#   mail -s "${SUBJ}" ${NOTIFY} < ${LOG}

exit
