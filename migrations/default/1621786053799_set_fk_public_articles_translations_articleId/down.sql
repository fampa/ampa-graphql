alter table "public"."articles_translations" drop constraint "articles_translations_articleId_fkey",
  add constraint "article_translations_article_id_fkey"
  foreign key ("articleId")
  references "public"."articles"
  ("id") on update restrict on delete restrict;
