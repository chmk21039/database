import psycopg
import json
import re
#import pandas as pd
#from sqlalchemy import create_engine
"""
def main():
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
    for i in result:
        print(i)

if __name__ == '__main__':
    main()
"""

def get_books():
    connection = psycopg.connect(
        host='localhost',
        dbname='book',
        user='postgres',
        password='password',
        port='5433'
    )
    sql = '''
    SELECT * FROM 書籍 JOIN 書籍著者 ON 書籍."ISBNコード" = 書籍著者."ISBNコード"
    JOIN 著者 ON 書籍著者.著者番号 = 著者.著者番号
    JOIN 出版社 ON 書籍.出版社番号 = 出版社.出版社番号;
    '''
    result = connection.execute(sql)
    books = {}
    for entry in result:
        fields = str(entry).replace('(', '').replace(')', '').replace(' ', '').replace('\\u3000', '　').split(',')
        isbn = fields[0]
        book = books.setdefault(isbn, {
            'ISBNコード': isbn,
            '書籍名': fields[1],
            '著者': [],
            '出版社': {
                '出版社番号': fields[9],
                '出版社名': fields[10]
            },
            '出版年': fields[3]
        })
        book['著者'].append({
            '著者番号': fields[7],
            '著者名': fields[8],
            '役割': fields[6]
        })

    books_j = list(books.values())
    return books_j
# フィルタリング関数
def find_book_by_isbn(books_json, target_isbn):
    for book in books_json:
        if book['ISBNコード'] == target_isbn:
            return book
    return None


connection = psycopg.connect(
        host='localhost',
        dbname='book',
        user='postgres',
        password='password',
        port='5433'
    )
sql = '''
SELECT * FROM 貸出 JOIN 貸出明細 ON 貸出.貸出番号 = 貸出明細.貸出番号
JOIN 学生 ON 学生.学生証番号 = 貸出.学生証番号;
'''
result = connection.execute(sql)
#for i in result:
#    print(i)
lists = []
past = ''
first = True

#(42, datetime.date(2021, 7, 9), datetime.date(2021, 7, 23), datetime.date(2021, 7, 21), 
# '5420365', 42, 2, '978-4839955557', '978-4839955557', 'ノンデザイナーズ・デザインブック [第4版]',
#  2, 2016, '978-4839955557', 6, '著', 6, 'Robin Williams', 2, 'マイナビ出 版', '5420365', '矢吹紫')
#['42', '2021-07-09', '2021-07-23', '2021-07-21', '5420365', '42', '1', '978-4788514348', 
# '978-4788514348', '誰のためのデザイン？\u3000増補・改訂版\u3000―認知科学者のデザイン原論', '1', 
# '2015', '978-4788514348', '5', '翻訳', '5', '野島久雄', '1', '新曜社', '5420365', '矢吹紫']

date_pattern = re.compile(r'datetime\.date\((\d+), (\d+), (\d+)\)')

# datetime.date() 形式の文字列を YYYY-MM-DD 形式に変換する関数
def convert_date(date_str):
    match = date_pattern.match(date_str)
    if match:
        year, month, day = match.groups()
        return f'{year}-{month.zfill(2)}-{day.zfill(2)}'
    return date_str

rentals = {}
book_data = json.dumps(get_books(), ensure_ascii=False)
print(book_data)
for entry in result:
    print(entry)
    # datetime.date() の文字列を処理して YYYY-MM-DD 形式に変換
    fields = [convert_date(str(field)) for field in entry]
    #fields = str(entry).replace('(', '').replace(')', '').replace(' ', '').replace('\\u3000', '　').replace('datetime.date', '').split(',')
    #print(fields)
    lental_num = fields[0]
    books = find_book_by_isbn(book_data, fields[7])
    print(books, fields[7])
    rental = rentals.setdefault(lental_num,{
        '貸出番号':fields[0],
        '貸出日':fields[1],
        '返却予定日':fields[2],
        '返却確認日':fields[3],
        '書籍':books,
        '学生':{'学生証番号':fields[8], '学生氏名':fields[9]}
    })
rentals_json = list(rentals.values())
"""
    book = books.setdefault(f'{fields[5]}-{fields[6]}', {
        'ISBNコード': fields[7],
        '書籍名': fields[9],
        '著者': [],
        '出版社': fields[18],
        '出版年': fields[11]
    })
    book['著者'].append({
        '著者番号': fields[15],
        '著者名': fields[16],
        '役割': fields[14]
    })
    rental['書籍'].append(book)

rentals_json = list(rentals.values())
"""
#for i in rentals_json:
#    print(i)
#print(json.dumps(rentals_json, ensure_ascii=False, indent=2))

#for i in lists:
#    print(i)
