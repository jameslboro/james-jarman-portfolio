CREATE VIEW vw_sales_profitability_analysis AS
SELECT 
    FORMAT(s.Order_Date, 'yyyy-MM') AS Year_Month,
    p.Division,
    p.Product_Name,
    SUM(s.Units) AS Total_Units_Sold,
    SUM(s.Units * p.Unit_Price) AS Total_Revenue,
    SUM(s.Units * p.Unit_Cost) AS Total_Cost,
    SUM(s.Units * (p.Unit_Price - p.Unit_Cost)) AS Gross_Profit
FROM dbo.candy_sales s
LEFT JOIN dbo.candy_products p
    ON s.Product_ID = p.Product_ID
GROUP BY 
    FORMAT(s.Order_Date, 'yyyy-MM'),
    p.Division,
    p.Product_Name;