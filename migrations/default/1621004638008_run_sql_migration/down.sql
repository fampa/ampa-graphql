-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE OR REPLACE FUNCTION search_families(search text) 
returns setof families AS $$ 
SELECT   * 
FROM     families 
WHERE    search <% ( NAME ) 
ORDER BY similarity(search, ( NAME )) DESC limit 5; 

$$ language sql stable;
