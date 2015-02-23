#!/bin/ksh
###############################################################################
# Shell script to backup Informix IDS to disk
# called by daily_back_notape.sh
###############################################################################
## Echo messages to log file

#INFXLOG="/home/prod/logs/in4mix_dump.log"
INFXLOG="/home/swx/inf_logs/in4mix_dump.log"

NOTIFY=" barry@tranact.com \
         colby@tranact.com \
         scott@tranact.com \
         bj@tranact.com " 
MSG="`hostname` - in4mix_dump.sh "
echo -e "Archive Informix Online for $INFORMIXSERVER \n"| tee $INFXLOG
chmod 666 $INFXLOG
## Check for valid backup device
FILENAME=`grep "^TAPEDEV" $INFORMIXDIR/etc/onconfig.swx | cut -f2 -d" "`
echo -e "FILENAME " $FILENAME| tee -a $INFXLOG
if [ "$FILENAME" != "/home/swx/backup/trangateway.bak" ] 
then
   echo -e "Invalid TAPEDEV $FILENAME \n"| tee -a $INFXLOG
   return 1
else
   echo -e "Archive to TAPEDEV $FILENAME \n"| tee -a $INFXLOG
## start with a fresh file....
   rm -f $FILENAME
   touch $FILENAME
   chmod 666 $FILENAME
   
## Verify file exists and is writable
   if [ -w $FILENAME ]
   then
## Start ontape and respond to prompt - the following spacing is key
## There must be a 0 for the level followed by a blank line for the response
## to the prompt.
TS=`date +"%H:%M:%S  %a %b %e"`
echo -e "${TS} - Start $$ - OnTape -s         \n"| tee -a $INFXLOG 
{
ontape -s <<EOF
0

EOF
}
      EC=$?
      TS=`date +"%H:%M:%S  %a %b %e"`
      if [ $EC = 0 ]
      then
         echo -e "Archive completed \n"| tee -a $INFXLOG

         echo -e "Zero Database Statistics \n"| tee -a $INFXLOG
         onstat -z | tee -a $INFXLOG
         echo -e "${TS} - Status $$ - onstat -z  \n"| tee -a $INFXLOG 
         echo -e "${TS} - End $$ - ontape -s  -Good Status $EC \n"| tee -a $INFXLOG 
      else
         echo -e "Archive failed \n"
         echo -e "${TS} - End $$ - ontape -s  -Error Status $EC  \n"| tee -a $INFXLOG 
#         exit 1
         EC=1
      fi
   else
      echo -e "output file $FILENAME must exist prior to execution \n"| tee -a $INFXLOG
##      exit 1
      EC=1
   fi
fi
mail -s "$MSG - LOGFILE" ${NOTIFY} < $INFXLOG

sleep 2
exit $EC