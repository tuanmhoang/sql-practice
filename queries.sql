-- 1/Select all primary skills that contain more than one word (please note that both ‘-‘ and ‘ ’ could be used as a separator).
explain analyze
SELECT distinct primary_skill 
FROM students
WHERE (LENGTH(primary_skill) - LENGTH(replace(primary_skill, ' ', ''))) > 0;

-- 2/Select all students who do not have a second name (it is absent or consists of only one letter/letter with a dot). 

explain analyze
SELECT * FROM students
WHERE surname like '%.' or surname = '';


-- 3/Select number of students passed exams for each subject and order result by a number of student descending. 
-- assume pass mark is 5

explain analyze
select s.id as subject_id, count(r.student_id) as no_of_students
from subjects s
join exam_results r on r.subject_id = s.id
where r.mark >= 5
group by s.id
order by no_of_students desc;


-- 4/Select the number of students with the same exam marks for each subject. 

select r.subject_id, r.mark, count(r.student_id) 
from exam_results r
group by (r.subject_id, r.mark) 
order by r.subject_id, r.mark;


-- 5/Select students who passed at least two exams for different subjects. 
update exam_results
set mark = 2
where student_id in (1, 2, 3);

select * from exam_results
where student_id in (1, 2, 3);

select r.student_id, count (r.mark >= 5) no_of_pass 
from exam_results r
where r.mark >= 5
group by r.student_id
having count (r.mark) >= 2;

-- 6/Select students who passed at least two exams for the same subject. 
select r.student_id, r.subject_id, count (r.mark)
from exam_results r
where r.mark >= 5
group by r.student_id, r.subject_id
having count (r.mark) >= 2
order by r.student_id, r.subject_id;

/*
-- verify
select count(*)
from exam_results r
where r.student_id = 1
and r.subject_id = 2
and r.mark >= 5;
*/

-- 7/Select all subjects which exams passed only students with the same primary skills. 
select distinct su.id as subject_id, su.name as subject, st.id as student_id,  st.name as student_name
from exam_results r
join students st on st.id = r.student_id
join subjects su on su.id = r.subject_id
where r.mark >= 5
and r.subject_id = st.primary_skill_id;

-- verify
-- select * from students where id = 1964;

-- 8/Select all subjects which exams passed only students with the different primary skills. It means that all students passed the exam for the one subject must have different primary skill. 
select distinct su.id as subject_id, su.name as subject, st.id as student_id,  st.name as student_name
from exam_results r
join students st on st.id = r.student_id
join subjects su on su.id = r.subject_id
where r.mark >= 5
and r.subject_id != st.primary_skill_id
order by subject_id, student_id;

-- verify
-- select * from students where id = 1;

/*
9/Select students who do not pass any exam using each of the following operator: 
- Outer join
- Subquery with ‘not in’ clause
- Subquery with ‘any ‘ clause Check which approach is faster for 1000, 10K, 100K exams and 10, 1K, 100K students
*/
-- prepare data: use not duplicated generator
update exam_results
set mark = 2
where student_id in (1, 2, 3);

select count(*) from exam_results
where student_id in (1, 2, 3);

-- query
-- normal
explain analyze
select r.student_id, count (r.mark) 
from exam_results r
where r.mark < 5 
group by r.student_id
having count (r.mark) = (select count (*) from subjects)
order by r.student_id;

-- operator outer join
explain analyze
select distinct s.id, s.name from students s
left outer join exam_results r on r.student_id = s.id
where s.id in (
	select r.student_id
	from exam_results r
	where r.mark < 5 
	group by r.student_id
	having count (r.mark) = (select count (*) from subjects)
	order by r.student_id
);

-- operator not in
explain analyze
select * from students 
where students.id not in (
	select r.student_id 
	from exam_results r
	where r.mark >= 5 
	group by r.student_id
	having count (r.mark) < (select count (*) from subjects)
	order by r.student_id
);
--- operator any
select * from students 
where students.id = any (
	select r.student_id 
	from exam_results r
	where r.mark < 5 
	group by r.student_id
	having count (r.mark) = (select count (*) from subjects)
	order by r.student_id
);

-- 10/Select all students whose average mark is bigger than the overall average mark. 
select r.student_id, avg(mark) 
from exam_results r
group by r.student_id
having avg(mark) > (select avg(mark) from exam_results)
order by r.student_id;

-- 11/Select the top 5 students who passed their last exam better than average students. 
-- verify
-- select avg(mark) from exam_results where student_id = 9;

-- assume last exam is subject_id = 1000
select r.student_id, r.mark
from exam_results r
where r.subject_id = 1000
and r.mark > (select avg(mark) from exam_results)
order by r.mark desc
limit 5
;

/**
12/Select the biggest mark for each student and add text description for the mark (use COALESCE and WHEN operators) 
- In case if the student has not passed any exam ‘not passed' should be returned.
- If the student mark is 1,2,3 – it should be returned as ‘BAD’
- If the student mark is 4,5,6 – it should be returned as ‘AVERAGE’
- If the student mark is 7,8 – it should be returned as ‘GOOD’
- If the student mark is 9,10 – it should be returned as ‘EXCELLENT’
**/

-- prepare data: use not duplicated generator
update exam_results set mark = 5 where student_id in (4, 5);
update exam_results set mark = 7 where student_id in (6, 7, 8);

select count(*) from exam_results where student_id in (1, 2, 3);

-- query
select r.student_id, max(r.mark), 
	case 
		when max(r.mark) between 1 and 3 then 'BAD'
		when max(r.mark) between 4 and 6 then 'AVERAGE'
		when max(r.mark) between 7 and 8 then 'GOOD'
		else 'EXCELLENT'
	end as student_type
from exam_results r
group by r.student_id;

-- 13/Select the number of all marks for each mark type (‘BAD’, ‘AVERAGE’,…). 
select  
	case 
		when r.mark between 1 and 3 then 'BAD'
		when r.mark between 4 and 6 then 'AVERAGE'
		when r.mark between 7 and 8 then 'GOOD'
		else 'EXCELLENT'
	end as mark_range,
	count(*)
from exam_results r
GROUP BY mark_range;
