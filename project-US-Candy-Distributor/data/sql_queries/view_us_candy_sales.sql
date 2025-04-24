DROP VIEW IF EXISTS grouped_candy_sales;
GO

CREATE VIEW grouped_candy_sales AS
SELECT Order_ID,
       MIN(Order_Date) AS Order_Date,
       MIN(Ship_Date) AS Ship_Date,
       MIN(Ship_Mode) AS Ship_Mode,
       MIN(Customer_ID) AS Customer_ID,
       MIN(Country_Region) AS Country_Region,
       MIN(City) AS City,
       MIN(State_Province) AS State_Province,
       MIN(Postal_Code) AS Postal_Code,
       MIN(Division) AS Division,
       MIN(Region) AS Region,
       MIN(Product_ID) AS Product_ID,
       MIN(Product_Name) AS Product_Name,
       SUM(Sales) AS Sales,
       SUM(Units) AS Units_Sold,
       SUM(Gross_Profit) AS Gross_Profit,
       SUM(Cost) AS Cost
FROM dbo.candy_sales
WHERE Country_Region = 'United States'
GROUP BY Order_ID;