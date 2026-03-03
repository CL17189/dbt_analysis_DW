{% macro calculate_discount_percentage(discount_amount, sales_price) %}
    ROUND(({{ discount_amount }} / NULLIF({{ sales_price }}, 0)) * 100, 2)
{% endmacro %}