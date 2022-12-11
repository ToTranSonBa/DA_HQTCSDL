USE DOAN_HQTCSDL
GO
---
-- 1.	Tình huống 1: Đối tác (1) đang thực hiện sửa sản phẩm trong cửa hàng chưa commit thì đối tác(2) xoá sản phẩm đối tác (1) đang sửa và đã commit  
EXEC PROC_XOAMONAN_DT 'MN_4' , 'CH_4', 'CN_2', 'TD_2'
-- 2.	Tình huống 2: Khách hàng đang trong quá trình thực hiện xem chi tiết món ăn thì bị đối tác cắt ngang xoá món ăn mà khách hàng cần xem chi tiết
EXEC  PROC_CAPNHATMONAN_DT 'MN_4' , 'CH_4', 'CN_2', 'TD_2', 'BÁNH KẸO', 'Ngon', N'Có bán', 25000
-- 3.	Tình huống 3: Khách hàng đang trong quá trình thực hiện thêm món ăn vào đơn hàng thì bị đối tác cắt ngang xoá món ăn mà khách hàng cần mua
exec PROC_XOAMONAN_DT 'MN_4' , 'CH_4', 'CN_2', 'TD_2'

SELECT * FROM dbo.MONAN