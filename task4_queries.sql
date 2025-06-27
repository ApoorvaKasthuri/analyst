
-- 1. SELECT + WHERE + ORDER BY
SELECT order_id, customer_id, order_status, order_purchase_timestamp
FROM orders
WHERE order_status = 'delivered'
ORDER BY order_purchase_timestamp DESC
LIMIT 10;

-- 2. GROUP BY + Aggregate Function (AVG)
SELECT customer_state, COUNT(order_id) AS total_orders, AVG(payment_value) AS avg_payment
FROM orders o
JOIN order_payments p ON o.order_id = p.order_id
GROUP BY customer_state
ORDER BY total_orders DESC;

-- 3. INNER JOIN: Orders with Payment Info
SELECT o.order_id, o.order_status, p.payment_type, p.payment_value
FROM orders o
INNER JOIN order_payments p ON o.order_id = p.order_id;

-- 4. LEFT JOIN: Orders with Reviews (some orders may not have reviews)
SELECT o.order_id, o.order_status, r.review_score
FROM orders o
LEFT JOIN order_reviews r ON o.order_id = r.order_id;

-- 5. RIGHT JOIN equivalent (SQLite does not support RIGHT JOIN directly)
-- Simulated using LEFT JOIN by switching tables
SELECT r.order_id, r.review_score, o.order_status
FROM order_reviews r
LEFT JOIN orders o ON o.order_id = r.order_id;

-- 6. Subquery: Customers with highest average payment
SELECT customer_id, avg_payment FROM (
    SELECT o.customer_id, AVG(p.payment_value) AS avg_payment
    FROM orders o
    JOIN order_payments p ON o.order_id = p.order_id
    GROUP BY o.customer_id
) WHERE avg_payment > 500;

-- 7. SUM aggregate: Total revenue per seller
SELECT s.seller_id, s.seller_city, SUM(oi.price) AS total_sales
FROM sellers s
JOIN order_items oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_city
ORDER BY total_sales DESC;

-- 8. Create View: Top 10 selling products
CREATE VIEW top_selling_products AS
SELECT p.product_id, pr.product_category_name, COUNT(oi.order_id) AS order_count, SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pr ON p.product_category_name = pr.product_category_name
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- 9. Optimized Query (with index assumption): Average freight by city
SELECT s.seller_city, AVG(oi.freight_value) AS avg_freight
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_city
ORDER BY avg_freight DESC;
