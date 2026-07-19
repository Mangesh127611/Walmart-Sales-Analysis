create database walmart;
use walmart;

CREATE TABLE walmart_sales(
    Store INT,
    Date VARCHAR(20),
    Weekly_Sales DECIMAL(12,2),
    Holiday_Flag TINYINT,
    Temperature DECIMAL(5,2),
    Fuel_Price DECIMAL(5,3),
    CPI DECIMAL(10,3),
    Unemployment DECIMAL(5,3)
);

select count(*) as total_records
from walmart;

SELECT
SUM(Store IS NULL) AS Store,
SUM(Date IS NULL) AS Date,
SUM(Weekly_Sales IS NULL) AS Weekly_Sales,
SUM(Holiday_Flag IS NULL) AS Holiday_Flag,
SUM(Temperature IS NULL) AS Temperature,
SUM(Fuel_Price IS NULL) AS Fuel_Price,
SUM(CPI IS NULL) AS CPI,
SUM(Unemployment IS NULL) AS Unemployment
FROM walmart_sales;

SELECT Store,Date,COUNT(*)
FROM walmart_sales
GROUP BY Store,Date
HAVING COUNT(*)>1;

select * from walmart 
limit 10;

-- convert date format
alter table walmart
add sales_date date;

update walmart
set sales_date = str_to_date(date, '%d-%m-%Y');

-- remove old date column
alter table walmart
drop column date;

-- verify dtypes
DESCRIBE walmart;

-- Business Problems
--  1) total sales
select round(sum(weekly_sales),2) as total_sales
from walmart;

--  2) average weekly sales
select round(avg(weekly_sales), 2) as average_weekly_sales
from walmart;

--  3) highest weekly sale
select max(weekly_sales) as highest_weekly_sales
from walmart;

--  4) lowest weekly sale
select min(weekly_sales) as lowest_weekly_sale
from walmart;

-- 5) top 10 highest sales records
select *
from walmart
order by weekly_sales desc
limit 10;

-- 6) store with highest sales
select store,
sum(weekly_sales) as totalsales
from walmart
group by store
order by totalsales desc;

-- 7) store with lowest sales
select store,
round(sum(weekly_sales), 2) as lowestsales
from walmart
group by store 
order by lowestsales
limit 1;

--  8) average sales per store
select store,
round(avg(weekly_sales), 2) as avgsales
from walmart
group by store;

-- 9) holidays vs non-holidays sales 
select holiday_flag,
sum(weekly_sales) as totalsales
from walmart
group by holiday_flag;

--  10) Number of holiday weeks
select count(*) 
from walmart 
where holiday_flag=1;

--  11) monthly sales trend
select 
month(sales_date) MonthNo,
round(sum(weekly_sales), 2)as  totalsales
from walmart
group by month(sales_date) 
order by MonthNo;

--  12) yearly sales
select
year(sales_date) as Year,
round(sum(weekly_sales), 2) as totalsales
from walmart
group by year(sales_date);

--  13) best performing month
select 
monthname(sales_date) MONTH,
round(sum(weekly_sales), 2) totalsales
from walmart
group by monthname(sales_date)
order by totalsales desc;

-- 14) top 5 store by average sales 
select store,
AVG(weekly_sales) as avg_sales
from walmart
group by store
order by avg_sales desc
limit 5;

-- 15) temperature impact sales
select round(temperature) temperature,
avg(weekly_sales) as avgsales
from walmart
group by round(temperature)
order by temperature;

-- 16) fuel price impact
select round(fuel_price, 1) fuel_price,
AVG(weekly_sales) as avgsales
from walmart
group by round(fuel_price,1) 
order by fuel_price;

--  17) highest cpi store
select store,
AVG(cpi) as avgcpi
from walmart
group by store
order by avgcpi desc;

--  18) highest unemployment store
select store,
AVG(unemployment) as avgunemployment
from walmart 
group by store
order by avgunemployment desc;

--  19) top 10 weekly sales date 
select sales_date,
sum(weekly_sales) as TotalSales
from walmart 
group by sales_date
order by Totalsales desc 
limit 10;

--  20) sales greater than overall average 
select * 
from walmart 
where weekly_sales > (select
avg(weekly_sales) 
from walmart);

--  21) running total sales
select sales_date,
weekly_sales,
sum(weekly_sales)
over(order by sales_date) RunningTotal
from walmart;

--  22) rank store by sales
select store,
sum(weekly_sales) TotalSales,
Rank() over(order by sum(weekly_sales) desc) Storerank
from walmart 
group by store;

--  23) top sale of each store
select store,
max(weekly_sales) as highestsale
from walmart 
group by store;

--  24) weekly sales classification
select store,
weekly_sales,
case
when weekly_sales> 2000000 then 'excellent'
when weekly_sales> 1500000 then 'good'
when weekly_sales> 1000000 then 'average'
else 'low'
end as performance
from walmart;

--  25) top 3 stores in each year
select * 
from
(select 
YEAR(sales_date) as year,
store,
sum(weekly_sales) as TotalSales,
dense_rank() over(
partition by year(sales_date) 
order by sum(weekly_sales) desc
) rnk
from walmart
group by YEAR(sales_date), store
) t
where rnk<=3;




	

