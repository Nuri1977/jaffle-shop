-- models/business/fct_order_items.sql

with orders as (
    select * from {{ ref('stg_orders') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

locations as (
    select * from {{ ref('stg_locations') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

final as (

    select
        -- Primary Key
        oi.order_item_id,

        -- Foreign Keys
        o.order_id,
        o.customer_id,
        o.location_id,
        oi.product_id,

        -- Order Details
        o.ordered_at,
        o.subtotal_cents as order_subtotal_cents,
        o.tax_paid_cents as order_tax_paid_cents,
        o.order_total_cents as order_total_cents,
        o.subtotal as order_subtotal,
        o.tax_paid as order_tax_paid,
        o.order_total as order_total,

        -- Customer Details
        c.customer_name,

        -- Location Details
        l.location_name,
        l.tax_rate as location_tax_rate,
        l.opened_date as location_opened_date,

        -- Product Details
        p.product_name,
        p.product_type,
        p.product_description,
        p.product_price,
        p.is_food_item,
        p.is_drink_item

    from order_items oi
    left join orders o
        on oi.order_id = o.order_id
    left join customers c
        on o.customer_id = c.customer_id
    left join locations l
        on o.location_id = l.location_id
    left join products p
        on oi.product_id = p.product_id

)

select * from final

Hahahahah
