CREATE TABLE "public"."services" ("id" serial NOT NULL, "name" text NOT NULL, "typeId" integer NOT NULL, "description" text, "periodicity" text, "price" numeric, "isAvailable" boolean NOT NULL DEFAULT false, "createdAt" timestamptz NOT NULL DEFAULT now(), "updatedAt" timestamptz NOT NULL DEFAULT now(), PRIMARY KEY ("id") );
CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updatedAt"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updatedAt" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_services_updatedAt"
BEFORE UPDATE ON "public"."services"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_public_services_updatedAt" ON "public"."services" 
IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
