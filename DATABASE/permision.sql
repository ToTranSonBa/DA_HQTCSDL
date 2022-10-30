USE DOAN_HQTCSDL
GO

--tao role
EXEC sp_addrole 'DoiTac'
go

exec sp_addrole 'NhanVien'
go

exec sp_addrole 'TaiXe'
go

exec sp_addrole 'admin', 'dbo'
go

exec sp_addrole 'KhachHang'
go
-- cap quyen cho cac role
-- doi tac
Grant insert, update
on HOSODANGKY
to DoiTac
go

grant select
on HOPDONG
TO DoiTac
GO

grant select, update
on CUAHANG
to DoiTac
go

grant insert, update, delete, select
on THUCDON
to DoiTac
go

grant insert, update, delete, select
on MONAN
to DoiTac
go

grant select
on DONHANG
to DoiTac
go

grant select, update
on TINHTRANGDONHANG
to DoiTac
go

-- nhan vien
Grant insert, update
on KHACHHANG
to KhachHang
go

Grant select
on DOITAC
to KhachHang
go

Grant select
on THUCDON
to KhachHang
go

Grant select
on MONAN
to KhachHang
go

Grant insert
on CHITIETDONHANG
to KhachHang
go

Grant insert, delete
on DONHANG
to KhachHang
go

Grant insert
on TINHTRANGDONHANG
to KhachHang
go

-- tai xe
Grant insert, update
on TAIXE
to TaiXe
go

Grant insert, update, delete
on TINHTRANGDONHANG
to TaiXe
go

-- nhan vien
Grant select, insert, update, delete
on HOPDONG 
to NhanVien
go

Grant select
on HOSODANGKI 
to NhanVien
go


-----
