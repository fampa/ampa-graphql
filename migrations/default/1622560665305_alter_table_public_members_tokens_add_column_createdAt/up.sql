alter table "public"."members_tokens" add column "createdAt" timestamptz
 null default now();
