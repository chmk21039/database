
DROP TABLE IF EXISTS 貸出明細;
DROP TABLE IF EXISTS 貸出;
DROP TABLE IF EXISTS 書籍著者;
DROP TABLE IF EXISTS 書籍;
--DROP TABLE IF EXISTS イラストレーター;
DROP TABLE IF EXISTS 著者;
--DROP TABLE IF EXISTS レーベル;
DROP TABLE IF EXISTS 出版社;
--DROP DATABASE IF EXISTS light;
DROP TABLE IF EXISTS 学生;
DROP DATABASE IF EXISTS book;
CREATE DATABASE book;

/*
DROP TABLE IF EXISTS public."貸出明細";
DROP TABLE IF EXISTS public."貸出";
DROP TABLE IF EXISTS public."書籍著者";
DROP TABLE IF EXISTS public."書籍";
DROP TABLE IF EXISTS public."著者";
DROP TABLE IF EXISTS public."出版社";
DROP TABLE IF EXISTS public."学生";
DROP DATABASE IF EXISTS book;
CREATE DATABASE book;
*/

CREATE TABLE 学生 (
  学生証番号 TEXT PRIMARY KEY,
  学生氏名 TEXT NOT NULL
);

CREATE TABLE 出版社 (
  出版社番号 INTEGER PRIMARY KEY,
  出版社名 TEXT NOT NULL
);

CREATE TABLE 書籍 (
  ISBNコード TEXT PRIMARY KEY,
  書籍名 TEXT NOT NULL,
  出版社番号 INTEGER NOT NULL REFERENCES 出版社(出版社番号),
  出版年 INTEGER NOT NULL
);

CREATE TABLE 著者 (
  著者番号 INTEGER PRIMARY KEY,
  著者名 TEXT NOT NULL
);

CREATE TABLE 書籍著者 (
  ISBNコード TEXT REFERENCES 書籍(ISBNコード),
  著者番号 INTEGER REFERENCES 著者(著者番号),
  役割 TEXT NOT NULL,
  PRIMARY KEY (ISBNコード, 著者番号)
);

CREATE TABLE 貸出 (
  貸出番号 INTEGER PRIMARY KEY,
  貸出日 DATE NOT NULL,
  返却予定日 DATE NOT NULL,
  返却確認日 DATE,
  学生証番号 TEXT NOT NULL REFERENCES 学生(学生証番号)
);

CREATE TABLE 貸出明細 (
  貸出番号 INTEGER,
  貸出連番 INTEGER,
  ISBNコード TEXT NOT NULL REFERENCES 書籍(ISBNコード),
  PRIMARY KEY (貸出番号, 貸出連番)
);

INSERT INTO 学生 (学生証番号, 学生氏名)
VALUES
  ('5420365', '矢吹紫'),
  ('5419513', '高橋博之'),
  ('6121M78', '田中淳平');

INSERT INTO 出版社 (出版社番号, 出版社名)
VALUES
  (1, '新曜社'),
  (2, 'マイナビ出版'),
  (3, 'オライリージャパン'),
  (4, '筑摩書房');

INSERT INTO 書籍 (ISBNコード, 書籍名, 出版社番号, 出版年)
VALUES
  ('978-4788514348', '誰のためのデザイン？　増補・改訂版　―認知科学者のデザイン原論', 1, 2015),
  ('978-4839955557', 'ノンデザイナーズ・デザインブック [第4版]', 2, 2016),
  ('978-4873118819', 'Python計算機科学新教本 ―新定番問題を解決する探索アルゴリズム、k平均法、ニューラルネットワーク', 3, 2019),
  ('978-4480069429', '知のスクランブル: 文理的思考の挑戦 ', 4, 2017);

INSERT INTO 著者 (著者番号, 著者名)
VALUES
  (1, 'D. A. ノーマン'),
  (2, '岡本明'),
  (3, '安村通晃'),
  (4, '伊賀聡一郎'),
  (5, '野島久雄'),
  (6, 'Robin Williams'),
  (7, '米谷テツヤ'),
  (8, '小原司'),
  (9, '吉川典秀'),
  (10, 'David Kopec'),
  (11, '黒川利明'),
  (12, '日本大学文理学部');

INSERT INTO 書籍著者 (ISBNコード, 著者番号, 役割)
VALUES
  ('978-4788514348', 1, '著'),
  ('978-4788514348', 2, '翻訳'),
  ('978-4788514348', 3, '翻訳'),
  ('978-4788514348', 4, '翻訳'),
  ('978-4788514348', 5, '翻訳'),
  ('978-4839955557', 6, '著'),
  ('978-4839955557', 7, '監修・翻訳'),
  ('978-4839955557', 8, '監修・翻訳'),
  ('978-4839955557', 9, '翻訳'),
  ('978-4873118819', 10, '著'),
  ('978-4873118819', 11, '翻訳'),
  ('978-4480069429', 12, '編集');

INSERT INTO 貸出 (貸出番号, 貸出日, 返却予定日, 返却確認日, 学生証番号)
VALUES
  (42, '2021-07-09', '2021-07-23', '2021-07-21', '5420365'),
  (43, '2021-09-03', '2021-09-17', NULL, '5419513'),
  (44, '2021-10-11', '2021-10-25', '2021-10-14', '6121M78');

INSERT INTO 貸出明細 (貸出番号, 貸出連番, ISBNコード)
VALUES
  (42, 1, '978-4788514348'),
  (42, 2, '978-4839955557'),
  (43, 1, '978-4873118819'),
  (44, 1, '978-4480069429');