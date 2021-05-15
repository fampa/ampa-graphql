CREATE FUNCTION search_families(search text) 
returns setof families AS $$ 
SELECT   * 
FROM     families 
WHERE    search <% ( NAME ) 
ORDER BY similarity(search, ( NAME )) DESC limit 5; 

$$ language sql stable;
