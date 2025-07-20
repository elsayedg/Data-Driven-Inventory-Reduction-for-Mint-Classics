
-- Query to get Trend Data 

SELECT p.warehousecode,
       p.productline,
       Year(o.orderdate)       AS year,
       Month(o.orderdate)      AS month,
       Sum(od.quantityordered) AS total_items_ordered
FROM   products p
       JOIN orderdetails od
         ON p.productcode = od.productcode
       JOIN orders o
         ON o.ordernumber = od.ordernumber
GROUP  BY p.warehousecode,
          p.productline,
          year,
          month
ORDER  BY year,
          month;
