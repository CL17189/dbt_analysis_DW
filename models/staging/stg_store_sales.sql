{{ config(
    materialized='incremental',
    unique_key='ticket_number'
) }}
WITH source AS (
    SELECT * FROM {{ source('tpcds', 'store_sales') }}
),
source_s3 as (
    select *
    from raw.store_sales 
),
renamed AS (
    SELECT
        ss_sold_date_sk AS date_key,
        ss_sold_time_sk AS time_key,
        ss_item_sk AS item_key,
        ss_customer_sk AS customer_key,
        ss_ticket_number AS ticket_number,
        ss_quantity AS quantity,
        ss_sales_price AS sales_price,
        ss_ext_sales_price AS extended_sales_price,
        ss_ext_discount_amt AS discount_amount,
        ss_net_paid AS net_paid,
        CURRENT_TIMESTAMP() AS _loaded_at
    FROM source
    WHERE ss_item_sk IS NOT NULL
      AND ss_customer_sk IS NOT NULL
      AND ss_quantity > 0
)

SELECT * FROM renamed
union all
SELECT * FROM source_s3