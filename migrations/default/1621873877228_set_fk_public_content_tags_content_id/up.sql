alter table "public"."content_tags"
  add constraint "content_tags_content_id_fkey"
  foreign key ("content_id")
  references "public"."content"
  ("id") on update cascade on delete cascade;
