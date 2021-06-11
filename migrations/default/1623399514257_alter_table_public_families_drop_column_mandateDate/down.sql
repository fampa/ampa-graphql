alter table "public"."families" alter column "mandateDate" drop not null;
alter table "public"."families" add column "mandateDate" date;
