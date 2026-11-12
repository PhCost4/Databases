-- =====================================================================
-- ANÁLISE DE PO: Abertura de Ordens de Compra
-- Descrição: Consulta SQL Server para monitoramento de ordens de compra 
-- ativas, volumes solicitados e valores consolidados.
-- =====================================================================

SELECT 
    pc.numero_pedido,
    pc.data_entrega,
    pc.data_validacao,
    pc.status AS status_pedido,
    det_pc.quantidade * det_pc.fator_unidade_armazenamento AS quantidade,
    det_pc.preco_unitario,
    det_pc.preco_total,
    det_pc.nome_item AS item,
    forn.nome AS fornecedor,
    grp.nome AS grupo_produto,	
    subgrp.nome AS subgrupo_produto,
    filial.codigo AS codigo_filial,
    familia.nome AS familia_produto
FROM dbo.fato_ordens_compra AS pc
LEFT JOIN dbo.fato_detalhes_ordens_compra AS det_pc ON det_pc.ordem_compra_id = pc.id
LEFT JOIN dbo.dim_fornecedores AS forn ON forn.id = pc.fornecedor_id
LEFT JOIN dbo.dim_grupos_produtos AS grp ON grp.id = det_pc.grupo_produto_id
LEFT JOIN dbo.dim_subgrupos_produtos AS subgrp ON subgrp.id = det_pc.subgrupo_produto_id
LEFT JOIN dbo.dim_locais_armazenagem AS local_armazenagem ON local_armazenagem.id = pc.local_armazenagem_id
LEFT JOIN dbo.dim_filiais AS filial ON filial.id = local_armazenagem.filial_id
LEFT JOIN dbo.dim_familia_grupos AS familia ON familia.id = grp.familia_id
WHERE CAST(pc.data_entrega AS Date) > '2025-09-30' 
  AND pc.status <> 3;
