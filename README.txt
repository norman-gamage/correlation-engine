/*
  CORRELATION ENGINE
  Installation guide

  Version: Alpha 1.0
  Author: Norman Gamage <norman.gamage@gmail.com>
  Last Update: 24 Apr 2015
*/

Pre-requisites:

  1. Download the repo from,

    https://github.com/norman-gamage/correlation-engine

  2. Software requirements:

    Microsoft Windows 7 (or better)
    Node.js (v0.12.0 or better)
    npm (2.5.1 or better

  3. Initialise PostgreSQL database as per instructions in,

    <correlation-engine>\scripts\README_DB.txt

Steps:

  1. Open Windows Command Prompt.

  2. Go to Correlation Engine folder.

  3. Run following command to install related packages,

    npm install

  4. PostgreSQL database connection configuration,

    a) Open 'Server.js' using a text editor (e.g. Notepad, Notepad++, Sublime).
    b) Modify the 'conString' variable (line #5) value with your PostgreSQL database username and password.
    c) Save and exit

  5. Run the server application using following command,

    node server.js

  6. To view correlation trend graphs, go to following link on a web browser,

    http://localhost:3000

  7. [Optional] To populate with simple trend data

    a) Open following link on a web browser,

      http://localhost:3000/send

    b) Use the controls as required to generate data

      Start/Pause: Begin/Pause data generation
      Reset: Reset to data points
      Trend: Switch between postive/negative trends