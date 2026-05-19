-- =====================================================
-- EXERCÍCIO 1
-- Liste produtos ordenados por preco crescente
-- =====================================================
SELECT *
FROM produtos
ORDER BY preco ASC;


-- =====================================================
-- EXERCÍCIO 2
-- Liste produtos ordenados por preco decrescente
-- =====================================================
SELECT *
FROM produtos
ORDER BY preco DESC;


-- =====================================================
-- EXERCÍCIO 3
-- Liste clientes em ordem alfabética
-- =====================================================
SELECT *
FROM clientes
ORDER BY nome ASC;


-- =====================================================
-- EXERCÍCIO 4
-- Liste pedidos mais recentes primeiro
-- =====================================================
SELECT *
FROM pedidos
ORDER BY data_pedido DESC;


-- =====================================================
-- EXERCÍCIO 5
-- Liste itens_pedido ordenados por quantidade
-- =====================================================
SELECT *
FROM itens_pedido
ORDER BY quantidade DESC;