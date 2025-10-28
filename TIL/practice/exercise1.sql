SET search_path TO exercises;

CREATE TABLE member_list (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	name_kana VARCHAR(50) NOT NULL,
	gender VARCHAR(50) NOT NULL,
	birthday DATE NOT NULL,
	prefecture VARCHAR(10) NOT NULL,
	email VARCHAR(255),
	mobile_phone VARCHAR(20),
	mobile_phone_carrier VARCHAR(255),
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--演習問題1
--Q1:idが10のidとnameを表示
SELECT id, name FROM member_list
WHERE id = 10;

--Q2: prefectureが大阪府の人
SELECT id, name, prefecture FROM member_list
WHERE prefecture = '大阪府';

--Q3: birthdayが1990/1/1以降の人
SELECT id, name, birthday FROM member_list
WHERE birthday >= '1990-1-1';

--Q4: prefectureが岡山県か神奈川県の人
SELECT id, name, prefecture FROM member_list
WHERE prefecture = '岡山県' OR prefecture = '神奈川県';

--Q5: nameに「川」を含む人
SELECT id, name FROM member_list
WHERE name LIKE '%川%';

--Q6: nameが「子」で終わる人
SELECT id, name FROM member_list
WHERE name LIKE '%子';

--Q7: member_list tableの件数
SELECT COUNT(id) AS result FROM member_list;

--Q8: genderごとの人数
SELECT gender, COUNT(id) FROM member_list
GROUP BY gender;

--Q9: mobile_phone_carrierごとの人数
SELECT mobile_phone_carrier, COUNT(mobile_phone_carrier) AS count FROM member_list
GROUP BY mobile_phone_carrier;

--Q10: idを降順で並べ替える、最初から５件を表示（フィールドは全て表示）
SELECT * FROM member_list
ORDER BY id DESC
LIMIT 5;

--Q11: prefectureを昇順で並べ替え、さらにbirthdayを降順で並べ替え、最初から20件を表示（フィールドは全て表示）
SELECT * FROM member_list
ORDER BY prefecture COLLATE "ja_JP.UTF-8" ASC, birthday DESC
LIMIT 20

-- `COLLATE "ja_JP.UTF-8"` を列名の直後に指定することで、
-- 「これは日本語です。日本語の辞書順（あいうえお順）で並び替えてください」
-- とデータベースに明示的に指示している
