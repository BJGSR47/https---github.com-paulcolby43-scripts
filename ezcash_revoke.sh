#  ezcash_revoke.sh
#  Creation Date:  6/10/14
#  Modified
#  Description:
#  Use to revoke database permissions from Applications
#
#  Caution:
#  Issue very discretely!
#
#  Usage:
#  logon as swx
#  execute the following script using the necessary parameter 
#
#  ezcash_grant.sh <user_name>
# 
#
cd /home/prod/scripts
NOTIFY=" barry@tranact.com \
         scott@tranact.com \
         bj@tranact.com " 
LOGFILE="../logs/ezcash_revoke.log"

cat >/tmp/ezcash_revoke.sql<<DONE
revoke CONNECT from $1;
revoke ALL on account_status from $1;
revoke ALL on card_issue from $1;
revoke ALL on standby_auth from $1;
revoke ALL on institution from $1;
revoke ALL on void_codes from $1;
revoke ALL on account_log from $1;
revoke ALL on account_type from $1;
revoke ALL on log_record_hist from $1;
revoke ALL on standby_auth from $1;
revoke ALL on transaction_fees from $1;
revoke ALL on switch_fees from $1;
revoke ALL on tgs_gl_desc from $1;
revoke ALL on branch_desc from $1;
revoke ALL, UPDATE, INSERT on company from $1;
revoke ALL on account from $1;
revoke ALL on cardholder from $1;
revoke ALL on cardholder_name from $1;
revoke ALL on cardholder_tran from $1;
revoke ALL on tgs_svc_chg_hist from $1;
revoke ALL on tgs_batch_charges from $1;
revoke ALL on tgs_transactiontypes from $1;
revoke ALL on tgs_tran_status_desc from $1;

revoke ALL on log_record from $1;
revoke ALL on tgs_gl_ext from $1;
revoke ALL on tgs_tran_fees from $1;
revoke ALL on tgs_fee_share from $1;
revoke ALL on tgs_out_msgs from $1;

DONE
dbaccess -e $DBNAME /tmp/ezcash_revoke.sql > ${LOGFILE} 2>&1
sed 's/$'"/`echo \\\r`/" ${LOGFILE} > ${LOGFILE}.txt
SUBJ="Permissions Revoked from $1"
for RECP in $NOTIFY
do
    mail -s "${SUBJ}" ${RECP} < ${LOGFILE}  
done
