use DOAN_HQTCSDL
go

create proc sp_DanSachMonAnKhachHangTimKiem
	@makh char(10),
	@tenmonan nvarchar(10)
as
SET TRANSACTION ISOLATION 
LEVEL SERIALIZABLE
begin tran
	begin try
		if not exists (select * from KHACHHANG kh where kh.KH_MA = @makh)
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
		WAITFOR DELAY '00:00:10'
		select *
		from MONAN mn
		where mn.MAN_TEN = @tenmonan
	end try
	begin catch
		print N'lỗi hệ thống'
		rollback tran
	end catch
commit tran
go
-- Cập nhật món ăn
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
SET TRANSACTION ISOLATION 
LEVEL SERIALIZABLE
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
