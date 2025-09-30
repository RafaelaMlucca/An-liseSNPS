# 🧬 Análise de Epistasia (Interação Gênica) na Glicemia

Este projeto tem como objetivo principal identificar **interações gênicas (epistasia)** que influenciam o nível de glicemia, ajustado por covariáveis, em uma população de estudo.

A metodologia combina técnicas de **análise univariada (GWAS clássico)** com uma abordagem de **Aprendizado de Máquina (Interaction Forest - IF)** para rastrear os pares de SNPs mais relevantes, seguidas por **regressões confirmatórias** com termo de interação.

---

## 💾 Estrutura do Repositório (Pipeline de 6 Fases)

Os scripts e resultados estão organizados de acordo com as fases lógicas de processamento:

📂 Analise_Epistasia_Genomica/
│

├── 📂 scripts/

│ ├── 📂 01_qc_prep/

│ │ └── Preparação dos dados e Filtro LD

│ ├── 📂 02_gwas_univariado/

│ │ └── Regressão Simples e Seleção Top 400

│ ├── 📂 03_if_screening/


│ │ └── Rastreamento com Interaction Forest (IF)

│ ├── 📂 04_if_selection/

│ │ └── Seleção dos Top Pares de EIM para Regressão

│ ├── 📂 05_reg_epistasia/

│ │ └── Regressões Confirmatórias com Interação

│ └── 📂 06_analise_final/

│ └── Estatísticas, Robustez e Visualização
│

├── 📂 data/

│ └── Bases de dados (entrada e intermediárias)
│

└── 📄 README.md

└── Documentação principal

```markdown
# 🧬 Análise de Epistasia (Interação Gênica) na Glicemia

Este projeto tem como objetivo principal identificar **interações gênicas (epistasia)** que influenciam o nível de glicemia, ajustado por covariáveis, em uma população de estudo.

A metodologia combina técnicas de **análise univariada (GWAS clássico)** com uma abordagem de **Aprendizado de Máquina (Interaction Forest - IF)** para rastrear os pares de SNPs mais relevantes, seguidas por **regressões confirmatórias** com termo de interação.

---

## 💾 Estrutura do Repositório (Pipeline de 6 Fases)

Os scripts e resultados estão organizados de acordo com as fases lógicas de processamento:

```

/Analise\_Epistasia\_Genomica/
├── /scripts/  
│   ├── /01\_qc\_prep/        \# Preparação dos dados e Filtro LD
│   ├── /02\_gwas\_univariado/\# Regressão Simples e Seleção Top 400
│   ├── /03\_if\_screening/   \# Rastreamento com Interaction Forest (IF)
│   ├── /04\_if\_selection/   \# Seleção dos Top Pares de EIM para Regressão
│   ├── /05\_reg\_epistasia/  \# Regressões Confirmatórias com Interação
│   └── /06\_analise\_final/  \# Estatísticas, Robustez e Visualização
├── /data/                  \# Bases de dados (entrada e intermediárias)
└── README.md               \# Documentação principal (este arquivo)

```

---

## ⚙️ Visão Geral da Metodologia

O fluxo de trabalho sequencial é dividido em seis fases:

| Fase | Objetivo Principal | Scripts Chave | Output |
| :--- | :--- | :--- | :--- |
| **1. QC & Pré-Processamento** | Filtrar SNPs por Linkage Disequilibrium (LD) e integrar fenótipos. | `FIltroLD.R`, `SnpsLdFen.R`, `JuntandoCromossomos.R` | Bases `chrX_Final.csv` e `todos_cromossomos_filtrados.csv` |
| **2. GWAS Univariado** | Identificar SNPs com maior efeito marginal para seleção do Top 400 e visualização. | `CodReg22Chr.R`, `JuntarDFsSnpePvalor.R`, `GraphManhattan.R` | Base `snps_top400_dataset.csv` |
| **3. IF Screening** | Ranqueamento dos pares de SNPs com maior EIM (Effect Importance Measure) nos 3 casos. | `400snpsmodelofinal.R`, `IFtodosChr.R`, `CodCromossomos1a22.R` | Arquivos `EIM_sorted.csv` para cada caso. |
| **4. Seleção IF** | Reduzir as listas de EIMs para os Top 200 pares que serão testados na regressão. | `seleciona200pormodelo.R` | Bases `top200_regressao.csv` e `top200_unidos.csv` |
| **5. Regressão Confirmatória** | Testar estatisticamente o termo de interação (`snp1 * snp2`) nos pares selecionados. | `RegressãoComEIM(*).R` | **24 Bases** de dados com p-valor da interação. |
| **6. Análise Final** | Comparar a robustez dos resultados e calcular a frequência dos SNPs/pares. | `estatisticasModelos.R` | Tabela de frequência de SNPs nos modelos. |

---

## 📊 Detalhamento dos Casos de Análise com Interaction Forest (Fase 3)

Para garantir que a seleção de pares de SNPs não dependa de um único conjunto de dados, o Interaction Forest foi executado em três cenários distintos, o que aumenta a robustez dos achados:

| Caso | Script | Estratégia | Justificativa |
| :--- | :--- | :--- | :--- |
| **Caso 1** | `400snpsmodelofinal.R` | Rastreamento apenas nos **Top 400 SNPs** com o menor p-valor do GWAS (Fase 2). | Foca em epistasia entre genes que já possuem algum efeito marginal significativo. |
| **Caso 2** | `IFtodosChr.R` | Rastreamento em **todos os SNPs** pós-LD, combinados em uma única base de dados. | Permite a identificação de interações puras (epistasia sem efeito marginal) em todo o genoma. |
| **Caso 3** | `CodCromossomos1a22.R` | Rastreamento cromossomo a cromossomo (22 modelos separados). | Reduz a carga computacional e permite identificar interações *cis* (dentro do mesmo cromossomo) que são robustas. |

---

## 📄 Detalhamento dos Scripts por Pasta

### 📁 01_qc_prep (Qualidade e Preparação)

| Script | Função |
| :--- | :--- |
| `FIltroLD.R` | Executa o **Filtro de Linkage Disequilibrium (LD)** (ex: $r^2 < 0.5$). |
| `TabelaLD.R` | Gera a tabela de resumo do LD (SNPs iniciais, removidos e remanescentes). |
| `GrafosChr (1).R` | Gera gráficos de barras para visualizar outros filtros de QC (MAF, HW, Missing Genotype). |
| `SnpsLdFen.R` | Faz o **Merge** dos SNPs filtrados por LD com os fenótipos e covariáveis (`sexo`, `idade`, `glicose`, etc.) para cada cromossomo. |
| `JuntandoCromossomos.R` | Combina todos os 22 arquivos `chrX_Final.csv` em uma única base geral. |

### 📁 02_gwas_univariado (Análise Marginal)

| Script | Função |
| :--- | :--- |
| `CodReg22Chr.R` | Roda a **Regressão Linear Simples** (`log(glicose) ~ covariáveis + SNP`) para cada SNP em cada cromossomo. |
| `JuntarDFsSnpePvalor.R` | Agrega os p-valores e **seleciona os Top 400 SNPs** com os menores p-valores. |
| `CodManht.R` / `GraphManhattan.R` | Scripts utilizados para gerar o **Manhattan Plot** a partir dos resultados de regressão simples. |
| `CodRegTeste1CHR.R` / `Reg.R` / `Reg (1).R` | Scripts de teste/exemplo, incluindo a aplicação de Regressão Logística (contra `diabetes2`). |

### 📁 03_if_screening (Rastreamento de Interação)

| Script | Função |
| :--- | :--- |
| `400snpsmodelofinal.R` | Execução do Interaction Forest para o **Caso 1 (Top 400 SNPs)**. |
| `IFtodosChr.R` | Execução do Interaction Forest para o **Caso 2 (Todos Juntos)**. |
| `CodCromossomos1a22.R` | Execução do Interaction Forest para o **Caso 3 (Cromossomo a Cromossomo)**. |
| `CódigoReg_atualizadoCHr1.R` | Exemplo de aplicação do IF (para Chr1), incluindo visualização dos resultados. |
| `Lendo_bancos (1).R` | Script de setup, instalação de pacotes (`diversityForest`/`BOLTSSIRR`) e pré-processamento de dados para o IF. |

### 📁 04_if_selection (Seleção para Regressão)

| Script | Função |
| :--- | :--- |
| `seleciona200pormodelo.R` | Carrega os resultados de EIM dos Casos 1 e 2 e **seleciona os 200 pares de SNPs com maior EIM** de cada modelo para teste confirmatório. |

### 📁 05_reg_epistasia (Regressão Confirmatória)

| Script | Função |
| :--- | :--- |
| `RegressãoComEIM(400snps).R` | Roda a regressão linear com termo de interação para os Top Pares do **Caso 1 (Top 400)**. |
| `RegressãoCOMEIM(casogeral).R` | Roda a regressão linear com termo de interação para os Top Pares do **Caso 2 (Todos Juntos)**. |
| `RegressãoComEIM(individual).R` | Roda a regressão linear com termo de interação para os Top Pares de cada um dos **22 cromossomos (Caso 3)**. |

### 📁 06_analise_final (Análise de Robustez)

| Script | Função |
| :--- | :--- |
| `estatisticasModelos.R` | **Agrega e compara** os resultados de EIM de todos os 3 casos do IF. Calcula a **frequência** de cada SNP/par de interação nos diferentes modelos para avaliar a robustez das descobertas. |

---

## 🛠️ Notas Importantes sobre a Validação Estatística

Após a Fase 5, recomenda-se fortemente a aplicação da **Correção para Múltiplos Testes** nos p-valores do termo de interação.

1.  Coletar todos os p-valores da coluna `pval_interacao` das 24 bases de dados geradas na Fase 5.
2.  Aplicar o método de **False Discovery Rate (FDR)** (Método Benjamini-Hochberg) sobre esta lista completa.
3.  Apenas pares com o **p-valor ajustado** abaixo de 0.05 devem ser considerados como interações significativas.
```
