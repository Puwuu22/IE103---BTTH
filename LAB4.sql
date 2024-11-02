-- Bài tập 1. Thiết kế báo cáo dạng bảng
-- 1. Thiết kế báo cáo liệt kê DSSV có thực hiện đề tài
CREATE VIEW DSSV_DT
AS
	SELECT S.MSSV, S.TENSV AS 'HO TEN', S.SODT AS 'SO DT', LOP, DIACHI AS 'DIA CHI'
	FROM SV_DETAI SD JOIN SINHVIEN S ON SD.MSSV = S.MSSV
GO
SELECT * FROM DSSV_DT

-- 2. Thiết kế báo cáo liệt kê danh sách đề tài hiện tại
CREATE VIEW DSDT_GVHD
AS
	SELECT GH.MSDT, TENDT AS 'TEN DE TAI', TENGV AS 'TEN GVHD', GH.MSGV AS 'MS GVHD' 
	FROM GV_HDDT GH 
	JOIN GIAOVIEN G ON GH.MSGV = G.MSGV
	JOIN DETAI D ON GH.MSDT = D.MSDT

GO
SELECT * FROM DSDT_GVHD

-- 3. Thiết kế báo cáo liệt kê thông tin của các giáo viên tham gia phản biện
CREATE VIEW DSGV_PBDT
AS
	SELECT DISTINCT G.TENGV AS 'HO TEN', MAX(TENHV) AS 'HOC VI', TENHH AS 'HOC HAM', SODT AS 'SO DT', DIACHI AS 'DIA CHI'
	FROM GIAOVIEN G, GV_PBDT GP, GV_HV_CN GHC, HOCHAM HH, HOCVI HV
	WHERE G.MSGV = GP.MSGV AND G.MSGV = GHC.MSGV AND G.MSHH = HH.MSHH AND HV.MSHV = GHC.MSHV
	GROUP BY G.TENGV, TENHH, SODT, DIACHI
GO
SELECT * FROM DSGV_PBDT

SET DATEFORMAT DMY

-- 4. Thiết kế báo cáo liệt kê danh sách hội đồng ứng với mỗi đề tài
CREATE VIEW DSHD_DT
AS
	SELECT D.MSDT, TENDT, H.MSHD, PHONG, CONVERT(VARCHAR, NGAYHD, 105) AS 'NGAY BAO VE', FORMAT(TGBD, 'HH:mm') AS 'THOI GIAN BAT DAU'
	FROM HOIDONG_DT HD 
	JOIN HOIDONG H ON H.MSHD = HD.MSHD
	JOIN DETAI D ON HD.MSDT = D.MSDT

GO
SELECT * FROM DSHD_DT

--	5. Thiết kế báo cáo liệt kê cho biết thông tin đề tài, thông tin giáo viên là ủy viên đề
--	tài và điểm số của các giáo viên ủy viên này cho từng đề tài
CREATE VIEW DSDT_GVUV_DIEM
AS
	SELECT D.MSDT, TENDT, G.MSGV, TENGV, DIEM
	FROM GV_UVDT GU 
	JOIN GIAOVIEN G ON G.MSGV = GU.MSGV
	JOIN DETAI D ON D.MSDT = GU.MSDT

GO
SELECT * FROM DSDT_GVUV_DIEM

-- 6*. Thiết kế báo cáo công bố kết quả bảo vệ của mỗi đề tài theo mẫu (điểm trung 
-- bình làm tròn đến 1 chữ số thập phân)



-- Bài tập 2. Thiết kế báo cáo dạng biểu đồ
-- 1. Thiết kế báo cáo chứa biểu đồ cột biểu diễn sự phân bố số lượng đề tài đã hướng dẫn của mỗi giáo viên.
CREATE VIEW TK_GVHD_DT
AS
	SELECT TENGV, MSDT
	FROM GIAOVIEN G, GV_HDDT H
	WHERE G.MSGV = H.MSGV
GO
SELECT * FROM TK_GVHD_DT

-- 2. Thiết kế báo cáo chứa biểu đồ cột biểu diễn sự phân bố số lượng sinh viên thực hiện của mỗi đề tài.
CREATE VIEW TK_SV_DT
AS
	SELECT S.TENSV, MSDT 
	FROM SINHVIEN S, SV_DETAI SD
	WHERE S.MSSV = SD.MSSV

GO
SELECT * FROM TK_SV_DT

-- 3. Thiết kế báo cáo chứa biểu đồ cột nhóm biểu diễn sự phân bố điểm của các giáo viên (bao gồm GVHD, GVPB, GVUV) theo từng đề tài.
CREATE VIEW TK_DIEM
AS
	SELECT D.TENDT, H.DIEM DIEM_HD, P.DIEM DIEM_PB, U.DIEM DIEM_UV
	FROM DETAI D, GV_HDDT H, GV_PBDT P, GV_UVDT U
	WHERE D.MSDT = H.MSDT AND D.MSDT = P.MSDT AND D.MSDT = U.MSDT

GO 
SELECT * FROM TK_DIEM

-- 4*. Thiết kế báo cáo chứa biểu đồ đường biểu diễn sự phân bố điểm trung bình của các đề tài.

-- 5. Thiết kế báo cáo chứa biểu đồ tròn biểu diễn sự phân bố số lượng giáo viên theo từng học vị.
CREATE VIEW TK_SLGV_HV
AS
	SELECT  DISTINCT HV.TENHV, MSGV
	FROM GV_HV_CN GHC JOIN HOCVI HV ON GHC.MSHV = HV.MSHV

GO
SELECT * FROM TK_SLGV_HV

--6. Thiết kế báo cáo chứa biểu đồ tròn biểu diễn sự phân bố số lượng giáo viên theo từng chuyên ngành.
CREATE VIEW TK_SLGV_CN
AS
	SELECT DISTINCT C.TENCN, MSGV
	FROM GV_HV_CN GHC JOIN CHUYENNGANH C ON GHC.MSCN = C.MSCN


--7*. Thiết kế báo cáo chứa biểu đồ kết hợp biểu diễn thông tin hướng dẫn đề tài của 
--mỗi giáo viên, gồm có:
--• Cột biểu diễn số lượng đề tài mà giáo viên đó đã hướng dẫn.
--• Đường biểu diễn số lượng sinh viên mà giáo viên đó đã hướng dẫn.
CREATE VIEW TK_HDDT
AS
	SELECT TENGV, H.MSDT, MSSV
	FROM GIAOVIEN G, GV_HDDT H, SV_DETAI S
	WHERE G.MSGV = H.MSGV AND H.MSDT = S.MSDT
GO
SELECT * FROM TK_HDDT

--8. Thiết kế báo cáo chứa biểu đồ cột biểu diễn sự phân bố số lượng đề tài của mỗi hội đồng


