#!/bin/ksh
###############################################################################
# Shell script to backup needed non-system files to DR
###############################################################################
## Echo messages to log file
CODELOG="/home/prod/logs/codeback.log"

NOTIFY=" barry@tranact.com \
         colby@tranact.com \
         scott@tranact.com \
         bj@tranact.com "
#NOTIFY=" barry@tranact.com " 

MSG="`hostname` -codeback.sh "
FILENAME="/home/swx/codeback.tar"
cd /home/swx
echo -e "Archive non-system files for `hostname` \n"| tee ${CODELOG}
   rm -f $FILENAME
   touch $FILENAME
   chmod 666 $FILENAME
   chmod 666 $CODELOG
ls -l | grep '^[^d]' | awk '{print $9}' > codeback.txt| tee -a ${CODELOG}
find /home/swx/datafiles -name '*.lod' >> codeback.txt| tee -a ${CODELOG}
find /home/swx/datafiles -name '*.cfg' >> codeback.txt| tee -a ${CODELOG}
find /home/swx/datafiles -name '*.CFG' >> codeback.txt| tee -a ${CODELOG}
{
cat >> codeback.txt<<EOF
/home/swx/barry/
/home/swx/shell/
/scripts/
/home/prod/4gl/
/home/prod/scripts/
EOF
}| tee -a ${CODELOG}
TS=`date +"%H:%M:%S  %a %b %e"`
echo -e "${TS} - Start - tar cvpPT         \n"| tee -a ${CODELOG}

tar cvpPT /home/swx/codeback.txt -f ${FILENAME} >> ${CODELOG}

EC=$?
TS=`date +"%H:%M:%S  %a %b %e"`
if [ $EC = 0 ]
then
   echo -e "Code Archive completed \n"| tee -a ${CODELOG}
   echo -e "${TS} - End - tar cvpPT  -Good Status $EC \n"| tee -a ${CODELOG} 
else
   echo -e "Code Archive failed \n"
   echo -e "${TS} - End - tar cvpPT  -Error Status $EC  \n"| tee -a ${CODELOG} 
   EC=1
fi
echo -e " Backup File Created: \n" | tee -a ${CODELOG}
  ls -l   ${FILENAME} | tee -a ${CODELOG}

echo -e "Backup procedure ended at: `date` \n"|tee -a ${CODELOG}

/scripts/codeback_ftp.sh
mail -s "$MSG - LOGFILE" ${NOTIFY} < ${CODELOG}

wait 2
exit $EC