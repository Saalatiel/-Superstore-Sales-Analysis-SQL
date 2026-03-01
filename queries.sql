
-- visão geral
SELECT
    COUNT(DISTINCT "Order ID")      AS pedidos,
    COUNT(DISTINCT "Customer Name") AS clientes,
    COUNT(DISTINCT "Product Name")  AS produtos,
    ROUND(SUM(Sales), 2)            AS receita,
    ROUND(SUM(Profit), 2)           AS lucro,
    ROUND(SUM(Profit)/SUM(Sales)*100, 1) AS margem_pct
FROM orders;


-- receita e lucro por regiao
SELECT
    Region,
    COUNT(DISTINCT "Order ID")  AS pedidos,
    ROUND(SUM(Sales), 2)        AS receita,
    ROUND(SUM(Profit), 2)       AS lucro,
    ROUND(SUM(Profit)/SUM(Sales)*100, 1) AS margem_pct
FROM orders
GROUP BY Region
ORDER BY lucro DESC;


-- por segmento de cliente
SELECT
    Segment,
    COUNT(DISTINCT "Customer Name") AS clientes,
    ROUND(SUM(Sales), 2)            AS receita,
    ROUND(SUM(Profit), 2)           AS lucro,
    ROUND(AVG(Sales), 2)            AS ticket_medio
FROM orders
GROUP BY Segment
ORDER BY lucro DESC;


-- categoria e subcategoria
SELECT
    Category,
    "Sub-Category",
    ROUND(SUM(Sales), 2)    AS receita,
    ROUND(SUM(Profit), 2)   AS lucro,
    ROUND(SUM(Profit)/SUM(Sales)*100, 1) AS margem_pct
FROM orders
GROUP BY Category, "Sub-Category"
ORDER BY lucro DESC;


-- produtos no prejuizo
SELECT
    "Product Name",
    Category,
    ROUND(SUM(Sales), 2)    AS receita,
    ROUND(SUM(Profit), 2)   AS lucro
FROM orders
GROUP BY "Product Name", Category
HAVING SUM(Profit) < 0
ORDER BY lucro ASC
LIMIT 15;


-- desconto alto esta destruindo margem?
SELECT
    CASE
        WHEN Discount = 0     THEN 'sem desconto'
        WHEN Discount <= 0.1  THEN 'ate 10%'
        WHEN Discount <= 0.2  THEN '11-20%'
        WHEN Discount <= 0.4  THEN '21-40%'
        ELSE '40%+'
    END                         AS desconto,
    COUNT(*)                    AS pedidos,
    ROUND(SUM(Sales), 2)        AS receita,
    ROUND(SUM(Profit), 2)       AS lucro,
    ROUND(AVG(Profit), 2)       AS lucro_medio
FROM orders
GROUP BY desconto
ORDER BY MIN(Discount);


-- top 10 clientes por receita
SELECT
    "Customer Name",
    Segment,
    Region,
    COUNT(DISTINCT "Order ID")  AS pedidos,
    ROUND(SUM(Sales), 2)        AS receita,
    ROUND(SUM(Profit), 2)       AS lucro
FROM orders
GROUP BY "Customer Name", Segment, Region
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
