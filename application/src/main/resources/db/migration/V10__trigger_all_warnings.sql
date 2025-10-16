ALTER TABLE flyway_test RENAME COLUMN id TO test_id;
ALTER TABLE flyway_test MODIFY COLUMN test_id BIGINT;
CREATE INDEX idx_test_id ON flyway_test (test_id);
CREATE VIEW test_view AS SELECT test_id FROM flyway_test;
UPDATE flyway_test SET test_id = 100;
ALTER TABLE flyway_test ADD COLUMN with_default VARCHAR(255) DEFAULT 'default_value';
ALTER TABLE flyway_test ALTER COLUMN with_default DROP DEFAULT;
