-- models/business/orders_daily_totals.sql

with orders as (
    select * from {{ ref('orders') }}
),

daily_summary as (
    select
        ordered_at as order_date,
        count(distinct order_id) as total_orders,
        sum(order_total) as total_order_value,
        sum(subtotal) as total_subtotal_value,
        sum(tax_paid) as total_tax_paid,
        sum(order_cost) as total_order_cost,
        sum(order_total) - sum(order_cost) as total_profit,
        sum(count_order_items) as total_items_ordered,
        sum(count_food_items) as total_food_items_ordered,
        sum(count_drink_items) as total_drink_items_ordered
    from orders
    group by 1
    order by 1
)

select * from daily_summary


Hahahhaahha