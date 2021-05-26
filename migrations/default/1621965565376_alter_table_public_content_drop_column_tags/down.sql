alter table "public"."content" alter column "tags" drop not null;
alter table "public"."content" add column "tags" int4;
