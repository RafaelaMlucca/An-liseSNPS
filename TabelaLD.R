# Diretórios dos arquivos
dir_iniciais <- "/home/giancarlo/Downloads/imputados-20250827T203833Z-1-001/imputados"
dir_filtrados <- "/home/giancarlo/Downloads/LD_filtrados_r2"

# Inicializar dataframe de saída
resumo <- data.frame(chr=character(), iniciais=integer(), LD=integer(), remanescentes=integer())

# Loop de chr1 a chr22
for (i in 1:22) {
  chr_nome <- paste0("chr", i)
  
  # Arquivos
  arquivo_inicial <- file.path(dir_iniciais, paste0("isa", i, "_imputed.csv"))
  arquivo_filtrado <- file.path(dir_filtrados, paste0("isa", i, "_LD_filtered.csv"))
  
  # Contagem de SNPs
  n_iniciais <- ncol(read.csv(arquivo_inicial))
  n_filtrados <- ncol(read.csv(arquivo_filtrado))
  
  # Calcular removidos
  n_removidos <- n_iniciais - n_filtrados
  
  # Adicionar linha à tabela
  resumo <- rbind(resumo, data.frame(chr=chr_nome,
                                     iniciais=n_iniciais,
                                     LD=n_removidos,
                                     remanescentes=n_filtrados))
}

# Visualizar
print(resumo)

# Salvar como Excel
install.packages("openxlsx")
library(openxlsx)
write.xlsx(resumo, file = "resumo_snps_por_chr.xlsx")

