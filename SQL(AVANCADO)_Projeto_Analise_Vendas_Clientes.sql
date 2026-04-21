CREATE SCHEMA bancodedados;
USE bancodedados;
-- Importe as tablas em anexo (clientes, pedidos, produtos, categorias)

SELECT Qtd_Vendida, COUNT(Qtd_vendida) FROM pedidos GROUP BY Qtd_Vendida ORDER BY Qtd_Vendida ASC; -- Historicamente Vende-se Apenas uma Unidade por Pedido

SELECT COUNT(ID_Cliente) FROM clientes; -- 100 Clientes
SELECT COUNT(ID_Pedido) FROM pedidos; -- 374 Pedidos
SELECT SUM(Receita_Venda) FROM pedidos; -- 228.900 Faturamento Bruto

SELECT YEAR(Data_Venda) AS Ano, MONTH(Data_Venda) AS Mes, SUM(Receita_Venda) AS Faturamento 
FROM pedidos GROUP BY YEAR(Data_Venda), MONTH(Data_Venda) ORDER BY Ano, Mes; -- Receita por Mês

SELECT ID_Cliente, SUM(Receita_Venda) AS Total_Comprado
FROM pedidos GROUP BY ID_Cliente ORDER BY Total_Comprado DESC LIMIT 10; -- Top 10 Clientes
SELECT ID_Cliente, SUM(Receita_Venda) AS Total_Comprado, ROW_NUMBER() OVER(ORDER BY SUM(Receita_Venda) DESC) AS Ranking 
FROM pedidos GROUP BY ID_Cliente; -- Top clientes com Window Function

SELECT ID_Cliente FROM clientes WHERE ID_Cliente NOT IN (SELECT ID_Cliente FROM pedidos); -- Verificação entre Tabelas com Subqueries
SELECT c.ID_Cliente FROM clientes c LEFT JOIN pedidos p ON c.ID_Cliente = p.ID_Cliente WHERE p.ID_Cliente IS NULL; -- Verificação entre Tabelas com Join
SELECT * FROM pedidos WHERE STR_TO_DATE(Data_Venda, '%Y-%m-%d') IS NULL AND Data_Venda IS NOT NULL; -- Verificação de Datas
SELECT * FROM pedidos WHERE ID_Pedido IS NULL OR ID_Loja IS NULL OR ID_Produto IS NULL OR ID_Cliente IS NULL; -- Verificação de Nulos

WITH Ano_Mes AS (
SELECT YEAR(Data_Venda) AS Ano, MONTH(Data_Venda) AS Mes, SUM(Receita_Venda) AS Faturamento FROM pedidos GROUP BY YEAR(Data_Venda), MONTH(Data_Venda)
) SELECT Ano, Mes, Faturamento, LAG(Faturamento) OVER(ORDER BY mes) AS Faturamento_Anterior, Faturamento - LAG(Faturamento) OVER(ORDER BY mes) AS Crescimento
FROM Ano_Mes WHERE Ano = 2019; -- Crescimento Mes/Mes (MoM)

SELECT ID_Cliente, COUNT(ID_Pedido) AS Qtd_Pedidos FROM pedidos GROUP BY ID_Cliente ORDER BY Qtd_Pedidos DESC; -- Frequência de compra 

SELECT pr.Nome_Produto, c.Categoria, SUM(pd.Qtd_Vendida), RANK() OVER(PARTITION BY c.Categoria ORDER BY SUM(pd.Qtd_Vendida) DESC) AS Ranking_Segmentado
FROM pedidos pd JOIN produtos pr ON pd.ID_Produto = pr.ID_Produto JOIN categorias c ON pr.ID_Categoria = c.ID_Categoria
GROUP BY pr.Nome_Produto , c.Categoria ORDER BY pr.Nome_Produto ASC; -- Top Produtos por Categoria com Window Functions e Segmentação com Partition By

SELECT DISTINCT(MONTH(Data_Venda)), SUM(Receita_Venda) OVER(ORDER BY MONTH(Data_Venda)) Receita_Acumulada_MoM FROM pedidos; -- Receita Acumulada MoM
SELECT DISTINCT YEAR(Data_Venda) AS Ano, MONTH(Data_Venda) AS Mes, Data_Venda, SUM(Receita_Venda) OVER(ORDER BY Data_Venda) Receita_Acumulada_MoM FROM pedidos; -- Receita Acumulada DoD

WITH primeira_compra AS (
SELECT ID_Cliente, MIN(Data_Venda) AS Primeira_Data FROM pedidos GROUP BY ID_Cliente
) SELECT YEAR(Primeira_Data) AS Ano_Coorte, MONTH(Primeira_Data) AS Mes_Coorte, Primeira_Data, Count(*) AS Clientes 
FROM primeira_compra GROUP BY Primeira_Data ORDER BY Ano_Coorte ASC, Mes_Coorte ASC; -- Coorte (Quando os clientes começam a comprar)

SELECT AVG(Receita_Venda) AS Ticket_Medio FROM pedidos; -- $612 de Ticket Medio

SELECT ID_Cliente, MIN(Data_Venda) AS Primeira_Compra, CASE WHEN MIN(Data_Venda) <> MAX(Data_Venda) THEN MAX(Data_Venda) ELSE NULL END AS Ultima_Compra
FROM pedidos GROUP BY ID_Cliente ORDER BY Ultima_Compra DESC; -- Data Primeira Compra X Data Ultima Compra
-- Não faz sentido calcular LTV, Retenção ou Churn Neste Ambiente de Negócio

WITH base AS (
SELECT ID_Cliente, COUNT(*) AS Recorrencia FROM pedidos GROUP BY ID_Cliente
) SELECT ID_Cliente, CASE WHEN Recorrencia = 1 THEN 'Único' ELSE 'Recorrente' END AS Status_Cliente,
SUM(CASE WHEN Recorrencia > 1 THEN 1 ELSE 0 END) OVER () AS Total_Recorrentes,
SUM(CASE WHEN Recorrencia > 1 THEN 1 ELSE 1 END) OVER () AS Total_Clientes
FROM base; -- Clientes Recorrentes X Total Clientes

SELECT MONTH(Data_Venda) AS Mes, COUNT(ID_Pedido) FROM pedidos GROUP BY MONTH(Data_Venda) ORDER BY Mes ASC; -- Quantidade Pedidos X Mes

SELECT c.Nome, c.ID_Cliente, COUNT(p.ID_Pedido) AS Qtd_Pedidos FROM pedidos p JOIN clientes c ON p.ID_Cliente = c.ID_Cliente 
GROUP BY c.Nome, c.ID_Cliente ORDER BY Qtd_Pedidos DESC LIMIT 5 -- 5 Melhores Clientes

						-- INSIGHTS:

-- Clientes Compram Geralmente Um Único Produto Por Vez
-- A Categoria Headphones é Responsável Por 93% das Vendas 
-- O TOP Produto do Ano É: Headphone Bluetooth 2000
-- Os Clientes Geralmente Começam a Comprar Principalmente No Início de Janeiro (Presente de Ano Novo?)
-- 83% dos Clientes Cadastrados Retornam Para Comprar Novamente
-- Fevereiro, Abril e Outubro Tiveram Um Nível Baixíssimo de Vendas
-- Os Meses Com mais Vendas São Respectivamente Janeiro, Novembro e Dezembro
-- 23% dos Clientes São Responsáveis por 43% do Faturamento Bruto
-- Os 5 Melhores Clientes do Ano Foram Respectivamente Jill(ID: 26), Wyatt(ID: 15), Jimmy(ID: 27), Jamime(ID:31) e Damien(ID: 78)