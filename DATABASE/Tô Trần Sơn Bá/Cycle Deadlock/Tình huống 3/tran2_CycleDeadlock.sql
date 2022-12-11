USE DOAN_HQTCSDL
GO
exec pr_TXHoanThanhDonHang 'DH_2', 'TX_1'
go

select * from DONHANG
select * from TINHTRANGGIAOHANG