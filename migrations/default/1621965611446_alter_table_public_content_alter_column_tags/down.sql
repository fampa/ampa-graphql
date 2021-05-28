alter table "public"."content" rename column "tagIds" to "tags";
ALTER TABLE "public"."content" ALTER COLUMN "tags" TYPE ARRAY;
