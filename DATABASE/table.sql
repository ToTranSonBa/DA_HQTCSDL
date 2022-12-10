CREATE 
--DROP
DATABASE DOAN_HQTCSDL
GO

USE test 
GO

USE DOAN_HQTCSDL
GO


CREATE
--ALTER
TABLE HOPDONG (
	HD_MA INT IDENTITY(1,1) PRIMARY KEY,
	HD_NGAYLAP DATETIME,
	HD_STK CHAR(50) NOT NULL UNIQUE,
	HD_NGANHANG NVARCHAR(100),
	HD_CHINHANHNGANHANG NVARCHAR(100),
	HD_TINHTRANG NVARCHAR(50),
	HD_HOAHONG FLOAT,
	HD_TGHIEULUC DATE,
	DT_MA INT,
	NV_MA INT 
)
GO

CREATE 
--ALTER
TABLE HOSODANGKY (
	HSDK_MA INT IDENTITY(1,1) PRIMARY KEY,
	HD_MA INT,
	HSDK_EMAIL NVARCHAR(50) UNIQUE,
	HSDK_TENQUAN NVARCHAR(100),
	HSDK_THANHPHO NVARCHAR(50),
	HSDK_QUAN NVARCHAR(50),
	HSDK_SLCHINHANH INT,
	HSDK_SLDONHANGTOITHIEU INT,
	HSDK_LOAIAMTHUC NVARCHAR(100),
	HSDK_NGUOIDAIDIEN NVARCHAR(100),
	NV_MA INT,
	DT_MA INT 
)
GO

CREATE 
--ALTER
TABLE DOITAC ( 
	DT_MA INT IDENTITY(1,1) PRIMARY KEY,
	DT_TEN NVARCHAR(100),
	DT_SDT CHAR(10) UNIQUE,
	DT_EMAIL NVARCHAR(100)
)
GO

CREATE 
--ALTER
TABLE NHANVIEN (
	NV_MA INT IDENTITY(1,1) PRIMARY KEY,
	NV_TEN NVARCHAR(50),
	NV_NGAYSINH DATE,
	NV_CMND CHAR(20) UNIQUE,
	NV_SDT CHAR(10) UNIQUE,
	NV_GIOITINH NVARCHAR(10),
	NV_MAIL NVARCHAR(100) UNIQUE,
	--DIACHI
	DC_MATINH INT,
	DC_MAHUYEN INT,
	DC_MAXA INT
) 
GO

CREATE
--ALTER
TABLE PHIHOAHONG (
	DH_MA INT,
	PHH_TONGTIEN MONEY,
	PHH_NGAYNOP DATETIME,
	PHH_PHITHANG INT, -- NOP TIEN CHO THANG ... NAM ...
	NV_MA INT 
	CONSTRAINT PK_PHH PRIMARY KEY (DH_MA,NV_MA)
)
GO

CREATE 
--ALTER
TABLE CUAHANG (
	CH_MA INT IDENTITY(1,1) PRIMARY KEY,
	DT_MA INT,
	CH_TEN CHAR(100), 
	CH_TGMOCUA TIME,
	CH_TGDONGCUA TIME,
	CH_SDT CHAR(10),
	CH_TINHTRANGHOATDONG NVARCHAR(50)
)
GO

CREATE 
--ALTER
TABLE CHINHANH (
	CN_MA INT IDENTITY(1,1), 
	CH_MA INT,
	DC_MATINH INT,
	DC_MAHUYEN INT,
	DC_MAXA INT,
	CN_TEN NVARCHAR(100)
	CONSTRAINT PK_CHINHANH PRIMARY KEY (CN_MA,CH_MA)
)
GO

CREATE 
--ALTER
TABLE THUCDON (
	TD_MA INT IDENTITY(1,1),		
	CN_MA INT, 
	CH_MA INT,
	TD_TEN INT
	CONSTRAINT PK_THUCDON PRIMARY KEY (TD_MA,CN_MA,CH_MA)
)
GO

CREATE 
--ALTER
TABLE MONAN (
	MAN_MA INT IDENTITY(1,1),
	TD_MA INT,
	CN_MA INT, 
	CH_MA INT,
	MAN_TEN NVARCHAR(100) UNIQUE,
	MAN_MIEUTA NVARCHAR(100),
	MAN_TINHTRANG NVARCHAR(100),
	MAN_IMGPATH NVARCHAR(100),
	MAN_GIA MONEY
	CONSTRAINT PK_MONAN PRIMARY KEY (MAN_MA, TD_MA,CN_MA,CH_MA)
)
GO

CREATE
--ALTER
TABLE DONHANG (
	DH_MA INT IDENTITY(1,1) PRIMARY KEY,
	DH_NGAYDAT DATETIME,
	DH_PHUONGTHUCTHANHTOAN NVARCHAR(100),
	DH_TONGTIEN MONEY,
	KH_MA INT, 
	CH_MA INT,
	DH_PHIVANCHUYEN MONEY,
	DH_TINHTRANG  NVARCHAR(50),
	TX_MA INT,
	--DIACHI
	DC_MATINH INT,
	DC_MAHUYEN INT,
	DC_MAXA INT,
)
GO


CREATE
--ALTER
TABLE CHITIETDONHANG (
	DH_MA INT PRIMARY KEY,
	MAN_MA INT,
	TD_MA INT,
	CN_MA INT, 
	CH_MA INT,
	CTDH_SOLUONG INT,
	CTDH_GIATIEN MONEY,
	CTDH_GHICHU NVARCHAR(100)
)
GO

CREATE
--ALTER
TABLE TAIXE (
	TX_MA INT IDENTITY(1,1) PRIMARY KEY,
	TX_TEN NVARCHAR(100),
	TX_CMND INT UNIQUE NOT NULL,
	TX_SDT CHAR(10),
	TX_BIENSOXE CHAR(20) UNIQUE NOT NULL,
	TX_STK CHAR(20) UNIQUE NOT NULL,
	TX_NGANHANG NVARCHAR(100),
	TX_GIOITINH NVARCHAR(10),
	--DIACHI
	DC_MATINH INT,
	DC_MAHUYEN INT,
	DC_MAXA INT,
)
GO

CREATE 
--ALTER 
TABLE TINHTRANGGIAOHANG (
	TX_MA INT,
	DH_MA INT,
	TTGH_TINHTRANG NVARCHAR(50),

	--vi tri tai xe giao hang hien tai
	DC_MATINH INT,
	DC_MAHUYEN INT,
	DC_MAXA INT,
	CONSTRAINT PK_TINHTRANGGIAOHANG PRIMARY KEY (TX_MA, DH_MA)
)
GO

CREATE 
--ALTER 
TABLE KHACHHANG (
	KH_MA INT IDENTITY(1,1) PRIMARY KEY,
	KH_TEN NVARCHAR(100),
	KH_SDT CHAR(100),
	KH_MAIL CHAR(100),
	KH_GIOITINH NVARCHAR(10),
	--DIACHI
	DC_MATINH INT,
	DC_MAHUYEN INT,
	DC_MAXA INT,
	DC_SONHA NVARCHAR(100)
)
GO



CREATE
--ALTER
TABLE DIACHI (
	DC_MATINH INT NOT NULL UNIQUE,
	DC_MAHUYEN INT NOT NULL UNIQUE,
	DC_MAXA INT NOT NULL UNIQUE,
	DC_TENTINH NVARCHAR(100),
	DC_TENHUYEN NVARCHAR(100),
	DC_TENXA NVARCHAR(100),
	CONSTRAINT PK_DIACHI PRIMARY KEY (DC_MATINH, DC_MAHUYEN, DC_MAXA)
)
GO

CREATE
--ALTER
TABLE TAIKHOAN(
	MA CHAR(10) NOT NULL PRIMARY KEY,
	UNAME CHAR(20) NOT NULL,
	PWD CHAR(10) NOT NULL,
	LOAI CHAR(10) NOT NULL
)

CREATE 
--ALTER
--DROP
TABLE GIOHANG(
	MAN_MA INT NOT NULL,
	KH_MA INT NOT NULL,
	SOLUONG INT NOT NULL,
	CONSTRAINT PK_GIOHANG PRIMARY KEY (MAN_MA, KH_MA),
	CONSTRAINT FK_GIOHANG_KHACHHANG FOREIGN KEY (KH_MA) REFERENCES dbo.KHACHHANG(KH_MA),
)
--=====================================================================================================================
----KHÓA NGOẠI
-- HOSODANGKY -> HOPDONG 1: CHITIETHOPDONG
ALTER TABLE HOSODANGKY
ADD CONSTRAINT FK_HOSODK_HOPDONG
FOREIGN KEY (HD_MA)
REFERENCES HOPDONG(HD_MA)

-- HOSODANGKY -> DOITAC 2: DANGKYCUAHANG
ALTER TABLE HOSODANGKY
ADD CONSTRAINT FK_HOSODK_DOITAC	
FOREIGN KEY (DT_MA)
REFERENCES DOITAC(DT_MA)

--HOSODANGKY -> NHANVIEN 3: KYHOPDONG
ALTER TABLE HOSODANGKY
ADD CONSTRAINT FK_HOSODK_NHANVIEN	
FOREIGN KEY (NV_MA)
REFERENCES NHANVIEN(NV_MA)

--NHANVIEN -> DIACHI 4: DIACHINHANVIEN
ALTER TABLE NHANVIEN
ADD CONSTRAINT FK_NHANVIEN_DIACHI
FOREIGN KEY (DC_MATINH,DC_MAHUYEN,DC_MAXA)
REFERENCES DIACHI(DC_MATINH,DC_MAHUYEN,DC_MAXA)

--PHIHOAHONG -> DONHANG 5: NOPPHH
ALTER TABLE PHIHOAHONG
ADD CONSTRAINT FK_PHIHOAHONG_DONHANG
FOREIGN KEY (DH_MA)
REFERENCES DONHANG(DH_MA)

-- PHIHOAHONG -> NHANVIEN 6: THUPHH
ALTER TABLE PHIHOAHONG
ADD CONSTRAINT FK_PHIHOAHONG_NHANVIEN
FOREIGN KEY (NV_MA)
REFERENCES NHANVIEN(NV_MA)

-- CUAHANG -> DOITAC 7: SOHUU
ALTER TABLE CUAHANG
ADD CONSTRAINT FK_CUAHANG_DOITAC
FOREIGN KEY (DT_MA)
REFERENCES DOITAC(DT_MA)

--CHINHANH -> CUAHNANG 8: CHINHANHCON
ALTER TABLE CHINHANH
ADD CONSTRAINT FK_CHINHANH_CUAHANG
FOREIGN KEY (CH_MA)
REFERENCES CUAHANG(CH_MA)

--THUCDON -> CHINHANH 9: THUCDONCHINHANH
ALTER TABLE THUCDON
ADD CONSTRAINT FK_THUCDON_CHINHANH
FOREIGN KEY (CN_MA,CH_MA)
REFERENCES CHINHANH(CN_MA,CH_MA)

--MONAN -> THUCDON 10: CHITIETTHUCDON
ALTER TABLE MONAN
ADD CONSTRAINT FK_MONAN_THUCDON
FOREIGN KEY (TD_MA, CN_MA, CH_MA)
REFERENCES THUCDON(TD_MA, CN_MA, CH_MA)

--DONHANG -> CUAHANG 11: DONTHUOCCUAHANG
ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_CUAHANG
FOREIGN KEY (CH_MA)
REFERENCES CUAHANG(CH_MA)

--DONHANG ->KHACHHANG 12: DATHANG
ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_KHACHHANG
FOREIGN KEY (KH_MA)
REFERENCES KHACHHANG(KH_MA)

--CHITIETDONHANG -> DONHANG 13: CHITIETDONHANG
ALTER TABLE CHITIETDONHANG
ADD CONSTRAINT FK_CHITIETDONHANG_DONHANG
FOREIGN KEY (DH_MA)
REFERENCES DONHANG(DH_MA)

--CHITIETDONHANG -> MONAN 14: MONANDUOCDAT ------------------LOI
ALTER TABLE CHITIETDONHANG
ADD CONSTRAINT FK_CHITIETDONHANG_MONAN
FOREIGN KEY (MAN_MA, TD_MA, CN_MA, CH_MA)
REFERENCES MONAN(MAN_MA, TD_MA, CN_MA, CH_MA)

--TINHTRANGGIAOHANG -> TAIXE 15: CAPNHAT_TTGH
ALTER TABLE TINHTRANGGIAOHANG
ADD CONSTRAINT FK_TINHTRANGGIAOHANG_TAIXE
FOREIGN KEY (TX_MA)
REFERENCES TAIXE(TX_MA)

--TINHTRANGGIAOHANG -> DONHANG 16: TINHTRANGCUADONHANG
ALTER TABLE TINHTRANGGIAOHANG
ADD CONSTRAINT FK_TINHTRANGGIAOHANG_KHACHHANG
FOREIGN KEY (DH_MA)
REFERENCES DONHANG(DH_MA)

--KHACHHANG-> DIACHI 17: DIACHIKHACHHANG
ALTER TABLE KHACHHANG
ADD CONSTRAINT FK_KHACHHANG_DIACHI
FOREIGN KEY (DC_MATINH,DC_MAHUYEN,DC_MAXA)
REFERENCES DIACHI(DC_MATINH,DC_MAHUYEN,DC_MAXA)

--TAIXE-> DIACHI 18: KHUVUCHOATDONG
ALTER TABLE TAIXE
ADD CONSTRAINT FK_TAIXE_DIACHI
FOREIGN KEY (DC_MATINH,DC_MAHUYEN,DC_MAXA)
REFERENCES DIACHI(DC_MATINH,DC_MAHUYEN,DC_MAXA)


--TINHTRANGDONHANG-> DIACHI 19: VITRIHIENTAI---------LOI
ALTER TABLE TINHTRANGGIAOHANG
ADD CONSTRAINT FK_TINHTRANGGIAOHANG_DIACHI
FOREIGN KEY (DC_MATINH,DC_MAHUYEN,DC_MAXA)
REFERENCES DIACHI(DC_MATINH,DC_MAHUYEN,DC_MAXA)

--HOPDONG -> NHANVIEN 20: DANGKY
ALTER TABLE HOPDONG
ADD CONSTRAINT FK_HOPDONG_NHANVIEN
FOREIGN KEY (NV_MA)
REFERENCES NHANVIEN(NV_MA)

--CHINHANH-> DIACHI 21: DIACHICHINHANH
ALTER TABLE CHINHANH
ADD CONSTRAINT FK_CHINHANH_DIACHI
FOREIGN KEY (DC_MATINH,DC_MAHUYEN,DC_MAXA)
REFERENCES DIACHI(DC_MATINH,DC_MAHUYEN,DC_MAXA)

--DONHANG -> DIACHI 22: DIACHIGIAOHANG
ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_DIACHI
FOREIGN KEY (DC_MATINH,DC_MAHUYEN,DC_MAXA)
REFERENCES DIACHI(DC_MATINH,DC_MAHUYEN,DC_MAXA)
GO 
--================================================================================================================================

---	RÀNG BUỘC TOÀN VẸN

--ngày nộp phí hoa hồng phải lớn hơn ngày lập hợp đồng
CREATE
--ALTER
--DROP
trigger tg_checkNgayNopPHH
on PHIHOAHONG
for insert ,update
as
begin 
	if exists (select *
				from inserted i, HOPDONG hd,NHANVIEN nv
				where hd.NV_MA = nv.NV_MA and nv.NV_MA = i.NV_MA and i.PHH_NGAYNOP < hd.HD_NGAYLAP)
	begin
		raiserror(N'ngày nộp phí hoa hồng phải lớn hơn ngày ngày lập hợp đồng',16,1)
		rollback
	end
END
go

--ngày sinh của nhân viên phải nhỏ hơn ngày lập hợp đồng
CREATE
--ALTER
--DROP
TRIGGER tg_checkNamSinhNhanVien
on NHANVIEN
for insert,update
as
begin
	if exists (select *
				from inserted i ,HOPDONG hd, HOSODANGKY hsdk
				where hd.HD_MA =hsdk.HD_MA and hsdk.NV_MA = i.NV_MA
				and i.NV_NGAYSINH > hd.HD_NGAYLAP)
	begin
		raiserror(N'ngày sinh của nhân viên nhập sai',16,1)
		rollback
	end
END
go

-- tình trạng hoạt động của cửa hàng phải là mở cửa
alter table CUAHANG add constraint check_TinhTrangHoatDong check(CH_TINHTRANGHOATDONG = N'Mở cửa'
OR CH_TINHTRANGHOATDONG = N'Đóng cửa')
go

-- tên các món ăn không được trùng nhau

CREATE
--ALTER
--DROP
TRIGGER tg_checkTenMonAn
on MONAN
for insert,update
as
begin
	if exists (select *
				from inserted i ,MONAN ma
				WHERE  i.MAN_TEN = ma.MAN_TEN AND i.MAN_MA != ma.MAN_MA )
	BEGIN
		RAISERROR(N'các món ăn phải có tên khác nhau',16,1)
		ROLLBACK
	END
END
go

--tình trạng của hợp đồng là còn hiệu lực và hết hết hiệu lực
alter table HOPDONG add constraint check_TinhTrangHopDong 
check (HD_TINHTRANG = N'Hiệu lực' or HD_TINHTRANG = N'Hết hiệu lực')
go
--tình trạng đơn đạt hàng phải là đang xác thực hoặc chưa xác thực
alter table DONHANG add constraint check_TinhTrangDonHang
check (DH_TINHTRANG = N'Đã xác nhận' or DH_TINHTRANG = N'Chưa xác nhân' OR DH_TINHTRANG = N'Đang giao' OR DH_TINHTRANG = N'Đã giao thành công')
GO 
--tình trạng các món ăn phải là có bán ,hết hàng hôm nay ,tạm ngừng, ngừng bán
alter table MONAN add constraint check_TinhTrangMonAn
check (MAN_TINHTRANG = N'Có bán' or MAN_TINHTRANG = N'Hết hàng hôm ngay' 
or MAN_TINHTRANG = N'Tạm ngừng' or MAN_TINHTRANG = N'Ngừng bán')
GO 
--tình trạng  giao hàng là đã nhận đơn hàng hoặc chưa nhận đơn hàng, đã giao thành công
alter table TINHTRANGGIAOHANG add constraint check_ChiTietGiaoHang 
check (TTGH_TINHTRANG = N'Đã nhận đơn hàng'or TTGH_TINHTRANG = N'chưa nhận đơn hàng' OR TTGH_TINHTRANG = N'Đã giao thành công')

-- phí tháng của PHIHOAHONG phải từ 1->12
alter table PHIHOAHONG add constraint check_PhiThangHoaHong 
check (PHH_PHITHANG >=1 and PHH_PHITHANG <= 12)
GO 
--phương thức thanh toán của đơn đặt hàng là thanh toán online hoặc thanh toán khi nhận hàng
alter table DONHANG add constraint check_PhuongThucThanhToan
check(DH_PHUONGTHUCTHANHTOAN = N'Thanh toán online' or DH_PHUONGTHUCTHANHTOAN = N'Thanh toán khi nhận hàng')
GO 
--phí vận chuyển phải nhỏ hơn tổng tiền của đơn hàng
create trigger tg_checkPhiVanChuyen
on DONHANG
for insert,update
as
begin
	if exists (select *
				from inserted i 
				where i.DH_TONGTIEN <= i.DH_PHIVANCHUYEN)
	begin
		raiserror(N'phí vận chuyển không được lớn hơn tổng tiền của đơn hàng',16,1)
		rollback
	end
end
GO 
-- Tên món tối đa 80 ký tự
alter table MONAN
ADD CONSTRAINT CHECK_TENMONAN
CHECK(LEN(MAN_TEN) < 80)
GO
-- Khách hang chỉ được đặt món ăn trong thực đơn
CREATE 
--ALTER
TRIGGER TR_DATHANG
ON CHITIETDONHANG
FOR INSERT, UPDATE
AS
BEGIN 
	IF NOT EXISTS (SELECT * FROM inserted I, MONAN MAN
					WHERE I.CH_MA= MAN.CH_MA AND I.CN_MA = MAN.CN_MA AND I.TD_MA = MAN.TD_MA
					AND I.MAN_MA = MAN.MAN_MA)
	BEGIN 
		raiserror(N'MON AN KHONG CO TRONG THUC DON',16,1)
		rollback
	END

END
GO

--giới tính của tài xế phải là Nam hoặc Nữ
alter table TAIXE add constraint check_PhaiTaiXe check(TX_GIOITINH = N'Nam' or TX_GIOITINH = N'Nữ')
GO 
--giới tính của Khách hàng phải là Nam hoặc Nữ
alter table KHACHHANG ADD constraint check_PhaiKhachHang check(KH_GIOITINH = N'Nam' or KH_GIOITINH = N'Nữ')
GO
----phí hoa hồng bằng 10% doanh thu
--CREATE
----ALTER
----DROP
--TRIGGER tg_PhiHoaHong
--on PHIHOAHONG
--for insert,update
--as
--if update(PHH_TONGTIEN)
--begin
--	update PHIHOAHONG
--	set PHH_TONGTIEN = (select sum(dh.DH_TONGTIEN)*0,1
--						from DONHANG dh
--						where PHIHOAHONG.DH_MA = dh.DH_MA and PHIHOAHONG.PHH_PHITHANG = month(dh.DH_NGAYDAT))	
--	where exists (select* 
--					from inserted i
--					where i.DH_MA = PHIHOAHONG.DH_MA and i.NV_MA = PHIHOAHONG.NV_MA)
--end
--GO 
--giá tiền trong chi tiết đơn hàng phải bằng giá tiền của món ăn
create trigger tg_GiaTienChiTietDonHang
on CHITIETDONHANG
for insert, update
as
begin
	update CHITIETDONHANG
	set CTDH_GIATIEN = (select ma.MAN_GIA
						from MONAN ma
						where ma.MAN_MA = CHITIETDONHANG.MAN_MA)
	where exists (select * 
					from inserted i
					where i.DH_MA = CHITIETDONHANG.DH_MA and i.MAN_MA = CHITIETDONHANG.MAN_MA)
end
GO 

--tổng tiền của một đơn hàng bằng tổng giá tất cả các món trong chi tiết  đơn hàng
CREATE 
-- alter 
-- DROP 
TRIGGER tg_TongTienDonHang
on DONHANG
for insert ,update
as
begin
	UPDATE DONHANG
	set DH_TONGTIEN =  (select sum(ctdh.CTDH_SOLUONG*ctdh.CTDH_GIATIEN)
						from CHITIETDONHANG ctdh
						where ctdh.DH_MA = DONHANG.DH_MA)
	where exists (select *
					from inserted i
					where i.DH_MA = i.DH_MA)
end
GO 
--tổng tiền của 1 đơn hàng trừ đi 20% hoa hồng
create trigger tg_TongTienSauCungCuaDonHang
on DONHANG
for insert,update
as
begin
	update DONHANG
	set DH_TONGTIEN =DH_TONGTIEN *0.8
	where exists (select *
					from inserted i
					where DONHANG.DH_MA = i.DH_MA)
end

--thời gian mở của của một của hàng phải sớm hơn thời gian đóng cửa
alter table CUAHANG add constraint check_ThoiGianDongMoCuaHang check(CH_TGMOCUA <CH_TGDONGCUA)
GO 

--thời gian mở của của một của hàng phải sớm hơn thời gian đóng cửa
alter table CUAHANG add constraint check_ThoiGianDongMoCuaHang check(CH_TGMOCUA <CH_TGDONGCUA)
GO 
--================================================================================================================================================
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
on dbo.TINHTRANGGIAOHANG
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
on dbo.TINHTRANGGIAOHANG
to KhachHang
go

-- tai xe
Grant insert, update
on TAIXE
to TaiXe
go

Grant insert, update, delete
on dbo.TINHTRANGGIAOHANG
to TaiXe
go

-- nhan vien
Grant select, insert, update, delete
on HOPDONG 
to NhanVien
go

Grant select
on dbo.HOSODANGKY
to NhanVien
GO
--=========================================================================================================================================
---------------------------------------- NHANVIEN 
--xem danh sach doi tac CUA NHAN VIEN PHU TRACH
create
--alter
proc pr_xemdanhsachdoitac 
	@NV_MA INT
as
BEGIN TRANSACTION
	BEGIN TRY
		IF EXISTS(SELECT * FROM dbo.NHANVIEN WHERE NV_MA = @NV_MA)
		BEGIN 
			PRINT N'Loi thong tin dau vao khong hop le'
			ROLLBACK
		END 
		SELECT * FROM dbo.DOITAC JOIN dbo.HOPDONG HD ON HD.DT_MA = HD.DT_MA WHERE HD.NV_MA = @NV_MA
	END TRY
	BEGIN CATCH
	END CATCH
COMMIT TRANSACTION
GO
------------------------------------------KHACHHANG
--thêm thông tin cho khách hàng mới
create proc sp_ThemThongTinKhachHang
	@tenkh nvarchar(100),
	@sdtkh char(10),
	@mailkh char(100),
	@gioitinhkh nvarchar(10),
	@dc_matinh INT,
	@dc_mahuyen INT,
	@dc_maxa INT,
	@kh_sonha NVARCHAR(100)
AS
BEGIN TRAN
	BEGIN TRY
		IF NOT EXISTS (SELECT *
						FROM DIACHI dc
						WHERE dc.DC_MATINH = @dc_matinh)
		BEGIN 
			PRINT N'mã tỉnh ' + @dc_matinh + N' không tồn tại'
			ROLLBACK TRAN
		END

		IF NOT EXISTS (SELECT *
						FROM DIACHI dc
						WHERE dc.DC_MAHUYEN = @dc_mahuyen)
		BEGIN 
			PRINT N'mã huyện ' + @dc_mahuyen + N' không tồn tại'
			ROLLBACK TRAN
		END

		IF NOT EXISTS (SELECT *
						FROM DIACHI dc
						WHERE dc.DC_MAXA = @dc_maxa)
		BEGIN 
			PRINT N'mã xã ' + @dc_maxa + N' không tồn tại'
			ROLLBACK TRAN
		END
		
		INSERT KHACHHANG
		VALUES (@tenkh,@sdtkh,@mailkh,@gioitinhkh,@dc_matinh,@dc_mahuyen,@dc_maxa, @kh_sonha)
	END TRY
	BEGIN CATCH
		PRINT N'lỗi hệ thống'
		ROLLBACK tran
	END CATCH
COMMIT TRAN
GO


create proc sp_CapNhatThongTinKhachHang
	@makh INT,
	@tenkh nvarchar(100),
	@sdtkh char(10),
	@mailkh char(10),
	@gioitinhkh nvarchar(10),
	@dc_matinh INT,
	@dc_mahuyen INT,
	@dc_maxa INT
as
begin tran
	begin try
		--mã khách hàng không tồn tại
		if not exists (select *
						from KHACHHANG kh
						where  kh.KH_MA = @makh)
		begin 
			print N'mã khách hàng ' +@makh + N' không tồn tại'
			rollback tran
		end

		--kiểm tra địa chỉ tồn tại
		if not exists (select *
						from DIACHI dc
						where dc.DC_MATINH = @dc_matinh)
		begin 
			print N'mã tỉnh ' + @dc_matinh + N' không tồn tại'
			rollback tran
		end

		if not exists (select *
						from DIACHI dc
						where dc.DC_MAHUYEN = @dc_mahuyen)
		begin 
			print N'mã huyện ' + @dc_mahuyen + N' không tồn tại'
			rollback tran
		end

		if not exists (select *
						from DIACHI dc
						where dc.DC_MAXA = @dc_maxa)
		begin 
			print N'mã xã ' + @dc_maxa + N' không tồn tại'
			rollback tran
		end
		
		update KHACHHANG
		set KH_TEN = @tenkh, KH_SDT = @sdtkh, KH_MAIL = @mailkh, KH_GIOITINH = @gioitinhkh,
		DC_MAHUYEN = @dc_mahuyen, DC_MATINH = @dc_matinh, DC_MAXA = @dc_maxa
		where KH_MA = @makh
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit tran
GO 

--thêm chi tiets đơn đặt hàng
create proc sp_ThemChiTietDonHang
	@DH_MA INT,
	@MAN_MA INT,
	@TD_MA INT,
	@CN_MA INT, 
	@CH_MA INT,
	@CTDH_SOLUONG INT,
	@CTDH_GIATIEN MONEY,
	@CTDH_GHICHU NVARCHAR(100)
as
begin tran
	begin try
		--kiểm tra của hàng tồn tại
		if not exists (select *
						from CUAHANG ch
						where ch.CH_MA = @CH_MA)
		begin
			print N'cửa hàng không tồn tại'
			rollback tran
		end

		--kiểm tra món ăn tồn tại
		if not exists (select *
						from MONAN ma
						where ma.MAN_MA = @MAN_MA)
		begin
			print N'món ăn không tồn tại'
			rollback tran
		end
		--kiểm tra đơn hàng tồn tại
		if not exists (select *
						from DONHANG dh
						where dh.DH_MA = @DH_MA)
		begin
			print N'đơn hàng không tồn tại'
			rollback tran
		end
		--kiểm tra thực đơn tồn tại
		if not exists (select *
						from THUCDON td
						where td.TD_MA = @TD_MA)
		begin
			print N'thực đơn không tồn tại'
			rollback tran
		end
		--kiểm tra chi nhánh tồn tại
		if not exists (select *
						from CHINHANH cn
						where cn.CN_MA = @CN_MA)
		begin
			print N'chi nhánh không tồn tại'
			rollback tran
		end

		--kiểm tra số lượng phải >=1
		if @CTDH_SOLUONG <1
		begin
			print N'Số lượng ít nhất là 1'
			rollback tran
		end
		insert CHITIETDONHANG
		values(@DH_MA,@MAN_MA,@TD_MA,@CN_MA,@CH_MA,@CTDH_SOLUONG,@CTDH_GIATIEN,@CTDH_GHICHU)
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit tran
GO 

create proc sp_DanSachMonAnKhachHangTimKiem
	@tenmonan nvarchar(10)
as
begin tran
	begin try
		
		if not exists (select*
						from MONAN mn
						where  mn.MAN_TEN =@tenmonan)
		begin
			print N'Món ăn không tồn tại'
			rollback tran
		end

		select *
		from MONAN mn
		where mn.MAN_TEN = @tenmonan
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit TRAN
GO 
-- in danh sách đối tác cho khách hàng
create proc sp_DanhSachDoiTacChoKhachHang
	@makh INT 
as
	begin tran
	begin try
		if not exists (select * 
						from KHACHHANG kh
						where kh.KH_MA = @makh)
		begin
			print N'Khách hàng không tồn tại'
			rollback tran
		end

		select * 
		from DOITAC
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit tran
GO 


--in thực đơn theo đối tác mà khách hàng chọn
create proc sp_ThucDonTheoDoiTac
	@madt INT,
	@makh INT
as
begin tran
	begin try
		if not exists (select * 
						from KHACHHANG kh
						where kh.KH_MA = @makh)
		begin
			print N'Khách hàng không tồn tại'
			rollback tran
		end

		if not exists (select * 
						from DOITAC dt
						where dt.DT_MA = @madt)
		begin
			print N'Đối tác không tồn tại'
			rollback tran
		end

		select td.*
		from DOITAC dt join CUAHANG ch on dt.DT_MA = ch.DT_MA
		join CHINHANH cn on ch.CH_MA = cn.CH_MA
		join THUCDON td on cn.CN_MA = td.CN_MA
		where dt.DT_MA = @madt
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit TRAN
GO 

--hủy đơn hàng mà khách hàng muốn hủy
create proc sp_huyDonHang
	@makh char(10),
	@madh char(10)
as
begin tran
	begin try
		if not exists (select * 
						from KHACHHANG kh
						where kh.KH_MA = @makh)
		begin
			print N'Khách hàng không tồn tại'
			rollback tran
		end

		if not exists (select * 
					from DONHANG dh
					where dh.DH_MA = @madh)
		begin
			print N'Đơn hàng ' + @madh + N' không tồn tại'
			rollback tran
		end
		if not exists (select * 
					from DONHANG dh
					where dh.DH_MA = @madh AND dh.DH_TINHTRANG = N'Chưa xác nhận')
		begin
			print N'Không thể hủy đơn hàng'
			rollback tran
		END
        
		UPDATE dbo.DONHANG 
		SET DH_TINHTRANG = N'Đã hủy'
		WHERE DH_MA = @madh
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit TRAN
GO 

--khách hàng theo dõi quá trình vận chuyển đơn hàng
create proc sp_QuaTrinhVanChuyenChoKhachHang
	@makh INT,
	@madh INT 
as
begin tran
	begin try
		if not exists (select * 
						from KHACHHANG kh
						where kh.KH_MA = @makh)
		begin
			print N'Khách hàng không tồn tại'
			rollback tran
		end

		if not exists (select * 
					from DONHANG dh
					where dh.DH_MA = @madh)
		begin
			print N'Đơn hàng không tồn tại'
			rollback tran
		end

		select ttgh.TTGH_TINHTRANG
		from TINHTRANGGIAOHANG ttgh 
		where ttgh.DH_MA = @madh
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit TRAN
GO 

--khách hàng có thể xem được danh sách các đơn hàng đã đặt
create proc sp_XemDanhSachDonHangCuaKhachHang
	@makh char(10)
as
begin tran
	begin try
		if not exists (select * 
						from KHACHHANG kh
						where kh.KH_MA = @makh)
		begin
			print N'Khách hàng không tồn tại'
			rollback tran
		end

		select *
		from DONHANG dh
		where dh.KH_MA = @makh
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit TRAN
GO 

--Tài xế
--Chức năng của tài xế
--Thêm thông tin tài xế
create proc sp_themthongtintaixe
@ten nvarchar(10),
@cmnd char(20),
@sdt char(10),
@bien_so_xe char(10),
@stk char(20),
@ngan_hang nvarchar(100),
@gioi_tinh nvarchar(10),
@ma_tinh INT,
@ma_huyen int ,
@ma_xa INT 
as
begin transaction
	BEGIN TRY 
		if(@sdt = NULL or @ten = NULL or @cmnd = NULL or @bien_so_xe = NULL)
		begin
			print N'Không được để trống các thông tin quan trọng'
			rollback transaction
			return
		end
		if not exists (select * from DIACHI where DC_MATINH = @ma_tinh)
		begin 
			print N'mã tỉnh không tồn tại'
			rollback tran
			return
		end
		if not exists (select * from DIACHI where DC_MAHUYEN = @ma_huyen)
		begin 
			print N'mã huyện không tồn tại'
			rollback tran
			return
		end
		if not exists (select * from DIACHI where DC_MAXA = @ma_xa)
		begin 
			print N'mã xã  không tồn tại'
			rollback tran
			return
		end
		--Insert
		insert into TAIXE values(@ten, @cmnd, @sdt, @bien_so_xe, @stk, @ngan_hang,@gioi_tinh,@ma_tinh,@ma_huyen,@ma_xa)
		print 'Thêm thành công'
	END TRY
	BEGIN CATCH 

	END CATCH
commit transaction
go

--Xem thông tin của tài xế
create proc sp_xemthongtintaixe
	@ma int
as
begin transaction
	BEGIN TRY
		if(@ma = NULL )
		begin
			print N'Không nhận được mã'
			rollback transaction
			return
		end
		if not exists(select * from TAIXE where TX_MA=@ma)
		begin
			print N'Mã tài xế không tồn tại'
			rollback transaction
			return
		end
		--Select
		select * from TAIXE where TX_MA=@ma
	END TRY
	BEGIN CATCH
		PRINT N'Không xem được thông tin khách hàng'
		ROLLBACK TRANSACTION
	END CATCH
commit transaction
go

--Cập nhật thông tin tài xế
create proc sp_capnhatthongtintaixe
@ma INT,
@ten nvarchar(100),
@cmnd char(20),
@sdt char(10),
@bien_so_xe char(20),
@stk char(20),
@ngan_hang nvarchar(100),
@gioi_tinh nvarchar(10),
@ma_tinh INT,
@ma_huyen INT,
@ma_xa INT
as
begin transaction
	BEGIN TRY
		if(@ma = NULL or @sdt = NULL or @ten = NULL or @cmnd = NULL or @bien_so_xe = NULL)
		begin
			print N'Không được để trống các thông tin quan trọng'
			rollback transaction
			return
		end
		if not exists(select * from TAIXE where TX_MA=@ma)
		begin
			print N'Mã tài xế không tồn tại'
			rollback transaction
			return
		end
		if not exists (select * from DIACHI where DC_MATINH = @ma_tinh)
		begin 
			print N'mã tỉnh không tồn tại'
			rollback tran
			return
		end
		if not exists (select * from DIACHI where DC_MAHUYEN = @ma_huyen)
		begin 
			print N'mã huyện không tồn tại'
			rollback tran
			return
		end
		if not exists (select * from DIACHI where DC_MAXA = @ma_xa)
		begin 
			print N'mã xã không tồn tại'
			rollback tran
			return
		end
		--Update
		update TAIXE set
		TX_TEN=@ten, 
		TX_CMND=@cmnd, 
		TX_SDT=@sdt, 
		TX_BIENSOXE=@bien_so_xe, 
		TX_STK=@stk, 
		TX_NGANHANG=@ngan_hang,
		TX_GIOITINH=@gioi_tinh,
		DC_MATINH=@ma_tinh,
		DC_MAHUYEN=@ma_huyen,
		DC_MAXA=@ma_xa
		WHERE TX_MA = @ma
	END TRY
	BEGIN CATCH
	PRINT N'Loi update'
		ROLLBACK tran
	END CATCH
commit transaction
go

--Hiển thị ra danh sách đơn hàng chưa được nhận giao
create proc sp_xemdanhsachdonhang
as
begin TRANSACTION
	BEGIN TRY 
		SELECT * from TINHTRANGGIAOHANG where TTGH_TINHTRANG=N'chưa xác nhận đơn hàng' and TX_MA=NULL
	END TRY 
	BEGIN CATCH
		PRINT N'loi select'
		ROLLBACK
	END CATCH
commit transaction
GO

--Xử lý đơn đặt hàng 
create proc sp_xulydonhang
@ma_tx INT,
@ma_dh INT,
@tinhtrang nvarchar(50),
@maxa INT,
@mahuyen INT,
@matinh INT
as
begin transaction
	BEGIN TRY
		if(@ma_dh = NULL)
		begin
			print N'Không nhận được mã đơn hàng'
			rollback transaction
			return
		end
		if(@ma_tx = NULL)
		begin
			print N'Không nhận được mã tài xế'
			rollback transaction
			return
		end
		if(@tinhtrang = NULL )
		begin
			print N'Không được để trống'
			rollback transaction
			return
		end
		if not exists(select * from TINHTRANGGIAOHANG where DH_MA=@ma_dh)
		begin
			print N'Không có đơn hàng mã ' + @ma_dh 
			rollback transaction
			return
		end
		if exists(select * from TINHTRANGGIAOHANG where DH_MA=@ma_dh and TTGH_TINHTRANG=N'Đã nhận đơn hàng')
		begin
			print N'Mã đơn hàng ' + @ma_dh + N' đã nhận'
			rollback transaction
			return
		end
		if exists(select * from TINHTRANGGIAOHANG where DH_MA=@ma_dh and TX_MA<>@ma_tx  and TTGH_TINHTRANG=N'Đã nhận đơn hàng')
		begin
			print N'Mã đơn hàng ' + @ma_dh + N' đã có tài xế nhận'
			rollback transaction
			return
		END
        IF(@maxa = NULL OR @mahuyen = NULL OR @matinh = null)
			BEGIN
				PRINT N'Dia diem khong hop le'
				ROLLBACK
			END 
		IF EXISTS (SELECT * FROM dbo.DIACHI WHERE DC_MATINH = @matinh AND DC_MAHUYEN = @mahuyen AND DC_MAXA = @maxa)
			BEGIN
				PRINT N'Dia diem khong ton tai'
				ROLLBACK
			END 
		--Update tình trạng giao hàng
		if(@tinhtrang = N'Đã nhận đơn hàng')
		begin
			update TINHTRANGGIAOHANG set TTGH_TINHTRANG=@tinhtrang, DC_MATINH = @matinh, DC_MAHUYEN = @mahuyen, DC_MAXA = @maxa
			WHERE DH_MA = @ma_dh
			UPDATE dbo.DONHANG SET TX_MA = @ma_tx WHERE @ma_dh = DH_MA
		end
		else
		begin
			update TINHTRANGGIAOHANG set TX_MA=NULL , TTGH_TINHTRANG=N'chưa nhận đơn hàng'
			
		end
	END TRY 
	BEGIN CATCH 
		PRINT N'Loi Update'
		ROLLBACK
	END CATCH
commit transaction
GO

--Tiền đơn hàng tài xế nhận
create proc sp_tiendonhangtaixenhan
@ma_tx INT,
@ma_dh INT,
@money int out
as
begin transaction
	BEGIN TRY
		if(@ma_tx = NULL)
		begin
			print N'Không nhận được mã'
			rollback transaction
			return
		end
		if not exists(select * from TAIXE where TX_MA=@ma_tx)
		begin
			print N'Mã tài xế không tồn tại'
			rollback transaction
			return
		end
		--Select
		select @money=DH_TONGTIEN from DONHANG where DH_MA=@ma_dh
	END TRY
	BEGIN CATCH
		PRINT N'Loi select'
		ROLLBACK
	END CATCH
commit transaction
GO


--Tổng tiền đơn đã giao
create proc sp_tongtien
@ma_tx INT,
@sum_money int out
as
begin transaction
	BEGIN TRY
		if(@ma_tx = NULL )
		begin
			print N'Không nhận được mã'
			rollback transaction
			return
		end
		if not exists(select * from TAIXE where TX_MA=@ma_tx)
		begin
			print N'Mã tài xế không tồn tại'
			rollback transaction
			return
		end
		--Select
		select @sum_money=sum(DH_TONGTIEN) from TINHTRANGGIAOHANG left join DONHANG 
		ON TINHTRANGGIAOHANG.DH_MA=DONHANG.DH_MA where TINHTRANGGIAOHANG.TX_MA=@ma_tx 
		AND TINHTRANGGIAOHANG.TTGH_TINHTRANG=N'Đã nhận đơn hàng'
	END TRY
	BEGIN CATCH
		PRINT N'Loi select'
		ROLLBACK
	END CATCH
commit transaction
GO


----===========================================================================================================================================================
--insert into TAIKHOAN values('kh_01','zp19d0z','1234','KHACHHANG');
--insert into TAIKHOAN values('kh_02','20120429','1234','KHACHHANG');
--insert into TAIKHOAN values('kh_03','20120000','1234','KHACHHANG');
--insert into TAIKHOAN values('kh_04','20120001','1234','KHACHHANG');
--insert into TAIKHOAN values('kh_05','20120002','1234','KHACHHANG');

--insert into TAIKHOAN values('dt_01','20120008','1234','DOITAC');
--insert into TAIKHOAN values('dt_02','20120007','1234','DOITAC');
--insert into TAIKHOAN values('nv_01','20120003','1234','NHANVIEN');
--insert into TAIKHOAN values('nv_02','20120004','1234','NHANVIEN');
--insert into TAIKHOAN values('tx_01','20120005','1234','TAIXE');
--insert into TAIKHOAN values('tx_02','20120006','1234','TAIXE');



insert into DIACHI values('11','1','101',N'Cao Bằng','abc','bcd');
insert into DIACHI values('70','51','501',N'Tây Ninh','efg','abs');
insert into DIACHI values('59','81','1001',N'TP. Hồ Chí Minh','ekj','lop');
SELECT * FROM dbo.DIACHI
insert into dbo.KHACHHANG
(
    KH_TEN,
    KH_SDT,
    KH_MAIL,
    KH_GIOITINH,
    DC_MATINH,
    DC_MAHUYEN,
    DC_MAXA,
    DC_SONHA
)
VALUES
(   N'Nguyễn A', -- KH_TEN - nvarchar(100)
    '0395639633', -- KH_SDT - char(100)
    'abc@gmail', -- KH_MAIL - char(100)
    N'Nam', -- KH_GIOITINH - nvarchar(10)
    11, -- DC_MATINH - int
    1, -- DC_MAHUYEN - int
    101, -- DC_MAXA - int
    'SO 4 DUONG 321'  -- DC_SONHA - nvarchar(100)
)


--insert into KHACHHANG values(N'Nguyễn B','0395639611','abc1@gmail',N'Nam','11','1','1', NULL);
--insert into KHACHHANG values(N'Nguyễn C','0395639612','abc2@gmail',N'Nam','59','1','1', NULL);
--insert into KHACHHANG values(N'Nguyễn D','0395639613','abc3@gmail',N'Nam','11','1','1', NULL);
--insert into KHACHHANG values(N'Nguyễn E','0395639614','abc4@gmail',N'Nam','70','1','1', NULL);

--insert into DOITAC values('dt_01',N'Nguyễn Văn F','0395639615','ab5c@gmail.com');
--insert into DOITAC values('dt_02',N'Nguyễn Văn G','0395639616','abc6@gmail.com');
--insert into NHANVIEN values('nv_01',N'Nguyễn Văn H','2002-01-11','5809237594','0395639617',N'Nam','abc7@gmail.com','59','1','1');
--insert into NHANVIEN values('nv_02',N'Nguyễn Văn J','2002-02-22','5809345367','0395639618',N'Nam','abc8@gmail.com','11','1','1');
--insert into TAIXE values('tx_01',N'Nguyễn K','134804358994','0395639619','j29-4565','1458912432',N'MB Bank',N'Nam','70','1','1');
--insert into TAIXE values('tx_02',N'Nguyễn L','134809135995','0395639620','j29-3479','1458947598',N'Agribank',N'Nam','11','1','1');

--insert into CUAHANG values('ch_01','dt_01','Hambu đê','05:59:59','23:59:59','1999999990',NULL);
--insert into CUAHANG values('ch_04','dt_01','Hambu đê','05:59:59','23:59:59','1999999990',NULL);
--insert into CUAHANG values('ch_05','dt_02','Pizza đê','05:59:59','23:59:59','1989898989',NULL);

--insert into CHINHANH values('cn_03','ch_01','59','1','1',N'Chi Nhánh Tây Ninh');
--insert into CHINHANH values('cn_02','ch_04','70','1','1',N'Chi Nhánh TP Hồ Chí Minh');

--insert into THUCDON values('td_01','cn_03','ch_01',N'Menu Hambu');
--insert into THUCDON values('td_02','cn_02','ch_04',N'Menu Pizza');

--insert into MONAN values('mn_01','td_01','cn_03','ch_01',N'Hamburger Cá','abc',NULL,NULL,89999);
--insert into MONAN values('mn_02','td_01','cn_03','ch_01',N'Hamburger Bò','efg',NULL,NULL,99999);
--insert into MONAN values('mn_03','td_02','cn_02','ch_04',N'Pizza Thập Cẩm','ekj',NULL,NULL,199999);

