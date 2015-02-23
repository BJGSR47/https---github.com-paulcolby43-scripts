#!/bin/ksh
# tran_errs.sh
cd /home/prod/4gl
LOG="../logs/tran_errs.log"
LOGNOTIFY=" barry@tranact.com \
         bj@tranact.com " 
NOTIFY=" barry@tranact.com \
         bj@tranact.com \
         scott@tranact.com " 
RPTFILE="../data/tran_errs.txt"

###############################################################################
date > $LOG
fglgo tran_errs $1 |tee -a ${LOG}
echo "Finished tran_errs.4gl" >> ${LOG}
date > $LOG
echo "See ${LOG} for information about program..." |tee -a ${LOG}
  SUBJ="tran_errs.sh PROCESS LOG `hostname`"

   cat $LOG | awk 'sub("$", "\r")' | \
   mail -s "${SUBJ}" ${LOGNOTIFY} < ${LOG}

  SUBJ="tran_errs.sh ERROR REPORT `hostname`"
   if [[ -s ${RPTFILE} ]]; then
     cat $RPTFILE | awk 'sub("$", "\r")' | \
     mail -s "${SUBJ}" ${NOTIFY} < ${RPTFILE}
   fi

exit
