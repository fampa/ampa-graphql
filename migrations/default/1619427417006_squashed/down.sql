
alter table "public"."members" add constraint "members_phone_key" unique (phone);

alter table "public"."members" rename column "updatedAt" to "updateAt";

alter table "public"."tags" rename column "nameCa" to "name_ca";

alter table "public"."tags" rename column "nameEs" to "name_es";

alter table "public"."articles_translations" rename column "articleId" to "article_id";

alter table "public"."articles" rename column "authorId" to "author_id";

alter table "public"."articles" rename column "updatedAt" to "updated_at";

alter table "public"."articles" rename column "createdAt" to "created_at";

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE OR REPLACE FUNCTION public.set_current_timestamp_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updatedAt" = NOW();
  RETURN _new;
END;
$function$;

alter table "public"."children" alter column "birthYear" drop not null;
alter table "public"."children" add column "birthYear" int4;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."children" add column "birthDate" date
 null;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."members" add column "nif" text
 null unique;

alter table "public"."children" rename column "updatedAt" to "updated_at";

alter table "public"."children" rename column "createdAt" to "created_at";

alter table "public"."children" rename column "familyId" to "family_id";

alter table "public"."children" rename column "birthYear" to "birthyear";

alter table "public"."children" rename column "lastName" to "lastname";

alter table "public"."children" rename column "firstName" to "firstname";

alter table "public"."members" rename column "updateAt" to "updated_at";

alter table "public"."members" rename column "createdAt" to "created_at";

alter table "public"."members" rename column "familyId" to "family_id";

alter table "public"."members" rename column "isAdmin" to "isadmin";

alter table "public"."members" rename column "lastName" to "lastname";

alter table "public"."members" rename column "firstName" to "firstname";

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE EXTENSION unaccent;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- DROP FUNCTION public.unaccent(text);

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE OR REPLACE FUNCTION public.unaccent(text)
 RETURNS text
 LANGUAGE c
 STABLE PARALLEL SAFE STRICT
AS '$libdir/unaccent', $function$unaccent_dict$function$;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- DROP FUNCTION public.unaccent(text);

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE OR REPLACE FUNCTION public.slugmaker(articles_translations_row articles_translations)
 RETURNS text
 LANGUAGE sql
 STABLE
AS $function$
 WITH "unaccented" AS (
    SELECT public.unaccent(articles_translations_row.title) AS "value"
  ),
    -- lowercases the string
  "lowercase" AS (
    SELECT lower("value") AS "value"
    FROM "unaccented"
  ),
  -- remove single and double quotes
  "removed_quotes" AS (
    SELECT regexp_replace("value", '[''"]+', '', 'gi') AS "value"
    FROM "lowercase"
  ),
  -- replaces anything that's not a letter, number, hyphen('-'), or underscore('_') with a hyphen('-')
  "hyphenated" AS (
    SELECT regexp_replace("value", '[^a-z0-9\\-_]+', '-', 'gi') AS "value"
    FROM "removed_quotes"
  ),
  -- trims hyphens('-') if they exist on the head or tail of the string
  "trimmed" AS (
    SELECT regexp_replace(regexp_replace("value", '\-+$', ''), '^\-', '') AS "value"
    FROM "hyphenated"
  )
  SELECT "value" FROM "trimmed";
 $function$;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- DROP FUNCTION public.unaccent(regdictionary, text);

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- CREATE OR REPLACE FUNCTION public.unaccent(regdictionary, text)
 RETURNS text
 LANGUAGE c
 STABLE PARALLEL SAFE STRICT
AS '$libdir/unaccent', $function$unaccent_dict$function$;

alter table "public"."members" alter column "email" set not null;

-- Could not auto-generate a down migration.
-- Please write an appropriate down migration for the SQL below:
-- alter table "public"."members" add column "phone" text
 null unique;
