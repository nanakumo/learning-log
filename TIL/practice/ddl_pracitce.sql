SET search_path TO learning;

CREATE TABLE clients(
    client_id INTEGER NOT NULL,
    client_name VARCHAR(255) NOT NULL,
    client_address VARCHAR(255) NOT NULL,
    client_phone_number VARCHAR(13),
    PRIMARY KEY(client_id)
);

CREATE TABLE orders(
    order_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    client_id INTEGER NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

INSERT INTO
clients (client_id, client_name, client_address, client_phone_number)
VALUES (1, '佐藤', '東京都新宿区', '090-1234-5678'),
(2, '鈴木', '大阪府大阪市', '080-0000-0000');

INSERT INTO
orders (order_id, order_date, client_id)
VALUES (1, '2023-01-01', 1),
(2, '2023-01-02', 2),
(3, '2023-01-03', 1); 

