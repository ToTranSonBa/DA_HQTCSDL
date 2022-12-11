use DOAN_HQTCSDL
go


EXEC dbo.pr_capnhatmonan @man_ma = 'MN_6',         -- char(10)
                         @ch_ma = 'CH_4',          -- char(10)
                         @td_ma = 'TD_2',          -- char(10)
                         @cn_ma = 'CN_2',          -- char(10)
                         @man_ten = N'STING',       -- nvarchar(50)
                         @man_mieuta = N'NGON',    -- nvarchar(100)
                         @man_tinhtrang = N'Có bán', -- nvarchar(50)
                         @man_gia = 20000       -- money


SELECT * FROM dbo.MONAN