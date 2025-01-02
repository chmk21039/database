import psycopg
import json
import re

# datetime.date() 形式の文字列を YYYY-MM-DD 形式に変換する関数
def convert_date(date_str):
    date_pattern = re.compile(r'datetime\.date\((\d+), (\d+), (\d+)\)')
    match = date_pattern.match(date_str)
    if match:
        year, month, day = match.groups()
        return f'{year}-{month.zfill(2)}-{day.zfill(2)}'
    return date_str
connection = psycopg.connect(
        host='localhost',
        dbname='book',
        user='postgres',
        password='password',
        port='5433'
    )
sql = '''
SELECT * FROM 貸出 JOIN 貸出明細 ON 貸出.貸出番号 = 貸出明細.貸出番号
JOIN 書籍 ON 貸出明細."ISBNコード" = 書籍."ISBNコード"
JOIN 書籍著者 ON 書籍."ISBNコード" = 書籍著者."ISBNコード"
JOIN 著者 ON 書籍著者.著者番号 = 著者.著者番号
JOIN 出版社 ON 書籍.出版社番号 = 出版社.出版社番号
JOIN 学生 ON 学生.学生証番号 = 貸出.学生証番号;
'''
result = connection.execute(sql)
rentals = {}
books = {}

for entry in result:
    # print(entry)
    # datetime.date() の文字列を処理して YYYY-MM-DD 形式に変換
    fields = [convert_date(str(field)) for field in entry]
    if fields[3] == "None": fields[3] = None
    lental_num = fields[0]
    rental = rentals.setdefault(lental_num, {
        '貸出番号': fields[0],
        '貸出日': fields[1],
        '返却予定日': fields[2],
        '返却確認日': fields[3],
        '書籍': [],
        '学生': {'学生証番号': fields[19], '学生氏名': fields[20]}
    })
    
    book = books.setdefault(fields[7], {
        'ISBNコード': fields[7],
        '書籍名': fields[9],
        '著者': [],
        '出版社': {
            '出版社番号': fields[17],
            '出版社名': fields[18]
        },
        '出版年': fields[11]
    })
    
    if {
        '著者番号': fields[15],
        '著者名': fields[16],
        '役割': fields[14]
    } not in book['著者']:
        book['著者'].append({
            '著者番号': fields[15],
            '著者名': fields[16],
            '役割': fields[14]
        })
    
    if book not in rental['書籍']:
        rental['書籍'].append(book)

rentals_json = list(rentals.values())
print(json.dumps(rentals_json, ensure_ascii=False, indent=2))

