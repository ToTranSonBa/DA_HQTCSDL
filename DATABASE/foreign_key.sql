﻿USE DOAN_HQTCSDL
GO



----KHÓA NGOẠI
-- HOSODANGKY -> HOPDONG 1
ALTER TABLE HOSODANGKY
ADD CONSTRAINT FK_HOSODK_HOPDONG
FOREIGN KEY (HD_MA)
REFERENCES HOPDONG

-- HOSODANGKY -> DOITAC 2
ALTER TABLE HOSODANGKY
ADD CONSTRAINT FK_HOSODK_DOITAC	
FOREIGN KEY (HSDK_NGUOIDAIDIEN)
REFERENCES DOITAC

--HOSODANGKY -> NHANVIEN 3
ALTER TABLE HOSODANGKY
ADD CONSTRAINT FK_HOSODK_NHANVIEN	
FOREIGN KEY (HSDK_NVDK)
REFERENCES NHANVIEN

--NHANVIEN -> DIACHI 4
ALTER TABLE NHANVIEN
ADD CONSTRAINT FK_NHANVIEN_DIACHI
FOREIGN KEY (DC_MATINH,DC_MAHUYEN,DC_MAXA)
REFERENCES DIACHI

--PHIHOAHONG -> DOITAC 5
ALTER TABLE PHIHOAHONG
ADD CONSTRAINT FK_PHIHOAHONG_DOITAC
FOREIGN KEY (DT_MA)
REFERENCES DOITAC

-- PHIHOAHONG -> NHANVIEN 6
ALTER TABLE PHIHOAHONG
ADD CONSTRAINT FK_PHIHOAHONG_NHANVIEN
FOREIGN KEY (PHH_NVNHAN)
REFERENCES NHANVIEN

-- CUAHANG -> DOITAC 7
ALTER TABLE CUAHANG
ADD CONSTRAINT FK_CUAHANG_DOITAC
FOREIGN KEY (DT_MA)
REFERENCES DOITAC

--CHINHANH -> CUAHNANG 8
ALTER TABLE CHINHANH
ADD CONSTRAINT FK_CHINHANH_CUAHANG
FOREIGN KEY (CH_MA)
REFERENCES CUAHANG

--THUCDON -> CHINHANH 9
ALTER TABLE THUCDON
ADD CONSTRAINT FK_THUCDON_CHINHANH
FOREIGN KEY (CN_MA,CH_MA)
REFERENCES CHINHANH

--MONAN -> THUCDON 10
ALTER TABLE MONAN
ADD CONSTRAINT FK_MONAN_THUCDON
FOREIGN KEY (TD_MA, CN_MA, CH_MA)
REFERENCES THUCDON

--DONHANG -> CUAHANG 11
ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_CUAHANG
FOREIGN KEY (CH_MA)
REFERENCES CUAHANG

--DONHANG ->KHACHHANG 12
ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_KHACHHANG
FOREIGN KEY (KH_MA)
REFERENCES KHACHHANG

--CHITIETDONHANG -> DONHANG 13 
ALTER TABLE CHITIETDONHANG
ADD CONSTRAINT FK_CHITIETDONHANG_DONHANG
FOREIGN KEY (DH_MA)
REFERENCES DONHANG

--CHITIETDONHANG -> MONAN 14
ALTER TABLE CHITIETDONHANG
ADD CONSTRAINT FK_CHITIETDONHANG_MONAN
FOREIGN KEY (MAN_MA)
REFERENCES MONAN

--TINHTRANGGIAOHANG -> TAIXE 15
ALTER TABLE TINHTRANGGIAOHANG
ADD CONSTRAINT FK_TINHTRANGGIAOHANG_TAIXE
FOREIGN KEY (TX_MA)
REFERENCES TAIXE

--TINHTRANGGIAOHANG -> KHACHHANG 16
ALTER TABLE TINHTRANGGIAOHANG
ADD CONSTRAINT FK_TINHTRANGGIAOHANG_KHACHHANG
FOREIGN KEY (KH_MA)
REFERENCES KHACHHANG

--KHACHHANG-> DIACHI 17
ALTER TABLE KHACHHANG
ADD CONSTRAINT FK_KHACHHANG_DIACHI
FOREIGN KEY (DC_MATINH,DC_MAHUYEN,DC_MAXA)
REFERENCES DIACHI