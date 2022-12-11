USE DOAN_HQTCSDL
GO
---
-- 1.	Tình huống 1: Đối tác (1) đang thực hiện sửa sản phẩm trong cửa hàng chưa commit thì đối tác(2) xoá sản phẩm đối tác (1) đang sửa và đã commit  
exec  PROC_CAPNHATMONAN_DT 'MN_4' , 'CH_4', 'CN_2', 'TD_2', N'BÁNH KẸO', 'Ngon', N'Có bán', 25000
-- 2.	Tình huống 2: Khách hàng đang trong quá trình thực hiện xem chi tiết món ăn thì bị đối tác cắt ngang xoá món ăn mà khách hàng cần xem chi tiết
EXEC PROC_XEMCHITIETSANPHAM_KH 'MN_4' , 'CH_4', 'CN_2', 'TD_2'
-- 3.	Tình huống 3: Khách hàng đang trong quá trình thực hiện thêm món ăn vào GIỎ hàng thì bị đối tác cắt ngang xoá món ăn mà khách hàng cần mua
EXEC dbo.sp_ThemVaoGioHang1 'MN_4' , 'TD_2', 'CN_2', 'CH_4',
                           @KH_MA = 'KH_2',  -- char(10)
                           @SOLUONG = 3, -- int
                           @NOTES = N'KHONG CO'  -- nvarchar(100)



SELECT * FROM dbo.MONAN
INSERT into MONAN values('MN_4','TD_2','CN_2','CH_4',N'ĐẬU PHỘNG','ekj',NULL,NULL,199999);