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

drop trigger tg_checkCMND

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
	END
END

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
		RAISERROR(N'các món ăn phải có tên khác nahu',16,1)
		ROLLBACK
	END
END
