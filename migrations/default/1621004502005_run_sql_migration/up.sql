CREATE INDEX families_name_gin_idx ON families
USING GIN ((name) gin_trgm_ops);
