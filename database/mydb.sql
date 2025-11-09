--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

-- Started on 2025-11-09 16:32:20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.templates DROP CONSTRAINT IF EXISTS templates_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_reviewer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_inspection_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reports DROP CONSTRAINT IF EXISTS reports_template_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reports DROP CONSTRAINT IF EXISTS reports_inspection_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reports DROP CONSTRAINT IF EXISTS reports_generated_by_fkey;
ALTER TABLE IF EXISTS ONLY public.presets DROP CONSTRAINT IF EXISTS presets_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.photos DROP CONSTRAINT IF EXISTS photos_uploaded_by_fkey;
ALTER TABLE IF EXISTS ONLY public.photos DROP CONSTRAINT IF EXISTS photos_inspection_id_fkey;
ALTER TABLE IF EXISTS ONLY public.observations DROP CONSTRAINT IF EXISTS observations_photo_id_fkey;
ALTER TABLE IF EXISTS ONLY public.observations DROP CONSTRAINT IF EXISTS observations_inspection_id_fkey;
ALTER TABLE IF EXISTS ONLY public.observations DROP CONSTRAINT IF EXISTS observations_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.inspections DROP CONSTRAINT IF EXISTS inspections_vessel_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inspections DROP CONSTRAINT IF EXISTS inspections_reviewer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.inspections DROP CONSTRAINT IF EXISTS inspections_inspector_id_fkey;
ALTER TABLE IF EXISTS ONLY public.activity_logs DROP CONSTRAINT IF EXISTS activity_logs_user_id_fkey;
DROP TRIGGER IF EXISTS update_vessel_modtime ON public.vessels;
DROP TRIGGER IF EXISTS update_user_modtime ON public.users;
DROP TRIGGER IF EXISTS update_observation_modtime ON public.observations;
DROP TRIGGER IF EXISTS update_inspection_modtime ON public.inspections;
DROP INDEX IF EXISTS public.idx_users_username;
DROP INDEX IF EXISTS public.idx_reviews_inspection_id;
DROP INDEX IF EXISTS public.idx_reports_inspection_id;
DROP INDEX IF EXISTS public.idx_photos_inspection_id;
DROP INDEX IF EXISTS public.idx_observations_inspection_id;
DROP INDEX IF EXISTS public.idx_inspections_vessel_id;
DROP INDEX IF EXISTS public.idx_inspections_status;
ALTER TABLE IF EXISTS ONLY public.vessels DROP CONSTRAINT IF EXISTS vessels_tag_no_key;
ALTER TABLE IF EXISTS ONLY public.vessels DROP CONSTRAINT IF EXISTS vessels_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.templates DROP CONSTRAINT IF EXISTS templates_pkey;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_pkey;
ALTER TABLE IF EXISTS ONLY public.reports DROP CONSTRAINT IF EXISTS reports_pkey;
ALTER TABLE IF EXISTS ONLY public.presets DROP CONSTRAINT IF EXISTS presets_pkey;
ALTER TABLE IF EXISTS ONLY public.photos DROP CONSTRAINT IF EXISTS photos_pkey;
ALTER TABLE IF EXISTS ONLY public.observations DROP CONSTRAINT IF EXISTS observations_pkey;
ALTER TABLE IF EXISTS ONLY public.inspections DROP CONSTRAINT IF EXISTS inspections_pkey;
ALTER TABLE IF EXISTS ONLY public.activity_logs DROP CONSTRAINT IF EXISTS activity_logs_pkey;
ALTER TABLE IF EXISTS public.vessels ALTER COLUMN vessel_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.users ALTER COLUMN user_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.templates ALTER COLUMN template_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.reviews ALTER COLUMN review_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.reports ALTER COLUMN report_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.presets ALTER COLUMN preset_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.photos ALTER COLUMN photo_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.observations ALTER COLUMN observation_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.inspections ALTER COLUMN inspection_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.activity_logs ALTER COLUMN log_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.vessels_vessel_id_seq;
DROP TABLE IF EXISTS public.vessels;
DROP SEQUENCE IF EXISTS public.users_user_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.templates_template_id_seq;
DROP TABLE IF EXISTS public.templates;
DROP SEQUENCE IF EXISTS public.reviews_review_id_seq;
DROP TABLE IF EXISTS public.reviews;
DROP SEQUENCE IF EXISTS public.reports_report_id_seq;
DROP TABLE IF EXISTS public.reports;
DROP SEQUENCE IF EXISTS public.presets_preset_id_seq;
DROP TABLE IF EXISTS public.presets;
DROP SEQUENCE IF EXISTS public.photos_photo_id_seq;
DROP TABLE IF EXISTS public.photos;
DROP SEQUENCE IF EXISTS public.observations_observation_id_seq;
DROP TABLE IF EXISTS public.observations;
DROP SEQUENCE IF EXISTS public.inspections_inspection_id_seq;
DROP TABLE IF EXISTS public.inspections;
DROP SEQUENCE IF EXISTS public.activity_logs_log_id_seq;
DROP TABLE IF EXISTS public.activity_logs;
DROP FUNCTION IF EXISTS public.update_modified_column();
--
-- TOC entry 234 (class 1255 OID 32986)
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modified_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 233 (class 1259 OID 32966)
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    log_id integer NOT NULL,
    user_id integer,
    action character varying(100),
    entity character varying(50),
    entity_id integer,
    details jsonb,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 32965)
-- Name: activity_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_logs_log_id_seq OWNER TO postgres;

--
-- TOC entry 3476 (class 0 OID 0)
-- Dependencies: 232
-- Name: activity_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_logs_log_id_seq OWNED BY public.activity_logs.log_id;


--
-- TOC entry 219 (class 1259 OID 32808)
-- Name: inspections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inspections (
    inspection_id integer NOT NULL,
    vessel_id integer,
    inspector_id integer,
    reviewer_id integer,
    status character varying(20) DEFAULT 'draft'::character varying,
    inspection_date date,
    remarks text,
    version integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT inspections_status_check CHECK (((status)::text = ANY ((ARRAY['draft'::character varying, 'submitted'::character varying, 'approved'::character varying])::text[])))
);


ALTER TABLE public.inspections OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 32807)
-- Name: inspections_inspection_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inspections_inspection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inspections_inspection_id_seq OWNER TO postgres;

--
-- TOC entry 3477 (class 0 OID 0)
-- Dependencies: 218
-- Name: inspections_inspection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inspections_inspection_id_seq OWNED BY public.inspections.inspection_id;


--
-- TOC entry 223 (class 1259 OID 32857)
-- Name: observations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observations (
    observation_id integer NOT NULL,
    inspection_id integer,
    photo_id integer,
    component character varying(100),
    finding_text text,
    recommendation_text text,
    severity character varying(20),
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT observations_severity_check CHECK (((severity)::text = ANY ((ARRAY['Minor'::character varying, 'Moderate'::character varying, 'Critical'::character varying])::text[])))
);


ALTER TABLE public.observations OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 32856)
-- Name: observations_observation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.observations_observation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.observations_observation_id_seq OWNER TO postgres;

--
-- TOC entry 3478 (class 0 OID 0)
-- Dependencies: 222
-- Name: observations_observation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.observations_observation_id_seq OWNED BY public.observations.observation_id;


--
-- TOC entry 221 (class 1259 OID 32837)
-- Name: photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.photos (
    photo_id integer NOT NULL,
    inspection_id integer,
    file_url text NOT NULL,
    tag_number character varying(50),
    component character varying(100),
    caption text,
    uploaded_by integer,
    sequence_no integer,
    metadata jsonb,
    uploaded_at timestamp without time zone DEFAULT now(),
    object_key text
);


ALTER TABLE public.photos OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 32836)
-- Name: photos_photo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.photos_photo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.photos_photo_id_seq OWNER TO postgres;

--
-- TOC entry 3479 (class 0 OID 0)
-- Dependencies: 220
-- Name: photos_photo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.photos_photo_id_seq OWNED BY public.photos.photo_id;


--
-- TOC entry 225 (class 1259 OID 32884)
-- Name: presets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.presets (
    preset_id integer NOT NULL,
    category character varying(50),
    preset_text text NOT NULL,
    type character varying(20),
    placeholders jsonb,
    severity_hint character varying(20),
    active boolean DEFAULT true,
    created_by integer,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT presets_type_check CHECK (((type)::text = ANY ((ARRAY['finding'::character varying, 'recommendation'::character varying])::text[])))
);


ALTER TABLE public.presets OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 32883)
-- Name: presets_preset_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.presets_preset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.presets_preset_id_seq OWNER TO postgres;

--
-- TOC entry 3480 (class 0 OID 0)
-- Dependencies: 224
-- Name: presets_preset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.presets_preset_id_seq OWNED BY public.presets.preset_id;


--
-- TOC entry 229 (class 1259 OID 32918)
-- Name: reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reports (
    report_id integer NOT NULL,
    inspection_id integer,
    template_id integer,
    file_url text NOT NULL,
    generated_by integer,
    status character varying(20) DEFAULT 'draft'::character varying,
    generated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT reports_status_check CHECK (((status)::text = ANY ((ARRAY['draft'::character varying, 'final'::character varying, 'locked'::character varying])::text[])))
);


ALTER TABLE public.reports OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 32917)
-- Name: reports_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reports_report_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reports_report_id_seq OWNER TO postgres;

--
-- TOC entry 3481 (class 0 OID 0)
-- Dependencies: 228
-- Name: reports_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reports_report_id_seq OWNED BY public.reports.report_id;


--
-- TOC entry 231 (class 1259 OID 32945)
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    review_id integer NOT NULL,
    inspection_id integer,
    reviewer_id integer,
    comments text,
    status character varying(20),
    reviewed_at timestamp without time zone DEFAULT now(),
    CONSTRAINT reviews_status_check CHECK (((status)::text = ANY ((ARRAY['approved'::character varying, 'rejected'::character varying, 'changes_requested'::character varying])::text[])))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 32944)
-- Name: reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviews_review_id_seq OWNER TO postgres;

--
-- TOC entry 3482 (class 0 OID 0)
-- Dependencies: 230
-- Name: reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_review_id_seq OWNED BY public.reviews.review_id;


--
-- TOC entry 227 (class 1259 OID 32901)
-- Name: templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.templates (
    template_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    template_html text,
    version integer DEFAULT 1,
    active boolean DEFAULT true,
    created_by integer,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.templates OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 32900)
-- Name: templates_template_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.templates_template_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.templates_template_id_seq OWNER TO postgres;

--
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 226
-- Name: templates_template_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.templates_template_id_seq OWNED BY public.templates.template_id;


--
-- TOC entry 215 (class 1259 OID 32780)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    role character varying(20) NOT NULL,
    department character varying(100),
    certification_id character varying(50),
    active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    username character varying(50) NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['inspector'::character varying, 'reviewer'::character varying, 'admin'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 32779)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 217 (class 1259 OID 32795)
-- Name: vessels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vessels (
    vessel_id integer NOT NULL,
    tag_no character varying(50) NOT NULL,
    description text,
    plant_unit character varying(100),
    location character varying(100),
    design_data jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.vessels OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 32794)
-- Name: vessels_vessel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vessels_vessel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vessels_vessel_id_seq OWNER TO postgres;

--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 216
-- Name: vessels_vessel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vessels_vessel_id_seq OWNED BY public.vessels.vessel_id;


--
-- TOC entry 3248 (class 2604 OID 32969)
-- Name: activity_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs ALTER COLUMN log_id SET DEFAULT nextval('public.activity_logs_log_id_seq'::regclass);


--
-- TOC entry 3226 (class 2604 OID 32811)
-- Name: inspections inspection_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspections ALTER COLUMN inspection_id SET DEFAULT nextval('public.inspections_inspection_id_seq'::regclass);


--
-- TOC entry 3233 (class 2604 OID 32860)
-- Name: observations observation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observations ALTER COLUMN observation_id SET DEFAULT nextval('public.observations_observation_id_seq'::regclass);


--
-- TOC entry 3231 (class 2604 OID 32840)
-- Name: photos photo_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos ALTER COLUMN photo_id SET DEFAULT nextval('public.photos_photo_id_seq'::regclass);


--
-- TOC entry 3236 (class 2604 OID 32887)
-- Name: presets preset_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presets ALTER COLUMN preset_id SET DEFAULT nextval('public.presets_preset_id_seq'::regclass);


--
-- TOC entry 3243 (class 2604 OID 32921)
-- Name: reports report_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports ALTER COLUMN report_id SET DEFAULT nextval('public.reports_report_id_seq'::regclass);


--
-- TOC entry 3246 (class 2604 OID 32948)
-- Name: reviews review_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN review_id SET DEFAULT nextval('public.reviews_review_id_seq'::regclass);


--
-- TOC entry 3239 (class 2604 OID 32904)
-- Name: templates template_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templates ALTER COLUMN template_id SET DEFAULT nextval('public.templates_template_id_seq'::regclass);


--
-- TOC entry 3219 (class 2604 OID 32783)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3223 (class 2604 OID 32798)
-- Name: vessels vessel_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vessels ALTER COLUMN vessel_id SET DEFAULT nextval('public.vessels_vessel_id_seq'::regclass);


--
-- TOC entry 3470 (class 0 OID 32966)
-- Dependencies: 233
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity_logs (log_id, user_id, action, entity, entity_id, details, created_at) FROM stdin;
\.


--
-- TOC entry 3456 (class 0 OID 32808)
-- Dependencies: 219
-- Data for Name: inspections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inspections (inspection_id, vessel_id, inspector_id, reviewer_id, status, inspection_date, remarks, version, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3460 (class 0 OID 32857)
-- Dependencies: 223
-- Data for Name: observations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.observations (observation_id, inspection_id, photo_id, component, finding_text, recommendation_text, severity, created_by, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3458 (class 0 OID 32837)
-- Dependencies: 221
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.photos (photo_id, inspection_id, file_url, tag_number, component, caption, uploaded_by, sequence_no, metadata, uploaded_at, object_key) FROM stdin;
\.


--
-- TOC entry 3462 (class 0 OID 32884)
-- Dependencies: 225
-- Data for Name: presets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.presets (preset_id, category, preset_text, type, placeholders, severity_hint, active, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 3466 (class 0 OID 32918)
-- Dependencies: 229
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reports (report_id, inspection_id, template_id, file_url, generated_by, status, generated_at) FROM stdin;
\.


--
-- TOC entry 3468 (class 0 OID 32945)
-- Dependencies: 231
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (review_id, inspection_id, reviewer_id, comments, status, reviewed_at) FROM stdin;
\.


--
-- TOC entry 3464 (class 0 OID 32901)
-- Dependencies: 227
-- Data for Name: templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.templates (template_id, name, description, template_html, version, active, created_by, created_at) FROM stdin;
\.


--
-- TOC entry 3452 (class 0 OID 32780)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, name, email, password_hash, role, department, certification_id, active, created_at, updated_at, username) FROM stdin;
\.


--
-- TOC entry 3454 (class 0 OID 32795)
-- Dependencies: 217
-- Data for Name: vessels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vessels (vessel_id, tag_no, description, plant_unit, location, design_data, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 232
-- Name: activity_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_logs_log_id_seq', 1, false);


--
-- TOC entry 3487 (class 0 OID 0)
-- Dependencies: 218
-- Name: inspections_inspection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inspections_inspection_id_seq', 1, false);


--
-- TOC entry 3488 (class 0 OID 0)
-- Dependencies: 222
-- Name: observations_observation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.observations_observation_id_seq', 1, false);


--
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 220
-- Name: photos_photo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.photos_photo_id_seq', 1, false);


--
-- TOC entry 3490 (class 0 OID 0)
-- Dependencies: 224
-- Name: presets_preset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.presets_preset_id_seq', 1, false);


--
-- TOC entry 3491 (class 0 OID 0)
-- Dependencies: 228
-- Name: reports_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reports_report_id_seq', 1, false);


--
-- TOC entry 3492 (class 0 OID 0)
-- Dependencies: 230
-- Name: reviews_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_review_id_seq', 1, false);


--
-- TOC entry 3493 (class 0 OID 0)
-- Dependencies: 226
-- Name: templates_template_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.templates_template_id_seq', 1, false);


--
-- TOC entry 3494 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 216
-- Name: vessels_vessel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vessels_vessel_id_seq', 1, false);


--
-- TOC entry 3288 (class 2606 OID 32974)
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (log_id);


--
-- TOC entry 3270 (class 2606 OID 32820)
-- Name: inspections inspections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspections
    ADD CONSTRAINT inspections_pkey PRIMARY KEY (inspection_id);


--
-- TOC entry 3276 (class 2606 OID 32867)
-- Name: observations observations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_pkey PRIMARY KEY (observation_id);


--
-- TOC entry 3273 (class 2606 OID 32845)
-- Name: photos photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (photo_id);


--
-- TOC entry 3278 (class 2606 OID 32894)
-- Name: presets presets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presets
    ADD CONSTRAINT presets_pkey PRIMARY KEY (preset_id);


--
-- TOC entry 3283 (class 2606 OID 32928)
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (report_id);


--
-- TOC entry 3286 (class 2606 OID 32954)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);


--
-- TOC entry 3280 (class 2606 OID 32911)
-- Name: templates templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (template_id);


--
-- TOC entry 3258 (class 2606 OID 32793)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3260 (class 2606 OID 32791)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3262 (class 2606 OID 40971)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3264 (class 2606 OID 32804)
-- Name: vessels vessels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vessels
    ADD CONSTRAINT vessels_pkey PRIMARY KEY (vessel_id);


--
-- TOC entry 3266 (class 2606 OID 32806)
-- Name: vessels vessels_tag_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vessels
    ADD CONSTRAINT vessels_tag_no_key UNIQUE (tag_no);


--
-- TOC entry 3267 (class 1259 OID 32981)
-- Name: idx_inspections_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inspections_status ON public.inspections USING btree (status);


--
-- TOC entry 3268 (class 1259 OID 32980)
-- Name: idx_inspections_vessel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inspections_vessel_id ON public.inspections USING btree (vessel_id);


--
-- TOC entry 3274 (class 1259 OID 32983)
-- Name: idx_observations_inspection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_observations_inspection_id ON public.observations USING btree (inspection_id);


--
-- TOC entry 3271 (class 1259 OID 32982)
-- Name: idx_photos_inspection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_photos_inspection_id ON public.photos USING btree (inspection_id);


--
-- TOC entry 3281 (class 1259 OID 32984)
-- Name: idx_reports_inspection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reports_inspection_id ON public.reports USING btree (inspection_id);


--
-- TOC entry 3284 (class 1259 OID 32985)
-- Name: idx_reviews_inspection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_inspection_id ON public.reviews USING btree (inspection_id);


--
-- TOC entry 3256 (class 1259 OID 40972)
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- TOC entry 3307 (class 2620 OID 32989)
-- Name: inspections update_inspection_modtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_inspection_modtime BEFORE UPDATE ON public.inspections FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- TOC entry 3308 (class 2620 OID 32990)
-- Name: observations update_observation_modtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_observation_modtime BEFORE UPDATE ON public.observations FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- TOC entry 3305 (class 2620 OID 32987)
-- Name: users update_user_modtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_user_modtime BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- TOC entry 3306 (class 2620 OID 32988)
-- Name: vessels update_vessel_modtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_vessel_modtime BEFORE UPDATE ON public.vessels FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- TOC entry 3304 (class 2606 OID 32975)
-- Name: activity_logs activity_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 3289 (class 2606 OID 32826)
-- Name: inspections inspections_inspector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspections
    ADD CONSTRAINT inspections_inspector_id_fkey FOREIGN KEY (inspector_id) REFERENCES public.users(user_id);


--
-- TOC entry 3290 (class 2606 OID 32831)
-- Name: inspections inspections_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspections
    ADD CONSTRAINT inspections_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES public.users(user_id);


--
-- TOC entry 3291 (class 2606 OID 32821)
-- Name: inspections inspections_vessel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspections
    ADD CONSTRAINT inspections_vessel_id_fkey FOREIGN KEY (vessel_id) REFERENCES public.vessels(vessel_id) ON DELETE CASCADE;


--
-- TOC entry 3294 (class 2606 OID 32878)
-- Name: observations observations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id);


--
-- TOC entry 3295 (class 2606 OID 32868)
-- Name: observations observations_inspection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_inspection_id_fkey FOREIGN KEY (inspection_id) REFERENCES public.inspections(inspection_id) ON DELETE CASCADE;


--
-- TOC entry 3296 (class 2606 OID 32873)
-- Name: observations observations_photo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_photo_id_fkey FOREIGN KEY (photo_id) REFERENCES public.photos(photo_id) ON DELETE SET NULL;


--
-- TOC entry 3292 (class 2606 OID 32846)
-- Name: photos photos_inspection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_inspection_id_fkey FOREIGN KEY (inspection_id) REFERENCES public.inspections(inspection_id) ON DELETE CASCADE;


--
-- TOC entry 3293 (class 2606 OID 32851)
-- Name: photos photos_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.photos
    ADD CONSTRAINT photos_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(user_id);


--
-- TOC entry 3297 (class 2606 OID 32895)
-- Name: presets presets_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.presets
    ADD CONSTRAINT presets_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id);


--
-- TOC entry 3299 (class 2606 OID 32939)
-- Name: reports reports_generated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_generated_by_fkey FOREIGN KEY (generated_by) REFERENCES public.users(user_id);


--
-- TOC entry 3300 (class 2606 OID 32929)
-- Name: reports reports_inspection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_inspection_id_fkey FOREIGN KEY (inspection_id) REFERENCES public.inspections(inspection_id) ON DELETE CASCADE;


--
-- TOC entry 3301 (class 2606 OID 32934)
-- Name: reports reports_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.templates(template_id);


--
-- TOC entry 3302 (class 2606 OID 32955)
-- Name: reviews reviews_inspection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_inspection_id_fkey FOREIGN KEY (inspection_id) REFERENCES public.inspections(inspection_id) ON DELETE CASCADE;


--
-- TOC entry 3303 (class 2606 OID 32960)
-- Name: reviews reviews_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES public.users(user_id);


--
-- TOC entry 3298 (class 2606 OID 32912)
-- Name: templates templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id);


-- Completed on 2025-11-09 16:32:20

--
-- PostgreSQL database dump complete
--

