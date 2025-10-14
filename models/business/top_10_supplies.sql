-- This model identifies the top 10 supplies by total cost.

with

supplies as (

    select * from {{ ref('supplies') }}

),

supply_costs as (

    select
        supply_name,
        sum(supply_cost) as total_supply_cost

    from supplies

    group by 1

),

ranked_supplies as (

    select
        supply_name,
        total_supply_cost,
        row_number() over (order by total_supply_cost desc) as rank_num

    from supply_costs

)

select
    supply_name,
    total_supply_cost

from ranked_supplies
where rank_num <= 10
order by rank_num asc