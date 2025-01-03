use new_schema;
--- 1. How many customers do we have each day? Are there any peak hours?
select avg(total_cust)
from(SELECT date, count(order_id) as total_cust
from orders
group by date) a;
select extract(HOUR FROM time) as hourday, count(order_id)as totalcust
from orders
group by hourday
order by totalcust desc;
--- 2. How many pizzas are typically in an order? Do we have any bestsellers?
select order_id, avg(quantity)
from order_details
group by order_id;
select pizza_id, sum(quantity) as totalunitsold
from order_details
group by pizza_id
order by totalunitsold desc
limit 5;
--- 3. How much money did we make this year in each month? Can we identify any seasonality in the sales?
select monthname(date) as month,sum(od.quantity*p.price) as revenue
from orders o
inner join order_details od
on o.order_id=od.order_id
inner join pizzas p
on od.pizza_id=p.pizza_id
group by month
order by revenue desc;
--- 4. Are there any pizzas we should take off the menu, or any promotions we could leverage?
select pizza_id,sum(quantity) as totalunitsold
from order_details
group by pizza_id
order by totalunitsold asc;
--- 5. What is the average order value for each pizza category (e.g., Vegetarian, Non-Vegetarian, etc.)?
SELECT p.category, AVG(od.quantity * pz.price) AS avg_order_value
FROM pizza_types p
INNER JOIN pizzas pz ON p.pizza_type_id = pz.pizza_type_id
inner join order_details od on od.pizza_id=pz.pizza_id
GROUP BY p.category
ORDER BY avg_order_value DESC;
--- 6. Are there any trends in sales based on the day of the week?

SELECT 
    CASE
        WHEN DAYOFWEEK(o.date) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(o.date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(o.date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(o.date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(o.date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(o.date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(o.date) = 7 THEN 'Saturday'
    END AS day_of_week,
    SUM(od.quantity * p.price) AS total_sales
FROM orders o
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');

select DATE_FORMAT(date, '%W') AS day_of_week,sum(od.quantity*p.price) as revenue
from orders o
inner join order_details od
on o.order_id=od.order_id
inner join pizzas p
on od.pizza_id=p.pizza_id
group by day_of_week
order by revenue desc;