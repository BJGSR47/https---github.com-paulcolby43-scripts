#!/bin/ksh
###########codeback_ftp.sh####################################################
# Shell script to encrypt the informix ontape backup file
# and ftp it to the backup server               
# Written by b.green on  03/05/2012  
###############################################################################
XHOST=`uname -a | cut -f2 -d" " | cut -f1 -d"."`
LOGFILE="/home/prod/logs/codeback_ftp.log"
BASE="/home/swx"                # source directory
NOTIFY=" barry@tranact.com \
         colby@tranact.com \
         scott@tranact.com \
         bj@tranact.com " 
#NOTIFY=" barry@tranact.com "
FILE="codeback.tar"        # file name to tranxmit 
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
FTPDEST="/home/swx/inf_logs/codeback.dest"
cd ${BASE}
echo "=======$0============================="
mv ${LOGFILE} ${LOGFILE}.OLD
echo "ftp procedure started at: `date`"|tee ${LOGFILE}
echo "XHOST ${XHOST}" |tee -a ${LOGFILE}
chmod 666 ${LOGFILE}
ls -l   ${BASE}/codeback.tar | tee -a ${LOGFILE}

cd $BASE
if [ ! -f ${FILE} ]; then
   echo "File ${FILE} is Missing...script $0 ends at `date`" | tee -a ${LOGFILE}
   exit 1
fi
echo "Have File ${FILE}"  | tee -a ${LOGFILE}

XMIT=/tmp/codeback_ftp.xmitfile
echo ${XMIT} | tee -a ${LOGFILE}

if [ -f ${LOGFILE} ]; then
   mv ${LOGFILE} ${LOGFILE}.OLD
fi
echo "Begins at: `date`" | tee -a ${LOGFILE}

echo ${FILE} | tee -a ${LOGFILE}
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
rm ${FTPDEST}

  #-----setup get File FTP stuff
  echo "user $FTPUSER $FTPPASS"  > ${XMIT}
  echo "prompt"                  >> ${XMIT}
  echo "binary"                  >> ${XMIT}
  echo "cd ${DIR}"               >> ${XMIT}
  echo "put ${FILE}"             >> ${XMIT}
#  echo "chmod 666 ${FILE}"      >> ${XMIT}
  echo "dir ${FILE} ${FTPDEST}"  >> ${XMIT}
  echo "bye"                     >> ${XMIT}
chmod 666 ${XMIT}

#------Perform the FTP Script---------------------------
   echo "Transmit the ${FILE} File to $FTPHOST" | tee -a ${LOGFILE}
   echo "--------------------------------------------------" | tee -a ${LOGFILE}
   ftp -vin $FTPHOST < ${XMIT} >> ${LOGFILE}
   STAT=$?
   echo "--------------------------------------------------" | tee -a ${LOGFILE}
   echo "FTP Status code ${STAT}." | tee -a ${LOGFILE}
#   rm -f ${XMIT}

   #------verify data was transfered correctly-----------------
   SSIZ=`ls -l ${FILE} |awk '{print $5}'`
#   RSIZ=`grep ftp ${LOGFILE} |grep .tar|awk '{print $5}'`
   RSIZ=`grep ${FILE} ${FTPDEST}|awk '{print $5}'`
   echo "\nSending Size: ${SSIZ}   Transmitted Size:  ${RSIZ}" | tee -a ${LOGFILE}
   if [ "${SSIZ}" -ne "${RSIZ}" ]; then
      echo "What we sent: ${SSIZ} DOES NOT MATCH received size: ${RSIZ}" | tee -a ${LOGFILE}
      STAT=8
   else
      echo "What we sent: ${SSIZ} DOES MATCH received size: ${RSIZ}" | tee -a ${LOGFILE}
      STAT=0
   fi    
   echo "Local File:" | tee -a ${LOGFILE}
   ls -l ${FILE} >> ${LOGFILE}
   echo "Transmit ends at: `date`" | tee -a ${LOGFILE}
echo $STAT
   #-----send the mail message--------------------------
   if [ ${STAT} -eq 0 ]; then
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
