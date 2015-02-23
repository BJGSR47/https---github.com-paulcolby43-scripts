#!/bin/sh
#userpermit.sh
# this script creates user permission reports for audit/Security Admin
cd /home/prod/4gl
LOG=../logs/user_permit.log
#NOTIFY=" barry@tranact.com \
#         scott@tranact.com \
#         bj@tranact.com " 
NOTIFY=" barry@tranact.com \
         bj@tranact.com " 
date > $LOG

# Remove old reports
rm ../data/user_all.txt
rm ../data/user_cca.txt
rm ../data/user_mon.txt
rm ../data/user_scf.txt
rm ../data/user_snx.txt
rm ../data/no_linux.txt
rm ../data/no_swx.txt
rm ../data/user_prof.txt
rm ../data/user_table.txt

#  Create the swxusers.txt file of users with AIX logons
/scripts/mygetusers3.sh |tee -a $LOG
#
# Client Access by Application (user_all.rpt)
fglgo user_all |tee -a $LOG
#
# System Manager Permissions (user_scf.rpt)
fglgo user_scf |tee -a $LOG
#
# System Monitor Permissions (user_mon.rpt)
fglgo user_mon |tee -a $LOG
#
# uSNITCH/Reports Permissions (user_snx.rpt)
fglgo user_snx |tee -a $LOG
#
# CCM Permissions (user_cca.rpt)
fglgo user_cca |tee -a $LOG
#
# User Profiles Permissions (user_prof.rpt)
fglgo user_prof |tee -a $LOG
#
# Informix Table Permissions (user_table.rpt)
fglgo user_table |tee -a $LOG

EC=$?
TS=`date +"%H:%M:%S  %a %b %e"`
if [ $EC = 0 ]; then
   echo -e "User Permission Reports GOOD \n" | tee -a ${LOG}
   PASSFAIL="GOOD"
else
   echo -e "At least one report FAILED \n" | tee -a ${LOG}
   PASSFAIL="FAILED"
fi

#
# Send Reports to Users
../scripts/userpermit_ftp.sh
EC=$?
if [ $EC = 0 ]; then
   echo -e "FTP GOOD \n" | tee -a ${LOG}
   FTPFAIL="GOOD"
else
   echo -e "FTP FAILED \n" | tee -a ${LOG}
   FTPFAIL="FAILED"
fi

#  Log file will be e-mailed to programmers 
   SUBJ="User Permission Reports ${PASSFAIL} FTP ${FTPFAIL}"

mail -s "${SUBJ}" ${NOTIFY} < $LOG

