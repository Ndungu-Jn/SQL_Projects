ALTER TABLE job_applied
ADD contact VARCHAR(50);

--Update to get names into that column
Update job_applied 
SET contact = 'John Ndungu'
WHERE job_id = 1;

Update job_applied 
SET contact = 'Pesh'
WHERE job_id = 2;

Update job_applied 
SET contact = 'Mzangulu'
WHERE job_id = 3;

Update job_applied 
SET contact = 'Sinyoyo'
WHERE job_id = 4;

Update job_applied 
SET contact = 'Kairetu'
WHERE job_id = 5;

--change the name of a column
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

--to change the data type in a column
ALTER TABLE job_applied
ALTER COLUMN contact_NAME TYPE TEXT;

SELECT *
FROM job_applied