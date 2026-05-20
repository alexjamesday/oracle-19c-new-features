set echo off
set termout on
clear screen


prompt |  __  __                       ___        _   _           _              _  __        __    _ _            
prompt | |  \/  | ___ _ __ ___        / _ \ _ __ | |_(_)_ __ ___ (_)___  ___  __| | \ \      / / __(_) |_ ___  ___ 
prompt | | |\/| |/ _ \ '_ ` _ \ _____| | | | '_ \| __| | '_ ` _ \| / __|/ _ \/ _` |  \ \ /\ / / '__| | __/ _ \/ __|
prompt | | |  | |  __/ | | | | |_____| |_| | |_) | |_| | | | | | | \__ \  __/ (_| |   \ V  V /| |  | | ||  __/\__ \
prompt | |_|  |_|\___|_| |_| |_|      \___/| .__/ \__|_|_| |_| |_|_|___/\___|\__,_|    \_/\_/ |_|  |_|\__\___||___/
prompt |                                   |_|                                                                     

pause 

clear screen

set echo off
set termout off

@@drop_table sensor_log

set echo on
set termout on

create table sensor_log
(
  logged_at date default sysdate not null,
  sensor_name varchar(20) not null,
  measured_value number default 0 not null,
  metric_type varchar(20) not null,
  constraint sensor_log_ck1 check (sensor_name in ('Temperature Sensor', 'Proximity Sensor', 'Pressure Sensor', 'Humidity Sensor')),
  constraint sensor_log_ck2 check (metric_type in ('Degrees Celsius', 'Metres', 'Kilo Pascal', 'Relative Humidity'))
)
.
pause 
/

create index sensor_log_ix1 on sensor_log (sensor_name, logged_at);

create or replace function get_next_sensor_name return varchar
is
  l_next_id pls_integer;
begin
  l_next_id := round(dbms_random.value(1, 4));
  
  return
    case l_next_id
      when 1 then 'Temperature Sensor'
      when 2 then 'Proximity Sensor'
      when 3 then 'Pressure Sensor'
      when 4 then 'Humidity Sensor'
    end;
end;
.
pause 
/

declare
  l_next_sensor sensor_log.sensor_name%type;
begin
  for idx in 1 .. 50000 loop
    l_next_sensor := get_next_sensor_name;
    
    insert into sensor_log
    (
      logged_at,
      sensor_name,
      measured_value,
      metric_type
    )
    values
    (
      sysdate,
      l_next_sensor,
      round(dbms_random.value(0, 100)),
      case l_next_sensor
        when 'Temperature Sensor' then 'Degrees Celsius'
        when 'Proximity Sensor' then 'Metres'
        when 'Pressure Sensor' then 'Kilo Pascal'
        when 'Humidity Sensor' then 'Relative Humidity'
      end
    );
    
    commit;
  end loop;
end;
.
pause 
/

pause 

alter table sensor_log memoptimize for write
.
pause 
/

pause

declare
  l_next_sensor sensor_log.sensor_name%type;
begin
  for idx in 1 .. 50000 loop
    l_next_sensor := get_next_sensor_name;
    
    insert /*+ memoptimize_write */ into sensor_log
    (
      logged_at,
      sensor_name,
      measured_value,
      metric_type
    )
    values
    (
      sysdate,
      l_next_sensor,
      round(dbms_random.value(0, 100)),
      case l_next_sensor
        when 'Temperature Sensor' then 'Degrees Celsius'
        when 'Proximity Sensor' then 'Metres'
        when 'Pressure Sensor' then 'Kilo Pascal'
        when 'Humidity Sensor' then 'Relative Humidity'
      end
    );
    
  end loop;
end;
.
pause 

/

pause

alter table sensor_log no memoptimize for write;
