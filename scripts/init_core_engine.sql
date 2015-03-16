/*
  CORRELATION ENGINE
  Core Engine 

  Version: Alpha 1.0
  Author: Norman Gamage <norman.gamage@gmail.com>
  Last Update: 17 Mar 2015
*/

-------------------------------------------------------------------------------
-- Drop functions and related triggers
-------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS schema_ce.x_square() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.y_square() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.summary_xy() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_flag() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_flag() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_sq() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_sq_flag() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_sq() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_sq_flag() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_xy() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_xy_flag() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x__sq() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y__sq() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.n_sum_x_sq() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.n_sum_y_sq() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.n_sum_xy() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_sum_y() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.r() CASCADE;

DROP FUNCTION IF EXISTS schema_ce.sum_x_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_flag_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_flag_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_sq_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_sq_flag_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_sq_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_sq_flag_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_xy_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_xy_flag_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x__sq_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y__sq_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.n_sum_x_sq_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.n_sum_y_sq_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.n_sum_xy_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_sum_y_m() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.r_m() CASCADE;

DROP FUNCTION IF EXISTS schema_ce.sum_x_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_flag_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_flag_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_sq_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_sq_flag_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_sq_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y_sq_flag_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_xy_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_xy_flag_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x__sq_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_y__sq_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.n_sum_x_sq_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.n_sum_y_sq_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.n_sum_xy_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.sum_x_sum_y_h() CASCADE;
DROP FUNCTION IF EXISTS schema_ce.r_h() CASCADE;

DROP FUNCTION IF EXISTS schema_ce.notify_trigger() CASCADE;

-------------------------------------------------------------------------------
-- Create functions
-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION schema_ce.x_square() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
	NEW.x_sq = NEW.x * NEW.x;
    END IF;   

    UPDATE schema_ce.corr_xy SET x_sq = NEW.x_sq WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.y_square() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
	NEW.y_sq = NEW.y * NEW.y;
    END IF;   

    UPDATE schema_ce.corr_xy SET y_sq = NEW.y_sq WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.summary_xy() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
	NEW.xy = NEW.x * NEW.y;
    END IF;   

    UPDATE schema_ce.corr_xy SET xy = NEW.xy WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_flag() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_x_flag = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;

  BEGIN
    IF (NEW.sum_x_flag = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_x := NEW.x;
      ELSE
        SELECT sum_x INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_x := NEW.x + t;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_x = NEW.sum_x, sum_x_flag = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_x_flag = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';
--
CREATE OR REPLACE FUNCTION schema_ce.sum_y_flag() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_y_flag = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;

  BEGIN
    IF (NEW.sum_y_flag = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_y := NEW.y;
      ELSE
        SELECT sum_y INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_y := NEW.y + t;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_y = NEW.sum_y, sum_y_flag = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_y_flag = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';
--
CREATE OR REPLACE FUNCTION schema_ce.sum_x_sq_flag() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_x_sq_flag = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_sq() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;

  BEGIN
    IF (NEW.sum_x_sq_flag = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_x_sq := NEW.x_sq;
      ELSE
        SELECT sum_x_sq INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_x_sq := NEW.x_sq + t;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_x_sq = NEW.sum_x_sq, sum_x_sq_flag = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_x_sq_flag = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y_sq_flag() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_y_sq_flag = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y_sq() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;

  BEGIN
    IF (NEW.sum_y_sq_flag = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_y_sq := NEW.y_sq;
      ELSE
        SELECT sum_y_sq INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_y_sq := NEW.y_sq + t;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_y_sq = NEW.sum_y_sq, sum_y_sq_flag = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_y_sq_flag = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_xy_flag() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_xy_flag = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_xy() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;

  BEGIN
    IF (NEW.sum_xy_flag = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_xy := NEW.xy;
      ELSE
        SELECT sum_xy INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_xy := NEW.xy + t;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_xy = NEW.sum_xy, sum_xy_flag = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_xy_flag = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x__sq() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.sum_x__sq = NEW.sum_x * NEW.sum_x;
    END IF;   

    UPDATE schema_ce.corr_xy SET sum_x__sq = NEW.sum_x__sq WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y__sq() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.sum_y__sq = NEW.sum_y * NEW.sum_y;
    END IF;   

    UPDATE schema_ce.corr_xy SET sum_y__sq = NEW.sum_y__sq WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.n_sum_x_sq() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.n_sum_x_sq = NEW.n * NEW.sum_x_sq;
    END IF;   

    UPDATE schema_ce.corr_xy SET n_sum_x_sq = NEW.n_sum_x_sq WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.n_sum_y_sq() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.n_sum_y_sq = NEW.n * NEW.sum_y_sq;
    END IF;   

    UPDATE schema_ce.corr_xy SET n_sum_y_sq = NEW.n_sum_y_sq WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.n_sum_xy() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.n_sum_xy = NEW.n * NEW.sum_xy;
    END IF;   

    UPDATE schema_ce.corr_xy SET n_sum_xy = NEW.n_sum_xy WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_sum_y() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.sum_x_sum_y = NEW.sum_x * NEW.sum_y;
    END IF;   

    UPDATE schema_ce.corr_xy SET sum_x_sum_y = NEW.sum_x_sum_y WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.r() RETURNS TRIGGER AS $$
  DECLARE
    d double precision := 0;
    x double precision := 0;
    y double precision := 0;

  BEGIN
    IF ((TG_OP = 'INSERT') OR (TG_OP = 'UPDATE')) AND (NEW.n > 1) THEN
      x = (NEW.n_sum_x_sq - NEW.sum_x__sq);
      y = (NEW.n_sum_y_sq - NEW.sum_y__sq);

      IF (x>=0 AND y>=0) THEN
        d = (sqrt(x) * sqrt(y));
      END IF;

      IF (d=0) THEN
        --NEW.r = 0;
      ELSE
        NEW.r = round(cast(((NEW.n_sum_xy - NEW.sum_x_sum_y) / (d)) as numeric), 4);
      END IF;
    END IF;   

    UPDATE schema_ce.corr_xy SET r = NEW.r WHERE n = NEW.n;

    IF (NEW.n%60=0) THEN
     UPDATE schema_ce.summary_xy SET r=(SELECT COALESCE(NEW.r,'0')) WHERE n=NEW.n;
     INSERT INTO schema_ce.summary_xy (n,x,y,r)
       SELECT NEW.n,NEW.x,NEW.y,NEW.r
       WHERE NOT EXISTS (SELECT 1 FROM schema_ce.summary_xy WHERE n=NEW.n);
    END IF;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_flag_m() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_x_flag_m = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_m() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;
    f double precision := 0;
    h bigint := 60;

  BEGIN
    IF (NEW.sum_x_flag_m = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_x_m := NEW.x;
      ELSIF (NEW.n < h+1) THEN
        SELECT sum_x_m INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_x_m := NEW.x + t;
      ELSE
        SELECT sum_x_m INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        SELECT x INTO f FROM schema_ce.corr_xy WHERE n = (NEW.n)-h;
        NEW.sum_x_m := NEW.x + t - f;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_x_m = NEW.sum_x_m, sum_x_flag_m = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_x_flag_m = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y_flag_m() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_y_flag_m = TRUE WHERE n = NEW.n;  
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y_m() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;
    f double precision := 0;
    h bigint := 60;

  BEGIN
    IF (NEW.sum_y_flag_m = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_y_m := NEW.y;
      ELSIF (NEW.n < h+1) THEN
        SELECT sum_y_m INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;      
        NEW.sum_y_m := NEW.y + t;       
      ELSE
        SELECT sum_y_m INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        SELECT y INTO f FROM schema_ce.corr_xy WHERE n = (NEW.n)-h;
        NEW.sum_y_m := NEW.y + t - f;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_y_m = NEW.sum_y_m, sum_y_flag_m = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_y_flag_m = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_sq_flag_m() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_x_sq_flag_m = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_sq_m() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;
    f double precision := 0;
    h bigint := 60;
    
  BEGIN
    IF (NEW.sum_x_sq_flag_m = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_x_sq_m := NEW.sum_x_sq;
      ELSIF (NEW.n < h+1) THEN
        SELECT sum_x_sq_m INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_x_sq_m := NEW.x_sq + t;
      ELSE
        SELECT sum_x_sq_m INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        SELECT x_sq INTO f FROM schema_ce.corr_xy WHERE n = (NEW.n)-h;
        NEW.sum_x_sq_m := NEW.x_sq + t - f;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_x_sq_m = NEW.sum_x_sq_m, sum_x_sq_flag_m = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_x_sq_flag_m = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y_sq_flag_m() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_y_sq_flag_m = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y_sq_m() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;
    f double precision := 0;
    h bigint := 60;

  BEGIN
    IF (NEW.sum_y_sq_flag_m = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_y_sq_m := NEW.sum_y_sq;
      ELSIF (NEW.n < h+1) THEN
        SELECT sum_y_sq_m INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_y_sq_m := NEW.y_sq + t;
      ELSE
        SELECT sum_y_sq_m INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        SELECT y_sq INTO f FROM schema_ce.corr_xy WHERE n = (NEW.n)-h;
        NEW.sum_y_sq_m := NEW.y_sq + t - f;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_y_sq_m = NEW.sum_y_sq_m, sum_y_sq_flag_m = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_y_sq_flag_m = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_xy_flag_m() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_xy_flag_m = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_xy_m() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;
    f double precision := 0;
    h bigint := 60;

  BEGIN
    IF (NEW.sum_xy_flag_m = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_xy_m := NEW.sum_xy;    
      ELSIF (NEW.n < h+1) THEN
        SELECT sum_xy_m INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_xy_m := NEW.xy + t;
      ELSE
        SELECT sum_xy_m INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        SELECT xy INTO f FROM schema_ce.corr_xy WHERE n = (NEW.n)-h;
        NEW.sum_xy_m := NEW.xy + t - f;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_xy_m = NEW.sum_xy_m, sum_xy_flag_m = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_xy_flag_m = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x__sq_m() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.sum_x__sq_m = NEW.sum_x_m * NEW.sum_x_m;
    END IF;   

    UPDATE schema_ce.corr_xy SET sum_x__sq_m = NEW.sum_x__sq_m WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y__sq_m() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.sum_y__sq_m = NEW.sum_y_m * NEW.sum_y_m;
    END IF;   

    UPDATE schema_ce.corr_xy SET sum_y__sq_m = NEW.sum_y__sq_m WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.n_sum_x_sq_m() RETURNS TRIGGER AS $$
  DECLARE
    h bigint := 60;

  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      IF (NEW.n >= h) THEN
        NEW.n_sum_x_sq_m = h * NEW.sum_x_sq_m;
      ELSE
	NEW.n_sum_x_sq_m = 0;
      END IF;
    END IF;   

    UPDATE schema_ce.corr_xy SET n_sum_x_sq_m = NEW.n_sum_x_sq_m WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.n_sum_y_sq_m() RETURNS TRIGGER AS $$
  DECLARE
    h bigint := 60;

  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      IF (NEW.n >= h) THEN
        NEW.n_sum_y_sq_m = h * NEW.sum_y_sq_m;
      ELSE
	NEW.n_sum_y_sq_m = 0;
      END IF;
    END IF;   

    UPDATE schema_ce.corr_xy SET n_sum_y_sq_m = NEW.n_sum_y_sq_m WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.n_sum_xy_m() RETURNS TRIGGER AS $$
  DECLARE
    h bigint := 60;
    
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      IF (NEW.n >= h) THEN
        NEW.n_sum_xy_m = h * NEW.sum_xy_m;
      ELSE
	NEW.n_sum_xy_m = 0;
      END IF;
    END IF;   

    UPDATE schema_ce.corr_xy SET n_sum_xy_m = NEW.n_sum_xy_m WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_sum_y_m() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.sum_x_sum_y_m = NEW.sum_x_m * NEW.sum_y_m;
    END IF;   

    UPDATE schema_ce.corr_xy SET sum_x_sum_y_m = NEW.sum_x_sum_y_m WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.r_m() RETURNS TRIGGER AS $$
  DECLARE
    d double precision := 0;
    x double precision := 0;
    y double precision := 0;

  BEGIN
    IF ((TG_OP = 'INSERT') OR (TG_OP = 'UPDATE')) THEN
      x = (NEW.n_sum_x_sq_m - NEW.sum_x__sq_m);
      y = (NEW.n_sum_y_sq_m - NEW.sum_y__sq_m);

      IF (x>=0 AND y>=0) THEN
        d = (sqrt(x) * sqrt(y));
      END IF;

      IF (d=0) THEN
        --NEW.r_m = 0;
      ELSE
        NEW.r_m =  round(cast( ((NEW.n_sum_xy_m - NEW.sum_x_sum_y_m) / (d)) as numeric ),4);
      END IF;
    END IF;   

    UPDATE schema_ce.corr_xy SET r_m = NEW.r_m WHERE n = NEW.n;

    IF (NEW.n%60=0) THEN
     UPDATE schema_ce.summary_xy SET r_m=(SELECT COALESCE(NEW.r_m,'0')) WHERE n=NEW.n;
     INSERT INTO schema_ce.summary_xy (n,x,y,r_m)
       SELECT NEW.n,NEW.x,NEW.y,NEW.r_m
       WHERE NOT EXISTS (SELECT 1 FROM schema_ce.summary_xy WHERE n=NEW.n);    
    END IF;
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_flag_h() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_x_flag_h = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_h() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;
    f double precision := 0;
    h bigint := 3600;

  BEGIN
    IF (NEW.sum_x_flag_h = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_x_h := NEW.x;
      ELSIF (NEW.n < h+1) THEN
        SELECT sum_x_h INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_x_h := NEW.x + t;
      ELSE
        SELECT sum_x_h INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        SELECT x INTO f FROM schema_ce.corr_xy WHERE n = (NEW.n)-h;
        NEW.sum_x_h := NEW.x + t - f;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_x_h = NEW.sum_x_h, sum_x_flag_h = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_x_flag_h = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y_flag_h() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_y_flag_h = TRUE WHERE n = NEW.n;  
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y_h() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;
    f double precision := 0;
    h bigint := 3600;

  BEGIN
    IF (NEW.sum_y_flag_h = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_y_h := NEW.y;
      ELSIF (NEW.n < h+1) THEN
        SELECT sum_y_h INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;      
        NEW.sum_y_h := NEW.y + t;       
      ELSE
        SELECT sum_y_h INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        SELECT y INTO f FROM schema_ce.corr_xy WHERE n = (NEW.n)-h;
        NEW.sum_y_h := NEW.y + t - f;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_y_h = NEW.sum_y_h, sum_y_flag_h = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_y_flag_h = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_sq_flag_h() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_x_sq_flag_h = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_sq_h() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;
    f double precision := 0;
    h bigint := 3600;
    
  BEGIN
    IF (NEW.sum_x_sq_flag_h = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_x_sq_h := NEW.sum_x_sq;
      ELSIF (NEW.n < h+1) THEN
        SELECT sum_x_sq_h INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_x_sq_h := NEW.x_sq + t;
      ELSE
        SELECT sum_x_sq_h INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        SELECT x_sq INTO f FROM schema_ce.corr_xy WHERE n = (NEW.n)-h;
        NEW.sum_x_sq_h := NEW.x_sq + t - f;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_x_sq_h = NEW.sum_x_sq_h, sum_x_sq_flag_h = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_x_sq_flag_h = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y_sq_flag_h() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_y_sq_flag_h = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y_sq_h() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;
    f double precision := 0;
    h bigint := 3600;

  BEGIN
    IF (NEW.sum_y_sq_flag_h = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_y_sq_h := NEW.sum_y_sq;
      ELSIF (NEW.n < h+1) THEN
        SELECT sum_y_sq_h INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_y_sq_h := NEW.y_sq + t;
      ELSE
        SELECT sum_y_sq_h INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        SELECT y_sq INTO f FROM schema_ce.corr_xy WHERE n = (NEW.n)-h;
        NEW.sum_y_sq_h := NEW.y_sq + t - f;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_y_sq_h = NEW.sum_y_sq_h, sum_y_sq_flag_h = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_y_sq_flag_h = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_xy_flag_h() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE schema_ce.corr_xy SET sum_xy_flag_h = TRUE WHERE n = NEW.n;
    RETURN NULL;
  END  
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_xy_h() RETURNS TRIGGER AS $$
  DECLARE
    t double precision := 0;
    f double precision := 0;
    h bigint := 3600;

  BEGIN
    IF (NEW.sum_xy_flag_h = TRUE) THEN
      IF (NEW.n = 1) THEN
        NEW.sum_xy_h := NEW.sum_xy;    
      ELSIF (NEW.n < h+1) THEN
        SELECT sum_xy_h INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        NEW.sum_xy_h := NEW.xy + t;
      ELSE
        SELECT sum_xy_h INTO t FROM schema_ce.corr_xy WHERE n = (NEW.n)-1;
        SELECT xy INTO f FROM schema_ce.corr_xy WHERE n = (NEW.n)-h;
        NEW.sum_xy_h := NEW.xy + t - f;
      END IF;

      UPDATE schema_ce.corr_xy SET sum_xy_h = NEW.sum_xy_h, sum_xy_flag_h = FALSE WHERE n = NEW.n;

      IF EXISTS (SELECT 1 FROM schema_ce.corr_xy WHERE n = (NEW.n + 1)) THEN
        UPDATE schema_ce.corr_xy SET sum_xy_flag_h = TRUE WHERE n = (NEW.n + 1);
      END IF;
    END IF;   
    
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x__sq_h() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.sum_x__sq_h = NEW.sum_x_h * NEW.sum_x_h;
    END IF;   

    UPDATE schema_ce.corr_xy SET sum_x__sq_h = NEW.sum_x__sq_h WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_y__sq_h() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.sum_y__sq_h = NEW.sum_y_h * NEW.sum_y_h;
    END IF;   

    UPDATE schema_ce.corr_xy SET sum_y__sq_h = NEW.sum_y__sq_h WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.n_sum_x_sq_h() RETURNS TRIGGER AS $$
  DECLARE
    h bigint := 3600;

  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      IF (NEW.n >= h) THEN
        NEW.n_sum_x_sq_h = h * NEW.sum_x_sq_h;
      ELSE
	NEW.n_sum_x_sq_h = 0;
      END IF;
    END IF;   

    UPDATE schema_ce.corr_xy SET n_sum_x_sq_h = NEW.n_sum_x_sq_h WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.n_sum_y_sq_h() RETURNS TRIGGER AS $$
  DECLARE
    h bigint := 3600;

  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      IF (NEW.n >= h) THEN
        NEW.n_sum_y_sq_h = h * NEW.sum_y_sq_h;
      ELSE
	NEW.n_sum_y_sq_h = 0;
      END IF;
    END IF;   

    UPDATE schema_ce.corr_xy SET n_sum_y_sq_h = NEW.n_sum_y_sq_h WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.n_sum_xy_h() RETURNS TRIGGER AS $$
  DECLARE
    h bigint := 3600;
    
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      IF (NEW.n >= h) THEN
        NEW.n_sum_xy_h = h * NEW.sum_xy_h;
      ELSE
	NEW.n_sum_xy_h = 0;
      END IF;
    END IF;   

    UPDATE schema_ce.corr_xy SET n_sum_xy_h = NEW.n_sum_xy_h WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.sum_x_sum_y_h() RETURNS TRIGGER AS $$
  BEGIN
    IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN
      NEW.sum_x_sum_y_h = NEW.sum_x_h * NEW.sum_y_h;
    END IF;   

    UPDATE schema_ce.corr_xy SET sum_x_sum_y_h = NEW.sum_x_sum_y_h WHERE n = NEW.n;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION schema_ce.r_h() RETURNS TRIGGER AS $$
  DECLARE
    d double precision := 0;
    x double precision := 0;
    y double precision := 0;

  BEGIN
    IF ((TG_OP = 'INSERT') OR (TG_OP = 'UPDATE')) THEN
      x = (NEW.n_sum_x_sq_h - NEW.sum_x__sq_h);
      y = (NEW.n_sum_y_sq_h - NEW.sum_y__sq_h);

      IF (x>=0 AND y>=0) THEN
        d = (sqrt(x) * sqrt(y));
      END IF;

      IF (d=0) THEN
        --NEW.r_h = 0;
      ELSE
        NEW.r_h = round(cast(((NEW.n_sum_xy_h - NEW.sum_x_sum_y_h) / (d)) as numeric), 4);
      END IF;
    END IF;   

    UPDATE schema_ce.corr_xy SET r_h = NEW.r_h WHERE n = NEW.n;

    IF (NEW.n%60=0) THEN
     UPDATE schema_ce.summary_xy SET r_h=(SELECT COALESCE(NEW.r_h,'0')) WHERE n=NEW.n;
     INSERT INTO schema_ce.summary_xy (n,x,y,r_h)
       SELECT NEW.n,NEW.x,NEW.y,NEW.r_h
       WHERE NOT EXISTS (SELECT 1 FROM schema_ce.summary_xy WHERE n=NEW.n);
    END IF;
    RETURN NULL;
  END
$$ LANGUAGE 'plpgsql';

CREATE FUNCTION schema_ce.notify_trigger() RETURNS trigger AS $$
  DECLARE
  BEGIN  
    IF ((TG_OP = 'UPDATE')) THEN
	IF ( 
	(NEW.x IS NOT NULL) AND
	(NEW.y IS NOT NULL) AND  
	(NEW.r IS NOT NULL) AND 
	(NEW.r_m IS NOT NULL) AND 
	(NEW.r_h IS NOT NULL)
	) THEN 
	  PERFORM pg_notify('watchers', '{"n":' || NEW.n || ',"x":' || NEW.x || ',"y":' || NEW.y || ',"r":' || NEW.r || ',"r_m":' || NEW.r_m || ',"r_h":' || NEW.r_h || '}');
	END IF;
    END IF;
    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;


-------------------------------------------------------------------------------
-- Create triggers
-------------------------------------------------------------------------------

CREATE TRIGGER x_square
  AFTER INSERT OR UPDATE OF x ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.x_square();

CREATE TRIGGER y_square
  AFTER INSERT OR UPDATE OF y ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.y_square();

CREATE TRIGGER xy
  AFTER INSERT OR UPDATE OF x, y ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.summary_xy();

CREATE TRIGGER sum_x_flag
  AFTER INSERT OR UPDATE OF x ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_flag();

CREATE TRIGGER sum_x
  AFTER INSERT OR UPDATE OF sum_x_flag ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x();

CREATE TRIGGER sum_y_flag
  AFTER INSERT OR UPDATE OF y ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_flag();

CREATE TRIGGER sum_y
  AFTER INSERT OR UPDATE OF sum_y_flag ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y();

CREATE TRIGGER sum_x_sq_flag
  AFTER INSERT OR UPDATE OF x_sq ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_sq_flag();

CREATE TRIGGER sum_x_sq
  AFTER INSERT OR UPDATE OF sum_x_sq_flag ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_sq();

CREATE TRIGGER sum_y_sq_flag
  AFTER INSERT OR UPDATE OF y_sq ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_sq_flag();

CREATE TRIGGER sum_y_sq
  AFTER INSERT OR UPDATE OF sum_y_sq_flag ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_sq();

CREATE TRIGGER sum_xy_flag
  AFTER INSERT OR UPDATE OF xy ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_xy_flag();

CREATE TRIGGER sum_xy
  AFTER INSERT OR UPDATE OF sum_xy_flag ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_xy();

CREATE TRIGGER sum_x__sq
  AFTER INSERT OR UPDATE OF sum_x ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x__sq();

CREATE TRIGGER sum_y__sq
  AFTER INSERT OR UPDATE OF sum_y ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y__sq();

CREATE TRIGGER n_sum_x_sq
  AFTER INSERT OR UPDATE OF sum_x_sq ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.n_sum_x_sq();

CREATE TRIGGER n_sum_y_sq
  AFTER INSERT OR UPDATE OF sum_y_sq ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.n_sum_y_sq();

CREATE TRIGGER n_sum_xy
  AFTER INSERT OR UPDATE OF sum_xy ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.n_sum_xy();

CREATE TRIGGER sum_x_sum_y
  AFTER INSERT OR UPDATE OF sum_x, sum_y ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_sum_y();

CREATE TRIGGER r
  AFTER INSERT OR UPDATE OF n_sum_xy, sum_x_sum_y, n_sum_x_sq, n_sum_y_sq ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.r();

CREATE TRIGGER sum_x_flag_m
  AFTER INSERT OR UPDATE OF x ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_flag_m();

CREATE TRIGGER sum_x_m
  AFTER INSERT OR UPDATE OF sum_x_flag_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_m();

CREATE TRIGGER sum_y_flag_m
  AFTER INSERT OR UPDATE OF y ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_flag_m();

CREATE TRIGGER sum_y_m
  AFTER INSERT OR UPDATE OF sum_y_flag_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_m();

CREATE TRIGGER sum_x_sq_flag_m
  AFTER INSERT OR UPDATE OF x_sq ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_sq_flag_m();

CREATE TRIGGER sum_x_sq_m
  AFTER INSERT OR UPDATE OF sum_x_sq_flag_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_sq_m();

CREATE TRIGGER sum_y_sq_flag_m
  AFTER INSERT OR UPDATE OF y_sq ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_sq_flag_m();

CREATE TRIGGER sum_y_sq_m
  AFTER INSERT OR UPDATE OF sum_y_sq_flag_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_sq_m();

CREATE TRIGGER sum_xy_flag_m
  AFTER INSERT OR UPDATE OF xy ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_xy_flag_m();

CREATE TRIGGER sum_xy_m
  AFTER INSERT OR UPDATE OF sum_xy_flag_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_xy_m();

CREATE TRIGGER sum_x__sq_m
  AFTER INSERT OR UPDATE OF sum_x_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x__sq_m();

CREATE TRIGGER sum_y__sq_m
  AFTER INSERT OR UPDATE OF sum_y_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y__sq_m();

CREATE TRIGGER n_sum_x_sq_m
  AFTER INSERT OR UPDATE OF sum_x_sq_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.n_sum_x_sq_m();

CREATE TRIGGER n_sum_y_sq_m
  AFTER INSERT OR UPDATE OF sum_y_sq_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.n_sum_y_sq_m();

CREATE TRIGGER n_sum_xy_m
  AFTER INSERT OR UPDATE OF sum_xy_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.n_sum_xy_m();

CREATE TRIGGER sum_x_sum_y_m
  AFTER INSERT OR UPDATE OF sum_x_m, sum_y_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_sum_y_m();

CREATE TRIGGER r_m
  AFTER INSERT OR UPDATE OF n_sum_xy_m, sum_x_sum_y_m, n_sum_x_sq_m, n_sum_y_sq_m ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.r_m();

CREATE TRIGGER sum_x_flag_h
  AFTER INSERT OR UPDATE OF x ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_flag_h();

CREATE TRIGGER sum_x_h
  AFTER INSERT OR UPDATE OF sum_x_flag_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_h();

CREATE TRIGGER sum_y_flag_h
  AFTER INSERT OR UPDATE OF y ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_flag_h();

CREATE TRIGGER sum_y_h
  AFTER INSERT OR UPDATE OF sum_y_flag_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_h();

CREATE TRIGGER sum_x_sq_flag_h
  AFTER INSERT OR UPDATE OF x_sq ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_sq_flag_h();

CREATE TRIGGER sum_x_sq_h
  AFTER INSERT OR UPDATE OF sum_x_sq_flag_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_sq_h();

CREATE TRIGGER sum_y_sq_flag_h
  AFTER INSERT OR UPDATE OF y_sq ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_sq_flag_h();

CREATE TRIGGER sum_y_sq_h
  AFTER INSERT OR UPDATE OF sum_y_sq_flag_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y_sq_h();

CREATE TRIGGER sum_xy_flag_h
  AFTER INSERT OR UPDATE OF xy ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_xy_flag_h();

CREATE TRIGGER sum_xy_h
  AFTER INSERT OR UPDATE OF sum_xy_flag_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_xy_h();

CREATE TRIGGER sum_x__sq_h
  AFTER INSERT OR UPDATE OF sum_x_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x__sq_h();

CREATE TRIGGER sum_y__sq_h
  AFTER INSERT OR UPDATE OF sum_y_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_y__sq_h();

CREATE TRIGGER n_sum_x_sq_h
  AFTER INSERT OR UPDATE OF sum_x_sq_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.n_sum_x_sq_h();

CREATE TRIGGER n_sum_y_sq_h
  AFTER INSERT OR UPDATE OF sum_y_sq_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.n_sum_y_sq_h();

CREATE TRIGGER n_sum_xy_h
  AFTER INSERT OR UPDATE OF sum_xy_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.n_sum_xy_h();

CREATE TRIGGER sum_x_sum_y_h
  AFTER INSERT OR UPDATE OF sum_x_h, sum_y_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.sum_x_sum_y_h();

CREATE TRIGGER r_h
  AFTER INSERT OR UPDATE OF n_sum_xy_h, sum_x_sum_y_h, n_sum_x_sq_h, n_sum_y_sq_h ON schema_ce.corr_xy
  FOR EACH ROW
  EXECUTE PROCEDURE schema_ce.r_h();

CREATE TRIGGER watched_table_trigger 
  AFTER UPDATE OF r_m ON schema_ce.summary_xy
  FOR EACH ROW
  WHEN (OLD.r_m IS DISTINCT FROM NEW.r_m)
  EXECUTE PROCEDURE schema_ce.notify_trigger();