-- =========================================================================
-- CONSULTA 1
-- OBJETIVO: Média global para cada cliente
-- =========================================================================
WITH valor_pedidos AS (
    SELECT
        ped.id_pedido,
        SUM(ip.quantidade * ip.preco_unitario) AS valor_total
    FROM pedidos ped
    INNER JOIN itens_pedido ip
        ON ped.id_pedido = ip.id_pedido
    WHERE ped.status = 'Confirmado'
    GROUP BY ped.id_pedido
)
SELECT
    id_pedido,
    valor_total,
    AVG(valor_total) OVER() AS media_global
FROM valor_pedidos;


-- =========================================================================
-- CONSULTA 2
-- OBJETIVO: Média de cada cliente a partir de seus pedidos
-- =========================================================================
WITH status_cliente as (
	SELECT
		ped.id_pedido as pedido,
		c.nome as cliente,
		sum(ip.quantidade * ip.preco_unitario) as valor_total
	FROM clientes as c
		INNER JOIN pedidos as ped
			ON c.id_cliente = ped.id_cliente
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	GROUP BY ped.id_pedido, c.nome
)
SELECT
	sc.pedido,
    sc.cliente,
    sc.valor_total,
	round(avg(valor_total) over(partition by sc.cliente), 2) as media_cliente
FROM status_cliente as sc
ORDER BY sc.pedido;


-- =========================================================================
-- CONSULTA 3
-- OBJETIVO: Ranking de clientes mais valiosos
-- =========================================================================
WITH faturamento_cliente as (
	SELECT
		c.nome as cliente,
		sum(ip.quantidade * ip.preco_unitario) as faturamento
	FROM clientes as c
		INNER JOIN pedidos as ped
			ON c.id_cliente = ped.id_cliente
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY c.id_cliente, c.nome
)
SELECT
	fc.cliente,
    fc.faturamento,
    rank() over(order by faturamento desc) as ranking
FROM faturamento_cliente as fc;


-- =========================================================================
-- CONSULTA 4
-- OBJETIVO: Ranking row_number por cliente
-- =========================================================================
WITH faturamento_cliente as (
    SELECT
		c.nome as cliente,
		ped.id_pedido as pedido,
		sum(ip.quantidade * ip.preco_unitario) as valor
	FROM clientes as c
		INNER JOIN pedidos as ped
			ON c.id_cliente = ped.id_cliente
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY c.id_cliente, c.nome, ped.id_pedido
)
SELECT 
	fc.cliente,
    fc.pedido,
    fc.valor,
    row_number()
		over(
			partition by cliente
            order by valor desc
        ) as ranking
FROM faturamento_cliente as fc;


-- =========================================================================
-- CONSULTA 5
-- OBJETIVO: ranking dos produtos por faturamento (rank vs row)
-- =========================================================================
WITH faturamento_produtos as (
	SELECT
		prod.nome as produto,
		sum(ip.quantidade * ip.preco_unitario) as faturamento
	FROM produtos as prod
		INNER JOIN itens_pedido as ip
			ON prod.id_produto = ip.id_produto
		INNER JOIN pedidos as ped
			ON ip.id_pedido = ped.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY prod.id_produto, prod.nome
)
SELECT 
	fp.produto,
    fp.faturamento,
    rank() 
		over(
			order by faturamento desc
		) as ranking,
    row_number() 
		over(
            order by faturamento desc
        ) as roww
FROM faturamento_produtos as fp
ORDER BY fp.faturamento desc;


-- =========================================================================
-- CONSULTA 6
-- OBJETIVO: Ranking por status
-- =========================================================================
WITH status_pedido as (
	SELECT
		ped.id_pedido as pedido,
		ped.status,
		sum(ip.quantidade * ip.preco_unitario) as valor
	FROM pedidos as ped
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	GROUP BY ped.status, ped.id_pedido
)
SELECT 
    sp.status,
    sp.pedido,
    sp.valor,
    rank()
		over(
			partition by status
            order by valor desc
        ) as ranking
FROM status_pedido as sp
ORDER BY status, ranking;


-- =========================================================================
-- CONSULTA 7
-- OBJETIVO: Múltiplas windows
-- =========================================================================
WITH status_cliente as (
	SELECT
		c.nome as cliente,
        ped.id_pedido as pedido,
		sum(ip.quantidade * ip.preco_unitario) as faturamento
	FROM clientes as c
		INNER JOIN pedidos as ped
			ON c.id_cliente = ped.id_cliente
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY c.id_cliente, c.nome, ped.id_pedido
)
SELECT
	sc.cliente,
    sc.pedido,
    sc.faturamento,
    round(avg(faturamento) over(), 2) as media_global,
    round(avg(faturamento)
		over(
			partition by cliente
        ), 2) as media_cliente,
	rank()
		over(
			partition by cliente
            order by faturamento desc
        ) as ranking
FROM status_cliente as sc;











