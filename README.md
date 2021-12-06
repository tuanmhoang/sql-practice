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

## What to test?

1/ Design database for a CDP program. DB should store information about students (name, surname, date of birth, phone numbers, primary skill, created_datetime, updated_datetime etc.), subjects (subject name, tutor, etc.) and exam results (student, subject, mark).

2/ Try different kind of indexes (B-tree, Hash, GIN, GIST) for the fields. Analyze performance for each of the indexes (use ANALYZE and EXPLAIN). Check the size of the index. Try to set index before inserting test data and after. What was the time? Test data:

a. 100K of users

b. 1K of subjects

c. 1 million of marks

## Diagram

![image](https://user-images.githubusercontent.com/37680968/144784019-0b2bc3b8-5ddd-4a66-8ba5-eb66a057a888.png)

## Result
