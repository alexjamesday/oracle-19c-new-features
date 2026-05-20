declare
  table_not_exists exception;
  pragma exception_init(table_not_exists, -942);
begin
  execute immediate 'drop table &1. cascade constraints purge';
exception
  when table_not_exists then null;
end;
/
