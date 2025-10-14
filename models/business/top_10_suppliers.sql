-- top_10_suppliers.sql
with

supplies as (

    select * from {{ ref('supplies') }}

),

ranked_suppliers as (
    select
        supply_name,
        sum(supply_cost) as total_supply_cost,
        rank() over (order by sum(supply_cost) desc) as supply_rank
    from supplies
    group by supply_name
)

select
    supply_name,
    total_supply_cost
from ranked_suppliers
where supply_rank <= 10
order by supply_rank