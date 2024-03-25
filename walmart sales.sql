create database if not exists saledatawalmart;

use saledatawalmart

create table if not exists sales (
invoice_id varchar(50) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(30) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4) not null,
Date datetime not null,
Time time not null,
payment_method varchar(15) not null,
cogs decimal (10,2) not null,
gross_marginal_pct float(11,9),
gross_income decimal(12,4) not null ,
rating float(2,1) );

use saledatawalmart

select * from sales

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Feature Engineering~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~ Time_Of_Date

select time,
 ( case when 'time' between "00:00:00" and "12:00:00" then " Morning"
 when 'time' between "12:01:00" and "16:00:00" then " Afternoon"
 else "Evening"
 end
)
as time_of_date
from sales;

alter table sales add column time_of_date varchar(20);

update sales 
set time_of_date = (
case when 'time' between "00:00:00" and "12:00:00" then " Morning"
 when 'time' between "12:01:00" and "16:00:00" then " Afternoon"
 else "Evening"
 end
 );
 


~~ day_name

use saledatawalmart

select
date, dayname(date)
from sales

alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

select * from sales

~~month name

select date, monthname(date) from sales

alter table sales add column month_name varchar(15);

update sales
set month_name = monthname(date);

select  * from sales

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Generic~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


~~ How many unique city does data have?

select distinct city
from sales

~~ In which city is each branch?

select distinct city, branch from sales


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Product ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~ How many unique product lines does the data have?

select
distinct product_line from sales 

~~ What is the most common payment method?

select 
payment_method,
count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc 

~~ What is the most selling product line?

select product_line,
count(product_line) as cnt
from sales
group by product_line
order by cnt desc


~~ total revenue by month

select month_name as Month,
sum(total) as Total_Revenue
from sales 
group by month_name
order by Total_Revenue desc

~~ which month had the largest COGS?

select month_name as Month,
sum(cogs) as cogs
from sales
group by month_name
order by cogs desc

~~ Which product line had the largest largest revenue

select product_line, 
sum(total) as Total_Revenue
from sales
group by product_line
order by Total_Revenue desc

~~ which city has the largest revenue

select city,branch,
sum(total) as Total_Revenue
from sales
group by city, branch
order by Total_Revenue desc

~~which product line had the largest VAT?

select product_line,
avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc

~~ which branch sold more products tha average product sold?

select branch,
sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity)from sales) 
order by qty desc

~~ most common product line by gender

select gender,
product_line,
count(gender) as cnt
from sales
group by gender, product_line
order by cnt desc

~~ what is the avg rate of each product line

select product_line,
round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sales~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~ number sales made in each time of the day per weekend

select time_of_date,
count(*) as total_sales
from sales
where day_name = 'sunday'
group by time_of_date
order by total_sales desc

~~ which of the customer types brings the most revenue ?

select 
customer_type,
sum(total) as total_rev
from sales
group by customer_type
order by total_rev desc

~~ which city has the largest tax percen/ VAT ?

select city,
round(avg(VAT),2) as VAT
from sales
group by city
order by VAT desc

~~ which customer type pays the most in VAT?

select customer_type,
round(avg(VAT),2) as VAT
from sales
group by customer_type
order by VAT desc


~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Customer~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~ how many unique customer types does the data have?

select distinct(customer_type) from sales

~~ how many unique payment methods does the data have?

select distinct payment_method from sales

~~what is the most common customer type ?

select customer_type , 
count(customer_type) as cnt
from sales
group by customer_type
order by cnt desc

~~~ which customer type buys the most?

select 
customer_type,
sum(quantity) as quantity
 from sales
 group by customer_type
 order by quantity desc
 
 ~~~ what gender of the most of the customer?
 
 select gender,
 count(*) as cnt
 from sales
 group by gender
 order by cnt desc
 
 
 ~~~ what is the gender distrubistion per branch?
 
select 
gender,
count(*)
from sales
where  branch = 'a'
group by gender 

 
select 
gender,
count(*)
from sales
where  branch = 'b'
group by gender 

 
select 
gender,
count(*)
from sales
where  branch = 'c'
group by gender 


~~~ which time of the day do customer give the most rating?

select time_of_date ,
avg(rating) as avg_rating
 from sales
 group by time_of_date
 order by avg_rating desc
 
 select * from sales
 
 
 ~~~which time of day do customer give most rating per branch?
 
 
 select time_of_date ,
avg(rating) as avg_rating
 from sales
 where branch = 'a'
 group by time_of_date
 order by avg_rating desc
 
 
select time_of_date ,
avg(rating) as avg_rating
 from sales branch ='b'
 group by time_of_date
 order by avg_rating desc
 
 
 select time_of_date ,
avg(rating) as avg_rating
 from sales
 where branch = 'c'
 group by time_of_date
 order by avg_rating desc
 
 
~~~ which day of the week has the best avg rating?

select day_name,
round(avg(rating) , 2) as avg_rating
from sales
group by day_name
order by avg_rating desc


 ~~~ which day of the week has the best rating per branch?
 
 
select day_name,
round(avg(rating) , 2) as avg_rating
from sales
where branch = 'a' 
group by day_name
order by avg_rating desc

 
select day_name,
round(avg(rating) , 2) as avg_rating
from sales
where branch = 'b' 
group by day_name
order by avg_rating desc

 
select day_name,
round(avg(rating) , 2) as avg_rating
from sales
where branch = 'c' 
group by day_name
order by avg_rating desc

