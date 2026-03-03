{{ config(
    materialized='table',
    cluster_by=['customer_key', 'date_key']
) }}

with base AS (
    select
        customer_key,
        date_key,
        ticket_number,
        revenue
    from {{ ref('fct_sales_incremental') }}
),

ranked AS (
    select
        customer_key,
        date_key,
        ticket_number,
        revenue,
        lag(date_key) over (partition by customer_key order by date_key) as prev_date_key
    from base
)

select
    customer_key,
    date_key,
    ticket_number,
    revenue,
    prev_date_key,
    case
        when prev_date_key is null then null
        else date_key - prev_date_key
    end as days_since_last_purchase
from ranked
