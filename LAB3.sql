-------------------------------------------------------BUỔI 2-----------------------------------------
-- Phần 3. HÀM
--	1.Viết hàm in ra thông tin sinh viên (TENSV, SODT, LOP, DIACHI) có mã số sinh viên (MSSV) được truyền vào. 
CREATE FUNCTION FUNC_In_DSSV(@MSSV CHAR(8))
RETURNS TABLE
AS
RETURN 
(
    SELECT TENSV, SODT, LOP, DIACHI
    FROM SINHVIEN
    WHERE MSSV = @MSSV
)

-- P3.1 Thực thi
GO
SELECT * FROM FUNC_In_DSSV('13520001')
SELECT * FROM FUNC_In_DSSV('13520005')
SELECT * FROM FUNC_In_DSSV('13520008')
	
-- 2.	Viết hàm in ra danh sách sinh viên (TENSV) sinh sống tại địa chỉ (DIACHI) được truyền vào. 
CREATE FUNCTION FUNC_In_DSSV_DC(@DIACHI NCHAR(50))
RETURNS TABLE
AS
RETURN ( SELECT TENSV FROM SINHVIEN WHERE DIACHI = @DIACHI)

-- P3.2 Thực thi
SELECT * FROM FUNC_In_DSSV_DC(N'QUẬN 1')
SELECT * FROM FUNC_In_DSSV_DC(N'THỦ ĐỨC')
SELECT * FROM FUNC_In_DSSV_DC(N'GÒ VẤP')

/*	3.	Viết hàm in ra danh sách sinh viên thực hiện đề tài (MSSV, TENSV) có mã số đề tài (MSDT) được truyền vào. 
	Thực thi với các trường hợp: 
	•	Truyền vào MSDT = ‘97004’. 
	•	Truyền vào MSDT = ‘97005’. 
	•	Truyền vào MSDT = ‘97011’. 
*/
CREATE FUNCTION FUNC_In_DSSV_DT(@MSDT CHAR(6))
RETURNS TABLE
AS
RETURN 
(
	SELECT S.MSSV, TENSV
	FROM SINHVIEN S JOIN SV_DETAI D ON S.MSSV = D.MSSV
	WHERE MSDT = @MSDT
)	

-- P3.3 Thực thi
SELECT * FROM FUNC_In_DSSV_DT('97004')
SELECT * FROM FUNC_In_DSSV_DT('97005')
SELECT * FROM FUNC_In_DSSV_DT('97011')

--	4.Viết hàm in ra danh sách giảng viên (MSGV, TENGV) có phản biện đề tài. 
CREATE FUNCTION FUNC_In_DSGV_PB()
RETURNS TABLE
AS
RETURN
(
	SELECT G.MSGV, TENGV
	FROM GIAOVIEN G JOIN GV_PBDT P ON G.MSGV = P.MSGV
)

-- CACH 2
CREATE FUNCTION FUNC_In_DSGV_PB_C2()
RETURNS TABLE
AS
RETURN
(
	SELECT MSGV, TENGV
	FROM GIAOVIEN
	WHERE MSGV IN (SELECT MSGV FROM GV_PBDT)
)
SELECT * FROM FUNC_In_DSGV_PB()
--	5.Viết hàm đếm số lượng giáo viên (SLGV) đạt học vị (TENHV) được truyền vào. Nếu không tìm thấy học vị tương ứng thì trả về giá trị ‒1. 
CREATE FUNCTION FUNC_Dem_SLGV_HV(@TENHV NVARCHAR(20))
RETURNS INT
AS
BEGIN
	DECLARE @SLGV INT
		
	SELECT @SLGV = COUNT(*) FROM GV_HV_CN GH
	JOIN GIAOVIEN GV ON GV.MSGV = GH.MSGV
	JOIN HOCVI HV ON HV.MSHV = GH.MSHV
	WHERE TENHV = @TENHV

	IF @SLGV IS NULL
	SET @SLGV = -1

RETURN @SLGV
END
-- P3.5 Thực thi
SELECT dbo.FUNC_Dem_SLGV_HV(N'Bác sĩ')
SELECT dbo.FUNC_Dem_SLGV_HV(N'Kỹ sư')
SELECT dbo.FUNC_Dem_SLGV_HV(N'Thạc sĩ')

--	6.	Viết hàm tính điểm trung bình của đề tài có mã số đề tài (MSDT) được truyền vào (Kết quả làm tròn đến hai chữ số thập phân). 
-- Trường hợp không có điểm thì điểm trung bình sẽ là 0. 
CREATE FUNCTION FUNC_Tinh_DTB(@MSDT CHAR(6))
RETURNS NUMERIC(5,2)
AS
BEGIN
	DECLARE @DTB NUMERIC(5,2)
	SELECT @DTB = AVG(DIEM) 
	FROM
	(
		SELECT DIEM FROM GV_HDDT WHERE MSDT = @MSDT
		UNION ALL
		SELECT DIEM FROM GV_PBDT WHERE MSDT = @MSDT
		UNION ALL
		SELECT DIEM FROM GV_UVDT WHERE MSDT = @MSDT
	) AS T
	IF @DTB IS NULL
	SET @DTB = 0
RETURN ROUND(@DTB, 2)
END

-- P3.6 Thực thi
SELECT dbo.FUNC_Tinh_DTB('97001')
SELECT dbo.FUNC_Tinh_DTB('97004')
SELECT dbo.FUNC_Tinh_DTB('97006')

/*	7.	*Viết hàm xếp loại kết quả của đề tài có mã số đề tài (MSDT) được truyền vào:
•	Kết quả là ‘ĐẠT’ nếu điểm trung bình từ 5 trở lên. 
•	Kết quả là ‘KHÔNG ĐẠT’ nếu điểm trung bình dưới 5. 
Thực thi với các trường hợp: 
•	Truyền vào MSDT = ‘97001’. 
•	Truyền vào MSDT = ‘97004’. 
•	Truyền vào MSDT = ‘97006’. 
*/
CREATE FUNCTION FUNC_XEPLOAI_DT(@MSDT CHAR(6))
RETURNS NVARCHAR(20)
AS
BEGIN
	DECLARE @DTB NUMERIC(5,2)
	DECLARE @XEPLOAI NVARCHAR(20)
	SELECT @DTB = AVG(DIEM) 
	FROM
	(
		SELECT DIEM FROM GV_HDDT WHERE MSDT = @MSDT
		UNION ALL
		SELECT DIEM FROM GV_PBDT WHERE MSDT = @MSDT
		UNION ALL
		SELECT DIEM FROM GV_UVDT WHERE MSDT = @MSDT
	) AS T

	IF @DTB >= 5
		SET @XEPLOAI = N'ĐẠT'
	ELSE 
		SET @XEPLOAI = N'KHÔNG ĐẠT'

	RETURN @XEPLOAI
END

-- C2 --
CREATE FUNCTION FUNC_XEPLOAI_DT_C2(@MSDT CHAR(6))
RETURNS NVARCHAR(20)
AS
BEGIN
	DECLARE @DTB NUMERIC(5,2)
	SELECT @DTB = dbo.FUNC_Tinh_DTB(@MSDT)
	
	IF @DTB >= 5
		RETURN N'ĐẠT'
	RETURN N'KHÔNG ĐẠT'
END

-- P3.7 Thực thi
SELECT dbo.FUNC_XEPLOAI_DT('97001')
SELECT dbo.FUNC_XEPLOAI_DT('97004')
SELECT dbo.FUNC_XEPLOAI_DT('97006')


-------------------------------------------------------BUỔI 3-----------------------------------------
-- Bài tập 1: Login
-- 1. Tạo các tài khoản login
CREATE LOGIN quynhttp WITH PASSWORD = '22521235'
CREATE LOGIN quynhttp_master WITH PASSWORD = '22521235', DEFAULT_DATABASE = master
CREATE LOGIN quynhttp_qldt WITH PASSWORD = '22521235', DEFAULT_DATABASE = QLDT

SELECT * FROM sys.syslogins

-- Bài tập 2. User và role 
-- 1. Tạo 2 user SV1 và SV2 lần lượt cho tài khoản login 1 và 2.
CREATE USER SV1 FOR LOGIN quynhttp
CREATE USER SV2 FOR LOGIN quynhttp_master

SELECT * FROM sys.sysusers

-- 2. Tạo 2 role LopTruong và LopPho, sau đó thêm user SV1 vào role LopTruong cho và user SV2 vào role LopPho. 
CREATE ROLE LopTruong 
CREATE ROLE LopPho 

EXEC sp_addrolemember LopTruong, SV1
EXEC sp_addrolemember LopPho, SV2

-- 3. Tạo user SV3 cho tài khoản login 3, sau đó thêm user SV3 vào role db_Owner và role db_DataReader của cơ sở dữ liệu Quản lý đề tài. 
CREATE USER SV3 FOR LOGIN quynhttp_qldt 

EXEC sp_addrolemember db_Owner, SV3
EXEC sp_addrolemember db_DataReader, SV3

SELECT * FROM sys.sysusers
-- 4. Xóa các user đã tạo ở các câu trên.
DROP USER SV1
DROP USER SV2

USE QLDT
DROP USER SV3

SELECT * FROM sys.sysusers

-- 5. Xóa tài khoản login 2 và 3 đã tạo ở câu a1.
USE master
DROP LOGIN quynhttp_master

USE QLDT
DROP LOGIN quynhttp_qldt
SELECT * FROM sys.syslogins

-- Bài tập 3. Vận dụng 1: Xác thực người dùng 
-- Câu 1. Tạo 6 login từ l1 đến l6 không có mật khẩu.
CREATE LOGIN l1 WITH PASSWORD = '22521235'
CREATE LOGIN l2 WITH PASSWORD = '22521235'
CREATE LOGIN l3 WITH PASSWORD = '22521235'
CREATE LOGIN l4 WITH PASSWORD = '22521235'
CREATE LOGIN l5 WITH PASSWORD = '22521235'
CREATE LOGIN l6 WITH PASSWORD = '22521235'
SELECT * FROM sys.syslogins

-- Câu 2. Tạo 6 user từ u1 đến u6 lần lượt tương ứng với 6 login đã tạo ở trên.
CREATE USER u1 FOR LOGIN l1
CREATE USER u2 FOR LOGIN l2
CREATE USER u3 FOR LOGIN l3
CREATE USER u4 FOR LOGIN l4
CREATE USER u5 FOR LOGIN l5
CREATE USER u6 FOR LOGIN l6

-- Câu 3. Tạo 3 role từ r1 đến r3.
CREATE ROLE r1
CREATE ROLE r2
CREATE ROLE r3

/* Câu 4. Tạo nhóm như sau:
•	u1 thuộc r1.
•	u2, u3 thuộc r2.
•	u4, u5, u6 thuộc r3.*/
EXEC sp_addrolemember r1, u1

EXEC sp_addrolemember r2, u2
EXEC sp_addrolemember r2, u3

EXEC sp_addrolemember r3, u4
EXEC sp_addrolemember r3, u5
EXEC sp_addrolemember r3, u6

/* Câu 5.	Thực hiện: 
•	r1 thành viên của db_DataReader.
•	r2 thành viên của db_Owner, db_Accessadmin.
•	r3 thành viên của db_SecurityAdmin, db_Owner, db_Accessadmin. */

EXEC sp_addrolemember db_DataReader, r1

EXEC sp_addrolemember db_Owner, r2
EXEC sp_addrolemember db_Accessadmin, r2

EXEC sp_addrolemember db_SecurityAdmin, r3
EXEC sp_addrolemember db_Owner, r3
EXEC sp_addrolemember db_Accessadmin, r3


-- Bài tập 4. Phân quyền người dùng
-- Tập làm các phát biểu grant, deny, revoke trên cơ sở dữ liệu AAA. 
-- 1.	Tạo các bảng T1, T2, T3 với các cột như sau:
CREATE TABLE T1(
	C11 INT PRIMARY KEY,
	C12 VARCHAR(10)
)

CREATE TABLE T2(
	C21 INT PRIMARY KEY,
	C22 VARCHAR(10)
)
CREATE TABLE T3(
	C31 INT PRIMARY KEY,
	C32 VARCHAR(10)
)
-- Câu 2.	Tạo các login Lo1, Lo2, Lo3 không có mật khẩu. 
CREATE LOGIN Lo1 WITH PASSWORD = '22521235'
CREATE LOGIN Lo2 WITH PASSWORD = '22521235'
CREATE LOGIN Lo3 WITH PASSWORD = '22521235'
SELECT * FROM sys.syslogins

-- Câu 3. Tạo các user Us1, Us2, Us3 lần lượt tương ứng với các login đã tạo ở trên.
CREATE USER Us1 FOR LOGIN Lo1
CREATE USER Us2 FOR LOGIN Lo2
CREATE USER Us3 FOR LOGIN Lo3

/* Câu 4.	Phân quyền cho các user như sau:
•	Us1 có quyền Select, Delete trên T1, T3.
•	Us2 có quyền Update, Delete trên T2.
•	Us3 có quyền Insert trên T1, T2, T3.
•	Us1 bị từ chối quyền Insert trên T1, T2.
•	Us2 bị từ chối quyền Delete trên T3.*/
GRANT SELECT, DELETE ON T1 TO Us1
GRANT SELECT, DELETE ON T3 TO Us1

GRANT UPDATE, DELETE ON T2 TO Us2

GRANT INSERT ON T1 TO Us3
GRANT INSERT ON T2 TO Us3
GRANT INSERT ON T3 TO Us3

DENY INSERT ON T1 TO Us1
DENY INSERT ON T2 TO Us1

DENY DELETE ON T3 TO Us2

-- 5.	Thu hồi quyền đã cấp đối với tất cả các user
REVOKE SELECT, DELETE ON T1 TO Us1
REVOKE SELECT, DELETE ON T3 TO Us1

REVOKE UPDATE, DELETE ON T2 TO Us2

REVOKE INSERT ON T1 TO Us3
REVOKE INSERT ON T2 TO Us3
REVOKE INSERT ON T3 TO Us3

-- Bài tập 5. Vận dụng 2: Quản lý giáo vụ 
-- Câu 1. Tạo 3 user: Giaovien, Giaovu và Sinhvien tương ứng với các login có cùng tên và password là tên user viết in hoa
-- Tạo login
CREATE LOGIN Giaovien WITH PASSWORD = 'GIAOVIEN', DEFAULT_DATABASE = QLDT
CREATE LOGIN Giaovu WITH PASSWORD = 'GIAOVU', DEFAULT_DATABASE = QLDT
CREATE LOGIN Sinhvien WITH PASSWORD = 'SINHVIEN', DEFAULT_DATABASE = QLDT

-- Tạo user
CREATE USER Giaovien FOR LOGIN Giaovien
CREATE USER Giaovu FOR LOGIN Giaovu
CREATE USER Sinhvien FOR LOGIN Sinhvien

-- Câu 2. Phân quyền cho các user như sau 
-- • Giaovu có quyền xem và chỉnh sửa trên tất cả các bảng.
GRANT SELECT, UPDATE ON DATABASE::QLDT TO Giaovu

-- • Giaovien có quyền xem thông tin giáo viên, thông tin sinh viên, các đề tài mà Giaovien hướng dẫn, phản biện hay làm uỷ viên, và xem thông tin hội đồng; Giaovien có quyền cập nhật thông tin của giáo viên.
GRANT SELECT ON GIAOVIEN TO Giaovien
GRANT SELECT ON SINHVIEN TO Giaovien

GRANT SELECT ON GV_HDDT TO Giaovien 
GRANT SELECT ON GV_PBDT TO Giaovien
GRANT SELECT ON GV_UVDT TO Giaovien
GRANT SELECT ON HOIDONG TO Giaovien

GRANT UPDATE ON GIAOVIEN TO Giaovien

-- • Sinhvien có quyền xem thông tin của sinh viên, của hội đồng và các đề tài hiện hữu trên hệ thống.
GRANT SELECT ON SINHVIEN TO Sinhvien
GRANT SELECT ON HOIDONG TO Sinhvien
GRANT SELECT ON DETAI TO Sinhvien

-- •Tất cả người dùng đều không có quyền xoá thông tin.
DENY DELETE ON DATABASE::QLDT TO PUBLIC

-- Câu 3. Thu hồi quyền đã cấp đối với tất cả các user, sau đó chụp lại hộp thoại Database User. 
REVOKE SELECT, UPDATE ON DATABASE::QLDT TO Giaovu

REVOKE SELECT ON GIAOVIEN TO Giaovien
REVOKE SELECT ON SINHVIEN TO Giaovien

REVOKE SELECT ON GV_HDDT TO Giaovien 
REVOKE SELECT ON GV_PBDT TO Giaovien
REVOKE SELECT ON GV_UVDT TO Giaovien
REVOKE SELECT ON HOIDONG TO Giaovien

REVOKE UPDATE ON GIAOVIEN TO Giaovien

REVOKE SELECT ON SINHVIEN TO Sinhvien
REVOKE SELECT ON HOIDONG TO Sinhvien
REVOKE SELECT ON DETAI TO Sinhvien

REVOKE DELETE ON DATABASE::QLDT TO PUBLIC

-- Bài tập 6. Vận dụng 3: Quản lý công ty 
/* Câu 1. Tạo cơ sở dữ liệu Company và bảng Attendance
Attendance (
ID Int Primary Key, 
Name Varchar(5) 
) */
CREATE DATABASE Company
USE Company

CREATE TABLE Attendance(
	ID INT PRIMARY KEY,
	NAME VARCHAR(5)
)
-- Câu 2. Tạo các user: John, Joe, Fred, Lynn, Amy và Beth tương ứng với các login có cùng tên và password là tên user viết in hoa, sau đó chụp lại bảng Syslogins và hộp thoại Database Properties.
CREATE LOGIN John WITH PASSWORD = 'JOHN', DEFAULT_DATABASE = Company
CREATE USER John FOR LOGIN John

CREATE LOGIN Joe WITH PASSWORD = 'JOE', DEFAULT_DATABASE = Company
CREATE USER Joe FOR LOGIN Joe

CREATE LOGIN Fred WITH PASSWORD = 'FRED', DEFAULT_DATABASE = Company
CREATE USER Fred FOR LOGIN Fred

CREATE LOGIN Lynn WITH PASSWORD = 'LYNN', DEFAULT_DATABASE = Company
CREATE USER Lynn FOR LOGIN Lynn

CREATE LOGIN Amy WITH PASSWORD = 'AMY', DEFAULT_DATABASE = Company
CREATE USER Amy FOR LOGIN Amy

CREATE LOGIN Beth WITH PASSWORD = 'BETH', DEFAULT_DATABASE = Company
CREATE USER Beth FOR LOGIN Beth

SELECT * FROM sys.syslogins

/* Câu 3. Tạo các role: DataEntry, Supervisor, Management và thực hiện tạo nhóm 
•	Thêm John, Joe và Lynn vào role DataEntry.
•	Thêm Fred vào role Supervisor.
•	Thêm Amy và Beth vào role Management.*/
CREATE ROLE DataEntry 
CREATE ROLE Supervisor
CREATE ROLE Management

EXEC sp_addrolemember DataEntry, John
EXEC sp_addrolemember DataEntry, Joe
EXEC sp_addrolemember DataEntry, Lynn

EXEC sp_addrolemember Supervisor, Fred

EXEC sp_addrolemember Management, Amy
EXEC sp_addrolemember Management, Beth

/* Câu 4. Thực hiện phân quyền cho các role như sau:
•	Cấp quyền cho role DataEntry các quyền Select, Insert và Update trên bảng Attendance.
•	Cấp quyền cho role Supervisor các quyền Select và Delete trên bảng Attendance.
•	Cấp quyền cho role Management quyền Select trên bảng Attendance.*/
GRANT SELECT, INSERT, UPDATE ON Attendance TO DataEntry
GRANT SELECT, DELETE ON Attendance TO Supervisor
GRANT SELECT ON Attendance TO Management

-- Câu 5. *Tạo user có tên NameManager tương ứng với login có cùng tên và có password là pc123. 
CREATE LOGIN NameManager WITH PASSWORD = 'pc123', DEFAULT_DATABASE = Company
CREATE USER NameManager FOR LOGIN NameManager

-- Cấp quyền Update cho user này trên cột Name của bảng Attendance
GRANT UPDATE(Name) ON Attendance TO NameManager

select* from sys.syslogins
select* from sys.sysusers