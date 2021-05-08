alter table "public"."tags" alter column "nameCa" drop not null;
alter table "public"."tags" add column "nameCa" text;
