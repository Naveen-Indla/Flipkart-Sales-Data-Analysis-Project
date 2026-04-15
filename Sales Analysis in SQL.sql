use taks_database;
/* 1.Top Selling Products */
SELECT Product_ID, SUM(Sales) AS Total_Sales
FROM sales_data
GROUP BY Product_ID
ORDER BY Total_Sales DESC;

/* 2. Top 10 Products by Total Sales */
SELECT Product_ID,Category, SUM(Sales) AS Total_Sales
FROM sales_data
GROUP BY Product_ID , Category
ORDER BY Total_Sales DESC
LIMIT 10;

/* 3.Monthly Revenue Trend */
SELECT 
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Sales) AS Monthly_Sales
FROM sales_data
GROUP BY Year, Month
ORDER BY Year, Month;

/* 4.Monthly Sales in(2023 to 2024)*/
SELECT 
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Sales) AS Monthly_Sales
FROM sales_data
WHERE YEAR(Order_Date) IN (2023, 2024)
GROUP BY Year, Month
ORDER BY Year, Month;

/* 5. Category Profit Analysis */
SELECT 
    Category,
    SUM(Profit) AS Total_Profit
FROM sales_data
GROUP BY Category
ORDER BY Total_Profit DESC;
/* 6. Compute total profit and profit margin for each product category.*/
SELECT 
    Category,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM sales_data
GROUP BY Category;

/* 7. Customer Repeat Purchases */
SELECT 
    Customer_ID,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM sales_data
GROUP BY Customer_ID
ORDER BY Total_Orders DESC;
 
/* 8. Identify customers who made more than 3 orders in the 2-year period.*/
SELECT 
    Customer_ID,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM sales_data
WHERE YEAR(STR_TO_DATE(Order_Date, '%Y-%m-%d')) IN (2023, 2024)
GROUP BY Customer_ID
HAVING Total_Orders > 3;

/*9. High Discount Products */
SELECT 
    Product_ID,
    Discount
FROM sales_data
WHERE Discount > 0.15;

/* 10. Find products with discounts greater than 15% and their total sales. */
SELECT 
    Product_ID,
    SUM(Sales) AS Total_Sales
FROM sales_data
WHERE Discount > 0.15
GROUP BY Product_ID
ORDER BY Total_Sales DESC;

/* 11. Region-wise Sales */
SELECT 
    Region,
    SUM(Sales) AS Total_Sales
FROM sales_data
GROUP BY Region
ORDER BY Total_Sales DESC;

/* 12. Show total sales and average profit for each region. */
SELECT 
    Region,
    SUM(Sales) AS Total_Sales,
    AVG(Profit) AS Avg_Profit
FROM sales_data
GROUP BY Region;

/* 13. Top Performing Brands */
SELECT 
    Brand,
    SUM(Sales) AS Total_Sales
FROM sales_data
GROUP BY Brand
ORDER BY Total_Sales DESC;
 
/* 14. List  top 5 brands by revenue in each category. */
SELECT *
FROM (
    SELECT 
        Category,
        Brand,
        SUM(Sales) AS Total_Sales,
        RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS rnk
    FROM sales_data
    GROUP BY Category, Brand
) ranked
WHERE rnk <= 5;

/* 15. Payment Mode Analysis */
SELECT 
    Payment_Mode,
    SUM(Sales) AS Total_Sales
FROM sales_data
GROUP BY Payment_Mode
ORDER BY Total_Sales DESC;

/* 16. Determine which payment mode contributed most to total sales. */
SELECT 
    Payment_Mode,
    SUM(Sales) AS Total_Sales
FROM sales_data
GROUP BY Payment_Mode
ORDER BY Total_Sales DESC
LIMIT 1;

/* 17. Orders With Rating < 3 */
SELECT *
FROM sales_data
WHERE Rating < 3;

/* 18. Retrieve all products where average customer rating is less than 3. */
SELECT 
    Product_ID,
    AVG(Rating) AS Avg_Rating
FROM sales_data
GROUP BY Product_ID
HAVING Avg_Rating < 3;

/*19. Year-over-Year Growth */
SELECT 
    MONTH(STR_TO_DATE(Order_Date, '%Y-%m-%d')) AS Month,
    SUM(CASE 
        WHEN YEAR(STR_TO_DATE(Order_Date, '%Y-%m-%d')) = 2023 
        THEN Sales ELSE 0 END) AS Sales_2023,
    SUM(CASE 
        WHEN YEAR(STR_TO_DATE(Order_Date, '%Y-%m-%d')) = 2024 
        THEN Sales ELSE 0 END) AS Sales_2024
FROM sales_data
GROUP BY Month
ORDER BY Month;

/* 20. Compare total sales of 2023 vs 2024 by month. */
SELECT 
    MONTH(STR_TO_DATE(Order_Date, '%Y-%m-%d')) AS Month,
    ROUND(
        ((SUM(CASE WHEN YEAR(STR_TO_DATE(Order_Date, '%Y-%m-%d')) = 2024 THEN Sales ELSE 0 END) -
          SUM(CASE WHEN YEAR(STR_TO_DATE(Order_Date, '%Y-%m-%d')) = 2023 THEN Sales ELSE 0 END)) /
          SUM(CASE WHEN YEAR(STR_TO_DATE(Order_Date, '%Y-%m-%d')) = 2023 THEN Sales ELSE 0 END)) * 100,
    2) AS YoY_Growth_Percent
FROM sales_data
GROUP BY Month
ORDER BY Month;
