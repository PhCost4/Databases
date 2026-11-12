-- =====================================================================
-- ANÁLISE DE RN: Recebimento de Notas Fiscais
-- Descrição: Consulta SQL Server para rastrear notas recebidas, 
-- controle de temperatura, conferência física e valores faturados.
-- =====================================================================

SELECT 
    rn1.Number AS numero_nota,
    rn1.DeliveryDate AS data_entrega,
    rn1.ValidationDate AS data_validacao,
    rn1.NBTempBluetooth AS bluetooth,
    rn1.Origin AS origem_mobile,
    rn2.Temperature AS temperatura,
    rn1.NbTempManual AS temperatura_manual,
    rn2.TemperatureMeasurementType AS tipo_medicao_temperatura,
    rn2.ItemPackagingString AS unidade_embalagem,
    rn2.ItemName AS item_nome,
    rn2.TotalPrice AS valor_total,
    rn2.ItemGroupName AS grupo_produto,
    rn2.ReceivedQuantity * rn2.ItemUnitStorageTypeValue AS quantidade_recebida,
    rn2.PackingPrice / rn2.ItemUnitStorageTypeValue AS preco_unitario,
    rn3.Name AS subgrupo_produto,
    rn4.Name AS fornecedor,
    rn6.Code AS codigo_filial,
    rn8.Name AS familia_produto
FROM dbo.ReceiptNotes AS rn1
LEFT JOIN dbo.ReceiptNoteDetails AS rn2 ON rn1.Id = rn2.ReceiptNoteId
LEFT JOIN dbo.ItemSubGroups AS rn3 ON rn3.Id = rn2.ItemSubGroupId	
LEFT JOIN dbo.Suppliers AS rn4 ON rn4.Id = rn2.SupplierId
LEFT JOIN dbo.SitePlaces AS rn5 ON rn5.Id = rn1.SitePlaceId 
LEFT JOIN dbo.Sites AS rn6 ON rn6.Id = rn5.SiteId
LEFT JOIN dbo.ItemGroups AS rn7 ON rn7.Id = rn2.ItemGroupId
LEFT JOIN dbo.ItemGroupFamilies AS rn8 ON rn8.Id = rn7.ItemGroupFamilyId
WHERE CAST(rn1.DeliveryDate AS Date) > '2025-12-31' 
  AND rn1.IsActive = 1;
