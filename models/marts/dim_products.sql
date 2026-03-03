{{
    config(
        materialized='table'
    )
}}

WITH products AS (
    SELECT * FROM {{ ref('stg_items') }}
),

sales AS (
    SELECT * FROM {{ ref('fct_sales') }}
),

product_metrics AS (
    SELECT
        item_key,
        COUNT(DISTINCT ticket_number) AS times_ordered,
        SUM(quantity) AS total_quantity_sold,
        SUM(revenue) AS total_revenue,
        AVG(sales_price) AS avg_selling_price
    FROM sales
    GROUP BY item_key
),

final AS (
    SELECT
        p.item_key,
        p.item_id,
        p.item_description,
        p.brand,
        p.item_class,
        p.category,
        p.current_price,
        
        COALESCE(pm.times_ordered, 0) AS times_ordered,
        COALESCE(pm.total_quantity_sold, 0) AS total_quantity_sold,
        COALESCE(pm.total_revenue, 0) AS total_revenue,
        COALESCE(pm.avg_selling_price, 0) AS avg_selling_price,
        
        CASE 
            WHEN pm.total_revenue > 50000 THEN 'Best Seller'
            WHEN pm.total_revenue > 20000 THEN 'Popular'
            WHEN pm.total_revenue > 5000 THEN 'Standard'
            WHEN pm.total_revenue > 0 THEN 'Low Sales'
            ELSE 'No Sales'
        END AS product_performance
        
    FROM products p
    LEFT JOIN product_metrics pm ON p.item_key = pm.item_key
)

SELECT * FROM final