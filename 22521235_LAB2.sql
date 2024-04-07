---------------------------Phần 1. THỦ TỤC LƯU TRỮ----------------------------
-- Bài tập 1. Thủ tục lưu trữ không có tham số vào 

-- 1. Yêu cầu: In ra danh sách sinh viên (MSSV, TENSV) có trong bảng SINHVIEN.
CREATE PROC In_DSSV
AS
BEGIN
	SELECT MSSV, TENSV
	FROM SINHVIEN
END

-- 1.1 Thực thi
EXEC In_DSSV

-- 2. Yêu cầu: In ra danh sách giáo viên với đầy đủ các thuộc tính của bảng GIAOVIEN.
CREATE PROC In_DSGV
AS
BEGIN
	SELECT *
	FROM GIAOVIEN
END

-- 1.2 Thực thi
EXEC In_DSGV

-- 3. Yêu cầu: In ra danh sách các hội đồng (MSHD, PHONG) đối với những hội đồng diễn ra vào tháng 12. 
CREATE PROC In_DSHD
AS
BEGIN
	SELECT MSHD, PHONG
	FROM HOIDONG
	WHERE MONTH(NGAYHD) = 12
END

-- 1.3 Thực thi
EXEC In_DSHD

-- 4. Yêu cầu: In ra điểm phản biện cao nhất và điểm phản biện thấp nhất trong số các đề tài được phản biện. 
CREATE PROC In_DiemPB
AS
BEGIN
	SELECT MAX(DIEM) AS 'Điểm cao nhất', MIN(DIEM) AS 'Điểm thấp nhất'
	FROM GV_PBDT
END

-- 1.4 Thực thi
EXEC In_DiemPB

-- 5. Yêu cầu: In ra danh sách giáo viên (TENGV) và mã số đề tài (MSDT) mà giáo viên đó hướng dẫn (nếu có). 
CREATE PROC In_GVHD
AS
BEGIN
    SELECT GV.TENGV, MSDT
    FROM GIAOVIEN GV LEFT JOIN GV_HDDT GVHD ON GVHD.MSGV = GV.MSGV  
END

-- 1.5 Thực thi
EXEC In_GVHD

-- 6. Yêu cầu: In ra danh sách đề tài (TENDT) và số lượng sinh viên thực hiện của mỗi đề tài. 
CREATE PROC In_DSDT
AS
BEGIN
	SELECT TENDT, COUNT(MSSV) AS 'SOLUONG_SV'
	FROM DETAI DT JOIN SV_DETAI SD ON DT.MSDT = SD.MSDT
	GROUP BY TENDT
END

-- 1.6 Thực thi
EXEC In_DSDT

-- 7. Yêu cầu: In ra danh sách các giáo viên (TENGV) đạt học hàm (TENHH) ‘GIÁO SƯ’.
CREATE PROC In_DSGV_HH
AS 
BEGIN
	SELECT TENGV, TENHH
	FROM GIAOVIEN GV JOIN HOCHAM HH ON GV.MSHH = HH.MSHH
END

-- 1.7 Thực thi

EXEC In_DSGV_HH
/* 8. *Yêu cầu: In ra danh sách giáo vên theo định dạng: <TENHV TENGV>
	(Lưu ý: Trường hợp giáo viên có đạt học vị ở nhiều chuyên ngành khác nhau thì chỉ in ra một lần).  */
CREATE PROC In_GSGV_HV
AS
BEGIN
    SELECT DISTINCT CONCAT_WS(' ', HV.TENHV, GV.TENGV) AS 'Giao vien'
    FROM GV_HV_CN GH
    JOIN GIAOVIEN GV ON GV.MSGV = GH.MSGV
    JOIN HOCVI HV ON HV.MSHV = GH.MSHV
END

-- 1.8 Thực thi
EXEC In_GSGV_HV

-- 9. Yêu cầu: In ra danh sách giáo viên (TENGV), học vị (TENHV) và chuyên ngành  (TENCN) mà giáo viên đó đã đạt được. 
CREATE PROC In_DSGV_HV_CN
AS
BEGIN
	SELECT TENGV, TENHV, TENCN
	FROM GV_HV_CN GH
	JOIN GIAOVIEN GV ON GV.MSGV = GH.MSGV
    JOIN HOCVI HV ON HV.MSHV = GH.MSHV
	JOIN CHUYENNGANH DT ON DT.MSCN = GH.MSCN
END

-- 1.9 Thực thi
EXEC In_DSGV_HV_CN

-- Bài tập 2. Thủ tục lưu trữ có tham số vào 
-- a. Thủ tục lưu trữ có một tham số vào 

--	1. Tham số đưa vào: MSSV. Yêu cầu: In ra thông tin của sinh viên tương ứng (TENSV, SODT, LOP, DIACHI).
CREATE PROC B2_In_DSSV @MSSV CHAR(8)
AS
BEGIN
	SELECT TENSV, SODT, LOP, DIACHI
	FROM SINHVIEN
	WHERE MSSV = @MSSV
END

-- a1. Thực thi
EXEC B2_In_DSSV '13520001'
EXEC B2_In_DSSV '13520006'
EXEC B2_In_DSSV '13520008'

--	2. Tham số đưa vào: MSDT. Yêu cầu: In ra tên các đề tài tương ứng (TENDT). 
CREATE PROC B2_In_DSDT @MSDT CHAR(6)
AS 
BEGIN
	SELECT TENDT
	FROM DETAI
	WHERE MSDT = @MSDT
END

-- a2. Thực thi
EXEC B2_In_DSDT '97004'
EXEC B2_In_DSDT '97006'
EXEC B2_In_DSDT '97090'


-- 3. Tham số đưa vào: MSHD. Yêu cầu: In ra thông tin của hội đồng đó (PHONG, TGBD, NGAYHD, TINHTRANG). 
CREATE PROC B2_In_DSHD @MSHD INT
AS
BEGIN
	SELECT PHONG, TGBD, NGAYHD, TINHTRANG
	FROM HOIDONG
	WHERE MSHD = @MSHD
END
-- a3. Thực thi
EXEC B2_In_DSHD 1
EXEC B2_In_DSHD 3
EXEC B2_In_DSHD 10

--	4. Tham số đưa vào: TENGV. Yêu cầu: In ra danh sách đề tài (MSDT, TENDT) mà giáo viên đó hướng dẫn.
CREATE PROC In_DSDT_GVHD @TENGV NVARCHAR(30) 
AS
BEGIN
	SELECT DT.MSDT, TENDT
	FROM GV_HDDT GH 
		JOIN GIAOVIEN GV ON GV.MSGV = GH.MSGV
		JOIN DETAI DT ON DT.MSDT = GH.MSDT
	WHERE TENGV = @TENGV
END

-- a4. Thực thi
EXEC In_DSDT_GVHD N'Trần Thu Trang'
EXEC In_DSDT_GVHD N'Chu Tiến'
EXEC In_DSDT_GVHD N'Nguyễn Văn B'

--	5. Tham số đưa vào: MSDT. Yêu cầu: In ra số lượng sinh viên thực hiện của mỗi đề tài. 
CREATE PROC B2_DSSV_DT @MSDT CHAR(6)
AS
BEGIN
	SELECT COUNT(MSSV) AS SLSV
	FROM SV_DETAI
	WHERE MSDT = @MSDT
END
	
-- a5. Thực thi
EXEC B2_DSSV_DT '97003'
EXEC B2_DSSV_DT '97005'
EXEC B2_DSSV_DT '97006'

--	6*. Tham số đưa vào: MSGV. Yêu cầu: In ra họ tên (TENGV) và tên học vị (TENHV) của giáo viên đó theo định dạng: <TENHV TENGV> 
-- (Lưu ý: Trường hợp giáo viên đạt một học vị ở nhiều chuyên ngành thì chỉ in ra một lần). 
CREATE PROC B2_In_GSGV_HV @MSGV CHAR(5)
AS
BEGIN
    SELECT DISTINCT CONCAT_WS(' ', HV.TENHV, GV.TENGV) AS N'Giáo viên'
    FROM GV_HV_CN GH
    JOIN GIAOVIEN GV ON GV.MSGV = GH.MSGV
    JOIN HOCVI HV ON HV.MSHV = GH.MSHV
	WHERE GV.MSGV = @MSGV
END

-- a6. Thực thi
EXEC B2_In_GSGV_HV '00201'
EXEC B2_In_GSGV_HV '00204'
EXEC B2_In_GSGV_HV '00206'

--	7. Tham số đưa vào: MSHD. Yêu cầu: In ra danh sách các đề tài (MSDT, TENDT) có trong hội đồng đó.
CREATE PROC B2_In_DSDT_HD @MSHD INT
AS
BEGIN
	SELECT DT.MSDT, TENDT
	FROM DETAI DT JOIN HOIDONG_DT HDDT ON DT.MSDT = HDDT.MSDT
	WHERE HDDT.MSHD = @MSHD
END

-- a7. Thực thi
EXEC B2_In_DSDT_HD 1
EXEC B2_In_DSDT_HD 2
EXEC B2_In_DSDT_HD 3

-- b.Thủ tục lưu trữ có nhiều tham số vào

/* 	8. Tham số đưa vào: MSGV, TENGV, SODT, DIACHI, MSHH, NAMHH.
	Yêu cầu: Thêm dữ liệu mới vào bảng GIAOVIEN với các thông tin được đưa vào. */
CREATE PROC B2_Them_DSGV_HH @MSGV CHAR(5), @TENGV NVARCHAR(30), @DIACHI NVARCHAR(50),
@SODT VARCHAR(10),  @MSHH INT, @NAMHH SMALLDATETIME
AS
BEGIN
	IF EXISTS (SELECT * FROM HOCHAM WHERE MSHH = @MSHH)
	BEGIN
		INSERT INTO GIAOVIEN (MSGV, TENGV,  DIACHI, SODT, MSHH, NAMHH)
		VALUES (@MSGV, @TENGV, @DIACHI, @SODT, @MSHH, @NAMHH)
		PRINT N'Thêm dữ liệu thành công'
	END
	ELSE
	BEGIN
		PRINT N'Không tìm thấy mã học hàm'
		RETURN 0
	END
END

-- b8. Thực thi
EXEC B2_Them_DSGV_HH '00269', N'Trần Thị Bưởi', '123 L.A.', '0969969966', 7, '2069'
EXEC B2_Them_DSGV_HH '00269', N'Trần Thị Bưởi', '123 L.A.', '0969969966', 1, '2069'
EXEC B2_Them_DSGV_HH '00232', N'Lê Minh Tấn', '135 C.F.', '0123456789', 2, '1990'

/*	9.	Tham số đưa vào: MSGV, TENGV, SODT, DIACHI, MSHH, NAMHH. 
	Yêu cầu: Thêm dữ liệu mới vào bảng GIAOVIEN với các thông tin được đưa vào. */
CREATE PROC B2_Them_DSGV @MSGV CHAR(5), @TENGV NVARCHAR(20), @DIACHI NVARCHAR(50),
@SODT NVARCHAR(10), @MSHH INT, @NAMHH SMALLDATETIME
AS
BEGIN
	IF EXISTS (SELECT * FROM GIAOVIEN WHERE MSGV = @MSGV)
	BEGIN
		RAISERROR (N'Mã giáo viên bị trùng', 8, 16)
		RETURN 0
	END
	ELSE 
	BEGIN
		INSERT INTO GIAOVIEN (MSGV, TENGV, DIACHI, SODT, MSHH, NAMHH)
		VALUES (@MSGV, @TENGV, @DIACHI, @SODT, @MSHH, @NAMHH)
		PRINT N'Thêm dữ liệu thành công'
		RETURN 1
	END
END

-- b9. Thực thi
EXEC B2_Them_DSGV '00222', N'Trần Thị Lung Linh', 'New York', '0123456789', 2, '2016' 
EXEC B2_Them_DSGV '00202', N'Lê Minh Tường', 'Carlifornia', '082344950', 1,'2022'
EXEC B2_Them_DSGV '00231', N'Đặng Minh Châu', 'Los Angeles', '0987654321', 1, '2011'

/*	10.	* Giống câu 8 và câu 9, nhưng đồng thời kiểm tra xem MSGV có trùng không và MSHH đã tồn tại chưa. 
	Nếu MSGV trùng thì trả về 0, nếu MSHH chưa tồn tại thì trả về 1, 
	ngược lại thì thêm dữ liệu mới, thông báo ‘Thêm dữ liệu thành công’ và trả về giá trị 1. */
CREATE PROC B2_Them_DSGV_MS_HH @MSGV CHAR(5), @TENGV NVARCHAR(20), @DIACHI NVARCHAR(50),
@SODT NVARCHAR(10), @MSHH INT, @NAMHH SMALLDATETIME
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM GIAOVIEN WHERE MSGV = @MSGV)
	BEGIN
		IF EXISTS (SELECT * FROM HOCHAM WHERE MSHH = @MSHH)
		BEGIN
			INSERT INTO GIAOVIEN VALUES (@MSGV, @TENGV, @DIACHI, @SODT, @MSHH, @NAMHH)
			PRINT N'Thêm dữ liệu thành công'
			RETURN 1
		END
		ELSE
		BEGIN
			PRINT N'Không tìm thấy mã học hàm'
			RETURN 1
		END
	END
	ELSE
	BEGIN
		RAISERROR (N'Mã giáo viên bị trùng', 8, 16)
		RETURN 0
	END
END	

-- b10. Thực thi
EXEC B2_Them_DSGV_MS_HH '00229', N'Tạ Tấn', 'VietNam', '0124856789', 3, '2016'
EXEC B2_Them_DSGV_MS_HH '00233', N'Nguyễn Dũng', 'Canada', '0187678578', 2, '2023'
EXEC B2_Them_DSGV_MS_HH '00222', N'Trần Hoàng Thư', 'B.P', '0715272899', 1 , '2017'

--	11.	Tham số đưa vào: MSDT cũ, TENDT mới. Yêu cầu: Cập nhật tên đề tài mới với mã đề tài cũ không đổi. 
CREATE PROC B2_Update_DT @MSDT CHAR(6), @TENDT NVARCHAR(30)
AS
BEGIN
	IF EXISTS (SELECT * FROM DETAI WHERE @MSDT = MSDT)
	BEGIN
		UPDATE DETAI
		SET TENDT = @TENDT
		WHERE MSDT = @MSDT
		PRINT N'Cập nhật dữ liệu thành công'
		RETURN 1
	END
	ELSE
	BEGIN
		PRINT N'Không tìm thấy mã số đề tài'
		RETURN 0
	END
END

-- b11. Thực thi
EXEC B2_Update_DT '97002', N'Nhận dạng khuôn mặt' 
EXEC B2_Update_DT '97005', N'Phần mềm xử lý ảnh' 
EXEC B2_Update_DT '97009', N'Quản lý trường đại học' 

--	12.	Tham số đưa vào: MSSV cũ, TENSV mới, DIACHI mới. 
--  Yêu cầu: Cập nhật họ tên và địa chỉ mới của sinh viên với mã sinh viên không đổi.
CREATE PROC B2_Update_DSSV @MSSV CHAR(8), @TENSV NVARCHAR(30), @DIACHI NCHAR(50)
AS
BEGIN 
	IF EXISTS (SELECT * FROM SINHVIEN WHERE MSSV = @MSSV)
	BEGIN
		UPDATE SINHVIEN
		SET TENSV = @TENSV
		WHERE MSSV = @MSSV
		
		UPDATE SINHVIEN
		SET DIACHI = @DIACHI
		WHERE MSSV = @MSSV
		
		PRINT N'Cập nhật dữ liệu thành công'
		RETURN 1
	END
	ELSE
	BEGIN
		PRINT N'Không tìm thấy sinh viên'
		RETURN 0
	END
END

-- b12. Thực thi
EXEC B2_Update_DSSV '13520002', N'Trần Khánh Nguyên', N'QUẬN 6' 
EXEC B2_Update_DSSV '13520005', N'Lê Thị Thúy Hằng', N'GÒ VẤP'
EXEC B2_Update_DSSV '13520008', N'Lê Minh An', N'QUẬN 7'

-- Bài tập 3. Thủ tục lưu trữ có tham số vào và tham số ra 

/*	1.Tham số đưa vào: TENGV. Tham số trả ra: SDT.  Yêu cầu: Đưa vào họ tên giáo viên (TENGV), trả ra số điện thoại (SDT) của giáo viên đó */
CREATE PROC B3_Tim_SDT @TENGV NVARCHAR(30), @SDT VARCHAR(10) OUT
AS
BEGIN
	IF EXISTS (SELECT * FROM GIAOVIEN WHERE TENGV = @TENGV)
		SELECT @SDT = SODT FROM GIAOVIEN WHERE TENGV = @TENGV
	ELSE
	BEGIN
		PRINT N'Không tìm thấy giáo viên'
		RETURN 0
	END
END
-- 3.1.1 Thực thi
GO
DECLARE @sdt VARCHAR(10)
EXEC B3_Tim_SDT @TENGV = N'Nguyễn Văn An', @SDT = @sdt OUT
PRINT @sdt

GO
DECLARE @sdt VARCHAR(10)
EXEC B3_Tim_SDT @TENGV = N'Chu Tiến', @SDT = @sdt OUT
PRINT @sdt

GO
DECLARE @sdt VARCHAR(10)
EXEC B3_Tim_SDT @TENGV = N'Lê Quang Danh', @SDT = @sdt OUT
PRINT @sdt

/* Nếu có nhiều giáo viên trùng tên thì có báo lỗi không, tại sao? Làm sao để hiện thông báo có bao nhiêu giáo viên trùng tên và trả về các SDT? 
=> Nếu có nhiều GV trùng tên thì sẽ không báo lỗi, mà chỉ trả về sdt của gv đầu tiên được tìm thấy. 
*/

CREATE PROC B3_Tim_SDT_C2 @TENGV NVARCHAR(30), @SDT VARCHAR(10) OUT
AS
BEGIN
	DECLARE @count INT
	SELECT @count = COUNT (*) FROM GIAOVIEN WHERE TENGV = @TENGV

	IF (@count > 1)
	BEGIN
		PRINT N'Có ' + CAST(@count AS NVARCHAR) + N' giáo viên trùng tên'
		SELECT MSGV, SODT FROM GIAOVIEN WHERE TENGV = @TENGV
	END
	ELSE IF (@count = 1)
    BEGIN
        PRINT N'Có 1 giáo viên có tên ' + @TENGV
        SELECT MSGV, SODT FROM GIAOVIEN WHERE TENGV = @TENGV
	END
	ELSE
	BEGIN
		PRINT N'Không tìm thấy giáo viên'
		RETURN 0
	END
END
-- 3.1.2 Thực thi và kiểm tra 
EXEC B2_Them_DSGV '00239', N'Trần Trung', 'US', '2222444488', 1, '2022'

GO
DECLARE @sdt VARCHAR(10)
EXEC B3_Tim_SDT_C2 @TENGV = N'Trần Trung', @SDT = @sdt OUT


/*	2.Tham số đưa vào: TENSV. 
	Tham số trả ra: MSDT. 
	Yêu cầu: Đưa vào họ tên sinh viên (TENSV), trả ra mã số đề tài (MSDT) mà sinh viên đó đã thực hiện, */
CREATE PROC B3_Tim_MSDT @TENSV NVARCHAR(30), @MSDT CHAR(6) OUT
AS
BEGIN
		IF EXISTS (SELECT * FROM SV_DETAI SD JOIN SINHVIEN SV ON SV.MSSV = SD.MSSV WHERE TENSV = @TENSV)
			SELECT @MSDT = MSDT FROM SV_DETAI SD JOIN SINHVIEN SV ON SV.MSSV = SD.MSSV WHERE TENSV = @TENSV
	ELSE
	BEGIN
		PRINT N'Không tìm thấy sinh viên'
		RETURN 0
	END
END

-- 3.2 Thực thi
GO
DECLARE @msdt CHAR(6)
EXEC B3_Tim_MSDT N'Phan Tấn Đạt', @MSDT = @msdt OUT
PRINT @msdt

GO
DECLARE @msdt CHAR(6)
EXEC B3_Tim_MSDT N'Ưng Hồng Ân', @MSDT = @msdt OUT
PRINT @msdt

GO
DECLARE @msdt CHAR(6)
EXEC B3_Tim_MSDT N'Lên Văn Lâm', @MSDT = @msdt OUT
PRINT @msdt

/*	3.Tham số đưa vào: TENHV. Tham số trả ra: SLGV. Yêu cầu: Đưa vào tên học vị (TENHV), trả ra số lượng giáo viên (SLGV) đạt học vị đó.*/
CREATE PROC B3_Dem_SLGV_HV @TENHV NVARCHAR(20), @SLGV INT OUT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM HOCVI WHERE TENHV = @TENHV)
	BEGIN
		PRINT N'Không tìm thấy học vị'
		RETURN 0
	END
	ELSE
	BEGIN
		SELECT @SLGV = COUNT(MSGV) FROM HOCVI HV INNER JOIN GV_HV_CN GH ON HV.MSHV = GH.MSHV WHERE TENHV = @TENHV
		PRINT N'Số giáo viên có học vị ' + @TENHV + N' là ' + CAST(@SLGV AS VARCHAR(4))
	END
END	
-- 3.3 Thực thi
GO
DECLARE @slgv INT
EXEC B3_Dem_SLGV_HV N'Kỹ sư', @SLGV = @slgv OUT

GO
DECLARE @slgv INT
EXEC B3_Dem_SLGV_HV N'Thạc sĩ', @SLGV = @slgv OUT

GO
DECLARE @slgv INT
EXEC B3_Dem_SLGV_HV N'Bác sĩ', @SLGV = @slgv OUT

/* 4.	Tham số đưa vào: MSDT. Tham số trả ra: DTB. 
		Yêu cầu: Đưa vào mã số đề tài (MSDT), trả ra điểm trung bình (DTB) của đề tài*/
CREATE PROC B3_Tinh_DTB @MSDT CHAR(6), @DTB NUMERIC(5,2) OUT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM DETAI WHERE MSDT = @MSDT)
	BEGIN
		PRINT N'Không tìm thấy đề tài'
		RETURN 0
	END
	ELSE
		DECLARE @TONGDIEM FLOAT = 0, @SLGV FLOAT = 0
		IF EXISTS (SELECT * FROM GV_HDDT WHERE MSDT = @MSDT)
		BEGIN
			SELECT @TONGDIEM=SUM(DIEM) + @TONGDIEM, @SLGV=COUNT(*) + @SLGV
			FROM GV_HDDT
			WHERE MSDT = @MSDT
		END
		ELSE 
		BEGIN
			PRINT N'Đề tài chưa được hoàn thành'
			RETURN 0
		END

		IF EXISTS (SELECT * FROM GV_PBDT WHERE MSDT = @MSDT)
		BEGIN
			SELECT @TONGDIEM=SUM(DIEM) + @TONGDIEM, @SLGV=COUNT(*) +@SLGV
			FROM GV_PBDT
			WHERE MSDT = @MSDT
		END
		ELSE 
		BEGIN
			PRINT N'Đề tài chưa được hoàn thành'
			RETURN 0
		END

		IF EXISTS (SELECT * FROM GV_UVDT WHERE MSDT = @MSDT)
		BEGIN
			SELECT @TONGDIEM=SUM(DIEM) + @TONGDIEM, @SLGV=COUNT(*) +@SLGV
			FROM GV_UVDT
			WHERE MSDT = @MSDT
		END
		ELSE 
		BEGIN
			PRINT N'Đề tài chưa được hoàn thành'
			RETURN 0
		END
		
		SET @DTB = @TONGDIEM/@SLGV
		BEGIN
			PRINT N'Điểm trung bình của đề tài ' + @MSDT + N' là: ' + CAST(@DTB AS VARCHAR(5))
		END
END 
-- 3.4 Thực thi
GO
DECLARE @dtb NUMERIC(5,2)
EXEC B3_Tinh_DTB '97003', @DTB = @dtb OUT

GO
DECLARE @dtb NUMERIC(5,2)
EXEC B3_Tinh_DTB '97005', @DTB = @dtb OUT

GO
DECLARE @dtb NUMERIC(5,2)
EXEC B3_Tinh_DTB '97009', @DTB = @dtb OUT

GO
DECLARE @dtb NUMERIC(5,2)
EXEC B3_Tinh_DTB '97006', @DTB = @dtb OUT


/*	5* .Tham số đưa vào: MSHD. Tham số trả ra: DTB_HD. 
	Yêu cầu: Đưa vào mã số hội đồng (MSHD), trả ra điểm trung bình các đề tài của hội đồng đó (DTB_HD)*/
CREATE PROC B3_Tinh_DTB_HD @MSHD INT, @DTB_HD NUMERIC(5,2) OUT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM HOIDONG_DT WHERE @MSHD = MSHD)
    BEGIN
        PRINT N'Không tìm thấy hội đồng'
        RETURN 0
    END
    ELSE
    BEGIN
        SELECT @DTB_HD = AVG(DIEM) 
		FROM (
			 SELECT HD.DIEM FROM HOIDONG_DT HT JOIN GV_HDDT HD ON HT.MSDT = HD.MSDT WHERE HT.MSHD = @MSHD
			 UNION ALL
			 SELECT PB.DIEM FROM HOIDONG_DT HT JOIN GV_PBDT PB ON HT.MSDT = PB.MSDT WHERE HT.MSHD = @MSHD
			 UNION ALL
			 SELECT UV.DIEM FROM HOIDONG_DT HT JOIN GV_UVDT UV ON HT.MSDT = UV.MSDT WHERE HT.MSHD = @MSHD
		) AS T

		PRINT N'Điểm trung bình của hội đồng ' + CAST(@MSHD AS VARCHAR(10)) + N' là: ' + CAST(@DTB_HD AS VARCHAR(5))
	END
END		

-- 4.5 Thực thi
GO
DECLARE @dtb_hd NUMERIC(5,2)
EXEC B3_Tinh_DTB_HD 1, @DTB_HD = @dtb_hd OUT

GO
DECLARE @dtb_hd NUMERIC(5,2)
EXEC B3_Tinh_DTB_HD 2, @DTB_HD = @dtb_hd OUT

GO
DECLARE @dtb_hd NUMERIC(5,2)
EXEC B3_Tinh_DTB_HD 3, @DTB_HD = @dtb_hd OUT

/*	6.Đưa vào TENGV và cho biết: Số đề tài hướng dẫn, số đề tài phản biện do giáo viên đó phụ trách. 
Nếu trùng tên thì có báo lỗi không hay hệ thống sẽ đếm tất cả các đề tài của những giáo viên trùng tên đó? Tại sao?
==> Nếu trùng sẽ không báo lỗi mà sẽ đếm tất cả đề tài. Do điều kiện WHERE trong các câu lệnh SELECT là TENGV = @TENGV, 
điều này sẽ khớp với tất cả các giáo viên có tên đã cho.
Làm sao để hiện thông báo có bao nhiêu giáo viên trùng tên và trả về thông tin được yêu cầu. 
Cần lưu ý gì với tham số vào không để không xảy ra lỗi tương tự hoặc tính hết các trường hợp để không báo lỗi và kết quả trả về đúng? 
*/
CREATE PROC B3_Dem_SLDT @TENGV NVARCHAR(30), @SLDT_HD INT OUT, @SLDT_PB INT OUT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM GIAOVIEN WHERE TENGV = @TENGV)
	BEGIN
		PRINT N'Không tìm thấy giáo viên'
		RETURN 0
	END
	ELSE
	BEGIN
		SELECT @SLDT_HD = COUNT(*) FROM GIAOVIEN GV JOIN GV_HDDT HD ON GV.MSGV = HD.MSGV
		WHERE TENGV = @TENGV

		SELECT @SLDT_PB = COUNT(*) FROM GIAOVIEN GV JOIN GV_PBDT PB ON GV.MSGV = PB.MSGV
		WHERE TENGV = @TENGV

		PRINT N'Số đề tài giáo viên ' + @TENGV + N' hướng dẫn là ' + CAST(@SLDT_HD AS VARCHAR(4))
		PRINT N'Số đề tài giáo viên ' + @TENGV + N' phản biện là ' + CAST(@SLDT_PB AS VARCHAR(4))
	END
END

-- 3.6 Thực thi và kiểm tra
INSERT INTO GV_HDDT VALUES ('00239', '97002', '9')
INSERT INTO GV_HDDT VALUES ('00239', '97005', '7')

GO 
DECLARE @sldt_hd INT, @sldt_pb INT 
EXEC B3_Dem_SLDT N'Trần Trung', @SLDT_HD = @sldt_hd OUT, @SLDT_PB = @sldt_pb OUT

						----KIỂM TRA TRÙNG TÊN---
CREATE PROC B3_Dem_SLDT_C2 @TENGV NVARCHAR(30), @SLDT_HD INT OUT, @SLDT_PB INT OUT
AS
BEGIN
    DECLARE @count1 INT = 0
    SELECT @count1 = COUNT(DISTINCT GV.MSGV) 
    FROM GIAOVIEN GV 
    JOIN  GV_HDDT HD ON GV.MSGV = HD.MSGV
    WHERE TENGV = @TENGV

    DECLARE @count2 INT = 0
    SELECT @count2 = COUNT(DISTINCT GV.MSGV) 
    FROM GIAOVIEN GV 
    JOIN  GV_PBDT PB ON GV.MSGV = PB.MSGV
    WHERE TENGV = @TENGV

    IF @count1 > 1
    BEGIN
        PRINT N'Có ' + CAST(@count1 AS NVARCHAR) + N' giáo viên hướng dẫn trùng tên'
        SELECT GV.MSGV, COUNT(*) FROM GIAOVIEN GV JOIN GV_HDDT HD ON GV.MSGV = HD.MSGV
        WHERE TENGV = @TENGV
        GROUP BY GV.MSGV
    END

    IF @count2 > 1
    BEGIN
        PRINT N'Có ' + CAST(@count2 AS NVARCHAR) + N' giáo viên phản biện trùng tên'
        SELECT GV.MSGV, COUNT(*) FROM GIAOVIEN GV JOIN GV_PBDT PB ON GV.MSGV = PB.MSGV
        WHERE TENGV = @TENGV
        GROUP BY GV.MSGV
    END

    IF @count1 = 1 OR @count2 = 1
    BEGIN
        SELECT @SLDT_HD = COUNT(*) FROM GIAOVIEN GV JOIN GV_HDDT HD ON GV.MSGV = HD.MSGV WHERE TENGV = @TENGV
        SELECT @SLDT_PB = COUNT(*) FROM GIAOVIEN GV JOIN GV_PBDT PB ON GV.MSGV = PB.MSGV WHERE TENGV = @TENGV
        PRINT N'Số đề tài giáo viên ' + @TENGV + N' hướng dẫn là ' + CAST(@SLDT_HD AS VARCHAR(4))
        PRINT N'Số đề tài giáo viên ' + @TENGV + N' phản biện là ' + CAST(@SLDT_PB AS VARCHAR(4))
    END
    ELSE
    BEGIN
        PRINT N'Không tìm thấy giáo viên'
        RETURN 0
    END
END


-- Phần 2. TRIGGER
-- 1.Tạo Trigger cho ràng buộc: Khi xóa MỘT đề tài thì xóa các thông tin liên quan.
CREATE TRIGGER KT_Xoa_DT
ON DETAI INSTEAD OF DELETE
AS 
BEGIN
	DECLARE @msdt CHAR(6)
	SELECT @msdt = MSDT FROM DELETED
	DELETE FROM SV_DETAI WHERE MSDT = @msdt
	DELETE FROM GV_HDDT WHERE MSDT = @msdt
	DELETE FROM GV_PBDT WHERE MSDT = @msdt
	DELETE FROM GV_UVDT WHERE MSDT = @msdt
	DELETE FROM HOIDONG_DT WHERE MSDT = @msdt
	DELETE FROM DETAI WHERE MSDT = @msdt
END

DELETE FROM DETAI WHERE MSDT = '97001'

		----KHI XÓA NHIỀU DETAI----
CREATE TRIGGER KT_Xoa_DT
ON DETAI INSTEAD OF DELETE
AS 
BEGIN
    DELETE FROM SV_DETAI WHERE MSDT IN (SELECT MSDT FROM DELETED)
    DELETE FROM GV_HDDT WHERE MSDT IN (SELECT MSDT FROM DELETED)
    DELETE FROM GV_PBDT WHERE MSDT IN (SELECT MSDT FROM DELETED)
    DELETE FROM GV_UVDT WHERE MSDT IN (SELECT MSDT FROM DELETED)
    DELETE FROM HOIDONG_DT WHERE MSDT IN (SELECT MSDT FROM DELETED)
    DELETE FROM DETAI WHERE MSDT IN (SELECT MSDT FROM DELETED)
END

/* 2.Tạo Trigger cho ràng buộc: Khi xóa một giáo viên thì xóa các thông tin liên quan. 
Thực thi với trường hợp: Xóa giáo viên có MSGV = ‘00203’. */
CREATE TRIGGER TRG_KT_Xoa_GV
ON GIAOVIEN INSTEAD OF DELETE
AS
BEGIN
    -- Vô hiệu hóa ràng buộc khóa ngoại
    ALTER TABLE HOIDONG_GV NOCHECK CONSTRAINT ALL
    ALTER TABLE HONGDONG NOCHECK CONSTRAINT ALL
	ALTER TABLE GV_UVDT NOCHECK CONSTRAINT ALL
	ALTER TABLE GV_PBDT NOCHECK CONSTRAINT ALL
	ALTER TABLE GV_HDDT NOCHECK CONSTRAINT ALL
	ALTER TABLE GV_HV_CN NOCHECK CONSTRAINT ALL


    -- Xóa thông tin liên quan từ các bảng khác
    DELETE FROM HOIDONG_GV WHERE MSGV IN (SELECT MSGV FROM DELETED)
    DELETE FROM HOIDONG WHERE MSGV IN (SELECT MSGV FROM DELETED)
    DELETE FROM GV_UVDT WHERE MSGV IN (SELECT MSGV FROM DELETED)
    DELETE FROM GV_PBDT WHERE MSGV IN (SELECT MSGV FROM DELETED)
    DELETE FROM GV_HDDT WHERE MSGV IN (SELECT MSGV FROM DELETED)
    DELETE FROM GV_HV_CN WHERE MSGV IN (SELECT MSGV FROM DELETED)

    -- Xóa giáo viên từ bảng GIAOVIEN
    DELETE FROM GIAOVIEN WHERE MSGV IN (SELECT MSGV FROM DELETED)

    -- Kích hoạt lại ràng buộc khóa ngoại
    ALTER TABLE HOIDONG_GV CHECK CONSTRAINT ALL
    ALTER TABLE HONGDONG CHECK CONSTRAINT ALL
	ALTER TABLE GV_UVDT CHECK CONSTRAINT ALL
	ALTER TABLE GV_PBDT CHECK CONSTRAINT ALL
	ALTER TABLE GV_HDDT CHECK CONSTRAINT ALL
	ALTER TABLE GV_HV_CN CHECK CONSTRAINT ALL
END

DELETE FROM GIAOVIEN WHERE MSGV = '00239'

/*3.Tạo Trigger cho ràng buộc: Mỗi hội đồng chấm không quá 3 đề tài. Thực thi với các trường hợp: 
	•Thêm dữ liệu mới:  
		oThêm đề tài có thông tin như sau: (MSDT, QUYETDINH) = (‘97004’, ‘Được’) vào hội đồng có MSHD = 1. 
		oThêm đề tài có thông tin như sau: (MSDT, QUYETDINH) = (‘97003’, ‘Được’) vào hội đồng có MSHD = 2. 
	•Sửa dữ liệu đã có: 
		oCập nhật MSHD = 1 cho đề tài có MSDT = ‘97004’ thuộc hội đồng 2. 
		oCập nhật MSHD = 3 cho đề tài có MSDT = ‘97005’ thuộc hội đồng 1. 
	* Dùng Group by có được không? Giải thích. */
-- Cau 3 -- 
CREATE TRIGGER TRG_KT_HD_DT 
ON HOIDONG_DT FOR INSERT, UPDATE 
AS
BEGIN
	DECLARE @SLDT INT = 0, @MSHD INT
	SELECT @MSHD = MSHD FROM INSERTED
	SELECT @SLDT = COUNT(*) FROM HOIDONG_DT WHERE MSHD = @MSHD

	IF @SLDT > 3
	BEGIN
        RAISERROR (N'Thêm đề tài thất bại. Hội đồng %d đã có đủ đề tài.', 16, 1, @MSHD)
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		PRINT N'Thêm đề tài thành công.'
	END
END
-- P2.1 Thực thi
		-- Thêm dữ liệu --
INSERT INTO HOIDONG_DT VALUES ('1', '97004', N'Được') 
INSERT INTO HOIDONG_DT VALUES ('2', '97003', N'Được') 
		-- Sửa dữ liệu -- 
UPDATE HOIDONG_DT SET MSHD = '1' WHERE MSDT = '97003' AND MSHD = '2'
UPDATE HOIDONG_DT SET MSHD = '1' WHERE MSDT = '97005' AND MSHD = '3'

SELECT * FROM HOIDONG_DT
/* 4.Tạo Trigger cho ràng buộc: Mỗi đề tài có không quá 3 sinh viên tham gia. 
	Dùng Group by có được không? Giải thích.*/
CREATE TRIGGER TRG_KT_SV_DT
ON SV_DETAI FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @SLSV INT = 0, @MSDT CHAR(6)
	SELECT @MSDT = MSDT FROM INSERTED
	SELECT @SLSV = COUNT (*) FROM SV_DETAI WHERE @MSDT = MSDT

	IF @SLSV > 3
	BEGIN
		RAISERROR (N'Thêm sinh viên thất bại. Đề tài %d đã có đủ sinh viên tham gia.', 16, 1, @MSDT)
		ROLLBACK TRANSACTION
	END
	ELSE
		PRINT N'Thêm sinh viên thành công'
END

SELECT * FROM SV_DETAI

/*	5.Tạo Trigger cho ràng buộc: Mỗi sinh viên chỉ được tham gia một đề tài. 
	Thực thi với các trường hợp: 
	•	Thêm dữ liệu mới:  
		o	Thêm thông tin thực hiện đề tài như sau: (MSSV, MSDT) = (‘13520001’, ‘97003’). 
		o	Thêm thông tin thực hiện đề tài như sau: (MSSV, MSDT) = (‘13520004’, ‘97006’). 
	•	Sửa dữ liệu đã có: 
		o	Chuyển đề tài có MSDT = ‘97001’ từ sinh viên có MSSV = ‘13520003’ sang sinh viên có MSSV = ‘13520001’. 
		o	Chuyển đề tài có MSDT = ‘97004’ từ sinh viên có MSSV = ‘13520001’ sang sinh viên có MSSV = ‘13520005’. */
-- Cau 5
CREATE TRIGGER TRG_KT_SV_SLDT 
ON SV_DETAI FOR INSERT, UPDATE
AS 
BEGIN 
	DECLARE @SLDT INT, @MSSV CHAR(8)
	SELECT @MSSV = MSSV FROM INSERTED
	SELECT @SLDT = COUNT(*) FROM SV_DETAI WHERE MSSV = @MSSV

	IF @SLDT > 1
	BEGIN
		RAISERROR (N'Thêm dữ liệu thất bại. Mỗi sinh viên chỉ được tham gia một đề tài', 16, 1)
		ROLLBACK TRANSACTION
	END
	ELSE
		PRINT N'Thêm dữ liệu thành công'
END

-- P2.5 Thực thi
			-- Thêm dữ liệu 
INSERT INTO SV_DETAI VALUES ('13520001', '97003')
INSERT INTO SV_DETAI VALUES ('13520004', '97006')

			-- Sửa dữ liệu 
UPDATE SV_DETAI SET MSSV = '13520001' WHERE MSDT = '97001' AND MSSV = '13520003'
UPDATE SV_DETAI SET MSSV = '13520005' WHERE MSDT = '97004' AND MSSV = '13520001'

-- 6.*Tạo Trigger cho ràng buộc: Một giáo viên muốn có học hàm PGS thì giáo viên đó phải là tiến sĩ. 
CREATE TRIGGER TRG_KT_HH_HV
ON GIAOVIEN FOR INSERT, UPDATE
AS
BEGIN
IF EXISTS ( SELECT * FROM INSERTED WHERE MSHH=1 AND NOT EXISTS( SELECT * FROM GV_HV_CN WHERE INSERTED.MSGV=GV_HV_CN.MSGV  AND MSHV=4 ))	

-- 7.*Tạo Trigger cho ràng buộc: Năm nhận học vị phải nhỏ hơn hoặc bằng năm nhận học hàm. 

-- Phần 3. HÀM

/*	1.Viết hàm in ra thông tin sinh viên (TENSV, SODT, LOP, DIACHI) có mã số sinh viên (MSSV) được truyền vào. 
	Thực thi với các trường hợp: 
		•	Truyền vào MSSV = ‘13520001’. 
		•	Truyền vào MSSV = ‘13520005’. 
		•	Truyền vào MSSV = ‘13520008’. 
*/

/*	2.	Viết hàm in ra danh sách sinh viên (TENSV) sinh sống tại địa chỉ (DIACHI) được truyền vào. 
	Thực thi với các trường hợp: 
	•	Truyền vào DIACHI = ‘QUẬN 1’. 
	•	Truyền vào DIACHI = ‘THỦ ĐỨC’. 
	•	Truyền vào DIACHI = ‘GÒ VẤP’.
*/


/*	3.	Viết hàm in ra danh sách sinh viên thực hiện đề tài (MSSV, TENSV) có mã số đề tài (MSDT) được truyền vào. 
	Thực thi với các trường hợp: 
	•	Truyền vào MSDT = ‘97004’. 
	•	Truyền vào MSDT = ‘97005’. 
	•	Truyền vào MSDT = ‘97011’. 
*/

--	4.Viết hàm in ra danh sách giảng viên (MSGV, TENGV) có phản biện đề tài. 

/*	5.Viết hàm đếm số lượng giáo viên (SLGV) đạt học vị (TENHV) được truyền vào. Nếu không tìm thấy học vị tương ứng thì trả về giá trị ‒1. 
	Thực thi với các trường hợp: 
	•	Truyền vào TENHV = ‘Bác sĩ’.
	•	Truyền vào TENHV = ‘Kỹ sư’. 
	•	Truyền vào TENHV = ‘Thạc sĩ’. 
*/


/*	6.	Viết hàm tính điểm trung bình của đề tài có mã số đề tài (MSDT) được truyền vào (Kết quả làm tròn đến hai chữ số thập phân). Trường hợp không có điểm thì điểm trung bình sẽ là 0. 
Thực thi với các trường hợp: 
•	Truyền vào MSDT = ‘97001’.
•	Truyền vào MSDT = ‘97004’
•	Truyền vào MSDT = ‘97006’.
*/


/*	7.	*Viết hàm xếp loại kết quả của đề tài có mã số đề tài (MSDT) được truyền vào:
•	Kết quả là ‘ĐẠT’ nếu điểm trung bình từ 5 trở lên. 
•	Kết quả là ‘KHÔNG ĐẠT’ nếu điểm trung bình dưới 5. 
Thực thi với các trường hợp: 
•	Truyền vào MSDT = ‘97001’. 
•	Truyền vào MSDT = ‘97004’. 
•	Truyền vào MSDT = ‘97006’. 
*/


--	Phần 4. CON TRỎ

-- Bài tập 1* 

-- 1.	Với những sinh viên tham gia lớp có mã lớp (LOP) bắt đầu bằng ký hiệu ‘IE’, liệt kê MSSV, TENSV và mã lớp (LOP) mà sinh viên đó tham gia. 
-- 2.	Cho biết số lượng sinh viên sống ở ‘QUẬN 1’ (DIACHI). 
-- 3.	Cho biết danh sách giáo viên gồm MSGV, TENGV, DIACHI, SODT, TENHH của từng giáo viên. 
-- 4.	Cho biết danh sách đề tài gồm MSDT, TENDT và số lượng sinh viên thực hiện của mỗi đề tài (nếu có).
-- 5.	Cho biết số lượng đề tài (SLDT) đã hướng dẫn ứng với từng giáo viên (TENGV).
-- 6.	Liệt kê danh sách giáo viên (MSGV, TENGV) chưa hướng dẫn đề tài nào. 

-- Bài tập 2* 
-- Trong cơ sở dữ liệu Quản lý đề tài, tạo một bảng tên là DETAI_DIEM với cấu trúc như sau: DETAI_DIEM (MSDT, DIEMTB) 
-- 1.	Khai báo con trỏ dùng để tính điểm trung bình cho từng đề tài, sau đó lưu kết quả vào bảng DETAI_DIEM. 
-- 2.	Gom các bước xử lý của con trỏ ở câu 1 vào một thủ tục lưu trữ. 
/*3.	Tạo thêm cột XEPLOAI có kiểu là NVARCHAR(20) trong bảng DETAI_DIEM, viết Cursor cập nhật kết quả xếp loại cho mỗi đề tài như sau: 
•	“Xuất sắc”: Điểm trung bình từ 9 đến 10. 
•	“Giỏi”: Điểm trung bình từ 8 đến 9. 
•	“Khá”: Điểm trung bình từ 6.5 đến 8. 
•	“Trung bình”: Điểm trung bình từ 5 đến 6.5. 
•	“Không đạt”: Điểm trung bình dưới 5.
*/