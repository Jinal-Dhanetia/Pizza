CREATE database pizzahut;
create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));



drop table order_details;
create table order_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null, 
quantity int not null,
primary key (order_details_id));

#Q1 :Retrieve the total numbers of orders placed 
SELECT count(order_id) from orders

#Q2:Calculate the total revenue generated from pizza sales.

SELECT round(sum(order_details.quantity* pizzas.price),2) as total_sales from pizzas
JOIN order_details on pizzas.pizza_id=order_details.pizza_id;

#Q3: Identify the highest-priced pizza.
 SELECT pizza_types.name,price from pizzas
 JOIN pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
 order by price desc
 limit 1;
 
 #Q4:Identify the most common pizza size ordered.
 SELECT count(order_details.order_details_id),pizzas.size from pizzas
 JOIN order_details on pizzas.pizza_id=order_details.pizza_id
 GROUP BY pizzas.size
 ORDER BY count(order_details.order_details_id) desc
 limit 1;
 
 #Q5 : List the top 5 most ordered pizza types along with their quantities.
	 
	 SELECT pizza_types.name,sum(order_details.quantity) from pizzas
	 JOIN order_details on pizzas.pizza_id=order_details.pizza_id
	 JOIN pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
	 GROUP BY pizza_types.name
	 ORDER BY sum(order_details.quantity) desc
	 limit 5;
 
 #Q6:Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT pizza_types.category, SUM(order_details.quantity) from pizza_types
JOIN pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
JOIN order_details on pizzas.pizza_id=order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY SUM(order_details.quantity) desc

#Q7:Determine the distribution of orders by hour of the day.

SELECT hour(order_time), count(order_id) from orders
GROUP BY hour(order_time) 

#Q8 :Join relevant tables to find the category-wise distribution of pizzas.

SELECT category,count(name) from pizza_types
GROUP BY category

#Q9 : Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT round(AVG(quantity),0) from 
(SELECT orders.order_date,sum(order_details.quantity) as quantity from orders
JOIN order_details on orders.order_id=order_details.order_id
GROUP BY orders.order_date) as order_quantity;

#Q10:Determine the top 3 most ordered pizza types based on revenue.

SELECT pizza_types.name,SUM((order_details.quantity)*(pizzas.price))as revenue from pizza_types
JOIN pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
JOIN order_details on pizzas.pizza_id=order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue desc
limit 3;

#Q11: Calculate the percentage contribution of each pizza type to total revenue.


SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

#Q11 : Analyze the cumulative revenue generated over time.

select order_date,sum(revenue) over(order by order_date) as cum_revenue from
(SELECT orders.order_date,SUM(order_details.quantity*pizzas.price) as revenue from orders
join order_details on orders.order_id=order_details.order_id
join pizzas on order_details.pizza_id=pizzas.pizza_id
GROUP BY orders.order_date ) as sales;

#Q12 :Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category,name,total from 
(select category ,name,total,
rank() over(partition by category order by total desc) as rn
from
(SELECT pizza_types.name,pizza_types.category,sum(order_details.quantity*pizzas.price) as total from pizza_types
JOIN pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
JOIN order_details on pizzas.pizza_id=order_details.pizza_id
group by pizza_types.name,pizza_types.category) as a) as b
where rn<=3








 

 
 
 
 

