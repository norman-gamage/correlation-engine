/*
  CORRELATION ENGINE
  Test Data

  Version: Alpha 1.0
  Author: Norman Gamage <norman.gamage@gmail.com>
  Last Update: 14 Apr 2015
*/

\connect CE;

-- Positive & Negative trend data
DO $$
  DECLARE
    MAX bigint := 2000;
    t double precision := 0;
    
  BEGIN
    FOR i IN 0..(MAX-1) LOOP
      IF (i < MAX/2) THEN
        t := t + 1;
      ELSE
	t := t - 1;        
      END IF;

      INSERT INTO schema_ce.corr_xy (x, y) VALUES ( (cast(i as double precision)/10), t );
    END LOOP;
END $$;

-- Zig-Zag trend data
/*
DO $$
  DECLARE
    MAX bigint := 1000;
    t double precision := 0;
    
  BEGIN
    FOR i IN 0..(MAX-1) LOOP
      IF (i/(MAX/10) % 2 = 0) THEN
	t := t+1;
      ELSE
        t := t-1;
      END IF;

      INSERT INTO schema_ce.corr_xy (x, y) VALUES ( (cast(i as double precision)/10), t);
    END LOOP;
END $$;
*/

-- Sinusoidal trend data
/*
DO $$
  DECLARE
    PI double precision := 3.1415926535;
    MAX bigint := 4000;
    p bigint := 100;
    t double precision := 0;
    
  BEGIN
    FOR i IN 0..(MAX-1) LOOP
      t := p * sin(PI * (cast(2*(i%p) as double precision)/p));
      INSERT INTO schema_ce.corr_xy (x, y) VALUES ( (cast(i as double precision)/10), t);
    END LOOP;
END $$;
*/