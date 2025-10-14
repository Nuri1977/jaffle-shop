with

customers as (

    select * from {{ ref('customers') }}

),

top_customers as (

    select
        *,
        row_number() over (order by lifetime_spend desc) as customer_rank

    from customers

)

select * from top_customers where customer_rank <= 100