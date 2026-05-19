-- EXERCÍCIO 1
WITH faturamento_clientes as (
	SELECT
		ped.id_cliente,
        c.nome,
        SUM(ip.preco_unitario * ip.quantidade) as faturamento_cliente
    FROM pedidos as ped
		INNER JOIN clientes as c
			ON ped.id_cliente = c.id_cliente
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
    GROUP BY ped.id_cliente, c.nome
),

media_faturamento_clientes as (
	SELECT
		AVG(faturamento_cliente) as media
    FROM faturamento_clientes
)

SELECT
	fc.nome,
    fc.id_cliente,
    fc.faturamento_cliente
FROM faturamento_clientes as fc
CROSS JOIN media_faturamento_clientes as mfc
WHERE fc.faturamento_cliente > mfc.media
ORDER BY fc.faturamento_cliente DESC;

-- EXERCÍCIO 2
WITH faturamento_mensal as (
	SELECT
		YEAR(ped.data_pedido) as ano, 
        MONTH(ped.data_pedido) as mes,
        SUM(ip.preco_unitario * ip.quantidade) as faturamento_mensal
    FROM pedidos as ped
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
    GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
),

media_mensal as (
	SELECT
		ROUND(AVG(faturamento_mensal), 2) as media
    FROM faturamento_mensal
)

SELECT
	fm.ano,
    fm.mes,
    fm.faturamento_mensal
FROM faturamento_mensal as fm
	CROSS JOIN media_mensal as mm
WHERE fm.faturamento_mensal < mm.media;


-- EXERCÍCIO 3
WITH faturamento_produtos as (
	SELECT
		prod.id_produto,
        prod.nome,
        SUM(ip.preco_unitario * ip.quantidade) as faturamento_produto
    FROM produtos as prod
		INNER JOIN itens_pedido as ip
			ON prod.id_produto = ip.id_produto
		INNER JOIN pedidos as ped
			ON ip.id_pedido = ped.id_pedido
	WHERE ped.status = 'Confirmado'
    GROUP BY prod.id_produto, prod.nome
),

media_produtos as (
	SELECT
		AVG(faturamento_produto) as media
    FROM faturamento_produtos
)

SELECT
	fp.id_produto,
    fp.faturamento_produto
FROM faturamento_produtos as fp
	CROSS JOIN media_produtos as mp
WHERE fp.faturamento_produto < mp.media
ORDER BY fp.faturamento_produto ASC;


-- EXERCÍCIO 4
WITH stats_pedidos_cliente AS (
    SELECT 
        ped.id_cliente,
        COUNT(DISTINCT ped.id_pedido) as qtd_pedidos,
        SUM(ip.preco_unitario * ip.quantidade) as faturamento_total
    FROM pedidos ped
    INNER JOIN itens_pedido ip 
		ON ped.id_pedido = ip.id_pedido
    WHERE ped.status = 'Confirmado'
    GROUP BY ped.id_cliente
		HAVING COUNT(DISTINCT ped.id_pedido) > 1
),
media_global AS (
    SELECT AVG(faturamento_total) as media_faturamento_geral 
    FROM stats_pedidos_cliente
)
SELECT 
    c.nome,
    s.qtd_pedidos,
    s.faturamento_total
FROM clientes c
INNER JOIN stats_pedidos_cliente as s 
	ON c.id_cliente = s.id_cliente
CROSS JOIN media_global m
WHERE s.faturamento_total > m.media_faturamento_geral
ORDER BY s.faturamento_total DESC;


-- EXERCÍCIO 5
WITH info_produto as (
	SELECT
		prod.id_produto,
		prod.nome as nome,
		SUM(ip.quantidade) as qtd_vendida,
		SUM(ip.preco_unitario * ip.quantidade) as faturamento_produto
	FROM produtos as prod
		INNER JOIN itens_pedido as ip
			ON prod.id_produto = ip.id_produto
		INNER JOIN pedidos as ped
			ON ip.id_pedido = ped.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY prod.id_produto, prod.nome
),
media_produtos as (
	SELECT
		AVG(faturamento_produto) media
    FROM info_produto
)

SELECT
	ipr.nome,
    ipr.qtd_vendida,
    ipr.faturamento_produto
FROM info_produto as ipr
	CROSS JOIN media_produtos as md
WHERE ipr.faturamento_produto > md.media AND ipr.qtd_vendida > 2
ORDER BY ipr.faturamento_produto DESC;


-- EXERCÍCIO 6
WITH metricas_mensais AS (
    SELECT
        YEAR(ped.data_pedido) AS ano,
        MONTH(ped.data_pedido) AS mes,
        SUM(ip.preco_unitario * ip.quantidade) AS faturamento_mensal,
        COUNT(DISTINCT ped.id_pedido) AS qtd_pedidos_mensal 
    FROM itens_pedido AS ip
    INNER JOIN pedidos AS ped ON ip.id_pedido = ped.id_pedido
    WHERE ped.status = 'Confirmado'
    GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
), 
medias_globais AS (
    SELECT
        AVG(faturamento_mensal) AS media_fat_global,
        AVG(qtd_pedidos_mensal) AS media_qtd_global
    FROM metricas_mensais
)

SELECT
    m.ano,
    m.mes,
    m.faturamento_mensal,
    m.qtd_pedidos_mensal
FROM metricas_mensais AS m
	CROSS JOIN medias_globais AS g
WHERE m.faturamento_mensal < g.media_fat_global AND m.qtd_pedidos_mensal > g.media_qtd_global      
ORDER BY m.faturamento_mensal ASC;

		
		 