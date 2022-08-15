------ C�U L?NH UPDATE
------ 2.33 C?p nh?t l?i gi� tr? tr??ng NGAYCHUYENHANG c?a nh?ng b?n ghi c� NGAYCHUYENHANG ch?a x�c ??nh (NULL)
----trong b?ng ?ONATHANG b?ng v?i gi� tr? c?a tr??ng NGAYDATHANG.

--UPDATE DONDATHANG
--SET NGAYCHUYENHANG = NGAYDATHANG
--WHERE NGAYCHUYENHANG IS NULL

------ 2.34 T?ng s? l??ng h�ng c?a nh?ng m?t h�ng do c�ng ty  VINAMILK cung c?p l�n g?p ?�i

--UPDATE MATHANG
--SET SOLUONG = SOLUONG*2
--FROM NHACUNGCAP
--WHERE MATHANG.MACONGTY = NHACUNGCAP.MACONGTY AND TENCONGTY = 'vinamilk'

----2.35 C?p nh?t gi� tr? c?a tr??ng  NOIGIAOHANG trong b?ng DONDATHANG b?ng ??a ch? c?a kh�ch h�ng ??i v?i 
----nh?ng ??n ??t h�ng ch?a x�c ??nh ???c n?i giao h�ng (gi� tr? tr??ng NOIGIAOHANG b?ng NULL)

--UPDATE DONDATHANG
--SET NOIGIAOHANG = DIACHI
--FROM KHACHHANG 
--WHERE DONDATHANG.MAKHACHHANG = KHACHHANG.MAKHACHHANG AND NOIGIAOHANG IS NULL

----2.36 C?p nh?t l?i d? li?u trong b?ng KHACHHANG sao cho n?u t�n c�ng ty v� t�n giao dich c?a kh�ch h�ng 
----tr�ng v?i t�n c�ng ty v� t�n giao d?ch c?a m?t nh� cung c?p n�o ?� th� ??a ch?, ?i?n tho?i, fax v� email 
----ph?i gi?ng nhau

--UPDATE KHACHHANG
--SET KHACHHANG.DIACHI = NHACUNGCAP.DIACHI
--	KHACHHANG.DIENTHOAI = NHACUNGCAP.DIENTHOAI
--	KHACHHANG.FAX = NHACUNGCAP.FAX
--	KHACHHANG.EMAIL = NHACUNGCAP.EMAIL
--FROM NHACUNGCAP
--WHERE KHACHHANG.TENCONGTY = NHACUNGCAP.TENCONGTY AND
--	KHACHHANG.TENGIAODICH = NHACUNGCAP.TENGIAODICH

----2.37 T?ng l??ng l�n g?p r??i cho nh?ng nh�n vi�n b�n ???c s? l??ng h�ng nhi?u h?n 100 trong n?m 2003

--UPDATE NHANVIEN
--SET LUONGCOBAN = LUONGCOBAN*1.5
--WHERE MANHANVIEN = (SELECT MANHANVIEN
--					FROM DONDATHANG INNER JOIN CHITIETDATHANG 
--					ON DONDATHANG.SOHOADON = CHITIETDATHANG.SOHOADON
--					GROUP BY MANHANVIEN
--					HAVING SUM(SOLUONG) > 100)

----2.38 T?ng ph? c?p l�n b?ng 50% l??ng cho nh?ng nh�n vi�n b�n ???c h�ng nhi?u nh?t

--UPDATE NHANVIEN
--SET PHUCAP = LUONGCOBAN * 0.5
--WHERE MANHANVIEN IN 
--(
--SELECT MANHANVIEN
--FROM DONDATHANG INNER JOIN CHITIETDATHANG 
--ON DONDATHANG.SOHOADON = CHITIETDATHANG.SOHOADON
--GROUP BY MANHANVIEN
--HAVING SUM(SOLUONG) >= ALL
--(SELECT SUM(SOLUONG)
--FROM DONDATHANG INNER JOIN CHITIETDATHANG 
--ON DONDATHANG.SOHOADON = CHITIETDATHANG.SOHOADON
--GROUP BY MANHANVIEN
--))


----2.39 gi?m 25% l??ng c?a nh?ng nh�n vi�n trong n?m 2003 kh�ng l?p ???c b?t k? ??n ??t h�ng n�o,

--UPDATE NHANVIEN
--SET LUONGCOBAN =LUONGCOBAN*0.75
--FROM DONDATHANG
--WHERE NHANVIEN.MANHANVIEN = DONDATHANG.MANHANVIEN AND DONDATHANG.SOHOADON IS NULL AND YEAR(NGAYDATHANG) = 2003

--UPDATE NHANVIEN
--SET LUONGCOBAN = LUONGCOBAN*0.75
--WHERE NOT EXISTS 
--(
--SELECT MANHANVIEN
--FROM DONDATHANG
--WHERE MANHANVIEN = NHANVIEN.MANHANVIEN
--)


----2.40 gi? s? trong b?ng DONDATHANG c� th�m tr??ng SOTIEN cho bi?t s? ti?n m� kh�ch h�ng ph?i tr? 
----trong m?i ??n ??t h�ng. H�y t�nh gi� tr? cho tr??ng n�y

--UPDATE DONDATHANG
--SET SOTIEN = 
--(
--SELECT SUM(SOLUONG* GIABAN - SOLUONG*GIABAN*MUCGIAMGIA/100)
--FROM CHITIETDATHANG
--WHERE CHITIETDATHANG.SOHOADON = DONDATHANG.SOHOADON
--GROUP BY SOHOADON
--)

----TH?C HI?N C�C Y�U C?U D??I ?�Y B?NG C�U L?NH DELETE

----2.41 X�a kh?i NHANVIEN nh?ng nh�n vi�n ?� l�m vi?c trong c�ng ty qu� 40 n?m

--DELETE FROM NHANVIEN
--WHERE DATEDIFF(YY,NGAYLAMVIEC, GETDATE()) > 40

----2.42 X�a nh?ng ??n ??t h�ng tr??c n?m 2000 ra kh?i c? s? d? li?u

--DELETE FROM DONDATHANG
--WHERE NGAYDATHANG < '1/1/2000'

----2.43 X�a kh?i b?ng LOAIHANG nh?ng loai h�ng hi?n kh�ng c� m?t h�ng

--DELETE FROM LOAIHANG
--WHERE NOT EXISTS 
--(
--SELECT MAHANG 
--FROM MATHANG 
--WHERE MATHANG.MALOAIHANG = LOAIHANG.MALOAIHANG
--)

----2.44 X�a kh?i b?ng KHACHHANG nh?ng kh�ch h�ng hi?n kh�ng c� b?t k? ??n ??t h�ng n�o cho c�ng ty
--?A ?A, T?I SAO?? NGHI�N C?U L?I C�U N�Y


--DELETE FROM KHACHHANG
--WHERE NOT EXISTS 
--(
--SELECT DONDATHANG.SOHOADON
--FROM DONDATHANG
--WHERE KHACHHANG.MAKHACHHANG = DONDATHANG.MAKHACHHANG
--)
----2.45 x�a kh?i b?ng MATHANG nh?ng m?t h�ng c� s? l??ng b?ng 0 v� kh�ng ???c ??t mua trong b?t k? ??n ??t h�ng n�o.

--DELETE FROM MATHANG
--WHERE SOLUONG = 0 AND NOT EXISTS 
--(
--SELECT SOHOADON
--FROM CHITIETDATHANG
--WHERE CHITIETDATHANG.MAHANG = MATHANG.MAHANG
--)