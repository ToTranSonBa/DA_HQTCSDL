use DOAN_HQTCSDL
go

--theo doi don hang theo trang thai
create 
--alter
proc pr_theodoidanhsachdonhang
	@ch_ma char(10),
	@dh_trangthai nvarchar(100)
as
begin transaction
	begin try
		declare c cursor for select DH_MA, DH_NGAYDAT, DH_TONGTIEN, KH_MA, DH_TINHTRANG, DC_MAXA, DC_MAHUYEN, DC_MATINH from DONHANG where CH_MA = @ch_ma and DH_TINHTRANG like @dh_trangthai
		declare @dh_ma char(10), @dh_ngaydat datetime, @dh_tongtien money, @kh_ma char(10), @dh_tinhtrang nvarchar(100), 
		@dc_maxa char(10), @dc_mahuyen char(10), @dc_matinh char(10)
		open c
		declare @i int = 1
		while @@FETCH_STATUS = 0
			begin
				declare @tenkh char(10) 
				(select @tenkh = KH_TEN from KHACHHANG where KH_MA = @kh_ma)

				declare @tenxa nvarchar(100), @tenhuyen nvarchar(100), @tentinh nvarchar(100)
				select @tenxa = DC_TENXA, @tenhuyen = DC_TENHUYEN, @tentinh = DC_TENTINH from DIACHI 
					where DC_MAXA = @dc_maxa and DC_MAHUYEN = @dc_mahuyen and DC_MATINH = @dc_matinh

				print @i + '_' + @dh_ma + '_' + @dh_ngaydat+ '_' + @dh_tongtien + '_' + @kh_ma + '_' + @dh_tinhtrang + '_' + @tenxa + '_' + @tenhuyen + '_' + @tentinh
				fetch next from c into @dh_ma, @dh_ngaydat, @dh_tongtien, @kh_ma, @dh_tinhtrang, @dc_maxa, @dc_mahuyen, @dc_matinh
			end
		close c
		deallocate c
	end try
	begin catch

	end catch
commit transaction
go

-- so sanh don hang theo ngay, thang, nam
create
--alter
proc pr_donhangtheodate
	@date date,
	@ch_ma char(10),
	@dh_trangthai nvarchar(100)
as
begin 
	declare c cursor for select DH_MA, DH_NGAYDAT, DH_TONGTIEN, KH_MA, DH_TINHTRANG, DC_MAXA, DC_MAHUYEN, DC_MATINH from DONHANG
								where CH_MA = @ch_ma and DH_TINHTRANG like @dh_trangthai and  DH_NGAYDAT = @date
	declare @dh_ma char(10), @dh_ngaydat datetime, @dh_tongtien money, @kh_ma char(10), @dh_tinhtrang nvarchar(100), 
	@dc_maxa char(10), @dc_mahuyen char(10), @dc_matinh char(10)
	open c
	declare @i int = 1
	while @@FETCH_STATUS = 0
		begin
			declare @tenkh char(10) 
			(select @tenkh = KH_TEN from KHACHHANG where KH_MA = @kh_ma)

			declare @tenxa nvarchar(100), @tenhuyen nvarchar(100), @tentinh nvarchar(100)
			select @tenxa = DC_TENXA, @tenhuyen = DC_TENHUYEN, @tentinh = DC_TENTINH from DIACHI 
				where DC_MAXA = @dc_maxa and DC_MAHUYEN = @dc_mahuyen and DC_MATINH = @dc_matinh

			print @i + '_' + @dh_ma + '_' + @dh_ngaydat+ '_' + @dh_tongtien + '_' + @kh_ma + '_' + @dh_tinhtrang + '_' + @tenxa + '_' + @tenhuyen + '_' + @tentinh
			fetch next from c into @dh_ma, @dh_ngaydat, @dh_tongtien, @kh_ma, @dh_tinhtrang, @dc_maxa, @dc_mahuyen, @dc_matinh
		end
	close c
	deallocate c
end
go


-- xem doanh thu tung ngay, thang nam
create
--alter
proc pr_doanhthutheodate
	@date date,
	@ch_ma char(10),
	@dh_trangthai nvarchar(100)
as
begin 
	declare c cursor for select DH_MA, DH_NGAYDAT, DH_TONGTIEN from DONHANG
								where CH_MA = @ch_ma and DH_TINHTRANG like @dh_trangthai and  DH_NGAYDAT = @date
	declare @dh_ma char(10), @dh_ngaydat datetime, @dh_tongtien money
	open c
	declare @i int = 1
	while @@FETCH_STATUS = 0
		begin
			print @i + '_' + @dh_ma + '_' + @dh_ngaydat+ '_' + @dh_tongtien
			fetch next from c into @dh_ma, @dh_ngaydat, @dh_tongtien, @kh_ma, @dh_tinhtrang, @dc_maxa, @dc_mahuyen, @dc_matinh
		end

	declare @tongdoanhthu money 
	select @tongdoanhthu = sum(DH_TONGTIEN) from DONHANG 
			where CH_MA = @ch_ma and DH_TINHTRANG like @dh_trangthai and  DH_NGAYDAT = @date
	print 'Tong doanh thu: ' + cast(@tongdoanhthu as char(20))
	close c
	deallocate c
end
go

-- chinh sua thong tin cua hang
create 
--alter
proc pr_updatecuahang 
	@ch_ma char(10),
	@ch_tgmocua time,
	@ch_tgdongcua time,
	@ch_sdt char(10),
	@ch_tinhtranghoatdong nvarchar(100)
as
begin transaction
	begin try
		if(@ch_tgdongcua is null)
		begin
			raiserror('thong tin nhap vao la null', 16, 1)
			rollback transaction
			return
		end
		if(@ch_tgmocua is null)
		begin
			raiserror('thong tin nhap vao la null', 16, 1)
			rollback transaction
			return
		end
		if(@ch_sdt is null)
		begin
			raiserror('thong tin nhap vao la null', 16, 1)
			rollback transaction
			return
		end
		if(@ch_tinhtranghoatdong is null)
		begin
			raiserror('thong tin nhap vao la null', 16, 1)
			rollback transaction
			return
		end
		update CUAHANG
		set CH_TGDONGCUA = @ch_tgdongcua, CH_TGMOCUA = @ch_tgmocua, CH_SDT = @ch_sdt, CH_TINHTRANGHOATDONG = @ch_tinhtranghoatdong
		where CH_MA = @ch_ma
	end try
	begin catch
		raiserror('khong cap nhat duoc thong tin', 16, 1)
		rollback transaction
		return
	end catch
	print 'update thanh cong'
commit transaction
go

-- thuc don
-- them
create 
--alter
proc pr_themmonan
	@man_ma char(10),
	@ch_ma char(10),
	@td_ma char(10),
	@cn_ma char(10),
	@man_ten nvarchar(50),
	@man_mieuta nvarchar(100),
	@man_tinhtrang nvarchar(50),
	@man_gia money
as
begin tran
	begin try
		if(@man_ma is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		if(@man_ten is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		if(@td_ma is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		if(@ch_ma is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		if(@cn_ma is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		if(@man_gia is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		if(@man_tinhtrang is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		-- ten mon an khong duoc trung
		if exists (select * from MONAN where @man_ma = MAN_MA and @man_ten = MAN_TEN)
		begin
			raiserror('ten mon an da ton tai', 16, 1)
			rollback tran
			return
		end
		-- chen
		insert into MONAN
		values (@man_gia, @td_ma, @cn_ma, @ch_ma, @man_ten, @man_mieuta, @man_tinhtrang, @man_gia)
	end try
	begin catch
			raiserror('khong them duoc mon an', 16, 1)
			rollback tran
			return
	end catch
	print 'them mon an thanh cong'
commit tran
go

-- cap nhat mon an
create 
--alter
proc pr_capnhatmonan
	@man_ma char(10),
	@ch_ma char(10),
	@td_ma char(10),
	@cn_ma char(10),
	@man_ten nvarchar(50),
	@man_mieuta nvarchar(100),
	@man_tinhtrang nvarchar(50),
	@man_gia money
as
begin tran
	begin try
		if(@man_ma is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		if(@man_ten is null)
		begin 
			raiserror('ten mon an la null', 16, 1)
			rollback tran
			return
		end
		if(@td_ma is null)
		begin 
			raiserror('ma thuc don la null', 16, 1)
			rollback tran
			return
		end
		if(@ch_ma is null)
		begin 
			raiserror('ma cua hang la null', 16, 1)
			rollback tran
			return
		end
		if(@cn_ma is null)
		begin 
			raiserror('ma chi nhanh la null', 16, 1)
			rollback tran
			return
		end
		if(@man_gia is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		if(@man_tinhtrang is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		-- ten mon an khong duoc trung
		if exists (select * from MONAN where @man_ma = MAN_MA and @man_ten = MAN_TEN)
		begin
			raiserror('ten mon an da ton tai', 16, 1)
			rollback tran
			return
		end
		-- cap nhat
		update MONAN
		set MAN_TEN = @man_ten, MAN_MIEUTA = @man_mieuta, MAN_TINHTRANG = @man_tinhtrang, MAN_GIA = @man_gia
		where MAN_MA = @man_ma and CH_MA = @ch_ma and TD_MA = @td_ma and CN_MA = @cn_ma
	end try
	begin catch
			raiserror('khong cap nhat duoc mon an', 16, 1)
			rollback tran
			return
	end catch
	print 'cap nhat mon an thanh cong'
commit tran
go

-- xoa mon an
create 
--alter
proc pr_xoamonan
	@man_ma char(10),
	@ch_ma char(10),
	@cn_ma char(10),
	@td_ma char(10)
as
begin tran
	begin try
		if(@man_ma is null)
		begin 
			raiserror('ma mon an la null', 16, 1)
			rollback tran
			return
		end
		if(@td_ma is null)
		begin 
			raiserror('ma thuc don la null', 16, 1)
			rollback tran
			return
		end
		if(@ch_ma is null)
		begin 
			raiserror('ma cua hang la null', 16, 1)
			rollback tran
			return
		end
		if(@cn_ma is null)
		begin 
			raiserror('ma chi nhanh la null', 16, 1)
			rollback tran
			return
		end

		delete from MONAN
		where MAN_MA = @man_ma and CH_MA = @ch_ma and TD_MA = @td_ma and CN_MA = @cn_ma 
	end try
	begin catch
		raiserror('khong cap nhat duoc mon an', 16, 1)
		rollback tran
		return
	end catch
	print 'xoa thanh cong'
commit tran
go

-- don hang
-- doi trang thai don hang: xac nhan hoac huy
create 
--alter
proc pr_capnhattrangthaidh
	@ch_ma char(10),
	@dh_ma char(10),
	@dh_trangthai nvarchar(100)
as
begin tran
	begin try
		if(@ch_ma is null)
		begin 
			raiserror('ma cua hang la null', 16, 1)
			rollback tran
			return
		end
		if(@dh_ma is null)
		begin 
			raiserror('ma don hang la null', 16, 1)
			rollback tran
			return
		end
		if(@dh_trangthai is null)
		begin 
			raiserror('tinh trang don hang la null', 16, 1)
			rollback tran
			return
		end
		update DONHANG
		set DH_TINHTRANG = @dh_trangthai
		where DH_MA = @dh_ma and CH_MA = @ch_ma
	end try
	begin catch
		raiserror(' cap nhat duoc tinh trang don hang that bai', 16, 1)
		rollback tran
		return
	end catch
	print 'cap nhat duoc tinh trang don hang thanh cong'
commit tran
go

-- tinh trang giao hang cua don hang
create
--alter
proc pr_tinhtranggiaohangdh
	@dh_ma char(10)
as
begin tran
	begin try
		if(@dh_ma is null)
		begin 
			raiserror('ma cua hang la null', 16, 1)
			rollback tran
			return
		end
		-- don hang co ton tai
		if not exists (select * from DONHANG where DH_MA = @dh_ma) 
		begin 
			raiserror('don hang khong ton tai', 16, 1)
			rollback tran
			return
		end
		if not exists (select * from TINHTRANGGIAOHANG where DH_MA = @dh_ma) 
		begin 
			raiserror('don hang khong ton tai', 16, 1)
			rollback tran
			return
		end

		declare c cursor for (select TX_MA, TTGH_TINHTRANG, DC_MAXA, DC_MAHUYEN, DC_MATINH from TINHTRANGGIAOHANG where DH_MA = @dh_ma)
		declare @tx_ma char(10), @ttgh_tinhtrang nvarchar(10), @dc_maxa char(10), @dc_mahuyen char(10), @dc_matinh char(10)
		declare @i int = 1
		open c
		fetch next from c into @tx_ma, @ttgh_tinhtrang, @dc_maxa, @dc_mahuyen, @dc_matinh
		while @@FETCH_STATUS = 0
			begin 
				declare @tenxa nvarchar(100), @tenhuyen nvarchar(100), @tentinh nvarchar(100)
				select @tenxa = DC_TENXA, @tenhuyen = DC_TENHUYEN, @tentinh = DC_TENTINH from DIACHI 
					where DC_MAXA = @dc_maxa and DC_MAHUYEN = @dc_mahuyen and DC_MATINH = @dc_matinh

				declare @tentx nvarchar(50), @bienso char(20)
				select @tentx = TX_TEN, @bienso = TX_BIENSOXE from TAIXE where TX_MA = @tx_ma

				print cast(@i as char(10)) + ' - tinh trang: ' + @ttgh_tinhtrang + ' - vi tri: '+ @tenxa + ', ' + @tenhuyen + ', ' + @tentinh
				fetch next from c into @tx_ma, @ttgh_tinhtrang, @dc_maxa, @dc_mahuyen, @dc_matinh
				set @i = @i + 1
			end
		close c
		deallocate c
	end try
	begin catch
		raiserror('khong hien thi duoc tinh trang giao hang', 16, 1)
		rollback tran
		return
	end catch
commit tran
go

-- xem chi tiet don hang
create 
--alter
proc pr_chitietdonhang
	@dh_ma char(10)
as
begin tran
	begin try
		if(@dh_ma is null)
		begin 
			raiserror('ma cua hang la null', 16, 1)
			rollback tran
			return
		end
		-- don hang co ton tai
		if not exists (select * from DONHANG where DH_MA = @dh_ma) 
		begin 
			raiserror('don hang khong ton tai', 16, 1)
			rollback tran
			return
		end

		if not exists (select * from CHITIETDONHANG where DH_MA = @dh_ma) 
		begin 
			raiserror('don hang khong ton tai', 16, 1)
			rollback tran
			return
		end

		declare c cursor for (select MAN_MA, TD_MA, CN_MA, CH_MA, CTDH_SOLUONG, CTDH_GHICHU from CHITIETDONHANG where DH_MA = @dh_ma)
		declare @td_ma char(10), @cn_ma char(10), @ch_ma char(10), @ctdh_soluong int, @ctdh_ghichu char(10), @man_ma char(10)
		fetch next from c into @man_ma, @td_ma, @cn_ma, @ch_ma, @ctdh_soluong, @ctdh_ghichu
		declare @i int = 1
		open c
		while @@FETCH_STATUS = 0
			begin
				declare @man_ten char(10)
				select @man_ten = MAN_TEN from MONAN where MAN_MA = @man_ma and TD_MA = @td_ma and CN_MA = @cn_ma and CH_MA = @ch_ma

				print cast(@i as char(10)) + '- mon an: ' + @man_ten + ' - so luong: ' + cast(@ctdh_soluong as char(10)) + '- ghi chu: ' + @ctdh_ghichu
				fetch next from c into @man_ma, @td_ma, @cn_ma, @ch_ma, @ctdh_soluong, @ctdh_ghichu
				set @i = @i + 1
			end	
		close c
		deallocate c

	end try
	begin catch
		raiserror('khong hien thi duoc chi tiet don hang', 16, 1)
		rollback tran
		return
	end catch
commit tran
go


-- xem thong tin cua hang
create
--alter
proc pr_thongtincuahang
	@dt_ma char(10)
as
begin tran
	begin try
		if(@dt_ma is null)
		begin
			raiserror('ma doi tac la null', 16, 1)
			rollback tran
			return
		end
		declare c cursor for (select HSDK_EMAIL, HSDK_TENQUAN, HSDK_THANHPHO, HSDK_QUAN, HSDK_SLDONHANGTOITHIEU, HSDK_LOAIAMTHUC, HSDK_NGUOIDAIDIEN from HOSODANGKY where DT_MA = @dt_ma)
		declare @email char(50), @tenquan nvarchar(100), @thanhpho nvarchar(50), @quan nvarchar(50), @sltoithieu int, @loaiamthuc nvarchar(500), @nguoidaidien nvarchar(10)
		open c
		fetch next from c into @email, @tenquan, @thanhpho, @quan, @sltoithieu, @loaiamthuc, @nguoidaidien
		while @@FETCH_STATUS = 0
			begin 
				print @email + ' - ' + @tenquan + ' - ' + @thanhpho + ' - ' + @quan + ' - ' +  @sltoithieu + ' - ' + @loaiamthuc + ' - ' + @nguoidaidien
				fetch next from c into @email, @tenquan, @thanhpho, @quan, @sltoithieu, @loaiamthuc, @nguoidaidien
			end
		close c
		deallocate c
	end try
	begin catch
		raiserror('khong hien thi duoc thong tin khach hang', 16, 1)
		rollback tran
		return
	end catch
commit tran
go

select * from HOSODANGKY