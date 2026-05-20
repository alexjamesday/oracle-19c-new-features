set echo on
set termout on

@drop_table tmp_txn

create table tmp_txn as select * from txn;

truncate table txn;

alter table txn add
(
  padding   varchar2(100) not null
);

insert into txn
select
  t.*,
  dbms_random.string('a', 100)
from tmp_txn t;

@drop_table tmp_txn

