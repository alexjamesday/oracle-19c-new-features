clear screen
set echo off
set termout off

@@drop_table txn

set echo on
set termout on

create or replace function get_txn_type return number
is
begin
  return round(dbms_random.value(1, 20));
end;
/

create or replace function get_account_number return varchar2
is
begin
  return to_char(dbms_random.value(1, 10000) + 100000, 'fm000000');
end;
/

create or replace function get_purchase_type(p_txn_type_id in number) return varchar2
deterministic
result_cache
is
begin
  return 'Purchase at ' ||
      case
        when p_txn_type_id <= 2 then 'Book Store'
        when p_txn_type_id <= 4 then 'Movie Theatre'
        when p_txn_type_id <= 8 then 'Online Shopping'
        when p_txn_type_id <= 10 then 'Record Store'
        when p_txn_type_id <= 11 then 'Restaurant'
        when p_txn_type_id <= 19 then 'Supermarket'
        when p_txn_type_id <= 20 then 'Taxi Cab'
      end;
end;
/  


create or replace function get_deposit_type(p_txn_type_id in number) return varchar2
deterministic
result_cache
is
begin
  return 'Deposit from ' ||
      case
        when p_txn_type_id <= 17 then 'Job Salary'
        when p_txn_type_id <= 20 then 'Windfall'
      end;
end;
/  

create table txn
as
select
  v.txn_date,
  v.account_number,
  case sign(v.amount)
    when -1 then cast(get_purchase_type(txn_type) as varchar(30))
    when 1 then cast(get_deposit_type(txn_type) as varchar(30))
  end as txn_desc,
  v.amount,
  50000 - sum(v.amount) over (partition by v.account_number order by v.txn_date) as balance,
  lpad('X', 100, 'X') as padding
from
(
  select
    rownum as id,
    sysdate - dbms_random.value(1, 365) as txn_date,
    cast(get_account_number as varchar2(10)) as account_number,
    round(sign(dbms_random.value(-10, 5)) * dbms_random.value(5, 1000)) as amount,
    get_txn_type as txn_type
  from dual
  connect by level <= 2000000
) v
where v.amount != 0;

create index txn_ix01 on txn (account_number, txn_date);

alter table txn modify
(
  txn_date          not null,
  account_number    not null,
  txn_desc          not null,
  amount            not null,
  balance           not null
);

pause
