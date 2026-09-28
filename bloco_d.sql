/*Bloco D1— Subqueries
 D1.Clientes cujo gasto total está acima da média geral de gasto por cliente.*/
 -- Os clientes que gastam mais que a média é a cidade de São Paulo do estado de SP 

select
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    SUM(i.price + i.freight_value) as gasto_total
    from olist_customers_dataset c
	join olist_orders_dataset o on o.customer_id = c.customer_id 
	join olist_order_items_dataset i on i.order_id = o.order_id 
	group by c.customer_unique_id, c.customer_city, c.customer_state 
	having SUM(i.price + i.freight_value) > (
   				 -- SUBQUERY: calcula a média de gasto por cliente
    				select AVG(gasto_por_cliente)
   					from (
      					  -- SUBQUERY: calcula o gasto total por cliente
      				select
          			 c.customer_unique_id,
            SUM(i.price + i.freight_value) AS gasto_por_cliente
        from olist_customers_dataset c
        join olist_orders_dataset o on o.customer_id = c.customer_id
        join olist_order_items_dataset i ON i.order_id = o.order_id
        group by c.customer_unique_id))
ORDER BY gasto_total asc
limit 10;

-- SUBQUERY calcula a média de vendas da plataforma
select avg(gasto_por cliente)
from (
--SUBQUERY: Calcula o faturamento total por cliente
select
		from olist_customers_dataset c
        join olist_orders_dataset o on o.customer_id = c.customer_id
        join olist_order_items_dataset i ON i.order_id = o.order_id
        group by c.customer_unique_id);

/*D2. Produtos que nunca receberam avaliação (NOT EXISTS / NOT IN)* - Existem produtos vendidos que jamais foram avaliados?*/
-- Sim, existe como o product_id: 3aa071139cb16b67ca9e5dea641aaa2f, product_category_name: artes
-- produtos avaliados

select
i.product_id,
r.review_id
from olist_order_items_dataset i
join olist_order_reviews_dataset r on r.order_id = i.order_id
join olist_products_dataset p on p.product_id = i.product_id;

-- quais produtos não estão presentes na lista de avaliados
select 
*
from olist_products_dataset p
where p.product_id not in (
select 
	i.product_id 
from olist_order_items_dataset i
join olist_order_reviews_dataset r on r.order_id = i.order_id
where i.product_id = p.product_id 
);


/*D3. Vendedores que venderam produtos de mais de 5 categorias diferentes (subquery 
com COUNT(DISTINCT ...)).*/


select
distinct 
	i.seller_id
from olist_order_items_dataset i
where i.seller_id in (
    select
        i2.seller_id
    from olist_order_items_dataset i2
    join olist_products_dataset p
        on p.product_id = i2.product_id
    group by i2.seller_id
    having count (distinct p.product_category_name) > 5
limit 20);

/*D4. Pedidos cujo valor de frete (freight_value) é maior que o valor total dos itens do 
próprio pedido (subquery correlacionada comparando as duas somas).*/

select
	distinct
    i.order_id
from olist_order_items_dataset i
where
    (
        select SUM(i2.freight_value)
        from olist_order_items_dataset i2
        where i2.order_id = i.order_id
    )
    >
    (
        select SUM(i3.price)
        from olist_order_items_dataset i3
        where i3.order_id = i.order_id);






