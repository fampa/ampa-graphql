alter table "public"."services" alter column "participants" set default 0;
alter table "public"."services" alter column "participants" drop not null;
alter table "public"."services" add column "participants" int4;
