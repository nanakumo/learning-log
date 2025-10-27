--itemテーブルの全てのデータを取得
SELECT * FROM item;
--itemテーブルの商品名を取得
SELECT item_name FROM item;
--itemテーブルの商品名と価格を取得
SELECT item_name, price FROM item;

--等しい条件をつける
SELECT item_id, item_name FROM item WHERE item_id = 1;
--等しくない条件をつける
SELECT item_id, item_name FROM item WHERE item_id != 1;

--以上
SELECT item_name, price FROM item WHERE price >= 150;
--以下
SELECT item_name, price FROM item WHERE price <= 1000;
--〜以上〜以下（範囲指定）
SELECT item_name, price FROM item WHERE price >= 100 AND price <= 300;
SELECT item_name, price FROM item WHERE price BETWEEN 100 AND 300; 

--IS NULL / IS NOT NULL
SELECT item_id, item_name FROM item WHERE item_name IS NULL;
SELECT item_id, item_name FROM item WHERE item_name IS NOT NULL;

--OR（いずれか）
SELECT item_name FROM item WHERE item_name = 'みかん' OR item_name = 'りんご';  

--IN（ランダム抽出）
SELECT item_id, item_name FROM item WHERE item_id IN(1,3,4);

--LIKE（あいまい検索）
--%......なくても良い、あった場合は何文字でも良い
--_......1文字
SELECT item_name FROM item WHERE item_name LIKE '%ん%';
SELECT item_name FROM item WHERE item_name LIKE '_ん%';

--DISTINCT（重複排除。抽出したフォールドを重複しないで表示させる）
SELECT DISTINCT price FROM item;

--ORDER BY（並べ替え）
SELECT item_name, price FROM item ORDER BY price DESC;
SELECT item_name, price FROM item ORDER BY price DESC, item_id ASC;

--LIMIT（先頭から３件）
SELECT item_id, item_name, price FROM item LIMIT 3;

--集計関連
--COUNT
SELECT COUNT(item_id) FROM item;
SELECT COUNT(item_name) FROM item;
--AVG
SELECT AVG(price) FROM item;
--SUM
SELECT SUM(price) AS total FROM item; 
--MAX
SELECT MAX(price) FROM item;
--GROUP BY
SELECT category_id, COUNT(category_id) AS category_count
FROM item
GROUP BY category_id
ORDER BY category_id;
--HAVING（グルピングした上で条件をつける）
SELECT category_id, COUNT(category_id) AS category_count
FROM item
GROUP BY category_id
ORDER BY category_id
HAVING category_id >= 2;
