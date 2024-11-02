-- 1. Tạo dữ liệu test như sau:
CREATE DATABASE TEST_XML
GO
USE TEST_XML
GO
CREATE TABLE KhoaHoc(
	MaKhoaHoc INT IDENTITY(1,1)NOT NULL,
	TenKhoaHoc VARCHAR(200) NOT NULL,
	CONSTRAINT PK_KhoaHoc PRIMARY KEY(MaKhoaHoc)
)

INSERT INTO KhoaHoc (TenKhoaHoc) SELECT 'Mang May Tinh Truyen Thong'
INSERT INTO KhoaHoc (TenKhoaHoc) SELECT 'Khoa Hoc May Tinh'
INSERT INTO KhoaHoc (TenKhoaHoc) SELECT 'Ky Thuat May Tinh'

CREATE TABLE SinhVien(
	MSSV BIGINT IDENTITY(1,1)NOT NULL CONSTRAINT PK_SinhVien PRIMARY KEY(MSSV),
	TenSV VARCHAR(200) NOT NULL,
	MaKhoaHoc INT NOT NULL CONSTRAINT FK_SinhVien_MaKhoaHoc
	FOREIGN KEY REFERENCES KhoaHoc(MaKhoaHoc)
)
INSERT INTO SinhVien SELECT 'Sang',1 
INSERT INTO SinhVien SELECT 'Duy',2 
INSERT INTO SinhVien SELECT 'Sa', 3

CREATE TABLE MonHoc(
	MaMonHoc INT IDENTITY NOT NULL CONSTRAINT PK_MonHoc PRIMARY
	KEY(MaMonHoc),
	TenMonHoc VARCHAR(200)
)
INSERT INTO MonHoc (TenMonHoc) SELECT ('Co So Du Lieu')
INSERT INTO MonHoc (TenMonHoc) SELECT ('Cau Truc Du Lieu')
INSERT INTO MonHoc (TenMonHoc) SELECT ('Lap Trinh Di Dong')
INSERT INTO MonHoc (TenMonHoc) SELECT ('Toan Giai Tich')
INSERT INTO MonHoc (TenMonHoc) SELECT ('Lap Trinh Java')
INSERT INTO MonHoc (TenMonHoc) SELECT ('He Quan Tri CSDL')
INSERT INTO MonHoc (TenMonHoc) SELECT ('Anh Van')
INSERT INTO MonHoc (TenMonHoc) SELECT ('Thiet Ke Web ')
INSERT INTO MonHoc (TenMonHoc) SELECT ('An Toan Thong Tin')

CREATE TABLE KhoaHocMonHoc(
	MaKhoaHoc INT CONSTRAINT FK_KhoaHocMonHoc_MaKhoaHoc FOREIGN KEY REFERENCES KhoaHoc(MaKhoaHoc),
	MaMonHoc INT CONSTRAINT FK_KhoaHocMonHoc_MaMonHoc FOREIGN KEY REFERENCES MonHoc(MaMonHoc)
)

INSERT INTO KhoaHocMonHoc (MaKhoaHoc,MaMonHoc) SELECT 1,1 
INSERT INTO KhoaHocMonHoc (MaKhoaHoc,MaMonHoc) SELECT 1,2 
INSERT INTO KhoaHocMonHoc (MaKhoaHoc,MaMonHoc) SELECT 1,3 
INSERT INTO KhoaHocMonHoc (MaKhoaHoc,MaMonHoc) SELECT 2,4 
INSERT INTO KhoaHocMonHoc (MaKhoaHoc,MaMonHoc) SELECT 2,5 
INSERT INTO KhoaHocMonHoc (MaKhoaHoc,MaMonHoc) SELECT 2,6 
INSERT INTO KhoaHocMonHoc (MaKhoaHoc,MaMonHoc) SELECT 3,7 
INSERT INTO KhoaHocMonHoc (MaKhoaHoc,MaMonHoc) SELECT 3,8 
INSERT INTO KhoaHocMonHoc (MaKhoaHoc,MaMonHoc) SELECT 3,9 

CREATE TABLE Diem(
	MSSV BIGINT CONSTRAINT FK_Diem_MSSV FOREIGN KEY REFERENCES SinhVien(MSSV),
	MaMonHoc INT CONSTRAINT FK_Diem_MaMonHoc FOREIGN KEY REFERENCES MonHoc(MaMonHoc),
	Diem INT
)

INSERT INTO Diem (MSSV,MaMonHoc,Diem) SELECT 1,1,75 
INSERT INTO Diem (MSSV,MaMonHoc,Diem) SELECT 1,2,80 
INSERT INTO Diem (MSSV,MaMonHoc,Diem) SELECT 1,3,70 
INSERT INTO Diem (MSSV,MaMonHoc,Diem) SELECT 2,4,80 
INSERT INTO Diem (MSSV,MaMonHoc,Diem) SELECT 2,5,80 
INSERT INTO Diem (MSSV,MaMonHoc,Diem) SELECT 2,6,90 
INSERT INTO Diem (MSSV,MaMonHoc,Diem) SELECT 3,7,80 
INSERT INTO Diem (MSSV,MaMonHoc,Diem) SELECT 3,8,80 
INSERT INTO Diem (MSSV,MaMonHoc,Diem) SELECT 3,9,90

CREATE TABLE QuanLySV(
	MSDH INT NOT NULL,
	TenDH VARCHAR(20),
	ChiTietSV XML
)

INSERT INTO QuanLySV VALUES
(1,'DH CNTT','<THONGTINSV> 
	<sinhvien ID="10" Ten="Nam"> 
		<monhoc ID="1" Ten="Co So Du Lieu" /> 
		<monhoc ID="2" Ten="Cau Truc Du Lieu" /> 
		<monhoc ID="3" Ten="Lap Trinh Mobile" /> 
	</sinhvien> 
	<sinhvien ID="11" Ten="An"> 
		<monhoc ID="4" Ten="Toan Giai Tich" />
		<monhoc ID="5" Ten="Lap Trinh Java" /> 
		<monhoc ID="6" Ten="He Quan Tri CSDL" />
	</sinhvien> 
	<sinhvien ID="12" Ten="Thanh"> 
		<monhoc ID="7" Ten="Anh Van" /> 
		<monhoc ID="8" Ten="Thiet Ke Web" /> 
		<monhoc ID="9" Ten="An Toan Thong Tin" /> 
	</sinhvien> 
	</THONGTINSV>'
)

INSERT INTO QuanLySV VALUES
(2,'DH KHTN','<THONGTINSV> 
	<sinhvien ID="10" Ten="Khang"> 
		<monhoc ID="1" Ten="Co So Du Lieu" /> 
		<monhoc ID="2" Ten="Cau Truc Du Lieu" /> 
		<monhoc ID="3" Ten="Lap Trinh Mobile" />
	</sinhvien> 
	<sinhvien ID="11" Ten="Vinh"> 
		<monhoc ID="4" Ten="Toan Giai Tich" />
		<monhoc ID="5" Ten="Lap Trinh Java" /> 
		<monhoc ID="6" Ten="He Quan Tri CSDL" />
	</sinhvien> 
	<sinhvien ID="12" Ten="Hoa"> 
		<monhoc ID="7" Ten="Anh Van" /> 
		<monhoc ID="8" Ten="Thiet Ke Web" /> 
		<monhoc ID="9" Ten="An Toan Thong Tin" /> 
	</sinhvien> 
	</THONGTINSV>'
)

-- Gợi ý: Dùng bảng QuanLySV
-- 2. Viết lệnh Xpath lấy Sinh viên có ID=10.
SELECT ChiTietSV.query('//sinhvien[@ID=10]')
FROM QuanLySV

-- 3. Viết lệnh lấy sinh viên ở vị trí cuối cùng ở trường CNTT.
SELECT ChiTietSV.query('//sinhvien[last()]')
FROM QuanLySV
WHERE TenDH = 'DH CNTT'

-- 4. Viết lệnh Xpath lấy tên Sinh viên có ID=10 trong trường Đại học CNTT.
-- Cách 1: 
SELECT ChiTietSV.query('//sinhvien[@ID=10]')
FROM QuanLySV
WHERE TenDH = 'DH CNTT'

-- Cách 2: 
SELECT ChiTietSV.value('(//sinhvien[@ID=10]/@Ten)[1]', 'varchar(10)') AS N'Tên'
FROM QuanLySV
WHERE TenDH = 'DH CNTT'

-- Gợi ý: Dùng hàm value() thay cho query().
-- 5. Viết lệnh trả về tất cả các nút từ nút gốc là THONGTINSV.
SELECT ChiTietSV.query('/THONGTINSV/*')
FROM QuanLySV

-- 6. Viết lệnh Xquery trả về danh sách sinh viên có ID < 12 với MSDH = 1.
-- Cách 1
SELECT ChiTietSV.query('//sinhvien[@ID < 12]')
FROM QuanLySV
WHERE MSDH = 1

--Cách 2
SELECT ChiTietSV.query(
	'for $sv in //sinhvien
	where $sv/@ID < 12
	return $sv'
)
FROM QuanLySV
WHERE MSDH = 1

-- 7. Viết lệnh Xquery trả về danh sách sinh viên sắp xếp tăng dần theo tên với MSDH=2.
SELECT ChiTietSV.query(
	'for $sv in //sinhvien
	order by $sv/@Ten ascending
	return $sv'
)
FROM QuanLySV
WHERE MSDH = 2

-- 8. Viết lệnh Xquery trả về MSDH và TenDH theo định dạng sau:
/* <QuanLySV>
		<ChiTietSV>1 DH CNTT</ChiTietSV>
	</QuanLySV>
*/
SELECT ChiTietSV.query(
	'<QuanLySV>
		<ChiTietSV>{
			sql:column("MSDH"),
			sql:column("TenDH")
		}</ChiTietSV>
	</QuanLySV>'
)
FROM QuanLySV

--9. Viết lệnh Xquery xóa tên các sinh viên trường DH KHTN.
UPDATE QuanLySV
SET ChiTietSV.modify(
	'delete(//sinhvien/@Ten)'
)
WHERE TenDH = 'DH KHTN'

--10. Viết lệnh Xquery trả về thông tin các sinh viên có tên là ‘Nam’ hoặc ‘Thanh’.
SELECT ChiTietSV.query(
	'for $sv in //sinhvien
	where $sv/@Ten = "Nam" or $sv/@Ten = "Thanh"
	return $sv'
)
FROM QuanLySV

--11. Viết lệnh Xquery thay đổi tên sinh viên thứ 2 thành tên ‘Binh’ trong trường CNTT.
UPDATE QuanLySV
SET ChiTietSV.modify(
	'replace value of (//sinhvien/@Ten)[2]
	with "Binh"'
)
WHERE TenDH = 'DH CNTT'

--12. Viết lệnh Xquery kiểm tra xem có tồn tại sinh viên có ID là 12 trong trường KHTN không? 
-- (Nếu có trả về 1, nếu không thì trả về 0).
SELECT ChiTietSV.exist(
	'//sinhvien[@ID=12]'
)
FROM QuanLySV
WHERE TenDH = 'DH KHTN'


--Gợi ý: Dùng lệnh exist() thay cho query().
--13. Thêm môn học có ID = 13 vào đối tượng sinh viên có ID = 10 của trường đại học Công nghệ thông tin.
UPDATE QuanLySV 
SET ChiTietSv.modify(
	'insert <monhoc ID = "13" /> as last
	into (//sinhvien[@ID=10])[1]'
)
WHERE TenDH = 'DH CNTT'
--Gợi ý: Dùng lệnh insert('<dữ liệu xml'>) into (<tên node>) trong hàm modify().
--14. Thêm thuộc tính tên môn học là "Quản lý thông tin" cho môn học có ID = 13 
--vào đối tượng sinh viên có ID = 10 của trường đại học Công nghệ thông tin.
UPDATE QuanLySV
SET ChiTietSV.modify(
	'insert attribute Ten{"Quan Ly Thong Tin"}
	into (//sinhvien[@ID=10]/monhoc[@ID=13])[1]'
)
WHERE TenDH = 'DH CNTT'

--15. Viết lệnh Xquery kiểm tra xem có tồn tại sinh viên tên ‘Lan’ trong trường CNTT không? 
--(Nếu có trả về 1, nếu không thì trả về 0), và INSERT sinh viên này thêm vào 
--THONGTINSV nếu chưa tồn tại:
--<sinhvien ID=”15” Ten=”Lan>
--<monhoc ID=”10” Ten=”Toan Roi Rac” />
--<monhoc ID=”11” Ten=”Lap Trinh C#” />
--<monhoc ID=”12” Ten=”CSDL Nang Cao” />
--</sinhvien>
IF NOT EXISTS (
    SELECT 1
    FROM QuanLySV
    WHERE TenDH = 'DH CNTT'
    AND ChiTietSV.exist('//sinhvien[@Ten="Lan"]') = 1
)
BEGIN
    UPDATE QuanLySV
    SET ChiTietSV.modify(
		'insert <sinhvien ID="15" Ten="Lan">
            <monhoc ID="10" Ten="Toan Roi Rac" />
            <monhoc ID="11" Ten="Lap Trinh C#" />
            <monhoc ID="12" Ten="CSDL Nang Cao" />
        </sinhvien>
        into (/THONGTINSV)[1]'
    )
    WHERE TenDH = 'DH CNTT'
END
ELSE
BEGIN
    SELECT 1 AS 'Result'
END

-- Cau bo sung (1): Viết câu lệnh XQuery thêm thuộc tính Diem là 10 cho sinh viên có ID = 10 của trường "DH CNTT"
UPDATE QuanLySV
SET ChiTietSV.modify(
    'insert attribute Diem {"10"}
    into (//sinhvien[@ID="10"])[1]'
)
FROM QuanLySV
WHERE TenDH = 'DH CNTT'

-- Cau bo sung (2): Viết câu lệnh XQuery/XPath lấy ra điểm môn "Quan Ly Thong Tin" của sinh viên có ID = 10 của trường  "DH CNTT"--
-- Cach 1: XQuery
SELECT ChiTietSV.query(
	'for $sv in //sinhvien 
	where $sv/@ID = 10 and $sv/monhoc/@Ten = "Quan Ly Thong Tin"
	return data($sv/monhoc/@Diem)'
)
FROM QuanLySV
WHERE TenDH = 'DH CNTT'

--Cach 2: XPath
SELECT ChiTietSV.value(
	'(//sinhvien[@ID=10]/monhoc[@Ten="Quan Ly Thong Tin"]/@Diem)[1]', 'INT'
) AS N'Điểm'
FROM QuanLySV
WHERE TenDH = 'DH CNTT'

SELECT *
FROM QuanLySV
