USE DOAN_HQTCSDL
GO

EXEC pr_TXNhanDonHang 'DH_4', 'TX_1'
GO

SELECT * FROM dbo.DONHANG
SELECT * FROM dbo.TAIXE
