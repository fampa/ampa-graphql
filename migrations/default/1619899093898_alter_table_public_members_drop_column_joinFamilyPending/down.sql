alter table "public"."members" alter column "joinFamilyPending" set default false;
alter table "public"."members" alter column "joinFamilyPending" drop not null;
alter table "public"."members" add column "joinFamilyPending" bool;
