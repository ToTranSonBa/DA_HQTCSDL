USE DOAN_HQTCSDL
GO
create 
--alter
proc pr_TXNhanDonHang
	@dh_ma char(10),
	@tx_ma char(10)
as
begin TRAN
SET TRAN ISOLATION LEVEL SERIALIZABLE
	begin try
		if not exists (select * from DONHANG WITH (READCOMMITTED) WHERE DH_MA = @dh_ma and DH_TINHTRANG like N'Đã xác nhận')
		begin 
			raiserror('Don hang khong ton tai hoac chua xac nhan', 16,1)
			rollback tran
		end
		
		declare @ch_maxa char(10), @ch_mahuyen char(10), @ch_matinh char(10)
		select @ch_maxa = cn.DC_MAXA, @ch_mahuyen = cn.DC_MAHUYEN, @ch_matinh = cn.DC_MATINH from CHINHANH cn, DONHANG dh
		where dh.DH_MA = @dh_ma and dh.CH_MA = cn.CH_MA
		WAITFOR DELAY '00:00:10'

		update DONHANG WITH (XLOCK)
		set DH_TINHTRANG = N'Đang giao', TX_MA = @tx_ma
		where DH_MA = @dh_ma
		
		insert TINHTRANGGIAOHANG
		values (@tx_ma, @dh_ma, N'Đã nhận đơn hàng', @ch_matinh, @ch_mahuyen, @ch_maxa)
	end try
	begin catch
		raiserror('xac nhan don hang that bai', 16,1)
		rollback tran
	end catch
commit tran
go

-- 
CREATE 
--ALTER
PROC SP_KHDATHANG
	@kH_MA CHAR(10), 
	@PHUONGTHUCTHANHTOAN NVARCHAR(100)
AS
BEGIN TRAN
SET TRAN ISOLATION LEVEL SERIALIZABLE
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM dbo.KHACHHANG WHERE KH_MA = @kH_MA)
		BEGIN 
			PRINT N'KHACH HANG KHONG TON TAI'
			ROLLBACK
		END


		-- lay dia chi khach hang
		DECLARE @XA CHAR(10), @HUYEN CHAR(10), @TINH CHAR(10)
		SELECT @XA = DC_MAXA, @HUYEN = DC_MAHUYEN, @TINH = DC_MATINH  FROM dbo.KHACHHANG WHERE KH_MA = @KH_MA
		
		-- PHAN LOAI MON AN THEO CUA HANG
		DECLARE D CURSOR FOR SELECT DISTINCT MN.CH_MA FROM dbo.MONAN MN, dbo.GIOHANG GH WHERE GH.KH_MA = @KH_MA AND GH.MAN_MA = MN.MAN_MA
		OPEN D
		DECLARE @CH_MA CHAR(10) 
		FETCH NEXT FROM D INTO @CH_MA
		
		SELECT * FROM dbo.MONAN
		SELECT * FROM dbo.GIOHANG
		PRINT @CH_MA
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- MA DON HANG
			DECLARE @DH_MA CHAR(10), @TMP INT;
			SELECT @TMP = COUNT(*) + 1 FROM dbo.DONHANG WITH (READCOMMITTED)
			SET @DH_MA = 'DH_' + CAST(@TMP AS CHAR(10));
			-- TONG TIEN
			DECLARE @TONGTIEN MONEY 
			SET @TONGTIEN = 0;
			-- INSERT DONHANG
			INSERT INTO dbo.DONHANG WITH (XLOCK)
			(
				DH_MA,
				DH_NGAYDAT,
				DH_PHUONGTHUCTHANHTOAN,
				DH_TONGTIEN,
				KH_MA,
				CH_MA,
				DH_PHIVANCHUYEN,
				DH_TINHTRANG,
				TX_MA,
				DC_MATINH,
				DC_MAHUYEN,
				DC_MAXA
			)
			VALUES
			(   @DH_MA,   -- DH_MA - char(10)
				GETDATE(), -- DH_NGAYDAT - datetime
				@PHUONGTHUCTHANHTOAN, -- DH_PHUONGTHUCTHANHTOAN - nvarchar(100)
				1000000, -- DH_TONGTIEN - money
				@KH_MA, -- KH_MA - char(10)
				@CH_MA, -- CH_MA - char(10)
				10000, -- DH_PHIVANCHUYEN - money
				N'Chưa xác nhân', -- DH_TINHTRANG - nvarchar(50)
				NULL, -- TX_MA - char(10)
				@TINH, -- DC_MATINH - char(10)
				@HUYEN, -- DC_MAHUYEN - char(10)
				@XA  -- DC_MAXA - char(10)
				)
			DECLARE C CURSOR FOR SELECT GH.MAN_MA, GH.SOLUONG, GH.NOTES FROM dbo.GIOHANG GH, dbo.MONAN MN
										WHERE KH_MA = @kH_MA AND MN.MAN_MA = GH.MAN_MA AND MN.CH_MA = @CH_MA

			OPEN C
			DECLARE @MAN_MA CHAR(10), @SOLUONG INT, @NOTES NVARCHAR(100)
			FETCH NEXT FROM C INTO @MAN_MA, @SOLUONG, @NOTES
			WHILE @@FETCH_STATUS = 0
				BEGIN
					PRINT @MAN_MA
					-- LAY THONG TIN MON AN
					DECLARE @TD_MA CHAR(10), @CN_MA CHAR(10), @GIA MONEY
					SELECT @TD_MA = TD_MA, @CN_MA = CN_MA, @GIA = MAN_GIA FROM dbo.MONAN WHERE MAN_MA = @MAN_MA 
					--TINH TONG TIEN
					SET @TONGTIEN = @TONGTIEN + @SOLUONG * @GIA
					PRINT @CH_MA + ' - ' + @MAN_MA 
					INSERT INTO dbo.CHITIETDONHANG
					(
						DH_MA,
						MAN_MA,
						TD_MA,
						CN_MA,
						CH_MA,
						CTDH_SOLUONG,
						CTDH_GIATIEN,
						CTDH_GHICHU
					)
					VALUES
					(   @DH_MA,   -- DH_MA - char(10)
						@MAN_MA, -- MAN_MA - char(10)
						@TD_MA, -- TD_MA - char(10)
						@CN_MA, -- CN_MA - char(10)
						@CH_MA, -- CH_MA - char(10)
						@SOLUONG, -- CTDH_SOLUONG - char(10)
						NULL, -- CTDH_GIATIEN - money
						@NOTES  -- CTDH_GHICHU - nvarchar(100)
						)
					PRINT 'CHEN THANH CONG'
					DELETE dbo.GIOHANG WHERE KH_MA = @kH_MA AND MAN_MA = @MAN_MA
					FETCH NEXT FROM C INTO @MAN_MA, @SOLUONG, @NOTES
				END
			CLOSE C
			DEALLOCATE C
			-- UPDATE TONG TIEN
			UPDATE dbo.DONHANG
			SET DH_TONGTIEN = @TONGTIEN
			WHERE DH_MA = @DH_MA
			PRINT 'UPDATE THANH CONG'
			--TIEP TUC VONG LAP MOI
			FETCH NEXT FROM D INTO @CH_MA
		END

		CLOSE D
		DEALLOCATE D

	END TRY
	BEGIN CATCH
		PRINT N'LOI THUC THI'
		CLOSE D
		DEALLOCATE D
		CLOSE C
		DEALLOCATE C
		ROLLBACK
	END CATCH
COMMIT TRANSACTION
GO  