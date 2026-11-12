-- =====================================================================
-- ANÁLISE DE NEEDS: Planejamento de Consumo e Ordens de Suprimento
-- Descrição: Consulta SQL Server para rastrear o planejamento de consumo 
-- planejado e ordens de suprimento associadas.
-- =====================================================================

SELECT 
    so1.DeliveryDate AS data_entrega,
    so1.ValidationDate AS data_validacao,
    so1.Number AS numero_so,
    so1.Comment AS comentario,
    so2.ItemName AS item_nome,
    so2.Quantity * so2.ItemUnitStorageTypeValue AS qtd_unidade_armazenamento,
    so2.UnitPrice AS preco_unitario,
    so2.TotalPrice AS preco_total,
    so3.Name AS grupo_produto,	
    so4.Name AS subgrupo_produto,
    so5.Title AS local_armazenagem,
    so6.Code AS codigo_filial,
    so7.Name AS fornecedor
FROM dbo.SupplyOrders AS so1
LEFT JOIN dbo.SupplyOrderItemDetails AS so2 ON so1.Id = so2.SupplyOrderId
LEFT JOIN dbo.ItemGroups AS so3 ON so3.Id = so2.ItemGroupId
LEFT JOIN dbo.ItemSubGroups AS so4 ON so4.Id = so2.ItemSubGroupId
LEFT JOIN dbo.SitePlaces AS so5 ON so5.Id = so1.SitePlaceId
LEFT JOIN dbo.Sites AS so6 ON so6.Id = so5.SiteId
LEFT JOIN dbo.Suppliers AS so7 ON so7.Id = so2.SupplierId
WHERE CAST(so1.DeliveryDate AS Date) > '2025-12-31' 
  AND (so1.Comment LIKE '%PLANEJADO_ANALISE_DE_DADOS_RELATORIO_13!@#$&SVL%' 
       OR so1.Comment LIKE '%PLANEJADO_ ANALISE_DE_DADOS_RELATORIO_13!@#$&%');
