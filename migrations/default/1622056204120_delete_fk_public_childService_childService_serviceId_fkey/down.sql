alter table "public"."childService"
  add constraint "childService_serviceId_fkey"
  foreign key ("serviceId")
  references "public"."services"
  ("id") on update set null on delete set null;
