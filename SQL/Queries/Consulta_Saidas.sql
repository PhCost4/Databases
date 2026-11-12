-- =====================================================================
-- ANÁLISE DE OF: Consumo e Saídas entre Departamentos
-- Descrição: Consulta SQL Server para apuração de transferências internas, 
-- consumo departamental e controle de perdas operacionais.
-- =====================================================================

SELECT 
    saida.data_criacao,
    saida.data_validacao,
    saida.data_entrega,
    saida.numero_documento,
    saida.ativo,
    saida.origem_mobile,
    det_saida.nome_item AS item_nome,
    det_saida.unidade_armazenamento,
    det_saida.valor_total,
    det_saida.quantidade,
    filial.codigo AS codigo_filial,
    grp.nome AS grupo_produto,
    subgrp.nome AS subgrupo_produto,
    local_destino.titulo AS local_destino,
    local_origem.titulo AS local_origem
FROM dbo.fato_saidas_estoque AS saida
LEFT JOIN dbo.fato_detalhes_saidas_estoque AS det_saida ON saida.id = det_saida.saida_estoque_id
LEFT JOIN dbo.dim_locais_armazenagem AS local_origem_ref ON local_origem_ref.id = saida.local_origem_id
LEFT JOIN dbo.dim_filiais AS filial ON filial.id = local_origem_ref.filial_id
LEFT JOIN dbo.dim_grupos_produtos AS grp ON grp.id = det_saida.grupo_produto_id
LEFT JOIN dbo.dim_subgrupos_produtos AS subgrp ON subgrp.id = det_saida.subgrupo_produto_id
LEFT JOIN dbo.dim_locais_armazenagem AS local_destino ON local_destino.id = saida.local_destino_id
LEFT JOIN dbo.dim_locais_armazenagem AS local_origem ON local_origem.id = saida.local_origem_id
WHERE CAST(saida.data_entrega AS Date) > '2025-09-30' 
  AND saida.ativo = 1;
