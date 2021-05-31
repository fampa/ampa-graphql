alter table "public"."services"
  add constraint "services_typeId_fkey"
  foreign key ("typeId")
  references "public"."service_types"
  ("id") on update cascade on delete cascade;
