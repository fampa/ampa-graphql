alter table "public"."content" alter column "tagIds" drop not null;
alter table "public"."content" add column "tagIds" _int4;
