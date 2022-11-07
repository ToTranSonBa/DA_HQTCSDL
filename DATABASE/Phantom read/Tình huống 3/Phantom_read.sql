use DOAN_HQTCSDL
go

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
	WAITFOR DELAY '00:00:10'
	--Insert
	insert into TAIXE values(@ma,@ten, @cmnd, @sdt, @bien_so_xe, @stk, @ngan_hang,@gioi_tinh,@ma_tinh,@ma_huyen,@ma_xa)
	print 'Thêm thành công'
commit transaction
go

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
