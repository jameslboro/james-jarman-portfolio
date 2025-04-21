WITH ranked_sales AS (
    SELECT 
        s.Order_ID,
        s.Order_Date,
		s.Units,
		s.State_Province,
        s.Postal_Code,
        s.Customer_ID,
        z.lat AS Customer_Lat,
        z.lng AS Customer_Lng,
        p.Factory,
        f.Latitude AS Factory_Lat,
        f.Longitude AS Factory_Lng,
        3959 * ACOS(
            COS(RADIANS(z.lat)) 
            * COS(RADIANS(f.Latitude)) 
            * COS(RADIANS(f.Longitude) - RADIANS(z.lng)) 
            + SIN(RADIANS(z.lat)) 
            * SIN(RADIANS(f.Latitude))
        ) AS Distance_Miles,
        ROW_NUMBER() OVER (PARTITION BY s.Order_ID ORDER BY s.Order_Date DESC) AS rn
    FROM candy_sales AS s
    LEFT JOIN uszips AS z ON s.Postal_Code = z.zip
    LEFT JOIN candy_products AS p ON s.Product_ID = p.Product_ID
    LEFT JOIN candy_factories AS f ON p.Factory = f.Factory
    WHERE s.Country_Region = 'United States'
)

SELECT *
FROM ranked_sales
WHERE rn = 1;
