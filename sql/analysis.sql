-- CLEANING
CREATE TABLE walmart_clean AS
SELECT 
    "Store" AS store,
    TO_DATE("Date", 'DD-MM-YYYY') AS date,
    "Weekly_Sales" AS weekly_sales,
    "Holiday_Flag" AS holiday_flag,
    "Temperature" AS temperature,
    "Fuel_Price" AS fuel_price,
    "CPI" AS cpi,
    "Unemployment" AS unemployment
FROM walmart;

-- TOP stores by revenue
select store, sum(weekly_sales) as total_sales
from walmart_clean
group by store
order by total_sales desc

-- Sales trend over time
select date, sum(weekly_sales) as total_sales
from walmart_clean
group by date
order by date asc

--Impact of holiday on revenue
select holiday_flag, avg(weekly_sales)
from walmart_clean
group by holiday_flag

--Peak sales week
select date, sum(weekly_sales) as total_sales
from walmart_clean
group by date
order by total_sales desc
limit 5

--Monthly sales
select EXTRACT(MONTH FROM date) as month, avg(weekly_sales) as total_sales
from walmart_clean
group by month
order by total_sales desc

--Impact of Holiday on Stores 

with stores_stat as 
(
	select store,
	AVG(case when holiday_flag = 1 then weekly_sales END) as holiday_avg,
	AVG(case when holiday_flag = 0 then weekly_sales END) as non_holiday_avg
	from walmart_clean
	group by store
)

select store, holiday_avg, non_holiday_avg, holiday_avg - non_holiday_avg as lift, (holiday_avg - non_holiday_avg) / non_holiday_avg AS pct_lift
from stores_stat
order by lift desc;


