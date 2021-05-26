alter table "public"."tags" add column "type" text
 null default 'ARTICLE'::text;
