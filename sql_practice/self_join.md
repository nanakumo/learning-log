## 上司より給与が高い社員を抽出してください

### 概要

**Employee** テーブルから、直属の上司（Manager）よりも高い給与（Salary）を受け取っている従業員の名前（Name）を抽出してください。
結果テーブルの表示順序は問いません。

### table定義

**Table: Employee**

| Column Name | Type    | Description           |
| :---        | :---    | :---                  |
| id          | int     | **主キー (PK)** |
| name        | varchar | 従業員名              |
| salary      | int     | 給与                  |
| managerId   | int     | 上司のID (FK的な役割) |

> **補足**: `id` はこのテーブルの主キーであり、一意の値（Unique）を持ちます。

### やり方１：WHERE句を使う

お先に下記のコマンドを実行してみます。

```sql
SELECT *
FROM Employee AS a, Employee AS b;
```

結合条件がないので、2つのテーブルをすべての組み合わせで結合して、以下のように出力結果は 4 x 4 = 16 件のレコードとなります。


<details>
<summary>▶️ クリックして組み合わせの結果を見る (16 rows)</summary>

| A.id | A.name | A.salary | A.managerId | B.id | B.name | B.salary | B.managerId |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Joe | 70000 | 3 | 1 | Joe | 70000 | 3 |
| 1 | Joe | 70000 | 3 | 2 | Henry | 80000 | 4 |
| 1 | Joe | 70000 | 3 | 3 | Sam | 60000 | null |
| 1 | Joe | 70000 | 3 | 4 | Max | 90000 | null |
| 2 | Henry | 80000 | 4 | 1 | Joe | 70000 | 3 |
| 2 | Henry | 80000 | 4 | 2 | Henry | 80000 | 4 |
| 2 | Henry | 80000 | 4 | 3 | Sam | 60000 | null |
| 2 | Henry | 80000 | 4 | 4 | Max | 90000 | null |
| 3 | Sam | 60000 | null | 1 | Joe | 70000 | 3 |
| 3 | Sam | 60000 | null | 2 | Henry | 80000 | 4 |
| 3 | Sam | 60000 | null | 3 | Sam | 60000 | null |
| 3 | Sam | 60000 | null | 4 | Max | 90000 | null |
| 4 | Max | 90000 | null | 1 | Joe | 70000 | 3 |
| 4 | Max | 90000 | null | 2 | Henry | 80000 | 4 |
| 4 | Max | 90000 | null | 3 | Sam | 60000 | null |
| 4 | Max | 90000 | null | 4 | Max | 90000 | null |

</details>

しかし、今回必要なのは「マネージャーより給与が高い社員」のデータだけです。そのため、WHERE句に2つの判定条件を追加して絞り込みます。

```sql
SELECT
    *
FROM
    Employee AS a,
    Employee AS b
WHERE
    a.managerid = b.id
        AND a.salary > b.salary;
```

出力結果は以下になります。

| Id | Name | Salary | ManagerId | Id | Name | Salary | ManagerId |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Joe | 70000 | 3 | 3 | Sam | 60000 | null |

### やり方２：JOIN文を使う

```sql
SELECT *
    FROM employee a
        INNER JOIN employee b
        ON a.managerid = b.id
            AND a.salary > b.salary;
```