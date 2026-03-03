{{ config(
    materialized='incremental',
    unique_key='customer_key'
) }}
WITH source AS (
    SELECT * FROM {{ source('tpcds', 'customer') }}
),
source_s3 as (
    select *
    from raw.customer 
),


renamed AS (
    SELECT
        c_customer_sk AS customer_key,
        c_customer_id AS customer_id,
        c_first_name AS first_name,
        c_last_name AS last_name,
        c_email_address AS email,
        c_birth_country AS birth_country,
        c_birth_year AS birth_year,
        CURRENT_TIMESTAMP() AS _loaded_at
    FROM source
),

SELECT * FROM renamed
union all
SELECT * FROM source_s3
