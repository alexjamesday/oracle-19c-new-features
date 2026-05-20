set autotrace off
set echo off
set termout on
clear screen


prompt |  __  __                       ___        _   _           _              _   ____                _     
prompt | |  \/  | ___ _ __ ___        / _ \ _ __ | |_(_)_ __ ___ (_)___  ___  __| | |  _ \ ___  __ _  __| |___ 
prompt | | |\/| |/ _ \ '_ ` _ \ _____| | | | '_ \| __| | `_ ` _ \| / __|/ _ \/ _` | | |_) / _ \/ _` |/ _` / __|
prompt | | |  | |  __/ | | | | |_____| |_| | |_) | |_| | | | | | | \__ \  __/ (_| | |  _ <  __/ (_| | (_| \__ \
prompt | |_|  |_|\___|_| |_| |_|      \___/| .__/ \__|_|_| |_| |_|_|___/\___|\__,_| |_| \_\___|\__,_|\__,_|___/
prompt |                                   |_|                                                                 


pause 

clear screen

set echo off
set termout off

@@drop_table x_airport_code
@@drop_table airport

set echo on
set termout on

create or replace directory staging_dir as '/home/oracle/staging';

create table x_airport_code
(
  city          varchar(100),
  city_code     varchar(100),
  airport_code  varchar(100)
)
organization external
(
  type oracle_loader
  default directory staging_dir
  access parameters
  (
    records delimited by newline
    fields terminated by ',' optionally enclosed by '"' lrtrim
  )
  location ('airport_codes.csv')
)
.
pause 
/

select count(1) as tally
from x_airport_code
.
pause
/

pause

create table airport
(
  code        varchar(3) not null,
  city_code   varchar(3) not null,
  city_name   varchar(40) not null,
  constraint airport_pk primary key (code)
)
.
pause
/

insert into airport
select
  airport_code,
  city_code,
  city
from x_airport_code
.
pause
/

commit;

pause

@index_stats AIRPORT_PK

pause

set echo on

column city_name format a40

set autotrace on

select *
from airport a
where a.code = 'DXB'
.
pause
/

/

pause

alter table airport memoptimize for read
.
/

pause

exec dbms_memoptimize.populate(schema_name => user, table_name => 'AIRPORT')

pause

select *
from airport a
where a.code = 'DXB'
.
pause
/

/

pause 

alter table airport no memoptimize for read;
