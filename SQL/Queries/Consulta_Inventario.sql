-- =====================================================================
-- ANÁLISE DE INVENTÁRIO: Auditoria Geral de Estoque e Validades
-- Descrição: Consulta SQL Server para apuração de contagens físicas vs. 
-- teóricas, cálculo de valuation e controle de datas de validade por local.
-- =====================================================================

-- Objetivo: Consolidar o inventário geral filtrando por locais estratégicos 
-- (operações de aeroporto/lounge), aplicando regras de exceção de preço médio 
-- por filial e calculando o valor total teórico e físico.

SELECT
    filial.codigo AS site,
    inv.data_criacao,
    inv.data_validacao,
    usuario.primeiro_nome,
    det.nome_item AS item,
    det.quantidade_teorica AS qtd_teorica,
    det.quantidade_fisica AS qtd_fisica,

    -- Retorna preço médio alternativo para a filial específica se houver divergência teórica
    CASE 
        WHEN filial.codigo = 'LLT' AND det.quantidade_teorica > 0.0000 AND det.preco_medio_item_detalhe = 0.000 
        THEN det.preco_medio 
        ELSE det.preco_medio_item_detalhe 
    END AS preco_medio_teorico,

    det.preco_medio AS preco_medio_fisico,
    det.string_unidade_armazenamento AS unidade_medida,
    det.quantidade_producao_item AS unidade_producao,
    MIN(val.data_validade) AS data_validade_minima,
    local_armazenagem.titulo AS local_armazenagem,
    grp.nome AS grupo_produto,
    subgrp.nome AS subgrupo_produto,
    familia.nome AS familia_produto,

    -- Recalcula o valor total teórico usando a regra de preço médio ajustada
    det.quantidade_teorica * (
        CASE 
            WHEN filial.codigo = 'LLT' AND det.quantidade_teorica > 0.0000 AND det.preco_medio_item_detalhe = 0.000 
            THEN det.preco_medio 
            ELSE det.preco_medio_item_detalhe 
        END
    ) AS valor_total_teorico,

    det.quantidade_fisica * det.preco_medio AS valor_total_fisico
FROM dbo.fato_inventarios AS inv
LEFT JOIN dbo.fatos_detalhes_inventario AS det ON det.inventario_id = inv.id
LEFT JOIN dbo.dim_locais_armazenagem AS local_armazenagem ON local_armazenagem.id = inv.local_armazenagem_id
LEFT JOIN dbo.dim_filiais AS filial ON filial.id = local_armazenagem.filial_id
LEFT JOIN dbo.dim_produtos AS prod ON prod.id = det.produto_id
LEFT JOIN dbo.dim_grupos_produtos AS grp ON grp.id = prod.grupo_id
LEFT JOIN dbo.dim_subgrupos_produtos AS subgrp ON subgrp.id = prod.subgrupo_id
LEFT JOIN dbo.dim_familia_grupos AS familia ON familia.id = grp.familia_id
LEFT JOIN dbo.dim_usuarios AS usuario ON usuario.id = inv.usuario_validador_id
LEFT JOIN dbo.dim_validades_inventario AS val ON val.detalhe_inventario_id = det.id
WHERE CAST(inv.data_criacao AS Date) > '2025-12-31'
  AND local_armazenagem.titulo IN (
        'ES.1 - Estoque Principal',
        'ES.4 - Estoque Lounge A',
        'ES.1 - Est. Lounge Principal',
        'ES.2 - Estoque Setor B',
        'ES.2 - Estoque Setor C',
        'ES.2 - Estoque Setor D',
        'ES.2 - Estoque Setor E'
  )
GROUP BY
    filial.codigo,
    inv.data_criacao,
    inv.data_validacao,
    usuario.primeiro_nome,
    det.nome_item,
    det.quantidade_teorica,
    det.quantidade_fisica,
    det.preco_medio_item_detalhe,
    det.preco_medio,
    det.string_unidade_armazenamento,
    det.quantidade_producao_item,
    local_armazenagem.titulo,
    grp.nome,
    subgrp.nome,
    familia.nome;
