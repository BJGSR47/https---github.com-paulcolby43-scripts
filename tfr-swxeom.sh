#!/bin/ksh
#   trf-swxeom.sh      :: No Parameters Required                   
# Transfers the swxeom Reports Files 
#----------------------------------------------------

. /home/prod/scripts/.security.swxeom  
#   NOTIFY=" barry@tranact.com \
#            bj@tranact.com "
   NOTIFY=" barry@tranact.com \
            scott@tranact.com \
            bj@tranact.com "            

SPATH=../data 
LPATH=../logs 
LOG=../logs/trf-swxeom.log
 tcmds=${SPATH}/trf-swxeom.cmd
 DPATH="swxeom"                     
 NOW=$(date +"%m%d%y")                    
FILE1=bill_inact.log
FILE2=inact_refd.log
FILE3=inact_refd.log
FILE4=mth_cards*
FILE5=unsold*
FILE6=card_list*
FILE7=fee_sched_*.txt
FILE8=top_50.txt
FILE9=inactive_rpt.txt
FILE10=inactive_errs.txt
FILE11=inactrefd_rpt.txt
FILE12=inactrefd_errs.txt
FILE13=inactrefd_rpt.txt
FILE14=inactrefd_errs.txt
touch $LOG
cat /dev/null > $LOG

cd $SPATH
  touch $tcmds
  echo "user $FTPUSER $FTPPASS" > $tcmds
  echo "cd $DPATH" >> $tcmds
  echo "mkdir $NOW" >> $tcmds
  echo "cd $NOW" >> $tcmds
  echo "ascii" >> $tcmds

# Let's do log files first. They are in the logs directory

  echo "lcd ${LPATH}" >> $tcmds
cd ${LPATH}

#--- Build Script to Transmit the Files ---
if [ ! -f $FILE1 ]; then
    echo "File $FILE1 is missing..."|tee -a $LOG
else
  echo "mput $FILE1" >> $tcmds
  echo -e "\n File Name to Send: $FILE1"|tee -a $LOG
fi

if [ ! -f $FILE2 ]; then
    echo "File $FILE2 is missing..."|tee -a $LOG
else
  echo "mput $FILE2" >> $tcmds
  echo -e "\n File Name to Send: $FILE2"|tee -a $LOG
fi
if [ ! -f $FILE3 ]; then
    echo "File $FILE3 is missing..."|tee -a $LOG
else
  echo "mput $FILE3" >> $tcmds
  echo -e "\n File Name to Send: $FILE3"|tee -a $LOG
fi

# Now we'll do the data and reports. They are in the data directory

echo "lcd ${SPATH}" >> $tcmds
cd ${SPATH}
if [ ! -f $FILE4 ]; then
    echo "File $FILE4 is missing..."|tee -a $LOG
else
  echo "mput $FILE4" >> $tcmds
  echo -e "\n File Name to Send: $FILE4"|tee -a $LOG
fi
if [ ! -f $FILE5 ]; then
    echo "File $FILE5 is missing..."|tee -a $LOG
else
  echo "put $FILE5" >> $tcmds
  echo -e "\n File Name to Send: $FILE5"|tee -a $LOG
fi
if [ ! -f $FILE6 ]; then
    echo "File $FILE6 is missing..."|tee -a $LOG
else
  echo "put $FILE6" >> $tcmds
  echo -e "\n File Name to Send: $FILE6"|tee -a $LOG
fi
if [ ! -f $FILE7 ]; then
    echo "File $FILE7 is missing..."|tee -a $LOG
else
  echo "put $FILE7" >> $tcmds
  echo -e "\n File Name to Send: $FILE7"|tee -a $LOG
fi
if [ ! -f $FILE8 ]; then
    echo "File $FILE8 is missing..."|tee -a $LOG
else
  echo "put $FILE8" >> $tcmds
  echo -e "\n File Name to Send: $FILE8"|tee -a $LOG
fi
if [ ! -f $FILE9 ]; then
    echo "File $FILE9 is missing..."|tee -a $LOG
else
  echo "put $FILE9" >> $tcmds
  echo -e "\n File Name to Send: $FILE9"|tee -a $LOG
fi
if [ ! -f $FILE10 ]; then
    echo "File $FILE10 is missing..."|tee -a $LOG
else
  echo "put $FILE10" >> $tcmds
  echo -e "\n File Name to Send: $FILE10"|tee -a $LOG
fi
if [ ! -f $FILE11 ]; then
    echo "File $FILE11 is missing..."|tee -a $LOG
else
  echo "put $FILE11" >> $tcmds
  echo -e "\n File Name to Send: $FILE11"|tee -a $LOG
fi
if [ ! -f $FILE12 ]; then
    echo "File $FILE12 is missing..."|tee -a $LOG
else
  echo "put $FILE12" >> $tcmds
  echo -e "\n File Name to Send: $FILE12"|tee -a $LOG
fi
if [ ! -f $FILE13 ]; then
    echo "File $FILE13 is missing..."|tee -a $LOG
else
  echo "put $FILE13" >> $tcmds
  echo -e "\n File Name to Send: $FILE13"|tee -a $LOG
fi
if [ ! -f $FILE14 ]; then
    echo "File $FILE14 is missing..."|tee -a $LOG
else
  echo "put $FILE14" >> $tcmds
  echo -e "\n File Name to Send: $FILE14"|tee -a $LOG
fi

  echo "bye" >> $tcmds
  echo -e "Beginning ftp process " |tee -a $LOG
  cat $tcmds | ftp -vin $FTPHOST |tee -a $LOG
  LSTAT=$?         
  if [ "$LSTAT" != "0" ]; then
     echo "Errors found in transmit, Code: $LSTAT"|tee -a $LOG
     echo "Problems with Sending Files at `date`" |tee -a $LOG
   echo "Transfers may be incomplete......." |tee -a $LOG
   SUBJ="`hostname` - ** ERRORS SWXEOM File Transfers `hostname`"
   date|tee -a $LOG
   echo "========================"|tee -a $LOG
 else
#--- Build Email Message -----------------------------
  SUBJ="`hostname` - SWXEOM File Transfers `hostname`"

  echo -e "\n SWXEOM Report File Transfer "|tee -a $LOG
  echo -e "\n Transmited    at: `date`   "|tee -a $LOG
  echo -e "\n Server   Address: $FTPHOST "|tee -a $LOG
  echo -e "\n Server File Path:    $DPATH   "|tee -a $LOG
 fi
#--- send an email to notify recepient ---
  mail -s "${SUBJ}" ${NOTIFY} < $LOG
     sleep 3

#--- now clean up the mess we made -----
#rm -f $tcmds
#rm -f $LOG

exit $LSTAT
