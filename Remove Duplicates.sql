--Drop Duplicates

--Scenario 1: Data duplicated based on SOME of the columns
drop table if exists cars;
create table cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);

select * from cars
order by model, brand;

--1st way
--Use Unique Identifier
delete from cars
where id in (
			select model,brand ,max(id)
			from cars
			group by model,brand   --Cloumns that have dublicated rows
			having count(1) >1
			)

--2nd way
--Self Join
delete from cars
where id in (
			select c1.* , c2.*
			from cars c1 inner join cars c2
			on c1.model = c2.model
			and c1.brand = c2.brand
			where c1.id > c2.id
			)

--3rd way
--Window function
delete from cars
where id in (
			select id 
			from
				(select * , ROW_NUMBER() OVER(Partition by model ,brand order by id) as RN
				from cars ) as tbl
			where tbl.RN > 1
			)
--4th
--Min Function
delete from cars
where id not in (
			select min(id)
			from cars
			group by model , brand	
			)

---------------------------------------------------------------------------------------------
--Scenario 2: Data duplicated based on ALL of the columns

insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);

select * from cars;

--1st 
--Window Function
delete from cars
where id in (
			select id 
			from
				(select * , ROW_NUMBER() OVER(Partition by model ,brand ,color , make , id order by id) as RN
				from cars ) as tbl
			where tbl.RN > 1
			)

--2nd
--Backup Table
create table cars_bkp
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
)
insert into cars_bkp 
select distinct * from cars;