alter table "public"."articles_translations" drop constraint "article_translations_article_id_fkey",
  add constraint "articles_translations_articleId_fkey"
  foreign key ("articleId")
  references "public"."articles"
  ("id") on update cascade on delete cascade;
