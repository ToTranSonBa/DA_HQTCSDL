use DOAN_HQTCSDL
go

--xem danh sach doi tac
create
--alter
proc pr_xemdanhsachdoitac
as
begin
	declare c cursor for (select * from DOITAC)
	declare @dt_ma char(10), @dt_ten nvarchar(50), @dt_sdt char(10), @dt_email char(100)
	open c
	fetch next from c into @dt_ma, @dt_ten, @dt_sdt, @dt_ma
	while @@FETCH_STATUS = 0
		begin
			print @dt_ma + '  ' + @dt_ten + ' ' + @dt_sdt +' ' + @dt_ma
			fetch next from c into @dt_ma, @dt_ten, @dt_sdt, @dt_ma
		end
	close c
	deallocate c
end
go

--
