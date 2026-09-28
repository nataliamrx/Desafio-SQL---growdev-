-- Validação do setup: contagem de linhas por tabela

select Count (*) from olist_customers_dataset;

select 'custumers' as tabela, COUNT(*) as linhas from olist_customers_dataset
union all
select 'orders', COUNT(*) from olist_orders_dataset
union all
select 'order_items', COUNT(*) from olist_order_items_dataset
union all
select 'order_payments', COUNT(*) from olist_order_payments_dataset
union all
select 'order_reviews', COUNT(*) from olist_order_reviews_dataset
union all
select 'products', COUNT(*) from olist_products_dataset
union all
select 'sellers', COUNT(*) from olist_sellers_dataset
union all
select 'geolocation', COUNT(*) from olist_geolocation_dataset


/*Bloco A
	A1. Listar os 20 pedidos com status delivered mais recentes, ordenados pela data de 
entrega.*/ 
-- Listado os 20 pedidos e observamos que o mais recente foi do dia 17/10/2018 e o mais antigo foi do dia 12/09/2018.

select 
	o.order_id,
	o.customer_id,
	o.order_delivered_customer_date
from olist_orders_dataset o
where o.order_status = 'delivered'
order by o.order_delivered_customer_date desc 
limit 20;

/*A2. Listar todos os produtos de uma categoria específica (usando a tabela de tradução 
para filtrar pelo nome em português).*/
-- Listado todos os produtos da categoria escolhida 'moveis_decoracao'.

--Primeiro: 
select *
from olist_products_dataset

--Segundo:
select *
from product_category_name_translation

--Terceiro: 
select *
from olist_products_dataset
where product_category_name = 'moveis_decoracao'

--Definitivo para a resposta do A2: 
select
    p.product_id,
    p.product_category_name
from olist_products_dataset as p
join product_category_name_translation as t
    on p.product_category_name = t.product_category_name
where t.product_category_name = 'moveis_decoracao';

/*A3. Listar os métodos de pagamento distintos utilizados na base (SELECT DISTINCT 
payment_type).*/
-- Os métodos de pagamentos são: boleto, credit_card, debit_card, not_defined e voucher. 
select
	distinct
	payment_type
from olist_order_payments_dataset
order by olist_order_payments_dataset.payment_type asc;


/*A4. Listar os produtos com peso (product_weight_g) acima de 10kg, ordenados do 
mais pesado para o mais leve.*/
-- Os produtos foram listados e observei que o product_id:26644690fde745fc4654719c3904e1db possui o maior peso, com 40.425g
select 
	product_id,
	product_weight_g
from olist_products_dataset
where product_weight_g > 10000
order by product_weight_g desc;
