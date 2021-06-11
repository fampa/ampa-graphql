alter table "public"."families" add constraint "families_mandateSignatureCode_key" unique (mandateSignatureCode);
alter table "public"."families" alter column "mandateSignatureCode" drop not null;
alter table "public"."families" add column "mandateSignatureCode" text;
