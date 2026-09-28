/*Bloco E — CASE WHEN 
E1. Classificar pedidos por prazo de entrega: "adiantado", "no prazo" ou "atrasado" (comparando data real x estimada).como se distribui a performance de entrega da plataforma*/
--Feita a carecterização 

SELECT
o.order_id,
o.order_estimated_delivery_date AS estimativa_entrega,
o.order_delivered_customer_date AS entregue_ao_cliente,
case
-- e: não possuir data de entrega
when NULLIF(o.order_delivered_customer_date, '') :: date is null
then 'sem data de entrega'
-- 1: "adiantado"
when o.order_delivered_customer_date :: date < o.order_estimated_delivery_date :: date then 'adiantado'
-- 2: "no prazo"
when o.order_delivered_customer_date :: date = o.order_estimated_delivery_date :: date then 'no prazo'
-- 3: "atrasado"
when o.order_delivered_customer_date :: date > o.order_estimated_delivery_date :: date then 'atrasado'
-- Valor padrão quando não atende à nenhum das condições acima
else 'Nao pode ser categorizado'
end
from olist_orders_dataset o
where o.order_status = 'delivered';

/*E2. Classificar clientes por faixa de gasto total: "bronze", "prata", "ouro".*/
--Como segmentar nossa base de clientes por valor? 

select
c.customer_unique_id,
SUM(i.price + i.freight_value) as gasto_total,
case -- 1: "bronze" gasto_total <= 500
when SUM(i.price + i.freight_value) <= 500 then 'bronze' -- 2: "prata" gasto_total <= 2000
when SUM(i.price + i.freight_value) <= 2000 then 'prata' -- 3: "ouro"
else 'ouro'
end as faixa_cliente
from olist_customers_dataset c
join olist_orders_dataset o on o.customer_id = c.customer_id
join olist_order_items_dataset i on i.order_id = o.order_id
group by c.customer_unique_id
order by gasto_total
desc;	

/*E3. Classificar produtos por faixa de peso: "leve", "médio", "pesado" (com base em product_weight_g). */

-- Até 1.000 g => leve
-- De 1.001 g até 5.000 g => médio
-- Acima de 5.000 g => pesado

select 
p.product_id,
p.product_weight_g,
case
when p.product_weight_g <= 1000
then 'leve'
when p.product_weight_g <= 5000
then 'médio'
 else 'pesado'
 end as faixa_peso
from olist_products_dataset p;

/*E4. Classificar pagamentos como "à vista" ou "parcelado", e dentro de parcelado sinalizar parcelamentos longos (payment_installments > 6).*/

select 
p.order_id,
p.payment_value,
p.payment_installments,
case
when p.payment_installments = 1
then 'à vista'
when p.payment_installments > 6
then 'parcelado longo'
else 'parcelado'
end as tipo_pagamento
from olist_order_payments_dataset p;



