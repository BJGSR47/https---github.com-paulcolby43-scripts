#!/bin/sh
#
# for production
 
    LOG=/home/prod/logs/sendtoswx.log
    cat /dev/null > $LOG
#   NOTIFY=" barry@tranact.com \
#            bj@tranact.com "
   NOTIFY=" barry@tranact.com \
            bj@tranact.com \
            scott@tranact.com "            

# clear last yesterdays files
   cd /home/prod/4gl
   rm ../data/trans_sent_to_swx.txt
################################################################
## Begin sendtoswx script 
   echo -e "\n $0 started at: `date`" | tee  $LOG
   echo -e " using database $DBNAME" | tee -a $LOG
################################################################

##################################################################
## Begin sendtoswx.4gl 
   echo -e "\n sendtoswx.4gl started at `date`"  | tee -a $LOG
   fglgo sendtoswx 2>&1| tee -a $LOG
   EC1=$?
    
   echo -e " sendtoswx.4gl ended at `date`"  | tee -a $LOG
## End sendtoswx.4gl
##################################################################
                                                   
##################################################################
EC99=$EC1
if [ $EC99 = 0 ]; then
   echo -e "sendtoswx GOOD \n" | tee -a ${LOG}
   PASSFAIL="GOOD"
else
   echo -e "sendtoswx FAILED \n" | tee -a ${LOG}
   PASSFAIL="FAILED"
fi

##################################################################    
   echo -e "\n $0 ended at: `date`  "  | tee -a $LOG 
    echo -e " sendtoswx script ended at: `date`  " | tee -a $LOG   
    # transfer files to report server
    ../scripts/tfr-sendtoswx.sh
EC=$?
if [ $EC = 0 ]; then
   echo -e "FTP GOOD \n" | tee -a ${LOG}
   FTPFAIL="GOOD"
else
   echo -e "FTP FAILED \n" | tee -a ${LOG}
   FTPFAIL="FAILED"
fi
  SUBJ="sendtoswx ${PASSFAIL} ftp ${FTPFAIL} `hostname`"

#   cat $LOG | awk 'sub("$", "\r")' | \
   mail -s "${SUBJ} " ${NOTIFY} < ${LOG}
## End sendtoswx script 
##################################################################

exit $EC
