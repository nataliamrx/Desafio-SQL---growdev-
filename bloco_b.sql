/* BLOCO B
 B1. Relatório com -categoria- do produto (traduzida), valor do item, cidade do vendedor. - (join 4 tabelas, o que foi vendido por quanto (R$) e de onde veio o vendedor?)
 Produtos de diversas categorias vendidas por valores e cidades distintas.. 
 
olist_products_dataset = categoria
olist_order_items_dataset = valor do item
olist_sellers_dataset = cidade do vendedor 

*No bloco B.4 tem a mesmo principio*/ 

select
    coalesce(t.product_category_name_english,p.product_category_name) as "categoria",
    i.price as valor_item,
    s.seller_city as cidade_vendedor
from olist_order_items_dataset as i
join olist_products_dataset as p on p.product_id = i.product_id
join olist_sellers_dataset s on s.seller_id = i.seller_id
left join product_category_name_translation t on t.product_category_name = p.product_category_name 
limit 100;
    
    
/*B2. Identificar pedidos com atraso na entrega, comparando data estimada com data real de entrega (join entre orders e customers).
-- Foi observado que em algumas datas não possuem a data de entrega ao cliente, considerando mais de 3.384 dias em atraso como no caso da coluna:
order_id: 2d858f451373b04fb5c984a1cc2defaf da coluna: customer_city: porto alegre, já na coluna order_id: 1b3190b2dfa9d789e1f14c05b647a14a possui 188 dias de atraso. 
*/
select
o.order_id,
c.customer_city,
c.customer_state,
o.order_estimated_delivery_date as estimativa_entrega,
o.order_delivered_customer_date as entregue_ao_cliente_em,
(
	coalesce(
			nullif(o.order_delivered_customer_date, '') :: date,
			CURRENT_DATE
			)
- nullif(o.order_estimated_delivery_date, '') :: date
) as dias_atraso
from olist_orders_dataset o
join olist_customers_dataset c
	ON c.customer_id = o.customer_id 
	where o.order_status = 'delivered'
and coalesce(
nullif (o.order_delivered_customer_date, '') :: date,
CURRENT_DATE
) > nullif (o.order_estimated_delivery_date, '') :: date
ORDER by dias_atraso desc
limit 20;


/*B3 .  Listar pedidos e suas formas de pagamento, incluindo pedidos pagos em mais de uma parcela (join entre orders e order_payments).*/
--Lista realizada onde apresentam os pedidos e suas respectivas formas de pagamentos, observado que, credit_card possuiu o maior número de payment_type
select
    o.order_id,
    p.payment_type,
    p.payment_installments,
    p.payment_value
from olist_orders_dataset o
join olist_order_payments_dataset p
on p.order_id = o.order_id
limit 200;

/*B4. Listar produtos junto com a categoria traduzida, incluindo produtos cuja categoria não possui tradução cadastrada product_category_name_translation).
 (LEFT JOIN com product_category_name_translation).
 -- Todos os produtos da categoria que não possuem tradução, constam listados, como o produto perfumery, art, sport_leisure, etc... */

select
	p.product_id,
	coalesce(t.product_category_name_english, p.product_category_name) as "categoria"
from olist_products_dataset as p
left join product_category_name_translation as t
on t.product_category_name = p.product_category_name
limit 100;

/*B5.Identificar pedidos em que o cliente e o vendedor são do mesmo estado (join entre customers, orders, order_items e sellers).- Pergunta: pedidos onde a venda foi local
 (mesmo estado) Assvendas foram feitaa na cidade de São Paulo, no estado de São Paulo.*/
 
  select
    o.order_id,
    c.customer_city,
    c.customer_state,
    s.seller_city,
    s.seller_state
from olist_orders_dataset o
join olist_customers_dataset c on o.customer_id = c.customer_id
join olist_order_items_dataset i on i.order_id = i.order_id
join olist_sellers_dataset s on i.seller_id = s.seller_id 
WHERE c.customer_state = s.seller_state
limit 100;
 


 
 










