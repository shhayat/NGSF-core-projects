library(synergyfinder)
library(tidyr)
#setwd("/Users/shahina/Desktop/Synergy_Analysis")
setwd("/Users/shahina/Projects/synergy_analysis/Synergy_Analysis")
#For HCC38
dir.create("HCC38", recursive=TRUE, showWarnings = FALSE) 
df <- read.csv("Paclitaxel_Homoharringtonine_HCC38.csv", head=TRUE)[1:8]
#use first row as column name
names(df) <- as.matrix(df[1, ])
#remove first row from df and select rest of the rows
df1 <- df[-1, ][1:33,]
df1[] <- lapply(df1, function(x) type.convert(as.character(x)))

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

#2D contour plot

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

#plot dose response curve and heatmap
pdf("HCC38/HCC38_dose_response_and_heatmap.pdf", width=20,onefile=FALSE)

PlotDoseResponse(
  data = res,
  block_ids = c(1),
  drugs = c(1,2),
  file_type = "pdf"
)
dev.off()



#For Hs578T
df <- read.csv("Paclitaxel_Homoharringtonine_Hs578T.csv")
dir.create("Hs578T", recursive=TRUE, showWarnings = FALSE) 
names(df) <- as.matrix(df[1, ])
#remove first row from df and select rest of the rows
df1 <- df[-1, ][1:35,]
df1[] <- lapply(df1, function(x) type.convert(as.character(x)))


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

#2D contour plot

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


#3D surface plot
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

#plot dose response curve and heatmap
pdf("Hs578T/Hs578T_dose_response_and_heatmap.pdf", width=20, onefile=FALSE)

PlotDoseResponse(
  data = res,
  block_ids = c(1),
  drugs = c(1,2),
  file_type = "pdf"
)
dev.off()







#For HCC1395
df <- read.csv("Paclitaxel_Homoharringtonine_HCC1395.csv")
dir.create("HCC1395", recursive=TRUE, showWarnings = FALSE) 
names(df) <- as.matrix(df[1, ])
#remove first row from df and select rest of the rows
df1 <- df[-1, ][1:33,]
#value 12.346 in conc_c is changed to 12.346 because there is another value 12.347 
#in conc_c and when these values are passed to Plot2DrugContour function then the 
#backend function .RoundValue will convert both values to 12.35 and this creates problem
#with Plot2DrugContour plot and gives a warning message Aggregation function missing: 
#defaulting to length. Rounding both values to 12.35 will cause 2 response values in one cell
#and cannot be correctly plotted in synergy map
df1[df1 == 12.346] <- 12.344
df1[] <- lapply(df1, function(x) type.convert(as.character(x)))



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

library(data.table)
acast(setDT(synergy.score$response)[, conc2:= rev(conc1), synergy.score$response], SUB~SUB2,value.var='PATID', length)
                
acast(synergy.score$response, conc1~conc2, value.var='response', length)

#2D contour plot

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


#3D surface plot
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

#plot dose response curve and heatmap
pdf("HCC1395/HCC1395_dose_response_and_heatmap.pdf", width=20, onefile=FALSE)

PlotDoseResponse(
  data = res,
  block_ids = c(1),
  drugs = c(1,2),
            adjusted = TRUE,
  file_type = "pdf"
)
dev.off()
                
#change data structure for synergy response and scores
synergy.response <- cbind(synergy.score$response[2:4])
df.wide.response <- pivot_wider(synergy.response, 
                       names_from = conc2, 
                       values_from = c(response),
                       names_prefix = c("adjusted_response.")) 

synergy.scores <- synergy.score$synergy_score[c(2:3,6)]

df.wide.scores <- pivot_wider(synergy.scores, 
                       names_from = conc2, 
                       values_from = c(ZIP_synergy),
                       names_prefix = c("score.")) 

df.wide <- cbind(df.wide.response,df.wide.scores[2:length(df.wide.scores)])
write.csv(df.wide, file="HCC1395/HCC1395.df.csv", row.names = FALSE)
   
