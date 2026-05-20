set termout on
set echo off

clear screen

prompt |  ____  __  __ _        ____             _                __  __                
prompt | |  _ \|  \/  | |      |  _ \ _   _ _ __(_)_ __   __ _   |  \/  | _____   _____ 
prompt | | | | | |\/| | |      | | | | | | | '__| | '_ \ / _` |  | |\/| |/ _ \ \ / / _ \
prompt | | |_| | |  | | |___   | |_| | |_| | |  | | | | | (_| |  | |  | | (_) \ V /  __/
prompt | |____/|_|  |_|_____|  |____/ \__,_|_|  |_|_| |_|\__, |  |_|  |_|\___/ \_/ \___|
prompt |                                                 |___/                          

pause

set echo on
clear screen

declare
  l_next_account long;
  
  l_insertions PLS_INTEGER := 0;
begin
  for idx in 1 .. 50 loop
  
    l_next_account := get_account_number;
  
    insert into txn
    (
      txn_date,
      account_number,
      txn_desc,
      amount,
      balance
    )
    select
      v.txn_date,
      v.account_number,
      v.txn_desc,
      v.amount,
      v.balance + v.amount
    from
    (
      select
        sysdate as txn_date,
        t.account_number,
        get_purchase_type(get_txn_type) as txn_desc,
        -1 * round(dbms_random.value(5, 1000)) as amount,
        t.balance
      from txn t
      where t.account_number = l_next_account
      order by t.txn_date desc
    ) v
    where rownum = 1;
    
    l_insertions := l_insertions + sql%rowcount;
    
    -- Sleep for 1/2 second...
    dbms_session.sleep(0.5);
    
    commit;
  end loop;
  
  dbms_output.put_line('Inserted ' || l_insertions || ' records.');
end;
.
pause

/

pause

@@format_txn_output.sql

clear screen

select
  txn_date,
  account_number,
  txn_desc,
  amount,
  balance
from txn t
where t.txn_date >= sysdate - 2 / 60 / 24
order by txn_date
.
pause

/

pause
