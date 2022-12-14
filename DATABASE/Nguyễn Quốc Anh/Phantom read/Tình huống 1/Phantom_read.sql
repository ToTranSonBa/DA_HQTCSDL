use DOAN_HQTCSDL
go
--Dach sach mon an
create 
--ALTER
PROC sp_DanSachMonAnKhachHangTimKiem
	@makh char(10),
	@tenmonan nvarchar(10)
as
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
