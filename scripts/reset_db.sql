/*
  CORRELATION ENGINE
  Reset Database

  Version: Alpha 1.0
  Author: Norman Gamage <norman.gamage@gmail.com>
  Last Update: 17 Mar 2015
*/

\connect CE;

DELETE FROM schema_ce.corr_xy WHERE n>0;
ALTER SEQUENCE schema_ce.corr_xy_n_seq RESTART WITH 1;

DELETE FROM schema_ce.summary_xy WHERE n>0;
ALTER SEQUENCE schema_ce.summary_xy_i_seq RESTART WITH 1;