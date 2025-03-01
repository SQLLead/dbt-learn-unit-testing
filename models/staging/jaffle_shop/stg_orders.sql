with

source as (

    select * from {{ source('jaffle_shop',  'orders') }}

),

staged as (

    select 
        id as order_id,
        user_id as customer_id,
        order_date,
        datediff('day', order_date, {{ dbt.current_timestamp() }} ) as days_since_ordered,
        status like '%pending%' as is_status_pending,
        case 
            when status like '%return%' then 'returned'
            when status like '%pending%' then 'placed'
            when status like '%shipped%'
              or status = 'shitcanned' then 'shipped'
            else status
        end as status
    from source

)

select * from staged

