--Problem 1
--Suppose you have a car travelling certain distance and the data is presented as follows -
--Day 1 - 50 km
--Day 2 - 100 km
--Day 3 - 200 km

--Sample Dataset:

create table car_travels
(
    cars                    varchar(40),
    days                    varchar(10),
    cumulative_distance     int
);
insert into car_travels values ('Car1', 'Day1', 50);
insert into car_travels values ('Car1', 'Day2', 100);
insert into car_travels values ('Car1', 'Day3', 200);
insert into car_travels values ('Car2', 'Day1', 0);
insert into car_travels values ('Car3', 'Day1', 0);
insert into car_travels values ('Car3', 'Day2', 50);
insert into car_travels values ('Car3', 'Day3', 50);
insert into car_travels values ('Car3', 'Day4', 100);

select * from car_travels;

--Using Lag Function
--Lag & Lead
--LAG(Col_name , No.Rows , Value if Null)

select * 
	, cumulative_distance 
		- LAG(cumulative_distance , 1 ,0 )
			over(partition by cars order by days) as Travelled_Distance
from car_travels;


------------------------------------------------------------------------------
--Problem 2
create table emp_input
(
id      int,
name    varchar(40)
);
insert into emp_input values (1, 'Emp1');
insert into emp_input values (2, 'Emp2');
insert into emp_input values (3, 'Emp3');
insert into emp_input values (4, 'Emp4');
insert into emp_input values (5, 'Emp5');
insert into emp_input values (6, 'Emp6');
insert into emp_input values (7, 'Emp7');
insert into emp_input values (8, 'Emp8');

select * from emp_input;

--Solution
with cte as
(select CONCAT(id ,' ' , name) as name, ntile(4) over(order by id) as buckets
from emp_input)
select STRING_AGG(name , ' , ') as final_result
from cte
group by buckets
order by 1

--Another Solution (Without CTE)
create table emp_temp
(
buckets      int,
name    varchar(40)
)

insert into emp_temp(name,buckets)
select CONCAT(id ,' ' , name) as name, ntile(4) over(order by id) as buckets
from emp_input

select * from emp_temp

select STRING_AGG(name , ' , ') as final_result 
from emp_temp
group by buckets
order by 1

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--Tree Node Problem:
CREATE TABLE Tree (
    id INT PRIMARY KEY,
    p_id INT
);

-- Inserting sample data
INSERT INTO Tree (id, p_id) VALUES (1, NULL);
INSERT INTO Tree (id, p_id) VALUES (2, 1);
INSERT INTO Tree (id, p_id) VALUES (3, 1);
INSERT INTO Tree (id, p_id) VALUES (4, 2);
INSERT INTO Tree (id, p_id) VALUES (5, 2);

select * from Tree

--Solution
select id , p_id,
	case when p_id is null then 'Root'
	     when P_id is not null and  id in (select distinct p_id from Tree) then 'Inner'
		 else 'Leaf'
	end as Type
from Tree
