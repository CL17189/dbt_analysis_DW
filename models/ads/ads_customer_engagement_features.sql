{{ config(
    materialized='table',
    cluster_by=['customer_key']
) }}

with hist AS (
    select
        customer_key,
        date_key,
        revenue,
        days_since_last_purchase
    from {{ ref('ads_customer_transaction_history') }}
),

agg AS (
    select
        customer_key,
        count(*) as total_purchases,
        count(distinct date_key) as distinct_purchase_days,
        avg(days_since_last_purchase) as avg_days_between_purchases,
        max(days_since_last_purchase) as max_days_between_purchases
    from hist
    group by customer_key
)

select * from agg
