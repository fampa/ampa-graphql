alter table "public"."childService"
  add constraint "childService_serviceId_fkey"
  foreign key ("serviceId")
  references "public"."content"
  ("id") on update cascade on delete cascade;
