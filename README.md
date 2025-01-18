## Pizza-sales-analysis-
SQL data analytics project analyzinng pizza sales data to gain insights into customer behavior,top_selling items and revenue trends
## Project overview
This project uses **sql query** to analyze pizza sales data,clean datasets and extract key insights.The final results are visualized using **Tableau**
## Dataset
**Sources**
[Pizza-sales-analysis](https://github.com/Ayushi0214/pizza-sales---SQL/blob/main/pizza_sales.zip)
### SQL Queries
**Key SQL techniques used:**
1.Aggregate functions
2.Joins
3.Window functions(rank())
## Key insights of pizza sales
 Refer to [Pizza sales insights report](insights.md)
## Sample Query -Top 5 Best-selling Pizzas
List the top 5 most ordered pizza types along with their quantities.

Query:
SELECT 
    pizza_types.name, sum(order_details.quantity) AS max_quant
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY max_quant DESC
LIMIT 5;

