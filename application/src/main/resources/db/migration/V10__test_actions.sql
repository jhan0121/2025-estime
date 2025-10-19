-- 테스트용 기본 테이블 생성
CREATE TABLE test_table (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    value VARCHAR(100)
);


-- ===================================================
-- ✅ 성공 케이스 (Success Cases)
-- ===================================================
-- 아래 SQL들은 정적 분석 통과 및 마이그레이션 성공 예상

-- 새 테이블 생성
-- CREATE TABLE success_new_table (id INT PRIMARY KEY, value VARCHAR(255));

-- 기본값이 있는 컬럼 추가
-- ALTER TABLE test_table ADD COLUMN new_column VARCHAR(100) DEFAULT 'default_value';

-- NULL 허용 컬럼 추가
-- ALTER TABLE test_table ADD COLUMN another_column INT;

-- INSERT 작업
-- INSERT INTO test_table (id, name, value) VALUES (1, 'Test Name', 'Test Value');

-- WHERE 절이 있는 UPDATE
-- UPDATE test_table SET name = 'Updated Name' WHERE id = 1;

-- WHERE 절이 있는 DELETE
-- DELETE FROM test_table WHERE id = 1;


-- ===================================================
-- ❌ 금지 유형 SQL (Forbidden Commands)
-- ===================================================
-- 정적 분석 단계에서 즉시 실패 (exit 1)

-- DROP TABLE
-- DROP TABLE test_drop_table_example;

-- DROP DATABASE
-- DROP DATABASE test_drop_db_example;

-- DROP SCHEMA
-- DROP SCHEMA test_drop_schema_example;

-- TRUNCATE TABLE
-- TRUNCATE TABLE test_truncate_example;

-- ALTER TABLE DROP COLUMN
-- ALTER TABLE test_drop_column_example DROP COLUMN example_column;

-- DELETE without WHERE (WHERE 절 없는 DELETE)
-- DELETE FROM test_delete_without_where;


-- ===================================================
-- ⚠️ 검토 필요 SQL (Review Warnings)
-- ===================================================
-- 정적 분석 단계에서 경고 출력하지만 계속 진행

-- --- 스키마 구조 변경 (RENAME/MODIFY/CHANGE) ---

-- -- 컬럼 추가 (사전 준비)
-- ALTER TABLE test_table ADD COLUMN review_col1 VARCHAR(100) DEFAULT 'default_value';
-- ALTER TABLE test_table ADD COLUMN review_col2 INT;
--
-- -- 테이블명 변경
-- ALTER TABLE test_table RENAME TO test_table_renamed;
-- ALTER TABLE test_table_renamed RENAME TO test_table;
--
-- -- 컬럼 타입 변경 (MODIFY)
-- ALTER TABLE test_table MODIFY COLUMN review_col1 TEXT;
--
-- -- 컬럼명 및 타입 변경 (CHANGE)
-- ALTER TABLE test_table CHANGE COLUMN review_col2 review_col2_renamed BIGINT;
--
-- -- 컬럼명만 변경 (RENAME COLUMN) - MySQL 8.0+
-- ALTER TABLE test_table RENAME COLUMN value TO value_renamed;
-- ALTER TABLE test_table RENAME COLUMN value_renamed TO value;


-- --- 인덱스 변경 ---

-- -- 인덱스 생성
-- CREATE INDEX idx_name ON test_table (name);
--
-- -- 인덱스 삭제
-- DROP INDEX idx_name ON test_table;
--
-- -- 다시 생성 (이후 테스트용)
-- CREATE INDEX idx_name ON test_table (name);


-- --- 테이블 속성 변경 ---

-- -- 새 테이블 생성 (사전 준비)
-- CREATE TABLE review_test_table (id INT PRIMARY KEY, value VARCHAR(255));
--
-- -- 테이블 엔진 변경
-- ALTER TABLE review_test_table ENGINE=InnoDB;
--
-- -- 문자셋 변경 (CHARACTER SET)
-- ALTER TABLE review_test_table CHARACTER SET utf8mb4;
--
-- -- 콜레이션 변경
-- ALTER TABLE review_test_table COLLATE=utf8mb4_unicode_ci;


-- --- DB 제약조건 변경 ---

-- -- 제약조건 추가 (UNIQUE)
-- ALTER TABLE test_table ADD CONSTRAINT unique_name UNIQUE (name);
--
-- -- 제약조건 삭제
-- ALTER TABLE test_table DROP CONSTRAINT unique_name;
--
-- -- 제약조건 다시 추가
-- ALTER TABLE test_table ADD CONSTRAINT unique_name UNIQUE (name);


-- --- 데이터 변경 (UPDATE without WHERE) ---

-- -- 데이터 추가
-- INSERT INTO test_table (id, name, value) VALUES (2, 'Test Name 2', 'Test Value 2');
-- INSERT INTO test_table (id, name, value) VALUES (3, 'Test Name 3', 'Test Value 3');
--
-- -- WHERE 절 없는 UPDATE
-- UPDATE test_table SET value = 'All Same Value';


-- ===================================================
-- 🧪 엣지 케이스 (Edge Cases)
-- ===================================================

-- 대소문자 혼합
-- DrOp TaBlE test_case_mixed_example;

-- 여러 공백
-- DROP     TABLE     test_spaces_example;

-- 탭 포함
-- DROP	TABLE	test_tab_example;

-- UPDATE without WHERE (대소문자 혼합)
-- UpDaTe test_table SeT name = 'Edge Case Update';


-- ===================================================
-- 🔴 Flyway 실행 실패 케이스 (Migration Failure)
-- ===================================================
-- 정적 분석 통과, 마이그레이션 실행 시 실패

-- --- 1. 존재하지 않는 테이블 참조 ---
-- ALTER TABLE non_existent_table ADD COLUMN test_col VARCHAR(100);

-- --- 2. 존재하지 않는 컬럼 참조 ---
-- ALTER TABLE test_table DROP COLUMN non_existent_column;

-- --- 3. 중복 테이블 생성 ---
-- CREATE TABLE test_table (id INT);

-- --- 4. 중복 컬럼 추가 ---
-- ALTER TABLE test_table ADD COLUMN name VARCHAR(100);

-- --- 5. 존재하지 않는 인덱스 삭제 ---
-- DROP INDEX non_existent_index ON test_table;

-- --- 6. 잘못된 외래키 참조 ---
-- ALTER TABLE test_table ADD CONSTRAINT fk_test FOREIGN KEY (name) REFERENCES non_existent_table(id);

-- --- 7. NOT NULL 제약조건 위반 (기존 NULL 데이터 존재 시) ---
-- INSERT INTO test_table (id, name, value) VALUES (10, NULL, 'test');
-- ALTER TABLE test_table MODIFY COLUMN name VARCHAR(255) NOT NULL;

-- --- 8. 데이터 타입 불일치 (데이터 손실 발생) ---
-- INSERT INTO test_table (id, name, value) VALUES (11, 'Very Long Text That Exceeds Limit', 'test');
-- ALTER TABLE test_table MODIFY COLUMN name VARCHAR(5);

-- --- 9. UNIQUE 제약조건 위반 (중복 데이터 존재 시) ---
-- INSERT INTO test_table (id, name, value) VALUES (12, 'Duplicate', 'test1');
-- INSERT INTO test_table (id, name, value) VALUES (13, 'Duplicate', 'test2');
-- ALTER TABLE test_table ADD CONSTRAINT unique_name_test UNIQUE (name);

-- --- 10. 잘못된 SQL 구문 ---
-- SELCT * FROM test_table;

-- --- 11. 권한 부족 (테스트 유저는 SUPER 권한 없음) ---
SET GLOBAL max_connections = 200;
