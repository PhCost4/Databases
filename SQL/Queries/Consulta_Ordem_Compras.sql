-- =====================================================================
-- ANÁLISE DE PO: Abertura de Ordens de Compra
-- Descrição: Consulta SQL Server para monitoramento de ordens de compra 
-- ativas, volumes solicitados e valores consolidados.
-- =====================================================================

SELECT 
    po1.NumberString AS numero_pedido,
    po1.DeliveryDate AS data_entrega,
    po1.ValidationDate AS data_validacao,
    po1.Status AS status_pedido,
    po2.Quantity * po2.ItemUnitStorageTypeValue AS quantidade,
    po2.UnitPrice AS preco_unitario,
    po2.TotalPrice AS preco_total,
    po2.ItemName AS item,
    po3.Name AS fornecedor,
    po4.Name AS grupo_produto,	
    po5.Name AS subgrupo_produto,
    po7.Code AS codigo_filial,
    po8.Name AS familia_produto
FROM dbo.PurchaseOrders AS po1
LEFT JOIN dbo.PurchaseOrderDetails AS po2 ON po2.PurchaseOrderId = po1.Id
LEFT JOIN dbo.Suppliers AS po3 ON po3.Id = po1.SupplierId
LEFT JOIN dbo.ItemGroups AS po4 ON po4.Id = po2.ItemGroupId
LEFT JOIN dbo.ItemSubGroups AS po5 ON po5.Id = po2.ItemSubGroupId
LEFT JOIN dbo.SitePlaces AS po6 ON po6.Id = po1.SitePlaceId
LEFT JOIN dbo.Sites AS po7 ON po7.Id = po6.SiteId
LEFT JOIN dbo.ItemGroupFamilies AS po8 ON po8.Id = po4.ItemGroupFamilyId
WHERE CAST(po1.DeliveryDate AS Date) > '2025-09-30' 
  AND po1.Status <> 3;
