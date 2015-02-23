#!/bin/ksh
# tgs_update_stat.sh
LOG="/home/swx/inf_logs/tgs_update_stat.log"
NOTIFY=" barry@tranact.com \
         colby@tranact.com \
         scott@tranact.com \
         bj@tranact.com " 
MSG="`hostname` - tgs_update_stat.sh "
###############################################################################
date > $LOG
echo "==================================" >> $LOG
onstat -g seg >> $LOG  2>> $LOG
echo "==================================" >> $LOG
echo "===ipcs -ma|grep swx =============" >> $LOG
ipcs -ma|grep swx >> $LOG  2>> $LOG
echo "==================================" >> $LOG
echo "===ipcs -ma|wc -l =(total nbr)====" >> $LOG
ipcs -ma|wc -l >> $LOG  2>> $LOG
echo "==================================" >> $LOG
echo "Running onmode -F" >> $LOG 2>> $LOG
onmode -F >> $LOG  2>> $LOG

echo "==================================" >> $LOG
echo "Updating Statistics for Informix Tables"
echo "Updating Statistics for Informix Tables" >> $LOG
date >> $LOG

cat >/tmp/tables.sql<<DONE
DATABASE trangateway;
UPDATE STATISTICS MEDIUM FOR TABLE user_name  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE user_name (user_id);
UPDATE STATISTICS MEDIUM FOR TABLE account_status  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE account_status (code);
UPDATE STATISTICS MEDIUM FOR TABLE language  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE language (code);
UPDATE STATISTICS MEDIUM FOR TABLE account_type_log  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE account_type_log (ch_datetime) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE account_type_log (ch_datetime, ch_user_id, ch_type);
UPDATE STATISTICS MEDIUM FOR TABLE card_issue_log  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE card_issue_log (ch_datetime) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE card_issue_log (ch_datetime, ch_user_id, ch_type);
UPDATE STATISTICS MEDIUM FOR TABLE institution_log  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE institution_log (ch_datetime) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE institution_log (ch_datetime, ch_user_id, ch_type);
UPDATE STATISTICS MEDIUM FOR TABLE account_type_def  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE account_type_def (acct_type_index);
UPDATE STATISTICS HIGH FOR TABLE account_type_def (acct_type);
UPDATE STATISTICS MEDIUM FOR TABLE void_codes  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE void_codes (void_code);
UPDATE STATISTICS MEDIUM FOR TABLE account_type  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE account_type (institution);
UPDATE STATISTICS HIGH FOR TABLE account_type ( acct_type_index ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE account_type (institution, acct_type_index);
UPDATE STATISTICS MEDIUM FOR TABLE bin_range  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE bin_range (bin_low);
UPDATE STATISTICS HIGH FOR TABLE bin_range (bin_high);
UPDATE STATISTICS MEDIUM FOR TABLE type_codes  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE type_codes (type_code);
UPDATE STATISTICS MEDIUM FOR TABLE curr_seq_nbr ;
UPDATE STATISTICS MEDIUM FOR TABLE pos_totals_desc  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE pos_totals_desc (total_type);
UPDATE STATISTICS MEDIUM FOR TABLE device_status_desc ;
UPDATE STATISTICS MEDIUM FOR TABLE status_history  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE status_history (device_id);
UPDATE STATISTICS HIGH FOR TABLE status_history (date_time);
UPDATE STATISTICS HIGH FOR TABLE status_history (swx_status);
UPDATE STATISTICS MEDIUM FOR TABLE cash_sat  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cash_sat (device_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE cash_sat (device_id, cannister_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE cash_sat_hist ;
UPDATE STATISTICS MEDIUM FOR TABLE transaction_fees  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE transaction_fees (institution) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE transaction_fees (institution, auth_name, auth_flag, pri_tran_code, sec_tran_code);
UPDATE STATISTICS MEDIUM FOR TABLE error_desc  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE error_desc (error_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE rules_description  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE rules_description (rule_type) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE rules_description (rule_type, name);
UPDATE STATISTICS MEDIUM FOR TABLE scf_access  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE scf_access (user_id);
UPDATE STATISTICS MEDIUM FOR TABLE atm_config ;
UPDATE STATISTICS MEDIUM FOR TABLE cca_access  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cca_access (user_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE cca_access (user_id, bin);
UPDATE STATISTICS MEDIUM FOR TABLE negative  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE negative (bin) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE negative (bin, cardholder, member);
UPDATE STATISTICS MEDIUM FOR TABLE pos  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE pos (device_id);
UPDATE STATISTICS MEDIUM FOR TABLE status_translator  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE status_translator (msg_format) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE status_translator (msg_format, native_status);
UPDATE STATISTICS MEDIUM FOR TABLE pos_totals  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE pos_totals (device_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE pos_totals (device_id, total_type);
UPDATE STATISTICS MEDIUM FOR TABLE sup_device ;
UPDATE STATISTICS MEDIUM FOR TABLE atm_sat ;
UPDATE STATISTICS MEDIUM FOR TABLE comm_history  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE comm_history (sun) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE comm_history (sun, date_time);
UPDATE STATISTICS MEDIUM FOR TABLE colorinfo  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE colorinfo (color);
UPDATE STATISTICS MEDIUM FOR TABLE comm_dev_stat ;
UPDATE STATISTICS MEDIUM FOR TABLE calendar  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE calendar (cal_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE calendar (cal_id, bus_day);
UPDATE STATISTICS MEDIUM FOR TABLE log_details  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE log_details (sys_seq_nbr);
UPDATE STATISTICS HIGH FOR TABLE log_details (event_code) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE log_details (event_code, auth_name, event_time);
UPDATE STATISTICS MEDIUM FOR TABLE pin_alg_desc  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE pin_alg_desc (code);
UPDATE STATISTICS MEDIUM FOR TABLE curr_comm_status  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE curr_comm_status (sun);
UPDATE STATISTICS MEDIUM FOR TABLE curr_atm_status  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE curr_atm_status (device_id);
UPDATE STATISTICS MEDIUM FOR TABLE encode_decode ;
UPDATE STATISTICS MEDIUM FOR TABLE sec_type_desc  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sec_type_desc (sec_type);
UPDATE STATISTICS MEDIUM FOR TABLE iso8583_accounts  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE iso8583_accounts (node_name);
UPDATE STATISTICS HIGH FOR TABLE iso8583_accounts ( node_acct_type ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE iso8583_accounts (node_name, node_acct_type);
UPDATE STATISTICS MEDIUM FOR TABLE tran_code_desc  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE tran_code_desc (pri_tran_code);
UPDATE STATISTICS MEDIUM FOR TABLE system_sec_types ;
UPDATE STATISTICS MEDIUM FOR TABLE merchant_types  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE merchant_types (code);
UPDATE STATISTICS MEDIUM FOR TABLE sup_auth  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sup_auth (bin) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE sup_auth (bin, cardholder);
UPDATE STATISTICS MEDIUM FOR TABLE cal_name  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cal_name (cal_id);
UPDATE STATISTICS MEDIUM FOR TABLE swx_status_codes  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE swx_status_codes (swx_status);
UPDATE STATISTICS MEDIUM FOR TABLE timer ;
UPDATE STATISTICS MEDIUM FOR TABLE bin_translate ;
UPDATE STATISTICS MEDIUM FOR TABLE purge_data ;
UPDATE STATISTICS MEDIUM FOR TABLE monitor_access  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE monitor_access (user_id);
UPDATE STATISTICS MEDIUM FOR TABLE iso8583_bits  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE iso8583_bits (node_name);
UPDATE STATISTICS HIGH FOR TABLE iso8583_bits ( bit_nbr ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE iso8583_bits (node_name, bit_nbr, msg_type);
UPDATE STATISTICS MEDIUM FOR TABLE cca_rules  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cca_rules (vel_neg_flag) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE cca_rules (vel_neg_flag, term_type, pri_tran_code, sec_tran_code, index_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE pos_access  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE pos_access (user_id);
UPDATE STATISTICS MEDIUM FOR TABLE merchant_status  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE merchant_status (code);
UPDATE STATISTICS MEDIUM FOR TABLE merchant  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE merchant (id);
UPDATE STATISTICS MEDIUM FOR TABLE switch_negative  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE switch_negative (seq_nbr);
UPDATE STATISTICS HIGH FOR TABLE switch_negative (bin, cardholder);
UPDATE STATISTICS MEDIUM FOR TABLE cardholder_status  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cardholder_status (code);
UPDATE STATISTICS MEDIUM FOR TABLE function_call  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE function_call (function_call);
UPDATE STATISTICS HIGH FOR TABLE function_call ( seq_nbr ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE function_call (function_call, seq_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE vru_opcodes ;
UPDATE STATISTICS MEDIUM FOR TABLE tp_type_codes  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE tp_type_codes (tp_type);
UPDATE STATISTICS MEDIUM FOR TABLE ach_tran_codes ;
UPDATE STATISTICS MEDIUM FOR TABLE cmd_queue ;
UPDATE STATISTICS MEDIUM FOR TABLE tran_codes  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE tran_codes (tp_type) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE tran_codes (tp_type, tran_type, pri_tran_code, sec_tran_code);
UPDATE STATISTICS MEDIUM FOR TABLE cardholder_tran  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cardholder_tran (bin) DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cardholder_tran (bin, cardholder, member, tran_datetime);
UPDATE STATISTICS HIGH FOR TABLE cardholder_tran ( acct_nbr ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cardholder_tran ( cardholder) DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cardholder_tran (bin, acct_nbr);
UPDATE STATISTICS HIGH FOR TABLE cardholder_tran (sys_seq_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE security_settings ;
UPDATE STATISTICS MEDIUM FOR TABLE account_log  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE account_log (ch_datetime);
UPDATE STATISTICS HIGH FOR TABLE account_log (ch_user_id);
UPDATE STATISTICS HIGH FOR TABLE account_log (bin) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE account_log (bin, cardholder, member);
UPDATE STATISTICS MEDIUM FOR TABLE authorizer_rules  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE authorizer_rules (auth_name) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE authorizer_rules (auth_name, pri_tran_code, sec_tran_code);
UPDATE STATISTICS MEDIUM FOR TABLE atm_status  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE atm_status (device_id);
UPDATE STATISTICS HIGH FOR TABLE atm_status (timestamp);
UPDATE STATISTICS HIGH FOR TABLE atm_status (seq_nbr);
UPDATE STATISTICS HIGH FOR TABLE atm_status (status);
UPDATE STATISTICS MEDIUM FOR TABLE iso8583_proccodes  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE iso8583_proccodes (node_name);
UPDATE STATISTICS HIGH FOR TABLE iso8583_proccodes ( msg_type_in ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE iso8583_proccodes (node_name, msg_type_in, proc_code);
UPDATE STATISTICS MEDIUM FOR TABLE processes ;
UPDATE STATISTICS MEDIUM FOR TABLE terminal_rules  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE terminal_rules (tp_name) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE terminal_rules (tp_name, pri_tran_code, sec_tran_code);
UPDATE STATISTICS MEDIUM FOR TABLE error_log  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE error_log (date_time);
UPDATE STATISTICS MEDIUM FOR TABLE system_settings ;
UPDATE STATISTICS MEDIUM FOR TABLE reentry_code_desc  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE reentry_code_desc (reentry_code);
UPDATE STATISTICS MEDIUM FOR TABLE iso8583_void_in  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE iso8583_void_in (node_name) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE iso8583_void_in (node_name, node_code_in);
UPDATE STATISTICS MEDIUM FOR TABLE iso8583_void_out  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE iso8583_void_out (node_name) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE iso8583_void_out (node_name, void_code);
UPDATE STATISTICS MEDIUM FOR TABLE terminal_processor  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE terminal_processor (tp_name);
UPDATE STATISTICS HIGH FOR TABLE terminal_processor (device_type);
UPDATE STATISTICS MEDIUM FOR TABLE account  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE account (bin) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE account (bin, cardholder, member);
UPDATE STATISTICS HIGH FOR TABLE account ( account_nbr ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE account (bin, cardholder, member, account_nbr);
UPDATE STATISTICS LOW FOR TABLE account (account_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE standby_auth  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE standby_auth (institution) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE standby_auth (institution, account_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE E91125-01 DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE log_record (pri_tran_code);
UPDATE STATISTICS HIGH FOR TABLE log_record (tran_datetime);
UPDATE STATISTICS HIGH FOR TABLE log_record (sys_seq_nbr, tran_datetime);
UPDATE STATISTICS HIGH FOR TABLE log_record (rtrvl_ref_nbr);
UPDATE STATISTICS HIGH FOR TABLE log_record (tp_name);
UPDATE STATISTICS HIGH FOR TABLE log_record (tp_datetime) DISTRIBUTIONS ONLY;
UPDATE STATISTICS MEDIUM FOR TABLE log_record (tp_datetime, tp_seq, tp_name);
UPDATE STATISTICS HIGH FOR TABLE log_record (tp_seq);
UPDATE STATISTICS HIGH FOR TABLE log_record ( terminal_id ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS MEDIUM FOR TABLE log_record (tp_seq, terminal_id, cardholder, tp_name, sec_tran_code, chp_setl_date);
UPDATE STATISTICS HIGH FOR TABLE log_record (device_id);
UPDATE STATISTICS MEDIUM FOR TABLE log_record (device_id, pri_tran_code, tran_datetime);
UPDATE STATISTICS MEDIUM FOR TABLE log_record (terminal_id, rtrvl_ref_nbr);
UPDATE STATISTICS HIGH FOR TABLE log_record ( iso_auth_id ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS MEDIUM FOR TABLE log_record (terminal_id, iso_auth_id, pri_tran_code, sec_tran_code);
UPDATE STATISTICS HIGH FOR TABLE log_record (swx_setl_date);
UPDATE STATISTICS MEDIUM FOR TABLE log_record (swx_setl_date, tp_name, type_code, pri_tran_code);
UPDATE STATISTICS HIGH FOR TABLE log_record ( chp_name ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS MEDIUM FOR TABLE log_record (swx_setl_date, chp_name, type_code, pri_tran_code);
UPDATE STATISTICS HIGH FOR TABLE log_record (chp_setl_date);
UPDATE STATISTICS HIGH FOR TABLE log_record (chp_inst_nbr);
UPDATE STATISTICS HIGH FOR TABLE log_record (bill_number);
UPDATE STATISTICS HIGH FOR TABLE log_record (bin, cardholder);
UPDATE STATISTICS HIGH FOR TABLE log_record (acct_2_nbr);
UPDATE STATISTICS HIGH FOR TABLE log_record (pos_auth_cycle,pos_batch_nbr);
UPDATE STATISTICS HIGH FOR TABLE log_record (pos_batch_nbr, bin, cardholder);
UPDATE STATISTICS MEDIUM FOR TABLE log_record (bin,cardholder,tp_seq);
UPDATE STATISTICS MEDIUM FOR TABLE log_record (pan,iso_acq_inst,iso_auth_id);
UPDATE STATISTICS MEDIUM FOR TABLE table_edit_list ;
UPDATE STATISTICS MEDIUM FOR TABLE atm  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE atm (device_id);
UPDATE STATISTICS MEDIUM FOR TABLE mgs_hour  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE mgs_hour (hour) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE mgs_hour (hour, device_id, pri_tran_code);
UPDATE STATISTICS MEDIUM FOR TABLE mgs_day  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE mgs_day (day) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE mgs_day (day, device_id, pri_tran_code);
UPDATE STATISTICS MEDIUM FOR TABLE mgs_month  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE mgs_month (month) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE mgs_month (month, device_id, pri_tran_code);
UPDATE STATISTICS MEDIUM FOR TABLE cardholder  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cardholder (bin) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE cardholder (bin, cardholder, member);
UPDATE STATISTICS HIGH FOR TABLE cardholder (card_status);
UPDATE STATISTICS MEDIUM FOR TABLE cardholder_log  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cardholder_log (ch_datetime);
UPDATE STATISTICS HIGH FOR TABLE cardholder_log (ch_user_id);
UPDATE STATISTICS HIGH FOR TABLE cardholder_log (bin) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE cardholder_log (bin, cardholder, member);
UPDATE STATISTICS MEDIUM FOR TABLE cardholder_name  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cardholder_name (bin) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE cardholder_name (bin, cardholder, member);
UPDATE STATISTICS HIGH FOR TABLE cardholder_name (last_name);
UPDATE STATISTICS MEDIUM FOR TABLE cardholder_name_lg  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cardholder_name_lg (ch_datetime);
UPDATE STATISTICS HIGH FOR TABLE cardholder_name_lg (ch_user_id);
UPDATE STATISTICS HIGH FOR TABLE cardholder_name_lg (bin) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE cardholder_name_lg (bin, cardholder, member);
UPDATE STATISTICS MEDIUM FOR TABLE card_issue  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE card_issue (institution);
UPDATE STATISTICS HIGH FOR TABLE card_issue (bin);
UPDATE STATISTICS MEDIUM FOR TABLE authorizer  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE authorizer (auth_name);
UPDATE STATISTICS HIGH FOR TABLE authorizer (switch_flag);
UPDATE STATISTICS MEDIUM FOR TABLE iso8583_acqrule  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE iso8583_acqrule (node_name) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE iso8583_acqrule (node_name, message_number, proc_code, bit_nbr, contents, line_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE iso8583_aurule  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE iso8583_aurule (node_name) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE iso8583_aurule (node_name, type_code, log_reentry_code, line_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE iso8583_bitinfo  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE iso8583_bitinfo (node_name) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE iso8583_bitinfo (node_name, bit_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE iso8583_config  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE iso8583_config (node_name);
UPDATE STATISTICS MEDIUM FOR TABLE m_status  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE m_status (m_status);
UPDATE STATISTICS MEDIUM FOR TABLE triton_stat_mon  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE triton_stat_mon (device_id);
UPDATE STATISTICS MEDIUM FOR TABLE inst_access  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE inst_access (user_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE inst_access (user_id, institution);
UPDATE STATISTICS MEDIUM FOR TABLE intl_bin  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE intl_bin (bin);
UPDATE STATISTICS MEDIUM FOR TABLE bin_nofees  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE bin_nofees (bin);
UPDATE STATISTICS MEDIUM FOR TABLE institution  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE institution (institution);
UPDATE STATISTICS MEDIUM FOR TABLE pos_batch_totals  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE pos_batch_totals (device_id);
UPDATE STATISTICS MEDIUM FOR TABLE ej_log  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE ej_log (device_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE ej_log (device_id, recv_datetime, recv_msec);
UPDATE STATISTICS MEDIUM FOR TABLE coupon_cnt  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE coupon_cnt (rule_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE coupon_cnt (rule_id, device_id, authorizer, pan);
UPDATE STATISTICS HIGH FOR TABLE coupon_cnt ( pan ) DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE coupon_cnt ( device_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE coupon_cnt (rule_id, pan);
UPDATE STATISTICS MEDIUM FOR TABLE fx_currency  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE fx_currency (iso_currency_code);
UPDATE STATISTICS MEDIUM FOR TABLE inst_bin_range  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE inst_bin_range (bin_low);
UPDATE STATISTICS HIGH FOR TABLE inst_bin_range (bin_high);
UPDATE STATISTICS MEDIUM FOR TABLE pos_recon ;
UPDATE STATISTICS MEDIUM FOR TABLE card_classes ;
UPDATE STATISTICS MEDIUM FOR TABLE cmd_desc  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE cmd_desc (command);
UPDATE STATISTICS MEDIUM FOR TABLE log_record_fields  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE log_record_fields (field_name);
UPDATE STATISTICS MEDIUM FOR TABLE coupon_def  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE coupon_def (rule_id);
UPDATE STATISTICS MEDIUM FOR TABLE ema_voids ;
UPDATE STATISTICS MEDIUM FOR TABLE system_params  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE system_params (sys_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE system_params (sys_id, param_name);
UPDATE STATISTICS MEDIUM FOR TABLE device  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE device (institution);
UPDATE STATISTICS HIGH FOR TABLE device (device_id);
UPDATE STATISTICS HIGH FOR TABLE device (terminal_id);
UPDATE STATISTICS HIGH FOR TABLE device (tp_name);
UPDATE STATISTICS HIGH FOR TABLE device (device_type) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE device (device_type, device_id);
UPDATE STATISTICS MEDIUM FOR TABLE echo_msg  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE echo_msg (device_id);
UPDATE STATISTICS MEDIUM FOR TABLE void_translator ;
UPDATE STATISTICS MEDIUM FOR TABLE sn_users  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_users (sn_user);
UPDATE STATISTICS HIGH FOR TABLE sn_users (unassign);
UPDATE STATISTICS MEDIUM FOR TABLE sn_excp_dates  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_excp_dates (sn_user) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE sn_excp_dates (sn_user, sn_stage, exception_date);
UPDATE STATISTICS MEDIUM FOR TABLE sn_st_grp_desc  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_st_grp_desc (status_grp_id);
UPDATE STATISTICS MEDIUM FOR TABLE sn_status_grps  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_status_grps (status_grp_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE sn_status_grps (status_grp_id, status_code);
UPDATE STATISTICS MEDIUM FOR TABLE sn_user_st_grp  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_user_st_grp (sn_user) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE sn_user_st_grp (sn_user, status_grp_id);
UPDATE STATISTICS MEDIUM FOR TABLE sn_user_devices  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_user_devices (sn_user) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE sn_user_devices (sn_user, device_id);
UPDATE STATISTICS MEDIUM FOR TABLE sn_restores  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_restores (sn_status);
UPDATE STATISTICS HIGH FOR TABLE sn_restores (sn_restore);
UPDATE STATISTICS MEDIUM FOR TABLE sn_settings  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_settings (param_name);
UPDATE STATISTICS MEDIUM FOR TABLE sn_weekday_duties  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_weekday_duties (sn_user) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE sn_weekday_duties (sn_user, sn_stage, weekday);
UPDATE STATISTICS MEDIUM FOR TABLE sn_stages  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_stages (sn_stage);
UPDATE STATISTICS MEDIUM FOR TABLE atm_exemptfee  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE atm_exemptfee (device_id);
UPDATE STATISTICS MEDIUM FOR TABLE sn_status_log  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_status_log (seq_nbr) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE sn_status_log (seq_nbr, sn_user, timestamp);
UPDATE STATISTICS HIGH FOR TABLE sn_status_log (device_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE sn_status_log (device_id, status_code, sn_active);
UPDATE STATISTICS HIGH FOR TABLE sn_status_log (status_code);
UPDATE STATISTICS HIGH FOR TABLE sn_status_log (sn_user);
UPDATE STATISTICS MEDIUM FOR TABLE sn_access  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE sn_access (user_id);
UPDATE STATISTICS MEDIUM FOR TABLE device_fee  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE device_fee (device) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE device_fee (device, pri_tran_code);
UPDATE STATISTICS MEDIUM FOR TABLE user_maint_log  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE user_maint_log (ch_user_id) DISTRIBUTIONS ONLY;
UPDATE STATISTICS LOW FOR TABLE user_maint_log (ch_user_id, ch_datetime);
UPDATE STATISTICS MEDIUM FOR TABLE aix  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE aix (aixuser);
UPDATE STATISTICS MEDIUM FOR TABLE log_record_hist  DISTRIBUTIONS ONLY;
UPDATE STATISTICS HIGH FOR TABLE log_record_hist (tran_datetime);
UPDATE STATISTICS HIGH FOR TABLE log_record_hist (device_id);
UPDATE STATISTICS MEDIUM FOR TABLE log_record_hist (swx_setl_date);
UPDATE STATISTICS MEDIUM FOR TABLE log_record_hist (bin, cardholder);
UPDATE STATISTICS MEDIUM FOR TABLE log_record_hist (chp_inst_nbr);
UPDATE STATISTICS MEDIUM FOR TABLE log_record_hist (chp_setl_date);
UPDATE STATISTICS MEDIUM FOR TABLE log_record_hist (pri_tran_code);
UPDATE STATISTICS LOW FOR TABLE log_record_hist (swx_setl_date, tp_name, type_code, pri_tran_code);
UPDATE STATISTICS MEDIUM FOR TABLE log_record_hist (tp_name);
UPDATE STATISTICS MEDIUM FOR TABLE log_record_hist (tp_name);
UPDATE STATISTICS HIGH FOR TABLE iso_msg (sys_seq_nbr, tran_datetime);
UPDATE STATISTICS HIGH FOR TABLE tgs_svc_chg_hist ( gl_modifier, bin, cardholder )
UPDATE STATISTICS HIGH FOR TABLE tgs_svc_chg_hist ( bin, cardholder, gl_modifier )
UPDATE STATISTICS MEDIUM FOR TABLE tgs_gl_desc ( pri_tran_code, sec_tran_code, gl_modifier )
UPDATE STATISTICS MEDIUM FOR TABLE tgs_gl_desc ( gl_tran_code, gl_modifier )
DONE

cat /tmp/tables.sql |
while read -r USED
  do

    echo $USED > /tmp/update_stat.sql

    dbaccess -e trangateway /tmp/update_stat.sql  >> $LOG 2>&1
    date >> $LOG

  done
echo "Finished updates on all tables     " >> $LOG
echo "==================================" >> $LOG
date >> $LOG

echo "======= PROCEDURES statistics ====" >> $LOG
cat >/tmp/stat9.sql<<DONE
UPDATE STATISTICS FOR PROCEDURE;
DONE
dbaccess -e trangateway /tmp/stat9.sql  >> $LOG 2>> $LOG
echo "Finished PROCEDURES               " >> $LOG
date >> $LOG
echo "==================================" >> $LOG
echo "======Finished All Updates========" >> $LOG
echo "See ${LOG} for information about process to database..."


mail -s "$MSG - LOGFILE" ${NOTIFY} < $LOG
