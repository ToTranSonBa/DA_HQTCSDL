
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
		values (@man_ma, @td_ma, @cn_ma, @ch_ma, @man_ten, @man_mieuta, @man_tinhtrang, @man_gia)
		waitfor delay '00:00:10'
	end try
	begin catch
			raiserror('khong them duoc mon an', 16, 1)
			rollback tran
			return
	end catch
	print 'them mon an thanh cong'
commit tran
go

create proc sp_DanSachMonAnKhachHangTimKiem
	@makh char(10),
	@tenmonan nvarchar(10)
as
set transaction isolation level read committed
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