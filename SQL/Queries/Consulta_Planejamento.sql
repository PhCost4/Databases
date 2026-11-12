-- =====================================================================
-- ANÁLISE DE NEEDS: Planejamento de Consumo e Ordens de Suprimento
-- Descrição: Consulta SQL Server para rastrear o planejamento de consumo 
-- e ordens de suprimento associadas na operação logística.
-- =====================================================================

SELECT 
    ord.data_entrega,
    ord.data_validacao,
    ord.numero_ordem AS numero_so,
    ord.observacao AS comentario,
    det_ord.nome_item AS item_nome,
    det_ord.quantidade * det_ord.fator_unidade_armazenamento AS qtd_unidade_armazenamento,
    det_ord.preco_unitario,
    det_ord.preco_total,
    grp.nome AS grupo_produto,	
    subgrp.nome AS subgrupo_produto,
    local_armazenagem.titulo AS local_armazenagem,
    filial.codigo AS codigo_filial,
    forn.nome AS fornecedor
FROM dbo.fato_ordens_suprimento AS ord
LEFT JOIN dbo.fato_detalhes_ordens_suprimento AS det_ord ON ord.id = det_ord.ordem_suprimento_id
LEFT JOIN dbo.dim_grupos_produtos AS grp ON grp.id = det_ord.grupo_produto_id
LEFT JOIN dbo.dim_subgrupos_produtos AS subgrp ON subgrp.id = det_ord.subgrupo_produto_id
LEFT JOIN dbo.dim_locais_armazenagem AS local_armazenagem ON local_armazenagem.id = ord.local_armazenagem_id
LEFT JOIN dbo.dim_filiais AS filial ON filial.id = local_armazenagem.filial_id
LEFT JOIN dbo.dim_fornecedores AS forn ON forn.id = det_ord.fornecedor_id
WHERE CAST(ord.data_entrega AS Date) > '2025-12-31' 
  AND (ord.observacao LIKE '%PLANEJAMENTO_CONSUMO_PADRAO%' 
       OR ord.observacao LIKE '%PLANEJAMENTO_DEMANDA_OPERACIONAL%');
