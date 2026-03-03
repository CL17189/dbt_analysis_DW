{{ config(
    materialized='table',
    cluster_by=['customer_key']
) }}

with engagement AS (
    select * from {{ ref('ads_customer_engagement_features') }}
),

revenue AS (
    select * from {{ ref('ads_customer_revenue_features') }}
),

calc AS (
    select
        e.customer_key,
        e.total_purchases,
        e.distinct_purchase_days,
        e.avg_days_between_purchases,
        r.cumulative_revenue,
        r.avg_revenue_per_order,
        r.max_revenue_single_order,
        case
            when r.cumulative_revenue <= 1000 then r.cumulative_revenue * 1.05
            when r.cumulative_revenue <= 5000 then r.cumulative_revenue * 1.1
            else r.cumulative_revenue * 1.15
        end as predicted_ltv
    from engagement e
    left join revenue r
        on e.customer_key = r.customer_key
)

select * from calc
