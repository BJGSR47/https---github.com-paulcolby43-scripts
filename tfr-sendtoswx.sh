#!/bin/ksh
#   trf-sendtoswx.sh      :: No Parameters Required                   
# Transfers the sendtoswx Reports Files 
#----------------------------------------------------

. /home/prod/scripts/.security.swxgl  
#   NOTIFY=" barry@tranact.com \
#            bj@tranact.com "
   NOTIFY=" barry@tranact.com \
            scott@tranact.com \
            bj@tranact.com "            

SPATH=../data 
LOG=../logs/trf-sendtoswx.log
 tcmds=${SPATH}/trf-sendtoswx.cmd
 DPATH="GeneralLedger"                     
 NOW=$(date +"%m%d%y")                    
FILE1=trans_sent_to_swx.txt
touch $LOG
cat /dev/null > $LOG

cd $SPATH
  touch $tcmds
  echo "user $FTPUSER $FTPPASS" > $tcmds
  echo "cd $DPATH" >> $tcmds
  echo "mkdir $NOW" >> $tcmds
  echo "cd $NOW" >> $tcmds
  echo "ascii" >> $tcmds

#--- Build Script to Transmit the Files ---
if [ ! -f $FILE1 ]; then
    echo "File $FILE1 is missing..."|tee -a $LOG
else
  echo "put $FILE1" >> $tcmds
  echo -e "\n File Name to Send: $FILE1"|tee -a $LOG
fi
  echo "bye" >> $tcmds
  echo -e "Beginning ftp process " |tee -a $LOG
  cat $tcmds | ftp -vin $FTPHOST |tee -a $LOG
  LSTAT=$?         
  if [ "$LSTAT" != "0" ]; then
     echo "Errors found in transmit, Code: $LSTAT"|tee -a $LOG
     echo "Problems with Sending Files at `date`" |tee -a $LOG
   echo "Transfers may be incomplete......." |tee -a $LOG
   SUBJ="`hostname` - ** ERRORS SENDTOSWX File Transfers `hostname`"
   date|tee -a $LOG
   echo "========================"|tee -a $LOG
   mail -s "${SUBJ}" ${NOTIFY} < $LOG
     sleep 3
     exit 1
 fi
#--- Build Email Message -----------------------------
  SUBJ="`hostname` - SENDTOSWX File Transfers `hostname`"

  echo -e "\n SENDTOSWX Report File Transfer "|tee -a $LOG
  echo -e "\n Transmited    at: `date`   "|tee -a $LOG
  echo -e "\n Server   Address: $FTPHOST "|tee -a $LOG
  echo -e "\n Server File Path:    $DPATH   "|tee -a $LOG
#--- send an email to notify recepient ---
  mail -s "${SUBJ}" ${NOTIFY} < $LOG
     sleep 3

#--- now clean up the mess we made -----
#rm -f $tcmds
#rm -f $LOG

exit $LSTAT
