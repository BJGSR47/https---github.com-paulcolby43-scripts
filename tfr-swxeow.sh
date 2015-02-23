#!/bin/ksh
#   trf-swxeow.sh      :: No Parameters Required                   
# Transfers the swxeow Reports Files 
#----------------------------------------------------

. /home/prod/scripts/.security.swxeow  
#   NOTIFY=" barry@tranact.com \
#            bj@tranact.com "
   NOTIFY=" barry@tranact.com \
            scott@tranact.com \
            bj@tranact.com "            

SPATH=../data 
LOG=../logs/trf-swxeow.log
 tcmds=${SPATH}/trf-swxeow.cmd
 DPATH="swxeow"                     
 NOW=$(date +"%m%d%y")                    
FILE1=htcl_list.txt
FILE2=card_list.txt
FILE3=svc_list.txt
FILE4=load_vel.txt
FILE5=unlinked.txt
FILE6=com_elmnt.txt
FILE7=fieldchk.txt
FILE8=card_load*.txt
FILE9=fee_verify.txt
FILE10=audit_logrpt.txt
FILE11=tgs_audit_logrpt.txt
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
if [ ! -f $FILE4 ]; then
    echo "File $FILE4 is missing..."|tee -a $LOG
else
  echo "put $FILE4" >> $tcmds
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
  echo "mput $FILE8" >> $tcmds
  echo -e "\n File Name to Send: $File8"|tee -a $LOG
fi
if [ ! -f $FILE9 ]; then
    echo "File $FILE9 is missing..."|tee -a $LOG
else
  echo "mput $FILE9" >> $tcmds
  echo -e "\n File Name to Send: $File9"|tee -a $LOG
fi
if [ ! -f $FILE10 ]; then
    echo "File $FILE10 is missing..."|tee -a $LOG
else
  echo "mput $FILE10" >> $tcmds
  echo -e "\n File Name to Send: $File10"|tee -a $LOG
fi
if [ ! -f $FILE11 ]; then
    echo "File $FILE11 is missing..."|tee -a $LOG
else
  echo "mput $FILE11" >> $tcmds
  echo -e "\n File Name to Send: $File11"|tee -a $LOG
fi

  echo "bye" >> $tcmds
  echo -e "Beginning ftp process " |tee -a $LOG
  cat $tcmds | ftp -vin $FTPHOST |tee -a $LOG
  LSTAT=$?         
  if [ "$LSTAT" != "0" ]; then
     echo "Errors found in transmit, Code: $LSTAT"|tee -a $LOG
     echo "Problems with Sending Files at `date`" |tee -a $LOG
   echo "Transfers may be incomplete......." |tee -a $LOG
   SUBJ="`hostname` - ** ERRORS SWXEOW File Transfers `hostname`"
   date|tee -a $LOG
   echo "========================"|tee -a $LOG
 else
#--- Build Email Message -----------------------------
  SUBJ="`hostname` - SWXEOW File Transfers `hostname`"

  echo -e "\n SWXEOW Report File Transfer "|tee -a $LOG
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
