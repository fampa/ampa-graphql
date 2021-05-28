alter table "public"."content_tags"
  add constraint "article_tags_tag_id_fkey"
  foreign key ("tag_id")
  references "public"."tags"
  ("id") on update restrict on delete restrict;
