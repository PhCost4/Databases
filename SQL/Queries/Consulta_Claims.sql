-- =====================================================================
-- ANÁLISE DE CLAIMS: Reclamações e Não-Conformidades de Fornecedores
-- Descrição: Consulta SQL Server para apuração de divergências, 
-- quebras de qualidade e penalidades em notas de fornecedores.
-- =====================================================================

SELECT 
    det_rec.quantidade_reclamada, 
    det_rec.preco_embalagem, 
    det_rec.nome_item AS item, 
    det_rec.comentario,
    det_rec.comentario_sancao,
    rec.comentario AS comentarios_nota,
    rec.data_criacao, 
    rec.data_entrega, 
    rec.data_validacao,
    det_rec.tipo_reclamacao_id,
    rec.status,
    rec.numero_reclamacao,
    forn.nome AS fornecedor,
    grp.nome AS grupo_produto,
    subgrp.nome AS subgrupo_produto,
    filial.codigo AS codigo_filial,
    local_armazenagem.titulo AS local_armazenagem,
    usuario.primeiro_nome AS criado_por,
    usuario.cargo AS cargo_criador,
    CASE 
         WHEN det_rec.tipo_reclamacao_id = 1 THEN 'NonCompliantDeliveredQuantity'
         WHEN det_rec.tipo_reclamacao_id = 2 THEN 'Yield'
         WHEN det_rec.tipo_reclamacao_id = 4 THEN 'NonCompliantCalibration'
         WHEN det_rec.tipo_reclamacao_id = 8 THEN 'WrongProductDelivered'
         WHEN det_rec.tipo_reclamacao_id = 16 THEN 'FlawFilth'
         WHEN det_rec.tipo_reclamacao_id = 32 THEN 'OutsideInvasion'
         WHEN det_rec.tipo_reclamacao_id = 64 THEN 'NonCompliantQuality'
         WHEN det_rec.tipo_reclamacao_id = 128 THEN 'NonCompliantLabel'
         WHEN det_rec.tipo_reclamacao_id = 256 THEN 'WrongInvoicedPrice'
         WHEN det_rec.tipo_reclamacao_id = 512 THEN 'NonCompliantExpirationDate'
         WHEN det_rec.tipo_reclamacao_id = 1024 THEN 'WrongFee'
         WHEN det_rec.tipo_reclamacao_id = 2048 THEN 'QuantityNotReceived'
         ELSE 'Multiple Claim Types'
    END AS tipo_reclamacao_en,
    CASE 
         WHEN det_rec.tipo_reclamacao_id = 1 THEN 'Quantidade Entregue Não-Conforme'
         WHEN det_rec.tipo_reclamacao_id = 2 THEN 'Rendimento'
         WHEN det_rec.tipo_reclamacao_id = 4 THEN 'Tamanho do Produto Não-Conforme'
         WHEN det_rec.tipo_reclamacao_id = 8 THEN 'Produto Entregue Errado'
         WHEN det_rec.tipo_reclamacao_id = 16 THEN 'Defeito/Sujidade'
         WHEN det_rec.tipo_reclamacao_id = 32 THEN 'Objetos Estranhos'
         WHEN det_rec.tipo_reclamacao_id = 64 THEN 'Qualidade Não-Conforme'
         WHEN det_rec.tipo_reclamacao_id = 128 THEN 'Etiqueta Não-Conforme'
         WHEN det_rec.tipo_reclamacao_id = 256 THEN 'Preço Faturado Incorreto'
         WHEN det_rec.tipo_reclamacao_id = 512 THEN 'Data de Validade Não-Conforme'
         WHEN det_rec.tipo_reclamacao_id = 1024 THEN 'Taxa/Impostos Incorreta'
         WHEN det_rec.tipo_reclamacao_id = 2048 THEN 'Quantidade Não Recebida'
         ELSE 'Outros - Sem Preenchimento'
    END AS tipo_reclamacao_br
FROM dbo.fato_detalhes_reclamacoes AS det_rec
LEFT JOIN dbo.fato_reclamacoes AS rec ON det_rec.reclamacao_id = rec.id
LEFT JOIN dbo.dim_fornecedores AS forn ON forn.id = det_rec.fornecedor_id
LEFT JOIN dbo.dim_grupos_produtos AS grp ON grp.id = det_rec.grupo_produto_id
LEFT JOIN dbo.dim_subgrupos_produtos AS subgrp ON subgrp.id = det_rec.subgrupo_produto_id
LEFT JOIN dbo.dim_filiais AS filial ON filial.id = det_rec.filial_id
LEFT JOIN dbo.dim_locais_armazenagem AS local_armazenagem ON local_armazenagem.id = rec.local_armazenagem_id
LEFT JOIN dbo.dim_usuarios AS usuario ON usuario.id = rec.usuario_criador_id
WHERE rec.numero_reclamacao IS NOT NULL;
