-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE INDEX families_name_gin_idx ON families
USING GIN ((name) gin_trgm_ops);
