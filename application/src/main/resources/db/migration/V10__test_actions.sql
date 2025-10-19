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
CREATE TABLE success_new_table (id INT PRIMARY KEY, value VARCHAR(255));

-- 기본값이 있는 컬럼 추가
ALTER TABLE test_table ADD COLUMN new_column VARCHAR(100) DEFAULT 'default_value';

-- NULL 허용 컬럼 추가
ALTER TABLE test_table ADD COLUMN another_column INT;

-- INSERT 작업
INSERT INTO test_table (id, name, value) VALUES (1, 'Test Name', 'Test Value');

-- WHERE 절이 있는 UPDATE
UPDATE test_table SET name = 'Updated Name' WHERE id = 1;

-- WHERE 절이 있는 DELETE
DELETE FROM test_table WHERE id = 1;


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

-- 테이블명 변경
-- ALTER TABLE test_table RENAME TO test_table_renamed;
-- ALTER TABLE test_table_renamed RENAME TO test_table;

-- 컬럼 타입 변경 (MODIFY)
-- ALTER TABLE test_table MODIFY COLUMN new_column TEXT;

-- 컬럼명 및 타입 변경 (CHANGE)
-- ALTER TABLE test_table CHANGE COLUMN another_column another_col BIGINT;

-- 컬럼명만 변경 (RENAME COLUMN) - MySQL 8.0+
-- ALTER TABLE test_table RENAME COLUMN value TO val;
-- ALTER TABLE test_table RENAME COLUMN val TO value;


-- --- 인덱스 변경 ---

-- 인덱스 생성
-- CREATE INDEX idx_name ON test_table (name);

-- 인덱스 삭제
-- DROP INDEX idx_name ON test_table;

-- 다시 생성 (이후 테스트용)
-- CREATE INDEX idx_name ON test_table (name);


-- --- 테이블 속성 변경 ---

-- 테이블 엔진 변경
-- ALTER TABLE success_new_table ENGINE=InnoDB;

-- 문자셋 변경 (CHARACTER SET)
-- ALTER TABLE success_new_table CHARACTER SET utf8mb4;

-- 콜레이션 변경
-- ALTER TABLE success_new_table COLLATE=utf8mb4_unicode_ci;


-- --- DB 제약조건 변경 ---

-- 제약조건 추가 (UNIQUE)
-- ALTER TABLE test_table ADD CONSTRAINT unique_name UNIQUE (name);

-- 제약조건 삭제
-- ALTER TABLE test_table DROP CONSTRAINT unique_name;

-- 제약조건 다시 추가
-- ALTER TABLE test_table ADD CONSTRAINT unique_name UNIQUE (name);


-- --- 데이터 변경 (UPDATE without WHERE) ---

-- INSERT 추가 데이터
-- INSERT INTO test_table (id, name, value) VALUES (2, 'Test Name 2', 'Test Value 2');
-- INSERT INTO test_table (id, name, value) VALUES (3, 'Test Name 3', 'Test Value 3');

-- WHERE 절 없는 UPDATE
-- UPDATE test_table SET value = 'All Same Value';


-- ===================================================
-- 🔍 복합 케이스 (Combined Cases)
-- ===================================================
-- 여러 검토 필요 항목이 동시에 발생하는 케이스

-- 새 컬럼 추가 후 MODIFY
-- ALTER TABLE test_table ADD COLUMN complex_col VARCHAR(50);
-- ALTER TABLE test_table MODIFY COLUMN complex_col TEXT;

-- 인덱스 생성
-- CREATE INDEX idx_complex ON test_table (complex_col(100));

-- 제약조건 추가
-- ALTER TABLE test_table ADD CONSTRAINT check_complex CHECK (LENGTH(complex_col) > 0);


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
