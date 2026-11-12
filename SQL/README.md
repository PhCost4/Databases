# Portfólio de Consultas SQL · Engenharia e Análise de Dados

Repositório de consultas SQL otimizadas e modeladas para extração, transformação e integração direta com ferramentas de Business Intelligence (Power BI) e pipelines analíticos.

## Stack

* **Linguagem:** T-SQL (SQL Server)
* **Consumo e Visualização:** Power BI (DirectQuery / Import), Excel
* **Modelagem:** Star Schema (Tabelas Fato e Dimensão), Normalização e Agregações

## Estrutura do Repositório

```
SQL/
├── Queries/
│   ├── Consulta_Claims.sql              → Abertura de reclamações e não-conformidades de fornecedores
│   ├── Consulta_Estoque.sql             → Posição diária (day by day) e histórico móvel de estoque
│   ├── Consulta_Inventario.sql          → Auditoria de inventário geral, contagens físicas vs. teóricas e validades
│   ├── Consulta_Ordem_Compras.sql       → Monitoramento de aberturas e status de ordens de compra (PO)
│   ├── Consulta_Planejamento.sql        → Planejamento de consumo e ordens de suprimento (Needs)
│   ├── Consulta_Recebimento_Notas.sql   → Conferência e recebimento de notas fiscais (RN)
│   └── Consulta_Saidas.sql              → Consumo, transferências internas e saídas entre departamentos (OF)
└── README.md                            → Documentação viva das consultas e regras de negócio
```

## Como utilizar

1. **Conexão:** Utilize um cliente SQL compatível com SQL Server (SSMS, Azure Data Studio, DBeaver) ou conecte diretamente via conector nativo do **Power BI** (*Obter Dados > SQL Server > Opções Avançadas > Instrução SQL*).
2. **Adaptação:** Ajuste os nomes das tabelas e schemas (`dbo.fato_*`, `dbo.dim_*`) conforme o dicionário de dados do seu ambiente de destino.
3. **Execução:** Os scripts são autônomos e já contemplam filtros de performance na origem para reduzir o volume trafegado para a camada visual.

## Padrões e boas práticas adotadas

* **Processamento na origem (Query Folding):** Filtros de status, saldos positivos, datas de corte e janelas móveis aplicados diretamente no banco antes da carga no BI.
* **Modelagem dimensional:** Junções explícitas (`LEFT JOIN`) partindo de tabelas fato para dimensões hierárquicas (Produto, Grupos, Filiais e Locais de Armazenagem).
* **Anonimização e segurança:** Nomenclaturas padronizadas e mascaradas para fins de portfólio, preservando a confidencialidade de esquemas proprietários.

## Catálogo de Consultas e Regras de Negócio

### 1. Estoque e Logística (`SQL/Queries/Consulta_Estoque.sql`)
* **Posição Atual de Estoque (Day by Day):** Consolida a última data de validação, preço unitário médio e saldo armazenado por item, local de armazenagem, filial e hierarquia de produtos para itens ativos com saldo positivo (`> 0`).
* **Histórico de Movimentação (Janela Móvel):** Rastreia a evolução de saldos e quantidades de produção com filtro dinâmico cobrindo o período do mês anterior até a data atual (`GETDATE()`).

### 2. Inventário Geral (`SQL/Queries/Consulta_Inventario.sql`)
* **Auditoria de Inventário e Valuation:** Consolida o cruzamento de contagens físicas e teóricas em filiais e locais estratégicos, aplicando regras condicionais específicas de preço médio por filial (`CASE WHEN`).
* **Controle de Validades:** Integração com datas mínimas de validade (`MIN`) para monitoramento de vencimento de lotes e cálculo do valor total teórico versus físico.

### 3. Gestão de Fornecedores (`SQL/Queries/Consulta_Claims.sql`)
* **Abertura de Reclamações e Não-Conformidades:** Rastreia divergências no recebimento, quebras de qualidade, prazos de validade e penalidades aplicadas, traduzindo códigos numéricos de ocorrência (`CASE WHEN`) para classificações legíveis de negócio.

### 4. Planejamento de Consumo (`SQL/Queries/Consulta_Planejamento.sql`)
* **Ordens de Suprimento (Needs):** Acompanha o planejamento de consumo da operação, consolidando quantidades convertidas na unidade de armazenagem, preços unitários e custos totais por filial e fornecedor.

### 5. Compras e Aquisições (`SQL/Queries/Consulta_Ordem_Compras.sql`)
* **Ordens de Compra (PO):** Monitora o ciclo de compras ativas, volumes solicitados, preços unitários e valores consolidados por grupo de produtos e filial, filtrando pedidos cancelados ou inativos.

### 6. Recebimento Fiscal e Qualidade (`SQL/Queries/Consulta_Recebimento_Notas.sql`)
* **Recebimento de Notas (RN):** Registra a entrada física e fiscal de mercadorias, contemplando aferições de temperatura (manual e via Bluetooth), conversões de embalagem e validação de valores faturados.

### 7. Operações e Saídas Internas (`SQL/Queries/Consulta_Saidas.sql`)
* **Consumo Departamental e Transferências (OF):** Controla a movimentação de saída entre locais de origem e destino, rastreando o consumo interno entre departamentos e registros de perdas operacionais.