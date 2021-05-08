alter table "public"."tags" alter column "nameEs" drop not null;
alter table "public"."tags" add column "nameEs" text;
