#The purpose of rewriting Plot2drupHeatmap function is to do modifications to the 
#axes values and dose response value size and also to replace legend title to cytotoxicity

#First load required functions for Plot2drupHeatmap.
#.Extract2DrugPlotData 
#.RoundValues
#.Pt2mm

.Extract2DrugPlotData <- function(data,
                                  plot_block = 1,
                                  drugs = c(2, 1),
                                  plot_value = "response",
                                  statistic = NULL){
  # 1. Check the input data
  # Data structure of 'data'
  if (!is.list(data)) {
    stop("Input data is not in list format!")
  }
  if (!all(c("drug_pairs", "response") %in% names(data))) {
    stop("Input data should contain at least tow elements: 'drug_pairs' and 
         'response'. Please prepare your data with 'ReshapeData' function.")
  }
  # Parameter 'drugs'
  if (length(drugs) != 2) {
    stop("The length of 'drugs' parameter is not 2. Please chosed exactly 2
         drugs for heatmap.")
  }
  # Parameter 'plot_value'
  avail_value <- c("response", "response_origin", "ZIP_ref", "ZIP_fit",
                   "ZIP_synergy", "HSA_ref", "HSA_synergy", "Bliss_ref",
                   "Bliss_synergy", "Loewe_ref", "Loewe_synergy")
  if (!plot_value %in% avail_value) {
    stop("The parameter 'plot_value = ", plot_value, "' is not available.",
         "Avaliable values are '", paste(avail_value, collapse = ", "), "'.")
  }
  
  # Annotation data
  drug_pair <- data$drug_pairs[data$drug_pairs$block_id == plot_block, ] %>% 
    dplyr::select(
      drug1 = paste0("drug", drugs[1]),
      drug2 = paste0("drug", drugs[2]),
      conc_unit1 = paste0("conc_unit", drugs[1]),
      conc_unit2 = paste0("conc_unit", drugs[2]),
      replicate,
      input_type
    )
  
  # Parameter 'statistic'
  if (is.null(statistic)){
    statistic_table <- drug_pair$replicate
  } else {
    avail_statistic <- c("sd", "sem", "ci")
    if (!drug_pair$replicate) {
      warning("The selected block ", plot_block,
              " doesn't have the replicate data. Statistics is not available.")
      statistic_table <- FALSE
    } else if(!statistic %in% avail_statistic) {
      warning("The parameter 'statistic = ", statistic, "' is not available.",
              "Avaliable values are ", paste(avail_statistic, sep = ", "), ".")
      statistic_table <- FALSE
    } else {
      statistic_table <- TRUE
    }
  }
  
  # 1. Extract tables for plotting
  
  # Data table
  concs <- grep("conc\\d", colnames(data$response), value = TRUE)
  selected_concs <- paste0("conc", drugs)
  
  if (statistic_table){
    if (startsWith(plot_value, "response")){
      plot_table <- data$response_statistics
    } else {
      if (!"synergy_scores" %in% names(data)){
        stop("The synergy scores are not calculated. Please run function ",
             "'CalculateSynergy' first.")
      }
      plot_table <- data$synergy_scores_statistics
    }
    plot_table <- plot_table %>% 
      dplyr::filter(block_id == plot_block) %>% 
      dplyr::ungroup()
    if (is.null(statistic)) {
      plot_table <- plot_table %>% 
        dplyr::select(
          dplyr::starts_with("conc"), 
          value = !!paste0(plot_value, "_mean")
        ) %>%
        dplyr::mutate(
          text = as.character(.RoundValues(value))
        )
    } else if (statistic == "sd") {
      plot_table <- plot_table %>% 
        dplyr::select(
          dplyr::starts_with("conc"), 
          value = !!paste0(plot_value, "_mean"),
          statistic = !!paste0(plot_value, "_sd")
        ) %>%
        dplyr::mutate(
          text = paste(
            .RoundValues(value), "\n" ,
            "\u00B1",
            .RoundValues(statistic)
          )
        )
    } else if (statistic == "sem") {
      plot_table <- plot_table %>% 
        dplyr::select(
          dplyr::starts_with("conc"), 
          value = !!paste0(plot_value, "_mean"),
          statistic = !!paste0(plot_value, "_sem")
        ) %>%
        dplyr::mutate(
          text = paste(
            .RoundValues(value), "\n" ,
            "\u00B1",
            .RoundValues(statistic)
          )
        )
    } else if (statistic == "ci") {
      plot_table <- plot_table %>% 
        dplyr::select(
          dplyr::starts_with("conc"), 
          value = !!paste0(plot_value, "_mean"),
          left = !!paste0(plot_value, "_ci_left"),
          right = !!paste0(plot_value, "_ci_right")
        ) %>%
        dplyr::mutate(
          text = paste0(
            .RoundValues(value), "\n",
            "[",
            .RoundValues(left),
            ", ",
            .RoundValues(right),
            "]"
          )
        )
    }
  } else {
    if (startsWith(plot_value, "response")){
      plot_table <- data$response
    } else {
      if (!"synergy_scores" %in% names(data)){
        stop("The synergy scores are not calculated. Please run function ",
             "'CalculateSynergy' first.")
      }
      plot_table <- data$synergy_scores
    }
    plot_table <- plot_table %>% 
      dplyr::filter(block_id == plot_block) %>% 
      dplyr::select(
        dplyr::starts_with("conc"),
        value = !!plot_value
      ) %>%
      dplyr::mutate(
        text = as.character(.RoundValues(value))
      )
  }
  
  # Extract data for selected two drugs from multi-drug combination
  other_concs <- setdiff(concs, selected_concs)
  if (length(other_concs) > 0) {
    conc_zero <- apply(
      dplyr::select(plot_table, dplyr::all_of(concs)), 
      1,
      function(x) {
        sum(x != 0) <= 2
      })
    plot_table <- plot_table[conc_zero, ]
    other_concs_sum <- plot_table %>% 
      dplyr::ungroup() %>% 
      dplyr::select(dplyr::all_of(other_concs)) %>% 
      rowSums()
    plot_table <- plot_table[other_concs_sum == 0, ] %>% 
      dplyr::select(-dplyr::all_of(other_concs))
    colnames(plot_table) <- sapply(colnames(plot_table), function(x){
      if (x == selected_concs[1]){
        return("conc1")
      } else if (x == selected_concs[2]) {
        return("conc2")
      } else {
        return(x)
      }
    })
  }
  
  # Transform conc into factor
  plot_table[, c("conc1", "conc2")] <- lapply(
    plot_table[, c("conc1", "conc2")],
    function(x) {
      factor(.RoundValues(x))
    }
  )
  plot_table <- plot_table %>% 
    dplyr::select(conc1, conc2, value, text)
  return(list(plot_table = plot_table, drug_pair = drug_pair))
}

.RoundValues <- function(numbers) {
  numbers[abs(numbers) >= 1 & !is.na(numbers)] <- round(
    numbers[abs(numbers) >= 1 & !is.na(numbers)],
    2
  )
  numbers[abs(numbers) < 1 & !is.na(numbers)] <- signif(
    numbers[abs(numbers) < 1 & !is.na(numbers)],
    2
  )
  return(numbers)
}

.Pt2mm <- function(x) {
  5 * x / 14
}


#After loading above functions call Plot2drugHeatmap Function for each cell
Plot2drugHeatmap <- function(data) 
{
data=data
plot_block = 1
drugs = c(1, 2)
plot_value = "response"
statistic = NULL
summary_statistic = NULL
dynamic = FALSE
plot_title = NULL
col_range = NULL
row_range = NULL
color_range = NULL 
high_value_color = "#FF0000"
low_value_color = "#00FF00"
text_label_size_scale = 1.4
text_label_color = "#000000"
title_text_size_scale = 1.1

library(ggplot2)
plot_data <- .Extract2DrugPlotData(data, plot_block = plot_block, 
                                     drugs = drugs, plot_value = plot_value, statistic = statistic)
  plot_table <- plot_data$plot_table
  drug_pair <- plot_data$drug_pair
  if (!is.null(row_range)) {
    selected_rows <- levels(plot_table$conc2)[row_range[1]:row_range[2]]
    plot_table <- plot_table[plot_table$conc2 %in% selected_rows, 
    ]
    plot_table$conc2 <- factor(plot_table$conc2)
  }
  if (!is.null(col_range)) {
    selected_cols <- levels(plot_table$conc1)[col_range[1]:col_range[2]]
    plot_table <- plot_table[plot_table$conc1 %in% selected_cols, 
    ]
    plot_table$conc1 <- factor(plot_table$conc1)
  }
  if (plot_value == "response") {
    if (is.null(plot_title)) {
      plot_title <- paste("Dose Response Matrix", sep = " ")
    }
    legend_title <- "Cytotoxicity (%)"
  }else if (plot_value == "response_origin") {
    if (is.null(plot_title)) {
      plot_title <- paste("Dose Response Matrix", sep = " ")
    }
    legend_title <- paste(stringr::str_to_title(drug_pair$input_type), 
                          "%")
  }else {
    if (is.null(plot_title)) {
      plot_title <- switch(sub(".*_", "", plot_value), 
                           ref = sub("_ref", " Reference Additive Effect", 
                                     plot_value), fit = sub("_fit", " Fitted Effect", 
                                                            plot_value), synergy = sub("_synergy", " Synergy Score", 
                                                                                       plot_value))
    }
    legend_title <- switch(sub(".*_", "", plot_value), ref = "Cytotoxicity (%)", 
                           fit = "Cytotoxicity (%)", synergy = "Synergy Score")
  }
  plot_subtitle <- c()
  if (!is.null(summary_statistic)) {
    concs <- plot_table[, grepl("conc\\d+", colnames(plot_table))]
    if (endsWith(plot_value, "_synergy")) {
      concs_zero <- apply(concs, 2, function(x) {
        x == 0
      })
      index <- rowSums(concs_zero) < 1
      summary_value_table <- plot_table[index, ]
    }else {
      summary_value_table <- plot_table
    }
    avail_value <- grepl("mean|median|quantile_\\d+", summary_statistic)
    if (!any(avail_value)) {
      warning("Input value for parameter summary_statistic is not available.")
      plot_subtitle <- ""
    }else {
      if ("mean" %in% summary_statistic) {
        value <- .RoundValues(mean(summary_value_table$value))
        if (length(concs == 2) & (drug_pair$replicate | 
                                  !plot_value %in% c("response", "response_origin"))) {
          p_value <- data$drug_pairs[data$drug_pairs$block_id == 
                                       plot_block, paste0(plot_value, "_p_value")]
          if (p_value != "< 2e-324") {
            p_value <- paste0("= ", p_value)
          }
          plot_subtitle <- c(plot_subtitle, paste0("Mean: ", 
                                                   value, " (p ", p_value, ")"))
        }else {
          plot_subtitle <- c(plot_subtitle, paste0("Mean: ", 
                                                   value))
        }
      }
      if ("median" %in% summary_statistic) {
        value <- .RoundValues(stats::median(summary_value_table$value))
        plot_subtitle <- c(plot_subtitle, paste0("Median: ", 
                                                 value))
      }
      qua <- grep("quantile_\\d+", summary_statistic, value = TRUE)
      if (length(qua) > 0) {
        for (q in qua) {
          pro <- as.numeric(sub("quantile_", "", q))
          value <- .RoundValues(stats::quantile(summary_value_table$value, 
                                                probs = pro/100))
          plot_subtitle <- c(plot_subtitle, paste0(pro, 
                                                   "% Quantile: ", value))
        }
      }
    }
  }
  plot_subtitle <- paste(plot_subtitle, collapse = " | ")
  if (is.null(color_range)) {
    color_range <- round(max(abs(plot_table$value)), -1) + 
      10
    start_point <- -color_range
    end_point <- color_range
  }else {
    if (length(color_range) != 2 | class(color_range) != 
        "numeric") {
      stop("The variable 'color_range' should be a vector with exact 2 numeric ", 
           "values.")
    }
    else if (color_range[1] >= color_range[2]) {
      stop("The first item in 'color_range' vector should be less than the ", 
           "second item.")
    }else {
      if (color_range[1] > max(plot_table$value) | color_range[2] < 
          min(plot_table$value)) {
        stop("There is no overlap between 'color_range' (", 
             paste(color_range, collapse = ", "), ") and the range of 'plot_value' (", 
             paste(range(plot_table$value), collapse = ", "), 
             ")")
      }
      start_point <- color_range[1]
      end_point <- color_range[2]
    }
  }
  if (dynamic) {
    conc1 <- unique(plot_table$conc1)
    conc2 <- unique(plot_table$conc2)
    mat <- reshape2::acast(plot_table, conc1 ~ conc2, value.var = "value")
    colnames(mat) <- seq(1, ncol(mat))
    rownames(mat) <- seq(1, nrow(mat))
    x_ticks_text <- as.character(sort(conc1))
    y_ticks_text <- as.character(sort(conc2))
    x <- data.frame(x = seq(1, length(conc1)), ticks = as.character(sort(conc1)))
    y <- data.frame(y = seq(1, length(conc2)), ticks = as.character(sort(conc2)))
    plot_table <- plot_table %>% dplyr::left_join(x, by = c(conc1 = "ticks")) %>% 
      dplyr::left_join(y, by = c(conc2 = "ticks"))
    x_axis_title <- paste0(drug_pair$drug1, " (", drug_pair$conc_unit1, 
                           ")")
    y_axis_title <- paste0(drug_pair$drug2, " (", drug_pair$conc_unit2, 
                           ")")
    concs <- expand.grid(conc1, conc2)
    hover_text <- NULL
    for (i in 1:nrow(concs)) {
      hover_text <- c(hover_text, paste0(drug_pair[, c("drug1", 
                                                       "drug2")], ": ", sapply(concs[i, ], as.character), 
                                         " ", drug_pair[, c("conc_unit1", "conc_unit1")], 
                                         "<br>", collapse = ""))
    }
    hover_text <- paste0(hover_text, "Value: ", .RoundValues(plot_table$value), 
                         sep = "")
    hover_text <- matrix(hover_text, nrow = length(conc1))
    if (start_point < 0 & end_point > 0) {
      zero_pos <- -start_point/(end_point - start_point)
      color_scale <- list(c(0, low_value_color), c(zero_pos, 
                                                   "white"), c(1, high_value_color))
    }else {
      color_scale <- list(c(0, low_value_color), c(1, high_value_color))
    }
    p <- plotly::plot_ly(x = ~plot_table$x, y = ~plot_table$y, 
                         z = ~plot_table$value, zmin = start_point, zmid = 0, 
                         zmax = end_point, type = "heatmap", hoverinfo = "", 
                         autocolorscale = FALSE, colorscale = color_scale, 
                         colorbar = list(x = 1, y = 0.75, align = "center", 
                                         outlinecolor = "#FFFFFF", tickcolor = "#FFFFFF", 
                                         title = legend_title, titlefont = list(size = 12 * 
                                                                                  title_text_size_scale, family = "arial"), tickfont = list(size = 12 * 
                                                                                                                                              title_text_size_scale, family = "arial"))) %>% 
      plotly::layout(title = list(text = paste0("<b>", 
                                                plot_title, "</b>"), font = list(size = 18 * 
                                                                                   title_text_size_scale, family = "arial"), y = 1.3), 
                     xaxis = list(title = paste0(x_axis_title), tickfont = list(size = 12 * 
                                                                                  title_text_size_scale, family = "arial"), titlefont = list(size = 12 * 
                                                                                                                                               title_text_size_scale, family = "arial"), ticks = "none", 
                                  showspikes = FALSE, showgrid = FALSE, tickmode = "array", 
                                  tickvals = x$x, ticktext = x$ticks), yaxis = list(title = paste0(y_axis_title), 
                                                                                    tickfont = list(size = 12 * title_text_size_scale, 
                                                                                                    family = "arial"), titlefont = list(size = 12 * 
                                                                                                                                          title_text_size_scale, family = "arial"), 
                                                                                    ticks = "none", showspikes = FALSE, showgrid = FALSE, 
                                                                                    tickmode = "array", tickvals = y$y, ticktext = y$ticks), 
                     margin = list(l = 50, r = 50, b = 50, t = 90, 
                                   pad = 4)) %>% plotly::add_annotations(text = plot_subtitle, 
                                                                         x = 0.3, y = 1.05, yref = "paper", xref = "paper", 
                                                                         xanchor = "middle", yanchor = "top", showarrow = FALSE, 
                                                                         font = list(size = 15 * title_text_size_scale, family = "arial"))
    if (!is.null(text_label_color)) {
      p <- p %>% plotly::add_annotations(x = ~plot_table$x, 
                                         y = ~plot_table$y, text = ~plot_table$text, showarrow = FALSE, 
                                         font = list(color = text_label_color, size = 12 * 
                                                       text_label_size_scale), ax = 20, ay = -20)
    }
    p <- p %>% plotly::config(toImageButtonOptions = list(format = "svg", 
                                                          filename = plot_title, width = NULL, height = NULL, 
                                                          scale = 1))
  }else {
    warn = getOption("warn")
    options(warn = -1)
    p <- ggplot2::ggplot(data = plot_table, aes(x = conc1, 
                                                y = conc2, fill = value)) + ggplot2::geom_tile() + 
      ggplot2::geom_text(ggplot2::aes(label = text), size = .Pt2mm(7) * 
                           text_label_size_scale)
    if (start_point < 0 & end_point > 0) {
      colour_breaks <- c(start_point, 0, end_point)
      colours <- c(low_value_color, "#FFFFFF", high_value_color)
      p <- p + scale_fill_gradientn(limits = c(start_point, 
                                               end_point), colours = colours[c(1, seq_along(colours), 
                                                                               length(colours))], values = c(0, scales::rescale(colour_breaks, 
                                                                                                                                from = c(start_point, end_point)), 1), oob = scales::oob_squish_any)
    }else {
      p <- p + ggplot2::scale_fill_gradient(high = high_value_color, 
                                            low = low_value_color, name = legend_title, limits = c(start_point, 
                                                                                                   end_point), oob = scales::oob_squish_any)
    }
    p <- p + ggplot2::guides(fill = ggplot2::guide_colorbar(barheight = 10, 
                                                            barwidth = 1.5, ticks = FALSE)) + ggplot2::labs(title = plot_title, 
                                                                                                            subtitle = plot_subtitle, x = paste0(drug_pair$drug1, 
                                                                                                                                                 " (", drug_pair$conc_unit1, ")"), y = paste0(drug_pair$drug2, 
                                                                                                                                                                                              " (", drug_pair$conc_unit2, ")"), fill = legend_title) + 
      ggplot2::theme(plot.title = ggplot2::element_text(size = 13.5 * 
                                                          title_text_size_scale, face = "bold", hjust = 0.5), 
                     plot.subtitle = ggplot2::element_text(size = 12 * 
                                                             title_text_size_scale, hjust = 0.5), panel.background = ggplot2::element_blank(), 
                     axis.text = ggplot2::element_text(size = 10 * title_text_size_scale), axis.title = ggplot2::element_text(size = 10 * title_text_size_scale), legend.title = ggplot2::element_text(size = 10 *  title_text_size_scale), legend.text = ggplot2::element_text(size = 9 * title_text_size_scale), legend.background = element_rect(color = NA))
   
    
  }
p
}

pdf("HCC38/HCC38_dose_response_heatmap.pdf", onefile=FALSE)
load("HCC38_res.RData")
Plot2drugHeatmap(res)
dev.off()

pdf("Hs578T/Hs578T_dose_response_heatmap.pdf", onefile=FALSE, width=10)
  load("Hs578T_res.RData")
  Plot2drugHeatmap(res)
dev.off()

pdf("HCC1395/HCC1395_dose_response_heatmap.pdf", onefile=FALSE)
  load("HCC1395_res.RData")
  Plot2drugHeatmap(res)
dev.off()

pdf("HCC1806/HCC1806_dose_response_heatmap.pdf", onefile=FALSE)
  load("HCC1806_res.RData")
  Plot2drugHeatmap(res)
dev.off()
