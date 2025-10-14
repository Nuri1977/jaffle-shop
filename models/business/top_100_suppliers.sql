with

supplies as (

    select * from {{ ref('stg_supplies') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

product_supplies_summary as (

    select
        product_id,
        sum(supply_cost) as total_supply_cost
    from supplies
    group by product_id
),

ranked_suppliers as (
    select
        product_id,
        total_supply_cost,
        RANK() OVER (ORDER BY total_supply_cost DESC) as supply_rank
    from product_supplies_summary
),

top_100_suppliers as (
    select
        product_id,
        total_supply_cost
    from ranked_suppliers
    where supply_rank <= 100
)

select
    top_100_suppliers.product_id,
    products.product_name,
    top_100_suppliers.total_supply_cost
from top_100_suppliers
left join products on top_100_suppliers.product_id = products.product_id