﻿CREATE 
--DROP
DATABASE DOAN_HQTCSDL
GO

USE DOAN_HQTCSDL
GO



CREATE
--ALTER
TABLE HOPDONG (
	HD_MA CHAR(10) PRIMARY KEY,
	HD_NGAYLAP DATETIME,
	HD_STK CHAR(20),
	HD_NGANHANG NVARCHAR(100),
	HD_CHINHANHNGANHANG NVARCHAR(100),
	HD_TINHTRANG NVARCHAR(50),
	HD_HOAHONG FLOAT,
	HD_TGHIEULUC DATE,
	DT_MA CHAR(10),
	NV_MA CHAR(10)
)
GO

CREATE 
--ALTER
TABLE HOSODANGKY (
	HSDK_MA CHAR(10) PRIMARY KEY,
	HD_MA CHAR(10), 
	HSDK_EMAIL NVARCHAR(50),
	HSDK_TENQUAN NVARCHAR(100),
	HSDK_THANHPHO NVARCHAR(50),
	HSDK_QUAN NVARCHAR(50),
	HSDK_SLCHINHANH INT,
	HSDK_SLDONHANGTOITHIEU INT,
	HSDK_LOAIAMTHUC NVARCHAR(100),
	HSDK_NGUOIDAIDIEN NVARCHAR(10),
	NV_MA CHAR(10),
	DT_MA CHAR(10)
)
GO

CREATE 
--ALTER
TABLE DOITAC ( 
	DT_MA CHAR(10) PRIMARY KEY,
	DT_TEN NVARCHAR(50),
	DT_SDT CHAR(10),
	DT_EMAIL NVARCHAR(100)
)
GO

CREATE 
--ALTER
TABLE NHANVIEN (
	NV_MA CHAR(10) PRIMARY KEY,
	NV_TEN NVARCHAR(50),
	NV_NGAYSINH DATE,
	NV_CMND CHAR(20),
	NV_SDT CHAR(10),
	NV_GIOITINH NVARCHAR(10),
	NV_MAIL NVARCHAR(100),
	--DIACHI
	DC_MATINH CHAR(10),
	DC_MAHUYEN CHAR(10),
	DC_MAXA CHAR(10),
) 
GO

CREATE
--ALTER
TABLE PHIHOAHONG (
	DH_MA CHAR(10),
	PHH_TONGTIEN MONEY,
	PHH_NGAYNOP DATETIME,
	PHH_PHITHANG INT, -- NOP TIEN CHO THANG ... NAM ...
	NV_MA CHAR(10)
	CONSTRAINT PK_PHH PRIMARY KEY (DH_MA,NV_MA)
)
GO

CREATE 
--ALTER
TABLE CUAHANG (
	CH_MA CHAR(10) PRIMARY KEY,
	DT_MA CHAR(10),
	CH_TEN CHAR(100), 
	CH_TGMOCUA TIME,
	CH_TGDONGCUA TIME,
	CH_SDT CHAR(10),
	CH_TINHTRANGHOATDONG NVARCHAR(50)
)
GO

CREATE 
--ALTER
TABLE CHINHANH (
	CN_MA CHAR(10), 
	CH_MA CHAR(10),
	DC_MATINH CHAR(10),
	DC_MAHUYEN CHAR(10),
	DC_MAXA CHAR(10),
	CN_TEN NVARCHAR(100)
	CONSTRAINT PK_CHINHANH PRIMARY KEY (CN_MA,CH_MA)
)
GO

CREATE 
--ALTER
TABLE THUCDON (
	TD_MA CHAR(10),		
	CN_MA CHAR(10), 
	CH_MA CHAR(10),
	TD_TEN CHAR(50)
	CONSTRAINT PK_THUCDON PRIMARY KEY (TD_MA,CN_MA,CH_MA)
)
GO

CREATE 
--ALTER
TABLE MONAN (
	MAN_MA CHAR(10),
	TD_MA CHAR(10),
	CN_MA CHAR(10), 
	CH_MA CHAR(10),
	MAN_TEN NVARCHAR(100),
	MAN_MIEUTA NVARCHAR(100),
	MAN_TINHTRANG NVARCHAR(20),
	MAN_IMGPATH NVARCHAR(50),
	MAN_GIA MONEY,
	CONSTRAINT PK_MONAN PRIMARY KEY (MAN_MA, TD_MA,CN_MA,CH_MA)
)
GO

CREATE
--ALTER
TABLE DONHANG (
	DH_MA CHAR(10) PRIMARY KEY,
	DH_NGAYDAT DATETIME,
	DH_PHUONGTHUCTHANHTOAN NVARCHAR(100),
	DH_TONGTIEN MONEY,
	KH_MA CHAR(10), 
	CH_MA CHAR(10),
	DH_PHIVANCHUYEN MONEY,
	DH_TINHTRANG  NVARCHAR(50),
	--DIACHI
	DC_MATINH CHAR(10),
	DC_MAHUYEN CHAR(10),
	DC_MAXA CHAR(10),
)
GO


CREATE
--ALTER
TABLE CHITIETDONHANG (
	DH_MA CHAR(10) PRIMARY KEY,
	MAN_MA CHAR(10),
	TD_MA CHAR(10),
	CN_MA CHAR(10), 
	CH_MA CHAR(10),
	CTDH_SOLUONG INT,
	CTDH_GIATIEN MONEY ,
	CTDH_GHICHU NVARCHAR(100)
)
GO

CREATE
--ALTER
TABLE TAIXE (
	TX_MA CHAR(10) PRIMARY KEY,
	TX_TEN NVARCHAR(50),
	TX_CMND CHAR(20),
	TX_SDT CHAR(10),
	TX_BIENSOXE CHAR(10),
	TX_STK CHAR(20),
	TX_NGANHANG NVARCHAR(100),
	TX_GIOITINH NVARCHAR(10),
	--DIACHI
	DC_MATINH CHAR(10),
	DC_MAHUYEN CHAR(10),
	DC_MAXA CHAR(10),
)
GO

CREATE 
--ALTER 
TABLE TINHTRANGGIAOHANG (
	TX_MA CHAR(10),
	DH_MA CHAR(10),
	TTGH_TINHTRANG NVARCHAR(50),

	--vi tri tai xe giao hang hien tai
	DC_MATINH CHAR(10),
	DC_MAHUYEN CHAR(10),
	DC_MAXA CHAR(10),
	CONSTRAINT PK_TINHTRANGGIAOHANG PRIMARY KEY (TX_MA, DH_MA)
)
GO

CREATE 
--ALTER 
TABLE KHACHHANG (
	KH_MA CHAR(10) PRIMARY KEY,
	KH_TEN NVARCHAR(100),
	KH_SDT CHAR(10),
	KH_MAIL CHAR(100),
	KH_GIOITINH NVARCHAR(10),
	KH_ANH NVARCHAR(50),
	--DIACHI
	DC_MATINH CHAR(10),
	DC_MAHUYEN CHAR(10),
	DC_MAXA CHAR(10)
	
)
GO

CREATE
--ALTER
TABLE DIACHI (
	DC_MATINH CHAR(10) NOT NULL,
	DC_MAHUYEN CHAR(10) NOT NULL,
	DC_MAXA CHAR(10) NOT NULL,
	DC_TENTINH NVARCHAR(20),
	DC_TENHUYEN NVARCHAR(20),
	DC_TENXA NVARCHAR(20),
	DC_SONHA NVARCHAR(100),
	CONSTRAINT PK_DIACHI PRIMARY KEY (DC_MATINH, DC_MAHUYEN, DC_MAXA)
)
GO

CREATE
--ALTER
TABLE TAIKHOAN(
	MA CHAR(10) NOT NULL PRIMARY KEY,
	UNAME CHAR(20) NOT NULL,
	PWD CHAR(10) NOT NULL,
	LOAI CHAR(10) NOT NULL
)
GO

CREATE
--ALTER
TABLE GIOHANG(
	MAN_MA CHAR(10) NOT NULL,
	KH_MA CHAR(10) NOT NULL,
	SOLUONG INT
	CONSTRAINT PK_GIOHANG PRIMARY KEY (MAN_MA, KH_MA)
)
GO


insert into TAIKHOAN values('kh_01','zp19d0z','1234','KHACHHANG');
insert into TAIKHOAN values('kh_02','20120429','1234','KHACHHANG');
insert into TAIKHOAN values('kh_03','20120000','1234','KHACHHANG');
insert into TAIKHOAN values('kh_04','20120001','1234','KHACHHANG');
insert into TAIKHOAN values('kh_05','20120002','1234','KHACHHANG');

insert into TAIKHOAN values('dt_01','20120008','1234','DOITAC');
insert into TAIKHOAN values('dt_02','20120007','1234','DOITAC');
insert into TAIKHOAN values('nv_01','20120003','1234','NHANVIEN');
insert into TAIKHOAN values('nv_02','20120004','1234','NHANVIEN');
insert into TAIKHOAN values('tx_01','20120005','1234','TAIXE');
insert into TAIKHOAN values('tx_02','20120006','1234','TAIXE');

select* from TAIKHOAN

insert into DIACHI values('11','1','1',N'Cao Bằng','abc','bcd',NULL);
insert into DIACHI values('70','1','1',N'Tây Ninh','efg','abs',NULL);
insert into DIACHI values('59','1','1',N'TP. Hồ Chí Minh','ekj','lop',NULL);

select * from DIACHI

insert into KHACHHANG values('kh_01',N'Nguyễn A','0395639633','abc@gmail',N'Nam','/images/profile pic/pic-1.png','11','1','1');
insert into KHACHHANG values('kh_02',N'Nguyễn B','0395639611','abc1@gmail',N'Nữ','/images/profile pic/pic-2.png','11','1','1');
insert into KHACHHANG values('kh_03',N'Nguyễn C','0395639612','abc2@gmail',N'Nam','/images/profile pic/pic-3.png','59','1','1');
insert into KHACHHANG values('kh_04',N'Nguyễn D','0395639613','abc3@gmail',N'Nữ','/images/profile pic/pic-4.png','11','1','1');

select * from KHACHHANG

insert into DOITAC values('dt_01',N'Nguyễn Văn F','0395639615','ab5c@gmail.com');
insert into DOITAC values('dt_02',N'Nguyễn Văn G','0395639616','abc6@gmail.com');


insert into NHANVIEN values('nv_01',N'Nguyễn Văn H','2002-01-11','5809237594','0395639617',N'Nam','abc7@gmail.com','59','1','1');
insert into NHANVIEN values('nv_02',N'Nguyễn Văn J','2002-02-22','5809345367','0395639618',N'Nam','abc8@gmail.com','11','1','1');

insert into TAIXE values('tx_01',N'Nguyễn K','134804358994','0395639619','j29-4565','1458912432',N'MB Bank',N'Nam','70','1','1');
insert into TAIXE values('tx_02',N'Nguyễn L','134809135995','0395639620','j29-3479','1458947598',N'Agribank',N'Nam','11','1','1');

insert into CUAHANG values('ch_01','dt_01','Hambu đê','05:59:59','23:59:59','1999999990',NULL);
insert into CUAHANG values('ch_04','dt_01','Hambu đê','05:59:59','23:59:59','1999999990',NULL);
insert into CUAHANG values('ch_05','dt_02','Pizza đê','05:59:59','23:59:59','1989898989',NULL);

insert into CHINHANH values('cn_03','ch_01','59','1','1',N'Chi Nhánh Tây Ninh');
insert into CHINHANH values('cn_02','ch_04','70','1','1',N'Chi Nhánh TP Hồ Chí Minh');

insert into THUCDON values('td_01','cn_03','ch_01',N'Menu Hambu');
insert into THUCDON values('td_02','cn_02','ch_04',N'Menu Pizza');

select * from THUCDON

insert into MONAN values('mn_01','td_01','cn_03','ch_01',N'Hamburger Cá','abc',NULL,'/images/foods/dish-1.png',89999);
insert into MONAN values('mn_02','td_01','cn_03','ch_01',N'Hamburger Bò','efg',NULL,'/images/foods/menu-2.jpg',99999);
insert into MONAN values('mn_03','td_02','cn_02','ch_04',N'Pizza Thập Cẩm','ekj',NULL,'/images/foods/dish-4.png',199999);

select * from MONAN

select count(*) from TAIKHOAN where UNAME='zp19d0z' and PWD='1234'
go
create proc sp_taikhoan 
@username char(20),
@password char(10)
As
select * from TAIKHOAN where UNAME='zp19d0z' and PWD='1234'

exec sp_taikhoan 'zp19d0z','1234';


select * from TAIKHOAN where UNAME='zp19d0z' and PWD=1234