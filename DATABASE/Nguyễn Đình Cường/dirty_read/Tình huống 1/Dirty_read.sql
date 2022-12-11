USE DOAN_HQTCSDL

-- xoa mon an
CREATE 
--alter
PROC PROC_CAPNHATMONAN_DT2
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
		
		update MONAN
		set MAN_TEN = @man_ten, MAN_MIEUTA = @man_mieuta, MAN_TINHTRANG = @man_tinhtrang, MAN_GIA = @man_gia
		WHERE MAN_MA = @man_ma and CH_MA = @ch_ma and TD_MA = @td_ma and CN_MA = @cn_ma
		WAITFOR DELAY '00:00:10'
		ROLLBACK
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
CREATE
--ALTER
PROC sp_DanSachMonAnKhachHangTimKiem
	@makh char(10),
	@tenmonan nvarchar(100)
as
set transaction isolation level read uncommitted
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
