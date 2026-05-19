-- =========================================================================
-- CONSULTA 1
-- OBJETIVO: Evolução do faturamento mensal
-- =========================================================================
SELECT 
    YEAR(ped.data_pedido) as ano,
    MONTH(ped.data_pedido) as mes,
    ROUND(SUM(i.quantidade * i.preco_unitario), 2) as faturamento_mensal
FROM pedidos as ped
INNER JOIN itens_pedido as i
    ON ped.id_pedido = i.id_pedido
WHERE ped.status = 'Confirmado'
GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
ORDER BY ano ASC, mes ASC;


-- =========================================================================
-- CONSULTA 2
-- OBJETIVO: Volume de pedidos confirmados por mês
-- =========================================================================
SELECT
    YEAR(ped.data_pedido) as ano,
    MONTH(ped.data_pedido) as mes,
    COUNT(ped.id_pedido) as total_pedidos
FROM pedidos as ped
WHERE status = 'Confirmado'
GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
ORDER BY ano ASC, mes ASC;


-- =========================================================================
-- CONSULTA 3
-- OBJETIVO: Cálculo do ticket médio mensal
-- =========================================================================
SELECT
    YEAR(ped.data_pedido) as ano,
    MONTH(ped.data_pedido) as mes,
    ROUND((SUM(i.quantidade * i.preco_unitario) / COUNT(DISTINCT ped.id_pedido)), 2) as ticket_medio
FROM pedidos as ped
INNER JOIN itens_pedido as i
    ON ped.id_pedido = i.id_pedido
WHERE status = 'Confirmado'
GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
ORDER BY ano ASC, mes ASC;


-- =========================================================================
-- CONSULTA 4
-- OBJETIVO: Visão consolidada (Faturamento, Qtd e Ticket Médio)
-- =========================================================================
SELECT
    YEAR(ped.data_pedido) as ano,
    MONTH(ped.data_pedido) as mes,
    SUM(i.quantidade * i.preco_unitario) as faturamento_mensal,
    COUNT(DISTINCT ped.id_pedido) as total_pedidos,
    ROUND((SUM(i.quantidade * i.preco_unitario) / COUNT(DISTINCT ped.id_pedido)), 2) as ticket_medio
FROM pedidos as ped
INNER JOIN itens_pedido as i
    ON ped.id_pedido = i.id_pedido
WHERE status = 'Confirmado'
GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
ORDER BY ano ASC, mes ASC;


-- =========================================================================
-- CONSULTA 5
-- OBJETIVO: Identificar o mês com maior faturamento histórico
-- =========================================================================
SELECT 
    YEAR(data_pedido) as ano,
    MONTH(data_pedido) as mes,
    ROUND(SUM(i.quantidade * i.preco_unitario), 2) as faturamento_melhor_mes
FROM itens_pedido as i
INNER JOIN pedidos as ped
    ON i.id_pedido = ped.id_pedido
WHERE status = 'Confirmado'
GROUP BY YEAR(data_pedido), MONTH(data_pedido)
ORDER BY faturamento_melhor_mes DESC
LIMIT 1;


-- =========================================================================
-- CONSULTA 6
-- OBJETIVO: Identificar o mês com maior volume de pedidos
-- =========================================================================
SELECT 
    YEAR(data_pedido) as ano,
    MONTH(data_pedido) as mes,
    COUNT(id_pedido) as maior_qtd_pedidos
FROM pedidos as ped
WHERE status = 'Confirmado'
GROUP BY YEAR(data_pedido), MONTH(data_pedido)
ORDER BY maior_qtd_pedidos DESC
LIMIT 1;


-- =========================================================================
-- CONSULTA 7
-- OBJETIVO: Ranking mensal de faturamento (Geral)
-- =========================================================================
SELECT 
    YEAR(data_pedido) as ano,
    MONTH(data_pedido) as mes,
    ROUND(SUM(i.quantidade * i.preco_unitario), 2) as faturamento_melhor_mes
FROM itens_pedido as i
INNER JOIN pedidos as ped
    ON i.id_pedido = ped.id_pedido
WHERE status = 'Confirmado'
GROUP BY YEAR(data_pedido), MONTH(data_pedido)
ORDER BY faturamento_melhor_mes DESC;

