## Exploratory: Revenue Discrepancy Checks

To validate consistency across tables (`payments` vs. `order_items`), multiple revenue calculations were compared.

### Findings
Revenue calculations using the `payments` table were consistently higher than those using the `order_items` table:

| Year | Revenue (Payments) | Revenue (Order Items) | Difference |
|------|---------------------|------------------------|------------|
| 2016 | R$47,969.31         | R$47,958.99            | +R$10.32   |
| 2017 | R$7,001,143.26      | R$6,999,771.36         | +R$1,371.90|
| 2018 | R$8,550,563.16      | R$8,549,172.74         | +R$1,390.42|

These discrepancies persisted even after cleaning the dataset to include only orders with valid matches across `orders`, `payments`, and `order_items`.

> Despite aligning on order status and filtering for completeness, `payments` and `order_items` produced different total revenues. Given the nature of the `payments` table as the financial source of truth, it was chosen as the authoritative revenue reference for this section.

---

### Data Consistency Checks

Performed validation across key tables to identify:

- **Orders without payments:**  
  One order (`bfbd0f9bdef84302105ad712db648a6c`) was found with valid order items and a `delivered` status but no payment record.

- **Orders without order items:**  
  775 orders lacked entries in the `order_items` table. These spanned statuses such as:
  - `canceled`
  - `created`
  - `invoiced`
  - `shipped`
  - `unavailable`

- **Inconsistent data points:**
  - `orders`: 99,441  
  - `payments`: 99,440  
  - `order_items`: 98,666  

These inconsistencies are relatively low in volume but significant enough to affect aggregate revenue totals.

---

### Cleaned Revenue Calculations

Used a CTE to filter only valid, fully matched orders across all relevant tables and re-ran revenue calculations:

| Year | Cleaned Revenue (Payments) | Cleaned Revenue (Order Items) | Difference |
|------|-----------------------------|-------------------------------|------------|
| 2016 | R$47,891.58                 | R$47,815.53                   | +R$76.05   |
| 2017 | R$7,001,143.26              | R$6,999,771.36                | +R$1,371.90|
| 2018 | R$8,550,563.16              | R$8,549,172.74                | +R$1,390.42|

### Insight

Although revenue alignment improved with cleaned joins, discrepancies still remained. The persistent gaps reinforced the choice to use the `payments` table as the revenue source of truth due to its completeness, consistency, and financial integrity.

---

## Conclusion

The `payments` table was adopted as the source of truth for all revenue and AOV-related metrics due to more consistent alignment and financial relevance. Minor anomalies in order data highlighted the importance of careful joins and validation across relational tables during analysis.