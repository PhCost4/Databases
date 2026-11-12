-- =====================================================================
-- ANÁLISE DE ESTOQUE: Posição Diária (Day by Day) e Histórico
-- Descrição: Consultas SQL Server para rastreamento de saldo, giro 
-- e movimentações de estoque por filial, armazém e categoria de produto.
-- =====================================================================


-- 1. Posição Atual de Estoque Filtrada (Day by Day)
-- Objetivo: Identificar o saldo atual e preço médio dos itens ativos 
-- que possuem quantidade em estoque maior que zero, agrupados por local.

SELECT
    MAX(mov.data_validacao) AS max_data_validacao,
    prod.nome AS item,
    MAX(est.preco_medio) AS preco_unitario,
    MAX(est.quantidade_armazenada) AS max_quantidade_armazenada,
    local_armazenagem.titulo AS local_armazenagem,
    filial.codigo AS codigo_filial,
    grp.nome AS grupo_produto,
    subgrp.nome AS subgrupo_produto,
    familia.nome AS familia_produto,
    unidade.codigo AS unidade_medida
FROM dbo.fato_movimentacao_estoque AS mov   
LEFT JOIN dbo.dim_estoque_itens AS est ON mov.estoque_item_id = est.id   
LEFT JOIN dbo.dim_locais_armazenagem AS local_armazenagem ON local_armazenagem.id = est.local_armazenagem_id   
LEFT JOIN dbo.dim_filiais AS filial ON filial.id = local_armazenagem.filial_id   
LEFT JOIN dbo.dim_produtos AS prod ON prod.id = est.produto_id   
LEFT JOIN dbo.dim_grupos_produtos AS grp ON grp.id = prod.grupo_id   
LEFT JOIN dbo.dim_subgrupos_produtos AS subgrp ON subgrp.id = prod.subgrupo_id   
LEFT JOIN dbo.dim_familia_grupos AS familia ON familia.id = grp.familia_id
LEFT JOIN dbo.dim_unidades_producao AS unidade ON unidade.id = prod.unidade_producao_id   
LEFT JOIN dbo.dim_unidades_armazenamento AS unidade_armazenamento ON unidade_armazenamento.id = est.unidade_armazenamento_id
WHERE prod.ativo = 1
  AND est.quantidade_armazenada > 0.0000
GROUP BY    
    prod.nome,
    local_armazenagem.titulo,
    filial.codigo,
    grp.nome,
    subgrp.nome,
    familia.nome,
    unidade.codigo;


-- 2. Histórico de Movimentação de Estoque (Janela Móvel)
-- Objetivo: Rastrear o histórico de entradas, saídas e variações de quantidade 
-- (quantidade antiga vs. quantidade nova) no último mês fechado até a data atual.

SELECT
    mov.data_validacao,
    prod.nome AS item,
    prod.id AS id_item,
    est.preco_medio AS preco_unitario,
    est.quantidade_armazenada AS quantidade_armazenada,
    mov.quantidade_antiga AS qtd_antiga,
    mov.quantidade_nova AS qtd_nova,
    est.quantidade_producao_item,
    local_armazenagem.titulo AS local_armazenagem,
    filial.codigo AS codigo_filial,
    grp.nome AS grupo_produto,
    subgrp.nome AS subgrupo_produto,
    familia.nome AS familia_produto,
    unidade_armazenamento.nome AS unidade_armazenamento
FROM dbo.fato_movimentacao_estoque AS mov
LEFT JOIN dbo.dim_estoque_itens AS est ON mov.estoque_item_id = est.id
LEFT JOIN dbo.dim_locais_armazenagem AS local_armazenagem ON local_armazenagem.id = est.local_armazenagem_id
LEFT JOIN dbo.dim_filiais AS filial ON filial.id = local_armazenagem.filial_id
LEFT JOIN dbo.dim_produtos AS prod ON prod.id = est.produto_id
LEFT JOIN dbo.dim_grupos_produtos AS grp ON grp.id = prod.grupo_id
LEFT JOIN dbo.dim_subgrupos_produtos AS subgrp ON subgrp.id = prod.subgrupo_id
LEFT JOIN dbo.dim_familia_grupos AS familia ON familia.id = grp.familia_id
LEFT JOIN dbo.dim_unidades_producao AS unidade ON unidade.id = prod.unidade_producao_id
LEFT JOIN dbo.dim_unidades_armazenamento AS unidade_armazenamento ON unidade_armazenamento.id = est.unidade_armazenamento_id
WHERE mov.data_validacao >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
  AND mov.data_validacao <= GETDATE()
GROUP BY
    mov.data_validacao,
    prod.nome,
    prod.id,
    est.preco_medio,
    est.quantidade_armazenada,
    mov.quantidade_antiga,
    mov.quantidade_nova,
    est.quantidade_producao_item,
    local_armazenagem.titulo,
    filial.codigo,
    grp.nome,
    subgrp.nome,
    familia.nome,
    unidade_armazenamento.nome;
