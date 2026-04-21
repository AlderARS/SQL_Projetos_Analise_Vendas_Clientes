Esta é uma Análise de Vendas e Clientes (Nível Avançado com SQL), analisando a performance comercial de uma loja de aparelhos de tecnologia. Base de dados essa fictícia usada apenas para aprendizado e testes.

Os Schemas utilizados estão anexados e são:
- pedidos
- clientes
- produtos
- categorias

Na Etapa 1: Dediquei tempo para conhecer o banco. 
Na Etapa 2: Explorei receita mensal, top clientes e outros. 
Na Etapa 3: Verifiquei os Dados principalmente datas, nulos e relacionamento entre tabelas para fazer ou não o tratamento de dados. 
Na Etapa 4: Desenvolvi análises de Receita e Crescimento MoM e de frequência de compra dos Clientes . 
Na Etapa 5: Realizei um ranqueamento segmentado da categoria dos produtos para identificar as categorias mais procuradas e compradas, analisei a receita acumulada mes a mes e dia a dia, fiz um cohort para identificar quando os clientes começam a comprar, descobri o ticket médio, separei as datas de primeira e ultima compra dos clientes, Criei uma ferramenta para dar status e fazer contagem a clientes que compram mais de uma vez ou que fizeram apenas uma compra e por fim uma query simples e importante para ver a quantidade de pedidos por mes.

Insights Obtidos através dessa analise:
-- Clientes Compram Geralmente Um Único Produto Por Vez
-- A Categoria Headphones é Responsável Por 93% das Vendas 
-- O TOP Produto do Ano É: Headphone Bluetooth 2000
-- Os Clientes Geralmente Começam a Comprar Principalmente No Início de Janeiro (Presente de Ano Novo?)
-- 83% dos Clientes Cadastrados Retornam Para Comprar Novamente
-- Fevereiro, Abril e Outubro Tiveram Um Nível Baixíssimo de Vendas
-- Os Meses Com mais Vendas São Respectivamente Janeiro, Novembro e Dezembro
-- 23% dos Clientes São Responsáveis por 43% do Faturamento Bruto
-- Os 5 Melhores Clientes do Ano Foram Respectivamente Jill(ID: 26), Wyatt(ID: 15), Jimmy(ID: 27), Jamime(ID:31) e Damien(ID: 78)
