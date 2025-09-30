# Caminhos dos diretórios
dir_merge <- "/home/giancarlo/Downloads/Snps_Merge/"
dir_filtrado <- "/home/giancarlo/Downloads/LD_filtrados_r2/"
dir_saida <- "/home/giancarlo/Downloads/Snps_finais_com_fenotipos/"
dir.create(dir_saida, showWarnings = FALSE)

# Fenótipos a manter
fenotipos <- c("sexo", "computed_gender", "idade", "CP1", "CP2", "glicose", "medDM_bioq")

# Loop pelos 22 cromossomos
for (chr in 1:22) {
  cat("➡️ Processando cromossomo", chr, "\n")
  
  # Caminhos de arquivos
  arq_merge <- paste0(dir_merge, "chr", chr, "_Merge.csv")
  arq_ld <- paste0(dir_filtrado, "isa", chr, "_LD_filtered.csv")
  arq_saida <- paste0(dir_saida, "chr", chr, "_Final.csv")
  
  # Carrega os dados
  df_merge <- read.csv(arq_merge, header = TRUE)
  df_ld <- read.csv(arq_ld, header = TRUE)
  
  # Interseção dos SNPs filtrados com os disponíveis
  snps_comuns <- intersect(colnames(df_ld), colnames(df_merge))
  fenotipos_presentes <- intersect(fenotipos, colnames(df_merge))
  
  # Cria o novo banco com SNPs + fenotipos
  df_final <- df_merge[, c(snps_comuns, fenotipos_presentes)]
  
  # Salva o resultado
  write.csv(df_final, arq_saida, row.names = FALSE)
  
  cat("✅ Salvo em:", arq_saida, "\n")
}
