-- =====================================================
-- ARQUIVO: inserts
-- OBJETIVO: Inserção de dados nas tabelas
-- =====================================================

-- =====================================================
-- TABELA: CLIENTES
-- =====================================================
INSERT INTO clientes (nome, email) VALUES 
('Ricardo Oliveira', 'ricardo.oli@email.com'),
('Mariana Souza', 'mari.souza@email.com'),
('Carlos Alberto', 'carlos.beto@email.com'),
('Ana Beatriz', 'ana.bia@email.com'),
('Lucas Mendes', 'lucas.m@email.com');

INSERT INTO clientes (nome, email) VALUES
('Fernanda Lima', 'fernanda@email.com'),
('João Pedro', 'joao@email.com'),
('Patricia Gomes', 'patricia@email.com');

select * from clientes;

-- =====================================================
-- TABELA: PRODUTOS
-- =====================================================
INSERT INTO produtos (nome, preco) VALUES
('Fone de Ouvido Bluetooth', 189.90),
('Teclado Mecânico RGB', 350.00),
('Monitor Gamer 24"', 1250.00),
('Cadeira Ergonômica', 890.00),
('Smartphone 128GB', 1950.00);

INSERT INTO produtos (nome, preco) VALUES
('Webcam Full HD', 299.90),
('Mouse Vertical', 159.90);

select * from produtos;

-- =====================================================
-- TABELA: PEDIDOS
-- =====================================================
INSERT INTO pedidos (id_cliente, data_pedido, status) VALUES 
-- Outubro
(1, '2023-10-01', 'Confirmado'),
(2, '2023-10-02', 'Confirmado'),
(1, '2023-10-03', 'Cancelado'),
(3, '2023-10-05', 'Confirmado'),
(2, '2023-10-07', 'Bloqueado'), 
(4, '2023-10-10', 'Confirmado'),
(5, '2023-10-12', 'Cancelado'),
(1, '2023-10-15', 'Confirmado');

INSERT INTO pedidos (id_cliente, data_pedido, status) VALUES
-- Novembro
(2, '2023-11-03', 'Confirmado'),
(3, '2023-11-08', 'Confirmado'),
(5, '2023-11-15', 'Cancelado'),
(1, '2023-11-20', 'Confirmado'),
-- Dezembro
(4, '2023-12-02', 'Confirmado'),
(2, '2023-12-10', 'Bloqueado'),
(3, '2023-12-18', 'Confirmado'),
(5, '2023-12-22', 'Confirmado'),
-- Janeiro
(1, '2024-01-05', 'Confirmado'),
(4, '2024-01-11', 'Cancelado'),
(2, '2024-01-19', 'Confirmado'),
(3, '2024-01-25', 'Confirmado');

select * from pedidos;

-- =====================================================
-- TABELA: ITENS_PEDIDO
-- =====================================================
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES 
-- Pedido 1: Compras variadas
(1, 1, 2, 189.90), 
(1, 2, 1, 350.00), 
(1, 3, 1, 1250.00),
-- Pedido 2: Cliente comprou monitor e teclado
(2, 3, 1, 1250.00),
(2, 2, 3, 350.00),
-- Pedido 3: Apenas um fone
(3, 1, 1, 189.90),
-- Pedido 4: Itens de escritório
(4, 4, 1, 890.00), 
(4, 5, 2, 1950.00),
-- Pedido 5: Repetindo produtos em pedidos diferentes
(5, 2, 2, 350.00),
(5, 5, 2, 1950.00),
-- Pedido 6:
(6, 3, 1, 1250.00), 
(6, 1, 3, 189.90),
-- Pedido 7:
(7, 4, 1, 890.00),
-- Pedido 8: O pedido mais completo
(8, 5, 1, 1950.00), 
(8, 1, 4, 189.90);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
-- Pedido 9
(9, 1, 1, 189.90),
(9, 5, 1, 1950.00),
-- Pedido 10
(10, 3, 2, 1250.00),
-- Pedido 11
(11, 2, 1, 350.00),
-- Pedido 12
(12, 4, 1, 890.00),
(12, 1, 2, 189.90),
-- Pedido 13
(13, 5, 1, 1950.00),
-- Pedido 14
(14, 2, 2, 350.00),
-- Pedido 15
(15, 3, 1, 1250.00),
(15, 4, 1, 890.00),
-- Pedido 16
(16, 1, 5, 189.90),
-- Pedido 17
(17, 5, 2, 1950.00),
-- Pedido 18
(18, 4, 1, 890.00),
-- Pedido 19
(19, 2, 3, 350.00),
(19, 3, 1, 1250.00),
-- Pedido 20
(20, 1, 2, 189.90),
(20, 5, 1, 1950.00);

select * from itens_pedido;