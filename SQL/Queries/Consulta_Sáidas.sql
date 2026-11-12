-- =====================================================================
-- ANÁLISE DE OF: Consumo e Saídas entre Departamentos
-- Descrição: Consulta SQL Server para apuração de transferências internas, 
-- consumo departamental e controle de perdas operacionais.
-- =====================================================================

SELECT 
    of1.CreationDate AS data_criacao,
    of1.ValidationDate AS data_validacao,
    of1.Date AS data_entrega,
    of1.Number AS numero_documento,
    of1.IsActive AS ativo,
    of1.Origin AS origem_mobile,
    of2.itemName AS item_nome,
    of2.ItemStorageString AS unidade_armazenamento,
    of2.TotalPrice AS valor_total,
    of2.Quantity AS quantidade,
    of4.Code AS codigo_filial,
    of5.Name AS grupo_produto,
    of6.Name AS subgrupo_produto,
    of7.Title AS local_destino,
    of8.Title AS local_origem
FROM dbo.OutputForms AS of1
LEFT JOIN dbo.OutputFormDetails AS of2 ON of1.Id = of2.OutputFormId
LEFT JOIN dbo.SitePlaces AS of3 ON of3.Id = of1.FromSitePlaceId
LEFT JOIN dbo.Sites AS of4 ON of4.Id = of3.SiteId
LEFT JOIN dbo.ItemGroups AS of5 ON of5.Id = of2.ItemGroupId
LEFT JOIN dbo.ItemSubGroups AS of6 ON of6.Id = of2.ItemSubGroupId
LEFT JOIN dbo.SitePlaces AS of7 ON of7.Id = of1.ToSitePlaceId
LEFT JOIN dbo.SitePlaces AS of8 ON of8.Id = of1.FromSitePlaceId
WHERE CAST(of1.Date AS Date) > '2025-09-30' 
  AND of1.IsActive = 1;
