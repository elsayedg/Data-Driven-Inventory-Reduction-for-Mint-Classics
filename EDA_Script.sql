-- =============================
-- step 1 checking data quality 
-- =============================

-- products table

select * from products where productName is null;

-- orderdetails table 

select * from orderdetails where productCode is null;

-- orders table

select * from orders where orderDate is null;

-- productlines table 

select * from productlines;

-- warehouses table 

select * from warehouses;

-- customers table 

 select * from customers where customerName is null ;

/*
 there is no missing data in our data base  
*/


-- ================================
-- step 2 getting to Know our data 
-- ================================

-- 1- How many products are stored in each warehouse?

SELECT
    warehouseCode ,
    sum(quantityInStock) AS total_quantity
FROM products p
GROUP BY warehouseCode
ORDER BY total_quantity DESC;

/*
	warehouseCode|total_quantity|
	-------------+--------------+
	b            |        219183|
	a            |        131688|
	c            |        124880|
	d            |         79380|
*/

-- 2- How many orders did each warehouse serve?

SELECT
    warehouseCode ,
    sum(quantityOrdered) AS total_Orders
FROM
    products p
JOIN orderdetails o 
ON p.productCode = o.productCode
GROUP BY warehouseCode
ORDER BY total_Orders DESC;

/*
	warehouseCode|total_Orders|
	-------------+------------+
	b            |       35582|
	a            |       24650|
	c            |       22933|
	d            |       22351|

*/

-- 3- What is the percentage of moving stock for each warehouse?

SELECT
    p.warehouseCode ,
    sum(o.quantityOrdered) AS total_Orders,
    sum(p.quantityInStock) AS total_quantity,
    ((sum(o.quantityOrdered) / sum(p.quantityInStock)) * 100) AS perecent_of_moving_stock
FROM products p
JOIN orderdetails o 
ON p.productCode = o.productCode
GROUP BY warehouseCode
ORDER BY perecent_of_moving_stock DESC;

/*
	warehouseCode|total_Orders|total_quantity|perecent_of_moving_stock|
	-------------+------------+--------------+------------------------+
	d South      |       22351|       2186871|                  1.0221|
	a North      |       24650|       3659553|                  0.6736|
	c west       |       22933|       3439570|                  0.6667|
	b East       |       35582|       5844033|                  0.6089|
	
    
    as we can see the South warehouse has the highst percent of moving stock

*/


-- 4- How much time does it usually take to deliver an order?

SELECT 
DATEDIFF(shippedDate, orderDate)   AS actual_time 
,DATEDIFF(requiredDate , orderDate) AS expected_time
,(DATEDIFF(requiredDate , orderDate)) - (DATEDIFF(shippedDate, orderDate)) AS diff 
FROM orders o 
WHERE o.status = 'Shipped'
ORDER BY diff ;
/*
	# actual_time		expected_time			diff
		65			9			-56
		6			6			0
		6			6			0
		7			7			0
		6			6			0
		6			6			0
		7			7			0
		6			6			0
		5			6			1
		5			6			1
	etc

		we got an outlier 
		lets invstigate more 
*/
-- 5- Outlier investigation
select o.orderNumber
,o.comments 
from orders o 
join orderdetails od 
on o.orderNumber = od.orderNumber 
where DATEDIFF(o.requiredDate , o.shippedDate) < 0
group by o.orderNumber,o.comments ;

/*
	# orderNumber		comments
			10165		This order was on hold because customers's credit limit had been exceeded. 
						Order will ship when payment is received
	
    it's a payment issue not supplychain issue 
*/

-- 6- How much earlier than usual do we typically deliver orders?

SELECT  
(DATEDIFF(requiredDate , orderDate)) - (DATEDIFF(shippedDate, orderDate)) AS diff_in_Days 
,count(*)
FROM orders o 
WHERE o.status = 'Shipped'
GROUP BY diff_in_Days
ORDER BY count(*) desc;

/*
	# diff_in_Days  count(*) 
				3  		54
				5  		45
				4  		42
		etc 
	most of the time we deliver early by 3 to 5 days 
*/


-- 7- What is the average delivery time (in days) for each warehouse?
SELECT  p.warehouseCode  , 
avg(DATEDIFF(o.requiredDate , o.shippedDate)) as avg_order_shiped
FROM orders o  JOIN orderdetails od 
ON o.orderNumber = od.orderNumber  JOIN products p 
ON od.productCode = p.productCode
WHERE o.status = 'Shipped'
GROUP BY p.warehouseCode  
ORDER BY avg_order_shiped desc;

/*

		# warehouseCode		avg_order_shiped
			c		4.6142
			a		4.2229
			b		4.2101
			d		3.8629

the bigger is better 
*/

-- 8- How many orders are shipped from each warehouse? 


SELECT p.warehouseCode ,count(o.orderNumber) 
FROM products p JOIN orderdetails o ON p.productCode = o.productCode
GROUP BY p.warehouseCode 
ORDER BY count(o.orderNumber) ;

/* 
	warehouseCode|count(o.orderNumber)|
	-------------+--------------------+
	d            |                 634|
	c            |                 657|
	a            |                 695|
	b            |                1010|
	
    most came from the east which has the bigest inventory instock items 
	lets see the products in each 
*/

-- 9- What types of products are stored in each warehouse?

SELECT p.warehouseCode,p.productLine  ,count(o.orderNumber) 
FROM products p JOIN orderdetails o ON p.productCode = o.productCode
GROUP BY p.warehouseCode,p.productLine  
ORDER BY count(o.orderNumber) ;

/*
	warehouseCode|productLine     |count(o.orderNumber)|
	-------------+----------------+--------------------+
	d            |Trains          |                  81|
	d            |Ships           |                 245|
	d            |Trucks and Buses|                 308|
	a            |Planes          |                 336|
	a            |Motorcycles     |                 359|
	c            |Vintage Cars    |                 657|
	b            |Classic Cars    |                1010|
*/

-- 10- What subcategories do each of the products belong to?

SELECT p.warehouseCode
,p.productLine  
,count(p.productCode) 
, sum(p.quantityInStock)
FROM products p 
GROUP BY p.warehouseCode,p.productLine  
ORDER BY count(p.productCode) ,sum(p.quantityInStock);

/*
	warehouseCode|productLine     |count(p.productCode)|sum(p.quantityInStock)|
	-------------+----------------+--------------------+----------------------+
	d            |Trains          |                   3|                 16696|
	d            |Ships           |                   9|                 26833|
	d            |Trucks and Buses|                  11|                 35851|
	a            |Planes          |                  12|                 62287|
	a            |Motorcycles     |                  13|                 69401|
	c            |Vintage Cars    |                  24|                124880|
	b            |Classic Cars    |                  38|                219183|

*/

-- 11- Where does the majority of our customer base reside?
select  distinct country 
,count(distinct customerNumber)
from customers
group by country 
order by count(*) desc;

/*
	# country	count(distinct customerNumber)
	USA				36
	Germany				13
	France				12
	Spain				7
	Australia			5
	UK				5
	Italy				4
	New Zealand			4
	Canada				3
	Finland				3
	Norway				3
	Singapore			3
	Switzerland			3
	Austria				2
	Belgium				2
	Denmark				2
	Ireland				2
	Japan				2
	Portugal			2
	Sweden				2
	Hong Kong			1
	Israel				1
	Netherlands			1
	Philippines			1
	Poland				1
	Russia				1
	South Africa			1

Most of our customer from USA , Germany and France 
so more than 50% of our customer out Side USA 
which means out supply chain is solid and would not effect 
Becuase it's dependand on ports and ships 
*/



