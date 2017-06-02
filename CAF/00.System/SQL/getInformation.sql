set define on

set feedback off

set echo off

set verify off

set pagesize 0

set heading off

set termout off

set trim on

set wrap on

set trimspool on

set sqlblanklines on

set linesize 10000

set colsep , 

spool .\01.Inbox\App1\Data\FDMEE\MyInputFile.csv

select * from my_table;

spool off

exit;

