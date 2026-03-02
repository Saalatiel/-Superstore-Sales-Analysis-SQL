
-- visão geral
SELECT
    COUNT(DISTINCT order_id)      AS pedidos,
    COUNT(DISTINCT customer_name) AS clientes,
    COUNT(DISTINCT product_name)  AS produtos,
    ROUND(SUM(sales), 2)          AS receita,
    ROUND(SUM(profit), 2)         AS lucro,
    ROUND(SUM(profit) / SUM(sales) * 100, 1) AS margem_pct
FROM sample_superstoreSampleSuperstore ;


-- receita e lucro por regiao
SELECT
    region                          AS regiao,
    COUNT(DISTINCT order_id)        AS pedidos,
    ROUND(SUM(sales), 2)            AS receita,
    ROUND(SUM(profit), 2)           AS lucro,
    ROUND(SUM(profit)/SUM(sales)*100, 1) AS margem_pct
FROM sample_superstoreSampleSuperstore 
GROUP BY region
ORDER BY lucro DESC;


-- por segmento de cliente
SELECT
    segment                         AS segmento,
    COUNT(DISTINCT customer_name)   AS clientes,
    ROUND(SUM(sales), 2)            AS receita,
    ROUND(SUM(profit), 2)           AS lucro,
    ROUND(AVG(sales), 2)            AS ticket_medio
FROM sample_superstoreSampleSuperstore 
GROUP BY segment
ORDER BY lucro DESC;


-- categoria e subcategoria
SELECT
    category                        AS categoria,
    sub_category                    AS subcategoria,
    ROUND(SUM(sales), 2)            AS receita,
    ROUND(SUM(profit), 2)           AS lucro,
    ROUND(SUM(profit)/SUM(sales)*100, 1) AS margem_pct
FROM sample_superstoreSampleSuperstore 
GROUP BY category, sub_category
ORDER BY lucro DESC;


-- produtos no prejuizo
SELECT
    product_name                    AS produto,
    category                        AS categoria,
    ROUND(SUM(sales), 2)            AS receita,
    ROUND(SUM(profit), 2)           AS lucro
FROM sample_superstoreSampleSuperstore 
GROUP BY product_name, category
HAVING SUM(profit) < 0
ORDER BY lucro ASC
LIMIT 15;


-- desconto alto esta destruindo margem?
SELECT
    CASE
        WHEN discount = 0     THEN 'sem desconto'
        WHEN discount <= 0.1  THEN 'ate 10%'
        WHEN discount <= 0.2  THEN '11-20%'
        WHEN discount <= 0.4  THEN '21-40%'
        ELSE '40%+'
    END                         AS faixa_desconto,
    COUNT(*)                    AS total_vendas,
    ROUND(SUM(sales), 2)        AS receita,
    ROUND(SUM(profit), 2)       AS lucro,
    ROUND(AVG(profit), 2)       AS lucro_medio
FROM sample_superstoreSampleSuperstore 
GROUP BY faixa_desconto
ORDER BY MIN(discount);


-- top 10 clientes por receita
SELECT
    customer_name                   AS cliente,
    segment                         AS segmento,
    region                          AS regiao,
    COUNT(DISTINCT order_id)        AS pedidos,
    ROUND(SUM(sales), 2)            AS receita,
    ROUND(SUM(profit), 2)           AS lucro
FROM sample_superstoreSampleSuperstore 
GROUP BY customer_name, segment, region
ORDER BY receita DESC
LIMIT 10;

-- clientes fieis (mais de 5 pedidos)
SELECT
    "Customer Name",
    COUNT(DISTINCT "Order ID")  AS pedidos,
    ROUND(SUM(Sales), 2)        AS receita
FROM orders
GROUP BY "Customer Name"
HAVING COUNT(DISTINCT "Order ID") > 5
ORDER BY pedidos DESC;


-- receita por ano
SELECT
    SUBSTR("Order Date", -4)    AS ano,
    COUNT(DISTINCT "Order ID")  AS pedidos,
    ROUND(SUM(Sales), 2)        AS receita,
    ROUND(SUM(Profit), 2)       AS lucro
FROM orders
GROUP BY ano
ORDER BY ano;


-- receita mensal em 2017
SELECT
    SUBSTR("Order Date", 1, 7)  AS mes,
    COUNT(DISTINCT "Order ID")  AS pedidos,
    ROUND(SUM(Sales), 2)        AS receita
FROM orders
WHERE "Order Date" LIKE '%2017%'
GROUP BY mes
ORDER BY mes;


-- crescimento ano a ano (LAG pega o valor do ano anterior)
WITH anual AS (
    SELECT
        SUBSTR("Order Date", -4)    AS ano,
        ROUND(SUM(Sales), 2)        AS receita
    FROM orders
    GROUP BY ano
)
SELECT
    ano,
    receita,
    LAG(receita) OVER (ORDER BY ano) AS ano_anterior,
    ROUND(
        (receita - LAG(receita) OVER (ORDER BY ano))
        / LAG(receita) OVER (ORDER BY ano) * 100
    , 1) AS crescimento_pct
FROM anual
ORDER BY ano;


-- top 3 subcategorias por regiao
-- RANK() numera dentro de cada regiao separadamente
WITH rank_sub AS (
    SELECT
        Region,
        "Sub-Category",
        ROUND(SUM(Sales), 2) AS receita,
        RANK() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS pos
    FROM orders
    GROUP BY Region, "Sub-Category"
)
SELECT Region, pos, "Sub-Category", receita
FROM rank_sub
WHERE pos <= 3
ORDER BY Region, pos;
