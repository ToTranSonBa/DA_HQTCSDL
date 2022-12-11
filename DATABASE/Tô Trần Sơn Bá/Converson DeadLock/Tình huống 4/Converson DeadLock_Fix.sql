USE DOAN_HQTCSDL
GO
create 
--alter
proc pr_TXNhanDonHang
	@dh_ma char(10),
	@tx_ma char(10)
as
set transaction isolation level  Serializable 
begin tran
	begin try
		if not exists (select * from DONHANG with(xlock, tablock) where DH_MA = @dh_ma and DH_TINHTRANG like N'Đã xác thực')
		begin 
			raiserror('Don hang khong ton tai hoac chua xac nhan', 16,1)
			rollback tran
		end
		
		declare @ch_maxa char(10), @ch_mahuyen char(10), @ch_matinh char(10)
		select @ch_maxa = cn.DC_MAXA, @ch_mahuyen = cn.DC_MAHUYEN, @ch_matinh = cn.DC_MATINH from CHINHANH cn, DONHANG dh with(tablock)
		where dh.DH_MA = @dh_ma and dh.CH_MA = cn.CH_MA
		WAITFOR DELAY '00:00:10'

		update DONHANG 
		set DH_TINHTRANG = N'Đang vận chuyển'
		where DH_MA = @dh_ma
		
		insert TINHTRANGGIAOHANG
		values (@tx_ma, @dh_ma, N'Đang giao', @ch_matinh, @ch_mahuyen, @ch_maxa)
	end try
	begin catch
		raiserror('xac nhan don hang that bai', 16,1)
		rollback tran
	end catch
commit tran
go

-- 
create 
--alter
proc pr_ThemDonHang		
	@dh_ma char(10),
	@dh_phuongthucthanhtoan nvarchar(100),
	@dh_tongtien money,
	@kh_ma char(10),
	@ch_ma char(10)
as
set transaction isolation level  Serializable 
begin tran
	begin try
		if (@dh_ma is null) 
		begin
			raiserror('Don hang khong hop le', 16, 1)
			rollback
		end
		if (@kh_ma is null) 
		begin
			raiserror('ma khach hang khong hop le', 16, 1)
			rollback
		end

		
		if(@dh_phuongthucthanhtoan is null) and (@dh_tongtien is null) 
		begin 
			raiserror('Don hang khong hop le', 16, 1)
			rollback
		end
		if (@ch_ma is null) 
		begin
			raiserror('ma cua hang khong hop le', 16, 1)
			rollback
		end
		if not exists (select * from KHACHHANG where KH_MA = @kh_ma)
		begin
			raiserror('ma khach hang khong ton tai', 16, 1)
			rollback
		end
		if not exists (select * from CUAHANG where CH_MA = @ch_ma)
		begin
			raiserror('ma cua hang khong ton tai', 16, 1)
			rollback
		end

		if exists (select * from DONHANG  with (tabLock) where DH_MA = @dh_ma)
		begin
			raiserror('Don hang khong hop le', 16, 1)
			rollback
		end
		declare @maxa char(10), @mahuyen char(10), @matinh char(10)
		select @maxa = DC_MAXA, @mahuyen = DC_MAHUYEN, @matinh = DC_MATINH from KHACHHANG  where KH_MA = @kh_ma

		WAITFOR DELAY '00:00:15'
		insert DONHANG  with (xlock, tabLock)
		values (@dh_ma, GETDATE(), @dh_phuongthucthanhtoan, @dh_tongtien, @kh_ma, @ch_ma, N'Chưa xác thực', @matinh, @mahuyen, @maxa)
	end try
	begin catch
		raiserror('dat hang khong thanh cong', 16, 1)
		rollback
	end catch
commit tran
go