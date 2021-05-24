alter table "public"."content"
  add constraint "content_type_fkey"
  foreign key ("type")
  references "public"."contentTypes"
  ("id") on update set null on delete set null;
