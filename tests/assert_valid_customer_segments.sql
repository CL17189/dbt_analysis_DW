-- Check that all customer segments are valid

SELECT
    customer_segment,
    COUNT(*) as count
FROM {{ ref('dim_customers') }}
WHERE customer_segment NOT IN ('VIP', 'High Value', 'Medium Value', 'Low Value', 'New Customer')
GROUP BY customer_segment