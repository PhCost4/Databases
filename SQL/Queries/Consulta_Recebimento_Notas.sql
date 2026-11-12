-- =====================================================================
-- ANÁLISE DE RN: Recebimento de Notas Fiscais
-- Descrição: Consulta SQL Server para rastrear notas recebidas, 
-- controle de temperatura, conferência física e valores faturados.
-- =====================================================================

SELECT 
    nf.numero_nota,
    nf.data_entrega,
    nf.data_validacao,
    nf.sensor_bluetooth AS bluetooth,
    nf.origem_mobile,
    det_nf.temperatura_aferida AS temperatura,
    nf.temperatura_manual,
    det_nf.tipo_medicao_temperatura,
    det_nf.unidade_embalagem,
    det_nf.nome_item AS item_nome,
    det_nf.valor_total,
    det_nf.nome_grupo_item AS grupo_produto,
    det_nf.quantidade_recebida * det_nf.fator_unidade_armazenamento AS quantidade_recebida,
    det_nf.preco_embalagem / det_nf.fator_unidade_armazenamento AS preco_unitario,
    subgrp.nome AS subgrupo_produto,
    forn.nome AS fornecedor,
    filial.codigo AS codigo_filial,
    familia.nome AS familia_produto
FROM dbo.fato_notas_recebidas AS nf
LEFT JOIN dbo.fato_detalhes_notas_recebidas AS det_nf ON nf.id = det_nf.nota_recebida_id
LEFT JOIN dbo.dim_subgrupos_produtos AS subgrp ON subgrp.id = det_nf.subgrupo_produto_id	
LEFT JOIN dbo.dim_fornecedores AS forn ON forn.id = det_nf.fornecedor_id
LEFT JOIN dbo.dim_locais_armazenagem AS local_armazenagem ON local_armazenagem.id = nf.local_armazenagem_id 
LEFT JOIN dbo.dim_filiais AS filial ON filial.id = local_armazenagem.filial_id
LEFT JOIN dbo.dim_grupos_produtos AS grp ON grp.id = det_nf.grupo_produto_id
LEFT JOIN dbo.dim_familia_grupos AS familia ON familia.id = grp.familia_id
WHERE CAST(nf.data_entrega AS Date) > '2025-12-31' 
  AND nf.ativo = 1;
