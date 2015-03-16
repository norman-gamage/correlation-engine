/*
  CORRELATION ENGINE
  Initialise Core Engine

  Version: Alpha 1.0
  Author: Norman Gamage <norman.gamage@gmail.com>
  Last Update: 17 Mar 2015
*/

Pre-requisites:

  1. OS: MS-Windows 7 or better (64-bit)
  2. PostGreSQL: 9.4 or better
  3. Scripts: Download/fork following script files from the repo
        i. init_db.sql
       ii. init_core_engine.sql
      iii. reset_db.sql

Steps:

  1. Open Windows Command Prompt.

  2. Go to PostGreSQL binary folder (Default path: C:\Program Files\PostgreSQL\9.4\bin)

  3. Run following commands in order,

    a) Create database

        createdb -h localhost -p 5432 -U postgres CE &

    b) Initialize database

        psql -U postgres -a -d CE -f c:\path\to\init_db.sql &

    c) Initialize core engine

        psql -U postgres -a -d CE -f c:\path\to\init_core_engine.sql &

    d) Reset database

        psql -U postgres -a -d CE -f c:\path\to\reset_db.sql &