WITH sales AS (
    SELECT * FROM {{ ref('stg_store_sales') }}
),

customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

items AS (
    SELECT * FROM {{ ref('stg_items') }}
),

joined AS (
    SELECT
        s.ticket_number,
        s.date_key,
        s.customer_key,
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.birth_country,
        s.item_key,
        i.item_id,
        i.item_description,
        i.brand,
        i.category,
        s.quantity,
        s.sales_price,
        s.extended_sales_price,
        s.discount_amount,
        s.net_paid
    FROM sales s
    LEFT JOIN customers c ON s.customer_key = c.customer_key
    LEFT JOIN items i ON s.item_key = i.item_key
)

SELECT * FROM joined