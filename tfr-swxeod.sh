#!/bin/ksh
#   trf-swxeod.sh      :: No Parameters Required                   
# Transfers the swxeod Reports Files 
#----------------------------------------------------

. /home/prod/scripts/.security.swxeod  
#   NOTIFY=" barry@tranact.com \
#            bj@tranact.com "
   NOTIFY=" barry@tranact.com \
            scott@tranact.com \
            bj@tranact.com "            

SPATH=../data 
LOG=../logs/trf-swxeod.log
 tcmds=${SPATH}/trf-swxeod.cmd
 DPATH="swxeod"
 NOW=$(date +"%m%d%y")                    
FILE1=no_setl.txt
FILE2=logextbal.txt
FILE3=report_2.txt
FILE4=report_2sum.txt
FILE5=report_4.txt
FILE6=report_12.txt
FILE7=report_sar.txt
FILE8=report_ctr.txt
FILE9=daily_void.txt
FILE10=daily_void_sum.txt
FILE11=chp_fees.txt
FILE12=fgn_trans.txt
FILE13=tran_byhr.txt
FILE14=reversals.txt
FILE15=xs_trans.txt
FILE16=xs_purch.txt
FILE17=bill_pay.txt
FILE18=mult_ssn.txt
FILE19=mult_addr.txt
FILE20=bad_zip.txt
FILE21 = dlycrd_chg.txt
touch $LOG
cat /dev/null > $LOG
#/bin/rm -f $scr.log > /dev/null 2>&1

cd $SPATH
  touch $tcmds
  echo "user $FTPUSER $FTPPASS" > $tcmds
  echo "cd $DPATH" >> $tcmds
  echo "mkdir $NOW" >> $tcmds
  echo "cd $NOW" >> $tcmds
  echo "ascii" >> $tcmds

if [ ! -f $FILE1 ]; then
    echo "File $FILE1 is missing..."|tee -a $LOG
else
  echo "put $FILE1" >> $tcmds
  echo -e "\n File Name To Send: $FILE1"|tee -a $LOG
fi

if [ ! -f $FILE2 ]; then
    echo "File $FILE2 is missing..."|tee -a $LOG
else
  echo "put $FILE2" >> $tcmds
  echo -e "\n File Name To Send: $FILE2"|tee -a $LOG
fi
if [ ! -f $FILE3 ]; then
    echo "File $FILE3 is missing..."|tee -a $LOG
else
  echo "put $FILE3" >> $tcmds
  echo -e "\n File Name To Send: $FILE3"|tee -a $LOG
fi
if [ ! -f $FILE4 ]; then
    echo "File $FILE4 is missing..."|tee -a $LOG
else
  echo "put $FILE4" >> $tcmds
  echo -e "\n File Name To Send: $FILE4"|tee -a $LOG
fi
if [ ! -f $FILE5 ]; then
    echo "File $FILE5 is missing..."|tee -a $LOG
else
  echo "put $FILE5" >> $tcmds
  echo -e "\n File Name To Send: $FILE5"|tee -a $LOG
fi
if [ ! -f $FILE6 ]; then
    echo "File $FILE6 is missing..."|tee -a $LOG
else
  echo "put $FILE6" >> $tcmds
  echo -e "\n File Name To Send: $FILE6"|tee -a $LOG
fi
if [ ! -f $FILE7 ]; then
    echo "File $FILE7 is missing..."|tee -a $LOG
else
  echo "put $FILE7" >> $tcmds
  echo -e "\n File Name To Send: $FILE7"|tee -a $LOG
fi
if [ ! -f $FILE8 ]; then
    echo "File $FILE8 is missing..."|tee -a $LOG
else
  echo "put $FILE8" >> $tcmds
  echo -e "\n File Name To Send: $FILE8"|tee -a $LOG
fi
if [ ! -f $FILE9 ]; then
    echo "File $FILE9 is missing..."|tee -a $LOG
else
  echo "put $FILE9" >> $tcmds
  echo -e "\n File Name To Send: $FILE9"|tee -a $LOG
fi
if [ ! -f $FILE10 ]; then
    echo "File $FILE10 is missing..."|tee -a $LOG
else
  echo "put $FILE10" >> $tcmds
  echo -e "\n File Name To Send: $FILE10"|tee -a $LOG
fi
if [ ! -f $FILE11 ]; then
    echo "File $FILE11 is missing..."|tee -a $LOG
else
  echo "put $FILE11" >> $tcmds
  echo -e "\n File Name To Send: $FILE11"|tee -a $LOG
fi
if [ ! -f $FILE12 ]; then
    echo "File $FILE12 is missing..."|tee -a $LOG
else
  echo "put $FILE12" >> $tcmds
  echo -e "\n File Name To Send: $FILE12"|tee -a $LOG
fi
if [ ! -f $FILE13 ]; then
    echo "File $FILE13 is missing..."|tee -a $LOG
else
  echo "put $FILE13" >> $tcmds
  echo -e "\n File Name To Send: $FILE13"|tee -a $LOG
fi
if [ ! -f $FILE14 ]; then
    echo "File $FILE14 is missing..."|tee -a $LOG
else
  echo "put $FILE14" >> $tcmds
  echo -e "\n File Name To Send: $FILE14"|tee -a $LOG
fi
if [ ! -f $FILE15 ]; then
    echo "File $FILE15 is missing..."|tee -a $LOG
else
  echo "put $FILE15" >> $tcmds
  echo -e "\n File Name To Send: $FILE15"|tee -a $LOG
fi
if [ ! -f $FILE16 ]; then
    echo "File $FILE16 is missing..."|tee -a $LOG
else
  echo "put $FILE16" >> $tcmds
  echo -e "\n File Name To Send: $FILE16"|tee -a $LOG
fi
if [ ! -f $FILE17 ]; then
    echo "File $FILE17 is missing..."|tee -a $LOG
else
  echo "put $FILE17" >> $tcmds
  echo -e "\n File Name To Send: $FILE17"|tee -a $LOG
fi
if [ ! -f $FILE18 ]; then
    echo "File $FILE18 is missing..."|tee -a $LOG
else
  echo "put $FILE18" >> $tcmds
  echo -e "\n File Name To Send: $FILE18"|tee -a $LOG
fi
if [ ! -f $FILE19 ]; then
    echo "File $FILE19 is missing..."|tee -a $LOG
else
  echo "put $FILE19" >> $tcmds
  echo -e "\n File Name To Send: $FILE19"|tee -a $LOG
fi
if [ ! -f $FILE20 ]; then
    echo "File $FILE20 is missing..."|tee -a $LOG
else
  echo "put $FILE20" >> $tcmds
  echo -e "\n File Name To Send: $FILE20"|tee -a $LOG
fi
if [ ! -f $FILE21 ]; then
    echo "File $FILE21 is missing..."|tee -a $LOG
else
  echo "put $FILE21" >> $tcmds
  echo -e "\n File Name To Send: $FILE21"|tee -a $LOG
fi
#--- Build Script to Transmit the Files ---
  echo "bye" >> $tcmds
  echo -e "Beginning ftp process " |tee -a $LOG
  cat $tcmds | ftp -vin $FTPHOST |tee -a $LOG
  LSTAT=$?         
  if [ "$LSTAT" != "0" ]; then
     echo "Errors found in transmit, Code: $LSTAT"|tee -a $LOG
     echo "Problems with Sending Files at `date`" |tee -a $LOG
   echo "Transfers may be incomplete......." |tee -a $LOG
   SUBJ="`hostname` - ** ERRORS SWXEOD File Transfers `hostname`"
   date|tee -a $LOG
   echo "========================"|tee -a $LOG
 else
#--- Build Email Message -----------------------------
  SUBJ="`hostname` - SWXEOD File Transfers `hostname`"

  echo -e "\n SWXEOD Report File Transfer "|tee -a $LOG
  echo -e "\n Transmited    at: `date`   "|tee -a $LOG
  echo -e "\n Server   Address: $FTPHOST "|tee -a $LOG
  echo -e "\n Server File Path:    $DPATH   "|tee -a $LOG
 fi
#--- send an email to notify recepient ---
  mail -s "${SUBJ}" ${NOTIFY} < $LOG
echo "email sent"
     sleep 3

#--- now clean up the mess we made -----
#rm -f $tcmds
#rm -f $LOG

exit $LSTAT
