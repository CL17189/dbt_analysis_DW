-- This test fails if any sale has negative revenue

SELECT
    ticket_number,
    revenue
FROM {{ ref('fct_sales') }}
WHERE revenue < 0