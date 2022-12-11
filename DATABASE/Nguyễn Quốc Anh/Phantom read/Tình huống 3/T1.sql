use DOAN_HQTCSDL
go
exec sp_themthongtintaixe N'Nguyễn Quốc Anh','0123456389','0123474789','11D-1111',NULL,NULL,N'Nam','11','1','101'

EXEC dbo.sp_themthongtintaixe @ten = N'Nguyễn Quốc Anh',       -- nvarchar(10)
                              @cmnd = '0123456389',       -- char(20)
                              @sdt = '0123474789',        -- char(10)
                              @bien_so_xe = '11D-1111', -- char(10)
                              @stk = '',        -- char(20)
                              @ngan_hang = N'', -- nvarchar(100)
                              @gioi_tinh = N'Nam', -- nvarchar(10)
                              @ma_tinh = '11',    -- char(10)
                              @ma_huyen = '1',   -- char(10)
                              @ma_xa = '101'       -- char(10)


SELECT * FROM dbo.TAIXE
SELECT * FROM dbo.DIACHI