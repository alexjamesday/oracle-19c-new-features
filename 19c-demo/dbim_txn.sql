set echo off
set termout on
clear screen

prompt |  ____        _        _                       ___             __  __                                 
prompt | |  _ \  __ _| |_ __ _| |__   __ _ ___  ___   |_ _|_ __       |  \/  | ___ _ __ ___   ___  _ __ _   _ 
prompt | | | | |/ _` | __/ _` | '_ \ / _` / __|/ _ \   | || '_ \ _____| |\/| |/ _ \ '_ ` _ \ / _ \| '__| | | |
prompt | | |_| | (_| | || (_| | |_) | (_| \__ \  __/   | || | | |_____| |  | |  __/ | | | | | (_) | |  | |_| |
prompt | |____/ \__,_|\__\__,_|_.__/ \__,_|___/\___|  |___|_| |_|     |_|  |_|\___|_| |_| |_|\___/|_|   \__, |
prompt |                                                                                                |___/ 

pause 

clear screen

set termout off

@@format_txn_output.sql

variable bv_desc varchar2(50)
variable bv_amount number
variable bv_balance number

declare
  C_LIMIT constant pls_integer := 1000;
  l_lucky_winner pls_integer := 1;
begin
  l_lucky_winner := round(dbms_random.value(1, C_LIMIT));
  
  select
    txn_desc,
    amount,
    balance
  into
    :bv_desc,
    :bv_amount,
    :bv_balance
  from
  (
    select
      rownum as ranking,
      txn_desc,
      amount,
      balance
    from txn t
    where rownum <= C_LIMIT
   )
   where ranking = l_lucky_winner;
end;
/

alter system flush buffer_cache;

set echo on
set termout on
clear screen

print bv_desc
print bv_amount
print bv_balance

pause

select
  t.txn_date,
  t.account_number,
  t.txn_desc,
  t.amount,
  t.balance
from txn t
where txn_desc = :bv_desc
and amount = :bv_amount
and balance = :bv_balance
.
pause

/

pause
clear screen

explain plan for
select
  t.txn_date,
  t.account_number,
  t.txn_desc,
  t.amount,
  t.balance
from txn t
where txn_desc = :bv_desc
and amount = :bv_amount
and balance = :bv_balance
.
pause

/

@xplan

pause

set echo on
set termout on
clear screen

alter table txn inmemory no inmemory (padding);

select dbms_inmemory_admin.populate_wait('NONE') as pop_status
from dual;

pause

set echo off

select
  segment_name,
  round(inmemory_size / 1024 / 1024) as dbim_mb,
  round(bytes / 1024 / 1024) as disk_mb
from v$im_segments;

set echo on
pause

select
  t.txn_date,
  t.account_number,
  t.txn_desc,
  t.amount,
  t.balance
from txn t
where txn_desc = :bv_desc
and amount = :bv_amount
and balance = :bv_balance
.
pause

/

pause
clear screen

explain plan for
select
  t.txn_date,
  t.account_number,
  t.txn_desc,
  t.amount,
  t.balance
from txn t
where txn_desc = :bv_desc
and amount = :bv_amount
and balance = :bv_balance
.
pause

/

@xplan

pause

alter table txn no inmemory;
