# Northwind_Traders_Data_Analysis

(I made data analysis with sql and phyton tools for Northwind Dataset)
![logo](https://github.com/user-attachments/assets/b60bc01c-5312-4724-9e14-0ef4625dedc8)

The Northwind dataset is a classic sample database provided by Microsoft, originally designed to demonstrate database operations like querying, reporting, and data analysis. It simulates the operations of a fictional company called "Northwind Traders," which imports and exports specialty foods globally. The dataset covers the period from 1996 to 1998 and includes comprehensive details about the company's sales, products, suppliers, employees, and customers.

Key Tables in the Northwind Dataset (1996-1998):

Customers:

Contains details about customers, including customer IDs, company names, contact names, addresses, and countries.

![6_Customers](https://github.com/user-attachments/assets/cab3f755-381f-4644-abbb-fb1e9e72d799)

Employees:

Holds information about the employees, such as names, job titles, hire dates, birthdates, and supervisor relationships.

![7_Employees](https://github.com/user-attachments/assets/b1e34ce7-1ce3-48ae-b4fa-8d2674803cdc)


Orders:

Represents orders placed by customers. It includes order IDs, customer IDs, employee IDs (indicating who handled the order), order dates, required shipping dates, shipping methods, and freight costs.

![4_Orders](https://github.com/user-attachments/assets/95770097-6206-4244-9f58-b6f34d0f77e4)

Order Details:

This table breaks down each order into individual products sold. It includes order IDs, product IDs, quantity ordered, unit price, and any discount applied.

Products:

Lists the products available for sale. It includes product names, supplier IDs, category IDs, quantities per unit, unit prices, stock levels, and reorder levels.

![5_Products](https://github.com/user-attachments/assets/e645aeda-63aa-4d79-bb56-be35d4e781c7)


Suppliers:

Provides information on suppliers, including company names, contact names, addresses, and countries.

Categories:

Categorizes products into different categories like beverages, condiments, dairy products, etc.
Shippers:

Contains the shipping methods and details, including company names and contact info.
Territories/Regions:

Represents geographic regions and territories assigned to employees for sales operations.
Invoices:

Summarizes the invoices related to the sales transactions, with detailed information about shipments, freight charges, and tax rates.

Time Period Coverage (1996-1998):
The data reflects transactions from the years 1996 to 1998, showcasing the business operations of Northwind Traders during that time. This period allows users to analyze trends in sales, employee performance, and other business operations over these three years.
The Northwind dataset is popular for practicing SQL queries, performing analysis in data visualization tools, and modeling business intelligence scenarios.

Here's a summary of a potential analysis of the Northwind dataset (1996-1998):

1. Sales Trends:
Sales showed a steady increase from 1996 to 1998, with a significant rise in the fourth quarters due to holiday demand. The top-selling products were beverages and condiments, which consistently contributed the most to revenue.
Key customers came from Europe and North America, accounting for the majority of sales. Germany, the USA, and France were the largest markets.

2. Employee Performance:
Certain employees, especially those handling large accounts in North America and Europe, contributed heavily to the company’s success. Employees like Nancy Davolio and Margaret Peacock had the highest sales volumes.
Sales personnel focusing on repeat customers performed better than those targeting new customer acquisition, indicating strong customer loyalty.

3. Order Analysis:
Reorder frequency for popular items (like beverages) was high, indicating consistent demand, whereas specialty items had less frequent but higher-value orders.
A significant number of orders experienced delays due to shipping issues. On-time deliveries were more frequent with local shippers than international ones.

4. Customer Behavior:
Loyal customers placed larger and more frequent orders, with discounts being a key driver for increasing order size. Customers from countries like Germany and USA were particularly responsive to discounts, leading to higher volumes.
Most orders came from large companies, while smaller firms placed fewer, but higher-value orders.

5. Product Categories:
Beverages were the top-selling category, followed by Condiments and Confections. The company’s focus on perishable goods like dairy products was less profitable due to shorter shelf life and higher shipping costs.
Products with the highest profit margins were specialty items, like exotic cheeses and regional delicacies, which had lower volume but higher unit prices.

6. Supplier Relationships:
Key suppliers were from countries like the USA, Italy, and Japan. Long-term partnerships with reliable suppliers ensured steady stock for top-selling products.
Some suppliers were more prone to shipping delays, which affected order fulfillment. This highlighted the need for a diversified supplier base.

7. Shipping and Freight:
Shippers like Speedy Express and United Package had better on-time performance records, while Federal Shipping faced delays, particularly on international routes.
Freight costs significantly impacted profit margins on lower-priced goods. The company’s reliance on air freight for perishables contributed to higher costs.

8. Regional Analysis:
The European market showed the highest growth, especially in Germany and France, while North America remained the largest revenue contributor.
Sales in South America were minimal, suggesting a potential market expansion opportunity.

9. Profitability:
Products with a higher unit price and lower shipping costs contributed the most to profitability. Discounted sales, although they drove volume, led to thinner margins in some regions.
The company could improve profitability by optimizing shipping methods and exploring alternative suppliers to reduce costs.
