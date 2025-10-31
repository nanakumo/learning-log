-- RETURNING文は今回insertしたレコードを確認できる
INSERT INTO item(item_name, price, category_id) VALUES
('ブドウ', 660, 1)
RETURNING item_id, item_name;

-- NOT NULLを設定していないカラムに対して、
-- NULL挿入することで、そのカラムに何も入っていないことにすることができる
INSERT INTO item(item_name, price, category_id) VALUES
('マンゴー', NULL, 1);

-- ON CONFLICT句は、主キーや一意制約に違反した場合の処理を指定できる
-- DO NOTHINGは何もしない
INSERT INTO item(item_name, price, category_id) VALUES
('マンゴー', 880, 1)
ON CONFLICT (item_name) DO NOTHING;

-- DO UPDATEは違反した場合に更新処理を行う
INSERT INTO item(item_name, price, category_id) VALUES
('マンゴー', 880, 1)
ON CONFLICT (item_name) DO UPDATE SET
price = EXCLUDED.price, category_id = EXCLUDED.category_id, created_at = CURRENT_TIMESTAMP;

-- 計算を含めるSELECT文
-- price列が500以上の商品を対象に、10%値上げした価格を計算して取得する
SELECT item_id, item_name, price, price * 1.1 AS increased_price
FROM item
WHERE price >= 500;

-- DELETE文で特定のレコードを削除する
DELETE FROM item WHERE item_id = 5;
-- 安全なデータ更新と削除ポイント
-- 1. 必ずバックアップを取る
-- 2. トランザクションを使用する
-- 3. WHERE句を指定することを忘れずに

-- テーブル構造の変更
-- カラムの追加
ALTER TABLE item ADD COLUMN stock_quantity INTEGER DEFAULT 0;
-- カラムを削除
ALTER TABLE item DROP COLUMN stock_quantity;
-- カラムのデータ型を変更
ALTER TABLE item ALTER COLUMN price TYPE NUMERIC(10,2) USING price::NUMERIC(10,2);
-- カラム名の変更
ALTER TABLE item RENAME COLUMN category_id TO category_type_id;
-- テーブル名の変更
ALTER TABLE item RENAME TO items;
-- テーブルの削除
DROP TABLE IF EXISTS items;