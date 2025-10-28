--演習問題2
CREATE TABLE products(
    product_id SERIAL,
    product_name VARCHAR(255) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    PRIMARY KEY(product_id)
);

CREATE TABLE companies(
    company_id SERIAL,
    company_name VARCHAR(255) NOT NULL,
    PRIMARY KEY(company_id)
);

-- orderはSQLの予約語なのでordersに変更
CREATE TABLE orders(
    order_id SERIAL,
    order_date DATE NOT NULL,
    company_id INTEGER,
    PRIMARY KEY(order_id),
    FOREIGN KEY(company_id) REFERENCES companies(company_id)
);

CREATE TABLE order_detail(
    order_detail_id SERIAL,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    PRIMARY KEY(order_detail_id),
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);

CREATE INDEX idx_orders_company_id ON orders(company_id);
CREATE INDEX idx_order_detail_order_id ON order_detail(order_id);
CREATE INDEX idx_order_detail_product_id ON order_detail(product_id);