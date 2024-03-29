
/*

as we can see from the Graph that our sales Never goes beound 4000 items from Classic Cars 
this lead us to question do we have over stock

*/

-- what is the moving stocks per year for each warehouse?

SELECT
    p.warehousecode,
       YEAR(o.orderdate) AS YEAR,
       ( ( Sum(od.quantityordered) / Sum(p.quantityinstock) ) * 100 ) AS
       perecent_of_moving_stock
FROM
    products p
JOIN orderdetails od
         ON
    p.productcode = od.productcode
JOIN orders o
         ON
    o.ordernumber = od.ordernumber
GROUP BY
    warehousecode,
          YEAR
ORDER BY
    YEAR,
          warehousecode;
    
    
/*
 
        warehousecode|YEAR|perecent_of_moving_stock|
        -------------+----+------------------------+
        a            |2003|                  0.6635|
        b            |2003|                  0.5870|
        c            |2003|                  0.6499|
        d            |2003|                  1.0410|
        a            |2004|                  0.6594|
        b            |2004|                  0.6048|
        c            |2004|                  0.6662|
        d            |2004|                  1.0069|
        a            |2005|                  0.7279|
        b            |2005|                  0.6666|
        c            |2005|                  0.7031|
        d            |2005|                  1.0271|
        

we got the Same picture which is we need to reduce our stock 

*/    
    
-- so what if analysis  reducing  the stock by 50 % 

SELECT
    p.warehousecode,
       Sum(o.quantityordered)
       AS total_Orders,
       Sum(p.quantityinstock) - ( Sum(p.quantityinstock) * .5 )
       AS total_quantity,
       ( ( Sum(o.quantityordered) / ( Sum(p.quantityinstock) - (
                                        Sum(p.quantityinstock) * .5 ) ) ) * 100
       ) AS
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
        warehousecode|total_Orders|total_quantity|perecent_of_moving_stock|
        -------------+------------+--------------+------------------------+
        d            |       22351|     1093435.5|                  2.0441|
        a            |       24650|     1829776.5|                  1.3472|
        c            |       22933|     1719785.0|                  1.3335|
        b            |       35582|     2922016.5|                  1.2177|

*/

-- How to rearrange the Wahehouses 
-- first let get the numbers in each and what are the capacity ?

WITH groupbywarhouse
     AS (
SELECT
    warehousecode,
                productline,
                Sum(quantityinstock) AS totalQuantity
FROM
    products
GROUP BY
    warehousecode,
                   productline)
SELECT
    *,
       Sum(totalquantity)
         OVER(
           PARTITION BY warehousecode) AS TotalPerWarhouse
FROM
    groupbywarhouse
ORDER BY
    warehousecode,
          productline;
        
        
        
/*
        warehousecode|productline     |totalQuantity|TotalPerWarhouse|
        -------------+----------------+-------------+----------------+
        a            |Motorcycles     |        69401|          131688|
        a            |Planes          |        62287|          131688|
        b            |Classic Cars    |       219183|          219183|
        c            |Vintage Cars    |       124880|          124880|
        d            |Ships           |        26833|           79380|
        d            |Trains          |        16696|           79380|
        d            |Trucks and Buses|        35851|           79380|
*/


-- what are the capacity ?

SELECT
    *
FROM
    warehouses; 
/*
        warehouseCode|warehouseName|warehousePctCap|
        -------------+-------------+---------------+
        a            |North        |72             |
        b            |East         |67             |
        c            |West         |50             |
        d            |South        |75             |

*/

--  What is the maximum number of items that each warehouse can hold?

SELECT
    p.warehouseCode AS code ,
    w.warehouseName AS Name,
    w.warehousePctCap AS Capacity, 
    sum(p.quantityInStock) AS TotalItemInStock,
    round((sum(p.quantityInStock) /(w.warehousePctCap * .01)), 0) AS TotalCapacity,
    round((sum(p.quantityInStock) /(w.warehousePctCap * .01)), 0) - sum(p.quantityInStock) AS EmptyFor
FROM
    products p
JOIN warehouses w 
ON
    p.warehouseCode = w.warehouseCode
GROUP BY
    p.warehouseCode ,
    w.warehouseName,
    w.warehousePctCap 
;

/*
here is the results  quantityInStock

from this we can calculate the items it takes 

        code|Name |Capacity|TotalItemInStock|TotalCapacity|EmptyFor|
        ----+-----+--------+----------------+-------------+--------+
        a   |North|72      |          131688|     182900.0| 51212.0|
        b   |East |67      |          219183|     327139.0|107956.0|
        c   |West |50      |          124880|     249760.0|124880.0|
        d   |South|75      |           79380|     105840.0| 26460.0|
                        
Taking into account the average delivery time Question 7 from EDA file 

            warehousecode|avg_order_shiped|
            -------------+----------------+
            c            |          4.6142|
            a            |          4.2229|
            b            |          4.2101|
            d            |          3.8629|
            
*/

-- ===============================
-- my recommendation
-- ===============================


/*
 
While reducing overall stock by 50% aligns with industry benchmarks and long-term inventory management, 
it's a significant move that requires careful planning and may not be ideal immediately. 
As a more immediate and actionable step, I recommend consolidating the inventory of warehouse D with warehouse C. 
This approach leverages C's ample capacity (124,880 items) to accommodate D's existing inventory (79,380) 
while simplifying operations and potentially reducing costs. 
While C's average daily delivery time is slightly longer than D's (4.6 days vs. 3.8 days), 
this minor trade-off is outweighed by the efficiency gains and cost savings of consolidation. 
This first step can then pave the way for further inventory reductions down the line, 
ensuring a smoother and more strategic approach to optimizing stock levels.
*/



