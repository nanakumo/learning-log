--INNER JOIN(両方に存在するデータのみ表示)
SELECT item.item_name, category.category_name
FROM item
INNER JOIN category ON item.category_id = category.category_id;
--別名をつけた場合(INNER JOIN)
SELECT i.item_name, c.category_name
FROM item i
INNER JOIN category c ON i.category_id = c.category_id;

--LEFT JOIN(片方は全部表示)
SELECT i.item_name, c.category_name
FROM category c
LEFT JOIN item i ON c.category_id = i.category_id;

--UNION ALL(合体、重複も全て表示)
SELECT player_name FROM football
UNION ALL
SELECT player_name FROM baseball;
--UNION(合体、重複は表示しない)
SELECT player_name FROM football
UNION
SELECT player_name FROM baseball;

--副問い合わせ（サブクエリ・入れ子の状態）
--itemテーブルの中で金額が一番高い商品名を抽出
SELECT item_name, price FROM item
WHERE price = (SELECT MAX(price) FROM item);
--皿のデータをitemの中で最安値に値下げする
UPDATE item SET price = (SELECT MIN(price) FROM item)
WHERE item_id = 4;
