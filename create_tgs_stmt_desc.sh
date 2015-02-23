#  create_tgs_stmt_desc.sh

cd /home/prod/scripts

LOGFILE="../logs/create_tgs_stmt_desc.log"

cat >../data/load_tgs_stmt_desc.sql<<DONE
--drop table "swx".tgs_stmt_desc;
create table "swx".tgs_stmt_desc 
  ( pri_tran_code char(4) ,
    sec_tran_code char(4),
    description char(20)
  ) extent size 16 next size 16 lock mode row;

revoke all on "swx".tgs_stmt_desc from "public" as "swx";
grant select on "swx".tgs_stmt_desc to "public" as "swx";
grant select on "swx".tgs_stmt_desc to "barry" as "swx";
grant update on "swx".tgs_stmt_desc to "barry" as "swx";
grant insert on "swx".tgs_stmt_desc to "barry" as "swx";
grant delete on "swx".tgs_stmt_desc to "barry" as "swx";
grant select on "swx".tgs_stmt_desc to "bj" as "swx";
grant update on "swx".tgs_stmt_desc to "bj" as "swx";
grant insert on "swx".tgs_stmt_desc to "bj" as "swx";
grant delete on "swx".tgs_stmt_desc to "bj" as "swx";
grant select on "swx".tgs_stmt_desc to "paull" as "swx";
grant update on "swx".tgs_stmt_desc to "paull" as "swx";
grant insert on "swx".tgs_stmt_desc to "paull" as "swx";
grant delete on "swx".tgs_stmt_desc to "paull" as "swx";
DONE
dbaccess -e $DBNAME ../data/load_tgs_stmt_desc.sql > ${LOGFILE} 2>&1

cat >../data/tgs_stmt_desc.unl<<DONE
BILL|PAY|Bill Payment|
CARD|REVT|Wire Reversal|
CARD|TFR|Wire|
CASH|REVT|Cash Dep Rev|
CASH|TFR|Cash Deposit|
CHK|REVT|Check Deposit Rev|
CHK|TFR|Check Deposit|
CRED|TFR|Bill Pay Rev|
DEP|FUND|Dep from Other Card|
DEP|NORM|ATM Deposit|
DEP|REFD|Merch Return|
DEP|REV|ATM Dep Rev|
DEP|REVT|Vendor Pymt Rev|
DEP|TFR|Pymt from Vendor|
INQ|BAL|Account Inquiry|
INQ|NORM|Account Inquiry|
INQ|POS|Account Inquiry|
JRNL|CRED|Account Credit|
JRNL|DBT|Account Debit|
LOAN|REVT|Undefined|
LOAN|TFR|Undefined|
LOST|REVT|Lost Card Tfr Rev|
LOST|TFR|Lost Card Tfr|
MON|ORD|Money Order|
MOVE|REVT|Undefined|
MOVE|TFR|Undefined|
PRE|AUTH|POS Auth|
PRE|REV|POS Auth Rev|
PURC|TFR|Pot Purchase
PUT|REVT|Funding Rev|
PUT|TFR|Funding|
SVC|CRED|Account Credit|
SVC|DBT|Account Debit|
TRN|NORM|Transfer|
TRN|REV|Transfer Rev|
WDL|ALL|Wdl of Balance|
WDL|FAST|ATM Wdl|
WDL|NORM|ATM Wdl|
WDL|PART|ATM Wdl|
WDL|PURC|POS Purchase|
WDL|PURH|POS Debit|
WDL|REV|ATM Wdl Rev|
WDL|REVT|HMF ATM Wdl Rev|
WDL|TFR|HMF ATM Wdl|
DONE

cat >../data/tgs_stmt_desc.sql<<DONE
load from ../data/tgs_stmt_desc.unl
insert into tgs_stmt_desc
DONE
dbaccess -e $DBNAME ../data/tgs_stmt_desc.sql >> ${LOGFILE} 2>&1

cat >../data/load_table_edit_list.unl<<DONE
tgs_stmt_desc|&Other2|TGS Stmt Desc|
DONE

cat >../data/load_table_edit_list.sql<<DONE
load from ../data/load_table_edit_list.unl
insert into table_edit_list
DONE

dbaccess -e $DBNAME ../data/load_table_edit_list.sql >> ${LOGFILE} 2>&1
