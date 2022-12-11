USE DOAN_HQTCSDL
GO

EXEC dbo.SP_KHDATHANG @kH_MA = 'KH_4',               -- char(10)
                      @PHUONGTHUCTHANHTOAN = N'Thanh toán online' -- nvarchar(100)
 
 SELECT * FROM dbo.GIOHANG
