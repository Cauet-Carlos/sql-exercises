-- =====================================================
-- CONSULTA 1
-- OBJETIVO: Listar pedidos com informações do cliente
-- =====================================================
SELECT 
	p.id_pedido as ID,
    c.nome as NOME,
    p.data_pedido as DATA,
    p.status as STATUS
FROM pedidos as p
INNER JOIN clientes as c
	ON p.id_cliente = c.id_cliente;
    
    
-- =====================================================
-- CONSULTA 2
-- OBJETIVO: Listar itens dos pedidos com nome do produto
-- =====================================================
SELECT
	ped.id_pedido as ID_PED,
    prod.nome as NOME,
    i.quantidade as QTD,
    i.preco_unitario as PREÇO
FROM produtos as prod
INNER JOIN itens_pedido as i ON prod.id_produto = i.id_produto
INNER JOIN pedidos as ped ON i.id_pedido = ped.id_pedido;


-- =====================================================
-- CONSULTA 3
-- OBJETIVO: Mostrar valor total de cada item do pedido
-- =====================================================
SELECT
	i.id_item as ID_Item,
    prod.nome as Nome_Produto,
    i.quantidade as QTD,
    ROUND(i.quantidade * i.preco_unitario, 2) AS valor_total_item
FROM itens_pedido as i
INNER JOIN produtos as prod ON i.id_produto = prod.id_produto
ORDER BY ID_Item;

-- =====================================================
-- CONSULTA 4
-- OBJETIVO: Verificar clientes que não possuem pedidos
-- =====================================================
SELECT  
	c.id_cliente,
    c.nome,
    c.email
FROM clientes as c
LEFT JOIN pedidos as p 
	ON c.id_cliente = p.id_cliente
WHERE p.id_pedido IS NULL
ORDER BY c.nome;

-- =====================================================
-- CONSULTA 5
-- OBJETIVO: Verificar produtos que não possuem pedidos
-- =====================================================
SELECT
    prod.nome,
    prod.preco
FROM produtos as prod
LEFT JOIN itens_pedido as i
	ON prod.id_produto = i.id_produto
WHERE i.id_pedido IS NULL
ORDER BY preco DESC;

