alter table "public"."tags_translations"
  add constraint "tag_translations_tagId_fkey"
  foreign key ("tagId")
  references "public"."tags"
  ("id") on update cascade on delete cascade;
