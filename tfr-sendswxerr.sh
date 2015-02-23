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
LPATH=../logs 
LOG=../logs/trf-sendswxerr.log
 tcmds=${SPATH}/trf-sendswxerr.cmd
 DPATH="GeneralLedger"                     
 NOW=$(date +"%m%d%y")                    
FILE1=sendswxerr.log
FILE2=trans_sent_unproc.txt
FILE3=trans_sent_voids.txt
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

# Let's do log files first. They are in the logs directory
  echo "lcd ${LPATH}" >> $tcmds
cd ${LPATH}
if [ ! -f $FILE1 ]; then
    echo "File $FILE1 is missing..."|tee -a $LOG
else
  echo "put $FILE1" >> $tcmds
  echo -e "\n File Name to Send: $FILE1"|tee -a $LOG
fi

# Now we'll do the data and reports. They are in the data directory
echo "lcd ${SPATH}" >> $tcmds
cd ${SPATH}
if [ ! -f $FILE2 ]; then
    echo "File $FILE2 is missing..."|tee -a $LOG
else
  echo "put $FILE2" >> $tcmds
  echo -e "\n File Name to Send: $FILE2"|tee -a $LOG
fi
if [ ! -f $FILE3 ]; then
    echo "File $FILE3 is missing..."|tee -a $LOG
else
  echo "put $FILE3" >> $tcmds
  echo -e "\n File Name to Send: $FILE3"|tee -a $LOG
fi
  echo "bye" >> $tcmds
  echo -e "Beginning ftp process " |tee -a $LOG
  cat $tcmds | ftp -vin $FTPHOST |tee -a $LOG
  LSTAT=$?         
  if [ "$LSTAT" != "0" ]; then
     echo "Errors found in transmit, Code: $LSTAT"|tee -a $LOG
     echo "Problems with Sending Files at `date`" |tee -a $LOG
   echo "Transfers may be incomplete......." |tee -a $LOG
   SUBJ="`hostname` - ** ERRORS sendswxerr File Transfers `hostname`"
   date|tee -a $LOG
   echo "========================"|tee -a $LOG
   mail -s "${SUBJ}" ${NOTIFY} < $LOG
     sleep 3
     exit 1
 fi
#--- Build Email Message -----------------------------
  SUBJ="`hostname` - sendswxerr File Transfers `hostname`"

  echo -e "\n sendswxerr Report File Transfer "|tee -a $LOG
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
