use DOAN_HQTCSDL
go

--tạo role và phân quyền cho khách hàng
create role KhachHang
go

grant insert, Update
on KHACHHANG
to KhachHang
go

grant  insert,delete
on DONHANG
to KhachHang
go

grant insert 
on CHITIETDONHANG
to KhachHang

grant select
on DOITAC
to KhachHang

grant select
on THUCDON
to KhachHang

grant select
on MONAN
to KhachHang

grant select
on TINHTRANGDONHANG
to KhachHang

--Tạo role và phân quyền cho tài xế
create role TaiXe
go

Grant Insert, Update
on TAIXE
to TaiXe
go

Grant Select, Insert, Update
on TINHTRANGDONHANG
to TaiXe
go

Grant Select
on DONHANG
to TaiXe
go

--Chức năng của các role
--Khách hàng
--thêm thông tin cho khách hàng mới
create proc sp_ThemThongTinKhachHang
	@tenkh nvarchar(10),
	@sdtkh char(10),
	@mailkh char(10),
	@gioitinhkh nvarchar(10),
	@dc_matinh char(10),
	@dc_mahuyen char(10),
	@dc_maxa char(10)
as
begin tran
	begin try
		declare @stt int
		declare @makh char(10)
		set @stt = (select count(kh.KH_MA) + 1
					from KHACHHANG kh)
		set @makh = 'kh_' + cast(@stt as char(10))

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
		
		insert KHACHHANG
		values (@makh,@tenkh,@sdtkh,@mailkh,@gioitinhkh,@dc_matinh,@dc_mahuyen,@dc_maxa)
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit tran
go
--cập nhật thông tin cho khách hàng
create proc sp_CapNhatThongTinKhachHang
	@makh char(10),
	@tenkh nvarchar(10),
	@sdtkh char(10),
	@mailkh char(10),
	@gioitinhkh nvarchar(10),
	@dc_matinh char(10),
	@dc_mahuyen char(10),
	@dc_maxa char(10)
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

--thêm chi tiets đơn đặt hàng
create proc sp_ThemChiTietDonHang
	@DH_MA CHAR(10),
	@MAN_MA CHAR(10),
	@TD_MA CHAR(10),
	@CN_MA CHAR(10), 
	@CH_MA CHAR(10),
	@CTDH_SOLUONG INT,
	@CTDH_GIATIEN MONEY ,
	@CTDH_GHICHU NVARCHAR(100)
as
begin tran
	begin try
		--kiểm tra của hàng tồn tại
		if not exists (select *
						from CUAHANG ch
						where ch.CH_MA = @CH_MA)
		begin
			print N'cửa hàng ' + @CH_MA +N'không tồn tại'
			rollback tran
		end

		--kiểm tra món ăn tồn tại
		if not exists (select *
						from MONAN ma
						where ma.MAN_MA = @MAN_MA)
		begin
			print N'món ăn ' + @CH_MA +N'không tồn tại'
			rollback tran
		end
		--kiểm tra đơn hàng tồn tại
		if not exists (select *
						from DONHANG dh
						where dh.DH_MA = @DH_MA)
		begin
			print N'đơn hàng ' + @CH_MA +N'không tồn tại'
			rollback tran
		end
		--kiểm tra thực đơn tồn tại
		if not exists (select *
						from THUCDON td
						where td.TD_MA = @TD_MA)
		begin
			print N'thực đơn ' + @CH_MA +N'không tồn tại'
			rollback tran
		end
		--kiểm tra chi nhánh tồn tại
		if not exists (select *
						from CHINHANH cn
						where cn.CN_MA = @CN_MA)
		begin
			print N'chi nhánh ' + @CH_MA +N'không tồn tại'
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

--thêm đơn hàng mà khách hàng đặt
create proc sp_KhachHangDatHang
	@madh char(10),
	@ngaydat datetime,
	@phuongthucthanhtoan nvarchar(100),
	@makh char(10),
	@mach char(10),
	@phivanchuyen money,
	@tinhtrang nvarchar(50),
	@dc_matinh char(10),
	@dc_mahuyen char(10),
	@dc_maxa char(10)
as
begin tran
	begin try
		set @madh = 'DH_' + (select count(dh.DH_MA) + 1		
							from DONHANG dh)
		set @ngaydat = getdate()
		--kiểm tra khách hàng tồn tại
		if not exists (select *
						from KHACHHANG kh
						where kh.KH_MA = @makh)
		begin
			print N'khách hàng ' + @makh +N'không tồn tại'
			rollback tran
		end
		--kiểm tra của hàng tồn tại
		if not exists (select *
						from CUAHANG ch
						where ch.CH_MA = @mach)
		begin
			print N'cửa hàng ' + @mach +N'không tồn tại'
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

		insert DONHANG 
		values(@madh,@ngaydat,@phuongthucthanhtoan,null,@makh,@mach,@phivanchuyen,@tinhtrang,@dc_matinh,@dc_mahuyen,@dc_maxa)
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit tran

create proc sp_DanSachMonAnKhachHangTimKiem
	@makh char(10),
	@tenmonan nvarchar(10)
as
begin tran
	begin try
		if not exists (select * 
						from KHACHHANG kh
						where kh.KH_MA = @makh)
		begin
			print N'Khách hàng ' + @makh + N' không tồn tại'
			rollback tran
		end
		
		if not exists (select*
						from MONAN mn
						where  mn.MAN_TEN =@tenmonan)
		begin
			print N'Món ăn ' + @tenmonan + N' không tồn tại'
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
commit tran
-- in danh sách đối tác cho khách hàng
create proc sp_DanhSachDoiTacChoKhachHang
	@makh char(10)
as
	begin tran
	begin try
		if not exists (select * 
						from KHACHHANG kh
						where kh.KH_MA = @makh)
		begin
			print N'Khách hàng ' + @makh + N' không tồn tại'
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
--in thực đơn theo đối tác mà khách hàng chọn
create proc sp_ThucDonTheoDoiTac
	@madt char(10),
	@makh char(10)
as
begin tran
	begin try
		if not exists (select * 
						from KHACHHANG kh
						where kh.KH_MA = @makh)
		begin
			print N'Khách hàng ' + @makh + N' không tồn tại'
			rollback tran
		end

		if not exists (select * 
						from DOITAC dt
						where dt.DT_MA = @madt)
		begin
			print N'Đối tác ' + @madt + N' không tồn tại'
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
commit tran
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
			print N'Khách hàng ' + @makh + N' không tồn tại'
			rollback tran
		end

		if not exists (select * 
					from DONHANG dh
					where dh.DH_MA = @madh)
		begin
			print N'Đơn hàng ' + @madh + N' không tồn tại'
			rollback tran
		end

		delete DONHANG
		where DH_MA = @madh and DONHANG.DH_TINHTRANG = N'chưa xác thực'
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit tran
--khách hàng theo dõi quá trình vận chuyển đơn hàng
create proc sp_QuaTrinhVanChuyenChoKhachHang
	@makh char(10),
	@madh char(10)
as
begin tran
	begin try
		if not exists (select * 
						from KHACHHANG kh
						where kh.KH_MA = @makh)
		begin
			print N'Khách hàng ' + @makh + N' không tồn tại'
			rollback tran
		end

		if not exists (select * 
					from DONHANG dh
					where dh.DH_MA = @madh)
		begin
			print N'Đơn hàng ' + @madh + N' không tồn tại'
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
commit tran
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
			print N'Khách hàng ' + @makh + N' không tồn tại'
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
commit tran
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
@ma_tinh char(10),
@ma_huyen char(10),
@ma_xa char(10)
as
begin transaction
	if(@sdt = NULL or @ten = NULL or @cmnd = NULL or @bien_so_xe = NULL)
	begin
		print N'Không được để trống các thông tin quan trọng'
		rollback transaction
		return
	end
	if not exists (select * from DIACHI where DC_MATINH = @ma_tinh)
	begin 
		print N'mã tỉnh ' + @ma_tinh + N' không tồn tại'
		rollback tran
		return
	end
	if not exists (select * from DIACHI where DC_MAHUYEN = @ma_huyen)
	begin 
		print N'mã huyện ' + @ma_huyen + N' không tồn tại'
		rollback tran
		return
	end
	if not exists (select * from DIACHI where DC_MAXA = @ma_xa)
	begin 
		print N'mã xã ' + @ma_xa + N' không tồn tại'
		rollback tran
		return
	end
	declare @stt int
	declare @ma char(10)
	select @stt = count(TX_MA) + 1 from TAIXE
	set @ma = 'tx_' + cast(@stt as char(10))
	--Insert
	insert into TAIXE values(@ma,@ten, @cmnd, @sdt, @bien_so_xe, @stk, @ngan_hang,@gioi_tinh,@ma_tinh,@ma_huyen,@ma_xa)
	print 'Thêm thành công'
commit transaction
go
--Xem thông tin của tài xế
create proc sp_xemthongtintaixe
@ma char(10)
as
begin transaction
	if(@ma = NULL )
	begin
		print N'Không nhận được mã'
		rollback transaction
		return
	end
	if not exists(select * from TAIXE where TX_MA=@ma)
	begin
		print N'Mã tài xế ' + @makh + N' không tồn tại'
		rollback transaction
		return
	end
	--Select
	select * from TAIXE where TX_MA=@ma
commit transaction
go
--Cập nhật thông tin tài xế
create proc sp_capnhatthongtintaixe
@ma char(10),
@ten nvarchar(10),
@cmnd char(20),
@sdt char(10),
@bien_so_xe char(10),
@stk char(20),
@ngan_hang nvarchar(100),
@gioi_tinh nvarchar(10),
@ma_tinh char(10),
@ma_huyen char(10),
@ma_xa char(10)
as
begin transaction
	if(@ma = NULL or @sdt = NULL or @ten = NULL or @cmnd = NULL or @bien_so_xe = NULL)
	begin
		print N'Không được để trống các thông tin quan trọng'
		rollback transaction
		return
	end
	if not exists(select * from TAIXE where TX_MA=@ma)
	begin
		print N'Mã tài xế ' +@ma + N' không tồn tại'
		rollback transaction
		return
	end
	if not exists (select * from DIACHI where DC_MATINH = @ma_tinh)
	begin 
		print N'mã tỉnh ' + @ma_tinh + N' không tồn tại'
		rollback tran
		return
	end
	if not exists (select * from DIACHI where DC_MAHUYEN = @ma_huyen)
	begin 
		print N'mã huyện ' + @ma_huyen + N' không tồn tại'
		rollback tran
		return
	end
	if not exists (select * from DIACHI where DC_MAXA = @ma_xa)
	begin 
		print N'mã xã ' + @ma_xa + N' không tồn tại'
		rollback tran
		return
	end
	--Update
	update TAIXE set
	TX_MA=@ma,
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
	print 'Cập nhật thành công'
commit transaction
go
--Hiển thị ra danh sách đơn hàng chưa được nhận giao
create proc sp_xemdanhsachdonhang
as
begin transaction
	--Select
	select * from TINHTRANGGIAOHANG where TTGH_TINHTRANG=N'chưa xác nhận đơn hàng' and TX_MA=NULL
commit transaction
go
--Xử lý đơn đặt hàng 
create proc sp_xulydonhang
@ma_tx char(10),
@ma_dh char(10),
@tinhtrang nvarchar(50)
as
begin transaction
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
	end
	--Update tình trạng giao hàng
	if(@tinhtrang = N'Đã nhận đơn hàng')
	begin
		update TINHTRANGGIAOHANG set TX_MA=@ma_tx, TTGH_TINHTRANG=@tinhtrang
	end
	else
	begin
		update TINHTRANGGIAOHANG set TX_MA=NULL , TTGH_TINHTRANG=N'chưa nhận đơn hàng'
	end
	print 'Cập nhật tình trạng  thành công'
commit transaction
go
--Những đơn hàng đã nhận để kiểm tra và giao hàng
create proc sp_donhangtaixenhan
@ma_tx char(10)
as
begin transaction
	if(@ma_tx = NULL )
	begin
		print N'Không nhận được mã'
		rollback transaction
		return
	end
	if not exists(select * from TAIXE where TX_MA=@ma_tx)
	begin
		print N'Mã tài xế ' + @ma_tx + N' không tồn tại'
		rollback transaction
		return
	end
	--Select
	select * from TINHTRANGGIAOHANG where TX_MA=@ma_tx and TTGH_TINHTRANG=N'Đã nhận đơn hàng'
commit transaction
go
--Tiền đơn hàng tài xế nhận
create proc sp_tiendonhangtaixenhan
@ma_tx char(10),
@ma_dh char(10),
@money int out
as
begin transaction
	if(@ma_tx = NULL)
	begin
		print N'Không nhận được mã'
		rollback transaction
		return
	end
	if not exists(select * from TAIXE where TX_MA=@ma_tx)
	begin
		print N'Mã tài xế ' + @ma_tx + N' không tồn tại'
		rollback transaction
		return
	end
	--Select
	select @money=DH_TONGTIEN from DONHANG where DH_MA=@ma_dh
commit transaction
go
--Tổng tiền đơn đã giao
create proc sp_tongtien
@ma_tx char(10),
@sum_money int out
as
begin transaction
	if(@ma = NULL )
	begin
		print N'Không nhận được mã'
		rollback transaction
		return
	end
	if not exists(select * from TAIXE where TX_MA=@ma_tx)
	begin
		print N'Mã tài xế ' + @ma_tx + N' không tồn tại'
		rollback transaction
		return
	end
	--Select
	select @sum_money=sum(DH_TONGTIEN) from TINHTRANGGIAOHANG left join DONHANG on TINHTRANGGIAOHANG.DH_MA=DONHANG.DH_MA where TINHTRANGGIAOHANG.TX_MA=@ma_tx and TINHTRANGGIAOHANG.TTGH_TINHTRANG=N'Đã nhận đơn hàng'
commit transaction
go

