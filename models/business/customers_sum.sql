-- This model calculates aggregated customer metrics.

with

customers as (

    select *
    from {{ ref('stg_customers') }}

),

orders as (

    select *
    from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        customer_id,
        min(ordered_at) as first_ordered_at,
        max(ordered_at) as last_ordered_at,
        count(distinct order_id) as count_lifetime_orders,
        sum(subtotal) as lifetime_spend_pretax,
        sum(tax_paid) as lifetime_tax_paid,
        sum(order_total) as lifetime_spend
    from orders
    group by 1

),

final as (

    select
        customers.customer_id,
        customers.customer_name,
        customer_orders.count_lifetime_orders,
        customer_orders.first_ordered_at,
        customer_orders.last_ordered_at,
        customer_orders.lifetime_spend_pretax,
        customer_orders.lifetime_tax_paid,
        customer_orders.lifetime_spend,
        case
            when customer_orders.count_lifetime_orders >= 5 then 'Loyal'
            when customer_orders.count_lifetime_orders >= 2 then 'Regular'
            else 'New'
        end as customer_type
    from customers
    left join customer_orders
        on customers.customer_id = customer_orders.customer_id

)

select *
from final


Hahahahahah