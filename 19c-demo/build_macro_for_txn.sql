set echo on
set termout on

create or replace function get_txns
(
  p_account_number in varchar2,
  p_no_older_than  in date default trunc(sysdate),
  p_row_limit      in number default 10
)
return varchar2 sql_macro
is
begin
  return
'select
  txn_date,
  account_number,
  txn_desc,
  amount,
  balance
from txn
where account_number = get_txns.p_account_number
and txn_date >= get_txns.p_no_older_than
and rownum <= get_txns.p_row_limit';
end;
.
pause
/
