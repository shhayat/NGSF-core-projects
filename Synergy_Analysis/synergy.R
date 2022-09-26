library(synergyfinder)

#set working directory
setwd("/Users/hxo752/Desktop/core-projects/synergy_analysis

###########
#For HCC38
###########
#creat dir
dir.create("HCC38", recursive=TRUE, showWarnings = FALSE) 
df <- read.csv("Paclitaxel_Homoharringtonine_HCC38.csv", head=TRUE)[1:8]
##use first row as column name
names(df) <- as.matrix(df[1, ])
#remove first row from df and select rest of the rows
df1 <- df[-1, ][1:33,]
#data type conversion
df1[] <- lapply(df1, function(x) type.convert(as.character(x)))
#str(df1)

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

#write synergy scores to csv file
write.csv(synergy.score, "HCC38/HCC38_synergy_scores.csv")

#Plot 2D Synergy Map
pdf("HCC38/HCC38_2D_contour_plot.pdf")
Plot2DrugContour(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "median")
)
Plot2DrugContour(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "ZIP_synergy",
  dynamic = FALSE,
  summary_statistic = c("quantile_25", "quantile_75")
)
dev.off()

Plot 3D Synergy Map
#3D surface plot
pdf("HCC38/HCC38_3D_surface_plot.pdf")
Plot2DrugSurface(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)
Plot2DrugSurface(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "ZIP_synergy",
  dynamic = FALSE,
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)
dev.off()

#Plot dose response curve and heatmap
pdf("HCC38/HCC38_dose_response_and_heatmap.pdf", width=20, onefile=FALSE)

PlotDoseResponse(
  data = res,
  block_ids = c(1),
  drugs = c(1,2),
  file_type = "pdf"
)
dev.off()


#########
#Hs578T
#########
#creat dir
dir.create("Hs578T", recursive=TRUE, showWarnings = FALSE) 
df <- read.csv("Paclitaxel_Homoharringtonine_Hs578T.csv")
##use first row as column name
names(df) <- as.matrix(df[1, ])
#remove first row from df and select rest of the rows
df1 <- df[-1, ][1:35,]
#data type conversion
df1[] <- lapply(df1, function(x) type.convert(as.character(x)))
#str(df1)

# Reshaping and pre-processing
res <- ReshapeData(
  data = df1,
  data_type = "viability",
  impute = FALSE,
  impute_method = NULL,
  noise = TRUE,
  seed = 1)

# calculate synergy
synergy.score <- CalculateSynergy(
  data = res,
  method = c("ZIP"),
  Emin = NA,
  Emax = NA,
  correct_baseline = "all")

#write synergy scores to csv file
write.csv(synergy.score, "Hs578T/Hs578T_synergy_scores.csv")


#2D Synergy Map
pdf("Hs578T/Hs578T_2D_contour_plot.pdf")
Plot2DrugContour(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "median")
)
Plot2DrugContour(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "ZIP_synergy",
  dynamic = FALSE,
  summary_statistic = c("quantile_25", "quantile_75")
)
dev.off()


#Plot 3D Synergy Map
pdf("Hs578T/Hs578T_3D_surface_plot.pdf")
Plot2DrugSurface(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)
Plot2DrugSurface(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "ZIP_synergy",
  dynamic = FALSE,
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)
dev.off()

#Plot dose response curve and heatmap
pdf("Hs578T/Hs578T_dose_response_and_heatmap.pdf", width=20, onefile=FALSE)

PlotDoseResponse(
  data = res,
  block_ids = c(1),
  drugs = c(1,2),
  file_type = "pdf"
)
dev.off()


#########
#HCC1395
#########
#creat dir
dir.create("HCC1395", recursive=TRUE, showWarnings = FALSE) 
df <- read.csv("Paclitaxel_Homoharringtonine_HCC1395.csv")
##use first row as column name
names(df) <- as.matrix(df[1, ])
#remove first row from df and select rest of the rows
df1 <- df[-1, ][1:33,]
#data type conversion
df1[] <- lapply(df1, function(x) type.convert(as.character(x)))
#str(df1)
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

#write syngery scores to csv file
write.csv(synergy.score, "HCC1395/HCC1395_synergy_scores.csv")

#2D Syngery Map
pdf("HCC1395/HCC1395_2D_contour_plot.pdf")
Plot2DrugContour(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "median")
)
Plot2DrugContour(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "ZIP_synergy",
  dynamic = FALSE,
  summary_statistic = c("quantile_25", "quantile_75")
)
dev.off()


#3D Synergy Map
pdf("HCC1395/HCC1395_3D_surface_plot.pdf")
Plot2DrugSurface(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "response",
  dynamic = FALSE,
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)
Plot2DrugSurface(
  data = synergy.score,
  plot_block = 1,
  drugs = c(1, 2),
  plot_value = "ZIP_synergy",
  dynamic = FALSE,
  summary_statistic = c("mean", "quantile_25", "median", "quantile_75")
)
dev.off()

#Plot dose response curve and heatmap
pdf("HCC1395/HCC1395_dose_response_and_heatmap.pdf", width=20, onefile=FALSE)

PlotDoseResponse(
  data = res,
  block_ids = c(1),
  drugs = c(1,2),
  file_type = "pdf"
)
dev.off()
