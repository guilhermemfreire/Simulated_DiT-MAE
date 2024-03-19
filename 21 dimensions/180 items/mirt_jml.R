library(mirtjml)

setwd("~/guilhermemfreire@usp.br - Google Drive/My Drive/VAE_Q_GUILHERME/Simulação ACT/21 dimensions/180 items")

R <-  100   # qtde réplicas
p <-  2     # número da simulação
J <-  180    # número de itens
N <-  10000 # número de indivíduos
K <-  21     # número de traços latentes
tr <- 8000  # Número de indivíduos para treino

start_time <- Sys.time()
for (r in 1:R) 
{
  print(paste0("Replica: ", r))
  
  data <- as.matrix(read.csv(file = paste("output_data/10_missing/masked/Masked_rep", r,"_10_missing.csv", sep = ""), sep = ";", header = FALSE))
  data[data==-1] <- NA
  Y <- matrix(data, nrow = tr, ncol = J)
  
  Q <- as.matrix(read.csv("input_data/qmatrix/Qmatrix.csv", sep = ";", header = FALSE))
  
  A0 <- Q
  d0 <- rep(0, J)
  theta0 <- matrix(rnorm(tr*K, 0, 1),tr)
  
  Estimados <- mirtjml_conf(Y ,Q , theta0, A0, d0)
  
  
  skill_preds <- Estimados[["theta_hat"]]
  write.table(skill_preds, file=paste("output_data_jml/10_missing/theta/thetas_rep",r,"_jml_10_missing_",p,".csv",sep = ""),sep=";",row.names=FALSE, col.names=FALSE,dec = ".")
  
  discr <- Estimados[["A_hat"]]
  write.table(discr, file=paste("output_data_jml/10_missing/a/discr_hat_rep",r,"_jml_10_missing_",p,".csv",sep = ""),sep=";",row.names=FALSE, col.names=FALSE,dec = ".")
  
  diff <- Estimados[["d_hat"]]
  write.table(-diff, file=paste("output_data_jml/10_missing/b/diff_hat_rep",r,"_jml_10_missing_",p,".csv",sep = ""),sep=";",row.names=FALSE, col.names=FALSE,dec = ".")
}

end_time <- Sys.time()

print(end_time - start_time) 

# Time spent for 100 replica of 10 missing: 13.03599 hours
# Time spent for 100 replica of 25 missing: 13.97433 hours
# Time spent for 100 replica of 50 missing: 16.07885 hours