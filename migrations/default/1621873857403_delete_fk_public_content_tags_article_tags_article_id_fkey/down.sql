alter table "public"."content_tags"
  add constraint "article_tags_article_id_fkey"
  foreign key ("content_id")
  references "public"."articles"
  ("id") on update restrict on delete restrict;
