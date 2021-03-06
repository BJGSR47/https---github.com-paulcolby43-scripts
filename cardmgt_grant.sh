#  cardmgt_grant.sh
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
#  execute the following script using the necessary parameter
#
#  cardmgt_grant.sh <user_name>
#
#  To revoke these permissions, change the grant statement words
#  'grant' and 'to'.  The 'grant' becomes 'revoke' and the 'to'
#  becomes 'from'.
#
cd /home/prod/scripts
NOTIFY=" barry@tranact.com \
         scott@tranact.com \
         bj@tranact.com "
LOGFILE="../logs/cardmgt_grant.log"

cat >/tmp/cardmgt_grant.sql<<DONE
grant CONNECT to $1;
grant SELECT on account to $1;
grant SELECT on branch_desc to $1;
grant SELECT on card_classes to $1;
grant SELECT on card_issue to $1;
grant SELECT on cardholder to $1;
grant SELECT on cardholder_name to $1;
grant SELECT on cardholder_tran to $1;
grant SELECT on company to $1;
grant SELECT on institution to $1;
grant SELECT on account_type to $1;
grant SELECT on log_record to $1;
grant SELECT on log_record_hist to $1;
grant SELECT on standby_auth to $1;
grant SELECT on tgs_gl_desc to $1;
grant SELECT on tgs_svc_chg_accum to $1;
grant SELECT on tgs_svc_chg_hist to $1;
grant SELECT on void_codes to $1;
grant SELECT on tgs_out_msgs to "noreply" as "swx";
grant UPDATE on tgs_out_msgs to "noreply" as "swx";
grant INSERT on tgs_out_msgs to "noreply" as "swx";

DONE
dbaccess -e $DBNAME /tmp/cardmgt_grant.sql > ${LOGFILE}
sed 's/$'"/`echo \\\r`/" ${LOGFILE} >${LOGFILE}.txt
SUBJ="Permissions Granted to $1"
for RECP in $NOTIFY
do
    mail -s "${SUBJ}" ${RECP} < ${LOGFILE}
done
