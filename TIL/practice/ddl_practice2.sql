SET search_path TO learning;

CREATE TABLE Payee (
    payee_id SERIAL,
    payee_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (payee_id)
);

CREATE TABLE Account_name (
    account_id SERIAL,
    account_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (account_id)
);

CREATE TABLE Payment (
    payment_id SERIAL,
    payee_id INTEGER NOT NULL,
    pay_date DATE NOT NULL,
    PRIMARY KEY (payment_id),
    FOREIGN KEY (payee_id) REFERENCES Payee(payee_id)
);

CREATE TABLE Payment_detail (
    payment_detail_id SERIAL,
    payment_id INTEGER NOT NULL,
    account_id INTEGER NOT NULL,
    summary VARCHAR(255) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    PRIMARY KEY (payment_detail_id),
    FOREIGN KEY (payment_id) REFERENCES Payment(payment_id),
    FOREIGN KEY (account_id) REFERENCES Account_name(account_id)
);

INSERT INTO Payee (payee_name) VALUES
('山田商事'),
('佐藤株式会社');

INSERT INTO Account_name (account_name) VALUES
('交通費'),
('接待交際費'),
('消耗品費');

INSERT INTO Payment (payee_id, pay_date) VALUES
(1, '2024-01-15'),
(2, '2024-01-20');

INSERT INTO Payment_detail (payment_id, account_id, summary, amount) VALUES
(1, 1, '出張交通費', 15000.00),
(1, 3, '事務用品購入', 5000.00),
(2, 2, '取引先との会食', 20000.00);


