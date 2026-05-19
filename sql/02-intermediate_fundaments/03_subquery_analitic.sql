SELECT
	prod.id_produto,
    prod.nome
FROM produtos as prod
WHERE prod.preco > (
	SELECT
		AVG(pod.preco)
    FROM produtos as pod
); 

SELECT 
	c.id_cliente,
    c.nome
FROM clientes as c
WHERE c.id_cliente IN (
	SELECT 
		ped.id_cliente
    FROM pedidos as ped
    WHERE ped.status = 'cancelado'
);

SELECT 
	c.id_cliente,
    c.nome
FROM clientes as c
WHERE EXISTS (
	SELECT 1
    FROM pedidos as ped
    WHERE ped.id_cliente = c.id_cliente and
    ped.status = 'confirmado'
);

SELECT 
	id_pedido,
    SUM(ip.quantidade * ip.preco_unitario) as valor_total_pedido
FROM itens_pedido as ip
GROUP BY id_pedido
HAVING SUM(ip.quantidade * ip.preco_unitario) > (
	SELECT
		SUM(ip.quantidade * ip.preco_unitario) / COUNT(DISTINCT ip.id_pedido)
        FROM itens_pedido as ip
);

SELECT 
	AVG(faturamento_total) as media_faturamento_mensal
FROM (
	SELECT
		SUM(ip.preco_unitario * ip.quantidade) as faturamento_total
    FROM itens_pedido as ip
    INNER JOIN pedidos as ped
		ON ip.id_pedido = ped.id_pedido
	WHERE ped.status = 'Confirmado'
	GROUP BY YEAR(ped.data_pedido), MONTH(ped.data_pedido)
) AS faturamento_mensal;


SELECT 
	ped.id_cliente,
    c.nome,
    round(sum(ip.preco_unitario * ip.quantidade), 2) as faturamento_cliente
FROM itens_pedido as ip
	INNER JOIN pedidos as ped
		ON ip.id_pedido = ped.id_pedido
	INNER JOIN clientes as c
		ON ped.id_cliente = c.id_cliente
WHERE ped.status = 'Confirmado'
GROUP BY ped.id_cliente, c.nome
HAVING sum(ip.preco_unitario * ip.quantidade) < (
	SELECT 
		avg(faturamento_cliente)
    FROM (
        SELECT
			round(sum(ip2.preco_unitario * ip2.quantidade), 2) as faturamento_cliente
		FROM itens_pedido as ip2
			INNER JOIN pedidos as ped2
				ON ip2.id_pedido = ped2.id_pedido
		WHERE ped2.status = 'Confirmado'
		GROUP BY ped2.id_cliente
	) as media_clientes
)
ORDER BY faturamento_cliente DESC;


SELECT
	prod.id_produto,
    prod.nome
FROM produtos as prod
WHERE NOT EXISTS (
	SELECT 1
    FROM itens_pedido as ip
		INNER JOIN pedidos as ped
			ON ip.id_pedido = ped.id_pedido
    WHERE prod.id_produto = ip.id_produto and ped.status = 'Confirmado'
);


SELECT 
	ped.id_pedido,
    round(sum(ip.preco_unitario * ip.quantidade), 2) as faturamento_pedido,
    date_format(ped.data_pedido, '%m/%Y') as mês
FROM pedidos as ped
	INNER JOIN itens_pedido as ip
		ON ped.id_pedido = ip.id_pedido
WHERE ped.status = 'Confirmado'
GROUP BY ped.id_pedido
HAVING sum(ip.preco_unitario * ip.quantidade) > (
	SELECT
		avg(valor_pedido)
	FROM (
		SELECT
			sum(ip2.preco_unitario * ip2.quantidade) as valor_pedido
		FROM itens_pedido as ip2
			INNER JOIN pedidos as ped2
				ON ip2.id_pedido = ped2.id_pedido
		WHERE ped2.status = 'Confirmado'
		GROUP BY ped2.id_pedido
	) as media_pedidos
);

	
SELECT
	c.nome as cliente,
    COUNT(ped.id_pedido) as qtd_pedido
FROM clientes as c
	INNER JOIN pedidos as ped
		ON c.id_cliente = ped.id_cliente
GROUP BY c.id_cliente, c.nome
HAVING COUNT(ped.id_pedido) > (
    SELECT
        AVG(qtd_pedidos)
    FROM (
        SELECT
            COUNT(ped2.id_pedido) AS qtd_pedidos
        FROM pedidos AS ped2
        GROUP BY ped2.id_cliente
    ) AS media_clientes
)
ORDER BY qtd_pedidos DESC;


SELECT 
	prod.id_produto,
	prod.nome as produto,
    sum(ip.preco_unitario * ip.quantidade) as total_vendido
FROM produtos as prod
	INNER JOIN itens_pedido as ip
		ON prod.id_produto = ip.id_produto
	INNER JOIN pedidos as ped
		ON ip.id_pedido = ped.id_pedido
WHERE ped.status = 'Confirmado'
GROUP BY prod.id_produto, prod.nome
HAVING sum(ip.preco_unitario * ip.quantidade) > (
	SELECT 
		avg(total_vendido_produto)
	FROM (
		SELECT
			MONTH(ped.data_pedido),
			sum(ip.preco_unitario * ip.quantidade) as total_vendido_produto
		FROM itens_pedido as ip
			INNER JOIN pedidos as ped
				ON ip.id_pedido = ped.id_pedido
		WHERE ped.status = 'Confirmado'
		GROUP BY ip2.id_produto
	) as media_mensal
)
ORDER BY total_vendido DESC;