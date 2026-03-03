{{ config(
    materialized='incremental',
    unique_key='item_key'
) }}
WITH source AS (
    SELECT * FROM {{ source('tpcds', 'item') }}
),
source_s3 as (
    select *
    from raw.item 
),
renamed AS (
    SELECT
        i_item_sk AS item_key,
        i_item_id AS item_id,
        i_item_desc AS item_description,
        i_brand AS brand,
        i_class AS item_class,
        i_category AS category,
        i_current_price AS current_price,
        CURRENT_TIMESTAMP() AS _loaded_at
    FROM source
)

SELECT * FROM renamed
union all
SELECT * FROM source_s3

