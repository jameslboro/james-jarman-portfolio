# Analysing Target E-Commerce in Brazil

This project investigates key performance and operational insights from a Brazilian e-commerce dataset using SQL queries. The goal is to address business-relevant questions by analysing orders, payments, products, customers, and more.

---

## Contents

1. [Data Sources](#data-sources)  
2. [Sales Analysis](#1-sales-analysis)  
3. [Customer Behaviour](#2-customer-behaviour)  
4. [Logistics and Shipping Performance](#3-logistics-and-shipping-performance)  
5. [Product Insights](#4-product-insights)  
6. [Payment Behaviour](#5-payment-behaviour)  
7. [Geospatial and Regional Insights](#6-geospatial-and-regional-insights)  

---

## Data Sources

All analysis was performed on the `target_ecommerce` schema. The tables used include:

- `orders`
- `order_items`
- `payments`
- `products`
- `customers`
- `sellers`
- `geolocations`

For a full breakdown of the schema and relationships, refer to the [data dictionary](./data_dictionary.md) and the [Entity Relationship Diagram (ERD)](./erd/erd.png).

---

## 1. Sales Analysis

This section addresses key revenue and performance metrics by exploring the payments, orders, and order_items tables.

**Full SQL script for all Sales Analysis questions can be found [here](.\sql\01_sales_analysis.sql).**

---

### Question 1: What is the total revenue generated per year and per month?

**Insight:**  
Revenue increased significantly from 2016 to 2018; however, it is important to note that the data only covers **3 months of 2016** and **the first 9 months of 2018**, making **2017 and 2018 the most complete and comparable years**.  

- In **2017**, the platform generated approximately **R$7.00 million** in revenue.  
- In **2018** (with only 9 months of data), revenue rose to **R$8.55 million**, indicating continued growth.  
- Monthly revenue trends show consistent increases throughout 2017 and strong performance in early to mid-2018.  
- Notable spikes in revenue occurred in **November 2017** and **March–May 2018**, possibly due to seasonal promotions or campaigns.

**Visualisation:**  
![01_monthly_revenue_trend](./visualisations\01_monthly_revenue_trend.png)

---

### Question 2: Which months show the highest and lowest sales performance?

**Insight:**  
The month with the highest sales performance was **November 2017**, generating approximately **R$1.16 million** in revenue, likely reflecting major seasonal promotions or holiday sales.  
The lowest sales month was **December 2016**, with just **R$19.62** in revenue, which aligns with the limited data coverage for 2016 and suggests incomplete or minimal sales activity during that period.  
These extremes highlight the importance of considering data coverage when interpreting monthly performance trends.

---

### Question 3: Which product categories generate the most revenue?

**Insight:**  
The top product categories by revenue highlight key drivers of sales on the platform:  
- **Health & Beauty** leads with approximately **R$1.43 million**, indicating strong consumer demand in personal care.  
- **Watches & Presents** and **Bed, Table & Bath** categories follow closely, each generating over **R$1.2 million** in revenue.  
- Other high-performing categories include **Sport & Leisure** and **Computer Accessories**, reflecting diverse customer interests.  
- Revenue gradually declines across numerous smaller categories, illustrating a long tail of niche or lower-selling products.  

This distribution suggests focusing marketing and inventory efforts on the top categories could maximise revenue, while also exploring growth potential in mid-tier categories.

**Visualisation:**  
![01_revenue_by_top20_product_categories](.\visualisations\01_revenue_by_top20_product_categories.png)

---

### Question 4: What is the average order value (AOV) per state?

**Insight:**  
The average order value varies significantly across states:  
- States like **Paraíba (PB)**, **Acre (AC)**, and **Amapá (AP)** top the list with AOVs above **R$230**, indicating higher spending per order in these regions.  
- The majority of other states fall in the **R$150–R$220** range, showing moderate average spending.  
- Notably, **São Paulo (SP)**, despite being a major economic hub, has a relatively lower AOV (~**R$136**), which could be influenced by a larger volume of smaller orders or diverse customer segments.  

This variation may reflect regional differences in consumer behavior, purchasing power, or product preferences. It could inform targeted marketing strategies or tailored promotions by state.

**Visualisation:**  
![01_average_order_value](.\visualisations\01_average_order_value.png)

<!-- ---

### Exploratory: Revenue Discrepancy Checks

To validate consistency across tables (`payments` vs. `order_items`), multiple revenue calculations were compared.

**Findings:**  
_(Note whether discrepancies exist and the decision made on which table to use for analysis.)_

**Suggested Commentary:**  
> Despite aligning on order status and filtering for completeness, `payments` and `order_items` produced different total revenues. Given the nature of the `payments` table as the financial source of truth, it was chosen as the authoritative revenue reference for this project.

---

#### Data Consistency Checks

Performed validation across key tables to identify:

- Orders without payments
- Orders without items
- Inconsistent statuses for such cases

**Summary of Issues:**  
_(List any anomalies found. Include number of mismatches or examples, if necessary.)_

---

#### Cleaned Revenue Calculations

Used a CTE to filter only valid, fully matched orders across all relevant tables and re-ran revenue calculations.

**Insight:**  
_(Note if revenue alignment improved and whether the final method influenced results.)_

---

### Conclusion

The payments table was adopted as the source of truth for all revenue and AOV-related metrics due to more consistent alignment and financial relevance.

---

## 2. Customer Behaviour

This section investigates customer distribution, repeat buying behaviour, and high-value customer segmentation to uncover trends that can guide marketing and retention strategies.

**Full SQL script for all Customer Behaviour questions can be found [here](.\sql\02_customer_analysis.sql).**

---

### Question 5: Which states or cities have the highest number of unique customers?

**Insight:**  
_(To be filled after reviewing query results. Example: São Paulo has the largest customer base, followed by Rio de Janeiro and Minas Gerais.)_

**Suggested Visualisations:**  
Bar chart of unique customers by state  
Highlight map or label showing the top customer city

---

### Question 6: What is the repeat purchase rate of customers?

**Insight:**  
_(To be filled after reviewing query results. Example: Approximately 16.4% of customers placed more than one order.)_

**Suggested Visualisations:**  
Pie chart or donut chart showing repeat vs. one-time customers

---

### Question 7: How many customers place multiple orders and how often?

**Insight:**  
_(To be filled after reviewing query results. Example: Most repeat customers placed 2–3 orders, with a long tail distribution.)_

**Suggested Visualisations:**  
Histogram or bar chart showing how many customers made 2, 3, 4, ... N orders

---

### Question 8: Do high-value customers (top 10%) behave differently from others?

**Insight:**  
_(To be filled after reviewing query results. Example: High-value customers placed 3.2 times more orders and spent 4.5 times more on average.)_

**Suggested Visualisations:**  
Side-by-side bar charts showing average orders and spend for high-value vs. others  
Box plot to visualise spending distribution across segments

---

### Section 2: Key Takeaways

- Major customer concentration is seen in a handful of key states and metropolitan cities.
- Repeat purchase behaviour is present but not dominant; there is opportunity to increase retention.
- High-value customers exhibit significantly stronger engagement metrics and should be a focus for loyalty initiatives.

---

## 3. Logistics and Shipping Performance

This section examines delivery efficiency, regional shipping delays, and how geographic distance impacts delivery timeliness — key for improving operational logistics.

**Full SQL script for all Logistics and Shipping Performance questions can be found [here](.\sql\03_logistics_and_shipping_analysis.sql).**

---

### Question 9: What is the average delivery time across different states?

**Insight:**  
_(To be filled after reviewing query results. Example: Southern states such as São Paulo and Rio de Janeiro experience faster delivery times compared to more remote states.)_

**Suggested Visualisations:**  
Bar chart ranking states by average delivery time  
Choropleth map highlighting state-level differences

---

### Question 10: Which regions experience the longest delivery delays?

**Insight:**  
_(To be filled after reviewing query results. Example: Northern and interior states show the most significant delays relative to the estimated delivery date.)_

**Suggested Visualisations:**  
Descending bar chart of average delivery delays by state  
Colour-coded scheme to highlight problematic regions

---

### Question 11: Is there a relationship between shipping distance and delivery delay?

**Insight:**  
_(To be filled after reviewing query results. Example: There is a clear positive correlation between shipping distance and delivery delay, especially beyond 1,000 km.)_

**Suggested Visualisations:**  
Line chart or scatter plot showing average delay vs. distance bucket  
Histogram to show order volume by distance bucket

---

### Section 3: Key Takeaways

- Delivery speed and reliability vary significantly by state, highlighting the need for region-specific logistics strategies.
- Remote regions face consistently higher delays, likely due to infrastructure and fulfilment challenges.
- Distance is a strong predictor of delivery performance and should inform warehouse placement and service level agreements.

---

## 4. Product Insights

This section explores key product-level dynamics, including return trends, freight costs, and physical product characteristics, to better understand inventory, fulfilment, and shipping drivers.

**Full SQL script for all Product Insights questions can be found [here](.\sql\04_product_analysis.sql).**

---

### Question 12: Which products or categories have the highest return rate (undelivered or cancelled)?

**Insight:**  
_(To be filled after reviewing query results. Example: Categories such as fashion or electronics may have higher return/cancellation rates, suggesting potential issues with fit, description accuracy, or logistics.)_

**Suggested Visualisations:**  
Bar charts showing top product categories by return rate  
Heatmap correlating product types with cancellation/unavailability patterns

---

### Question 13: Are certain product categories more associated with high freight costs?

**Insight:**  
_(To be filled after reviewing query results. Example: Furniture and home appliances consistently rank highest in shipping costs, indicating heavier or bulkier stock keeping units.)_

**Suggested Visualisations:**  
Bar chart of categories by average freight cost  
Bubble chart combining freight cost and order volume per category

---

### Question 14: Which products have the highest weight or dimensional volume?

**Insight:**  
_(To be filled after reviewing query results. Example: The bulkiest products are concentrated in home and lifestyle categories, affecting logistics and storage needs.)_

**Suggested Visualisations:**  
Tables of top 10 products by weight and volume  
Side-by-side bar charts comparing volume and weight distribution by category

---

### Section 4: Key Takeaways

- Return rates vary by product and category — these insights can guide improvements in product descriptions, quality, and expectations.
- High freight costs tend to align with large or heavy items, influencing pricing strategies and shipping policies.
- Identifying physically large or heavy products enables smarter warehouse planning and shipping optimisations.

---

## 5. Payment Behaviour

This section examines how customers pay — from preferred methods by geography and segment, to instalment patterns and revenue implications — enabling more tailored payment and financing strategies.

**Full SQL script for all Payment Behaviour questions can be found [here](.\sql\05_payment_analysis.sql).**

---

### Question 15: What are the most commonly used payment types by state or customer segment?

**Insight:**  
_(To be filled after reviewing results. Example: Credit cards dominate in most urban states, while boleto bancário is more prevalent in rural regions or among one-time shoppers.)_

**Suggested Visualisations:**  
Choropleth map of payment type popularity by state  
Stacked bar chart comparing payment types across segments

---

### Question 16: What is the average instalment plan length for orders by value or category?

**Insight:**  
_(To be filled after reviewing results. Example: High-value items tend to be split into longer instalment plans, especially in electronics and furniture categories.)_

**Suggested Visualisations:**  
Grouped bar chart for instalment count vs. order value segment  
Category-level heatmap of average instalment duration

---

### Question 17: How much revenue is coming from instalment payments vs upfront?

**Insight:**  
_(To be filled after reviewing results. Example: Instalment payments make up over 60% of revenue, underlining the importance of financing options in customer purchasing behaviour.)_

**Suggested Visualisations:**  
Pie chart or donut chart of revenue split by payment type  
Bar chart comparing revenue and volume for each group

---

### Section 5: Key Takeaways

- Regional preferences in payment methods can inform localised marketing and checkout flows.
- Instalment usage scales with order value and product category, offering clues for embedded financing strategies.
- A significant share of revenue may be tied to instalment-based purchases, making it a critical lever for growth and customer conversion.

---

## 6. Geospatial and Regional Insights

This section uncovers how geography influences e-commerce performance — including where orders are concentrated and whether rural or urban areas face longer delivery times.

**Full SQL script for all Geospatial and Regional Insights questions can be found [here](.\sql\06_geospatial_and_regional_analysis.sql).**

---

### Question 18: What is the distribution of orders across Brazilian states?

**Insight:**  
_(To be filled after reviewing results. Example: The majority of orders come from south-eastern states like São Paulo and Rio de Janeiro, aligning with population and urbanisation patterns.)_

**Suggested Visualisations:**  
Map of Brazil by state with order volume  
Horizontal bar chart ranking states by order count

---

### Question 19: Do rural or urban areas tend to have longer delivery times?

**Insight:**  
_(To be filled after reviewing results. Example: Rural areas experience delivery times 1.5 days longer on average, likely due to lower logistics density and greater distances.)_

**Suggested Visualisations:**  
Side-by-side bar chart comparing average delivery times for urban vs. rural  
Map overlay with urban/rural segmentation and delivery delays

---

### Section 6: Key Takeaways

- Order volume is heavily concentrated in a few states, reflecting Brazil’s urban demographics and economic hubs.
- Rural locations are linked with longer delivery times, which may warrant differentiated logistics strategies or clearer expectations.

--- -->
