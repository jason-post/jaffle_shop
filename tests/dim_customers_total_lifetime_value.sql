with calc as (
    select
        {% for payment_method in payment_methods() -%}
        {% if not loop.first %}    + {% endif %}{{payment_method}}_lifetime_value
        {% endfor %} as expected_total,
        customer_lifetime_value as actual_total
    from {{ ref('dim_customers') }}
)
select *
from calc
where expected_total <> actual_total