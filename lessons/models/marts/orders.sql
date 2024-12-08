WITH
order_item_measures AS (

    SELECT
        order_id,
        SUM(item_sale_price) as total_sale_price,
        SUM(product_cost) as total_product_cost,
        SUM(item_profit) as total_profit,
        SUM(item_discount) as total_discount

    FROM {{ ref('int_ecommerce__order_items_products')}}
    GROUP BY 1
)

SELECT
    -- Dimensions from our staing order table
    orders.order_id,
    orders.created_at as order_created_at,
    orders.shipped_at as order_shipped_at,
    orders.delivered_at as order_delivered_at,
    orders.returned_at as order_returned_at,
    orders.status as order_status,


    -- Metrics on an order level
    order_item_measures.total_sale_price,
    order_item_measures.total_product_cost,
    order_item_measures.total_profit,
    order_item_measures.total_discount

FROM {{ ref('stg_ecommerce__orders') }} AS orders
LEFT JOIN order_item_measures ON orders.order_id = order_item_measures.order_id