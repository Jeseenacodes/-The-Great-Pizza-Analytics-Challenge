
#  **Pizza Sales SQL Analysis — Documentation**

## Phase 1: Foundation & Inspection

### **1. View all pizzas**

```sql
SELECT * FROM pizzas;
```

### **2. List unique pizza categories**

```sql
SELECT DISTINCT category 
FROM pizza_types;
```

### **3. Show pizza type, name, ingredients (replace NULL with “Missing_Data”)**

```sql
SELECT pizza_type_id,
       name,
       COALESCE(ingredients, 'Missing_Data') AS ingredients
FROM pizza_types
LIMIT 5;

# When exploring raw data, NULL ingredients can cause issues during filtering or text analysis.
`COALESCE()` ensures clean, readable outputs by replacing missing values.
```

### **4. Find pizzas missing price**

```sql
SELECT *
FROM pizzas
WHERE price IS NULL;
```

---

## Phase 2: Filtering & Exploration

### **1. Orders placed on `2015-01-01`**

```sql
SELECT *
FROM orders
WHERE date = '2015-01-01';
```

### **2. List pizzas by price (descending)**

```sql
SELECT pt.name, p.price
FROM pizzas AS p
JOIN pizza_types AS pt 
  ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC;
```

### **3. Pizzas sold in sizes `L` or `XL`**

```sql
SELECT pt.name, p.size
FROM pizzas AS p
JOIN pizza_types AS pt 
  ON p.pizza_type_id = pt.pizza_type_id
WHERE p.size IN ('L', 'XL');
```

### **4. Pizzas priced between $15 and $17**

```sql
SELECT pt.name, p.price
FROM pizzas AS p
JOIN pizza_types AS pt 
  ON p.pizza_type_id = pt.pizza_type_id
WHERE p.price BETWEEN 15.00 AND 17.00
ORDER BY p.price ASC;
```

### **5. Pizzas with “Chicken” in the name**

```sql
SELECT *
FROM pizza_types
WHERE name LIKE '%Chicken%';
```

### **6. Orders on `2015-02-15` or after 8 PM**

```sql
SELECT *
FROM orders
WHERE date = '2015-02-15'
   OR time > '20:00:00';
```

---

##  Phase 3: Sales Performance

### **1. Total quantity of pizzas sold**

```sql
SELECT SUM(quantity) AS pizza_quantity
FROM order_details;
```

### **2. Average pizza price**

```sql
SELECT ROUND(AVG(price), 2) AS avg_price
FROM pizzas;
```

### **3. Total order value per order**

```sql
SELECT o.order_id,
       SUM(p.price * od.quantity) AS total_value
FROM orders AS o
JOIN order_details AS od 
  ON o.order_id = od.order_id
JOIN pizzas AS p 
  ON od.pizza_id = p.pizza_id
GROUP BY o.order_id;
```

### **4. Total quantity sold per pizza category**

```sql
SELECT pt.category,
       SUM(od.quantity) AS total_quantity
FROM pizza_types AS pt
JOIN pizzas AS p 
  ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od 
  ON p.pizza_id = od.pizza_id
GROUP BY pt.category;
```

### **5. Categories with over 5,000 pizzas sold**

```sql
SELECT pt.category,
       SUM(od.quantity) AS total_quantity
FROM pizza_types AS pt
JOIN pizzas AS p 
  ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details AS od 
  ON p.pizza_id = od.pizza_id
GROUP BY pt.category
HAVING SUM(od.quantity) > 5000;
```

### **6. Pizzas that were never ordered**

```sql
SELECT p.*
FROM pizzas AS p
LEFT JOIN order_details AS od 
  ON p.pizza_id = od.pizza_id
WHERE od.order_id IS NULL;
```

### **7. Price difference between sizes of the same pizza (Self-join)**

```sql
SELECT p1.pizza_type_id,
       (MAX(p2.price) - MIN(p1.price)) AS price_difference
FROM pizzas AS p1
JOIN pizzas AS p2 
  ON p1.pizza_type_id = p2.pizza_type_id
 AND p1.size <> p2.size
GROUP BY p1.pizza_type_id;
```

---


---
