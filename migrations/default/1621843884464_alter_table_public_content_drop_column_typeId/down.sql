alter table "public"."content" alter column "typeId" set default 1;
alter table "public"."content"
  add constraint "content_type_fkey"
  foreign key (typeId)
  references "public"."content_types"
  (id) on update set null on delete set null;
alter table "public"."content" alter column "typeId" drop not null;
alter table "public"."content" add column "typeId" int4;
