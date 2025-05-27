SELECT	Order_ID,
		MIN(Order_Date) AS Order_Date,
		MIN(Customer_ID) AS Customer_ID,
		MIN(Division) AS Division,
		MIN(Product_Name) AS Product_Name,
		SUM(Units) AS Units_Sold,
		SUM(Cost) AS Cost,
		SUM(Sales) AS Sales,
		SUM(Gross_Profit) AS Gross_Profit
FROM dbo.candy_sales
GROUP BY Order_ID;