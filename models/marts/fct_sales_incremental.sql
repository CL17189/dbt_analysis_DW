{{ config(
    materialized='incremental',
    unique_key='ticket_number',
    cluster_by=['date_key', 'customer_key']
) }}


WITH sales_data AS (
    SELECT * FROM {{ ref('int_sales_with_customers') }}
    
    {% if is_incremental() %}
    -- Only process new sales since last run
    WHERE date_key > (SELECT MAX(date_key) FROM {{ this }})
    {% endif %}
),

final AS (
    SELECT
        ticket_number,
        date_key,
        customer_key,
        customer_id,
        first_name || ' ' || last_name AS customer_name,
        birth_country,
        item_key,
        item_id,
        item_description,
        brand,
        category,
        quantity,
        sales_price,
        extended_sales_price,
        discount_amount,
        net_paid,
        extended_sales_price - discount_amount AS revenue,
        CURRENT_TIMESTAMP() AS _updated_at
    FROM sales_data
)

SELECT * FROM final