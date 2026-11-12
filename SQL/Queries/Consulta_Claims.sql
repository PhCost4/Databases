-- =====================================================================
-- ANÁLISE DE CLAIMS: Reclamações e Não-Conformidades de Fornecedores
-- Descrição: Consulta SQL Server para apuração de divergências, 
-- quebras de qualidade e penalidades em notas de fornecedores.
-- =====================================================================

SELECT 
    clm1.ClaimRNQuantity AS quantidade_reclamada, 
    clm1.PackingPrice AS preco_embalagem, 
    clm1.ItemName AS item, 
    clm1.Comment AS comentario,
    clm1.SanctionComment AS comentario_sancao,
    clm2.Comment AS comentarios_nota,
    clm2.CreationDate AS data_criacao, 
    clm2.DeliveryDate AS data_entrega, 
    clm2.ValidationDate AS data_validacao,
    clm1.ClaimTypes AS tipo_reclamacao_id,
    clm2.Status AS status,
    clm2.Number AS numero_reclamacao,
    clm3.Name AS fornecedor,
    clm4.Name AS grupo_produto,
    clm5.Name AS subgrupo_produto,
    clm6.Code AS codigo_filial,
    clm7.Title AS local_armazenagem,
    clm8.Firstname AS criado_por,
    clm8.JobTitle AS cargo_criador,
    CASE 
         WHEN clm1.ClaimTypes = 1 THEN 'NonCompliantDeliveredQuantity'
         WHEN clm1.ClaimTypes = 2 THEN 'Yield'
         WHEN clm1.ClaimTypes = 4 THEN 'NonCompliantCalibration'
         WHEN clm1.ClaimTypes = 8 THEN 'WrongProductDelivered'
         WHEN clm1.ClaimTypes = 16 THEN 'FlawFilth'
         WHEN clm1.ClaimTypes = 32 THEN 'OutsideInvasion'
         WHEN clm1.ClaimTypes = 64 THEN 'NonCompliantQuality'
         WHEN clm1.ClaimTypes = 128 THEN 'NonCompliantLabel'
         WHEN clm1.ClaimTypes = 256 THEN 'WrongInvoicedPrice'
         WHEN clm1.ClaimTypes = 512 THEN 'NonCompliantExpirationDate'
         WHEN clm1.ClaimTypes = 1024 THEN 'WrongFee'
         WHEN clm1.ClaimTypes = 2048 THEN 'QuantityNotReceived'
         ELSE 'Multiple Claim Types'
    END AS tipo_reclamacao_en,
    CASE 
         WHEN clm1.ClaimTypes = 1 THEN 'Quantidade Entregue Não-Conforme'
         WHEN clm1.ClaimTypes = 2 THEN 'Rendimento'
         WHEN clm1.ClaimTypes = 4 THEN 'Tamanho do Produto Não-Conforme'
         WHEN clm1.ClaimTypes = 8 THEN 'Produto Entregue Errado'
         WHEN clm1.ClaimTypes = 16 THEN 'Defeito/Sujidade'
         WHEN clm1.ClaimTypes = 32 THEN 'Objetos Estranhos'
         WHEN clm1.ClaimTypes = 64 THEN 'Qualidade Não-Conforme'
         WHEN clm1.ClaimTypes = 128 THEN 'Etiqueta Não-Conforme'
         WHEN clm1.ClaimTypes = 256 THEN 'Preço Faturado Incorreto'
         WHEN clm1.ClaimTypes = 512 THEN 'Data de Validade Não-Conforme'
         WHEN clm1.ClaimTypes = 1024 THEN 'Taxa/Impostos Incorreta'
         WHEN clm1.ClaimTypes = 2048 THEN 'Quantidade Não Recebida'
         ELSE 'Outros - Sem Preenchimento'
    END AS tipo_reclamacao_br
FROM dbo.ClaimNoteDetails AS clm1
LEFT JOIN dbo.ClaimNotes AS clm2 ON clm1.ClaimNoteId = clm2.Id
LEFT JOIN dbo.Suppliers AS clm3 ON clm3.Id = clm1.SupplierId
LEFT JOIN dbo.ItemGroups AS clm4 ON clm4.Id = clm1.ItemGroupId
LEFT JOIN dbo.ItemSubGroups AS clm5 ON clm5.Id = clm1.ItemSubGroupId
LEFT JOIN dbo.Sites AS clm6 ON clm6.Id = clm1.SiteId
LEFT JOIN dbo.SitePlaces AS clm7 ON clm7.Id = clm2.SitePlaceId
LEFT JOIN dbo.Users AS clm8 ON clm8.Id = clm2.UserCreatorId
WHERE clm2.Number IS NOT NULL;
