set linesize 130

alter session set nls_date_format = "yyyy-mm-dd hh24:mi";

column account_number format a15
column txn_desc format a30
column amount format 999g999
column balance format 999g999
column PADDING format noprint

set echo off
set termout on

clear screen

prompt |      _ ____   ___  _   _    _          ____   ___  _     
prompt |     | / ___| / _ \| \ | |  (_)_ __    / ___| / _ \| |    
prompt |  _  | \___ \| | | |  \| |  | | `_ \   \___ \| | | | |    
prompt | | |_| |___) | |_| | |\  |  | | | | |   ___) | |_| | |___ 
prompt |  \___/|____/ \___/|_| \_|  |_|_| |_|  |____/ \__\_\_____|
prompt |                                                          

pause

set long 1000000
set echo on
set termout on

clear screen

select
  t.txn_date,
  t.account_number,
  t.txn_desc,
  t.amount,
  t.balance
from txn t
where rownum <= 2
.
pause
/

pause

clear screen

select json_object(t.*) as txn_Doc
from txn t
where rownum <= 2
.
pause
/

pause

clear screen

select json_serialize(json_object(t.*) pretty) as txn_Doc
from txn t
where rownum <= 2
.
pause
/

pause

clear screen

select json_serialize
(
  json_object
  (
    'txn_date' : t.txn_date,
    'account' : t.account_number,
    'description' : t.txn_desc,
    'amount' : t.amount,
    'balance' : t.balance
  )
  pretty
) as txn_Doc
from txn t
where rownum <= 2
.
pause
/

pause

clear screen

with first_two_txns as
(
  select
    json_object
    (
      'txn_date' : t.txn_date,
      'account' : t.account_number,
      'description' : t.txn_desc,
      'amount' : t.amount,
      'balance' : t.balance
    ) as txn_json
  from txn t
  where rownum <= 2
),
aggregated_txns as
(
  select json_object('transactions' : json_arrayagg(txn_json)) as txn_doc
  from first_two_txns
)
select json_serialize(txn_doc pretty) as txn_doc
from aggregated_txns
.
pause
/

pause

clear screen

with first_two_txns as
(
  select
    json_object
    (
      'txn_date' : t.txn_date,
      'account' : t.account_number,
      'description' : t.txn_desc,
      'amount' : t.amount,
      'balance' : t.balance
    ) as txn_json
  from txn t
  where rownum <= 2
),
aggregated_txns as
(
  select json_object('transactions' : json_arrayagg(txn_json)) as txn_doc
  from first_two_txns
)
select t.*
from
  aggregated_txns a,
  json_table
  (
    a.txn_doc,
    '$.transactions[*]'
    columns
      txn_date date path '$.txn_date',
      account_number varchar(10) path '$.account',
      txn_desc varchar(30) path '$.description',
      amount number path '$.amount',
      balance number path '$.balance'
  ) t
.
pause
/

pause

clear screen

set echo off
set termout off

@@drop_table txn_json

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

insert into txn_json values (1, 'this is definitely not a JSON document')
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

clear screen

select
  id,
  data as txn_info
from txn_json
where rownum <= 2
.
pause
/

pause

clear screen

select
  id,
  json_serialize(data pretty) as txn_info
from txn_json
where rownum <= 2
.
pause
/

pause

column txn_date format a20
column account format a10
column description format a30
column amount format a10
column balance format a15

clear screen

select 
  t.data.txn_date,
  t.data.account,
  t.data.description,
  t.data.amount,
  t.data.balance
from txn_json t
.
pause
/

pause

column txn_date format a20
column account format a10
column description format a30
column amount format 999g999
column balance format 999g999

clear screen

select 
  json_value(t.data, '$.txn_date' returning date) as txn_date,
  t.data.account,
  t.data.description,
  json_value(t.data, '$.amount' returning number) as amount,
  json_value(t.data, '$.balance' returning number) as balance
from txn_json t
.
pause
/

pause
