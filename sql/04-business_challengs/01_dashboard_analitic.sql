-- =========================================================================
-- CHALLENGE 1
-- OBJETIVO: Dashboard analítico SQL
-- =========================================================================
WITH status_pedidos as (
	SELECT
		YEAR(ped.data_pedido) as ano,
		MONTH(ped.data_pedido) as mes,
		SUM(ip.quantidade * ip.preco_unitario) as faturamento,
		LAG(SUM(ip.quantidade * ip.preco_unitario)) 
			OVER(ORDER BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)) as fat_anterior
	FROM pedidos as ped
		INNER JOIN itens_pedido as ip
			ON ped.id_pedido = ip.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
),
metricas as (
	SELECT
		sp.ano,
        sp.mes,
        sp.faturamento,
        SUM(faturamento)
			OVER(order by ano, mes) as acumulado,
		ROUND(AVG(faturamento)
			OVER(order by ano, mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) as media_movel,
		ROUND(((faturamento - fat_anterior) / fat_anterior * 100), 2) as crescimento_percentual,
        RANK() OVER(partition by ano order by faturamento DESC) as ranking
    FROM status_pedidos as sp
)
SELECT
	ano,
    mes,
    faturamento,
    acumulado,
    media_movel,
    crescimento_percentual,
    ranking
FROM metricas;