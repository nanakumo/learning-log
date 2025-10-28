CREATE INDEX idx_empoyee_name ON learning.employees(employee_name);
SELECT * FROM pg_indexs 
WHERE schemaname = 'learning' AND tablename = 'employees'; 