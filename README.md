# Проект 3-го спринта


### Этап 1
1. Добавим новое поле в таблицы staging.user_order_log и mart.f_sales 

```
ALTER TABLE staging.user_order_log
ADD COLUMN status varchar(15) DEFAULT 'shipped';
```

```
ALTER TABLE mart.f_sales 
ADD COLUMN status varchar(15) DEFAULT 'shipped';
```

2. Заполнение таблицы mart.f_sales с помощью [mart.f_sales.sql]([https://www.google.com "Сайт Google"](https://github.com/Mirabila/de-project-sprint-3/blob/main/migrations/sql/mart.f_sales.sql)

### Этап 2


1. Создание витрины mart.f_customer_retention

```
create table if not exists mart.f_customer_retention (
new_customers_count INT,
returning_customers_count INT,
refunded_customer_count INT,
period_name VARCHAR(15) default 'weekly',
period_id INT,
item_id INT,
new_customers_revenue numeric(10,2),
returning_customers_revenue numeric(10,2),
customers_refunded INT);
```

2. Заполнене витрины mart.f_customer_retention с помощью [mart.f_customer_retention.sql](https://github.com/Mirabila/de-project-sprint-3/blob/main/migrations/sql/mart.f_customer_retention.sql)

3. Добавление в DAG новой функции:

```
update_f_customer_retention = PostgresOperator(
task_id='update_f_customer_retention',
postgres_conn_id=postgres_conn_id,
sql="sql/mart.f_customer_retention.sql")
```
   
   Итоговый [DAG](https://github.com/Mirabila/de-project-sprint-3/blob/main/src/dags/sprint3.py)
