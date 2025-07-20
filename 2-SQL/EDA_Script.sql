-- =============================
-- step 1 checking data quality 
-- =============================

-- products table

SELECT
    *
FROM
    products
WHERE
    productname IS NULL;

-- orderdetails table 

SELECT
    *
FROM
    orderdetails
WHERE
    productcode IS NULL;

-- orders table
SELECT
    *
FROM
    orders
WHERE
    orderdate IS NULL;

-- productlines table 

SELECT
    *
FROM
    productlines;

-- warehouses table 

SELECT
    *
FROM
    warehouses;

-- customers table 

SELECT
    *
FROM
    customers
WHERE
    customername IS NULL;

/*
 there is no missing data in our data base  
*/


-- ================================
-- step 2 getting to Know our data 
-- ================================

-- 1- How many products are stored in each warehouse?

SELECT
    warehousecode,
       Sum(quantityinstock) AS total_quantity
FROM
    products p
GROUP BY
    warehousecode
ORDER BY
    total_quantity DESC;

/*
	warehouseCode|total_quantity|
	-------------+--------------+
	b            |        219183|
	a            |        131688|
	c            |        124880|
	d            |         79380|
*/

-- 2- How many items did each warehouse serve?

SELECT
    warehousecode,
       Sum(quantityordered) AS total_Orders
FROM
    products p
JOIN orderdetails o
         ON
    p.productcode = o.productcode
GROUP BY
    warehousecode
ORDER BY
    total_orders DESC;

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
    p.warehousecode,
       Sum(o.quantityordered) AS
       total_items_Orders,
       Sum(p.quantityinstock) AS
       total_quantity,
       ( ( Sum(o.quantityordered) / Sum(p.quantityinstock) ) * 100 ) AS
       perecent_of_moving_stock
FROM
    products p
JOIN orderdetails o
         ON
    p.productcode = o.productcode
GROUP BY
    warehousecode
ORDER BY
    perecent_of_moving_stock DESC;

/*
        warehousecode|total_items_Orders|total_quantity|perecent_of_moving_stock|
        -------------+------------------+--------------+------------------------+
        d            |             22351|       2186871|                  1.0221|
        a            |             24650|       3659553|                  0.6736|
        c            |             22933|       3439570|                  0.6667|
        b            |             35582|       5844033|                  0.6089|
    
    as we can see the South warehouse has the highst percent of moving stock

*/


-- 4- How much time does it usually take to deliver an order?

SELECT
    Datediff(shippeddate, orderdate)
       AS
       actual_time,
       Datediff(requireddate, orderdate)
       AS expected_time,
       ( Datediff(requireddate, orderdate) ) - (
       Datediff(shippeddate, orderdate) ) AS
       diff
FROM
    orders o
WHERE
    o.status = 'Shipped'
ORDER BY
    diff;
/*
        actual_time|expected_time|diff|
        -----------+-------------+----+
                 65|            9| -56|
                  6|            6|   0|
                  6|            6|   0|
                  7|            7|   0|
                  6|            6|   0|
                  6|            6|   0|
                  7|            7|   0|
                  6|            6|   0|
                  5|            6|   1|
                  5|            6|   1|
                  6|            7|   1|
                  5|            6|   1|
                  5|            6|   1|
                  6|            7|   1|
                  6|            7|   1|
                  6|            7|   1|
                  5|            6|   1|
                  5|            6|   1|
	etc

		we got an outlier 
		lets invstigate more 
*/

-- 5- Outlier investigation
SELECT
    o.ordernumber,
       o.comments
FROM
    orders o
JOIN orderdetails od
         ON
    o.ordernumber = od.ordernumber
WHERE
    Datediff(o.requireddate, o.shippeddate) < 0
GROUP BY
    o.ordernumber,
          o.comments;

/*
ordernumber|comments                                                                                                           |
-----------+-------------------------------------------------------------------------------------------------------------------+
      10165|This order was on hold because customers's credit limit had been exceeded. Order will ship when payment is received|
	
    it's a payment issue not supplychain issue 
*/

-- 6- How much earlier than usual do we typically deliver orders?

SELECT
    ( Datediff(requireddate, orderdate) ) - (
       Datediff(shippeddate, orderdate) ) AS
       diff_in_Days,
       Count(*)
FROM
    orders o
WHERE
    o.status = 'Shipped'
GROUP BY
    diff_in_days
ORDER BY
    Count(*) DESC;

/*
        diff_in_Days|Count(*)|
        ------------+--------+
                   3|      54|
                   5|      45|
                   4|      42|
		etc 
	most of the time we deliver early by 3 to 5 days 
*/


-- 7- What is the average delivery time (in days) for each warehouse?
-- this shows how much early each warehouse deliver 
-- the bigger number is better 

SELECT
    p.warehousecode,
       Avg(Datediff(o.requireddate, o.shippeddate)) AS avg_order_shiped
FROM
    orders o
JOIN orderdetails od
         ON
    o.ordernumber = od.ordernumber
JOIN products p
         ON
    od.productcode = p.productcode
WHERE
    o.status = 'Shipped'
GROUP BY
    p.warehousecode
ORDER BY
    avg_order_shiped DESC;

/*
        warehousecode|avg_order_shiped|
        -------------+----------------+
        c            |          4.6142|
        a            |          4.2229|
        b            |          4.2101|
        d            |          3.8629|

*/

-- 8- What types of products are stored in each warehouse?

SELECT
    p.warehousecode,
       p.productline,
       Count(o.ordernumber)
FROM
    products p
JOIN orderdetails o
         ON
    p.productcode = o.productcode
GROUP BY
    p.warehousecode,
          p.productline
ORDER BY
    Count(o.ordernumber);

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

-- 9- What subcategories do each of the products belong to?

SELECT
    p.warehousecode,
       p.productline,
       Count(p.productcode),
       Sum(p.quantityinstock)
FROM
    products p
GROUP BY
    p.warehousecode,
          p.productline
ORDER BY
    Count(p.productcode),
          Sum(p.quantityinstock);
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

-- 10- Where does the majority of our customer base reside?
SELECT
    DISTINCT country,
                Count(DISTINCT customernumber)
FROM
    customers
GROUP BY
    country
ORDER BY
    Count(*) DESC;

/*
        country     |Count(DISTINCT customernumber)|
        ------------+------------------------------+
        USA         |                            36|
        Germany     |                            13|
        France      |                            12|
        Spain       |                             7|
        Australia   |                             5|
        UK          |                             5|
        Italy       |                             4|
        New Zealand |                             4|
        Canada      |                             3|
        Finland     |                             3|
        Norway      |                             3|
        Singapore   |                             3|
        Switzerland |                             3|
        Austria     |                             2|
        Belgium     |                             2|
        Denmark     |                             2|
        Ireland     |                             2|
        Japan       |                             2|
        Portugal    |                             2|
        Sweden      |                             2|
        Hong Kong   |                             1|
        Israel      |                             1|
        Netherlands |                             1|
        Philippines |                             1|
        Poland      |                             1|
        Russia      |                             1|
        South Africa|                             1|

Most of our customer from USA , Germany and France 
so more than 50% of our customer out Side USA 
which means out supply chain is solid and would not effect 
Becuase it's dependand on ports and ships 
*/



