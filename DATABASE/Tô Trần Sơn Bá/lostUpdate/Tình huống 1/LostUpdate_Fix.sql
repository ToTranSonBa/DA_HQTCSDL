-- tình huống xung đột 1
USE DOAN_HQTCSDL
GO

create 
--alter 
proc pr_XacNhanDonHang
	@dh_ma char(10)
as
set transaction isolation LEVEL SERIALIZABLE
begin tran
	begin try
		if not exists (select * from DONHANG with(xlock, TABLOCK) where DH_MA = @dh_ma)
		begin 
			raiserror('Don hang khong ton tai', 16, 1)
			rollback
		end		
		if not exists (select * from DONHANG with(xlock, TABLOCK) where DH_MA = @dh_ma and DH_TINHTRANG like N'Chưa xác nhân')
		begin
			raiserror('don hang khong the xac nhan', 16, 1)
			rollback
		end
		
		WAITFOR DELAY '00:00:20'
		update DONHANG 
		set DH_TINHTRANG = N'Đã xác nhận'
		where DH_MA = @dh_ma and DH_TINHTRANG like N'Chưa xác nhân'
	end try
	begin catch
		raiserror(N'xác nhận đơn hàng thất bại', 16, 1)
		rollback
	end catch
	print N'xác nhân đơn hàng thành công'
commit tran
go

create 
--alter 
proc pr_HuyDonHang
	@dh_ma char(10)
as
set transaction isolation LEVEL SERIALIZABLE
begin tran
	begin try
		if not exists (select * from DONHANG where DH_MA = @dh_ma)
		begin 
			raiserror('Don hang khong ton tai', 16, 1)
			rollback
		end
		if not exists (select * from DONHANG with(rowlock) where DH_MA = @dh_ma and DH_TINHTRANG like N'Chưa xác nhân')
		begin
			raiserror('don hang khong the xac nhan', 16, 1)
			rollback
		end

		update DONHANG with(rowlock)
		set DH_TINHTRANG = N'Đã hủy'
		where DH_MA = @dh_ma and DH_TINHTRANG like N'Chưa xác nhân'
	end try
	begin catch
		raiserror(N'xác nhận đơn hàng thất bại', 16, 1)
		rollback
	end catch
commit tran
go
