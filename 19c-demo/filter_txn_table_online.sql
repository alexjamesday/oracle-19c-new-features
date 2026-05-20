set echo off
set termout on
clear screen

prompt |  __  __                                   _    _____ _ _ _              _____     _     _          ___        _ _            
prompt | |  \/  | _____   _____     __ _ _ __   __| |  |  ___(_) | |_ ___ _ __  |_   _|_ _| |__ | | ___    / _ \ _ __ | (_)_ __   ___ 
prompt | | |\/| |/ _ \ \ / / _ \   / _` | `_ \ / _` |  | |_  | | | __/ _ \ `__|   | |/ _` | `_ \| |/ _ \  | | | | `_ \| | | `_ \ / _ \
prompt | | |  | | (_) \ V /  __/  | (_| | | | | (_| |  |  _| | | | ||  __/ |      | | (_| | |_) | |  __/  | |_| | | | | | | | | |  __/
prompt | |_|  |_|\___/ \_/ \___|   \__,_|_| |_|\__,_|  |_|   |_|_|\__\___|_|      |_|\__,_|_.__/|_|\___|   \___/|_| |_|_|_|_| |_|\___|
prompt |                                                                                                                              

pause 

set echo on
clear screen

select
  to_char(txn_date, 'yyyy-mm') as month,
  count(1) as tally
from txn
group by
  to_char(txn_date, 'yyyy-mm')
order by 1;

pause

clear screen

alter table txn move including rows where txn_date >= add_months(sysdate, -6) online
.
pause
/

pause

select
  to_char(txn_date, 'yyyy-mm') as month,
  count(1) as tally
from txn
group by
  to_char(txn_date, 'yyyy-mm')
order by 1;

pause