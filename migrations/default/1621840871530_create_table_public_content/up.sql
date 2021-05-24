CREATE TABLE "public"."content" ("id" serial NOT NULL, "isPublished" boolean NOT NULL DEFAULT false, "isMenu" boolean NOT NULL DEFAULT false, "image" text, "icon" text, "authorId" text, "createdAt" timestamptz NOT NULL DEFAULT now(), "updatedAt" timestamptz NOT NULL DEFAULT now(), "type" integer NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("authorId") REFERENCES "public"."members"("id") ON UPDATE set null ON DELETE set null);
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
CREATE TRIGGER "set_public_content_updatedAt"
BEFORE UPDATE ON "public"."content"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_public_content_updatedAt" ON "public"."content" 
IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
