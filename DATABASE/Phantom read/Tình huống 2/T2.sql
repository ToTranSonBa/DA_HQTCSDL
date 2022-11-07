use DOAN_HQTCSDL
go

@man_ma char(10),
	@ch_ma char(10),
	@td_ma char(10),
	@cn_ma char(10),
	@man_ten nvarchar(50),
	@man_mieuta nvarchar(100),
	@man_tinhtrang nvarchar(50),
	@man_gia money

exec pr_capnhatmonan 'man1','ch1','td1','cn1','Phở Bò Tái',NULL,NULL,'30000'