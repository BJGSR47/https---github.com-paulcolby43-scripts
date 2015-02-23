#!/bin/ksh
#   trf-swxgl.sh      :: No Parameters Required                   
# Transfers the General Ledger Reports and Files 
#----------------------------------------------------

. /home/prod/scripts/.security.swxgl  
#   NOTIFY=" barry@tranact.com \
#            bj@tranact.com "
   NOTIFY=" barry@tranact.com \
            scott@tranact.com \
            bj@tranact.com "            

SPATH=../data
LPATH=../logs 
LOG=../logs/trf-swxgl.log
 tcmds=${SPATH}/trf-swxgl.cmd
 DPATH="GeneralLedger"                     
 NOW=$(date +"%m%d%y")                    
FILE1=logext.log
FILE2=fee_conv.log
FILE3=fee_ext.log
FILE4=fee_split.log
FILE5=extract.out
FILE6=gl_trans.txt
FILE7=gl_trans_by_gl.txt
FILE8=fee_conv.txt
FILE9=fees_sent_to_swx.txt
FILE10=unk_gl_fees.txt
FILE11=gl_total.txt
FILE12=gl_extract.txt
FILE13=gl_tran_by_block.txt
FILE14=glout.txt
FILE15=daily_fee_charge.txt
FILE16=daily_fee_charge_err.txt
FILE17=daily_fee_split.txt
FILE99=glout.txt
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

# Now we'll do the data and reports. They are in the data directory

echo "lcd ${SPATH}" >> $tcmds
cd ${SPATH}

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

# NOTE: This is a backup of the GL Extract file to the daily directory
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

# NOTE: This is the GL extract file and goes in a different directory
#       to eliminate switching back and forth between directories
#       it is moved last (BJG)
if [ ! -f $FILE99 ]; then
    echo "File $FILE99 is missing..."|tee -a $LOG
else
  echo "cd /Public/ProgramFiles/Transact" >> $tcmds
  echo "put $FILE99" >> $tcmds
  echo -e "\n File Name To Send: $FILE99"|tee -a $LOG
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
   SUBJ="`hostname` - ** ERRORS SWXGL File Transfers `hostname`"
   date|tee -a $LOG
   echo "========================"|tee -a $LOG
 else
#--- Build Email Message -----------------------------
  SUBJ="`hostname` - GL Extract File Transfers `hostname`"

  echo -e "\n SWXGL File Transfer "|tee -a $LOG
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
