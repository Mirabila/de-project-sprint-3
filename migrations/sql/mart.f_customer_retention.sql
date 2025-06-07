insert into mart.f_customer_retention (
    new_customers_count,
    returning_customers_count,
    refunded_customer_count,
    period_id,
    item_id,
    new_customers_revenue,
    returning_customers_revenue,
    customers_refunded)
with count_orders as (
    select customer_id, count(customer_id) as orders, status, dc.week_of_year as period_id, item_id, sum(payment_amount) as paid
    from mart.f_sales fs2 
    left join mart.d_calendar dc on fs2.date_id = dc.date_id 
    group by status, customer_id , period_id, item_id
),
new_customers as (
    select 
    count (customer_id) as new_customers_count,
    sum(paid) as new_customers_revenue,
    period_id, 
    item_id
    from count_orders
    where status = 'shipped' and orders = 1
    group by period_id, item_id
),
returning_customers as (
    select 
    count (customer_id) as returning_customers_count,
    sum(paid) as returning_customers_revenue,
    period_id, 
    item_id
    from count_orders
    where status = 'shipped' and orders > 1
    group by period_id, item_id
),
refunded_orders as (
    select 
    count (distinct(customer_id)) as refunded_customer_count,
    count (orders) as customers_refunded,
    sum(paid) as customers_refunded_sum,
    period_id, 
    item_id
    from count_orders
    where status = 'refunded'
    group by period_id, item_id
)
select 
nc.new_customers_count, 
rc.returning_customers_count, 
ro.refunded_customer_count,
nc.item_id, 
nc.period_id,
nc.new_customers_revenue,
rc.returning_customers_revenue,
ro.customers_refunded
from new_customers nc
full join returning_customers rc on nc.period_id = rc.period_id and nc.item_id = rc.item_id
full join refunded_orders ro on nc.period_id = ro.period_id and nc.item_id = ro.item_id
;