-- models/business/top_10_ordered_products.sql

with product_order_counts as (
    select
        product_id,
        product_name,
        count(order_item_id) as total_orders
    from {{ ref('order_items') }}
    group by
        product_id,
        product_name
),

ranked_products as (
    select
        product_id,
        product_name,
        total_orders,
        row_number() over (order by total_orders desc) as product_rank
    from product_order_counts
)

select
    product_id,
    product_name,
    total_orders
from ranked_products
where product_rank <= 10
order by product_rank asc