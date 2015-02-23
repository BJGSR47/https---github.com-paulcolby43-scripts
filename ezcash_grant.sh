#  ezcash_grant.sh
#  Creation Date:  7/23/12
#  Modified
#  Description:
#  Use to grant database permissions to Applications
#  so that they can execute programs required of them.
#
#  Caution:
#  Issue very discretely!
#
#  Usage:
#  logon as swx
#  execute the following script using the necessary 2 parameters 
#
#  ezcash_grant.sh <user_name>
# 
#  To revoke these permissions, change the grant statement words
#  'grant' and 'to'.  The 'grant' becomes 'revoke' and the 'to' 
#  becomes 'from'.
#
cd /home/prod/scripts
NOTIFY=" barry@tranact.com \
         scott@tranact.com \
         bj@tranact.com " 
LOGFILE="../logs/ezcash_grant.log"

cat >/tmp/ezcash_grant.sql<<DONE
grant CONNECT to $1;
grant SELECT on "swx".account_status to $1;
grant SELECT on "swx".void_codes to $1;
grant SELECT on "swx".account_type to $1;
grant SELECT on "swx".transaction_fees to $1;
grant SELECT, UPDATE, INSERT on "swx".cardholder_tran to $1;
grant SELECT on "swx".account_log to $1;
grant SELECT, UPDATE, INSERT on "swx".account to $1;
grant SELECT, UPDATE, INSERT on "swx".cardholder_name to $1;
grant SELECT, UPDATE, INSERT on "swx".cardholder to $1;
grant SELECT on "swx".standby_auth to $1;
grant SELECT on "swx".log_record to $1;
grant SELECT on "swx".log_record_hist to $1;
grant SELECT on "swx".card_issue to $1;
grant SELECT on "swx".institution to $1;
grant SELECT, UPDATE, INSERT on "swx".branch_desc to $1;
grant SELECT on "swx".switch_fees to $1;
grant SELECT on "swx".tgs_gl_desc to $1;
grant SELECT, UPDATE, INSERT, DELETE on "swx".tgs_svc_chg_hist to $1;
grant SELECT, UPDATE, INSERT, DELETE on "swx".tgs_tran_status_desc to $1;
grant SELECT, UPDATE, INSERT, DELETE on "swx".tgs_transactiontypes to $1;
grant SELECT, UPDATE, INSERT, DELETE on "swx".tgs_gl_ext to $1;
grant SELECT, UPDATE, INSERT, DELETE on "swx".tgs_batch_charges to $1;
grant SELECT, UPDATE, INSERT, DELETE on "swx".tgs_tran_fees to $1;
grant SELECT, UPDATE, INSERT, DELETE on "swx".tgs_fee_share to $1;
grant SELECT, UPDATE, INSERT, DELETE on "swx".tgs_out_msgs to $1;

DONE
dbaccess -e $DBNAME /tmp/ezcash_grant.sql > ${LOGFILE} 2>&1
sed 's/$'"/`echo \\\r`/" ${LOGFILE} > ${LOGFILE}.txt
SUBJ="Permissions Granted to $1"
for RECP in $NOTIFY
do
    mail -s "${SUBJ}" ${RECP} < ${LOGFILE}  
done
