-- =========================================================================
-- CONSULTA 1
-- OBJETIVO: Faturamento do próximo mês
-- =========================================================================
WITH status_pedido as (
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
	sp.ano,
    sp.mes,
    sp.faturamento,
    lead(faturamento) 
		over(
			order by ano, mes
        ) as faturamento_prox_mes
FROM status_pedido as sp;


-- =========================================================================
-- CONSULTA 2
-- OBJETIVO: Média Móvel
-- =========================================================================
WITH status_pedido as (
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
	sp.ano,
    sp.mes,
    sp.faturamento,
    ROUND(AVG(faturamento) 
		over(
            order by ano, mes
            ROWS BETWEEN 2 PRECEDING
			AND CURRENT ROW
        ), 2) as media_movel
FROM status_pedido as sp;
    

-- =========================================================================
-- CONSULTA 3
-- OBJETIVO: Utilização do FIRST_Value
-- =========================================================================
WITH status_pedido as (
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
escalas as (
	SELECT
		sp.ano,
		sp.mes,
		sp.faturamento,
        ROUND(FIRST_VALUE(faturamento) 
			over(order by ano, mes), 2) as fat_prim_mes,
        lead(faturamento) 
			over(order by ano, mes) as prox_linha
    FROM status_pedido as sp
) 
SELECT
	ano,
    mes,
    faturamento,
	fat_prim_mes,
    ROUND((faturamento - fat_prim_mes), 2) as diferenca
FROM escalas;


-- =========================================================================
-- CONSULTA 4
-- OBJETIVO: NTILE - Quartis de faturamento
-- =========================================================================
 WITH status_clientes as (
	SELECT
		c.id_cliente as id,
        c.nome as nome,
		SUM(ip.quantidade * ip.preco_unitario) as faturamento
	FROM clientes as c
		INNER JOIN pedidos as ped
			ON c.id_cliente = ped.id_cliente
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY c.id_cliente, c.nome
),
clientes_agrupados AS (
    SELECT 
        id,
        nome,
        faturamento,
        NTILE(4) OVER (ORDER BY faturamento DESC) as quartil
    FROM status_clientes
)
SELECT 
    id,
    nome,
    faturamento,
	quartil,
    CASE quartil
        WHEN 1 THEN 'Diamante'
        WHEN 2 THEN 'Ouro'
        WHEN 3 THEN 'Prata'
        WHEN 4 THEN 'Bronze'
    END as categoria
FROM clientes_agrupados;
    
    
    
    
    
    
    
    
    