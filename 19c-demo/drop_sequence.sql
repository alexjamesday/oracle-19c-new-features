declare
  seq_not_exists exception;
  pragma exception_init(seq_not_exists, -02289);
begin
  execute immediate 'drop sequence &1.';
exception
  when seq_not_exists then null;
end;
/
