#!/bin/ksh
###########daily_encrypt.sh####################################################
# Shell script to encrypt the informix ontape backup file
# and ftp it to the backup server               
# Written by b.green on  2/28/2012  
###############################################################################
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
LOGFILE="/home/swx/inf_logs/bkup_ftp.log"
BASE="/home/swx/backup"                # source directory
NOTIFY=" barry@tranact.com \
         colby@tranact.com \
         scott@tranact.com \
         bj@tranact.com " 
#NOTIFY=" barry@tranact.com " 
FILE="trangateway.enc"        # file name to tranxmit 
FTPDEST="/home/swx/inf_logs/bkup_ftp.dest"

echo "=======$0============================="
if [ -f ${LOGFILE} ]; then
   mv ${LOGFILE} ${LOGFILE}.OLD
fi
echo "ftp procedure started at: `date`"|tee ${LOGFILE}

  ls -l   ${BASE}/${FILE} | tee -a ${LOGFILE}

cd $BASE
pwd |tee -a ${LOGFILE}
if [ ! -f ${FILE} ]; then
   echo -e "\nFile (${FILE}) is Missing...\nscript $0 ends at `date`" | tee -a ${LOGFILE}
   SUBJ="`hostname` - ${FILE} - ERROR Transmission to $FTPHOST"
   for RECP in $NOTIFY
   do
       mail -s "${SUBJ}" ${RECP} < ${LOGFILE}  
   done
   exit 1
fi
echo "Have File ${FILE}"  | tee -a ${LOGFILE}

XMIT=/tmp/bkup_ftp.xmitfile
echo ${XMIT} | tee -a ${LOGFILE}

echo "Begins at: `date`" | tee -a ${LOGFILE}
chmod 666 ${LOGFILE} |tee -a ${LOGFILE}
echo ${FILE} | tee -a ${LOGFILE}
rm ${FTPDEST}
  #-----setup get File FTP stuff
  echo "user $FTPUSER $FTPPASS"  > ${XMIT}
  echo "prompt"                  >> ${XMIT}
  echo "binary"                  >> ${XMIT}
  echo "cd ${DIR}"               >> ${XMIT}
  echo "put ${FILE}"             >> ${XMIT}
  echo "chmod 666 ${FILE}"       >> ${XMIT}
  echo "dir ${FILE} ${FTPDEST}"  >> ${XMIT}
  echo "bye"                     >> ${XMIT}
chmod 666 ${XMIT} |tee -a ${LOGFILE}

#------Perform the FTP Script---------------------------
   echo "Transmit the ${FILE} File to $FTPHOST" | tee -a ${LOGFILE}
   echo "--------------------------------------------------" | tee -a ${LOGFILE}
#   cat ${XMIT} | ftp -vin $FTPHOST | tee -a ${LOGFILE}
   ftp -vin $FTPHOST < ${XMIT} >> ${LOGFILE}
   STAT=$?
   echo "--------------------------------------------------" | tee -a ${LOGFILE}
   echo "FTP Status code ${STAT}." | tee -a ${LOGFILE}
#   rm -f ${XMIT}

   #------verify data was transfered correctly-----------------
   SSIZ=`ls -l ${FILE} |awk '{print $5}'`
#   RSIZ=`grep ftp ${LOGFILE} |grep .enc|awk '{print $5}'`
   RSIZ=`grep ${FILE} ${FTPDEST}|awk '{print $5}'`
   echo -e "\nSending Size: ${SSIZ}   Transmitted Size:  ${RSIZ}" | tee -a ${LOGFILE}
   if [ "${SSIZ}" -ne "${RSIZ}" ]; then
      echo "What we sent: ${RSIZ} DOES NOT MATCH received size: ${SSIZ}" | tee -a ${LOGFILE}
      STAT=8
   else
      echo "What we sent: ${RSIZ} DOES MATCH received size: ${SSIZ}" | tee -a ${LOGFILE}
      STAT=0
   fi    
   echo -e "\nLocal File:" | tee -a ${LOGFILE}
   ls -l ${FILE} >> ${LOGFILE}
   echo -e "\nTransmit ends at: `date`" | tee -a ${LOGFILE}

   #-----send the mail message--------------------------
   if [ "$STAT" -eq 0 ]; then
      SUBJ="`hostname` - ${FILE} - GOOD Transmission to $FTPHOST"
      for RECP in $NOTIFY
      do
          mail -s "${SUBJ}" ${RECP} < ${LOGFILE}  
      done
   else
      SUBJ="`hostname` - ${FILE} - ERROR Transmission to $FTPHOST"
      for RECP in $NOTIFY
      do
          mail -s "${SUBJ}" ${RECP} < ${LOGFILE}  
      done
      exit 1     # exit with error Flag Set ON
   fi
   #----------------------------------------------------

exit 0
