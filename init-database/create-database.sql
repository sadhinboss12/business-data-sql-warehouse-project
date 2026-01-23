--initialtng database
use master
go
if exists (select 1 from sys.databases where name = 'BusinessData')
begin
	alter 
--Creating Database
create database BusinessData 
go

--Creating Schema
use BusinessData
go
create schema bronze
go 
create schema silver
go 
create schema gold
