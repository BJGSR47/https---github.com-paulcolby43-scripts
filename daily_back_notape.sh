#!/bin/ksh
##########daily_back_notape.sh#################################################
#.Shell script to backup -iqvdf critical file systems to tape DAILY
# calls /scripts/in4mix_dump.sh to do ontape
# added logic to call compress/encrypt routines   file  5/10/2010  kv.
###############################################################################
#LOGFILE="/home/prod/logs/daily_back_notape.log"
LOGFILE="/home/swx/inf_logs/daily_back_notape.log"
TAPEDEV="/dev/rmt0"
BACKUP="/home/swx/backup"
ENCFILE="${BACKUP}/trangateway.enc"
NOTIFY=" barry@tranact.com \
         colby@tranact.com \
         scott@tranact.com \
         bj@tranact.com " 
MSG="`hostname` - daily_back_notape.sh "
mv ${LOGFILE} ${LOGFILE}.OLD

echo -e "=======$0============================= \n" > ${LOGFILE}
chmod 666 ${LOGFILE}
echo -e "Backup procedure started at: `date` \n"|tee -a ${LOGFILE}
if [ ! -f ${BACKUP}/trangateway.bak ]; then
   touch ${BACKUP}/trangateway.bak
fi

   /scripts/in4mix_dump.sh
   EC=$?
sleep 2
   if [[ ${EC} -eq 0 ]]; then
      echo -e "OnTape Level 0 Successful \n"| tee -a ${LOGFILE}
      uvencrypt -i ${BACKUP}/trangateway.bak -o ${ENCFILE} -p ${HOME}/swkey.pub
      rm ${BACKUP}/trangateway.bak
      echo -e "Backup file encrypted and removed \n"| tee -a ${LOGFILE}
   else
      echo -e "OnTape Level 0 UN-Successful: $EC \n"| tee -a ${LOGFILE}
   fi
echo -e "OnTape procedure completed at: `date` \n"|tee -a ${LOGFILE}
echo -e " Backup File Created: \n" | tee -a ${LOGFILE}
  ls -l   ${ENCFILE} | tee -a ${LOGFILE}

  #-----------delete log files----------------------------------
  echo -e "Delete log files older than 7 days old... \n" | tee -a ${LOGFILE}
  find /home/swx/inf_logs -name "llog-*.ont*" -type f -mtime +5 -exec rm {} \;
  #-------------------------------------------------------------

echo -e "Backup procedure ended at: `date` \n"|tee -a ${LOGFILE}

mail -s "$MSG - LOGFILE" ${NOTIFY} < ${LOGFILE}
sleep 3

# execute ftp script but don't wait for it to finish
/scripts/bkup_ftp.sh &
exit 0