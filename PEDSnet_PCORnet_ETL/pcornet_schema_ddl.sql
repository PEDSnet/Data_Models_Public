--
-- TOC entry 12 (class 2615 OID 39376)
-- Name: pcornet; Type: SCHEMA; Schema: -; Owner: rosita
--

DROP SCHEMA IF EXISTS pcornet CASCADE;

CREATE SCHEMA pcornet;

ALTER SCHEMA pcornet OWNER TO rosita;

SET search_path = pcornet, pg_catalog;

--
-- TOC entry 358 (class 1255 OID 39377)
-- Name: checkifrunning(); Type: FUNCTION; Schema: pcornet; Owner: rosita
--

CREATE TABLE demographic (
    patid character varying(255),
    birth_date character(10),
    birth_time character(5),
    sex character(2),
    hispanic character(2),
    race character(2),
    biobank_flag character(1),
    raw_sex character varying(255),
    raw_hispanic character varying(255),
    raw_race character varying(255)
);


ALTER TABLE pcornet.demographic OWNER TO rosita;

--
-- TOC entry 300 (class 1259 OID 39398)
-- Name: diagnosis; Type: TABLE; Schema: pcornet; Owner: rosita; Tablespace: 
--

CREATE TABLE diagnosis (
    patid character varying(255),
    encounterid character varying(255),
    enc_type character(2),
    admit_date character(10),
    providerid character varying(255),
    dx character(18),
    dx_type character(2),
    dx_source character(2),
    pdx character(2),
    raw_dx character varying(255),
    raw_dx_type character varying(255),
    raw_dx_source character varying(255),
    raw_pdx character varying(255)
);


ALTER TABLE pcornet.diagnosis OWNER TO rosita;

--
-- TOC entry 301 (class 1259 OID 39409)
-- Name: encounter; Type: TABLE; Schema: pcornet; Owner: rosita; Tablespace: 
--

CREATE TABLE encounter (
    patid character varying(255),
    encounterid character varying(255),
    admit_date character(10),
    admit_time character(5),
    discharge_date character(10),
    discharge_time character(5),
    providerid character varying(255),
    facility_location character(3),
    enc_type character(2),
    facilityid character varying(255),
    discharge_disposition character(2),
    discharge_status character(2),
    drg character(3),
    drg_type character(2),
    admitting_source character(2),
    raw_enc_type character varying(255),
    raw_discharge_disposition character varying(255),
    raw_discharge_status character varying(255),
    raw_drg_type character varying(255),
    raw_admitting_source character varying(255)
);


ALTER TABLE pcornet.encounter OWNER TO rosita;

--
-- TOC entry 302 (class 1259 OID 39424)
-- Name: enrollment; Type: TABLE; Schema: pcornet; Owner: rosita; Tablespace: 
--

CREATE TABLE enrollment (
    patid character varying(255),
    enr_start_date character(10),
    enr_end_date character(10),
    chart character(1),
    enr_basis character(1)
);


ALTER TABLE pcornet.enrollment OWNER TO rosita;

--
-- TOC entry 303 (class 1259 OID 39431)
-- Name: procedure; Type: TABLE; Schema: pcornet; Owner: rosita; Tablespace: 
--

CREATE TABLE procedure (
    patid character varying(255),
    encounterid character varying(255),
    enc_type character(2),
    admit_date character(10),
    providerid character varying(255),
    px character(11),
    px_type character(2),
    raw_px character varying(255),
    raw_px_type character varying(255)
);


ALTER TABLE pcornet.procedure OWNER TO rosita;

--
-- TOC entry 304 (class 1259 OID 39440)
-- Name: vital; Type: TABLE; Schema: pcornet; Owner: rosita; Tablespace: 
--

CREATE TABLE vital (
    patid character varying(255),
    encounterid character varying(255),
    measure_date character(10),
    measure_time character(5),
    vital_source character(20),
    ht numeric(8,4),
    wt numeric(8,4),
    diastolic numeric(4,0),
    systolic numeric(4,0),
    original_bmi numeric(8,0),
    bp_position character(2),
    raw_vital_source character varying(255),
    raw_diastolic character varying(255),
    raw_systolic character varying(255),
    raw_bp_position character varying(255)
);


ALTER TABLE pcornet.vital OWNER TO rosita;

-- Completed on 2014-09-25 14:59:08

--
-- PostgreSQL database dump complete
--

