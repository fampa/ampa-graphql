alter table "public"."children"
  add constraint "children_familyId_fkey"
  foreign key ("familyId")
  references "public"."families"
  ("id") on update cascade on delete cascade;
