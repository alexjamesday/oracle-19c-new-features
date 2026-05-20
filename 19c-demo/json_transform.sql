set termout on
set echo off
set linesize 130

column txn_desc format a30
column amount format 999g999
column balance format 999g999

clear screen

prompt |      _ ____   ___  _   _   _____                     __                      
prompt |     | / ___| / _ \| \ | | |_   _| __ __ _ _ __  ___ / _| ___  _ __ _ __ ___  
prompt |  _  | \___ \| | | |  \| |   | || '__/ _` | '_ \/ __| |_ / _ \| '__| '_ ` _ \ 
prompt | | |_| |___) | |_| | |\  |   | || | | (_| | | | \__ \  _| (_) | |  | | | | | |
prompt |  \___/|____/ \___/|_| \_|   |_||_|  \__,_|_| |_|___/_|  \___/|_|  |_| |_| |_|
prompt |                                                                              

pause

set echo off
set termout off

@@drop_table txn_json

set long 1000000
set echo on
set termout on

clear screen

create table txn_json
(
  id    number not null,
  data  blob not null,
  constraint txn_json_pk primary key (id),
  constraint txn_json_ck check (data is json format oson)
)
.
pause
/

pause

insert into txn_json
select
  rownum,
  json_object
  (
    'txn_date' : t.txn_date,
    'account' : t.account_number,
    'description' : t.txn_desc,
    'amount' : t.amount,
    'balance' : t.balance
  )
from txn t
where rownum <= 10;

commit;

pause

column id format 90
column txn_info format a100
column json_original format a50
column approval_inserted format a50
column desc_replaced format a50
column annotated format a50
column amount_set format a50
column account_renamed format a50
column remove_all_but_account_and_balance format a50
column do_all_ops_one_after_the_other format a50

clear screen

select
  json_serialize(t.data pretty) as json_original,
  json_serialize
  (
    json_transform
    (
      t.data,
      insert '$.approved' = 'true' format json
    )
    pretty
  ) as approval_inserted
from txn_json t
where t.id = 1
.
pause
/

pause

clear screen

select
  json_serialize(t.data pretty) as json_original,
  json_serialize
  (
    json_transform
    (
      t.data,
      replace '$.description' = 'Money stolen in bank raid'
    )
    pretty
  ) as desc_replaced
from txn_json t
where t.id = 1
.
pause
/

pause

clear screen

select
  json_serialize(t.data pretty) as json_original,
  json_serialize
  (
    json_transform
    (
      t.data,
      append '$.annotations' = 'Income' create on missing
    )
    pretty
  ) as annotated
from txn_json t
where t.id = 1
.
pause
/

pause

clear screen

select
  json_serialize(t.data pretty) as json_original,
  json_serialize
  (
    json_transform
    (
      t.data,
      set '$.amount' = 666
    )
    pretty
  ) as amount_set
from txn_json t
where t.id = 1
.
pause
/

pause

clear screen

select
  json_serialize(t.data pretty) as json_original,
  json_serialize
  (
    json_transform
    (
      t.data,
      rename '$.account' = 'account_number'
    )
    pretty
  ) as account_renamed
from txn_json t
where t.id = 1
.
pause
/

pause

clear screen

select
  json_serialize(t.data pretty) as json_original,
  json_serialize
  (
    json_transform
    (
      t.data,
      keep '$.account', '$.balance'
    )
    pretty
  ) as remove_all_but_account_and_balance
from txn_json t
where t.id = 1
.
pause
/

pause

clear screen

select
  json_serialize(t.data pretty) as json_original,
  json_serialize
  (
    json_transform
    (
      t.data,
      remove '$.balance',
      insert '$.approved' = 'true' format json,
      replace '$.description' = 'Money stolen in bank raid',
      append '$.annotations' = 'Income' create on missing,
      set '$.amount' = 666,
      rename '$.account' = 'account_number',
      keep '$.account_number', '$.amount', '$.annotations'
    )
    pretty
  ) as do_all_ops_one_after_the_other
from txn_json t
where t.id = 1
.
pause

/

pause