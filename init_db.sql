-------------------------------------- generate tables --------------------------------------
------ Drop tables

DROP TABLE IF EXISTS exam_results;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS subjects;

------ Create tables

-- table subjects
CREATE TABLE IF NOT EXISTS subjects (
	"id" serial PRIMARY KEY,
	"name" text NOT NULL,
	tutor text
);

-- table students
CREATE TABLE IF NOT EXISTS students (
	"id" serial PRIMARY KEY,
	"name" text NOT NULL,
	surname text,
	date_of_birth timestamp,
	phone_number text,
	primary_skill_id int REFERENCES "subjects" ("id"),
	created_datetime timestamp DEFAULT CURRENT_TIMESTAMP,
	updated_datetime timestamp DEFAULT CURRENT_TIMESTAMP
);

-- table exam results: can duplicated (student_id, subject_id)
CREATE TABLE IF NOT EXISTS exam_results (
	"id" serial PRIMARY KEY,
	student_id int REFERENCES "students" ("id"),
	subject_id int REFERENCES "subjects" ("id"),
	mark smallint DEFAULT 0 NOT NULL	
);

-------------------------------------- create index --------------------------------------
----- students -----
-- drop index if exists idx_student_primary_skill ;
-- create index idx_student_primary_skill on students using btree (primary_skill);
-- create index idx_student_primary_skill on students using hash (primary_skill);

-- drop index if exists idx_student_surname ;
-- create index idx_student_surname on students using btree (surname);
-- create index idx_student_surname on students using hash (surname);

----- exam results -----
-- drop index if exists idx_results_mark ;
-- create index idx_results_mark on exam_results using btree (mark);
-- create index idx_results_mark on exam_results using hash (mark);

----- subjects -----
-- drop index if exists idx_subject_name ;
-- create index idx_subject_name on subjects using btree (name);
-- create index idx_subject_name on subjects using hash (name);

-------------------------------------- generate data --------------------------------------
-- data for subjects: 1000 records
INSERT INTO subjects (
    "name", tutor
)
SELECT
    concat('subject ',a),
	concat( arrays.firstnames[s.a % ARRAY_LENGTH(arrays.firstnames,1) + 1],
		   ' ',
		    arrays.lastnames[s.a % ARRAY_LENGTH(arrays.lastnames,1) + 1]
		  )
FROM  generate_series(1,1000) AS s(a)
CROSS JOIN(
    SELECT ARRAY[
    'Adam','Bill','Bob','Calvin','Donald','Dwight','Frank','Fred','George','Howard',
    'James','John','Jacob','Jack','Martin','Matthew','Max','Michael',
    'Paul','Peter','Phil','Roland','Ronald','Samuel','Steve','Theo','Warren','William',
    'Abigail','Alice','Allison','Amanda','Anne','Barbara','Betty','Carol','Cleo','Donna',
    'Jane','Jennifer','Julie','Martha','Mary','Melissa','Patty','Sarah','Simone','Susan'
    ] AS firstnames,
    ARRAY[
        'Matthews','Smith','Jones','Davis','Jacobson','Williams','Donaldson','Maxwell','Peterson','Stevens',
        'Franklin','Washington','Jefferson','Adams','Jackson','Johnson','Lincoln','Grant','Fillmore','Harding','Taft',
        'Truman','Nixon','Ford','Carter','Reagan','Bush','Clinton','Hancock'
    ] AS lastnames	
) AS arrays;

-- data for students: 10000 records
INSERT INTO students (
    "name", surname, phone_number, primary_skill_id, date_of_birth
)
SELECT
    arrays.firstnames[s.a % ARRAY_LENGTH(arrays.firstnames,1) + 1] AS firstname,    
    arrays.lastnames[s.a % ARRAY_LENGTH(arrays.lastnames,1) + 1] AS surenames,
	arrays.phonenumbers[s.a % ARRAY_LENGTH(arrays.phonenumbers,1) + 1] AS phonenumbers,
	trunc(random() * 1000 + 1) AS primary_skill_id,
	timestamp '2014-01-10 20:00:00' + random() * (timestamp '1970-01-20 20:00:00' - timestamp '2000-01-10 10:00:00') AS dob
FROM  generate_series(1,10000) AS s(a) -- number of names to generate
CROSS JOIN(
    SELECT ARRAY[
    'Adam','Bill','Bob','Calvin','Donald','Dwight','Frank','Fred','George','Howard',
    'James','John','Jacob','Jack','Martin','Matthew','Max','Michael',
    'Paul','Peter','Phil','Roland','Ronald','Samuel','Steve','Theo','Warren','William',
    'Abigail','Alice','Allison','Amanda','Anne','Barbara','Betty','Carol','Cleo','Donna',
    'Jane','Jennifer','Julie','Martha','Mary','Melissa','Patty','Sarah','Simone','Susan'
    ] AS firstnames,
    ARRAY[
        'Matthews','Smith','Jones','Davis','Jacobson','Williams','Donaldson','Maxwell','Peterson','Stevens',
        'Franklin','Washington','Jefferson','Adams','Jackson','Johnson','Lincoln','Grant','Fillmore','Harding','Taft',
        'Truman','Nixon','Ford','Carter','Reagan','Bush','Clinton','Hancock', 'J.','','M.'
    ] AS lastnames,
	ARRAY[
		'123456789','123456789','322224511','343435663','123123123','645453453','665675676','432526623','904646289',
		'234234775','890345352','457834122','435784823','234677823','135627273','347335122','378902324','135176734'
	] AS phonenumbers
) AS arrays;

-- data for exams results
-- generate for duplicated
/*
INSERT INTO exam_results (student_id, subject_id, mark)
SELECT
    arrays.students[s.a % ARRAY_LENGTH(arrays.students,1) + 1] AS student_ids,
	arrays.subjects[s.a % ARRAY_LENGTH(arrays.subjects,1) + 1] AS subject_ids,
	trunc(random() * 10 + 1) AS mark
FROM  generate_series(1,1000000) AS s(a) -- number of names to generate
CROSS JOIN(
    SELECT ARRAY(
		SELECT a.n
		FROM generate_series(1, 10000) AS a(n)
	) as students,
    ARRAY(
		SELECT a.n
		FROM generate_series(1, 1000) AS a(n)
	) as subjects
) AS arrays;
*/

-- generate no duplicated
DO $$ <<generate_exam_results_block>>
DECLARE
	random_score smallint;
BEGIN
   	FOR iStudent in 1..10000 LOOP
		FOR iSubject in 1..1000 LOOP
			select trunc(random() * 10 + 1) into random_score;			
			INSERT INTO exam_results (student_id, subject_id, mark)
			VALUES (iStudent, iSubject, random_score);
		END LOOP;
	END LOOP;
END generate_exam_results_block $$;

-- select
/*
SELECT
    arrays.students[s.a % ARRAY_LENGTH(arrays.students,1) + 1] AS student_ids,
	arrays.subjects[s.a % ARRAY_LENGTH(arrays.subjects,1) + 1] AS subject_ids,
	trunc(random() * 10 + 1) AS mark	
FROM  generate_series(1,1000000) AS s(a)   -- number of names to generate o
CROSS JOIN(
    SELECT ARRAY(
		SELECT a.n
		FROM generate_series(1, 10000) AS a(n)
	) as students,
    ARRAY(
		SELECT a.n
		FROM generate_series(1, 1000) AS a(n)
	) as subjects
) AS arrays
group by (student_ids, subject_ids)
order by student_ids, subject_ids;
*/