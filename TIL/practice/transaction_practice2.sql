-- 商品購入処理で在庫減少・顧客残高更新・注文記録挿入を示すトランザクションです

-- 商品テーブル
CREATE TABLE products(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

-- 顧客テーブル
CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

-- 注文テーブル
CREATE TABLE orders2(
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 初期データ挿入
INSERT INTO products(name, price, stock) VALUES
('iPhone 17', 164800, 10);

INSERT INTO users(name, balance) VALUES
('田中太郎', 200000),
('鈴木花子', 150000);

-- transaction開始
-- 成功例
BEGIN;
-- 行ロック
SELECT id, price, stock FROM products
WHERE name = 'iPhone 17' FOR UPDATE;
-- 在庫を 1 減らす
UPDATE products SET stock = stock - 1 WHERE name = 'iPhone 17' AND stock > 0;
-- 行ロック
SELECT id, balance FROM users
WHERE id = 1 FOR UPDATE;
-- ユーザ残高から商品価格を差し引く。残高が価格以上のときのみ更新される。
UPDATE users SET balance = balance - (SELECT price FROM products WHERE name = 'iPhone 17')
WHERE id = 1 AND balance >= (SELECT price FROM products WHERE name = 'iPhone 17');
-- orders2テーブルへ挿入。
INSERT INTO orders2(user_id, product_id, amount) VALUES
(1, (SELECT id FROM products WHERE name = 'iPhone 17'), (SELECT price FROM products WHERE name = 'iPhone 17'));
COMMIT;

-- transaction開始
-- 失敗例: 残高不足
BEGIN;
-- 行ロック
SELECT id, price, stock FROM products WHERE name = 'iPhone 17' FOR UPDATE;
-- 在庫を 1 減らす
UPDATE products SET stock = stock - 1 WHERE name = 'iPhone 17' AND stock > 0;
-- 行ロック
SELECT id, balance FROM users WHERE id = 2 FOR UPDATE;
-- ユーザ残高から商品価格を差し引く。
UPDATE users SET balance = balance - (SELECT price FROM products WHERE name = 'iPhone 17')
WHERE id = 2 AND balance >= (SELECT price FROM products WHERE name = 'iPhone 17');  -- 本来は不足ユーザを対象にする想定
-- 残高参照: 残高不足
SELECT balance FROM users WHERE id = 2;  -- 結果を見て手動判断する想定
-- rollback(変更を取り消す)
ROLLBACK;

