
alter table "public"."members" add column "phone" text
 null unique;

alter table "public"."members" alter column "email" drop not null;

CREATE OR REPLACE FUNCTION public.unaccent(regdictionary, text)
 RETURNS text
 LANGUAGE c
 STABLE PARALLEL SAFE STRICT
AS '$libdir/unaccent', $function$unaccent_dict$function$;

DROP FUNCTION public.unaccent(regdictionary, text);

CREATE OR REPLACE FUNCTION public.slugmaker(articles_translations_row articles_translations)
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

DROP FUNCTION public.unaccent(text);

CREATE OR REPLACE FUNCTION public.unaccent(text)
 RETURNS text
 LANGUAGE c
 STABLE PARALLEL SAFE STRICT
AS '$libdir/unaccent', $function$unaccent_dict$function$;

DROP FUNCTION public.unaccent(text);

CREATE EXTENSION unaccent;

alter table "public"."members" rename column "firstname" to "firstName";

alter table "public"."members" rename column "lastname" to "lastName";

alter table "public"."members" rename column "isadmin" to "isAdmin";

alter table "public"."members" rename column "family_id" to "familyId";

alter table "public"."members" rename column "created_at" to "createdAt";

alter table "public"."members" rename column "updated_at" to "updateAt";

alter table "public"."children" rename column "firstname" to "firstName";

alter table "public"."children" rename column "lastname" to "lastName";

alter table "public"."children" rename column "birthyear" to "birthYear";

alter table "public"."children" rename column "family_id" to "familyId";

alter table "public"."children" rename column "created_at" to "createdAt";

alter table "public"."children" rename column "updated_at" to "updatedAt";

alter table "public"."members" add column "nif" text
 null unique;

alter table "public"."children" add column "birthDate" date
 null;

alter table "public"."children" drop column "birthYear" cascade;

CREATE OR REPLACE FUNCTION public.set_current_timestamp_updated_at()
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

alter table "public"."articles" rename column "created_at" to "createdAt";

alter table "public"."articles" rename column "updated_at" to "updatedAt";

alter table "public"."articles" rename column "author_id" to "authorId";

alter table "public"."articles_translations" rename column "article_id" to "articleId";

alter table "public"."tags" rename column "name_es" to "nameEs";

alter table "public"."tags" rename column "name_ca" to "nameCa";

alter table "public"."members" rename column "updateAt" to "updatedAt";

alter table "public"."members" drop constraint "members_phone_key";
