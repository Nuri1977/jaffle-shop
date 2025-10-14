with

source as (

    select * from {{ source('ecom', 'raw_items') }}

),

renamed as (

    select

        ----------  ids
        cast(id as bigint) as order_item_id,
        cast(order_id as bigint) as order_id,
        cast(sku as text) as product_id

    from source

)

select * from renamed
