CREATE TABLE jobs ( id INTEGER PRIMARY KEY, type VARCHAR, name VARCHAR );
CREATE TABLE runs ( id INTEGER PRIMARY KEY, job_id INT, start DATETIME, end DATETIME, status VARCHAR, FOREIGN KEY (job_id) REFERENCES job(id));
CREATE TABLE dest ( id INTEGER PRIMARY KEY, type VARCHAR, name VARCHAR );
CREATE TABLE run_dest ( run_id INT, dest_id INT, FOREIGN KEY (run_id) REFERENCES run(id), FOREIGN KEY (dest_id) REFERENCES dest(id) );

INSERT INTO jobs VALUES(1,'Qar::Extract','int_rate_fixings_emea');
INSERT INTO jobs VALUES(2,'Qar::Extract','int_rate_fixings_amrs');
INSERT INTO jobs VALUES(3,'Qar::Spider','bbg_fx_spot');
INSERT INTO jobs VALUES(4,'Qar::Extract','ccy_spot');

INSERT INTO runs VALUES (1,1,'2015-04-04T15:00:02Z','2015-04-04T15:00:17Z','done');
INSERT INTO runs VALUES (2,1,'2015-04-04T16:00:01Z','2015-04-04T16:00:25Z','done');
INSERT INTO runs VALUES (3,1,'2015-04-04T18:00:01Z','2015-04-04T18:03:05Z','error');
INSERT INTO runs VALUES (4,3,'2015-04-04T04:30:01Z','2015-04-04T04:12:07Z','error');
