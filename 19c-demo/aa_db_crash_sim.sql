whenever sqlerror exit sql.sqlcode

set echo off
set termout on
clear screen


prompt |  ____        _        _                        ____               _        ____  _                 _       _             
prompt | |  _ \  __ _| |_ __ _| |__   __ _ ___  ___    / ___|_ __ __ _ ___| |__    / ___|(_)_ __ ___  _   _| | __ _| |_ ___  _ __ 
prompt | | | | |/ _` | __/ _` | `_ \ / _` / __|/ _ \  | |   | `__/ _` / __| `_ \   \___ \| | `_ ` _ \| | | | |/ _` | __/ _ \| `__|
prompt | | |_| | (_| | || (_| | |_) | (_| \__ \  __/  | |___| | | (_| \__ \ | | |   ___) | | | | | | | |_| | | (_| | || (_) | |   
prompt | |____/ \__,_|\__\__,_|_.__/ \__,_|___/\___|   \____|_|  \__,_|___/_| |_|  |____/|_|_| |_| |_|\__,_|_|\__,_|\__\___/|_|   
prompt |                                                                                                                          
                                                                                                                          
pause 

clear screen
set echo on
set termout on


alter pluggable database DEMO_19C_PDB close immediate instances = ALL
.
pause
/

alter pluggable database DEMO_19C_PDB open instances = ALL services = ALL;

pause
