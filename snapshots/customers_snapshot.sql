{% snapshot customers_snapshot %}

{{
    config(
      target_database='ECOMMERCE_ANALYTICS_PROJECT',
      target_schema='snapshots',
      unique_key='customer_key',
      strategy='check',
      check_cols=['first_name', 'last_name', 'email', 'birth_country']
    )
}}

SELECT * FROM {{ ref('stg_customers') }}

{% endsnapshot %}