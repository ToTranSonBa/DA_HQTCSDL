use DOAN_HQTCSDL
go

--Thêm thông tin tài xế
CREATE
--ALTER
PROC sp_themthongtintaixe2
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
SET TRANSACTION ISOLATION 
LEVEL SERIALIZABLE
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
	set @ma = 'TX_' + cast(@stt as char(10))
	--Insert
	INSERT INTO dbo.TAIXE
	(
	    TX_MA,
	    TX_TEN,
	    TX_CMND,
	    TX_SDT,
	    TX_BIENSOXE,
	    TX_STK,
	    TX_NGANHANG,
	    TX_GIOITINH,
	    DC_MATINH,
	    DC_MAHUYEN,
	    DC_MAXA
	)
	VALUES
	(   @ma,   -- TX_MA - char(10)
	    @ten, -- TX_TEN - nvarchar(100)
	    @cmnd,   -- TX_CMND - char(20)
	    @sdt, -- TX_SDT - char(10)
	    @bien_so_xe,   -- TX_BIENSOXE - char(20)
	    @stk,   -- TX_STK - char(20)
	    @ngan_hang, -- TX_NGANHANG - nvarchar(100)
	    @gioi_tinh, -- TX_GIOITINH - nvarchar(10)
	    @ma_tinh, -- DC_MATINH - char(10)
	    @ma_huyen, -- DC_MAHUYEN - char(10)
	    @ma_xa  -- DC_MAXA - char(10)
	    )
	print 'Thêm thành công'
commit transaction
go

--Thêm thông tin tài xế
CREATE
--ALTER
PROC sp_themthongtintaixe
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
SET TRANSACTION ISOLATION 
LEVEL SERIALIZABLE
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
	set @ma = 'TX_' + cast(@stt as char(10))
	--Insert
	INSERT INTO dbo.TAIXE
	(
	    TX_MA,
	    TX_TEN,
	    TX_CMND,
	    TX_SDT,
	    TX_BIENSOXE,
	    TX_STK,
	    TX_NGANHANG,
	    TX_GIOITINH,
	    DC_MATINH,
	    DC_MAHUYEN,
	    DC_MAXA
	)
	VALUES
	(   @ma,   -- TX_MA - char(10)
	    @ten, -- TX_TEN - nvarchar(100)
	    @cmnd,   -- TX_CMND - char(20)
	    @sdt, -- TX_SDT - char(10)
	    @bien_so_xe,   -- TX_BIENSOXE - char(20)
	    @stk,   -- TX_STK - char(20)
	    @ngan_hang, -- TX_NGANHANG - nvarchar(100)
	    @gioi_tinh, -- TX_GIOITINH - nvarchar(10)
	    @ma_tinh, -- DC_MATINH - char(10)
	    @ma_huyen, -- DC_MAHUYEN - char(10)
	    @ma_xa  -- DC_MAXA - char(10)
	    )
	print 'Thêm thành công'
commit transaction
go
