:
#----- xmit-llog.sh ----------------------------------
# Script to transmit the llog Informix Log File
# ..
#-----------------------------------------------------
XHOST=`uname -a | cut -f2 -d" " | cut -f1 -d"."`
if [ ${XHOST} = "swx1" ]; then
    . /scripts/.security.swxdr
fi
if [ ${XHOST} = "swx2" ]; then
    . /scripts/.security.backupuat
fi
if [ ${XHOST} = "swxext" ]; then
    . /scripts/.security.backupdev
fi
if [ ${XHOST} = "swxdr" ]; then
    . /scripts/.security.swx1
fi
if [ ${XHOST} = "swx1" ]; then
    DIR=/bkupi                  # destination directory                   
fi
if [ ${XHOST} = "swx2" ]; then
    DIR=backup_swx2                  # destination directory                   
fi
if [ ${XHOST} = "swxext" ]; then
    DIR=backup_swxext                  # destination directory                   
fi
if [ ${XHOST} = "swxdr" ]; then
    DIR=/bkupi                  # destination directory                   
fi
BASE=/home/swx/inf_logs                # source directory
FILE="`basename $1`"        # file name to tranxmit 
NOTIFY=" barry@tranact.com \
         colby@tranact.com \
         scott@tranact.com \
         bj@tranact.com " 

LOG=${BASE}/xmit-llog.log
FTPDEST="/home/swx/inf_logs/xmit-llog.dest"
echo "`basename` begins" > ${LOG}
chmod 666 ${LOG}
if [ "$#" -ne "1" ]; then
  echo "Syntax Error:   Must pass File Name to Xmit as Parameter 1" >> ${LOG}
  exit
fi
cd ${BASE}
if [ ! -f ${FILE} ]; then
   echo "File (${FILE}) is Missing...script $0 ends at `date`" >> ${LOG}
   exit 1
fi
echo "Have File (${FILE})" 

XMIT=/tmp/xmit-llog.xmitfile
echo ${XMIT} >> ${LOG}

if [ -f /tmp/${FILE} ]; then
   rm -f /tmp/${FILE}
fi
if [ -f ${XMIT} ]; then
   rm -f ${XMIT}
fi
if [ -f ${LOG} ]; then
   mv ${LOG} ${LOG}.OLD
fi
echo "Begins at: `date`" > ${LOG}
chmod 660 ${LOG}
echo ${FILE} >> ${LOG}
ls -l ${BASE}/${FILE} >> ${LOG}
rm ${FTPDEST}
  #-----setup get File FTP stuff
  echo "user ${FTPUSER} ${FTPPASS}" > ${XMIT}
  echo "prompt"                  >> ${XMIT}
  echo "binary"                  >> ${XMIT}
  echo "cd $DIR"                 >> ${XMIT}
  echo "put ${FILE}"             >> ${XMIT}
#  echo "chmod 666 ${FILE}"       >> ${XMIT}
  echo "dir ${FILE} ${FTPDEST}"  >> ${XMIT}
  echo "bye"                     >> ${XMIT}
chmod 660 ${XMIT}

#------Perform the FTP Script---------------------------
   echo "Transmit the ${FILE} File to ${FTPHOST}" >> ${LOG}
   echo "--------------------------------------------------" >> ${LOG}
#   cat ${XMIT} | ftp -vin ${FTPHOST} | tee -a ${LOG}
   ftp -vin ${FTPHOST} < ${XMIT} >> ${LOG}
   STAT=$?
   echo "--------------------------------------------------" >> ${LOG}
   echo "FTP Status code ${STAT}." >> ${LOG}
   rm -f ${XMIT}

   #------verify data was transfered correctly-----------------
   SSIZ=`ls -l ${FILE} |awk '{print $5}'`
#   RSIZ=`grep ftp ${LOG} |grep .ont|awk '{print $5}'`
   RSIZ=`grep ${FILE} ${FTPDEST}|awk '{print $5}'`
   echo "\nSending Size: ${SSIZ}   Transmitted Size:  ${RSIZ}" >> ${LOG}
   if [ "$SSIZ" -ne "$RSIZ" ]; then
      echo "What we sent: ${RSIZ} DOES NOT MATCH received size: ${SSIZ}" >> ${LOG}
      STAT=8
   else
      echo "What we sent: ${RSIZ} DOES MATCH received size: ${SSIZ}" >> ${LOG}
      STAT=0
   fi    
   echo "Local File:" >> ${LOG}
   ls -l ${FILE} >> ${LOG}
   echo "Transmit ends at: `date`" >> ${LOG}

   #-----send the mail message--------------------------
   if [ "$STAT" -eq 0 ]; then
      SUBJ="`hostname` - ${FILE} - GOOD Transmission to ${FTPHOST}"
      for RECP in ${NOTIFY}
      do
          mail -s "${SUBJ}" ${RECP} < ${LOG}  
      done
   else
      SUBJ="`hostname` - ${FILE} - ERROR Transmission to ${FTPHOST}"
      for RECP in ${NOTIFY}
      do
          mail -s "${SUBJ}" ${RECP} < ${LOG}  
      done
      exit 1     # exit with error Flag Set ON
   fi
   #----------------------------------------------------

exit 0
