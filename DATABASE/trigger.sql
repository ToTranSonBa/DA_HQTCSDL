DATABASE DOAN_HQTCSDL
GO

use DOAN_HQTCSDL 
go
---	RÀNG BUỘC TOÀN VẸN

--Số cmnd phải là duy nhất cho TAI XE
CREATE TRIGGER tg_checkCMNDDoiTac
ON TAIXE
FOR INSERT ,UPDATE
AS
BEGIN
	IF EXISTS (SELECT *
				FROM INSERTED I ,TAIXE TX
				WHERE  I.TX_CMND = TX.TX_CMND AND I.TX_MA !=TX.TX_MA)
	BEGIN
		RAISERROR(N'Số chứng minh nhân dân nhập sai',16,1)
		ROLLBACK
	END
END


--Số cmnd phải là duy nhất cho nhân viên
create trigger tg_checkCMNDNhanVien
on NHANVIEN
for insert,update
as
begin
	if exists (select *
				from inserted i ,NHANVIEN nv
				WHERE  i.NV_CMND = nv.NV_CMND AND i.NV_MA != nv.NV_MA )
	BEGIN
		RAISERROR(N'Số chứng minh nhân viên nhập sai',16,1)
		ROLLBACK
	END
END

--ngày nộp phí hoa hồng phải lớn hơn ngày lập hợp đồng
create trigger tg_checkNgayNopPHH
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
end

--ngày sinh của nhân viên phải nhỏ hơn ngày lập hợp đồng
create trigger tg_checkNamSinhNhanVien
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
end

--email của các nhan viên không được giống nhau
create trigger tg_checkEmailNhanVien
on NHANVIEN
for insert,update
as
begin
	if exists (select *
				from inserted i ,NHANVIEN nv
				WHERE  i.NV_MAIL = nv.NV_MAIL AND i.NV_MA != nv.NV_MA )
	BEGIN
		RAISERROR(N'Email của các nhân viên phải khác nhau',16,1)
		ROLLBACK
	END
END

--email của các đối tác không được giống nhau
create trigger tg_checkEmailDoiTac
on DOITAC
for insert,update
as
begin
	if exists (select *
				from inserted i ,DOITAC dt
				WHERE  i.DT_EMAIL = dt.DT_EMAIL AND i.DT_MA != dt.DT_MA )
	BEGIN
		RAISERROR(N'Email của các đối tác phải khác nhau',16,1)
		ROLLBACK
	end
end

-- tình trạng hoạt động của cửa hàng phải là bình thường ,tạm nghỉ, đang bận ,đóng cửa
alter table CUAHANG add constraint check_TinhTrangHoatDong check(CH_TINHTRANGHOATDONG = N'Bình thường'
or CH_TINHTRANGHOATDONG = N'Tạm nghỉ' or CH_TINHTRANGHOATDONG = N'Đang bận' or CH_TINHTRANGHOATDONG = N'Đóng cửa')

-- tên các món ăn không được trùng nhau
create trigger tg_checkTenMonAn
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

-- số điện thoại của các đối tác phải khác nhau
create trigger tg_checkSDTDoiTac
on DOITAC
for insert,update
as
begin
	if exists (select *
				from inserted i ,DOITAC dt
				where i.DT_SDT = dt.DT_SDT and i.DT_MA != dt.DT_MA)
	begin
		raiserror(N'số điện thoại của các đối tác phải khác nhau',16,1)
		rollback
	end
end
drop trigger tg_checkSDTDoiTac

-- số điện thoại của các nhân viên phải khác nhau
create trigger tg_checkSDTNhanVien
on NHANVIEN
for insert,update
as
begin
	if exists (select *
				from inserted i ,NHANVIEN nv
				where i.NV_SDT = nv.NV_SDT and i.NV_MA != nv.NV_MA)
	begin
		raiserror(N'số điện thoại của các nhân viên phải khác nhau',16,1)
		rollback
	end
end

--tình trạng của hợp đồng là còn hiệu lực và hết hết hiệu lực
alter table HOPDONG add constraint check_TinhTrangHopDong 
check (HD_TINHTRANG = N'Hiệu lực' or HD_TINHTRANG = N'Hết hiệu lực')

--tình trạng đơn đạt hàng phải là đang xác thực hoặc chưa xác thực
alter table DONHANG add constraint check_TinhTrangDonHang
check (DH_TINHTRANG = N'Đã xác thực' or DH_TINHTRANG = N'Chưa xác thực')

--tình trạng các món ăn phải là có bán ,hết hàng hôm nay ,tạm ngừng, ngừng bán
alter table MONAN add constraint check_TinhTrangMonAn
check (MAN_TINHTRANG = N'Có bán' or MAN_TINHTRANG = N'Hết hàng hôm ngay' 
or MAN_TINHTRANG = N'Tạm ngừng' or MAN_TINHTRANG = N'Ngừng bán')

--tình trạng  giao hàng là đã nhận đơn hàng hoặc chưa nhận đơn hàng
alter table TINHTRANGGIAOHANG add constraint check_ChiTietGiaoHang 
check (TTGH_TINHTRANG = N'Đã nhận đơn hàng'or TTGH_TINHTRANG = N'chưa nhận đơn hàng')

--mỗi đối tác chỉ dùng một stk cho hợp đồng
alter table HOPDONG add unique (HD_STK)

-- phí tháng của PHIHOAHONG phải từ 1->12
alter table PHIHOAHONG add constraint check_PhiThangHoaHong 
check (PHH_PHITHANG >=1 and PHH_PHITHANG <= 12)

--số điện thoại của khách hàng không được trùng nhau
alter table KHACHHANG add unique (KH_SDT)

--mail của khách hàng không được trùng nhau
alter table KHACHHANG add unique (KH_MAIL)

--số điện thoại của tài xế không được trùng nhau
alter table TAIXE add unique (TX_SDT)

--số CMND của tài xế không được trùng nhau
alter table TAIXE add unique (TX_CMND)

--biển số xe của các tài xế không được trùng nhau
alter table TAIXE add unique (TX_BIENSOXE)

--stk của các tài xế không được trùng nhau
alter table TAIXE add unique (TX_STK)

--phương thức thanh toán của đơn đặt hàng là thanh toán online hoặc thanh toán khi nhận hàng
alter table DONHANG add constraint check_PhuongThucThanhToan
check(DH_PHUONGTHUCTHANHTOAN = N'Thanh toán online' or DH_PHUONGTHUCTHANHTOAN = N'Thanh toán khi nhận hàng')

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

--giới tính của Khách hàng phải là Nam hoặc Nữ
alter table KHACHHANG add constraint check_PhaiKhachHang check(KH_GIOITINH = N'Nam' or KH_GIOITINH = N'Nữ')

--phí hoa hồng bằng 10% doanh thu
create trigger tg_PhiHoaHong
on PHIHOAHONG
for insert,update
as
if update(PHH_TONGTIEN)
begin
	
	update PHIHOAHONG
	set PHH_TONGTIEN = (select sum(dh.DH_TONGTIEN)*0,1
						from DONHANG dh
						where PHIHOAHONG.DH_MA = dh.DH_MA and PHIHOAHONG.PHH_PHITHANG = month(dh.DH_NGAYDAT))	
	where exists (select* 
					from inserted i
					where i.DH_MA = PHIHOAHONG.DH_MA and i.NV_MA = PHIHOAHONG.NV_MA)
end

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


--tổng tiền của một đơn hàng bằng tổng giá tất cả các món trong chi tiết  đơn hàng
create trigger tg_TongTienDonHang
on DONHANG
for insert ,update
as
begin

	update DONHANG
	set DH_TONGTIEN =  (select sum(ctdh.CTDH_SOLUONG*ctdh.CTDH_GIATIEN)
						from CHITIETDONHANG ctdh
						where ctdh.DH_MA = DONHANG.DH_MA)
	where exists (select *
					from inserted i
					where i.DH_MA = i.DH_MA)
end

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