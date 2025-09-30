setwd("~/Downloads/Snps_finais_com_fenotipos")
# Caminho dos arquivos
dir_filtrados <- path.expand("~/Downloads/Snps_finais_com_fenotipos")


# Covariáveis desejadas
covariaveis <- c("sexo", "idade", "CP1", "CP2", "glicose", "medDM_bioq")

# Inicializa objeto
base_final <- NULL

for (i in 1:22) {
  arquivo <- file.path(dir_filtrados, paste0("chr", i, "_Final.csv"))
  df_chr <- read.csv(arquivo)
  
  # Remove 'computed_gender' se existir
  if ("computed_gender" %in% names(df_chr)) {
    df_chr <- df_chr[, !(names(df_chr) %in% "computed_gender")]
  }
  
  # Captura apenas covariáveis presentes neste arquivo
  covs_presentes <- intersect(covariaveis, names(df_chr))
  
  # Extrai SNPs (colunas que não estão nas covariáveis)
  snps_chr <- df_chr[, !(names(df_chr) %in% covariaveis), drop = FALSE]
  
  if (i == 1) {
    # Primeira vez: salva covariáveis + SNPs
    base_final <- cbind(df_chr[, covs_presentes, drop = FALSE], snps_chr)
  } else {
    # Demais: só adiciona SNPs, mantendo covariáveis originais
    base_final <- cbind(base_final, snps_chr)
  }
}

# Salvar em CSV
write.csv(base_final, "todos_cromossomos_filtrados.csv", row.names = FALSE)


# Mostrar todas as colunas
names(base_final)

# Checar se as covariáveis estão presentes
covariaveis %in% names(base_final)

# Mostrar apenas as que faltaram (se houver)
setdiff(covariaveis, names(base_final))

