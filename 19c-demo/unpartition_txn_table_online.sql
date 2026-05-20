set echo off
set termout on
clear screen

prompt |   ___        _ _               _   _             ____            _   _ _   _                _____     _     _      
prompt |  / _ \ _ __ | (_)_ __   ___   | | | |_ __       |  _ \ __ _ _ __| |_(_) |_(_) ___  _ __    |_   _|_ _| |__ | | ___ 
prompt | | | | | '_ \| | | '_ \ / _ \  | | | | '_ \ _____| |_) / _` | '__| __| | __| |/ _ \| '_ \     | |/ _` | '_ \| |/ _ \
prompt | | |_| | | | | | | | | |  __/  | |_| | | | |_____|  __/ (_| | |  | |_| | |_| | (_) | | | |    | | (_| | |_) | |  __/
prompt |  \___/|_| |_|_|_|_| |_|\___|   \___/|_| |_|     |_|   \__,_|_|   \__|_|\__|_|\___/|_| |_|    |_|\__,_|_.__/|_|\___|
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

alter table txn modify NONPARTITIONED online 
update indexes
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
