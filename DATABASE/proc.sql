use DOAN_HQTCSDL
go

--tạo role và phân quyền cho khách hàng
create role KhachHang
go

grant insert, Update
on KHACHHANG
to KhachHang
go

grant  insert,Update
on DONHANG
to KhachHang
go

grant insert ,Update
on CHITIETDONHANG
to KhachHang

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
