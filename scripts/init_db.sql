/*
  CORRELATION ENGINE
  Initialise Database

  Version: Alpha 1.0
  Author: Norman Gamage <norman.gamage@gmail.com>
  Last Update: 17 Mar 2015
*/

-- createdb -h localhost -p 5432 -U postgres CE

-------------------------------------------------------------------------------
-- Database: "CE"
-------------------------------------------------------------------------------

CREATE DATABASE "CE"
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United States.1252'
       LC_CTYPE = 'English_United States.1252'
       CONNECTION LIMIT = -1;

-- DROP DATABASE "CE";

\connect CE

-------------------------------------------------------------------------------
-- Schema: schema_ce
-------------------------------------------------------------------------------

CREATE SCHEMA schema_ce
  AUTHORIZATION postgres;

-- DROP SCHEMA schema_ce;

DROP SCHEMA public;

-------------------------------------------------------------------------------
-- Sequence: schema_ce.corr_xy_n_seq
-------------------------------------------------------------------------------

CREATE SEQUENCE schema_ce.corr_xy_n_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 2466
  CACHE 1;
ALTER TABLE schema_ce.corr_xy_n_seq
  OWNER TO postgres;

-- DROP SEQUENCE schema_ce.corr_xy_n_seq;

-------------------------------------------------------------------------------
-- Table: schema_ce.corr_xy
-------------------------------------------------------------------------------

CREATE TABLE schema_ce.corr_xy
(
  n bigint NOT NULL DEFAULT nextval('schema_ce.corr_xy_n_seq'::regclass),
  x double precision,
  y double precision,
  r double precision,
  r_m double precision,
  r_h double precision,
  x_sq double precision,
  y_sq double precision,
  xy double precision,
  sum_x double precision,
  sum_x_flag boolean DEFAULT false,
  sum_y double precision,
  sum_y_flag boolean DEFAULT false,
  sum_x_sq double precision,
  sum_x_sq_flag boolean DEFAULT false,
  sum_y_sq double precision,
  sum_y_sq_flag boolean DEFAULT false,
  sum_xy double precision,
  sum_xy_flag boolean DEFAULT false,
  sum_x__sq double precision,
  sum_y__sq double precision,
  n_sum_x_sq double precision,
  n_sum_y_sq double precision,
  n_sum_xy double precision,
  sum_x_sum_y double precision,
  sum_x_m double precision,
  sum_x_flag_m boolean DEFAULT false,
  sum_y_m double precision,
  sum_y_flag_m boolean DEFAULT false,
  sum_x_sq_m double precision,
  sum_x_sq_flag_m boolean DEFAULT false,
  sum_y_sq_m double precision,
  sum_y_sq_flag_m boolean DEFAULT false,
  sum_xy_m double precision,
  sum_xy_flag_m boolean DEFAULT false,
  sum_x__sq_m double precision,
  sum_y__sq_m double precision,
  n_sum_x_sq_m double precision,
  n_sum_y_sq_m double precision,
  n_sum_xy_m double precision,
  sum_x_sum_y_m double precision,
  sum_x_h double precision,
  sum_x_flag_h boolean DEFAULT false,
  sum_y_h double precision,
  sum_y_flag_h boolean DEFAULT false,
  sum_x_sq_h double precision,
  sum_x_sq_flag_h boolean DEFAULT false,
  sum_y_sq_h double precision,
  sum_y_sq_flag_h boolean DEFAULT false,
  sum_xy_h double precision,
  sum_xy_flag_h boolean DEFAULT false,
  sum_x__sq_h double precision,
  sum_y__sq_h double precision,
  n_sum_x_sq_h double precision,
  n_sum_y_sq_h double precision,
  n_sum_xy_h double precision,
  sum_x_sum_y_h double precision,
  CONSTRAINT "primary" PRIMARY KEY (n)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE schema_ce.corr_xy
  OWNER TO postgres;

-- DROP TABLE schema_ce.corr_xy;

-------------------------------------------------------------------------------
-- Sequence: schema_ce.summary_xy_i_seq
-------------------------------------------------------------------------------

CREATE SEQUENCE schema_ce.summary_xy_i_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 41
  CACHE 1;
ALTER TABLE schema_ce.summary_xy_i_seq
  OWNER TO postgres;

-- DROP SEQUENCE schema_ce.summary_xy_i_seq;

-------------------------------------------------------------------------------
-- Table: schema_ce.summary_xy
-------------------------------------------------------------------------------

CREATE TABLE schema_ce.summary_xy
(
  i bigint NOT NULL DEFAULT nextval('schema_ce.summary_xy_i_seq'::regclass),
  n bigint,
  x double precision,
  y double precision,
  r double precision,
  r_m double precision,
  r_h double precision,
  CONSTRAINT xy_pkey PRIMARY KEY (i)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE schema_ce.summary_xy
  OWNER TO postgres;

-- DROP TABLE schema_ce.summary_xy;