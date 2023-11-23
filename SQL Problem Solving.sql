--------------------------------------------------
--SQL Proplem Solving
--------------------------------------------------
--1
/* Write an SQL query to display the correct message (meaningful message) from the input
comments_and_translation table. */

drop table comments_and_translations;
create table comments_and_translations
(
	id				int,
	comment			varchar(100),
	translation		varchar(100)
);

insert into comments_and_translations values
(1, 'very good', null),
(2, 'good', null),
(3, 'bad', null),
(4, 'ordinary', null),
(5, 'cdcdcdcd', 'very bad'),
(6, 'excellent', null),
(7, 'ababab', 'not satisfied'),
(8, 'satisfied', null),
(9, 'aabbaabb', 'extraordinary'),
(10, 'ccddccbb', 'medium');

select *
from comments_and_translations

--First Solution
select COALESCE(translation, comment) AS output
from comments_and_translations

--Second Solution
select 
	  CASE 
			When translation is null 
			then comment 
			else translation
			end as Output
from comments_and_translations


--------------------------------------------------------------------
--2

DROP TABLE source;
CREATE TABLE source
    (
        id      int,
        name    varchar(1)
    );

DROP TABLE target;
CREATE TABLE target
    (
        id      int,
        name    varchar(1)
    );

INSERT INTO source VALUES (1, 'A');
INSERT INTO source VALUES (2, 'B');
INSERT INTO source VALUES (3, 'C');
INSERT INTO source VALUES (4, 'D');
INSERT INTO source VALUES (6, 'C');

INSERT INTO target VALUES (1, 'A');
INSERT INTO target VALUES (2, 'B');
INSERT INTO target VALUES (4, 'X');
INSERT INTO target VALUES (5, 'F');


select s.id , 'New in Source' as Comment
from source s 
left join target t 
on s.id = t.id 
where t.id is null
union
select t.id , 'New in Target' as Comment
from source s 
right join target t 
on s.id = t.id 
where s.id is null
union
select s.id , 'Mismatch' as Comment
from source s 
inner join target t 
on s.id = t.id and s.name <> t.name

-------------------------------------------------------------
--3
/* There are 10 IPL team. write an sql query such that each team play with every other team just once. */

create table teams
    (
        team_code       varchar(10),
        team_name       varchar(40)
    );

insert into teams values ('RCB', 'Royal Challengers Bangalore');
insert into teams values ('MI', 'Mumbai Indians');
insert into teams values ('CSK', 'Chennai Super Kings');
insert into teams values ('DC', 'Delhi Capitals');
insert into teams values ('RR', 'Rajasthan Royals');
insert into teams values ('SRH', 'Sunrisers Hyderbad');
insert into teams values ('PBKS', 'Punjab Kings');
insert into teams values ('KKR', 'Kolkata Knight Riders');
insert into teams values ('GT', 'Gujarat Titans');
insert into teams values ('LSG', 'Lucknow Super Giants');


with matches as
	(select ROW_NUMBER() over(order by team_name) as id ,*
	from teams)
select t.team_name as team , o.team_name as opponent
from matches t
inner join matches o
on t.id < o.id
order by team

--Another Problems like 3
/*There are 5 programming languages.
Write an SQL query to generate pairs of languages for a programming competition.
Each language should compete against every other language exactly once.*/

-- Create table and insert data
CREATE TABLE programming_languages (
    language_id INT,
    language_name VARCHAR(50)
);

INSERT INTO programming_languages VALUES
(1, 'Java'),
(2, 'Python'),
(3, 'JavaScript'),
(4, 'C#'),
(5, 'Ruby');

select *
from programming_languages

with competition as
	(select ROW_NUMBER() over(order by language_id) , *
	 from programming_languages
	)
select t1.language_name as Lan , t2.language_name as OpponentLan
from programming_languages t1 
inner join programming_languages t2
on t1.language_id < t2.language_id
order by 1

-------------------------------------------------------------------
--4
--Write a SQL query to fetch all the duplicate records from a table.

--Tables Structure:

drop table users;
create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

select * from users;


--Windowing Function
Select user_id , user_name , email 
from    (
		select * , ROW_NUMBER() over(partition by user_name order by user_id ) as RN
		from users) x
where x.rn > 1

-------------------------------------------------------------------------------
--5
--Write a SQL query to fetch the second last record from a employee table.

--Tables Structure:

create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

select * from employee;

--Solution
select  emp_ID , emp_NAME , DEPT_NAME ,SALARY
from (select * , ROW_NUMBER() over(Order by emp_ID desc) as RN
	from employee) x
Where x.RN =2	

---------------------------------------------------------------------
--6
/*Write a SQL query to display only the details of employees who either earn the highest salary
or the lowest salary in each department from the employee table */

--Tables Structure:

drop table employee;
create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);

select * from employee;

--1st Solution
select *
from (select * ,
max(salary) over(partition by dept_name) as maxsalary,
min(salary) over(partition by dept_name) as minsalary
from employee) x
where x.SALARY = x.maxsalary
or x.SALARY = x.minsalary

--2nd solution
select x.*
from employee e
join (select *,
max(salary) over (partition by dept_name) as max_salary,
min(salary) over (partition by dept_name) as min_salary
from employee) x
on e.emp_id = x.emp_id
and (e.salary = x.max_salary or e.salary = x.min_salary)
order by x.dept_name, x.salary;

--------------------------------------------------------------------------
--7
--From the doctors table, fetch the details of doctors who work in the same hospital but in different speciality.

--Table Structure:
create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

select * from doctors;

--Solution
select d1.*
from doctors d1
join doctors d2
on d1.hospital = d2.hospital
and d1.speciality <> d2.speciality
and d1.id <> d2.id

---------------------------------------------------------------------
--8
--From the login_details table, fetch the users who logged in consecutively 3 or more times.

--Table Structure:

create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

delete from login_details;
insert into login_details values
(101, 'Michael', GETDATE()),
(102, 'James', GETDATE()),
(103, 'Stewart', GETDATE()+1),
(104, 'Stewart', GETDATE()+1),
(105, 'Stewart', GETDATE()+1),
(106, 'Michael', GETDATE()+2),
(107, 'Michael', GETDATE()+2),
(108, 'Stewart', GETDATE()+3),
(109, 'Stewart', GETDATE()+3),
(110, 'James', GETDATE()+4),
(111, 'James', GETDATE()+4),
(112, 'James', GETDATE()+5),
(113, 'James', GETDATE()+6);

select * from login_details;

--1st Solution
Select distinct user_name as RepeatedNames --, ROW_NUMBER() over(Partition by x.names order by login_id) as RN
from
	(select * , 
			case
			when user_name = LEAD(user_name) over(order by login_id) and
				user_name = LEAD(user_name,2) over(order by login_id) then user_name
				end as Names
	from login_details) x
Where x.Names is not null

---------------------------------------------------------------------------
--9
--From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.

Note: Weather is considered to be extremely cold then its temperature is less than zero.

--Table Structure:
drop table weather
create table weather
(
id int,
city varchar(50),
temperature int,
day date
);
insert into weather values
(1, 'London', -1, Convert(Date ,'2021-01-01',23)),
(2, 'London', -2, Convert(Date ,'2021-01-02',23)),
(3, 'London', 4, Convert(Date ,'2021-01-03',23)),
(4, 'London', 1, Convert(Date ,'2021-01-04',23)),
(5, 'London', -2, Convert(Date ,'2021-01-05',23)),
(6, 'London', -5, Convert(Date ,'2021-01-06',23)),
(7, 'London', -7, Convert(Date ,'2021-01-07',23)),
(8, 'London', 5, Convert(Date ,'2021-01-08',23));

select * from weather;


Select *
From
(select day, temperature,
      CASE 
	  When temperature <0 
	  and LEAD(temperature) over(order by day) <0
	  and LEAD(temperature ,2) over(order by day) <0
	  then 'extremely cold'
	  When temperature <0 
	  and LAG(temperature) over(order by day) <0
	  and LEAD(temperature) over(order by day) <0
	  then 'extremely cold'
	  When temperature <0 
	  and LAG(temperature) over(order by day) <0
	  and LAG(temperature ,2) over(order by day) <0
	  then 'extremely cold'
	  end As Weather_State
from weather) x
where x.Weather_State ='extremely cold'

----------------------------------------------------------------------------------
--10
--Find the top 2 accounts with the maximum number of unique patients on a monthly basis.
--Note: Prefer the account if with the least value in case of same number of unique patients

--Table Structure:

drop table patient_logs;
create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

INSERT INTO patient_logs VALUES (1, CONVERT(DATETIME, '02-01-2020', 105), 100);
INSERT INTO patient_logs VALUES (1, CONVERT(DATETIME, '27-01-2020', 105), 200);
INSERT INTO patient_logs VALUES (2, CONVERT(DATETIME, '01-01-2020', 105), 300);
INSERT INTO patient_logs VALUES (2, CONVERT(DATETIME, '21-01-2020', 105), 400);
INSERT INTO patient_logs VALUES (2, CONVERT(DATETIME, '21-01-2020', 105), 300);
INSERT INTO patient_logs VALUES (2, CONVERT(DATETIME, '01-01-2020', 105), 500);
INSERT INTO patient_logs VALUES (3, CONVERT(DATETIME, '20-01-2020', 105), 400);
INSERT INTO patient_logs VALUES (1, CONVERT(DATETIME, '04-03-2020', 105), 500);
INSERT INTO patient_logs VALUES (3, CONVERT(DATETIME, '20-01-2020', 105), 450);

select * from patient_logs;

--Solution
Select *
From
	(Select * ,rank() over(partition by month order by no_patient desc , account_id) as rnk
	From
		(select x.month , x.account_id , COUNT(1) as no_patient
		From
			(Select distinct Format(date , 'MMMM') as month , account_id , patient_id
			from patient_logs
			) x 
		group by month	, account_id) Y) Z
Where z.rnk <3








