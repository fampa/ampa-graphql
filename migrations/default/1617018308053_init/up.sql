CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.articles_translations (
    article_id integer NOT NULL,
    language text NOT NULL,
    title text NOT NULL,
    content text NOT NULL
);
CREATE FUNCTION public.slugmaker(articles_translations_row public.articles_translations) RETURNS text
    LANGUAGE sql STABLE
    AS $_$
 WITH "unaccented" AS (
    SELECT unaccent(articles_translations_row.title) AS "value"
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
CREATE TABLE public.article_statuses (
    status text NOT NULL
);
CREATE TABLE public.article_tags (
    article_id integer NOT NULL,
    tag_id integer NOT NULL
);
CREATE TABLE public.tags (
    id integer NOT NULL,
    name_es text,
    name_ca text
);
CREATE SEQUENCE public.article_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.article_tags_id_seq OWNED BY public.tags.id;
CREATE TABLE public.articles (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    status text DEFAULT 'DRAFT'::text NOT NULL,
    image text,
    author_id text
);
CREATE SEQUENCE public.articles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;
CREATE TABLE public.children (
    id integer NOT NULL,
    firstname text,
    lastname text,
    birthyear integer,
    family_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);
CREATE SEQUENCE public.children_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.children_id_seq OWNED BY public.children.id;
CREATE TABLE public.families (
    id integer NOT NULL,
    name text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
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
    firstname text,
    lastname text,
    email text NOT NULL,
    family_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    isadmin boolean DEFAULT false
);
CREATE SEQUENCE public.members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.members_id_seq OWNED BY public.members.id;
ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);
ALTER TABLE ONLY public.children ALTER COLUMN id SET DEFAULT nextval('public.children_id_seq'::regclass);
ALTER TABLE ONLY public.families ALTER COLUMN id SET DEFAULT nextval('public.families_id_seq'::regclass);
ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.article_tags_id_seq'::regclass);
ALTER TABLE ONLY public.article_statuses
    ADD CONSTRAINT article_statuses_enum_pkey PRIMARY KEY (status);
ALTER TABLE ONLY public.tags
    ADD CONSTRAINT article_tags_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.article_tags
    ADD CONSTRAINT article_tags_pkey1 PRIMARY KEY (article_id, tag_id);
ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.articles_translations
    ADD CONSTRAINT articles_translations_pkey PRIMARY KEY (article_id, language);
ALTER TABLE ONLY public.children
    ADD CONSTRAINT children_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.families
    ADD CONSTRAINT families_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_enum_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_email_key UNIQUE (email);
ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);
CREATE TRIGGER set_public_articles_updated_at BEFORE UPDATE ON public.articles FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_articles_updated_at ON public.articles IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_children_updated_at BEFORE UPDATE ON public.children FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_children_updated_at ON public.children IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_families_updated_at BEFORE UPDATE ON public.families FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_families_updated_at ON public.families IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_members_updated_at BEFORE UPDATE ON public.members FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_members_updated_at ON public.members IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.article_tags
    ADD CONSTRAINT article_tags_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.articles(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.article_tags
    ADD CONSTRAINT article_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.articles_translations
    ADD CONSTRAINT article_translations_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.articles(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.members(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_status_fkey FOREIGN KEY (status) REFERENCES public.article_statuses(status) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.articles_translations
    ADD CONSTRAINT articles_translations_language_fkey FOREIGN KEY (language) REFERENCES public.languages(code) ON UPDATE RESTRICT ON DELETE RESTRICT;
