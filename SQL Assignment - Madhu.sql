-- SQL Assignment answers
SELECT * FROM classicmodels.employees;
select * from employees;

-- Q1 a. Assignment
select employeenumber, firstname, lastname from employees where jobTitle = "Sales Rep" and reportsto = 1102;

-- Q1 b. Assignment (showing with and without distinct)
select * from products;
-- by using distinct
select distinct productline from products where productLine like "%cars";

-- without using distinct
select productline from products where productline like "%cars" group by productline;
------------------------------------------------------------------------------------------------------------

-- Q2. Assignment -- (kept country also in column to show that countries are allocated to correct segment as per the question)--
use classicmodels;
Select * from customers;
select customernumber, customername, Country,
case 
when country in ("USA",  "Canada") then "North America"
When country in ("UK", "France", "Germany") then "Europe"
Else "Other"
End as customersegment
From Customers;
--------------------------------------------------------------------------------------------------------------------

-- Q3 a. Assignment
select * from orderdetails;
select productcode, sum(quantityordered) as Total_ordered from orderdetails 
group by productcode order by Total_ordered desc limit 10;

-- Q3 b. Assignments
select * from payments;
select monthname(paymentdate) as Payment_month, count(*) as Num_payments from payments 
group by Payment_month having num_payments>20 order by Num_payments DESC limit 10;
------------------------------------------------------------------------------------------------------------------

-- Q4 a. Assignment
Create database Customers_orders;
Use Customers_orders;
Create table Customers (customer_id int Primary Key auto_increment, first_name varchar(50) not null, last_name varchar(50) not null,
email varchar(255) unique, phone_number varchar(20));
Describe customers;

-- Q4 b. Assignment
Create table Orders (Order_id int Primary Key Auto_increment, Customer_id int, order_date date, 
total_amount decimal (10,2), foreign key (customer_id) references customers_orders.customers(customer_id), 
check (total_amount >0));
describe customers_orders.orders;
----------------------------------------------------------------------------------------------------------------------------

-- Q5. Assignment
Use classicmodels;
Select * from customers;
Select * from orders;
Select Country, count(Ordernumber) as Order_count from Customers JOIN Orders on 
Customers.Customernumber = Orders.Customernumber Group By Country order by order_count DESC LIMIT 5;
-----------------------------------------------------------------------------------------------------------------------

-- Q6. Assignment
create table Project(EmployeeID INT Primary Key Auto_increment, FullName varchar(50) Not Null,
Gender ENUM("Male", "Female") Not null, ManagerID int);
Describe Project;

Insert into Project values(1, "Pranaya", "Male", 3);
Insert into Project values(2, "Priyanka", "Female", 1);
Insert into Project values(3, "Preety", "Female", null);
Insert into Project values(4, "Anurag", "Male", 1);
Insert into Project values(5, "Sambit", "Male", 1);
Insert into Project values(6, "Rajesh", "Male", 3);
Insert into Project values(7, "Hina", "Female", 3);
select * from Project;

Select m.fullname as ManagerName, e.fullname as EmpName from Project E join project M on 
m.employeeid = e.managerid 
order by Managername;
-----------------------------------------------------------------------------------------------------------------

-- Q7. Assignment
Create table Facility(FacilityID int, Name varchar(100), State varchar(100), Country varchar(100));
select * from Facility;
Alter table facility modify FacilityID int Primary Key Auto_increment;
Alter table Facility add column City Varchar(100) not null after Name;
describe Facility;
---------------------------------------------------------------------------------------------------------------

-- Q8. Assignment
use classicmodels;
select * from productlines;
select * from orders;
select * from orderdetails;
select * from products;

Create VIEW product_category_sales as select productlines.productline as productline,
sum(orderdetails.quantityordered * orderdetails.priceEach) as total_sales, 
(select count(distinct orders.ordernumber) from orders join orderdetails on 
orders.ordernumber = orderdetails.ordernumber Join products on orderdetails.productcode = products.productcode 
where products.productline = productlines.productline) as number_of_orders from products
join orderdetails on products.productcode = orderdetails.productcode join orders on 
orderdetails.ordernumber = orders.ordernumber join productlines on products.productline = productlines.productline 
group by productlines.productline;

select * from product_category_sales;
---------------------------------------------------------------------------------------------------------------

-- Q9. Assignment
select * from customers;
select * from payments;
delimiter $$
create procedure Get_country_payments(p_year int, p_country varchar(50))
Begin
select year(paymentdate) as Year, Customers.country,
concat(round(sum(Payments.amount)/1000,0), "K") as "Total Amount" from payments
join Customers on payments.customernumber = customers.customernumber
where year (paymentdate) = p_year and customers.country = p_country
group by year(paymentdate), customers.country;
end $$
delimiter ;
call classicmodels.Get_country_payments(2003, 'France');
------------------------------------------------------------------------------------------------------------

-- Q10a. Assignments
select * from customers;
select * from orders;

-- Window functions with Rank
select customers.customername, count(orders.ordernumber) as Order_count,
rank() over (order by count(orders.ordernumber)desc) as orders_frequency_rank from customers
join orders on customers.customernumber = orders.customernumber group by customers.customername 
order by order_count desc;

-- Window functions with Dense_Rank
select customers.customername, count(orders.ordernumber) as Order_count,
dense_rank() over (order by count(orders.ordernumber)desc) as orders_frequency_rank from customers
join orders on customers.customernumber = orders.customernumber group by customers.customername 
order by order_count desc;

-- Q10b. Assignments
use classicmodels;
select * from orders;
WITH Total_orders as (select extract(year from orderdate) as Year, extract(month from orderdate) as month, 
count(ordernumber) as Total_orders from orders group by extract(year from orderdate), 
extract(month from orderdate)) 
select orders.year,
case
When orders.Month = 1 then "January"
When orders.Month = 2 then "February"
When orders.Month = 3 then "March"
When orders.Month = 4 then "April"
When orders.Month = 5 then "May"
When orders.Month = 6 then "June"
When orders.Month = 7 then "July"
When orders.Month = 8 then "August"
When orders.Month = 9 then "September"
When orders.Month = 10 then "October"
When orders.Month = 11 then "November"
When orders.Month = 12 then "December"
end as month, orders.Total_orders,
concat(round((orders.Total_orders - LAG(orders.Total_orders) over (order by orders.year, orders.month)) / LAG(orders.Total_orders)
over (order by orders.year, orders.month)*100,0), "%") as "% YOY Change" from Total_orders orders Order by orders.year, orders.month;
-------------------------------------------------------------------------------------------------------------------

-- Q11. Assignments
select * from products;
select productline, count(*) as "Total" from products
where buyprice > (select avg(buyprice) from products)
group by productline order by count(*) desc;
--------------------------------------------------------------------------------------------------------------

-- Q12. Assignments 
select * from Emp_EH;
Delimiter $$
Create PROCEDURE Emp_EH_Procedure (in p_EmpID int, in p_EmpName varchar(50), in p_EmailAddress varchar(250))
BEGIN
Declare Exit handler for sqlexception
Begin
Rollback;
Select "Error Occurred" as Message;
End;
Start transaction;
Insert into Emp_EH (EmpID, EmpName, EmailAddress) values (p_EmpID, p_EmpName, p_EmailAddress);
Commit;
Select "Data inserted succesfully" as Message;
End$$
Delimiter ;

CALL Emp_EH_Procedure(5, 'John Doe', 'john.doe@example.com');
CALL Emp_EH_Procedure(10, 'Shivani', 'shivani@yahoo.com');
CALL Emp_EH_Procedure(10, 'Shivani', 'shivani@yahoo.com');
CALL Emp_EH_Procedure(11, 'Shiv', 'shiv@gmail.com');
CALL Emp_EH_Procedure(12, 'Prithvi', 'prithvi@gmail.com');
CALL Emp_EH_Procedure(13, 'Priya', 'priya@gmail.com');
------------------------------------------------------------------------------------------------------------------

-- Q13. Assignments
Create table Emp_Bit(Name varchar(50), Occupation varchar (30), Working_date date, working_hours int);
Insert into Emp_Bit values("Robin", "Scientist", "2020-10-04",12);
Insert into Emp_Bit values("Warner", "Engineer", "2020-10-04",10);
Insert into Emp_Bit values("Peter", "Actor", "2020-10-04",13);
Insert into Emp_Bit values("Marco", "Doctor", "2020-10-04",14);
Insert into Emp_Bit values("Brayden", "Teacher", "2020-10-04",12);
Insert into Emp_Bit values("Antonio", "Business", "2020-10-04",11);
Select * from Emp_Bit;
Set sql_safe_updates = 0;
Update Emp_Bit set Working_hours = ABS(Working_hours) where Working_hours <0;
Delimiter $$
Create Trigger Prevent_Negative_Working_Hours
Before Insert on EMP_BIT For Each Row
Begin IF New.Working_hours <0 then
Set New.Working_hours = ABS(New.Working_hours);
End if;
End $$
Delimiter ;
Insert into Emp_Bit values ("Asha", "Trainer", "2020-10-04",-20);
Insert into Emp_Bit values ("Sana", "Designer", "2020-10-04",-10);
Select * from Emp_Bit;