use pizza;
-- Retrieve the  total number of orders placed
 select count('order_id') from orders;
 -- output=21350
-- Calculate the total revenue generated from pizza sales.pizzas
select sum(pizzas.price*order_details.quantity) from pizzas right outer join order_details on(pizzas.pizza_id=order_details.pizza_id);
-- output-817860.049999993

-- Identify the highest-priced pizza
select * from pizza_types;
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        RIGHT OUTER JOIN
    pizzas ON (pizzas.pizza_type_id = pizza_types.pizza_type_id)
ORDER BY pizzas.price DESC;
-- output-The Greek Pizza	35.95

-- Identify the most common pizza size ordered.
select *from order_details;
SELECT 
    pizzas.size,count(order_details.order_details_id)
FROM
    pizzas
        LEFT OUTER JOIN
    order_details ON (pizzas.pizza_id =order_details.pizza_id) group by pizzas.size;
-- output
-- L	18526
-- M	15385
-- S	14137
-- XL	544
-- XXL	28

-- List the top 5 most ordered pizza types along with their quantities.
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
-- output-
-- The Classic Deluxe Pizza	    2453
-- The Barbecue Chicken Pizza	2432
-- The Hawaiian Pizza	        2422
-- The Pepperoni Pizza	        2418
-- The Thai Chicken Pizza	    2371

-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category, SUM(order_details.quantity) AS quantity
FROM
    pizzas
        JOIN
    pizza_types ON (pizzas.pizza_type_id = pizza_types.pizza_type_id)
        JOIN
    order_details ON (order_details.pizza_id = pizzas.pizza_id)
GROUP BY pizza_types.category
ORDER BY quantity DESC;
-- output
-- Classic	14888
-- Supreme	11987
-- Veggie	11649
-- Chicken	11050

-- Determine the distribution of orders by hour of the day.

select hour(time),count(order_id) from orders group by hour(time) order by  count(order_id);
-- output-
-- 11	1231
-- 12	2520
-- 13	2455
-- 14	1472
-- 15	1468
-- 16	1920
-- 17	2336
-- 18	2399
-- 19	2009
-- 20	1642
-- 21	1198
-- 22	663
-- 23	28
-- 10	8
-- 9	1

-- Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) from pizza_types group by category;

-- output-
-- Chicken	6
-- Classic	8
-- Supreme	9
-- Veggie	9

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quant), 0)
FROM
    (SELECT 
        orders.date, SUM(order_details.quantity) as quant
    FROM
        orders
    JOIN order_details ON (orders.order_id = order_details.order_id)
    GROUP BY orders.date) as quaty;
-- output
-- 2015-01-01	162
-- 2015-01-02	165
-- 2015-01-03	158
-- 2015-01-04	106
-- 2015-01-05	125
-- 2015-01-06	147

-- 138(average pizzas)

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS quant
FROM
    pizzas
        JOIN
    pizza_types ON (pizza_types.pizza_type_id = pizzas.pizza_type_id)
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY quant DESC
LIMIT 3;
-- output
-- The Thai Chicken Pizza	       43434.25
-- The Barbecue Chicken Pizza	   42768
-- The California Chicken Pizza   41409.5

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    (SUM(order_details.quantity * pizzas.price)/(select sum(order_details.quantity*pizzas.price) from 
    order_details join pizzas on order_details.pizza_id=pizzas.pizza_id))*100 AS quant
FROM
    pizzas
        JOIN
    pizza_types ON (pizza_types.pizza_type_id = pizzas.pizza_type_id)
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY quant DESC;

-- output
-- Classic	26.905960255669903
-- Supreme	25.45631126009884
-- Chicken	23.955137556847493
-- Veggie	23.682590927384783

-- Analyze the cumulative revenue generated over time.
select date,sum(revenue_each_day) over(order by date) as cumulative_revenue from
(SELECT orders.date,round(sum(order_details.quantity*pizzas.price)) as revenue_each_day from order_details join 
orders on order_details.order_id=orders.order_id
join pizzas on order_details.pizza_id=pizzas.pizza_id group by orders.date) as revenue;

-- output-
-- 2015-01-01	2714
-- 2015-01-02	5446
-- 2015-01-03	8108
-- 2015-01-04	9863
-- 2015-01-05	11929
-- 2015-01-06	14358
-- 2015-01-07	16560
-- 2015-01-08	19398


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name,revenue,rn from
(select name,category,revenue,rank() over(partition by category order by revenue ) as rn from
(SELECT 
    pizza_types.category,pizza_types.name,
    SUM(pizzas.price * order_details.quantity) as revenue
FROM
    pizzas
        JOIN
    pizza_types ON (pizza_types.pizza_type_id = pizzas.pizza_type_id)
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category,pizza_types.name
ORDER BY revenue DESC) as a) as b where rn<4;

-- output-
-- The Chicken Pesto Pizza	Chicken	                    16701.75	1
-- The Chicken Alfredo Pizza	Chicken	                16900.25	2
-- The Southwest Chicken Pizza	Chicken	                34705.75	3
-- The California Chicken Pizza	Chicken	            41409.5	    4
-- The Barbecue Chicken Pizza	Chicken	                42768	    5
-- The Thai Chicken Pizza	Chicken	                    43434.25	6
-- The Pepperoni, Mushroom, and Peppers Pizza	Classic	18834.5	    1
-- The Big Meat Pizza	Classic	                        22968	    2
-- The Napolitana Pizza	Classic	                    24087	    3
-- The Italian Capocollo Pizza	Classic             	25094	    4
-- The Greek Pizza	Classic	                            28454.10	5
-- The Pepperoni Pizza	Classic							30161.75	6
-- The Hawaiian Pizza	Classic							32273.25	7
-- The Classic Deluxe Pizza	Classic					38180.5		8
-- The Brie Carre Pizza	Supreme						11588.499	1
-- The Spinach Supreme Pizza	Supreme					15277.75	2
-- The Calabrese Pizza	Supreme							15934.25	3
-- The Soppressata Pizza	Supreme						16425.75	4
-- The Prosciutto and Arugula Pizza	Supreme			24193.25	5
-- The Pepper Salami Pizza	Supreme						25529	    6
-- The Sicilian Pizza	Supreme							30940.5	    7
-- The Italian Supreme Pizza	Supreme					33476.75	8
-- The Spicy Italian Pizza	Supreme						34831.25	9
-- The Green Garden Pizza	Veggie						13955.75	1
-- The Mediterranean Pizza	Veggie						15360.5 	2
-- The Spinach Pesto Pizza	Veggie						15596   	3
-- The Italian Vegetables Pizza	Veggie				    16019.25	4
-- The Spinach and Feta Pizza	Veggie					23271.25	5
-- The Vegetables + Vegetables Pizza Veggie			    24374.75	6
-- The Five Cheese Pizza	Veggie	                    26066.5 	7
-- The Mexicana Pizza	Veggie							26780.75	8
-- The Four Cheese Pizza	Veggie						32265.7000	9
SELECT 
        orders.date, SUM(order_details.quantity) as quant
    FROM
        orders
    JOIN order_details ON (orders.order_id = order_details.order_id)
    GROUP BY orders.date;
