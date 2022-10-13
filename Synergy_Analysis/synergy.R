library(synergyfinder)
library(tidyr)
#setwd("/Users/shahina/Desktop/Synergy_Analysis")
#setwd("/Users/hxo752/Desktop/core-projects/synergy_analysis/")
setwd("/Users/shahina/Projects/synergy_analysis/Synergy_Analysis")
#For HCC38
dir.create("HCC38", recursive=TRUE, showWarnings = FALSE) 
df <- read.csv("Paclitaxel_Homoharringtonine_HCC38.csv", head=TRUE)[1:8]
#df <- read.csv("HCC38.csv", head=TRUE)[1:8]
#use first row as column name
names(df) <- as.matrix(df[1, ])
#remove first row from df and select rest of the rows
df1 <- df[-1, ][1:33,]
df1[] <- lapply(df1, function(x) type.convert(as.character(x)))

colnames(df1)[2:5] <- c("drug_col","drug_row","conc_c","conc_r")
#df1 <- df1[c(1,3,2,5,4,6,7,8)]

# Reshaping and pre-processing
res <- ReshapeData(
  data = df1,
  data_type = "viability",
  impute = TRUE,
  impute_method = NULL,
  noise = TRUE,
  seed = 1)

# calculate synergy
synergy.score <- CalculateSynergy(
  data = res,
  method = c("ZIP"),
  Emin = NA,
  Emax = NA,
  correct_baseline = "non")

write.csv(synergy.score, "HCC38/HCC38_synergy_scores.csv")
save(synergy.score, file = 'HCC38_synergy.score.RData', compress = 'xz')

#2D contour plot

pdf("HCC38/HCC38_2D_contour_plot.pdf")
Plot2DrugContour(
  data = res,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "median"),
  grid=FALSE
)
dev.off()


#run modified plot_synergy.R function to plot synergy scores
#axes text and dose response value size has been increased

#Plot synergy scores
pdf("HCC38/HCC38_plot_synergyscores_v3.pdf", width=10)
PlotSynergy(
  data = synergy.score,
  type = "2D",
  method = "ZIP",
  block_ids = c(1),
  drugs = c(1,2),
  grid=FALSE,
  text_size_scale = 1.5
)
dev.off() 

#round dose response values to whole number for plotting heatmap
res$response$response <- round(res$response$response)
save(res, file = 'HCC38_res.RData', compress = 'xz')

#run modified Plot2drugHeatmap.R function to plot dose response heatmap
#axes text and dose response value size has been increased and legend text 
#has been changed from inhibition to cytotoxicity

#change data format from long to wide for synergy response and scores
synergy.response <- synergy.score$response[2:4]
df.wide.response <- pivot_wider(synergy.response, 
                                names_from = conc1, 
                                values_from = c(response),
                                names_prefix = c("adjusted_response.")) 

synergy.scores <- synergy.score$synergy_score[c(2:3,6)]

df.wide.scores <- pivot_wider(synergy.scores, 
                              names_from = conc1, 
                              values_from = c(ZIP_synergy),
                              names_prefix = c("score.")) 

df.wide <- cbind(df.wide.response,df.wide.scores[2:length(df.wide.scores)])
df.wide <- df.wide[order(df.wide$conc2),]
df.wide <- df.wide[c(1:8,11,9:10,12:18,21,19:20)]
write.csv(df.wide, file="HCC38/HCC38.df.csv", row.names = FALSE)



#For Hs578T
df <- read.csv("Paclitaxel_Homoharringtonine_Hs578T-revised.csv")
dir.create("Hs578T", recursive=TRUE, showWarnings = FALSE) 
names(df) <- as.matrix(df[1, ])
#remove first row from df and select rest of the rows
df1 <- df[-1, ][1:32,]
df1[] <- lapply(df1, function(x) type.convert(as.character(x)))
colnames(df1)[2:5] <- c("drug_col","drug_row","conc_c","conc_r")

# Reshaping and pre-processing
res <- ReshapeData(
  data = df1,
  data_type = "viability",
  impute = TRUE,
  impute_method = NULL,
  noise = TRUE,
  seed = 1)

# calculate synergy
synergy.score <- CalculateSynergy(
  data = res,
  method = c("ZIP"),
  Emin = NA,
  Emax = NA,
  correct_baseline = "non")

write.csv(synergy.score, "Hs578T/Hs578T_synergy_scores.csv")
save(synergy.score, file = 'Hs578T_synergy.score.RData', compress = 'xz')

#2D contour response plot
pdf("Hs578T/Hs578T_2D_contour_plot.pdf")
Plot2DrugContour(
  data = res,
  plot_block = 1,
  drugs = c(1,2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "median"),
  grid=FALSE
)
dev.off()

#Plot synergy scores
pdf("Hs578T/Hs578T_plot_synergyscores_v3.pdf", width=10)
PlotSynergy(
  data = synergy.score,
  type = "2D",
  method = "ZIP",
  block_ids = c(1),
  drugs = c(1,2),
  grid=FALSE,
  text_size_scale = 1.5
)
dev.off() 

#round dose response values to whole number
res$response$response <- round(res$response$response)
save(res, file = 'Hs578T_res.RData', compress = 'xz')

#run modified Plot2drugHeatmap.R function to plot dose response heatmap
#axes text and dose response value size has been increased and legend text 
#has been changed from inhibition to cytotoxicity

#change data format from long to wide for synergy response and scores
synergy.response <- cbind(synergy.score$response[2:4])
df.wide.response <- pivot_wider(synergy.response, 
                                names_from = conc1, 
                                values_from = c(response),
                                names_prefix = c("adjusted_response.")) 

synergy.scores <- synergy.score$synergy_score[c(2:3,6)]

df.wide.scores <- pivot_wider(synergy.scores, 
                              names_from = conc1, 
                              values_from = c(ZIP_synergy),
                              names_prefix = c("score.")) 

df.wide <- cbind(df.wide.response,df.wide.scores[2:length(df.wide.scores)])
df.wide <- df.wide[order(df.wide$conc2),]
df.wide <- df.wide[c(1:4,12,5,13,6,14,7,15,8,16,11,9,17,10,18,19:21,29,22,30,23,31,24,32,25,33,28,26,34,27,35)]
write.csv(df.wide, file="Hs578T/Hs578T.df.csv", row.names = FALSE)



#For HCC1395
df <- read.csv("Paclitaxel_Homoharringtonine_HCC1395-revised.csv")
dir.create("HCC1395", recursive=TRUE, showWarnings = FALSE) 
names(df) <- as.matrix(df[1, ])
#remove first row from df and select rest of the rows
df1 <- df[-1, ][1:33,]
df1[] <- lapply(df1, function(x) type.convert(as.character(x)))
colnames(df1)[2:5] <- c("drug_col","drug_row","conc_c","conc_r")


# Reshaping and pre-processing
res <- ReshapeData(
  data = df1,
  data_type = "viability",
  impute = TRUE,
  impute_method = NULL,
  noise = TRUE,
  seed = 1)

# calculate synergy
synergy.score <- CalculateSynergy(
  data = res,
  method = c("ZIP"),
  Emin = NA,
  Emax = NA,
  correct_baseline = "non")

write.csv(synergy.score, "HCC1395/HCC1395_synergy_scores.csv")
save(synergy.score, file = 'HCC1395_synergy.score.RData', compress = 'xz')

#2D contour plot
pdf("HCC1395/HCC1395_2D_contour_plot.pdf")
Plot2DrugContour(
  data = res,
  plot_block = 1,
  drugs = c(1,2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "median"),
  grid=FALSE
)
dev.off()

#Plot synergy scores
pdf("HCC1395/HCC1395_plot_synergyscores_v3.pdf", width=10)
PlotSynergy(
  data = synergy.score,
  type = "2D",
  method = "ZIP",
  block_ids = c(1),
  drugs = c(1,2),
  grid=FALSE,
  text_size_scale = 1.5
)
dev.off()

#round dose response values to whole number
res$response$response <- round(res$response$response)

save(res, file = 'HCC1395_res.RData', compress = 'xz')

#run modified Plot2drugHeatmap.R function to plot dose response heatmap
#axes text and dose response value size has been increased and legend text 
#has been changed from inhibition to cytotoxicity

#change data format from long to wide for synergy response and scores
synergy.response <- cbind(synergy.score$response[2:4])
df.wide.response <- pivot_wider(synergy.response, 
                                names_from = conc1, 
                                values_from = c(response),
                                names_prefix = c("adjusted_response.")) 

synergy.scores <- synergy.score$synergy_score[c(2:3,6)]

df.wide.scores <- pivot_wider(synergy.scores, 
                              names_from = conc1, 
                              values_from = c(ZIP_synergy),
                              names_prefix = c("score.")) 

df.wide <- cbind(df.wide.response,df.wide.scores[2:length(df.wide.scores)])
df.wide <- df.wide[order(df.wide$conc2),]
df.wide <- df.wide[c(1:8,11,9,10,12:18,21,19,20)]
write.csv(df.wide, file="HCC1395/HCC1395.df.csv", row.names = FALSE)




#For HCC1806
dir.create("HCC1806", recursive=TRUE, showWarnings = FALSE) 
df <- read.csv("Paclitaxel_Other_Drugs_HCC1806.csv", head=TRUE)[1:8]
#use first row as column name
names(df) <- as.matrix(df[1, ])
#remove first row from df and select rest of the rows
df1 <- df[-1, ][1:66,]
df1[] <- lapply(df1, function(x) type.convert(as.character(x)))

colnames(df1)[2:5] <- c("drug_col","drug_row","conc_c","conc_r")
#df1 <- df1[c(1,3,2,5,4,6,7,8)]

# Reshaping and pre-processing
res <- ReshapeData(
  data = df1,
  data_type = "viability",
  impute = TRUE,
  impute_method = NULL,
  noise = TRUE,
  seed = 1)

# calculate synergy
synergy.score <- CalculateSynergy(
  data = res,
  method = c("ZIP"),
  Emin = NA,
  Emax = NA,
  correct_baseline = "non")

write.csv(synergy.score, "HCC1806/HCC1806_synergy_scores.csv")
save(synergy.score, file = 'HCC1806_synergy.score.RData', compress = 'xz')

#2D contour plot

pdf("HCC1806/HCC1806_2D_contour_plot_paclitaxel_lanatosidec.pdf")
Plot2DrugContour(
  data = res,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "median"),
  grid=FALSE
)
dev.off()

pdf("HCC1806/HCC1806_2D_contour_plot_paclitaxel_homoharringtonine.pdf")
Plot2DrugContour(
  data = res,
  plot_block = 2,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "median"),
  grid=FALSE
)
dev.off()

#Plot synergy scores
pdf("HCC1806/HCC1806_plot_synergyscores_v3.pdf", width=10)
#PlotSynergy(
 # data = synergy.score,
 # type = "2D",
 # method = "ZIP",
 # block_ids = 1,
 # drugs = c(1,2),
 # grid=FALSE,
 # text_size_scale = 1.5)

PlotSynergy(
  data = synergy.score,
  type = "2D",
  method = "ZIP",
  block_ids =2,
  drugs = c(1,2),
  grid=FALSE,
  text_size_scale = 1.5)

dev.off() 
#round dose response values to whole number
res$response$response <- round(res$response$response)
save(res, file = 'HCC1806_res.RData', compress = 'xz')

#run modified Plot2drugHeatmap.R function to plot dose response heatmap
#axes text and dose response value size has been increased and legend text 
#has been changed from inhibition to cytotoxicity


#change data format from long to wide for synergy response and scores
synergy.response <- synergy.score$response[2:4][1:100,]
df.wide.response <- pivot_wider(synergy.response, 
                                names_from = conc1, 
                                values_from = c(response),
                                names_prefix = c("adjusted_response.")) 

synergy.scores <- synergy.score$synergy_score[c(2:3,6)][1:100,]

df.wide.scores <- pivot_wider(synergy.scores, 
                              names_from = conc1, 
                              values_from = c(ZIP_synergy),
                              names_prefix = c("score.")) 

df.wide <- cbind(df.wide.response,df.wide.scores[2:length(df.wide.scores)])
df.wide <- df.wide[order(df.wide$conc2),]
df.wide <- df.wide[c(1:7, 11,8:10, 12:17, 21, 18:20)]        
write.csv(df.wide, file="HCC1806/HCC1806.df.paclitaxel_lanatosidec.csv", row.names = FALSE)

#change data format from long to wide for synergy response and scores
synergy.response <- synergy.score$response[2:4][101:nrow(synergy.score$response),]
df.wide.response <- pivot_wider(synergy.response, 
                                names_from = conc1, 
                                values_from = c(response),
                                names_prefix = c("adjusted_response.")) 

synergy.scores <- synergy.score$synergy_score[c(2:3,6)][101:nrow(synergy.score$response),]

df.wide.scores <- pivot_wider(synergy.scores, 
                              names_from = conc1, 
                              values_from = c(ZIP_synergy),
                              names_prefix = c("score.")) 

df.wide <- cbind(df.wide.response,df.wide.scores[2:length(df.wide.scores)])
df.wide <- df.wide[order(df.wide$conc2),]
df.wide <- df.wide[c(1:7, 11,8:10, 12:17, 21, 18:20)]        
write.csv(df.wide, file="HCC1806/HCC1806.df.paclitaxel_homoharringtonine.csv", row.names = FALSE)
                
                

#3D surface plot
#pdf("Hs578T/Hs578T_3D_surface_plot.pdf")
#Plot2DrugSurface(
#  data = res,
#  plot_block = 1,
#  drugs = c(2, 1),
#  plot_value = "response",
#  dynamic = FALSE,
#  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
#)
#Plot2DrugSurface(
#  data = synergy.score,
#  plot_block = 1,
#  drugs = c(2, 1),
#  plot_value = "ZIP_synergy",
#  dynamic = FALSE,
#  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
#)
#dev.off()



#3D surface plot
#pdf("HCC1395/HCC1395_3D_surface_plot.pdf")
#Plot2DrugSurface(
#  data = res,
#  plot_block = 1,
#  drugs = c(2, 1),
#  plot_value = "response",
#  dynamic = FALSE,
#  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
#)
#Plot2DrugSurface(
#  data = synergy.score,
#  plot_block = 1,
#  drugs = c(2, 1),
#  plot_value = "ZIP_synergy",
#  dynamic = FALSE,
#  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
#)
#dev.off()

#plot dose response curve and heatmap
#pdf("HCC1395/HCC1395_dose_response_and_heatmap.pdf", width=20, onefile=FALSE)

#PlotDoseResponse(
#  data = res,
#  block_ids = c(1),
#  drugs = c(2,1),
#  adjusted = TRUE,
#  file_type = "pdf"
#)
#dev.off()

#plot dose response curve and heatmap
#pdf("HCC38/HCC38_dose_response_and_heatmap.pdf", width=20,onefile=FALSE)

#PlotDoseResponse(
#  data = res,
#  block_ids = c(1),
#  drugs = c(2,1),
#  file_type = "pdf"
#)
#dev.off()

#3D surface plot
#pdf("HCC38/HCC38_3D_surface_plot.pdf")
#Plot2DrugSurface(
#  data = res,
#  plot_block = 1,
#  drugs = c(2, 1),
#  plot_value = "response",
#  dynamic = FALSE,
#  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
#)
#dev.off()

#plot dose response curve and heatmap
#pdf("Hs578T/Hs578T_dose_response_and_heatmap.pdf", width=20, onefile=FALSE)
#PlotDoseResponse(
#  data = res,
#  block_ids = c(1),
#  drugs = c(2,1),
#  adjusted = TRUE,
#  file_type = "pdf"
#)
#dev.off()
