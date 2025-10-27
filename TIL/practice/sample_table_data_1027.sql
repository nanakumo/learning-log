
CREATE TABLE category(
	category_id SERIAL,
	category_name VARCHAR(100),
	PRIMARY KEY(category_id)
);

CREATE TABLE item(
	item_id SERIAL,
	item_name VARCHAR(100),
	price INTEGER,
	create_date DATE,
	status BOOLEAN,
	category_id INTEGER,
	PRIMARY KEY(item_id),
	FOREIGN KEY(category_id) REFERENCES category(category_id)
);


INSERT INTO category(category_name) VALUES('食品');
INSERT INTO category(category_name) VALUES('ファッション');
INSERT INTO category(category_name) VALUES('雑貨');
INSERT INTO category(category_name) VALUES('その他');

INSERT INTO item(item_name,price,create_date,status,category_id)VALUES('みかん',100,'2023-04-01',TRUE,1);
INSERT INTO item(item_name,price,create_date,status,category_id)VALUES('りんご',150,'2023-05-10',TRUE,1);
INSERT INTO item(item_name,price,create_date,status,category_id)VALUES('Tシャツ',2300,'2023-06-30',TRUE,2);
INSERT INTO item(item_name,price,create_date,status,category_id)VALUES('皿',1000,'2023-07-02',TRUE,3);
INSERT INTO item(item_name,price,create_date,status,category_id)VALUES(NULL,100,'2023-07-05',FALSE,1);


CREATE TABLE football(
	player_id SERIAL,
	player_name VARCHAR(100),
	PRIMARY KEY(player_id)
);

CREATE TABLE baseball(
	player_id SERIAL,
	player_name VARCHAR(100),
	PRIMARY KEY(player_id)
);

INSERT INTO football(player_name) VALUES('武田');
INSERT INTO football(player_name) VALUES('三浦');
INSERT INTO football(player_name) VALUES('鈴木');

INSERT INTO baseball(player_name) VALUES('屋敷');
INSERT INTO baseball(player_name) VALUES('王');
INSERT INTO baseball(player_name) VALUES('鈴木');