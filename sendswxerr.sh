#!/bin/sh
#
# for production
 
    LOG=/home/prod/logs/sendswxerr.log
    cat /dev/null > $LOG
#   NOTIFY=" barry@tranact.com \
#            bj@tranact.com "
   NOTIFY=" barry@tranact.com \
            bj@tranact.com \
            scott@tranact.com "            

# clear yesterdays files
   cd /home/prod/4gl
   rm ../data/sendswxerr.log
   rm ../data/trans_sent_unproc.txt
   rm ../data/trans_sent_voids.txt
################################################################
## Begin sendswxerr script 
   echo -e "\n $0 started at: `date`" | tee  $LOG
   echo -e " using database $DBNAME" | tee -a $LOG
################################################################

##################################################################
## Begin sendswxerr.4gl 
   echo -e "\n sendswxerr.4gl started at `date`"  | tee -a $LOG
   fglgo sendswxerr 2>&1| tee -a $LOG
   EC1=$?
    
   echo -e " sendswxerr.4gl ended at `date`"  | tee -a $LOG
## End sendswxerr.4gl
##################################################################
                                                   
##################################################################
EC99=$EC1
if [ $EC99 = 0 ]; then
   echo -e "sendswxerr GOOD \n" | tee -a ${LOG}
   PASSFAIL="GOOD"
else
   echo -e "sendswxerr FAILED \n" | tee -a ${LOG}
   PASSFAIL="FAILED"
fi

##################################################################    
   echo -e "\n $0 ended at: `date`  "  | tee -a $LOG 
    echo -e " sendswxerr script ended at: `date`  " | tee -a $LOG   
    # transfer files to report server
    ../scripts/tfr-sendswxerr.sh
EC=$?
if [ $EC = 0 ]; then
   echo -e "FTP GOOD \n" | tee -a ${LOG}
   FTPFAIL="GOOD"
else
   echo -e "FTP FAILED \n" | tee -a ${LOG}
   FTPFAIL="FAILED"
fi
  SUBJ="sendswxerr ${PASSFAIL} ftp ${FTPFAIL} `hostname`"

#   cat $LOG | awk 'sub("$", "\r")' | \
   mail -s "${SUBJ} " ${NOTIFY} < ${LOG}
## End sendswxerr script 
##################################################################

exit $EC
