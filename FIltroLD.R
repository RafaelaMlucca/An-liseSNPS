setwd("~/Downloads/imputados-20250827T203833Z-1-001/imputados/")
# Pacotes necessários
if (!require(genetics)) install.packages("genetics")
library(genetics)

# Diretórios
base_dir <- "~/Downloads/imputados-20250827T203833Z-1-001/imputados/"
output_dir <- paste0(base_dir, "LD_filtrados_r2/")
dir.create(output_dir, showWarnings = FALSE)

# Parâmetros
r2_threshold <- 0.5
chromosomes <- 2:22
alleles_default <- c("C", "T")

for (chr in chromosomes) {
  cat("\n➡️ Processando cromossomo", chr, "...\n")
  
  file_path <- paste0(base_dir, "isa", chr, "_imputed.csv")
  output_path <- paste0(output_dir, "isa", chr, "_LD_filtered.csv")
  
  # Leitura
  gen <- read.csv(file_path, header = TRUE)
  gen <- gen[, sapply(gen, is.numeric)]  # só SNPs
  
  snps_to_keep <- c()
  n_snps <- ncol(gen)
  
  for (i in 1:(n_snps - 1)) {
    snp1 <- gen[[i]]
    snp2 <- gen[[i + 1]]
    
    if (length(unique(snp1)) < 2 || length(unique(snp2)) < 2) next
    
    g1 <- tryCatch(as.genotype.allele.count(snp1, alleles = alleles_default), error = function(e) NULL)
    g2 <- tryCatch(as.genotype.allele.count(snp2, alleles = alleles_default), error = function(e) NULL)
    
    if (is.null(g1) || is.null(g2)) next
    
    ld_result <- tryCatch(LD(g1, g2), error = function(e) NULL)
    
    if (!is.null(ld_result)) {
      corr <- suppressWarnings(ld_result$r)
      r2 <- corr^2
      
      if (!is.na(r2) && r2 <= r2_threshold) {
        snps_to_keep <- c(snps_to_keep, names(gen)[i], names(gen)[i + 1])
      }
    }
  }
  
  snps_to_keep <- unique(snps_to_keep)
  filtered_data <- gen[, snps_to_keep, drop = FALSE]
  write.csv(filtered_data, output_path, row.names = FALSE)
  
  cat("✅ SNPs filtrados com r² <=", r2_threshold, "salvos em:", output_path, "\n")
}

