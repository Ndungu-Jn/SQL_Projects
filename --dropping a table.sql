--dropping a column and a table
--NB this is a very dangerous command. it deletes the entire column and Table
ALTER TABLE job_applied
DROP COLUMN contact_name;

DROP TABLE job_applied

SELECT *
 FROM job_applied