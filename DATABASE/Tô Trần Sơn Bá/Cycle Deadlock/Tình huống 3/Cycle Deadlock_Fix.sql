USE DOAN_HQTCSDL
GO

create 
--alter
proc pr_TXNhanDonHang
	@dh_ma char(10),
	@tx_ma char(10)
as
set transaction isolation LEVEL SERIALIZABLE
begin tran
	begin try
		if not exists (select * from DONHANG where DH_MA = @dh_ma and DH_TINHTRANG like N'Đã xác thực')
		begin 
			raiserror('Don hang khong ton tai hoac chua xac nhan', 16,1)
			rollback
		end

		declare @ch_maxa char(10), @ch_mahuyen char(10), @ch_matinh char(10)
		select @ch_maxa = cn.DC_MAXA, @ch_mahuyen = cn.DC_MAHUYEN, @ch_matinh = cn.DC_MATINH from CHINHANH cn, DONHANG dh
		where dh.DH_MA = @dh_ma and dh.CH_MA = cn.CH_MA

		update DONHANG with (TabLockX) 
		set DH_TINHTRANG = N'Đang vận chuyển'
		where DH_MA = @dh_ma
		WAITFOR DELAY '00:00:20'
		
		insert TINHTRANGGIAOHANG with (TabLockX)
		values (@tx_ma, @dh_ma, N'Đang giao', @ch_matinh, @ch_mahuyen, @ch_maxa)
	end try
	begin catch
		raiserror('xac nhan don hang that bai', 16,1)
		rollback
	end catch
commit tran
go


create 
--alter
proc pr_TXHoanThanhDonHang
	@dh_ma char(10),
	@tx_ma char(10)
as
set transaction isolation level Read Committed
begin tran
	begin try
		if not exists (select * from DONHANG where DH_MA = @dh_ma and DH_TINHTRANG like N'Đang vận chuyển')
		begin 
			raiserror('Don hang khong ton tai hoac chua xac nhan', 16,1)
			rollback tran
		end

		declare @ch_maxa char(10), @ch_mahuyen char(10), @ch_matinh char(10)
		select @ch_maxa = DC_MAXA, @ch_mahuyen = DC_MAHUYEN, @ch_matinh = DC_MATINH from DONHANG where DH_MA = @dh_ma

		update TINHTRANGGIAOHANG with (TabLockX) 
		set TTGH_TINHTRANG = N'Giao hàng thành công'
		where TX_MA =@tx_ma and DH_MA = @dh_ma
		WAITFOR DELAY '00:00:20'

		update DONHANG with (TabLockX) 
		set DH_TINHTRANG = N'Giao hàng thành công'
		where DH_MA = @dh_ma
	end try
	begin catch
		raiserror('Hoan thanh don hang that bai', 16,1)
		rollback tran
	end catch
commit tran
go