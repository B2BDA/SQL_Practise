CREATE database test;
USE test;
drop table if exists sample;

CREATE TABLE test.sample(
 CustID int ,
 TranID int ,
 TranAmt float ,
 TranDate date 
) ;

INSERT test.sample (CustID, TranID, TranAmt, TranDate) VALUES (1001, 20001, 10000, CAST('2020-04-25' AS Date));
INSERT test.sample (CustID, TranID, TranAmt, TranDate) VALUES (1001, 20002, 15000, CAST('2020-04-25' AS Date));
INSERT test.sample (CustID, TranID, TranAmt, TranDate) VALUES (1001, 20003, 80000, CAST('2020-04-25' AS Date));
INSERT test.sample (CustID, TranID, TranAmt, TranDate) VALUES (1001, 20004, 20000, CAST('2020-04-25' AS Date));
INSERT test.sample (CustID, TranID, TranAmt, TranDate) VALUES (1002, 30001, 7000, CAST('2020-04-25' AS Date));
INSERT test.sample (CustID, TranID, TranAmt, TranDate) VALUES (1002, 30002, 15000, CAST('2020-04-25' AS Date));
INSERT test.sample (CustID, TranID, TranAmt, TranDate) VALUES (1002, 30003, 22000, CAST('2020-04-25' AS Date));


/*Problem Statement:-
Transatcion_tbl Table has four columns CustID, TranID, TranAmt, and  TranDate. User has to display all these fields along with maximum TranAmt for each CustID and ratio of TranAmt and maximum TranAmt for each transaction.*/
SELECT
*
,max(TranAmt) over(partition by CustID order by TranDate) as max_tran_amt
,TranAmt/max(TranAmt) over(partition by CustID order by TranDate) as ratio
from
test.sample;

/*Problem Statement : Write a SQL query to find the maximum and minimum values of continuous ‘Sequence’ in each ‘Group’*/
CREATE TABLE Emp(
`Group`  varchar(20),
Sequence  int );

INSERT INTO Emp VALUES('A',1);
INSERT INTO Emp VALUES('A',2);
INSERT INTO Emp VALUES('A',3);
INSERT INTO Emp VALUES('A',5);
INSERT INTO Emp VALUES('A',6);
INSERT INTO Emp VALUES('A',8);
INSERT INTO Emp VALUES('A',9);
INSERT INTO Emp VALUES('B',11);
INSERT INTO Emp VALUES('C',1);
INSERT INTO Emp VALUES('C',2);
INSERT INTO Emp VALUES('C',3);

select * from Emp;

with cte as (select
`Group`
,Sequence
,(Sequence - row_number() over(partition by `Group`)) as row_grp_diff
from Emp)
select `Group`
,min(Sequence) as min_Seq
,max(Sequence) as min_Seq
from cte
group by `Group`,row_grp_diff;

/*Problem Statement:-
Student Table has three columns Student_Name, Total_Marks and Year. User has to write a SQL query to display Student_Name, Total_Marks, Year,  Prev_Yr_Marks for those whose Total_Marks are greater than or equal to the previous year.*/
CREATE TABLE Student(
Student_Name  varchar(30),
Total_Marks  int ,
Year  int);

INSERT INTO Student VALUES('Rahul',90,2010);
INSERT INTO Student VALUES('Sanjay',80,2010);
INSERT INTO Student VALUES('Mohan',70,2010);
INSERT INTO Student VALUES('Rahul',90,2011);
INSERT INTO Student VALUES('Sanjay',85,2011);
INSERT INTO Student VALUES('Mohan',65,2011);
INSERT INTO Student VALUES('Rahul',80,2012);
INSERT INTO Student VALUES('Sanjay',80,2012);
INSERT INTO Student VALUES('Mohan',90,2012);

select * from Student;

with cte as (select Student_Name
,`Year`
,Total_Marks
,lag(Total_Marks) OVER(partition by Student_Name order by `Year`) as prev_yr_marks
from Student)
select
Student_Name
,Total_Marks
,`Year`
,prev_yr_marks
from cte
where Total_Marks>=prev_yr_marks;

/*Problem Statement:-
Emp_Details  Table has four columns EmpID, Gender, EmailID and DeptID. User has to write a SQL query to derive another column called Email_List to display all Emailid concatenated with semicolon associated with a each DEPT_ID  as shown below in output Table.
*/
CREATE TABLE Emp_Details (
EMPID int,
Gender varchar(255),
EmailID varchar(30),
DeptID int);

INSERT INTO Emp_Details VALUES (1001,'M','YYYYY@gmaix.com',104);
INSERT INTO Emp_Details VALUES (1002,'M','ZZZ@gmaix.com',103);
INSERT INTO Emp_Details VALUES (1003,'F','AAAAA@gmaix.com',102);
INSERT INTO Emp_Details VALUES (1004,'F','PP@gmaix.com',104);
INSERT INTO Emp_Details VALUES (1005,'M','CCCC@yahu.com',101);
INSERT INTO Emp_Details VALUES (1006,'M','DDDDD@yahu.com',100);
INSERT INTO Emp_Details VALUES (1007,'F','E@yahu.com',102);
INSERT INTO Emp_Details VALUES (1008,'M','M@yahu.com',102);
INSERT INTO Emp_Details VALUES (1009,'F','SS@yahu.com',100);

select * from Emp_Details;

SELECT 
DeptID
,group_concat(EmailID   SEPARATOR '; ' ) as Email_List
from Emp_Details group by DeptID;

/*This question has been asked in Amazon interview for the role of Data Analyst
Order_Tbl has four columns namely ORDER_DAY, ORDER_ID, PRODUCT_ID, QUANTITY and PRICE
(a) Write a SQL to get all the products that got sold on both the days and the number of times the product is sold.
(b) (b) Write a SQL to get products that was ordered on 02-May-2015 but not on 01-May-2015*/

CREATE TABLE Order_Tbl(
 ORDER_DAY date,
 ORDER_ID varchar(10) ,
 PRODUCT_ID varchar(10) ,
 QUANTITY int ,
 PRICE int 
) ;
INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR1', 'PROD1', 5, 5);
INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR2', 'PROD2', 2, 10);
INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR3', 'PROD3', 10, 25);
INSERT INTO Order_Tbl  VALUES ('2015-05-01','ODR4', 'PROD1', 20, 5);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR5', 'PROD3', 5, 25);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR6', 'PROD4', 6, 20);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR7', 'PROD1', 2, 5);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR8', 'PROD5', 1, 50);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR9', 'PROD6', 2, 50);
INSERT INTO Order_Tbl  VALUES ('2015-05-02','ODR10','PROD2', 4, 10);

select * from Order_Tbl;

with cte as (select
product_id,
order_day,
lag(order_day) over(partition by product_id) as next_day,
order_id
from 
Order_Tbl
order by 1,2),
cte2 as (
select
product_id
,datediff(order_day,next_day) as date_diff
,order_id
 from cte),
 cte3 as(
select 
product_id
from cte2
where date_diff <= 1)
select
product_id
,count(order_id) as num_times_ordered
from cte2
where product_id in (select distinct product_id from cte3)
group by 1
;

select
product_id
from
Order_Tbl
where
order_day = '2015-05-02'
and product_id not in 
(select
product_id
from
Order_Tbl
where
order_day = '2015-05-01');

/*This question is in continuation with the Part 5 video. If you not watched , I strongly recommend to watch Part 5 video before proceeding with Part 6 video.
This question has been taken from Amazon's interview questions
Problem Statements :-
(a) Write a SQL to get the highest sold Products (Quantity*Price) on both the days 
(b) Write a SQL to get all product's  total sales on 1st May and 2nd May adjacent to each other
(c) Write a SQL to get all products day wise, that was ordered more than once
*/
with cte as (select 
product_id
,order_day
,sum(Quantity*Price) over(partition by order_day,product_id) as total_sold
from Order_Tbl),
cte1 as (select
distinct order_day,
max(total_sold) over(partition by order_day) as max_sold
from
cte)
select
product_id
,cte.order_day
,total_sold
from cte
inner join 
cte1
on 
cte.order_day = cte1.order_day
and 
cte.total_sold = cte1.max_sold
;

with cte as (select
product_id
,order_day
,lead(order_day) over(partition by product_id) as next_day
,sum(Quantity*Price) as sold
from 
Order_Tbl
group by 1,2
order by 1,2),
cte1 as(
 select 
 *
 ,lead(sold) over(partition by product_id) as sold_next_day
 from 
 cte)
 select
 product_id
 ,order_day
 ,sold
,coalesce(next_day,order_day) as next_day
 ,sold_next_day

 from cte1
 where order_day != next_day;
 
with cte as (select
order_day
,product_id
,count(order_id) as num_ordered
from 
Order_Tbl
group by 1,2
order by 1,2)
select 
order_day
,product_id
from cte
where num_ordered>1
;


/*Problem Statements :-
Write a SQL which will explode the above data into single unit level records as shown below*/
CREATE TABLE Order_Tbl_1(
 ORDER_ID varchar(10) ,
 PRODUCT_ID varchar(10) ,
 QUANTITY int 
) ;
INSERT INTO Order_Tbl_1  VALUES ('ODR1', 'PROD1', 5);
INSERT INTO Order_Tbl_1  VALUES ('ODR2', 'PROD2', 1);
INSERT INTO Order_Tbl_1  VALUES ('ODR3', 'PROD3', 3);


select * from Order_Tbl_1;


with recursive base as(
/*Anchor part */
	select order_id,product_id, quantity, 1 as q, 1 as counter 
    from  Order_Tbl_1 
    UNION ALL
/*Recursive part */
    select order_id,product_id, quantity, q, counter+1  as counter 
    from  base where  counter+ 1 <= quantity
)
select order_id,product_id,q as quantity from base order by order_id;
 
/*Employee Table has four columns namely EmpID , EmpName, Salary and DeptID
Write a SQL  to find all Employees who earn more than the average salary in their corresponding department.*/
CREATE Table Employee
(
EmpID INT,
EmpName Varchar(30),
Salary Float,
DeptID INT
);

INSERT INTO Employee VALUES(1001,'Mark',60000,2);
INSERT INTO Employee VALUES(1002,'Antony',40000,2);
INSERT INTO Employee VALUES(1003,'Andrew',15000,1);
INSERT INTO Employee VALUES(1004,'Peter',35000,1);
INSERT INTO Employee VALUES(1005,'John',55000,1);
INSERT INTO Employee VALUES(1006,'Albert',25000,3);
INSERT INTO Employee VALUES(1007,'Donald',35000,3);


select * from Employee;

with cte as (select
*
,avg(salary) over(partition by DeptID) as dept_avg_sal
from
Employee)
select * from cte
where salary>dept_avg_sal;


/*Input :-  Team Table has two columns namely ID and TeamName and it contains 4 TeamsName.
Problem Statements :- Write a SQL which will fetch total schedule of matches between each Team vs opposite team:*/
Create Table Team(
ID INT,
TeamName Varchar(50)
);
INSERT INTO Team VALUES(1,'India'),(2,'Australia'),(3,'England'),(4,'NewZealand');


select * from Team;

select
concat(t1.TeamName ,' vs ',t2.TeamName) as matches
from Team as t1, Team as t2
where t1.id > t2.id;


/*Input :- Table Match_Result has three columns  namely Team_1, Team_2 and Result.
Problem Statements :- Write SQL to display total number of matches played, matches won, matches tied and matches lost for each team*/
create table match_result (Team_1 varchar(25),Team_2 varchar(25),Result varchar(25));
insert into match_result values ('India','Australia','India'),
								  ('India','England','England'),
								  ('SouthAfrica','India','India'),
								  ('Australia','England',null),
								  ('England','SouthAfrica','SouthAfrica'),
								  ('Australia','India','Australia');
                                  
select
*
from 
match_result;

with cte as(select 
Team_1
,count(*) as num_played
,coalesce(sum(case when (Team_1 = Result) then 1 end),0) as num_won
,coalesce(sum(case when (Result is NULL) then 1 end),0) as num_tie
, coalesce(sum(case when (Team_1 <> Result) then 1 end),0) as num_lost
from
match_result
group by 1),
cte2 as (select 
Team_2
,count(*) as num_played
, coalesce(sum(case when (Team_2 = Result) then 1 end),0) as num_won
,coalesce(sum(case when (Result is NULL) then 1 else 0 end),0) as num_tie
, coalesce(sum(case when (Team_2 <> Result) then 1 end),0) as num_lost
from
match_result
group by 1),
cte5 as(
select 
Team_1
,(cte.num_won+cte2.num_won) as Match_Won
, (cte.num_played + cte2.num_played) as Match_Played
,(cte.num_tie + cte2.num_tie) as Match_Tie
,(cte.num_lost + cte2.num_lost) as Match_Lost
from 
cte inner join cte2
on cte.Team_1 = cte2.Team_2)
select * 
from cte5 ;

/*Input :- Transaction_Table has four columns  namely  AccountNumber, TransactionTime, TransactionID and Balance

Problem Statements :- Write SQL to get the most recent / latest balance, and TransactionID for each AccountNumber*/

create table transactions
	(
	 accno int,
	 transaction_time datetime,
	 transaction_id int,
	 balance int
	 );

	 insert into transactions values(550,'2020-05-12 05:29:44.120',1001,2000);
	 insert into transactions values(550,'2020-05-15 10:29:25.630',1002,8000);
	 insert into transactions values(460,'2020-03-15 11:29:23.620',1003,9000);
	 insert into transactions values(460,'2020-04-30 11:29:57.320',1004,7000);
         insert into transactions values(460,'2020-04-30 12:32:44.223',1005,5000);
	 insert into transactions values(640,'2020-02-18 06:29:34.420',1006,5000);
	 insert into transactions values(640,'2020-02-18 06:29:37.120',1007,9000);


	select * from transactions;
    
with cte as(select
accno
,max(transaction_time) as latest_transaction
from 
transactions
group by 1)
select transactions.accno
,transaction_id
,balance
,latest_transaction
from transactions inner join cte
on transactions.transaction_time = cte.latest_transaction;

/*Input :- SalesTable has four columns  namely  ID, Product , SalesYear and QuantitySold

Problem Statements :- Write SQL to get the total Sales in year 1998,1999 and 2000 for all the products as shown below.*/

Create Table Sales (
ID int,
Product Varchar(25),
SalesYear Int,
QuantitySold Int);

Insert into Sales Values(1,'Laptop',1998,2500);
Insert into Sales Values(2,'Laptop',1999,3600);
Insert into Sales Values(3,'Laptop',2000,4200);
Insert into Sales Values(4,'Keyboard',1998,2300);
Insert into Sales Values(5,'Keyboard',1999,4800);
Insert into Sales Values(6,'Keyboard',2000,5000);
Insert into Sales Values(7,'Mouse',1998,6000);
Insert into Sales Values(8,'Mouse',1999,3400);
Insert into Sales Values(9,'Mouse',2000,4600);

select * from Sales;

with cte as (select
SalesYear
,sum(QuantitySold) as SalesPerYear
from 
Sales
group by 1),
cte2 as(
select 
'TotalSales' as TotalSales
,coalesce( (case when SalesYear = 1998 then SalesPerYear end),0) as `1998`
,coalesce( case when SalesYear = 1999 then SalesPerYear end,0)  as `1999`
,coalesce( case when SalesYear = 2000 then SalesPerYear end,0)  as `2000`
from cte)
select TotalSales
,max(`1998`) as `1998`
,max(`1999`) as `1999`
,max(`2000`) as `2000`
from cte2;

/* how to calculate running total with SQL. */
Create Table Inventory(
ProdName Varchar(20),
ProductCode Varchar(15),
Quantity int,
InventoryDate Date);

Insert Into Inventory values('Keyboard','K1001',20,'2020-03-01');
Insert Into Inventory values('Keyboard','K1001',30,'2020-03-02');
Insert Into Inventory values('Keyboard','K1001',10,'2020-03-03');
Insert Into Inventory values('Keyboard','K1001',40,'2020-03-04');
Insert Into Inventory values('Laptop','L1002',100,'2020-03-01');
Insert Into Inventory values('Laptop','L1002',60,'2020-03-02');
Insert Into Inventory values('Laptop','L1002',40,'2020-03-03');
Insert Into Inventory values('Monitor','M5005',30,'2020-03-01');
Insert Into Inventory values('Monitor','M5005',20,'2020-03-02');

select * from Inventory;
select
*
,sum(quantity) over(partition by ProdName order by InventoryDate) as running_total
from Inventory;

Create Table Account_Tbl(
TranDate DateTime,
TranID Varchar(20),
TranType Varchar(10),
Amount Float);

INSERT test.Account_Tbl (TranDate, TranID, TranType, Amount) VALUES ('2020-05-12T05:29:44.120', 'A10001','Credit', 50000);
INSERT test.Account_Tbl (TranDate, TranID, TranType, Amount) VALUES ('2020-05-13T10:30:20.100', 'B10001','Debit', 10000);
INSERT test.Account_Tbl (TranDate, TranID, TranType, Amount) VALUES ('2020-05-13T11:27:50.130', 'B10002','Credit', 20000);
INSERT test.Account_Tbl (TranDate, TranID, TranType, Amount) VALUES ('2020-05-14T08:35:30.123', 'C10001','Debit', 5000);
INSERT test.Account_Tbl (TranDate, TranID, TranType, Amount) VALUES ('2020-05-14T09:43:51.100', 'C10002','Debit', 5000);
INSERT test.Account_Tbl (TranDate, TranID, TranType, Amount) VALUES ('2020-05-15T05:51:11.117', 'D10001','Credit', 30000);

select * 
,sum(case when TranType = 'Credit' then Amount
else Amount*-1 end) over(order by TranDate) as Net_Balance
from
Account_Tbl;

/*Input :- StudentInfo Table has four columns  namely StudentName, English, Maths and Science

Problem Statements :- Write SQL to turn the columns English, Maths and Science into rows. It should display Marks for each student for each subjects as shown below
*/
Create Table studentinfo(
studentname Varchar(20),
english int,
maths int,
science int);

insert into studentinfo values ('David',85,90,88);
insert into studentinfo values ('John',75,85,80);
insert into studentinfo values ('Tom',83,80,92);


select * from studentinfo;

Select Studentname,'English' as English,English as Marks from studentinfo
UNION ALL 
Select StudentName,'Math' as maths,maths from studentinfo
UNION ALL
Select Studentname,'Science' as Science ,science from studentinfo;
/*Input :- Trade_Tbl has five columns  namely  Trade_ID, Trade_Timestamp, Trade_Stock, Quantity and Price

Problem Statements :- Write SQL to find all couples of trade for same stock that happened in the range of 10 seconds and having price difference by more than 10 %. Output result should also list the percentage of price difference between the 2 trade*/

Create Table Trade_tbl(
TRADE_ID varchar(20),
Trade_Timestamp time,
Trade_Stock varchar(20),
Quantity int,
Price Float
);

Insert into Trade_tbl Values('TRADE1','10:01:05','ITJunction4All',100,20);
Insert into Trade_tbl Values('TRADE2','10:01:06','ITJunction4All',20,15);
Insert into Trade_tbl Values('TRADE3','10:01:08','ITJunction4All',150,30);
Insert into Trade_tbl Values('TRADE4','10:01:09','ITJunction4All',300,32);
Insert into Trade_tbl Values('TRADE5','10:10:00','ITJunction4All',-100,19);
Insert into Trade_tbl Values('TRADE6','10:10:01','ITJunction4All',-300,19);


select * from Trade_tbl;

with cte as (select
a.trade_id as First_Trade
,b.trade_id as Second_Trade
,timestampdiff(second,b.Trade_Timestamp,a.Trade_Timestamp) as time_diff
,abs(b.price - a.price)/a.price as perc
,abs(b.price - a.price) as diff
from trade_tbl as a, trade_tbl as b
where a.trade_id > b.trade_id)
select
*
from cte
where time_diff <= 10
and perc>=0.01
;


/*Input :- BalanceTbl has two columns  namely  Balance and Dates.

Problem Statements :- Write SQL to derive Start_Date and End_Date column when there is continuous amount in Balance column as shown below.*/


Create Table BalanceTbl(
Balance int,
Dates Date
);
Insert into BalanceTbl Values(26000,'2020-01-01');
Insert into BalanceTbl Values(26000,'2020-01-02');
Insert into BalanceTbl Values(26000,'2020-01-03');
Insert into BalanceTbl Values(30000,'2020-01-04');
Insert into BalanceTbl Values(30000,'2020-01-05');
Insert into BalanceTbl Values(26000,'2020-01-06');
Insert into BalanceTbl Values(26000,'2020-01-07');
Insert into BalanceTbl Values(32000,'2020-01-08');
Insert into BalanceTbl Values(31000,'2020-01-09');

select *
from BalanceTbl;

with cte as(
select
*
,case when balance = lag(balance) over(order by dates) then 0 else 1 end as stat
from BalanceTbl),
cte2 as(
select
*
,sum(stat) over(order by Dates) as run_totl
from cte)
select
Balance
,max(Dates) as max_date
,min(Dates) as min_date
 from cte2
 group by run_totl
;

/*Input :- There are two table. First table name is Sales_Table. Second Table name is ExchangeRate_Table. As and when exchange rate changes, a new row is inserted in the ExchangeRate table with a new effective start date.

Problem Statements :- Write SQL to get Total  sales amount in USD for each sales date as shown below :-*/
Create Table Sales_Table(
Sales_Date Date,
Sales_Amount Bigint,
Currency Varchar(10)
);

INSERT INTO Sales_Table Values ('2020-01-01',500,'INR');
INSERT INTO Sales_Table Values ('2020-01-01',100,'GBP');
INSERT INTO Sales_Table Values ('2020-01-02',1000,'INR');
INSERT INTO Sales_Table Values ('2020-01-02',500,'GBP');
INSERT INTO Sales_Table Values ('2020-01-03',500,'INR');
INSERT INTO Sales_Table Values ('2020-01-17',200,'GBP');

CREATE TABLE test.ExchangeRate_Table(
 Source_Currency varchar(10) ,
 Target_Currency varchar(10),
 Exchange_Rate float ,
 Effective_Start_Date date 
) 
;
INSERT test.ExchangeRate_Table VALUES ('INR','USD', 0.014,'2019-12-31');
INSERT test.ExchangeRate_Table VALUES ('INR','USD', 0.015,'2020-01-02');
INSERT test.ExchangeRate_Table VALUES ('GBP','USD', 1.32, '2019-12-20');
INSERT test.ExchangeRate_Table VALUES ('GBP','USD', 1.3, '2020-01-01' );
INSERT test.ExchangeRate_Table VALUES ('GBP','USD', 1.35, '2020-01-16');

select * from ExchangeRate_Table;
select * from Sales_Table;
with cte as (
select
a.*
,b.*
,round(a.Sales_Amount * b.Exchange_Rate,2) as effective_price
from Sales_Table a
left join ExchangeRate_Table b
on a.Sales_Date >= b.Effective_Start_Date
and a.Currency = b.Source_Currency),
cte2 as(
select
Sales_Date
,case when effective_start_date = max(effective_start_date) over(partition by Sales_Date,Currency) then effective_price else 0 end as final_price
from cte)
select 
Sales_Date
,sum(final_price) as Total_amt_USD
from cte2
group by 1
;

/*Input :- Travel_Table has three columns namely Source, Destination and Distance. 

Problem Statements :- Write SQL to get unique combination of  two columns Source and Destination irrespective of order of columns as shown below :-
*/

Create Table Travel_Table(
Start_Location Varchar(30),
End_Location Varchar(30),
Distance int);

Insert into Travel_Table Values('Delhi','Pune',1400);
Insert into Travel_Table Values('Pune','Delhi',1400);
Insert into Travel_Table Values('Bangalore','Chennai',350);
Insert into Travel_Table Values('Mumbai','Ahmedabad',500);
Insert into Travel_Table Values('Chennai','Bangalore',350);
Insert into Travel_Table Values('Patna','Ranchi',300);

select distinct
case when start_location > end_location  then end_location else start_location end as source,
case when start_location > end_location  then start_location else end_location end as dest,
distance
from test.Travel_Table;

/*
Input :- Sample Table has ID column which is not continuous value starting from 1 to 20
Problem Statement :-  Write a SQL to find the missing ID  From sample Table*/
Create Table Sample_Table(
ID int);

Insert into Sample_Table Values (1),(4),(7),(9),(12),(14),(16),(17),(20);

select * from sample_table;

with recursive base as(
/*Anchor part */
	select 1 as counter 
    UNION ALL
/*Recursive part */
    select  counter+1  as counter 
    from  base where  counter+ 1 <= (select max(ID) from sample_table)
)
select * from base b
where counter not in (select * from sample_table);

/*
Input :- Emp_Detail Table four columns namely EmpName , Age, Salary and Department
Problem Statement :-  Write a SQL to find Top 2 records from each department 
*/
Create table Emp_Detail
(
EmpName Varchar(25),
Age int,
Salary Bigint,
Department Varchar(20)
);

Insert into Emp_Detail Values('James',25,25000,'Admin');
Insert into Emp_Detail Values('Robert',33,39000,'Admin');
Insert into Emp_Detail Values('Richard',41,48000,'Admin');
Insert into Emp_Detail Values('Thomas',28,30000,'Admin');
Insert into Emp_Detail Values('Tom',40,55000,'Finance');
Insert into Emp_Detail Values('Donald',35,38000,'Finance');
Insert into Emp_Detail Values('Sara',32,44000,'Finance');
Insert into Emp_Detail Values('Mike',28,25000,'HR');
Insert into Emp_Detail Values('John',35,45000,'HR');
Insert into Emp_Detail Values('Mary',23,30000,'HR');
Insert into Emp_Detail Values('David',32,43000,'HR');

select * from Emp_Detail;
with cte as (select * 
,row_number() over(partition by Department order by salary desc) as row_num
from Emp_Detail)
select * from cte
where row_num <=2;


/*Input :- Phone_Log Table has three columns namely Source_Phone_Nbr,  Destination_Phone_Nbr and Call_Start_DateTime. This table records all phone numbers that we dial in a given day.

Problem Statement :-  Write a SQL to display the Source_Phone_Nbr and a flag where the flag needs to be set to ‘Y’ if first called number and last called number are the same and ‘N’ if first called number and last called number are different*/
Create Table Phone_Log(
Source_Phone_Nbr Bigint,
Destination_Phone_Nbr Bigint,
Call_Start_DateTime Datetime) ;

Insert into Phone_Log Values (2345,6789,'2012-07-01 10:00');
Insert into Phone_Log Values (2345,1234,'2012-07-01 11:00');
Insert into Phone_Log Values (2345,4567,'2012-07-01 12:00');
Insert into Phone_Log Values (2345,4567,'2012-07-01 13:00');
Insert into Phone_Log Values (2345,6789,'2012-07-01 15:00');
Insert into Phone_Log Values (3311,7890,'2012-07-01 10:00');
Insert into Phone_Log Values (3311,6543,'2012-07-01 12:00');
Insert into Phone_Log Values (3311,1234,'2012-07-01 13:00');

select * from phone_log;

with cte as(
select 
*
,row_number() over(partition by Source_Phone_Nbr order by Call_Start_DateTime) as row_num
from
phone_log),
cte2 as(
select
Source_Phone_Nbr
,case when row_num = max(row_num) over(partition by Source_Phone_Nbr) then Destination_Phone_Nbr end as max_Destination_Phone_Nbr
,case when row_num = min(row_num) over(partition by Source_Phone_Nbr) then Destination_Phone_Nbr end as min_Destination_Phone_Nbr
from cte),
cte3 as(
select 
Source_Phone_Nbr
,max(max_Destination_Phone_Nbr) as max_Destination_Phone_Nbr
,min(min_Destination_Phone_Nbr) as min_Destination_Phone_Nbr
from cte2
group by 1)
select 
Source_Phone_Nbr
,case when max_Destination_Phone_Nbr = min_Destination_Phone_Nbr then 'Y' else 'N' end as status
from cte3 ;

Create Table Sample_1
(
X Bigint,
Y Bigint,
Z Bigint);

Insert into Sample_1 Values (200,400,1);
Insert into Sample_1 Values (200,400,2);
Insert into Sample_1 Values (200,400,3);
Insert into Sample_1 Values (10000,60000,1);
Insert into Sample_1 Values (500,600,1);
Insert into Sample_1 Values (500,600,2);
Insert into Sample_1 Values (20000,80000,1);

select * from sample_1;
select
*
from sample_1
having length(X) <=3 and length(Y)<=3;

with cte as (
select
*
,count(z) over(partition by x,y) as num
from sample_1)
select * 
from cte
where num >1;

/*Input :- Employee Table has three columns namely EmployeeID,  EmployeeName and ManagerID
Problem Statement :- Write a SQL query to get the output as shown in the Output table*/
Create Table Employee_1(
EmployeeID Varchar(20),
EmployeeName Varchar(20),
ManagerID varchar(20));

Insert Into Employee_1 Values(100,'Mark',103);
Insert Into Employee_1 Values(101,'John',104);
Insert Into Employee_1 Values(102,'Maria',103);
Insert Into Employee_1 Values(103,'Tom',NULL);
Insert Into Employee_1 Values(104, 'David',103);

select * from Employee_1;


select a.EmployeeId
,a.EmployeeName
,coalesce(b.EmployeeName, 'Boss') as Manager_Name 
from 
Employee_1 a
left join Employee_1 b
on a.ManagerID= b.EmployeeID;
/*Input :- Sales Table has three columns namely Id,  Product and Sales
Problem Statement :- Write a SQL query to get the output as shown in the Output tables*/
Create Table Sales1
(
Id int,
Product Varchar(20),
Sales Bigint
);

Insert into Sales1 values(1001,'Keyboard',20);
Insert into Sales1 values(1002,'Keyboard',25);
Insert into Sales1 values(1003,'Laptop',30);
Insert into Sales1 values(1004,'Laptop',35);
Insert into Sales1 values(1005,'Laptop',40);
Insert into Sales1 values(1006,'Monitor',45);
Insert into Sales1 values(1007,'WebCam',50);
Insert into Sales1 values(1008,'WebCam',55);

select * from Sales1;
with cte as (select
id
,product
,Sales
,row_number() over(partition by Product) as row_num
from 
sales1),
cte2 as(
select 
product
,Sales
from cte
where 
row_num = 1)
select
a.id
,a.product
,b.Sales
from
cte a left join cte2 b
on a.Product = b.Product;


select
id
,product
,sum(Sales) over(partition by Product order by id)  as run_tol
from sales1;
/*Input :- StudentInfo Table has three columns namely StudentName, Subjects and Marks
Problem Statement :- Write a SQL query to get the output as shown in the Output table*/
Create Table StudentInfo_1
(
StudentName Varchar(30),
Subjects Varchar(30),
Marks Bigint
);

insert into StudentInfo_1 Values ('David', 'English', 85);
insert into StudentInfo_1 Values ('David', 'Maths', 90);
insert into StudentInfo_1 Values ('David', 'Science', 88);
insert into StudentInfo_1 Values ('John', 'English', 75);
insert into StudentInfo_1 Values ('John', 'Maths', 85);
insert into StudentInfo_1 Values ('John', 'Science', 80);
insert into StudentInfo_1 Values ('Tom', 'English', 83);
insert into StudentInfo_1 Values ('Tom', 'Maths', 80);
insert into StudentInfo_1 Values ('Tom', 'Science', 92);

select * from StudentInfo_1;

select 
StudentName
,sum(case when Subjects = 'English' then Marks end) as English
,sum(case when Subjects = 'Science' then Marks end) as Science
,sum(case when Subjects = 'Maths' then Marks end) as Maths
from StudentInfo_1
group by 1
;

/* Input :- Employee Table has four columns namely EmpName,  DeptName, DeptNo and Salary
Problem Statement :- Write a SQL query to get the output as shown in the Output tables
*/
Create Table Employee_2(
EmpName Varchar(30),
DeptName Varchar(25),
DeptNo Bigint,
Salary Bigint);

Insert into Employee_2 Values('Mark','HR',101,30000);
Insert into Employee_2 Values('John','Accountant',101,20000);
Insert into Employee_2 Values('Smith','Analyst',101,25000);
Insert into Employee_2 Values('Donald','HR',201,40000);
Insert into Employee_2 Values('James','Analyst',201,22000);
Insert into Employee_2 Values('Maria','Analyst',201,38000);
Insert into Employee_2 Values('David','Manager',201,33000);
Insert into Employee_2 Values('Martin','Analyst',301,22000);
Insert into Employee_2 Values('Robert','Analyst',301,56000);
Insert into Employee_2 Values('Michael','Manager',301,34000);
Insert into Employee_2 Values('Robert','Accountant',301,37000);
Insert into Employee_2 Values('Michael','Analyst',301,28000);

select * from Employee_2;

with cte as(
select
*
,case when Salary = max(Salary) over(partition by DeptNo) then 1 else 0 end as max_sal_dep
,case when Salary = min(Salary) over(partition by DeptNo) then 1 else 0 end as min_sal_dep
from Employee_2)
select
EmpName
,DeptName
,DeptNo
,Salary
from cte where
 max_sal_dep+min_sal_dep =1
 order by DeptNo,Salary;
 
with recursive fancy_art as (
select "INTERVIEW" as word, length("INTERVIEW") as len_word 
UNION ALL
select substr(word,1,len_word-1) as word , len_word-1 as len_word from fancy_art
where len_word > 1
)
select word from fancy_art;

/*Problem Statement :- Order Status Table has three columns namely Quote_id, Order_id and Order_Status
When all Orders are in delivered status then Quote status should be ‘Complete’.                                             
When one or more Orders in delivered status then “ In Delivery”.                                                                      When One or  more in Submitted status then “Awaiting for Submission” Else “Awaiting for Entry” by default

Note :- Order Priority should be Delivered, Submitted and Created
 If one order is in delivered and other one is in Submitted then Quote_Status should be “In Delivery” 
Similarly if one order is in Submitted and others in Created then the Quote_Status should be “Awaiting for Submission “ */
create table OrderStatus
(
Quote_Id varchar(5),
Order_Id varchar(5),
Order_Status Varchar(20)
);

Insert into OrderStatus Values ('A','A1','Delivered') ;
Insert into OrderStatus Values ('A','A2','Delivered') ;
Insert into OrderStatus Values ('A','A3','Delivered') ;
Insert into OrderStatus Values ('B','B1','Submitted') ;
Insert into OrderStatus Values ('B','B2','Delivered') ;
Insert into OrderStatus Values ('B','B3','Created') ;
Insert into OrderStatus Values ('C','C1','Submitted'); 
Insert into OrderStatus Values ('C','C2','Created') ;
Insert into OrderStatus Values ('C','C3','Submitted'); 
Insert into OrderStatus Values ('D','D1','Created') ;


select * from OrderStatus;
with cte as (
select 
Quote_Id
,sum(case when Order_Status = 'Delivered' then 1 else 0 end ) as Delivered
,sum(case when Order_Status = 'Submitted' then 1 else 0 end ) as Submitted
,sum(case when Order_Status = 'Created' then 1 else 0 end ) as Created
from
OrderStatus
group by 1)
select
Quote_Id
,case when Delivered = 3 then 'Complete' 
	when Delivered <3 and  Delivered !=0 then 'In Delivery'
    when Submitted <= 3 and  Submitted !=0 then 'Awaiting for Submission'
    else 'Awaiting for Entry' end as Quote_Status
from cte;
/*Problem Statement :- Employees Table has five columns namely Employee_no, Birth_date , first_name , last_name and Joining_date

(1.)As a convention the values in first_name and last_name should always be in uppercase. But due to data entry issues some records may not adhere to this convention. Write a query to find all such records where first_name is not in upper case.
(2.) For some records the first_name column has full name and last_name is blank.  Write a SQL query to update it correctly,
(3.) Calculate tenure of employees as of 30th Jun 2017. Prepare following above sample report :
(4.) List all the employees whose work anniversary is same as their birthday date.
(5.) Find the Youngest (minimum age) employee with tenure more than 5 years as of 30th June 2017.*/
Create Table Employees
(
Employee_no BigInt,
Birth_date Date,
First_name Varchar(50),
Last_name Varchar(50),
Joining_date Date
);

INSERT INTO Employees Values(1001,CAST('1988-08-15' AS Date),'ADAM','WAUGH', CAST('2013-04-12' AS Date));
INSERT INTO Employees Values(1002,CAST('1990-05-10' AS Date),'Mark','Jennifer', CAST('2010-06-25' AS Date));
INSERT INTO Employees Values(1003,CAST('1992-02-07' AS Date),'JOHN','Waugh', CAST('2016-02-07' AS Date));
INSERT INTO Employees Values(1004,CAST('1985-06-12' AS Date),'SOPHIA TRUMP','', CAST('2016-02-15' AS Date));
INSERT INTO Employees Values(1005,CAST('1995-03-25' AS Date),'Maria','Gracia', CAST('2011-04-09' AS Date));
INSERT INTO Employees Values(1006,CAST('1994-06-23' AS Date),'ROBERT','PATRICA', CAST('2015-06-23' AS Date));
INSERT INTO Employees Values(1007,CAST('1993-04-05' AS Date),'MIKE JOHNSON','', CAST('2014-03-09' AS Date));
INSERT INTO Employees Values(1008,CAST('1989-04-05' AS Date),'JAMES','OLIVER', CAST('2017-01-15' AS Date));

select * from Employees;
/* Detect upper case */
select
* 
from 
Employees
where CAST(First_Name as binary) <> upper(First_Name);

select
*
,case 
when trim(last_name) = '' then SUBSTRING_INDEX(First_Name,' ',1) else first_name end as first_name
,case
when trim(last_name) = '' then SUBSTRING_INDEX(First_Name,' ',-1) else last_name end as last_name
,abs(datediff(joining_date,'2017-06-30')/365) as tenure
,abs(datediff(birth_date,'2017-06-30')/365) as age
from 
Employees
;

select
*
from 
employees
where month(Birth_date) = month(joining_date)
and day(Birth_date) = day(Birth_date);


with cte as 
(select
*
,case 
when trim(last_name) = '' then SUBSTRING_INDEX(First_Name,' ',1) else first_name end as first_names
,case
when trim(last_name) = '' then SUBSTRING_INDEX(First_Name,' ',-1) else last_name end as last_names
,abs(datediff(joining_date,'2017-06-30')/365) as tenure
,abs(datediff(birth_date,'2017-06-30')/365) as age
from 
Employees
)
select * from cte
where tenure >5
order by age
limit 1;

/*
Problem Statement :- Ruby is a teacher in a school and she has created a table called SeatArrangement which stores Student’s name and corresponding seat ids. Column id is continuous increment. Now Ruby wants to change the seats for adjacent seats. Write a SQL query to output the result for Ruby. */
Create Table SeatArrangement (
ID int,
StudentName Varchar(30)
);

Insert into SeatArrangement Values (1,'Emma');
Insert into SeatArrangement Values (2,'John');
Insert into SeatArrangement Values (3,'Sophia');
Insert into SeatArrangement Values (4,'Donald');
Insert into SeatArrangement Values (5,'Tom');

select * from SeatArrangement;

with cte as(
select  
*,
case when id%2 != 0 then lead(StudentName) over() else lag(StudentName) over() 
end as next_Student
from SeatArrangement)
select
coalesce(next_student,studentname) as studentname
from cte;
/*Problem Statement :- SalesInfo Table has three columns namely Continents, Country and Sales. Write a SQL query to get the aggregate sum  of sales  country wise and display only those which are maximum in each continents as shown in the table.
*/

Create Table SalesInfo(
Continents varchar(30),
Country varchar(30),
Sales Bigint
);

Insert into SalesInfo Values('Asia','India',50000);
Insert into SalesInfo Values('Asia','India',70000);
Insert into SalesInfo Values('Asia','India',60000);
Insert into SalesInfo Values('Asia','Japan',10000);
Insert into SalesInfo Values('Asia','Japan',20000);
Insert into SalesInfo Values('Asia','Japan',40000);
Insert into SalesInfo Values('Asia','Thailand',20000);
Insert into SalesInfo Values('Asia','Thailand',30000);
Insert into SalesInfo Values('Asia','Thailand',40000);
Insert into SalesInfo Values('Europe','Denmark',40000);
Insert into SalesInfo Values('Europe','Denmark',60000);
Insert into SalesInfo Values('Europe','Denmark',10000);
Insert into SalesInfo Values('Europe','France',60000);
Insert into SalesInfo Values('Europe','France',30000);
Insert into SalesInfo Values('Europe','France',40000);


select * from SalesInfo;

with cte as(
select
Continents
,Country
,sum(Sales) as sum_sales
from SalesInfo
group by 1,2),
cte2 as(
select
Continents
,Country
,sum_sales
,rank() over(partition by Continents order by sum_sales desc) as ranks
from cte)
select
*
from cte2
where ranks = 1;

/*Problem Statement :- Stadium Table has three columns namely Id, Visit_Date and No_Of_People. Write a SQL query to display the records with three or more rows with consecutive id’s and the number of people is greater than or equal to 100. Return the result table ordered by Visit_Date as shown in the below table.*/
Create Table Stadium(
id int,
Visit_Date Date,
No_Of_People Bigint);

Insert into Stadium Values(1,'2018-01-01',10);
Insert into Stadium Values(2,'2018-01-02',110);
Insert into Stadium Values(3,'2018-01-03',150);
Insert into Stadium Values(4,'2018-01-04',98);
Insert into Stadium Values(5,'2018-01-05',140);
Insert into Stadium Values(6,'2018-01-06',1450);
Insert into Stadium Values(7,'2018-01-07',199);
Insert into Stadium Values(8,'2018-01-09',125);
Insert into Stadium Values(9,'2018-01-10',88);
with cte as(
select *
,case when No_of_people >=100 then 1 else 0 end as status
 from Stadium),
 cte2 as(
 select *,
 sum(status) over(order by id) as status_sum
 from cte)
 select
 * 
,case when status_sum < lead(status_sum) over(order by id)
 and (lead(status_sum,2) over(order by id) < lead(status_sum,3) over(order by id)
 or lead(status_sum,3) over(order by id) < lead(status_sum,4) over(order by id))
 then 1 else 0 end as gg
from cte2
where status>0
;


Create Table Emp_Table (
SerialNo int,
Name Varchar(30),
Month_ID int,
Amount Bigint );

Insert into Emp_Table Values  (1,'JOHN',1,1000);
Insert into Emp_Table Values  (1,'JOHN',2,3000);
Insert into Emp_Table Values  (8,'DAVID',3,4000);
Insert into Emp_Table Values  (8,'DAVID',5,2000);

Create Table Month_Table(
Month_ID int,
Month Varchar(30));

Insert into Month_Table Values (1, 'JAN');
Insert into Month_Table Values (2, 'FEB');
Insert into Month_Table Values (3, 'MAR');
Insert into Month_Table Values (4, 'APR');
Insert into Month_Table Values (5, 'MAY');
Insert into Month_Table Values (6, 'JUN');
Insert into Month_Table Values (7, 'JUL');
Insert into Month_Table Values (8, 'AUG');
Insert into Month_Table Values (9, 'SEP');
Insert into Month_Table Values (10, 'OCT');
Insert into Month_Table Values (11, 'NOV');
Insert into Month_Table Values (12, 'DEC');

select * from Month_Table;

with recursive base as(
/*Anchor part */
	select Serialno, Name, 1 as Month_id 
    from  Emp_Table 
    UNION
/*Recursive part */
    select Serialno, Name, Month_id+1  as Month_id 
    from  base where  Month_id+1 <= 10
),
cte2 as(
select b.SerialNo, b.Name,  b.Month_id,e.Amount from base b 
left join Emp_Table e
on b.month_id = e.month_id
and b.Name = e.Name
order by b.Name desc,b.month_id)
select a.*,b.Month from cte2 a
inner join Month_Table b on a.month_id = b.month_id
order by b.Name desc,b.month_id;


/*Problem Statement :-   ITEM Table  has two columns namely ItemName and TotalQuantity. Write a SQL query  to duplicate the rows based on total count in output table by adding two new columns ID and CatID*/
Create Table Item(
ItemName Varchar(30),
TotalQuantity int
);
Insert into Item Values('Apple',2);
Insert into Item Values('Orange',3);

select * from Item;

with recursive cte as (
select ItemName
,TotalQuantity
,1 as catid from item
union
select ItemName,
TotalQuantity,
catid+1 as catid
from cte where catid+1 <= TotalQuantity)
select *,
row_number() over(order by ItemName) as Id from cte
order by ItemName,catid;

/*Problem Statement :-   ABC Bank is trying to find their customers transaction mode. Customers are using different apps such as Gpay, PhonePe, Paytm etc along with offline transactions. Bank wants to know which mode/app is used for highest amount of transactions in each location.
Write a SQL query to find the app/mode and the count for highest amount of transactions in each location

Consider below points while fetching the record :-
* Columns to be fetched – App, Count
* Count – Number of times the app is used for the highest amount of transaction for each location. 
* If the App column is NULL, it means the customer has paid the amount through Offline  mode        
* The first letter of the app name should be in uppercase letter and the rest followed by the lowercase
* The Count should be in descending order
*/
Create Table Customer(
Customer_id  int,
Cus_name  Varchar(30),
Age  int,
Gender  Varchar(10),
App  Varchar(30) );

Insert into Customer Values(1,'Amelia',23,'Female','gpay');
Insert into Customer Values(2,'William',16,'Male','phonepay');
Insert into Customer Values(3,'James',18,'Male','paytm');
Insert into Customer Values(4,'David',24,'Male','paytm');
Insert into Customer Values(5,'Ava',21,'Female','gpay');
Insert into Customer Values(6,'Sophia',31,'Female','paytm');
Insert into Customer Values(7,'Oliver',23,'Male','gpay');
Insert into Customer Values(8,'Harry',29,'Male',NULL);
Insert into Customer Values(9,'Issac',16,'Male','gpay');
Insert into Customer Values(10,'Jack',22,'Male','phonepay');

Create Table Transaction_Tbls (
Loc_name Varchar(30),
Loc_id int,
Cus_id int,
Amount_paid Bigint,
Trans_id int);

Insert into Transaction_Tbls Values ('Florida',100,1,78899,1000);
Insert into Transaction_Tbls Values ('Florida',100,2,55678,1001);
Insert into Transaction_Tbls Values ('Florida',100,3,27788,1002);
Insert into Transaction_Tbls Values ('Florida',100,4,65886,1003);
Insert into Transaction_Tbls Values ('Alaska',101,5,57757,1004);
Insert into Transaction_Tbls Values ('Alaska',101,6,34676,1005);
Insert into Transaction_Tbls Values ('Alaska',101,7,66837,1006);
Insert into Transaction_Tbls Values ('Alaska',101,8,77633,1007);
Insert into Transaction_Tbls Values ('Texas',102,9,98766,1008);
Insert into Transaction_Tbls Values ('Texas',102,10,45335,1009);

with cte as (
select * from
Customer a inner join Transaction_Tbls b
on a.Customer_id = b.cus_id),
cte2 as(
select
Loc_name
,max(Amount_paid) as max_lcl_amt
from cte
group by Loc_name),
cte3 as(
select
coalesce(cte.App,'Offline') as App
,cte.Customer_id
,cte.Trans_id
from cte inner join cte2
on cte.Loc_name = cte2.loc_name
and cte.Amount_paid = cte2.max_lcl_amt)
select
CONCAT(UCASE(LEFT(App, 1)), SUBSTRING(App, 2)) as App 
,count(Trans_id) as Cnt
from cte3
group by 1
order by 2 desc
;

/*This question has been asked in Amazon interview.
Problem Statement : E commerce company is trying to identify returning active users.  A returning active user is a user that has made a second purchase within 7 days of any other of their purchases. Write a SQL query to display the list of UserId of these returning active users.*/
Create Table Transactions_Amazon (
Id int,
UserId int,
Item Varchar(20),
CreatedAt Date,
Revenue int
);

Insert into Transactions_Amazon Values (1,109,'milk','2020-03-03',123);	
Insert into Transactions_Amazon Values (2,103,'bread','2020-03-29',862);
Insert into Transactions_Amazon Values (3,128,'bread','2020-03-04',112);
Insert into Transactions_Amazon Values (4,128,'biscuit','2020-03-24',160);
Insert into Transactions_Amazon Values (5,100,'banana','2020-03-18',599);
Insert into Transactions_Amazon Values (6,103,'milk','2020-03-31',290);
Insert into Transactions_Amazon Values (7,102,'bread','2020-03-25',325);
Insert into Transactions_Amazon Values (8,109,'bread','2020-03-22',432);
Insert into Transactions_Amazon Values (9,101,'milk','2020-03-01',449);
Insert into Transactions_Amazon Values (10,100,'milk','2020-03-29',410);
Insert into Transactions_Amazon Values (11,129,'milk','2020-03-02',771);
Insert into Transactions_Amazon Values (12,104,'biscuit','2020-03-31',957);
Insert into Transactions_Amazon Values (13,110,'bread','2020-03-13',210);
Insert into Transactions_Amazon Values (14,128,'milk','2020-03-28',498);
Insert into Transactions_Amazon Values (15,109,'bread','2020-03-02',362);
Insert into Transactions_Amazon Values (16,110,'bread','2020-03-13',262);
Insert into Transactions_Amazon Values (17,105,'bread','2020-03-21',562);
Insert into Transactions_Amazon Values (18,101,'milk','2020-03-26',740);
Insert into Transactions_Amazon Values (19,100,'banana','2020-03-13',175);
Insert into Transactions_Amazon Values (20,105,'banana','2020-03-05',815);
Insert into Transactions_Amazon Values (21,129,'milk','2020-03-02',489);
Insert into Transactions_Amazon Values (22,105,'banana','2020-03-09',972);
Insert into Transactions_Amazon Values (23,107,'bread','2020-03-01',701);
Insert into Transactions_Amazon Values (24,100,'bread','2020-03-07',410);
Insert into Transactions_Amazon Values (25,110,'bread','2020-03-27',225);

with cte as(
select *,
abs(datediff(CreatedAt, lead(CreatedAt) over(partition by userid order by CreatedAt))) as date_from_last_purchase
 from Transactions_Amazon
order by UserId ,CreatedAt )
select
distinct(userId)
from cte where date_from_last_purchase <=7;

/*Problem Statement : A group of students participated in a course which has 4 subjects . In order to complete the course,  students must fulfill below criteria :-
   * Student should score at least 40 marks in each subject 
   * Student  must secure at least 50% marks overall (Assuming total 100)
Assuming 100 marks as the maximum achievable marks for a given subject, Write a SQL query to print the result in the below format:*/

drop table Exam_Score;
Create Table Exam_Score
(
StudentId int,
SubjectID int,
Marks int
);

Insert Into Exam_Score values(101,1,60);
Insert Into Exam_Score values(101,2,71);
Insert Into Exam_Score values(101,3,65);
Insert Into Exam_Score values(101,4,60);
Insert Into Exam_Score values(102,1,40);
Insert Into Exam_Score values(102,2,55);
Insert Into Exam_Score values(102,3,64);
Insert Into Exam_Score values(102,4,50);
Insert Into Exam_Score values(103,1,45);
Insert Into Exam_Score values(103,2,39);
Insert Into Exam_Score values(103,3,60);
Insert Into Exam_Score values(103,4,65);
Insert Into Exam_Score values(104,1,83);
Insert Into Exam_Score values(104,2,77);
Insert Into Exam_Score values(104,3,91);
Insert Into Exam_Score values(104,4,74);
Insert Into Exam_Score values(105,1,83);
Insert Into Exam_Score values(105,2,77);
Insert Into Exam_Score values(105,4,74);

select * from Exam_Score;
with cte as (
select
StudentID
,case when SubjectID = 1 then Marks end as Subject1
,case when SubjectID = 2 then Marks end as Subject2
,case when SubjectID = 3 then Marks end as Subject3
,case when SubjectID = 4 then Marks end as Subject4
from
Exam_Score),
cte2 as(
select
StudentID
,coalesce(max(Subject1),0) as Subject1
,coalesce(max(Subject2),0) as Subject2
,coalesce(max(Subject3),0) as Subject3
,coalesce(max(Subject4),0) as Subject4
from cte
group by 1)
select 
*
,Subject1+Subject2+Subject3+Subject4 as TotalMarks
,case when Subject1>=40 and Subject2>=40 and Subject3>=40 and Subject4>=40 and ((Subject1+Subject2+Subject3+Subject4)/400 >= 0.5) then "Pass" else "Fail" end as Result
from cte2;

/*Hirerchy*/
Create Table Employee_Table(
EmployeeID int,
EmployeeName Varchar(30),
DepartmentID int,
ManagerID int);


Insert into Employee_Table Values(1001,'James Clarke',13,1003);
Insert into Employee_Table Values(1002,'Robert Williams',12,1005);
Insert into Employee_Table Values(1003,'Henry Brown',11,1004);
Insert into Employee_Table Values(1004,'David Wilson',13,1006);
Insert into Employee_Table Values(1005,'Michael Lee',11,1007);
Insert into Employee_Table Values(1006,'Daniel Jones',Null,1007);
Insert into Employee_Table Values(1007,'Mark Smith',14,Null);


select * from Employee_Table;
with recursive cte as(
select
EmployeeID
,EmployeeName
,DepartmentID
,ManagerID
, 0 as EmployeeLevel
from Employee_Table
where ManagerID is null
union 
select a.EmployeeID
,a.EmployeeName
,a.DepartmentID
,a.ManagerID
, EmployeeLevel+1
 from Employee_Table a inner join cte b on a.ManagerID= b.EmployeeID )
select * from cte
;
/*https://www.youtube.com/watch?v=N3ChrpDRcXY&ab_channel=kudvenkat*/	

/*Problem Statement :- For the 2021 academic year, students have appeared in the SSC exam. Write a SQL query to calculate the percentage of results using the best of the five rule i.e. You must take the top five grades for each student and calculate the percentage.
*/
create table SSC_Exam (
Id int,
English int,
Maths int,
Science int,
Geography int,
History int,
Sanskrit int);

Insert into SSC_Exam Values (1,85,99,92,86,86,99);
Insert into SSC_Exam Values (2,81,82,83,86,95,96);
Insert into SSC_Exam Values (3,76,55,76,76,56,76);
Insert into SSC_Exam Values (4,84,84,84,84,84,84);
Insert into SSC_Exam Values (5,83,99,45,88,75,90);


select * from SSC_Exam;

with unpivot as (
select
ID,
English as Marks,
'English' as Subject
from SSC_Exam
union 
select
ID,
Maths as Marks,
'Maths' as Subject
from SSC_Exam
union 
select
ID,
Science as Marks,
'Science' as Subject
from SSC_Exam
union 
select
ID,
Geography as Marks,
'Geography' as Subject
from SSC_Exam
union 
select
ID,
History as Marks,
'History' as Subject
from SSC_Exam
union 
select
ID,
Sanskrit as Marks,
'Sanskrit' as Subject
from SSC_Exam),
cte as(
select
*,
row_number() over(partition by ID order by Marks desc) as ordered_marks
from unpivot),
cte2 as(
select ID,
(sum(Marks)/500) *100 as pct
from cte
where ordered_marks <=5
group by 1)
select
SSC_Exam.Id,
English ,
Maths ,
Science ,
Geography ,
History ,
Sanskrit,
pct
from SSC_Exam
inner join cte2
on SSC_Exam.id = cte2.id
;

/*SQL Interview Questions and answers :
The Spending table keeps the logs of the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile application.
  Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.*/
  create table Spending 
(
User_id int,
Spend_date date,
Platform varchar(10),
Amount int
);

Insert into spending values(1,'2019-07-01','Mobile',100);
Insert into spending values(1,'2019-07-01','Desktop',100);
Insert into spending values(2,'2019-07-01','Mobile',100);
Insert into spending values(2,'2019-07-02','Mobile',100);
Insert into spending values(3,'2019-07-01','Desktop',100);
Insert into spending values(3,'2019-07-02','Desktop',100);

select * from spending;

with cte as(
select
User_Id
,Spend_date
,sum(case when Platform = 'Mobile' or Platform = 'Desktop' then 1 else 0 end) as total_dev
from spending
group by 2,1),
cte2 as(
select 
spending.User_Id
,spending.Spend_date
,spending.Platform
,spending.Amount
,cte.total_dev
from cte
inner join 
spending
on cte.user_id = spending.user_id
and cte.spend_date = spending.spend_date),
cte3 as(
select
*
,case when total_dev = 2 then 'Both' else Platform  end as Platform2
from cte2),
cte4 as(
select
Spend_date
,Platform2 as Platform
,sum(Amount) as Total_Amount
,count(user_id) as Total_users
from cte3
group by 1,2
order by 1,3),
cte5 as(
select 
Spend_date
,'Both' as Platform
,0 as Total_Amount
,0 as Total_User
from cte4
union
select * from cte4)
select Spend_date, Platform, max(Total_Amount) as Total_Amount, max(Total_User) as Total_User
from cte5 group by 1,2;
/*Problem Statement : Calls Table has three columns namely From_Id, To_Id and Duration . It contains duration of calls between From_Id and To_Id. Write a SQL query to report the number of calls and the total call duration between each pair of distinct persons (Person1,Person2) where Person1 is less than Person2. Return the result as shown in Output Table.*/
Create Table Calls
(
From_Id int,
To_Id int,
Duration int   
);
INSERT INTO Calls Values(1,2,59);
INSERT INTO Calls Values(2,1,11);
INSERT INTO Calls Values(1,3,20);
INSERT INTO Calls Values(3,4,100);
INSERT INTO Calls Values(3,4,200);
INSERT INTO Calls Values(3,4,200);
INSERT INTO Calls Values(4,3,499);
/* reverse duplicates*/
select * from Calls;
with cte as(
select
case when from_id>to_id then From_id else to_id end as Person_1
,case when from_id<to_id then From_id else to_id end as Person_2
, duration
from calls)
select 
person_1
,person_2
,sum(duration) as tot_dur
,count(1) as num_call
from cte
group by 1,2;

/*Problem Statement : Write a SQL query to output the names of those students whose best friends got higher salary package than Student.             */
Create Table Students_Tbl
(
Id int,
Student_Name Varchar(30)
);

Insert into Students_Tbl values(1,'Mark');
Insert into Students_Tbl values(2,'David');
Insert into Students_Tbl values(3,'John');
Insert into Students_Tbl values(4,'Albert');

Create Table Friends_Tbl(
Id int,
Friend_Id int
);

Insert into Friends_Tbl values(1,2);
Insert into Friends_Tbl values(2,3);
Insert into Friends_Tbl values(3,4);
Insert into Friends_Tbl values(4,1);

Create Table Package_Tbl
(Id int,
Salary Bigint );

Insert into Package_Tbl values(1,18);
Insert into Package_Tbl values(2,12);
Insert into Package_Tbl values(3,13);
Insert into Package_Tbl values(4,15);

with cte as(
select f.id,
f.friend_id,
s.Student_Name as student_name
from Friends_Tbl f
inner join Students_Tbl s
on f.id = s.id),
cte2 as(
select 
cte.*
,s.student_name as friend_name
from cte
inner join Students_Tbl s
on cte.friend_id = s.id),
cte3 as(
select cte2.*
, p.salary as student_pkg
from cte2
inner join package_tbl p
on cte2.id = p.id),
cte4 as
(select cte3.*
, p.salary as friend_pkg
from cte3
inner join package_tbl p
on cte3.friend_id = p.id)
select Student_name from cte4
where friend_pkg>student_pkg;

/*Problem Statement : Write a SQL query to calculate each user's average session time. 
A session is defined as the time difference between a page_load and page_exit.  Assume a user has only 1 session per day and if there are multiple of the same events on that day, consider only the latest page_load and earliest page_exit. Output the user_id and their average session time    */
Create table facebook_web_log
(
Userid int,
Time_stamp datetime,
Actions varchar(30)
);


INSERT INTO facebook_web_log values(0,'2019-04-25 13:30:15','page_load');
INSERT INTO facebook_web_log values(0,'2019-04-25 13:30:18','page_load');
INSERT INTO facebook_web_log values(0,'2019-04-25 13:30:40','scroll_down');
INSERT INTO facebook_web_log values(0,'2019-04-25 13:30:45','scroll_up');
INSERT INTO facebook_web_log values(0,'2019-04-25 13:31:10','scroll_down');
INSERT INTO facebook_web_log values(0,'2019-04-25 13:31:25','scroll_down');
INSERT INTO facebook_web_log values(0,'2019-04-25 13:31:40','page_exit');
INSERT INTO facebook_web_log values(1,'2019-04-25 13:40:00','page_load');
INSERT INTO facebook_web_log values(1,'2019-04-25 13:40:10','scroll_down');
INSERT INTO facebook_web_log values(1,'2019-04-25 13:40:15','scroll_down');
INSERT INTO facebook_web_log values(1,'2019-04-25 13:40:20','scroll_down');
INSERT INTO facebook_web_log values(1,'2019-04-25 13:40:25','scroll_down');
INSERT INTO facebook_web_log values(1,'2019-04-25 13:40:30','scroll_down');
INSERT INTO facebook_web_log values(1,'2019-04-25 13:40:35','page_exit');
INSERT INTO facebook_web_log values(2,'2019-04-25 13:41:21','page_load');
INSERT INTO facebook_web_log values(2,'2019-04-25 13:41:30','scroll_down');
INSERT INTO facebook_web_log values(2,'2019-04-25 13:41:35','scroll_down');
INSERT INTO facebook_web_log values(2,'2019-04-25 13:41:40','scroll_up');
INSERT INTO facebook_web_log values(1,'2019-04-26 11:15:00','page_load');
INSERT INTO facebook_web_log values(1,'2019-04-26 11:15:10','scroll_down');
INSERT INTO facebook_web_log values(1,'2019-04-26 11:15:20','scroll_down');
INSERT INTO facebook_web_log values(1,'2019-04-26 11:15:25','scroll_up');
INSERT INTO facebook_web_log values(1,'2019-04-26 11:15:35','page_exit');
INSERT INTO facebook_web_log values(0,'2019-04-28 14:30:15','page_load');
INSERT INTO facebook_web_log values(0,'2019-04-28 14:30:10','page_load');
INSERT INTO facebook_web_log values(0,'2019-04-28 13:30:40','scroll_down');
INSERT INTO facebook_web_log values(0,'2019-04-28 15:31:40','page_exit');

with cte as(
select
UserId
,case when (Actions = 'page_load') or (Actions = 'page_exit')
 then Date(Time_Stamp) end as Page_load_date
,case when Actions = 'page_load' then Time_Stamp end as Page_load
,case when Actions = 'page_exit' then Time_Stamp end as Page_exit
 from facebook_web_log
order by Userid),
cte2 as(
select
Page_load_date,
UserId,
coalesce(max(Page_load) ,0) as latest_Page_load,
coalesce(min(Page_exit),0) as earliest_Page_exit
from cte
group by 1,2)
select 
userid,
abs(avg(timestampdiff(second,earliest_Page_exit,latest_Page_load ))) as avg_diff
from cte2
where latest_Page_load !=0 and earliest_Page_exit !=0
group by 1
;

/*Problem Statement : 
Write a SQL query to remove all reversed number pairs from given table. Keep only one random pair .
Assumption:
1. There will not be same value for both A and B column.
2. There will not be same pair of numbers repeating in this table.                 
*/
Create Table Reverse_duplicates(
A int,
B int);

insert into Reverse_duplicates values(1,2);
insert into Reverse_duplicates values(3,2);
insert into Reverse_duplicates values(2,4);
insert into Reverse_duplicates values(2,1);
insert into Reverse_duplicates values(5,6);
insert into Reverse_duplicates values(4,2);


select a.A as A_1, a.B as B_1, b.A as A_2, b.b as B_2 
from Reverse_duplicates a
 left join Reverse_duplicates b
on a.A = b.B and a.B = b.a
where a.A<b.A or (b.A is null and b.b is null);