# sql-practice
practice sql

## Run docker
```
docker compose up -d
```

## Notes
- Multiple primary keys: https://stackoverflow.com/questions/23533184/primary-key-for-multiple-column-in-postgresql
- Multiple foreign keys: https://dba.stackexchange.com/questions/240160/postgresql-multiple-column-foreign-key
- https://stackoverflow.com/questions/9267535/double-foreign-key-in-postgresql
- n to n relationship: https://stackoverflow.com/questions/9789736/how-to-implement-a-many-to-many-relationship-in-postgresql
- blocks vs stored procedure: https://www.oreilly.com/library/view/mysql-stored-procedure/0596100892/ch04s01.html (mysql)
- array: https://dba.stackexchange.com/questions/209431/postgres-declaring-variable-containing-date-array-in-functions
- for loop: https://stackoverflow.com/questions/19145761/postgres-for-loop
- create predefined array: https://stackoverflow.com/questions/24938311/create-a-function-declaring-a-predefined-text-array
- ideas to generate dummy data: https://stackoverflow.com/questions/24841142/how-can-i-generate-big-data-sample-for-postgresql-using-generate-series-and-rand
- nice ideas for generating data https://gist.github.com/jbnv/ca5a7829927a6b8f2308
- generate timestamp for dob ideas: https://stackoverflow.com/questions/22964272/postgresql-get-a-random-datetime-timestamp-between-two-datetime-timestamp
- concat string: https://stackoverflow.com/questions/19942824/how-to-concatenate-columns-in-a-postgres-select
- random number from range (for scores): https://stackoverflow.com/questions/1400505/generate-a-random-number-in-the-range-1-10
- btree index references: https://towardsdatascience.com/climbing-b-tree-indexes-in-postgres-b67a7e596db
- indexes: https://devcenter.heroku.com/articles/postgresql-indexes#index-types

>B-Tree is the default that you get when you do CREATE INDEX. Virtually all databases will have some B-tree indexes. B-trees attempt to remain balanced, with the amount of data in each branch of the tree being roughly the same. Therefore the number of levels that must be traversed to find rows is always in the same ballpark. B-tree indexes can be used for equality and range queries efficiently. They can operate against all datatypes, and can also be used to retrieve NULL values. B-trees are designed to work very well with caching, even when only partially cached.
>
>Hash Indexes pre-Postgres 10 are only useful for equality comparisons, but you pretty much never want to use them since they are not transaction safe, need to be manually rebuilt after crashes, and are not replicated to followers, so the advantage over using a B-Tree is rather small. In Postgres 10 and above, hash indexes are now write-ahead logged and replicated to followers.
>
>Generalized Inverted Indexes (GIN) are useful when an index must map many values to one row, whereas B-Tree indexes are optimized for when a row has a single key value. GINs are good for indexing array values as well as for implementing full-text search.
>
>Generalized Search Tree (GiST) indexes allow you to build general balanced tree structures, and can be used for operations beyond equality and range comparisons. They are used to index the geometric data types, as well as full-text search.

## What to test?

1/ Design database for a CDP program. DB should store information about students (name, surname, date of birth, phone numbers, primary skill, created_datetime, updated_datetime etc.), subjects (subject name, tutor, etc.) and exam results (student, subject, mark).

2/ Try different kind of indexes (B-tree, Hash, GIN, GIST) for the fields. Analyze performance for each of the indexes (use ANALYZE and EXPLAIN). Check the size of the index. Try to set index before inserting test data and after. What was the time? Test data:

a. 100K of users

b. 1K of subjects

c. 1 million of marks

## Diagram

![image](https://user-images.githubusercontent.com/37680968/144784019-0b2bc3b8-5ddd-4a66-8ba5-eb66a057a888.png)

## Queries to do

1/Select all primary skills that contain more than one word (please note that both ‘-‘ and ‘ ’ could be used as a separator). 

2/Select all students who do not have a second name (it is absent or consists of only one letter/letter with a dot). 

3/Select number of students passed exams for each subject and order result by a number of student descending. 

4/Select the number of students with the same exam marks for each subject. 

5/Select students who passed at least two exams for different subjects. 

6/Select students who passed at least two exams for the same subject. 

7/Select all subjects which exams passed only students with the same primary skills. 

8/Select all subjects which exams passed only students with the different primary skills. It means that all students passed the exam for the one subject must have different primary skill. 

9/Select students who do not pass any exam using each of the following operator: 
- Outer join
- Subquery with ‘not in’ clause
- Subquery with ‘any ‘ clause Check which approach is faster for 1000, 10K, 100K exams and 10, 1K, 100K students

10/Select all students whose average mark is bigger than the overall average mark. 

11/Select the top 5 students who passed their last exam better than average students. 

12/Select the biggest mark for each student and add text description for the mark (use COALESCE and WHEN operators) 
- In case if the student has not passed any exam ‘not passed' should be returned.
- If the student mark is 1,2,3 – it should be returned as ‘BAD’
- If the student mark is 4,5,6 – it should be returned as ‘AVERAGE’
- If the student mark is 7,8 – it should be returned as ‘GOOD’
- If the student mark is 9,10 – it should be returned as ‘EXCELLENT’

13/Select the number of all marks for each mark type (‘BAD’, ‘AVERAGE’,…). 

