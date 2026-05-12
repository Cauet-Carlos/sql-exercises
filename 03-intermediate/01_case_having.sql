-- =====================================================
-- CONSULTA 1
-- OBJETIVO: Classificar pedidos por faixa de faturamento
-- =====================================================
SELECT
    ped.id_pedido,
    ROUND(SUM(i.quantidade * i.preco_unitario), 2) AS valor_total,
    CASE
        WHEN SUM(i.quantidade * i.preco_unitario) < 500 THEN 'Baixo'
        WHEN SUM(i.quantidade * i.preco_unitario)
            BETWEEN 500 AND 1500 THEN 'Médio'
        ELSE 'Alto'
    END AS classificacao_pedido
FROM pedidos ped
INNER JOIN itens_pedido i
    ON ped.id_pedido = i.id_pedido
GROUP BY ped.id_pedido;


-- =====================================================
-- CONSULTA 2
-- OBJETIVO: Mostrar pedidos com faturamento acima de 1000
-- =====================================================
SELECT 
	ped.id_pedido,
    round(sum(i.quantidade * i.preco_unitario), 2) as valor_total_pedido
FROM pedidos as ped 
INNER JOIN itens_pedido as i 
	ON ped.id_pedido = i.id_pedido
GROUP BY ped.id_pedido
HAVING valor_total_pedido > 1000;


-- =====================================================
-- CONSULTA 3
-- OBJETIVO: Identificar clientes que mais compram
-- =====================================================
SELECT
    c.nome,
    COUNT(DISTINCT ped.id_pedido) AS total_pedidos,
    round(sum(i.quantidade * i.preco_unitario), 2) as valor_total_cliente
FROM clientes as c
INNER JOIN pedidos as ped
	ON c.id_cliente = ped.id_cliente 
INNER JOIN itens_pedido as i 
	ON i.id_pedido = ped.id_pedido
GROUP BY c.id_cliente, c.nome
ORDER BY valor_total_cliente DESC
LIMIT 3;