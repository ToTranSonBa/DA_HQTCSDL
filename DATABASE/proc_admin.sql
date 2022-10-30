USE DOAN_HQTCSDL
GO

create
--alter
proc pr_themvaorole
	@ma_person char(10), -- ma nv, tai xe khach hang, admim
	@role char(20) -- ten role
as
begin transaction
	begin try
		--ma khach hang khac null
		if(@ma_person is null)
		begin
			RAISERROR('Ma khong hop le',16,1)
			rollback transaction
			return
		end
		-- ma khach hang co ton tai
		if(not exists (select * from dbo.KHACHHANG kh where kh.KH_MA = @ma_person))
		begin
			RAISERROR('Ma khong co trong du lieu',16,1)
			rollback transaction
			return
		end
		exec sp_addsrvrolemember @ma_person, @role
	end try
	begin catch
		RAISERROR('loi cap quyen',16,1)
		rollback transaction
		return
	end  catch

commit transaction
go

-- xoa khoi cac role
create
--alter
proc pr_xoakhoirole
	@ma_person char(10),
	@role char(20)
as
begin transaction
	begin try
		--ma khach hang khac null
		if(@ma_person is null)
		begin
			RAISERROR('Ma khong hop le',16,1)
			rollback transaction
			return
		end
		-- ma khach hang co ton tai
		if(not exists (select * from dbo.KHACHHANG kh where kh.KH_MA = @ma_person))
		begin
			RAISERROR('Ma khong hop le',16,1)
			rollback transaction
			return
		end
		exec sp_dropsrvrolemember @ma_person, @role
	end try
	begin catch
		RAISERROR('loi huy quyen role',16,1)
		rollback transaction
		return
	end  catch
commit transaction
go


-----------------------------------------------DANG BI LOI -  
-- them tai khoan khach hang
create 
--alter
proc pr_taoUSER
	@user char(50),
	@password char(50)
as
begin transaction
	begin try
		-- user khac null
		if(@user is null)
		begin
			RAISERROR('user khong hop le',16,1)
			rollback transaction
			return
		end

		-- password khac null
		if(@password is null)
		begin
			RAISERROR('password khong hop le',16,1)
			rollback transaction
			return
		end


	end try
	begin catch 
		RAISERROR('tao login that bai',16,1)
		rollback transaction
		return
	end catch
commit transaction
go

