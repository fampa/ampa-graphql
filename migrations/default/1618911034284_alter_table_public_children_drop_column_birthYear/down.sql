alter table "public"."children" alter column "birthYear" drop not null;
alter table "public"."children" add column "birthYear" int4;
