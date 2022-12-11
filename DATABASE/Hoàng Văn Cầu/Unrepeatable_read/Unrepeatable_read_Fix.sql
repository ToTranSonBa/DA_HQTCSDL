USE DOAN_HQTCSDL
GO
--
-- cap nhat mon an
CREATE 
--alter
PROC PROC_CAPNHATMONAN_DT
	@man_ma char(10),
	@ch_ma char(10),
	@cn_ma char(10),
	@td_ma char(10),
	@man_ten nvarchar(50),
	@man_mieuta nvarchar(100),
	@man_tinhtrang nvarchar(50),
	@man_gia money
as
BEGIN TRAN
SET TRAN ISOLATION LEVEL SERIALIZABLE
	BEGIN TRY
		IF(@man_ma is null)
		BEGIN 
			RAISERROR(N'Mã món ăn trống', 16, 1)
			ROLLBACK TRAN
			return
		END
		IF(@man_ten is null)
		BEGIN 
			RAISERROR(N'Tên món ăn trống', 16, 1)
			ROLLBACK TRAN
			return
		END
		IF(@td_ma is null)
		BEGIN 
			RAISERROR(N'Mã thực đơn trống', 16, 1)
			ROLLBACK TRAN
			return
		END
		IF(@ch_ma is null)
		BEGIN 
			RAISERROR(N'Mã cửa hàng trống', 16, 1)
			ROLLBACK TRAN
			return
		END
		IF(@cn_ma is null)
		BEGIN 
			RAISERROR(N'Mã chi nhánh trống', 16, 1)
			ROLLBACK TRAN
			return
		END
		IF(@man_gia is null)
		BEGIN 
			RAISERROR(N'Giá món ăn trống', 16, 1)
			ROLLBACK TRAN
			return
		END
		IF(@man_tinhtrang is null)
		BEGIN 
			RAISERROR(N'Tình trạng món ăn trống', 16, 1)
			ROLLBACK TRAN
			return
		END

		--kiểm tra của hàng tồn tại
		IF not exists (SELECT *
						FROM CUAHANG ch
						WHERE ch.CH_MA = @CH_MA)
		BEGIN
			print N'cửa hàng ' + @CH_MA +N'không tồn tại'
			ROLLBACK TRAN
		END
		--kiểm tra thực đơn tồn tại
		IF not exists (SELECT *
						FROM THUCDON td
						WHERE td.TD_MA = @TD_MA)
		BEGIN
			print N'thực đơn ' + @CH_MA +N'không tồn tại'
			ROLLBACK TRAN
		END
		--kiểm tra chi nhánh tồn tại
		IF not exists (SELECT *
						FROM CHINHANH cn
						WHERE cn.CN_MA = @CN_MA)
		BEGIN
			print N'chi nhánh ' + @CH_MA +N'không tồn tại'
			ROLLBACK TRAN
		END

		-- ten mon an khong duoc trung
		IF exists (SELECT * FROM MONAN WHERE @man_ma = MAN_MA and @man_ten = MAN_TEN)
		BEGIN
			RAISERROR(N'Tên món ăn đã tồn tại', 16, 1)
			ROLLBACK TRAN
			return
		END
		--WAITFOR DELAY '00:00:10'
		update MONAN
		set MAN_TEN = @man_ten, MAN_MIEUTA = @man_mieuta, MAN_TINHTRANG = @man_tinhtrang, MAN_GIA = @man_gia
		WHERE MAN_MA = @man_ma and CH_MA = @ch_ma and TD_MA = @td_ma and CN_MA = @cn_ma
	
	END TRY
	BEGIN CATCH
			RAISERROR(N'Không cập nhật được món ăn', 16, 1)
			ROLLBACK TRAN
			return
	END CATCH
	
	-- cap nhat
	print N'Cập nhật món ăn thành công'
COMMIT TRAN
GO

-- Xem chi tiết món ăn
CREATE 
	--ALTER
PROC PROC_XEMCHITIETSANPHAM_KH
	@MA_MONAN CHAR(10),
	@MA_CUAHANG CHAR(10),
	@MA_CHINHANH CHAR(10),
	@MA_THUCDON CHAR(10)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL SERIALIZABLE
	--BEGIN TRY
	BEGIN  TRY
		IF(@MA_MONAN is null)
		BEGIN 
			RAISERROR(N'Mã món ăn trống', 16, 1)
			ROLLBACK TRAN
			RETURN
		END
		IF(@MA_THUCDON is null)
		BEGIN 
			RAISERROR(N'Mã thực đơn trống', 16, 1)
			ROLLBACK TRAN
			RETURN
		END
		IF(@MA_CUAHANG is null)
		BEGIN 
			RAISERROR(N'Mã cửa hàng trống', 16, 1)
			ROLLBACK TRAN
			RETURN
		END
		IF(@MA_CHINHANH is null)
		BEGIN 
			RAISERROR(N'Mã chi nhánh trống', 16, 1)
			ROLLBACK TRAN
			RETURN
		END
		IF not exists (SELECT * FROM dbo.MONAN WHERE MAN_MA = @MA_MONAN AND TD_MA = @MA_THUCDON AND CN_MA = @MA_CHINHANH AND CH_MA = @MA_CUAHANG)
			BEGIN
				RAISERROR(N'Món ăn không tồn tại', 16, 1)
				ROLLBACK TRAN
				RETURN
			END	
		WAITFOR DELAY '00:00:10'
		SELECT * FROM dbo.MONAN WHERE MAN_MA = @MA_MONAN AND TD_MA = @MA_THUCDON AND CN_MA = @MA_CHINHANH AND CH_MA = @MA_CUAHANG
	END TRY
	-- BEGIN CATCH
	BEGIN CATCH
		RAISERROR(N'Lỗi!', 16, 1)
		ROLLBACK TRAN
		RETURN
	END CATCH
COMMIT TRAN
go

--- Thêm món ăn vào đơn hàng
CREATE 
--alter
PROC sp_ThemVaoGioHang1 
	@MAN_MA CHAR(10),
	@TD_MA CHAR(10),
	@CN_MA CHAR(10),
	@CH_MA CHAR(10),
	@KH_MA CHAR(10),
	@SOLUONG INT,
	@NOTES NVARCHAR(100)
AS
BEGIN TRANSACTION
SET TRAN ISOLATION LEVEL SERIALIZABLE
	BEGIN TRY
		IF NOT EXISTS(SELECT * FROM dbo.KHACHHANG WHERE KH_MA = @KH_MA)
		BEGIN 
			PRINT N'KHACH HANG KHONG TON TAI'
			ROLLBACK
		END
		IF NOT EXISTS (SELECT * FROM dbo.MONAN  WHERE MAN_MA = @MAN_MA AND TD_MA = @TD_MA AND CN_MA = @CN_MA AND CH_MA = @CH_MA)
		BEGIN 
			PRINT N'MON AN KHONG TON TAI'
			ROLLBACK
		END 
		WAITFOR DELAY '00:00:10'
		INSERT INTO dbo.GIOHANG
		(
		    MAN_MA,
		    TD_MA,
		    CN_MA,
		    CH_MA,
		    KH_MA,
		    SOLUONG,
		    NOTES
		)
		VALUES
		(   @MAN_MA,
			@TD_MA,
			@CN_MA,
			@CH_MA,
			@KH_MA,
			@SOLUONG ,
			@NOTES
		    )
	END TRY
	BEGIN CATCH
		PRINT N'LOI INSERT'
		ROLLBACK
	END CATCH
COMMIT TRANSACTION
GO

-- XOÁ MÓN ĂN
create 
--alter
proc PROC_XOAMONAN_DT
	@man_ma char(10),
	@ch_ma char(10),
	@cn_ma char(10),
	@td_ma char(10)
as
begin TRAN
SET TRAN ISOLATION LEVEL SERIALIZABLE
	begin try
		IF(@MAN_MA is null)
			BEGIN 
				RAISERROR(N'Mã món ăn trống', 16, 1)
				ROLLBACK TRAN
				RETURN
			END
		IF(@TD_MA is null)
			BEGIN 
				RAISERROR(N'Mã thực đơn trống', 16, 1)
				ROLLBACK TRAN
				RETURN
			END
		IF(@CH_MA is null)
			BEGIN 
				RAISERROR(N'Mã cửa hàng trống', 16, 1)
				ROLLBACK TRAN
				RETURN
			END
		IF(@CN_MA is null)
			BEGIN 
				RAISERROR(N'Mã chi nhánh trống', 16, 1)
				ROLLBACK TRAN
				RETURN
			END
		--kiểm tra cửa hàng tồn tại
		IF not exists (SELECT * FROM CUAHANG ch	WHERE ch.CH_MA = @ch_ma)
			BEGIN
				print N'cửa hàng ' + @ch_ma +N'không tồn tại'
				ROLLBACK TRAN
			END

		--kiểm tra món ăn tồn tại
		IF not exists (SELECT * FROM MONAN ma WHERE ma.MAN_MA = @man_ma)
			BEGIN
				print N'món ăn ' + @man_ma +N'không tồn tại'
				ROLLBACK TRAN
			END
		--kiểm tra thực đơn tồn tại
		IF not exists (SELECT * FROM THUCDON td WHERE td.TD_MA = @td_ma)
			BEGIN
				print N'thực đơn ' + @td_ma +N'không tồn tại'
				ROLLBACK TRAN
			END
		--kiểm tra chi nhánh tồn tại
		IF not exists (SELECT * FROM CHINHANH cn WHERE cn.CN_MA = @cn_ma)
			BEGIN
				print N'chi nhánh ' + @cn_ma +N'không tồn tại'
				ROLLBACK TRAN
			END
			DELETE FROM MONAN
			WHERE MAN_MA = @man_ma and CH_MA = @ch_ma and TD_MA = @td_ma and CN_MA = @cn_ma 
			
	END TRY
	BEGIN CATCH
		RAISERROR('khong cap nhat duoc mon an', 16, 1)
		ROLLBACK TRAN
		RETURN
	END CATCH
	PRINT 'xoa thanh cong'
commit tran
go