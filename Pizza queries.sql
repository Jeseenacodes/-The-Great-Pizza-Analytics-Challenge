SELECT * FROM orders
SELECT * FROM order_details
SELECT * FROM pizzas
SELECT * FROM pizza_types


-- Phase 1: Foundation & Inspection**

-- 2. List all unique pizza categories (`DISTINCT`).
SELECT * FROM pizzas

SELECT DISTINCT category FROM pizza_types
/*
"Supreme"
"Chicken"
"Classic"
"Veggie"
*/


-- 3. Display `pizza_type_id`, `name`, and ingredients, replacing NULL ingredients with `"Missing Data"`. Show first 5 rows.

SELECT pizza_type_id, name, ingredients FROM pizza_types 

 SELECT pizza_type_id, name, COALESCE(ingredients, 'Missing_Data') AS ingredients
 FROM pizza_types
 LIMIT 5;


-- 4. Check for pizzas missing a price (`IS NULL`).
SELECT * FROM pizzas

SELECT * FROM pizzas WHERE price IS NULL;


-- Phase 2: Filtering & Exploration**
-- 1. Orders placed on `'2015-01-01'` (`SELECT` + `WHERE`).

SELECT * FROM orders WHERE date = '2015-01-01'


-- 2. List pizzas with `price` descending.
SELECT pt.name, p.price FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY price DESC

SELECT * FROM pizza_types



-- 3. Pizzas sold in sizes `'L'` or `'XL'`.
SELECT * FROM pizzas 
WHERE size IN ('L' , 'XL')

SELECT pt.name, p.size
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
WHERE p.size IN ('L', 'XL');


-- 4. Pizzas priced between $15.00 and $17.00.
SELECT pt.name, p.price
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
WHERE  p.price BETWEEN 15.00 AND 17.00
ORDER BY price ASC;


-- 5. Pizzas with `"Chicken"` in the name.
SELECT * FROM pizza_types WHERE name LIKE '%Chicken%'



-- 6. Orders on `'2015-02-15'` or placed after 8 PM.

SELECT * FROM orders AS o
JOIN order_details AS od ON o.order_id = od.order_id
WHERE date = '2015-02-15' OR o.time > '20:00:00'
ORDER BY time ASC

SELECT * FROM orders WHERE date = '2015-02-15' OR time > '20:00:00'

SELECT * FROM order_details

-- Phase 3: Sales Performance**

-- 1. Total quantity of pizzas sold (`SUM`).
SELECT SUM(quantity) AS pizza_quantity
FROM order_details;




-- 2. Average pizza price (`AVG`).
SELECT ROUND(AVG(price),2) AS avg_price
FROM pizzas;





-- 3. Total order value per order (`JOIN`, `SUM`, `GROUP BY`).

SELECT o.order_id, SUM(p.price * od.quantity) AS total_value
FROM orders AS o
JOIN order_details AS od ON o.order_id = od.order_id
JOIN pizzas AS p ON od.pizza_id = p.pizza_id
GROUP BY o.order_id;



-- 4. Total quantity sold per pizza category (`JOIN`, `GROUP BY`).
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM pizza_types AS pt
JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.category;





-- 5. Categories with more than 5,000 pizzas sold (`HAVING`).
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM pizza_types AS pt
JOIN pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
HAVING SUM(od.quantity) > 5000;




-- 6. Pizzas never ordered (`LEFT/RIGHT JOIN`).

SELECT  *
FROM pizzas AS p
LEFT JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
LEFT JOIN order_details AS od ON p.pizza_id = od.pizza_id
WHERE od.order_id IS NULL;


-- 7. Price differences between different sizes of the same pizza (`SELF JOIN`).
SELECT p1.pizza_type_id, (MAX(p2.price) - MIN(p1.price)) AS price_difference
FROM pizzas AS p1
INNER JOIN pizzas AS p2 ON p1.pizza_type_id = p2.pizza_type_id AND p1.size <> p2.size
GROUP BY p1.pizza_type_id;

