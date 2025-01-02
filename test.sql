

--1 publisher
--SELECT 出版社番号, 出版社名 FROM 出版社;
--2 add publisher

--3 author
SET search_path TO public;
SELECT * FROM 書籍;
--select * from 生徒データ limit 5;
--4 add author
--5 書籍
--SELECT * FROM 書籍 JOIN 書籍著者 ON 書籍.ISBNコード = 書籍著者.ISBNコード;
--JOIN 著者 ON 書籍著者.著者番号 = 著者.著者番号
--JOIN 出版社 ON 書籍.出版社番号 = 出版社.出版社番号;
--6 add 書籍

--7
--SELECT * FROM 学生;
--8 add 学生

--9
--SELECT * FROM 貸出 JOIN 貸出明細 ON 貸出.貸出番号 = 貸出明細.貸出番号 JOIN 書籍 ON 貸出明細.ISBNコード = 書籍.ISBNコード
--JOIN 出版社 ON 書籍.出版社番号 = 出版社.出版社番号 JOIN 著者 ON 書籍著者.著者番号 = 著者.著者番号;
--10 add 貸出
--11 返却