-- =========================================================================
-- CONSULTA 1
-- OBJETIVO: Faturamento mês anteriot
-- =========================================================================
WITH faturamento_mensal as (
	SELECT
		YEAR(ped.data_pedido) as ano,
		MONTH(ped.data_pedido) as mes,
		SUM(ip.quantidade * ip.preco_unitario) as faturamento
	FROM pedidos as ped
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
)
SELECT
	fm.ano,
    fm.mes,
    fm.faturamento,
    lag(faturamento) 
		over(
			order by ano, mes
        ) fat_mes_anterior
FROM faturamento_mensal as fm;

-- =========================================================================
-- CONSULTA 2
-- OBJETIVO: Crescimento Mensal
-- =========================================================================
WITH faturamento_mensal as (
	SELECT
		YEAR(ped.data_pedido) as ano,
		MONTH(ped.data_pedido) as mes,
		SUM(ip.quantidade * ip.preco_unitario) as faturamento
	FROM pedidos as ped
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
), 
comparacao as (
	SELECT
		ano,
        mes,
        faturamento,
        LAG(faturamento) OVER (ORDER BY ano, mes) AS anterior
    FROM faturamento_mensal
)
SELECT
    ano,
    mes,
    faturamento,
    anterior,
    (faturamento - anterior) AS diferenca_absoluta,
    ROUND(((faturamento - anterior) / anterior) * 100, 2) AS crescimento_percentual
FROM comparacao;


-- =========================================================================
-- CONSULTA 3
-- OBJETIVO: Acumulado de faturamento
-- =========================================================================
WITH faturamento_mensal as (
	SELECT
		YEAR(ped.data_pedido) as ano,
		MONTH(ped.data_pedido) as mes,
		SUM(ip.quantidade * ip.preco_unitario) as faturamento
	FROM pedidos as ped
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
)
SELECT
	fm.faturamento,
    SUM(faturamento)
		over(
			order by ano, mes
        ) as fatur_acumulado
FROM faturamento_mensal as fm;


-- =========================================================================
-- CONSULTA 4
-- OBJETIVO: Ranking Temporal por cliente
-- =========================================================================
WITH status_cliente as (
	SELECT
		c.nome as nome,
		ped.id_pedido as pedido,
		ped.data_pedido as data,
		SUM(ip.quantidade * ip.preco_unitario) as valor
	FROM clientes as c
		INNER JOIN pedidos as ped
			ON c.id_cliente = ped.id_cliente
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY c.id_cliente, 
				c.nome, 
					ped.id_pedido,
						ped.data_pedido
)
SELECT
	sc.nome,
    sc.pedido,
    sc.data,
    sc.valor,
    row_number() 
		over(
			partition by nome
            order by data
        ) as ordem_pedido_cliente
FROM status_cliente as sc;





















