-- =====================================================
-- EXERCÍCIO 1
-- Liste produtos com preco maior que 100
-- =====================================================
SELECT *
FROM produtos
WHERE preco > 100;


-- =====================================================
-- EXERCÍCIO 2
-- Liste pedidos com status 'Entregue'
-- =====================================================
SELECT *
FROM pedidos
WHERE status = 'Confirmado';


-- =====================================================
-- EXERCÍCIO 3
-- Liste produtos com preco menor que 50
-- =====================================================
SELECT *
FROM produtos
WHERE preco < 50;


-- =====================================================
-- EXERCÍCIO 4
-- Liste itens_pedido com quantidade maior ou igual a 3
-- =====================================================
SELECT *
FROM itens_pedido
WHERE quantidade >= 3;


-- =====================================================
-- EXERCÍCIO 5
-- Liste produtos com preco diferente de 200
-- =====================================================
SELECT *
FROM produtos
WHERE preco <> 200;