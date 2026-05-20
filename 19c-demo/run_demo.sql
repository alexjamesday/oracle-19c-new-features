@@default_format.sql

set echo off
set termout on
clear screen

prompt |   ___                 _         ____        _        _                       _  ___          ____                       
prompt |  / _ \ _ __ __ _  ___| | ___   |  _ \  __ _| |_ __ _| |__   __ _ ___  ___   / |/ _ \  ___   |  _ \  ___ _ __ ___   ___  
prompt | | | | | '__/ _` |/ __| |/ _ \  | | | |/ _` | __/ _` | '_ \ / _` / __|/ _ \  | | (_) |/ __|  | | | |/ _ \ `_ ` _ \ / _ \ 
prompt | | |_| | | | (_| | (__| |  __/  | |_| | (_| | || (_| | |_) | (_| \__ \  __/  | |\__, | (__   | |_| |  __/ | | | | | (_) |
prompt |  \___/|_|  \__,_|\___|_|\___|  |____/ \__,_|\__\__,_|_.__/ \__,_|___/\___|  |_|  /_/ \___|  |____/ \___|_| |_| |_|\___/ 
prompt |                                                                                                                         
prompt |
prompt |
prompt |
prompt |


prompt |  1. Move Table Online
prompt |  2. Filter Table Online
prompt |  3. Partition Table Online
prompt |  4. Un-partition Table Online
prompt |  5. SQL Macros
prompt |  6. JSON in SQL
prompt |  7. JSON Merge Patch
prompt |  8. JSON Transform
prompt |  9. Mem-Optimised Reads
prompt | 10. Mem-Optimised Writes
prompt | 11. Database In-Memory
prompt | 12. Always Available Database
prompt |
prompt |
prompt | 96. Database Crash/Restart Simulation
prompt | 97. DML During Online Operation
prompt | 98. Rebuild Demo Table (TXN)
prompt | 99. Exit

prompt |
prompt |
prompt |
prompt |
prompt |


accept svar number default 1 prompt '| Please choose option (default: 1) ?  '

clear screen
set echo off
set termout off

column script_name format a20 new_value sv_script_name

select
  case &svar.
    when 1 then 'move_txn_table_online.sql'
    when 2 then 'filter_txn_table_online.sql'
    when 3 then 'partition_txn_table_online.sql'
    when 4 then 'unpartition_txn_table_online.sql'
    when 5 then 'run_macro_for_txn.sql'
    when 6 then 'json_txns.sql'
    when 7 then 'json_mergepatch.sql'
    when 8 then 'json_transform.sql'
    when 9 then 'memop_read.sql'
    when 10 then 'memop_write.sql'
    when 11 then 'dbim_txn.sql'
    when 12 then 'always_available.sql'
    when 96 then 'aa_db_crash_sim.sql'
    when 97 then 'run_txns.sql'
    when 98 then 'build_txn_table.sql'
    when 99 then 'exit.sql'
    else 'do_nothing.sql'
  end as script_name
from dual;

@@&sv_script_name.

@@run_demo.sql