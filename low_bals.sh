#!/bin/ksh
# low_bals.sh
cd /home/prod/4gl
LOG="../logs/low_bals.log"
NOTIFY=" barry@tranact.com \
         bj@tranact.com " 
RPTFILE="../data/low_bals.txt"

###############################################################################
date > $LOG
fglgo low_bals |tee -a ${LOG}
echo "Finished low_bals.4gl" >> ${LOG}
date > $LOG
echo "See ${LOG} for information about program..." |tee -a ${LOG}
  SUBJ="low_bals.sh PROCESS LOG `hostname`"

   cat $LOG | awk 'sub("$", "\r")' | \
   mail -s "${SUBJ}" ${NOTIFY} < ${LOG}

   if [[ -s ${RPTFILE} ]]; then
     cat $RPTFILE | awk 'sub("$", "\r")' | \
     mail -s "${SUBJ}" ${NOTIFY} < ${RPTFILE}
   fi

exit
