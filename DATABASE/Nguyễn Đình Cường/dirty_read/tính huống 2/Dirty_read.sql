
set transaction isolation level read uncommitted

SELECT * FROM dbo.MONAN
waitfor delay '0:0:10'
select * from MONAN



CREATE 
--alter
PROC sp_themMonAn 
	@DT_MA CHAR(10),	
    @TD_MA CHAR(10),
    @CN_MA CHAR(10),
    @CH_MA CHAR(10),
    @MAN_TEN NVARCHAR(100),
    @MAN_MIEUTA NVARCHAR(100),
    @MAN_IMGPATH NVARCHAR(100),
    @MAN_GIA MONEY
AS
set transaction isolation level read uncommitted
BEGIN TRANSACTION
	BEGIN TRY
		IF (@TD_MA IS NULL OR @CN_MA IS NULL OR @CH_MA IS NULL OR @MAN_TEN IS NULL  OR @MAN_GIA IS NULL)
		BEGIN 
			PRINT N'thong tin dau vao khong hop le'
			ROLLBACK
			RETURN
		END 
		IF NOT EXISTS (SELECT * FROM dbo.CUAHANG WHERE CH_MA = @CH_MA AND DT_MA = @DT_MA)
		BEGIN
			PRINT N'sai ma cua hang'
			ROLLBACK
			RETURN
		END

		IF NOT EXISTS (SELECT * FROM dbo.THUCDON WHERE TD_MA = @TD_MA AND CN_MA = @CN_MA AND CH_MA = @CH_MA)
		BEGIN
			PRINT N'THONG TIN VE THUC DON KHONG DUNG'
			ROLLBACK
			RETURN
		END

		DECLARE @MAN_MA CHAR(10), @TMP INT
		SELECT @TMP = COUNT(*) + 1 FROM dbo.MONAN
		SET @MAN_MA = 'MN_' + CAST(@TMP AS CHAR(10));

		INSERT INTO dbo.MONAN
		(
			MAN_MA,
			TD_MA,
			CN_MA,
			CH_MA,
			MAN_TEN,
			MAN_MIEUTA,
			MAN_IMGPATH,
			MAN_GIA
		)
		VALUES
		(   @MAN_MA,   -- MAN_MA - char(10)
			@TD_MA,   -- TD_MA - char(10)
			@CN_MA,   -- CN_MA - char(10)
			@CH_MA,   -- CH_MA - char(10)
			@MAN_TEN, -- MAN_TEN - nvarchar(100)
			@MAN_MIEUTA, -- MAN_MIEUTA - nvarchar(100)
			@MAN_IMGPATH, -- MAN_IMGPATH - nvarchar(100)
			@MAN_GIA  -- MAN_GIA - money
			)
    waitfor delay '0:0:15'
	rollback
	END TRY
	BEGIN CATCH
		PRINT N'LOI UPDATE'
		ROLLBACK
		RETURN
	END CATCH
COMMIT TRANSACTION
GO