# Instalar pacotes necessários (se ainda não instalados)
if (!require("readxl")) install.packages("readxl")
library(readxl)
setwd("/Users/rafaelalucca/Downloads")

dados <- read_excel("info_por_chr (1).xlsx", sheet = "Planilha1")
colnames(dados) <- c("Cromossomos", "Iniciais", "MAF", "HW", "Remanescentes", "MissingGenotype")

dados <- dados[-nrow(dados), ]
colnames(dados) <- c("Cromossomos", "Iniciais", "MAF", "HW", "Remanescentes", "MissingGenotype")

dados$MAF <- dados$MAF
dados$HW <- dados$HW
dados$Remanescentes <- dados$Remanescentes
dados$MissingGenotype <- dados$MissingGenotype

# Renomear colunas para facilitar o uso
colnames(dados) <- c("Cromossomos", "Iniciais", "MAF", "HW", "Remanescentes", "MissingGenotype")

# Excluir a última linha do banco de dados, se necessário
dados <- dados[-nrow(dados), ]

# Gráfico principal (Iniciais)
barplot(
  height = dados$Iniciais,
  names.arg = dados$Cromossomos,
  col = rgb(0.6, 0.6, 0.6, 0.5), # Cor cinza com transparência
  ylim = c(0, max(dados$Iniciais) * 1.2), # Ajustar limite do eixo Y
  xlab = "Cromossomos",
  ylab = "Frequência",
  main = "Filtros aplicados aos Cromossomos",
  border = "black"
)

# Sobrepor com MAF
barplot(
  height = dados$MAF,
  col = rgb(1, 0.5, 0, 0.5), # Cor laranja com transparência
  add = TRUE # Sobrepor ao gráfico existente
)

# Sobrepor com HW
barplot(
  height = dados$HW,
  col = rgb(0, 0, 1, 0.5), # Cor azul com transparência
  add = TRUE # Sobrepor ao gráfico existente
)

# Sobrepor com Remanescentes
barplot(
  height = dados$Remanescentes,
  col = rgb(0, 1, 0, 0.5), # Cor verde com transparência
  add = TRUE # Sobrepor ao gráfico existente
)

# Sobrepor com MissingGenotype
barplot(
  height = dados$MissingGenotype,
  col = rgb(1, 0, 0, 0.5), # Cor vermelha com transparência
  add = TRUE # Sobrepor ao gráfico existente
)

# Adicionar a legenda
legend(
  "topright",
  legend = c("Iniciais", "MAF", "HW", "Remanescentes", "Dados Faltantes"),
  fill = c(
    rgb(0.6, 0.6, 0.6, 0.5),
    rgb(1, 0.5, 0, 0.5),
    rgb(0, 0, 1, 0.5),
    rgb(0, 1, 0, 0.5),
    rgb(1, 0, 0, 0.5)
  ),
  bty = "n" # Sem borda
)