--
-- PostgreSQL database dump
--

\restrict 6y6gJgQdZQVzofgROpk3zug9lEjxnifBuJHX1Nx2JvtLfch8gmgp41mV62B8EEm

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-05-01 21:17:23

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 232 (class 1255 OID 57719)
-- Name: add_animal(character varying, character varying, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_animal(IN a_name character varying, IN a_type character varying, IN owner integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Animals(name, type, owner_id)
    VALUES (a_name, a_type, owner);

    RAISE NOTICE 'Animal added successfully';
END;
$$;


ALTER PROCEDURE public.add_animal(IN a_name character varying, IN a_type character varying, IN owner integer) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 57721)
-- Name: add_treatment(integer, character varying, numeric); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_treatment(IN v_id integer, IN t character varying, IN p numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Treatments(visit_id, treatment, price)
    VALUES (v_id, t, p);

    RAISE NOTICE 'Treatment added';
END;
$$;


ALTER PROCEDURE public.add_treatment(IN v_id integer, IN t character varying, IN p numeric) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 57720)
-- Name: add_visit(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_visit(IN a_id integer, IN d_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Visits(animal_id, doctor_id, visit_date)
    VALUES (a_id, d_id, CURRENT_DATE);

    RAISE NOTICE 'Visit created';
END;
$$;


ALTER PROCEDURE public.add_visit(IN a_id integer, IN d_id integer) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 57725)
-- Name: avg_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.avg_price() RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    result NUMERIC;
BEGIN
    SELECT COALESCE(AVG(price),0) INTO result
    FROM Treatments;

    RETURN result;
END;
$$;


ALTER FUNCTION public.avg_price() OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 57740)
-- Name: check_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.price < 0 THEN
        RAISE EXCEPTION 'Price cannot be negative!';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_price() OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 57722)
-- Name: delete_animal(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.delete_animal(IN a_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Animals WHERE id = a_id;

    RAISE NOTICE 'Animal deleted';
END;
$$;


ALTER PROCEDURE public.delete_animal(IN a_id integer) OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 57746)
-- Name: insert_view(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_view() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Visits(animal_id, doctor_id, visit_date)
    VALUES (NEW.animal_id, 1, CURRENT_DATE);

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.insert_view() OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 57738)
-- Name: log_treatment(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_treatment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Logs(message)
    VALUES ('Treatment added with ID: ' || NEW.id);

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_treatment() OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 57726)
-- Name: max_price(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.max_price() RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    result NUMERIC;
BEGIN
    SELECT MAX(price) INTO result FROM Treatments;
    RETURN result;
END;
$$;


ALTER FUNCTION public.max_price() OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 57723)
-- Name: total_income(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.total_income() RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    result NUMERIC;
BEGIN
    SELECT COALESCE(SUM(price),0) INTO result FROM Treatments;
    RETURN result;
END;
$$;


ALTER FUNCTION public.total_income() OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 57724)
-- Name: visit_count(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.visit_count(a_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    result INT;
BEGIN
    SELECT COUNT(*) INTO result
    FROM Visits
    WHERE animal_id = a_id;

    RETURN result;
END;
$$;


ALTER FUNCTION public.visit_count(a_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 57666)
-- Name: animals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animals (
    id integer NOT NULL,
    name character varying(100),
    type character varying(50),
    owner_id integer
);


ALTER TABLE public.animals OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 57665)
-- Name: animals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.animals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.animals_id_seq OWNER TO postgres;

--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 221
-- Name: animals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.animals_id_seq OWNED BY public.animals.id;


--
-- TOC entry 224 (class 1259 OID 57679)
-- Name: doctors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctors (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE public.doctors OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 57678)
-- Name: doctors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.doctors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.doctors_id_seq OWNER TO postgres;

--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 223
-- Name: doctors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.doctors_id_seq OWNED BY public.doctors.id;


--
-- TOC entry 230 (class 1259 OID 57728)
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    message text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 57727)
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO postgres;

--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 229
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- TOC entry 220 (class 1259 OID 57658)
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    id integer NOT NULL,
    name character varying(100),
    phone character varying(20)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 57657)
-- Name: owners_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.owners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.owners_id_seq OWNER TO postgres;

--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 219
-- Name: owners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.owners_id_seq OWNED BY public.owners.id;


--
-- TOC entry 228 (class 1259 OID 57705)
-- Name: treatments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.treatments (
    id integer NOT NULL,
    visit_id integer,
    treatment character varying(200),
    price numeric
);


ALTER TABLE public.treatments OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 57704)
-- Name: treatments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.treatments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.treatments_id_seq OWNER TO postgres;

--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 227
-- Name: treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.treatments_id_seq OWNED BY public.treatments.id;


--
-- TOC entry 226 (class 1259 OID 57687)
-- Name: visits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visits (
    id integer NOT NULL,
    animal_id integer,
    doctor_id integer,
    visit_date date
);


ALTER TABLE public.visits OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 57742)
-- Name: visit_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.visit_view AS
 SELECT id,
    animal_id
   FROM public.visits v;


ALTER VIEW public.visit_view OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 57686)
-- Name: visits_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visits_id_seq OWNER TO postgres;

--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 225
-- Name: visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visits_id_seq OWNED BY public.visits.id;


--
-- TOC entry 4796 (class 2604 OID 57669)
-- Name: animals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animals ALTER COLUMN id SET DEFAULT nextval('public.animals_id_seq'::regclass);


--
-- TOC entry 4797 (class 2604 OID 57682)
-- Name: doctors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors ALTER COLUMN id SET DEFAULT nextval('public.doctors_id_seq'::regclass);


--
-- TOC entry 4800 (class 2604 OID 57731)
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 57661)
-- Name: owners id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners ALTER COLUMN id SET DEFAULT nextval('public.owners_id_seq'::regclass);


--
-- TOC entry 4799 (class 2604 OID 57708)
-- Name: treatments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatments ALTER COLUMN id SET DEFAULT nextval('public.treatments_id_seq'::regclass);


--
-- TOC entry 4798 (class 2604 OID 57690)
-- Name: visits id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits ALTER COLUMN id SET DEFAULT nextval('public.visits_id_seq'::regclass);


--
-- TOC entry 4972 (class 0 OID 57666)
-- Dependencies: 222
-- Data for Name: animals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animals (id, name, type, owner_id) FROM stdin;
1	Rex	Dog	1
2	Barsik	Cat	2
3	Kesha	Parrot	3
4	Snow	Rabbit	4
5	Spike	Cow	5
6	Luna	Sheep	6
7	Goldie	Fish	7
8	Simba	Lion	8
9	Tiger	Tiger	9
10	Charlie	Giraffe	10
11	Max	Dog	11
12	Bella	Cat	12
13	Rocky	Dog	13
14	Molly	Cat	14
15	Daisy	Dog	15
16	Oscar	Hamster	16
17	Lucy	Dog	17
18	Milo	Cat	18
19	Coco	Parrot	19
20	Buddy	Dog	20
21	Lily	Cat	21
22	Leo	Dog	22
23	Nala	Cat	23
24	Jack	Dog	24
25	Zoe	Snake	25
26	Buster	Dog	26
27	Kitty	Cat	27
28	Rango	Lizard	28
29	Dumbo	Elephant	29
30	Khan	Horse	30
31	Bolt	Dog	1
32	Shadow	Wolf	2
33	Panda	Bear	3
34	Foxie	Fox	4
35	Zebra	Zebra	5
36	TestAnimal	Dog	1
\.


--
-- TOC entry 4974 (class 0 OID 57679)
-- Dependencies: 224
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctors (id, name) FROM stdin;
1	Dr. Ivanov
2	Dr. Kim
3	Dr. Sadykova
4	Dr. Petrov
5	Dr. Smirnov
6	Dr. Lee
7	Dr. Ahmed
8	Dr. Zhang
9	Dr. Brown
10	Dr. Wilson
11	Dr. Garcia
12	Dr. Martinez
13	Dr. Aliyev
14	Dr. Nurgalieva
15	Dr. Sarsembayev
16	Dr. Johnson
17	Dr. Clark
18	Dr. Walker
19	Dr. Scott
20	Dr. Adams
\.


--
-- TOC entry 4980 (class 0 OID 57728)
-- Dependencies: 230
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id, message, created_at) FROM stdin;
1	Treatment added with ID: 33	2026-05-01 21:00:03.035665
2	Treatment added with ID: 34	2026-05-01 21:06:43.52505
3	Treatment added with ID: 36	2026-05-01 21:09:35.024275
\.


--
-- TOC entry 4970 (class 0 OID 57658)
-- Dependencies: 220
-- Data for Name: owners; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.owners (id, name, phone) FROM stdin;
1	Ali	87011111111
2	Dana	87022222222
3	Murat	87033333333
4	Aruzhan	87044444444
5	Nursultan	87055555555
6	Aigerim	87066666666
7	Ruslan	87077777777
8	Madina	87088888888
9	Timur	87099999999
10	Asel	87012345678
11	Arman	87011112222
12	Zhanar	87022223333
13	Bekzat	87033334444
14	Saltanat	87044445555
15	Dias	87055556666
16	Kamila	87066667777
17	Erbol	87077778888
18	Ainur	87088889999
19	Sanzhar	87099990000
20	Indira	87012341234
21	Olzhas	87022221111
22	Gulnaz	87033332222
23	Serik	87044443333
24	Raushan	87055554444
25	Darkhan	87066665555
26	Zhanna	87077776666
27	Kanat	87088887777
28	Maira	87099998888
29	Adil	87011119999
30	Amina	87022220000
\.


--
-- TOC entry 4978 (class 0 OID 57705)
-- Dependencies: 228
-- Data for Name: treatments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.treatments (id, visit_id, treatment, price) FROM stdin;
16	1	Vaccination	5000
17	2	Checkup	3000
18	3	Surgery	20000
19	4	Injection	4000
20	5	Cleaning	3500
21	6	Vaccination	5000
22	7	Checkup	3000
23	8	Surgery	18000
24	9	Injection	4000
25	10	Cleaning	3500
26	11	Vaccination	5000
27	12	Checkup	3000
28	13	Surgery	22000
29	14	Injection	4500
30	15	Cleaning	3000
33	1	Valid treatment	5000
34	1	Test treatment	5000
36	1	Good test	5000
\.


--
-- TOC entry 4976 (class 0 OID 57687)
-- Dependencies: 226
-- Data for Name: visits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visits (id, animal_id, doctor_id, visit_date) FROM stdin;
1	1	1	2026-03-01
2	2	2	2026-03-02
3	3	3	2026-03-03
4	4	4	2026-03-04
5	5	5	2026-03-05
6	6	6	2026-03-06
7	7	7	2026-03-07
8	8	8	2026-03-08
9	9	9	2026-03-09
10	10	10	2026-03-10
11	11	11	2026-03-11
12	12	12	2026-03-12
13	13	13	2026-03-13
14	14	14	2026-03-14
15	15	15	2026-03-15
16	16	16	2026-03-16
17	17	17	2026-03-17
18	18	18	2026-03-18
19	19	19	2026-03-19
20	20	20	2026-03-20
21	21	1	2026-03-21
22	22	2	2026-03-22
23	23	3	2026-03-23
24	24	4	2026-03-24
25	25	5	2026-03-25
26	26	6	2026-03-26
27	27	7	2026-03-27
28	28	8	2026-03-28
29	29	9	2026-03-29
30	30	10	2026-03-30
31	31	11	2026-03-31
32	1	12	2026-04-01
33	2	13	2026-04-02
34	3	14	2026-04-03
35	4	15	2026-04-04
36	5	16	2026-04-05
37	6	17	2026-04-06
38	7	18	2026-04-07
39	8	19	2026-04-08
40	9	20	2026-04-09
41	10	1	2026-04-10
42	11	2	2026-04-11
43	12	3	2026-04-12
44	13	4	2026-04-13
45	14	5	2026-04-14
46	15	6	2026-04-15
47	16	7	2026-04-16
48	17	8	2026-04-17
49	18	9	2026-04-18
50	19	10	2026-04-19
51	20	11	2026-04-20
52	21	12	2026-04-21
53	22	13	2026-04-22
54	23	14	2026-04-23
55	24	15	2026-04-24
56	25	16	2026-04-25
57	26	17	2026-04-26
58	27	18	2026-04-27
59	28	19	2026-04-28
60	29	20	2026-04-29
61	30	1	2026-04-30
62	1	2	2026-05-01
63	2	3	2026-05-02
64	3	4	2026-05-03
65	4	5	2026-05-04
66	5	6	2026-05-05
67	6	7	2026-05-06
68	7	8	2026-05-07
69	8	9	2026-05-08
70	9	10	2026-05-09
71	10	11	2026-05-10
72	11	12	2026-05-11
73	12	13	2026-05-12
74	13	14	2026-05-13
75	14	15	2026-05-14
76	15	16	2026-05-15
77	16	17	2026-05-16
78	17	18	2026-05-17
79	18	19	2026-05-18
80	19	20	2026-05-19
81	20	1	2026-05-20
82	21	2	2026-05-21
83	22	3	2026-05-22
84	23	4	2026-05-23
85	24	5	2026-05-24
86	25	6	2026-05-25
87	26	7	2026-05-26
88	27	8	2026-05-27
89	28	9	2026-05-28
90	29	10	2026-05-29
91	30	11	2026-05-30
92	31	12	2026-05-31
93	1	1	2026-05-01
\.


--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 221
-- Name: animals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.animals_id_seq', 36, true);


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 223
-- Name: doctors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.doctors_id_seq', 20, true);


--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 229
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_id_seq', 3, true);


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 219
-- Name: owners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.owners_id_seq', 31, true);


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 227
-- Name: treatments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.treatments_id_seq', 36, true);


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 225
-- Name: visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visits_id_seq', 93, true);


--
-- TOC entry 4805 (class 2606 OID 57672)
-- Name: animals animals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT animals_pkey PRIMARY KEY (id);


--
-- TOC entry 4807 (class 2606 OID 57685)
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- TOC entry 4813 (class 2606 OID 57737)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4803 (class 2606 OID 57664)
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (id);


--
-- TOC entry 4811 (class 2606 OID 57713)
-- Name: treatments treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatments
    ADD CONSTRAINT treatments_pkey PRIMARY KEY (id);


--
-- TOC entry 4809 (class 2606 OID 57693)
-- Name: visits visits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- TOC entry 4818 (class 2620 OID 57739)
-- Name: treatments trg_log; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log AFTER INSERT ON public.treatments FOR EACH ROW EXECUTE FUNCTION public.log_treatment();


--
-- TOC entry 4819 (class 2620 OID 57741)
-- Name: treatments trg_price; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_price BEFORE INSERT OR UPDATE ON public.treatments FOR EACH ROW EXECUTE FUNCTION public.check_price();


--
-- TOC entry 4820 (class 2620 OID 57747)
-- Name: visit_view trg_view; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_view INSTEAD OF INSERT ON public.visit_view FOR EACH ROW EXECUTE FUNCTION public.insert_view();


--
-- TOC entry 4814 (class 2606 OID 57673)
-- Name: animals animals_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animals
    ADD CONSTRAINT animals_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.owners(id);


--
-- TOC entry 4817 (class 2606 OID 57714)
-- Name: treatments treatments_visit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.treatments
    ADD CONSTRAINT treatments_visit_id_fkey FOREIGN KEY (visit_id) REFERENCES public.visits(id);


--
-- TOC entry 4815 (class 2606 OID 57694)
-- Name: visits visits_animal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_animal_id_fkey FOREIGN KEY (animal_id) REFERENCES public.animals(id);


--
-- TOC entry 4816 (class 2606 OID 57699)
-- Name: visits visits_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.doctors(id);


-- Completed on 2026-05-01 21:17:26

--
-- PostgreSQL database dump complete
--

\unrestrict 6y6gJgQdZQVzofgROpk3zug9lEjxnifBuJHX1Nx2JvtLfch8gmgp41mV62B8EEm

