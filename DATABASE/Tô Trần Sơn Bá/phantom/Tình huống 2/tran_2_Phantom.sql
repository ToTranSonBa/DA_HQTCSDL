USE DOAN_HQTCSDL
GO

EXEC dbo.sp_ThemVaoGioHang @MAN_MA = 'MN_2', -- char(10)
                           @TD_MA = 'TD_1',  -- char(10)
                           @CN_MA = 'CN_3',  -- char(10)
                           @CH_MA = 'CH_1',  -- char(10)
                           @KH_MA = 'KH_4',  -- char(10)
                           @SOLUONG = 3, -- int
                           @NOTES = N''  -- nvarchar(100)





SELECT * FROM dbo.GIOHANG
SELECT * FROM dbo.MONAN
SELECT * FROM dbo.KHACHHANG