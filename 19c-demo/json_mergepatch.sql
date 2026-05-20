set termout on
set echo off
set linesize 130

column txn_desc format a30
column amount format 999g999
column balance format 999g999

clear screen

prompt |      _ ____   ___  _   _   __  __                       ____       _       _     
prompt |     | / ___| / _ \| \ | | |  \/  | ___ _ __ __ _  ___  |  _ \ __ _| |_ ___| |__  
prompt |  _  | \___ \| | | |  \| | | |\/| |/ _ \ '__/ _` |/ _ \ | |_) / _` | __/ __| '_ \ 
prompt | | |_| |___) | |_| | |\  | | |  | |  __/ | | (_| |  __/ |  __/ (_| | || (__| | | |
prompt |  \___/|____/ \___/|_| \_| |_|  |_|\___|_|  \__, |\___| |_|   \__,_|\__\___|_| |_|
prompt |                                            |___/                                 

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
column desc_removed format a50
column annotated format a50
column account_replaced format a50
column do_all_ops_one_after_the_other format a50

clear screen

select
  json_serialize(t.data pretty) as json_original,
  json_serialize
  (
    json_mergepatch
    (
      t.data,
      '{"annotations" : ["item 1", "item 2", "item 3"]}'
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
    json_mergepatch
    (
      t.data,
      '{"account" : "21920202"}'
    )
    pretty
  ) as account_replaced
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
    json_mergepatch
    (
      t.data,
      '{"description" : null}'
    )
    pretty
  ) as desc_removed
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
    json_mergepatch
    (
      t.data,
      '{"annotations" : ["item 1", "item 2", "item 3"], "account" : "21920202", "description" : null}'
    )
    pretty
  ) as do_all_ops_one_after_the_other
from txn_json t
where t.id = 1
.
pause
/

pause