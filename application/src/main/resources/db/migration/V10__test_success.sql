CREATE TABLE test_table (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- --- 성공 케이스 (Success Cases) ---
CREATE TABLE new_table (id INT PRIMARY KEY, value VARCHAR(255));
INSERT INTO test_table (id, name) VALUES (1, 'Test Name');
ALTER TABLE test_table ADD COLUMN new_column VARCHAR(100) DEFAULT 'default_value';
ALTER TABLE test_table ADD COLUMN another_column INT;
UPDATE test_table SET name = 'Updated Name' WHERE id = 1;
DELETE FROM test_table WHERE id = 1;


-- --- 위험한 SQL 명령어 (Forbidden Commands - Static Analysis Error) ---
-- DROP TABLE flyway_test;
-- TRUNCATE TABLE test_table;
-- ALTER TABLE test_table DROP COLUMN name;
-- DELETE FROM test_table; -- DELETE without WHERE clause


-- --- 검토 필요 SQL 명령어 (Review Warnings - Static Analysis Warning) ---
ALTER TABLE test_table RENAME COLUMN name TO full_name;
ALTER TABLE test_table MODIFY COLUMN id BIGINT;
CREATE INDEX idx_name ON test_table (name);
DROP INDEX idx_name ON test_table;
CREATE VIEW success_view AS SELECT id, name FROM test_table;
ALTER TABLE test_table ADD CONSTRAINT unique_name UNIQUE (name);
UPDATE test_table SET name = 'All Names'; -- UPDATE without WHERE clause


-- --- 하위 호환성 위반 (Backward Compatibility Errors) ---
-- ALTER TABLE test_table ADD COLUMN critical_new_col INT NOT NULL; -- ADD COLUMN NOT NULL without DEFAULT
-- ALTER TABLE test_table RENAME TO old_test_table; -- RENAME table


-- --- 하위 호환성 주의 (Backward Compatibility Warnings) ---
ALTER TABLE test_table ALTER COLUMN new_column DROP DEFAULT; -- ALTER COLUMN DROP DEFAULT
