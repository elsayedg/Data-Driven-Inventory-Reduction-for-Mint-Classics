# Data-Driven Inventory Reduction for Mint Classics

**Harnessing the power of data to optimize warehouse storage and streamline operations.**

This project dives into the world of inventory management and data-driven decision-making, showcasing how a fictional retailer of classic model cars, Mint Classics, can leverage insights from a relational database to make strategic inventory decisions.

**Key Project Steps:**

- **Exploratory Data Analysis:** 
  - will be found in this script [EDA Link](https://github.com/elsayedg/Data-Driven-Inventory-Reduction-for-Mint-Classics/blob/main/EDA_Script.sql)
  - After ensuring data quality, I used these questions to investigate the data.
    - 1- How many products are stored in each warehouse?
    - 2- How many items did each warehouse serve?
    - 3- What is the percentage of moving stock for each warehouse?
    - 4- How much time does it usually take to deliver an order?
    - 5- Outlier investigation
    - 6- How much earlier than usual do we typically deliver orders?
    - 7- What is the average delivery time (in days) for each warehouse?
    - 8- What types of products are stored in each warehouse?
    - 9-What subcategories do each of the products belong to?
    - 10-Where does the majority of our customer base reside?

- **Data Visulizations:**
  - To get better feel of Data i used this [Query](https://github.com/elsayedg/Data-Driven-Inventory-Reduction-for-Mint-Classics/blob/main/Source/Trend%20Data%20Script.sql) to get the data .
  - Then Excle [link to the file](https://github.com/elsayedg/Data-Driven-Inventory-Reduction-for-Mint-Classics/blob/main/Source/Trend.xlsx) to make this viz.
    - ![alt text](https://github.com/elsayedg/Data-Driven-Inventory-Reduction-for-Mint-Classics/blob/main/Source/1-%20items_trend.png)
    - ![alt text](https://github.com/elsayedg/Data-Driven-Inventory-Reduction-for-Mint-Classics/blob/main/Source/2-%20Items_per_year.png)
    - ![alt text](https://github.com/elsayedg/Data-Driven-Inventory-Reduction-for-Mint-Classics/blob/main/Source/3-%20Warehouse_trend.png)

- **Targeted Insights:**
  - In this [Script](https://github.com/elsayedg/Data-Driven-Inventory-Reduction-for-Mint-Classics/blob/main/Analysis_Script.sql) the analyis leverage the past steps and answer these queation .
    - 1- what is the moving stocks per year for each warehouse?
    - 2- what if analysis: reducing the stock by 50 %
    - 3- How to rearrange the Wahehouses?
    - 4- what are the capacity?
    - 5- Making the calculations
    - 6- the Recommendations 

- **Recommendation:** <br>
    While reducing overall stock by 50% aligns with industry benchmarks and long-term inventory management, <br>
    it's a significant move that requires careful planning and may not be ideal immediately. 
    As a more immediate and actionable step,<br> I recommend consolidating the inventory of warehouse D with warehouse C. 
   <br> This approach leverages C's ample capacity (124,880 items) to accommodate D's existing inventory (79,380) 
    while simplifying operations and potentially reducing costs. <br>
    While C's average daily delivery time is slightly longer than D's (4.6 days vs. 3.8 days), <br>
    this minor trade-off is outweighed by the efficiency gains and cost savings of consolidation. <br>
    This first step can then pave the way for further inventory reductions down the line, 
    ensuring a smoother and more strategic approach to optimizing stock levels.

- **Tools and Technologies:**
  - MySQL Workbench
  - SQL queries
  - Data visualization (Excel - Pivot tables)

**Project Objectives:**

1. Explore current inventory composition and trends.
2. Determine critical factors influencing inventory management.
3. Provide actionable insights and recommendations for inventory reduction and optimization.
4. Support a data-driven decision-making process for potential warehouse closure.

**Audience:**

- Data analysts
- Inventory management professionals
- Business decision-makers interested in data-driven optimization
- Anyone exploring SQL for data analysis and business problem-solving"
