alter table "public"."families"
  add constraint "families_ownerId_fkey"
  foreign key ("ownerId")
  references "public"."members"
  ("id") on update cascade on delete cascade;
