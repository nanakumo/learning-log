-- learning schema
CREATE SCHEMA IF NOT EXISTS learning;
SET search_path TO learning;

-- 会社テーブル
CREATE TABLE IF NOT EXISTS companies (
    companies_id SERIAL PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL
);

-- 部署テーブル
CREATE TABLE IF NOT EXISTS departments (
    departments_id SERIAL PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL
);

-- 社員テーブル
CREATE TABLE IF NOT EXISTS employees (
    company_id     INTEGER NOT NULL,
    employee_id    INTEGER NOT NULL,
    employee_name  VARCHAR(255) NOT NULL,
    department_id  INTEGER,
    -- 複合主キーと外部キー制約の設定
    CONSTRAINT pk_employees PRIMARY KEY (company_id, employee_id),
    CONSTRAINT fk_employees_departments FOREIGN KEY (department_id) REFERENCES departments(departments_id),
    CONSTRAINT fk_employees_companies FOREIGN KEY (company_id) REFERENCES companies(companies_id)
);