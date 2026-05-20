set echo off
set termout on
clear screen

prompt |   ___        _ _               ____            _   _ _   _                 ____                              _             
prompt |  / _ \ _ __ | (_)_ __   ___   |  _ \ __ _ _ __| |_(_) |_(_) ___  _ __     / ___|___  _ ____   _____ _ __ ___(_) ___  _ __  
prompt | | | | | '_ \| | | '_ \ / _ \  | |_) / _` | '__| __| | __| |/ _ \| '_ \   | |   / _ \| '_ \ \ / / _ \ '__/ __| |/ _ \| `_ \ 
prompt | | |_| | | | | | | | | |  __/  |  __/ (_| | |  | |_| | |_| | (_) | | | |  | |__| (_) | | | \ V /  __/ |  \__ \ | (_) | | | |
prompt |  \___/|_| |_|_|_|_| |_|\___|  |_|   \__,_|_|   \__|_|\__|_|\___/|_| |_|   \____\___/|_| |_|\_/ \___|_|  |___/_|\___/|_| |_|
prompt |                                                                                                                            

pause

set echo on
clear screen

explain plan for
select *
from txn t
where txn_date >= :a
and account_number = :b
order by txn_date
.
pause
/

@xplan

pause

alter table txn modify partition by range (txn_date)
(
  partition y2025_m01 values less than (date '2025-02-01'),
  partition y2025_m02 values less than (date '2025-03-01'),
  partition y2025_m03 values less than (date '2025-04-01'),
  partition y2025_m04 values less than (date '2025-05-01'),
  partition y2025_m05 values less than (date '2025-06-01'),
  partition y2025_m06 values less than (date '2025-07-01'),
  partition y9999_m12 values less than (maxvalue)
)
update indexes
(
  txn_ix01 local
)
online
.
pause
/

pause

explain plan for
select *
from txn t
where txn_date >= :a
and account_number = :b
order by txn_date
.
pause
/

@xplan

pause
