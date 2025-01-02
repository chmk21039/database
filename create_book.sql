DROP TABLE IF EXISTS 生徒成績データ;
DROP TABLE IF EXISTS 選択科目データ;
DROP TABLE IF EXISTS クラブデータ;
DROP TABLE IF EXISTS 生徒データ;
DROP DATABASE students;

DROP TABLE IF EXISTS 貸出明細;
DROP TABLE IF EXISTS 貸出;
DROP TABLE IF EXISTS 書籍著者;
DROP TABLE IF EXISTS 書籍;
DROP TABLE IF EXISTS イラストレーター;
DROP TABLE IF EXISTS 著者;
DROP TABLE IF EXISTS レーベル;
DROP TABLE IF EXISTS 出版社;
DROP DATABASE IF EXISTS light;

DROP DATABASE IF EXISTS book;
CREATE DATABASE book;
DROP TABLE IF EXISTS 学生;





SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
CREATE DATABASE book WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
ALTER DATABASE book OWNER TO postgres;
\connect book
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
SET default_tablespace = '';
SET default_table_access_method = heap;


--CREATE TABLE 学生(
CREATE TABLE public."学生" (
  学生証番号 TEXT,
  学生氏名 TEXT
);

--CREATE TABLE 出版社(
CREATE TABLE public."出版社" (
  出版社番号 INTEGER,
  出版社名 TEXT
);

--CREATE TABLE 書籍(
CREATE TABLE public."書籍" (
  ＩＳＢＮコード TEXT,
  書籍名 TEXT,
  出版社番号 INTEGER,-- REFERENCES 出版社(出版社番号),
  出版年 INTEGER
);
ALTER TABLE public."書籍" OWNER TO postgres;

--CREATE TABLE 著者(
CREATE TABLE public."著者" (
  著者番号 INTEGER,
  著者名 TEXT
);

--CREATE TABLE 貸出 (
CREATE TABLE public."書籍著者" (
  ISBNコード TEXT REFERENCES 書籍(ISBNコード),
  著者番号 INTEGER REFERENCES 著者(著者番号),
  役割 TEXT
  PRIMARY KEY (ISBNコード, 著者番号)
);
ALTER TABLE public."書籍著者" OWNER TO postgres;

--CREATE TABLE 貸出 (
CREATE TABLE public."貸出" (
  貸出番号 INTEGER,
  貸出日 DATE,
  返却予定日 DATE,
  返却確認日 DATE,
  学生証番号 TEXT
);

--CREATE TABLE 貸出明細 (
CREATE TABLE public."貸出明細" (
  貸出番号 INTEGER,
  貸出連番 INTEGER,
  ISBNコード TEXT-- REFERENCES 書籍(ISBNコード),
  --PRIMARY KEY (貸出番号, 貸出連番)
);
ALTER TABLE public."学生" OWNER TO postgres;
ALTER TABLE public."出版社" OWNER TO postgres;

ALTER TABLE public."著者" OWNER TO postgres;

ALTER TABLE public."貸出" OWNER TO postgres;
ALTER TABLE public."貸出明細" OWNER TO postgres;

COPY public."学生" ("学生証番号", "学生氏名") FROM stdin;
5420365	矢吹紫
5419513	高橋博之
6121M78	田中淳平
\.

COPY public."出版社" ("出版社番号", "出版社名") FROM stdin;
1	新曜社
2	マイナビ出版
3	オライリージャパン
4	筑摩書房
\.

COPY public."書籍" ("ＩＳＢＮコード", "書籍名", "出版社番号", "出版年") FROM stdin;
978-4788514348	誰のためのデザイン？　増補・改訂版―認知科学者のデザイン原論	1	2015
978-4839955557	ノンデザイナーズ・デザインブック［第4版］	2	2016
978-4873118819	Python計算機科学新教本―新定番問題を解決する探索アルゴリズム、k平均法、ニューラルネットワーク	3	2019
978-4480069429	知のスクランブル：文理的思考の挑戦	4	2017

COPY public."著者" ("著者番号", "著者名") FROM stdin;
1	Ｄ．Ａ．ノーマン
2	岡本明
3	安村通晃
4	伊賀聡一郎
5	野島久雄
6	RobinWilliams
7	米谷テツヤ
8	小原司
9	吉川典秀
10	DavidKopec
11	黒川利明
12	日本大学文理学部
\.

COPY public."書籍著者" ("ISBNコード", "著者番号", "役割") FROM stdin;
978-4788514348	1	著
978-4788514348	2	翻訳
978-4788514348	3	翻訳
978-4788514348	4	翻訳
978-4788514348	5	翻訳
978-4839955557	6	著
978-4839955557	7	監修・翻訳
978-4839955557	8	監修・翻訳
978-4839955557	9	翻訳
978-4873118819	10	著
978-4873118819	11	翻訳
978-4480069429	12	編集
\.

COPY public."貸出" ("貸出番号", "貸出日", "返却予定日", "返却確認日", "学生証番号") FROM stdin;
42	2021-07-09	2021-07-23	2021-07-21	5420365
43	2021-09-03	2021-09-17	NULL	5419513
44	2021-10-11	2021-10-25	2021-10-14	6121M78
\.

COPY public."貸出明細" ("貸出番号", "貸出連番", "ISBNコード") FROM stdin;
42	1	978-4788514348
42	2	978-4839955557
43	1	978-4873118819
44	1	978-4480069429
\.