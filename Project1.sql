SELECT count(*) FROM p1.retail_sales;
ALTER TABLE retail_sales
RENAME COLUMN ï»¿transactions_id TO transactions_id;
ALTER TABLE retail_sales
MODIFY COLUMN transactions_id INT;
ALTER TABLE retail_sales
MODIFY COLUMN sale_date date;
ALTER TABLE retail_sales
MODIFY COLUMN sale_time TIME;
ALTER TABLE retail_sales
MODIFY COLUMN customer_id INT;
ALTER TABLE retail_sales
MODIFY COLUMN age INT;
ALTER TABLE retail_sales
MODIFY COLUMN quantiy INT;
ALTER TABLE retail_sales
MODIFY COLUMN price_per_unit INT;
ALTER TABLE retail_sales
MODIFY COLUMN cogs double;
ALTER TABLE retail_sales
MODIFY COLUMN total_sale INT;
-- DATA CLEANING

-- FINDING NULL VALUES
SELECT * FROM retail_sales
WHERE 
age='' OR
category='' OR
quantiy='' OR
price_per_unit='' OR
cogs='' OR
total_sale='';

-- DELETING THE NULL VALUED ROWS FROM THE DATASET

DELETE FROM retail_sales
WHERE 
age='' OR
category='' OR
quantiy='' OR
price_per_unit='' OR
cogs='' OR
total_sale='';

-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE 
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How many UNIQUE customers do me have?
SELECT COUNT(distinct customer_id) FROM retail_sales;

-- HOW MANY UNIQUE CATOGERYS WE HAVE ?
SELECT DISTINCT category FROM retail_sales;


SELECT * FROM retail_sales;



-- Data Analysis & Business Problems & Answers


-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)




-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales
WHERE sale_date='2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022

SELECT category,SUM(quantiy)
FROM retail_sales
WHERE category='Clothing'
GROUP BY 1;


SELECT * FROM retail_sales
WHERE category='Clothing'
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
AND quantiy>=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category,AVG(age) FROM retail_sales
WHERE category='Beauty'
GROUP BY 1;

SELECT AVG(age) AS Avg_Age FROM retail_sales
WHERE category='Beauty';



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
 
 
 SELECT * FROM retail_sales
 WHERE total_sale>=1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category,gender,COUNT(*) as total_tran
FROM retail_sales 
GROUP BY category,gender
ORDER BY 1;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT YEAR(sale_date) AS year,MONTH(sale_date) AS month,AVG(total_sale) AS avg_sales 
FROM retail_sales
GROUP BY year,month
ORDER BY 1,3 desc;


SELECT year,month,avg_sales FROM (
SELECT YEAR(sale_date) AS year,MONTH(sale_date) AS month,AVG(total_sale) AS avg_sales,
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale)DESC) AS R
FROM retail_sales
GROUP BY year,month
) AS t1
WHERE R=1;
-- ORDER BY 1,3 desc;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 


SELECT customer_id,cust_sales FROM(
SELECT customer_id,SUM(total_sale) AS cust_sales,
RANK() OVER(ORDER BY SUM(total_sale)DESC) AS R
FROM retail_sales
GROUP BY 1
) AS t2
WHERE R<6
ORDER BY 2 DESC;



SELECT customer_id,SUM(total_sale) AS cust_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

 SELECT * FROM retail_sales;
SELECT category,COUNT(DISTINCT customer_id) AS cnt_unique_cs from retail_sales
GROUP BY category ;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
CASE
WHEN HOUR(sale_time)<=12 THEN 'MORNING'
WHEN HOUR(sale_time)>12 AND HOUR(sale_time)<17 THEN 'AFTERNOON'
ELSE 'EVENING'
END AS shift,COUNT(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
order by 1;


WITH hourly_sale
AS
(
SELECT *,
CASE
WHEN HOUR(sale_time)<=12 THEN 'MORNING'
WHEN HOUR(sale_time)>12 AND HOUR(sale_time)<17 THEN 'AFTERNOON'
ELSE 'EVENING'
END AS shift
FROM retail_sales
)
SELECT shift,
COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- END OF PROJECT1---