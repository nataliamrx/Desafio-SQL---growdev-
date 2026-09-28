/*Bloco C — Funções agregadas + GROUP BY + HAVING
C1. Faturamento total por estado do cliente.- Qual estado gera mais receita para a plataforma? -
- Estado de SP gera mais receita, em comparação aos outros estados, com o faturamento de 
R$ 5.769 */

select 
c.customer_state,
SUM(i.price + i.freight_value) as faturamento_total
from olist_orders_dataset o 
join olist_customers_dataset c on c.customer_id = o.customer_id 
join olist_order_items_dataset i on i.order_id = o.order_id 
where o.order_status = 'delivered'
group by c.customer_state
order by faturamento_total desc;

/*C2. 2. Top 10 vendedores por faturamento. */
-- Pergunta: quem são os vendedores que mais faturam? Os vendedores dos estados de SP e BA.

select
    s.seller_id,
    s.seller_city,
    s.seller_state,
	sum(i.price) as faturamento
from olist_order_items_dataset i
join olist_sellers_dataset s on i.seller_id = s.seller_id
group by
	s.seller_id,
    s.seller_city,
    s.seller_state
order by faturamento desc
limit 10;

/*C3. Ticket médio por categoria de produto. -*/
 --O ticket médio por categoria é do pcs, com o Ticket Médio de:R$ 1.146 

select
    p.product_category_name as categoria,
    avg(i.price + i.freight_value) as ticket_medio
from olist_order_items_dataset as i
join olist_products_dataset as p
    on i.product_id = p.product_id
group by p.product_category_name
order by ticket_medio desc;

/*C4. Vendedores com nota média de avaliação abaixo de 3 (HAVING AVG(...) < 3).*/
-- Todos os vendedores com a avaliação não favorável foram exibidos. 

select
    i.seller_id,
    avg(r.review_score) as nota_media
from olist_order_items_dataset as i
join olist_order_reviews_dataset as r
    on i.order_id = r.order_id
group by i.seller_id
HAVING avg(r.review_score) < 3
order by nota_media;

/*C5. Quantidade de pedidos por forma de pagamento (GROUP BY payment_type).*/
-- O número de quantidade de pedidos feitas por cartão de cédito foi de de: 76.505. Número superior em comparação aos outros meios de pagamento. 

select
	payment_type,
	COUNT(distinct order_id) as quantidade_pedidos
from olist_order_payments_dataset
group by payment_type
order by quantidade_pedidos desc;

/*C6. Peso médio dos produtos por categoria.*/
-- Observado que, o peso médio da categoria de móveis é maior, em comparação a categoria de livros importados que é mais leve, de 3.45g

select
product_category_name as categoria,
avg(product_height_cm) as peso_medio_g
from olist_products_dataset
group by product_category_name
order by peso_medio_g desc;

/*C7. Número médio de parcelas (AVG(payment_installments)) por categoria de produto. */
-- O maior número médio de parcelas feitas de todas as categorias é da categoria pcs, com 6 parcelas. 

select
    p.product_category_name as categoria,
    AVG(pay.payment_installments) AS media_parcelas
from olist_products_dataset as p
join olist_order_items_dataset as i
    on p.product_id = i.product_id
join olist_order_payments_dataset as pay
    on i.order_id = pay.order_id
group by p.product_category_name
order by media_parcelas desc;





