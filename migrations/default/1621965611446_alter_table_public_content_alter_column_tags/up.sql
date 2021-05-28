ALTER TABLE "public"."content" ALTER COLUMN "tags" TYPE int4[];
alter table "public"."content" rename column "tags" to "tagIds";
