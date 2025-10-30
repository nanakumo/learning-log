-- 2つの口座間の資金移動に関するトランザクションです。

CREATE TABLE accounts(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);

INSERT INTO accounts (name, balance) VALUES
('山田太郎', 5000.00),
('鈴木一郎', 3000.00);

-- =====================================
-- トランザクション開始（成功例）
-- 資金移動: 口座1 -> 口座2 金額=1000
-- =====================================
BEGIN;
-- 行ロック
SELECT balance FROM accounts WHERE id = 1 FOR UPDATE;
-- id = 1の口座から1000円を引き落とす
UPDATE accounts SET balance = balance - 1000
WHERE id = 1;
-- id = 1の口座の残高を確認
SELECT balance FROM accounts WHERE id = 1 AND balance >= 0;
-- 行ロック
SELECT balance FROM accounts WHERE id = 2 FOR UPDATE;
-- id = 2の口座に1000円を入金する
UPDATE accounts SET balance = balance + 1000 WHERE id = 2;
-- commit（確定）
COMMIT;

-- =====================================
-- トランザクション開始（失敗例）
-- 資金移動: 口座1 -> 口座2 金額=1000 （最後はロールバックする）
-- =====================================
BEGIN;
-- 行ロック
SELECT balance FROM accounts WHERE id = 1 FOR UPDATE;
-- id = 1の口座から1000円を引き落とす
UPDATE accounts SET balance = balance - 1000
WHERE id = 1;
-- id = 1の口座の残高を確認
-- 残高が0未満の場合はロールバックする想定
SELECT balance FROM accounts WHERE id = 1;
-- rollback（変更を取り消す）
ROLLBACK;