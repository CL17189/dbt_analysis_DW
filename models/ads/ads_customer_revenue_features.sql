{{ config(
    materialized='table',
    cluster_by=['customer_key']
) }}

with hist AS (
    select customer_key, date_key, revenue
    from {{ ref('ads_customer_transaction_history') }}
),

agg AS (
    select
        customer_key,
        sum(revenue) as cumulative_revenue,
        avg(revenue) as avg_revenue_per_order,
        max(revenue) as max_revenue_single_order,
        min(revenue) as min_revenue_single_order
    from hist
    group by customer_key
)

select * from agg
