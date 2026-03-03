{{
    config(
        materialized='table'
    )
}}

WITH customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

sales AS (
    SELECT * FROM {{ ref('fct_sales') }}
),

customer_metrics AS (
    SELECT
        customer_key,
        COUNT(DISTINCT ticket_number) AS total_transactions,
        SUM(quantity) AS total_items_purchased,
        SUM(revenue) AS total_revenue,
        AVG(revenue) AS avg_transaction_value,
        SUM(discount_amount) AS total_discounts_received
    FROM sales
    GROUP BY customer_key
),

final AS (
    SELECT
        c.customer_key,
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.birth_country,
        c.birth_year,
        
        COALESCE(cm.total_transactions, 0) AS total_transactions,
        COALESCE(cm.total_items_purchased, 0) AS total_items_purchased,
        COALESCE(cm.total_revenue, 0) AS total_revenue,
        COALESCE(cm.avg_transaction_value, 0) AS avg_transaction_value,
        COALESCE(cm.total_discounts_received, 0) AS total_discounts_received,
        
        CASE 
            WHEN cm.total_revenue > 10000 THEN 'VIP'
            WHEN cm.total_revenue > 5000 THEN 'High Value'
            WHEN cm.total_revenue > 1000 THEN 'Medium Value'
            WHEN cm.total_revenue > 0 THEN 'Low Value'
            ELSE 'New Customer'
        END AS customer_segment
        
    FROM customers c
    LEFT JOIN customer_metrics cm ON c.customer_key = cm.customer_key
)

SELECT * FROM final