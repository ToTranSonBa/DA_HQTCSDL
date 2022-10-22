DATABASE DOAN_HQTCSDL
GO
---	RÀNG BUỘC TOÀN VẸN

--Số cmnd phải là duy nhất cho đối tác
CREATE TRIGGER tg_checkCMNDDoiTac
ON DOITAC
FOR INSERT ,UPDATE
AS
BEGIN
	IF EXISTS (SELECT *
				FROM INSERTED I ,DOITAC DT
				WHERE  I.DT_CMND = DT.DT_CMND AND I.DT_MA !=DT.DT_MA )
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
				from inserted i, HOPDONG hd,HOSODANGKY hsdk,DOITAC dt
				where hd.HD_MA = hsdk.HD_MA and hsdk.HSDK_NGUOIDAIDIEN = dt.DT_MA
				and dt.DT_MA =i.DT_MA and i.PHH_NGAYNOP < hd.HD_NGAYLAP)
	begin
		raiserror(N'ngày nộp phí hoa hồng phải lớn hơn ngày ngày lập hợp đồng',16,1)
		rollback
	end
end

--ngày sinh của đối tác phải nhỏ hơn ngày lập hợp đồng
create trigger tg_checkNamSinhDoiTac
on DOITAC
for insert,update
as
begin
	if exists (select *
				from inserted i ,HOPDONG hd, HOSODANGKY hsdk
				where hd.HD_MA =hsdk.HD_MA and hsdk.HSDK_NGUOIDAIDIEN = i.DT_MA
				and i.DT_NGAYSINH >hd.HD_NGAYLAP)
	begin
		raiserror(N'ngày sinh của đối tác nhập sai',16,1)
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
				where hd.HD_MA =hsdk.HD_MA and hsdk.HSDK_NVDK = i.NV_MA
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
check (DH_TINHTRANG = N'Đang xác thực' or DH_TINHTRANG = N'Chưa xác thực')

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
on TINHTRANGGIAOHANG
for insert,update
as
begin
	if exists (select *
				from inserted i ,KHACHHANG kh ,DONHANG dh 
				where kh.KH_MA = dh.KH_MA and i.KH_MA = kh.KH_MA
				and dh.DH_TONGTIEN <= i.TTGH_PHIVANCHUYEN)
	begin
		raiserror(N'phí vận chuyển không được lớn hơn tổng tiền của đơn hàng',16,1)
		rollback
	end
end


