alter table "public"."childService" drop constraint "childService_childId_fkey",
  add constraint "childService_childId_fkey"
  foreign key ("childId")
  references "public"."children"
  ("id") on update set null on delete set null;
