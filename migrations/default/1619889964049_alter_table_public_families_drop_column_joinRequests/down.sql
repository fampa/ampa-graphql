alter table "public"."families" alter column "joinRequests" drop not null;
alter table "public"."families" add column "joinRequests" text;
