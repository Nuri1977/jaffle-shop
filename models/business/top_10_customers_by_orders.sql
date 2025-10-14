-- models/business/top_10_customers_by_orders.sql

with customers_with_order_summary as (
    select
        customer_id,
        customer_name,
        count_lifetime_orders,
        lifetime_spend,
        first_ordered_at,
        last_ordered_at,
        customer_type
    from {{ ref('customers') }}
    where count_lifetime_orders is not null -- Exclude customers with no orders
),

ranked_customers as (
    select
        *,
        row_number() over (order by count_lifetime_orders desc, customer_id asc) as customer_rank
    from customers_with_order_summary
)

select
    customer_id,
    customer_name,
    count_lifetime_orders,
    lifetime_spend,
    first_ordered_at,
    last_ordered_at,
    customer_type
from ranked_customers
where customer_rank <= 10
order by customer_rank asc