-- =====================================================
-- EXERCÍCIO 1
-- Conte quantos pedidos existem por status
-- =====================================================
SELECT
    status,
    COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY status;


-- =====================================================
-- EXERCÍCIO 2
-- Mostre quantidade total de itens por pedido
-- =====================================================
SELECT
    id_pedido,
    SUM(quantidade) AS total_itens
FROM itens_pedido
GROUP BY id_pedido;


-- =====================================================
-- EXERCÍCIO 3
-- Mostre media de preco dos produtos
-- =====================================================
SELECT
    AVG(preco) AS media_preco
FROM produtos;


-- =====================================================
-- EXERCÍCIO 4
-- Mostre quantidade de itens cadastrados por produto
-- =====================================================
SELECT
    id_produto,
    COUNT(*) AS total_registros
FROM itens_pedido
GROUP BY id_produto;


-- =====================================================
-- EXERCÍCIO 5
-- Mostre valor total por pedido
-- =====================================================
SELECT
    id_pedido,
    SUM(quantidade * preco_unitario) AS valor_total
FROM itens_pedido
GROUP BY id_pedido;