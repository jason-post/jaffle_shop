{{
    config(
        materialized = "ephemeral"
    )
}}

with payments as (

    select * from {{ ref('stg_payments') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

final as (

    select
        orders.customer_id,
        {% for payment_method in payment_methods() -%}
        sum(case when payment_method = '{{payment_method}}' then amount else 0 end) as {{payment_method}}_amount,
        {% endfor -%}
        sum(amount) as total_amount

    from payments

    left join orders using (order_id)

    group by 1

)

select * from final
