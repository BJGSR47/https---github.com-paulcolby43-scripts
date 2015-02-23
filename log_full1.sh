#!/bin/ksh

PROG=`basename $0`
USER_LIST=informix
BACKUP_CMD="ontape -a"
EXIT_STATUS=0

EVENT_SEVERITY=$1
EVENT_CLASS=$2
EVENT_MSG="$3"
EVENT_ADD_TEXT="$4"
EVENT_FILE="$5"
LOGFILE="/home/swx/inf_logs/ilog.log"
DIR="/home/swx/inf_logs"
NOTIFY=" barry@tranact.com \
         colby@tranact.com " 


case "${EVENT_CLASS}" in
   23)	
    echo -e "=========$0=============== \n" > ${LOGFILE}
    echo -e "`date` - ${BACKUP_CMD}  \n" >> ${LOGFILE}
    ${BACKUP_CMD} 2>&1 >> ${LOGFILE} <<EOF

n
EOF
    EXIT_STATUS=$?
#    EXIT_STATUS=0
sleep 2     #  put in a delay here....
    if [[ ${EXIT_STATUS} -eq 0 ]]; then
      LLNUM=`tail -3 ${LOGFILE}|head -1`
      LLFILE=`echo ${LLNUM} | sed "s/ *\([0-9]*\).*/\/home\/swx\/inf_logs\/llog-\1.ont/"`

      if [[ -f ${LLFILE} ]]; then
        echo -e "Copy Not Performed: File Allready Exists - ${LLFILE} \n" >>${LOGFILE}
        mail -s "`hostname` - $0 -FAILED" ${NOTIFY} < ${LOGFILE}
        exit 1
      fi
      LASTSZ=`ls -l ${DIR}/llog.last | awk '{print $5}'`
      cp ${DIR}/llog.last ${LLFILE} |tee -a ${LOGFILE}

sleep 2     #  put in a delay here....
      echo -e "Copying ${DIR}/llog.last to ${LLFILE} \n" >> ${LOGFILE}
      echo -e "Copy of  ${LLFILE} completed. \n" >> ${LOGFILE}
      LLSZ=`ls -l ${LLFILE} | awk '{print $5}'`
      echo -e "Check Size LASTSZ: \(${LASTSZ}\) vers LLSZ \(${LLSZ}\) \n"  >> ${LOGFILE}

      if [[ ${LASTSZ} -ne ${LLSZ} ]]; then
        echo -e "Copy Failed:Size Mismatch \n" >> ${LOGFILE}
        echo -e "Remote Copy Not Performed \n" >> ${LOGFILE}
        mail -s "`hostname` - $0 -FAILED" ${NOTIFY} < ${LOGFILE}
        exit 1
      else
        echo -e "Clearing Last and Copying ${LLFILE} to Hot Site \n" >> ${LOGFILE}
        cat /dev/null > ${DIR}/llog.last

        echo -e "Start Remote Copy at `date` \n" >> ${LOGFILE}
#    Encrypt Informix log
        uvencrypt -i ${LLFILE} -o ${LLFILE}.enc -p /home/swx/swkey.pub >> ${LOGFILE} 2>&1
        ENCFILE=${LLFILE}.enc
        rm ${LLFILE}

        /scripts/xmit-llog.sh  ${ENCFILE}
        RCP_STATUS=$?
        if [[ ${RCP_STATUS} -ne 0 ]]; then
          echo -e "Remote Copy Failed to Run - CODE: ${RCP_STATUS} \n" >> ${LOGFILE}
          mail -s "`hostname` - $0 -FAILED" ${NOTIFY} < ${LOGFILE}
          exit 1
        fi
        echo -e "Remote Copy to Hot Site Succeded \n" >> ${LOGFILE}
        echo -e "Completed at `date`    \n" >> ${LOGFILE}
        mail -s "`hostname` - $0 -SUCCESS"  ${NOTIFY} < ${LOGFILE}
      fi
     else
      echo -e "${BACKUP}_CMD Failed - CODE: ${EXIT_STATUS} \n" >> ${LOGFILE}
      mail -s "`hostname` - $0 -FAILED"  ${NOTIFY} < ${LOGFILE}
    fi
    ;;

# One program is shared by all event alarms.  If this ever gets expanded to
# handle more than just archive events, uncomment the following:
   *)
#		EXIT_STATUS=1
   ;;
esac

exit ${EXIT_STATUS}
