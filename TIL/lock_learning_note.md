# PostgreSQL のロック（テーブルロックと行ロック）

ロックは、データベースの一貫性と並行性を保つために使用されます。
複数のトランサクションが同時に同じデータにサクセスしようとするとき、競合状態が発生する可能性があります。この競合状態を防ぐために、データベースはロックを使用して、特定のリソース（行やテーブル）を他のトランザクションからアクセスできないようにします。

## テーブルロック

テーブルロックは、テーブル全体をロックする方法です。

### 排他ロック(LOCK)

排他ロックは、テーブルをロックして、他のトランザクションがそのテーブルに対して読み書きすることを防ぎます。
例：

```sql
LOCK TABLE employees IN EXCLUSIVE MODE;
```

### 共有ロック(SHARE)

共有ロックは、テーブルに対する読み取り操作を許可しながら、書き込み操作を防ぐために使用します。
例：

```sql
LOCK TABLE employees IN SHARE MODE;
```

## 行ロック

行ロックは、テーブル内の特定の行をロックする方法です。特に、高並行性のトランザクションにおいて有効です。

- 行ロック使用例
  employees テーブルから特定の社員情報を更新する場合

```sql
BEGIN;
SELECT * FROM employees WHERE id = 1 FOR UPDATE;
UPDATE employees SET name = '山田花子' WHERE id = 1;
COMMIT;
```

## ロックの競合(待機)

複数のトランザクションが同じリソースをロックしようとすると、ロックの競合が発生することがあります。

### デッドロック

デッドロックは、複数のトランザクションがお互いにロックを要求し合って、永遠に待機状態に陥る現象です。

#### デッドロックの回避：

1. 必要以上に広い範囲にロックをかけないようにします。可能な限り、行ロックを使用します。
2. トランザクションをできるだけ早く終了させて、ロックが長時間保持されることを避けることが重要です。
3. 適切なインデックスの作成や、トランザクションの順番を工夫することが競合を減らす助けになります。

具体的に言うと、

1. ロックの順番を一定に保つ
   例えば、全てのトランザクションがまずレコード A をロックし、その後レコード B をロックするようにします。

```sql
BEGIN;
-- lock the record A
SELECT * FROM employees WHERE id = 1 FOR UPDATE;
-- lock the record B
SELECT * FROM employees WHERE id = 2 FOR UPDATE;
COMMIT;
```

2. 短いトランザクションを作成する
3. タイムアウトを設定する
   PostgreSQL では、`statement_timeout`や`lock_timeout`を設定するができます。

```sql
SET lock_timeout = '5s' -- 5秒以内にロックを取得できなければエラー
```

#### デッドロックの検出

デッドロックが発生した場合、データベースは自動でその中の一つのトランザクションをロールバックしてデッドロックを解消します。以下のエラーメッセージを返します。

```
ERROR: deadlock detected
DETAIL: Process 12345 waits for ShareLock on transaction 54321; blocked by process 67890.
HINT: See server log for query details.
```
