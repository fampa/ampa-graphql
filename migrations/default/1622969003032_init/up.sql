SET check_function_bodies = false;
CREATE TABLE public.families (
    id integer NOT NULL,
    name text,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now(),
    iban text,
    "ownerId" text,
    "mandateId" text,
    "mandateDate" date,
    "signatureDate" date
);
CREATE FUNCTION public.search_families(search text) RETURNS SETOF public.families
    LANGUAGE sql STABLE
    AS $$ 
SELECT   * 
FROM     families 
WHERE    search <% ( NAME ) 
ORDER BY similarity(search, ( NAME )) DESC limit 5; 
$$;
CREATE FUNCTION public."set_current_timestamp_updatedAt"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updatedAt" = NOW();
  RETURN _new;
END;
$$;
CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updatedAt" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.content_translations (
    "parentId" integer NOT NULL,
    language text NOT NULL,
    title text,
    content text
);
CREATE FUNCTION public.slugger(content_translations_row public.content_translations) RETURNS text
    LANGUAGE sql STABLE
    AS $_$
 WITH "unaccented" AS (
    SELECT public.unaccent(content_translations_row.title) AS "value"
  ),
    -- lowercases the string
  "lowercase" AS (
    SELECT lower("value") AS "value"
    FROM "unaccented"
  ),
  -- remove single and double quotes
  "removed_quotes" AS (
    SELECT regexp_replace("value", '[''"]+', '', 'gi') AS "value"
    FROM "lowercase"
  ),
  -- replaces anything that's not a letter, number, hyphen('-'), or underscore('_') with a hyphen('-')
  "hyphenated" AS (
    SELECT regexp_replace("value", '[^a-z0-9\\-_]+', '-', 'gi') AS "value"
    FROM "removed_quotes"
  ),
  -- trims hyphens('-') if they exist on the head or tail of the string
  "trimmed" AS (
    SELECT regexp_replace(regexp_replace("value", '\-+$', ''), '^\-', '') AS "value"
    FROM "hyphenated"
  )
  SELECT "value" FROM "trimmed";
 $_$;
CREATE TABLE public."childService" (
    "childId" integer NOT NULL,
    "serviceId" integer NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now()
);
CREATE TABLE public.children (
    id integer NOT NULL,
    "firstName" text,
    "lastName" text,
    "familyId" integer NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now(),
    "birthDate" date
);
CREATE SEQUENCE public.children_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.children_id_seq OWNED BY public.children.id;
CREATE TABLE public.content (
    id integer NOT NULL,
    "isPublished" boolean DEFAULT false NOT NULL,
    "isMenu" boolean DEFAULT false NOT NULL,
    image text,
    icon text DEFAULT 'las la-school'::text,
    "authorId" text,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL,
    type text DEFAULT 'article'::text,
    price numeric,
    spots integer
);
CREATE SEQUENCE public.content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.content_id_seq OWNED BY public.content.id;
CREATE TABLE public.content_tags (
    content_id integer NOT NULL,
    tag_id integer NOT NULL
);
CREATE SEQUENCE public.families_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.families_id_seq OWNED BY public.families.id;
CREATE TABLE public.languages (
    code text NOT NULL,
    name text NOT NULL
);
CREATE TABLE public.members (
    id text NOT NULL,
    "firstName" text,
    "lastName" text,
    email text,
    "familyId" integer,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now(),
    "isAdmin" boolean DEFAULT false,
    phone text,
    nif text,
    "hasRequestedJoinFamily" boolean DEFAULT false,
    "joinFamilyRequest" jsonb,
    "canEmail" boolean DEFAULT true
);
CREATE SEQUENCE public.members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.members_id_seq OWNED BY public.members.id;
CREATE TABLE public.members_messages (
    "messageId" integer NOT NULL,
    "memberId" text NOT NULL,
    read boolean DEFAULT false
);
CREATE TABLE public.members_tokens (
    "memberId" text NOT NULL,
    token text NOT NULL,
    "createdAt" timestamp with time zone DEFAULT now()
);
CREATE TABLE public.messages (
    id integer NOT NULL,
    title text NOT NULL,
    content text,
    "createdAt" timestamp with time zone DEFAULT now() NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;
ALTER TABLE ONLY public.children ALTER COLUMN id SET DEFAULT nextval('public.children_id_seq'::regclass);
ALTER TABLE ONLY public.content ALTER COLUMN id SET DEFAULT nextval('public.content_id_seq'::regclass);
ALTER TABLE ONLY public.families ALTER COLUMN id SET DEFAULT nextval('public.families_id_seq'::regclass);
ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);
ALTER TABLE ONLY public.content_tags
    ADD CONSTRAINT article_tags_pkey1 PRIMARY KEY (content_id, tag_id);
ALTER TABLE ONLY public."childService"
    ADD CONSTRAINT "childService_pkey" PRIMARY KEY ("childId", "serviceId");
ALTER TABLE ONLY public.children
    ADD CONSTRAINT children_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.content_translations
    ADD CONSTRAINT "contentTranslations_pkey" PRIMARY KEY ("parentId", language);
ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.families
    ADD CONSTRAINT "families_mandateId_key" UNIQUE ("mandateId");
ALTER TABLE ONLY public.families
    ADD CONSTRAINT families_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_enum_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_email_key UNIQUE (email);
ALTER TABLE ONLY public.members_messages
    ADD CONSTRAINT members_messages_pkey PRIMARY KEY ("messageId", "memberId");
ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_nif_key UNIQUE (nif);
ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.members_tokens
    ADD CONSTRAINT members_tokens_pkey PRIMARY KEY ("memberId", token);
ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);
CREATE INDEX families_name_gin_idx ON public.families USING gin (name public.gin_trgm_ops);
CREATE TRIGGER "set_public_childService_updatedAt" BEFORE UPDATE ON public."childService" FOR EACH ROW EXECUTE FUNCTION public."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_public_childService_updatedAt" ON public."childService" IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
CREATE TRIGGER set_public_children_updated_at BEFORE UPDATE ON public.children FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_children_updated_at ON public.children IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_public_content_updatedAt" BEFORE UPDATE ON public.content FOR EACH ROW EXECUTE FUNCTION public."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_public_content_updatedAt" ON public.content IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
CREATE TRIGGER set_public_families_updated_at BEFORE UPDATE ON public.families FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_families_updated_at ON public.families IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_members_updated_at BEFORE UPDATE ON public.members FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_members_updated_at ON public.members IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER "set_public_messages_updatedAt" BEFORE UPDATE ON public.messages FOR EACH ROW EXECUTE FUNCTION public."set_current_timestamp_updatedAt"();
COMMENT ON TRIGGER "set_public_messages_updatedAt" ON public.messages IS 'trigger to set value of column "updatedAt" to current timestamp on row update';
ALTER TABLE ONLY public."childService"
    ADD CONSTRAINT "childService_childId_fkey" FOREIGN KEY ("childId") REFERENCES public.children(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public."childService"
    ADD CONSTRAINT "childService_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES public.content(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.content_translations
    ADD CONSTRAINT "contentTranslations_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public.content(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.content
    ADD CONSTRAINT "content_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public.members(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.content_tags
    ADD CONSTRAINT content_tags_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.content(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.families
    ADD CONSTRAINT "families_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES public.members(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.members_messages
    ADD CONSTRAINT "members_messages_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES public.members(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.members_messages
    ADD CONSTRAINT "members_messages_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES public.messages(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.members_tokens
    ADD CONSTRAINT "members_tokens_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES public.members(id) ON UPDATE CASCADE ON DELETE CASCADE;
