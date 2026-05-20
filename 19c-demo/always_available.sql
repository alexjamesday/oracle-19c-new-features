whenever sqlerror exit sql.sqlcode

set echo off
set termout on
clear screen


prompt |     _    _                               _             _ _       _     _         ____        _        _                    
prompt |    / \  | |_      ____ _ _   _ ___      / \__   ____ _(_) | __ _| |__ | | ___   |  _ \  __ _| |_ __ _| |__   __ _ ___  ___ 
prompt |   / _ \ | \ \ /\ / / _` | | | / __|    / _ \ \ / / _` | | |/ _` | '_ \| |/ _ \  | | | |/ _` | __/ _` | '_ \ / _` / __|/ _ \
prompt |  / ___ \| |\ V  V / (_| | |_| \__ \   / ___ \ V / (_| | | | (_| | |_) | |  __/  | |_| | (_| | || (_| | |_) | (_| \__ \  __/
prompt | /_/   \_\_| \_/\_/ \__,_|\__, |___/  /_/   \_\_/ \__,_|_|_|\__,_|_.__/|_|\___|  |____/ \__,_|\__\__,_|_.__/ \__,_|___/\___|
prompt |                          |___/                                                                                             

pause 

clear screen

set echo off
set termout off

@@drop_table movie_star
@@drop_sequence movie_star_seq

column id format 999
column first_name format a10
column last_name format a10
column birth_date format a10
column added_on format a20

set echo on
set termout on

create sequence movie_star_seq keep;

create table movie_star
(
  id          number not null,
  first_name  varchar(20) not null,
  last_name   varchar(20) not null,
  birth_date  date not null,
  added_on    date default sysdate not null,
  constraint movie_star_pk primary key (id)
)
/

pause

begin
  insert into movie_star
  (id, first_name, last_name, birth_date)
  values
  (movie_star_seq.nextval, 'Brad', 'Pitt', date '1963-12-18');

  insert into movie_star
  (id, first_name, last_name, birth_date)
  values
  (movie_star_seq.nextval, 'George', 'Clooney', date '1961-05-06');

  insert into movie_star
  (id, first_name, last_name, birth_date)
  values
  (movie_star_seq.nextval, 'Matt', 'Damon', date '1970-10-08');
end;
.
pause 
/

commit
/

select
  id,
  first_name,
  last_name,
  to_char(birth_date, 'yyyy-mm-dd') as birth_date,
  to_char(added_on, 'yyyy-mm-dd, hh24:mi') as added_on  
from movie_star
order by 1
.
pause
/

pause

begin
  insert into movie_star
  (id, first_name, last_name, birth_date)
  values
  (movie_star_seq.nextval, 'Salma', 'Hayek', date '1966-09-02');

  insert into movie_star
  (id, first_name, last_name, birth_date)
  values
  (movie_star_seq.nextval, 'Helen', 'Mirren', date '1945-07-26');

  insert into movie_star
  (id, first_name, last_name, birth_date)
  values
  (movie_star_seq.nextval, 'Jodie', 'Foster', date '1962-11-19');
end;
.
pause 
/

select
  id,
  first_name,
  last_name,
  to_char(birth_date, 'yyyy-mm-dd') as birth_date,
  to_char(added_on, 'yyyy-mm-dd, hh24:mi') as added_on  
from movie_star
order by 1
.
pause
/

select
  id,
  first_name,
  last_name,
  to_char(birth_date, 'yyyy-mm-dd') as birth_date,
  to_char(added_on, 'yyyy-mm-dd, hh24:mi') as added_on  
from movie_star
order by 1
.
pause
/

pause
