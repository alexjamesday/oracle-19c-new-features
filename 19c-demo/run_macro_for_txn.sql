set linesize 130

clear screen
column txn_desc format a30

set echo off
set termout on

prompt |  ____   ___  _       __  __                          
prompt | / ___| / _ \| |     |  \/  | __ _  ___ _ __ ___  ___ 
prompt | \___ \| | | | |     | |\/| |/ _` |/ __| `__/ _ \/ __|
prompt |  ___) | |_| | |___  | |  | | (_| | (__| | | (_) \__ \
prompt | |____/ \__\_\_____| |_|  |_|\__,_|\___|_|  \___/|___/
prompt |                                                      

pause

clear screen

set echo off
set termout off

@@format_txn_output.sql
@@build_macro_for_txn.sql

pause

set echo on
set termout on

var acc_no varchar2(10)

pause

exec :acc_no := get_account_number()

pause

print :acc_no

pause

select
  txn_date,
  account_number,
  txn_desc,
  amount,
  balance
from get_txns
(
  p_account_number => :acc_no,
  p_no_older_than => trunc(sysdate, 'yyyy')
)
.
pause
/

pause

clear screen

explain plan for
select
  txn_date,
  account_number,
  txn_desc,
  amount,
  balance
from get_txns
(
  p_account_number => :acc_no,
  p_no_older_than => trunc(sysdate, 'yyyy')
)
.
pause
/

@xplan

pause

