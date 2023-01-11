USE DOAN_HQTCSDL
GO 
set transaction isolation level read uncommitted

SELECT * FROM dbo.MONAN
waitfor delay '0:0:10'
select * from MONAN
