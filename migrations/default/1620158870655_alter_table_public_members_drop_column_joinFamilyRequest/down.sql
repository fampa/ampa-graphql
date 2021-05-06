alter table "public"."members" alter column "joinFamilyRequest" drop not null;
alter table "public"."members" add column "joinFamilyRequest" text;
