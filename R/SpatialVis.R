#' SpatialVis
#' @param file Seurat Object as Input
#' @param st.calc Spatialtime values
#' @param spatial.by absolute or relative values
#' @param slice Select tissue slice
#' @param remove.na subset only tissue of spatialtime
#' @param return_obj Return object
#' @param pt_size change spatial spots size
#' @param image_opacity H&E background opacity
#'
#' SpatialVis
#' @import Seurat
#' @import tidyverse
#' @export
#'
#' @details
#' This function calculates and adds coordinates values to each line drawn in data frame.

SpatialVis <- function(file = NULL, st.calc = NULL, spatial.by = c("abs", "rel"), slice = "slice1", remove.na = F, return_obj = T,
                       pt_size = 1, image_opacity = 1) {

  if (is.null(file) || is.null(st.calc)) {
    stop("Both 'file' and 'st.calc' must be provided.")
  }

  spatial.by <- match.arg(spatial.by)

  myBarcode <- rownames(file@meta.data)
  TissueID <- st.calc[match(myBarcode, st.calc$barcode), ]

  if (spatial.by == "abs") {

    file$st <- TissueID$st_abs
  } else if (spatial.by == "rel") {

    file$st <- TissueID$st_rel
  }

  file$st[is.na(file$st)] <- 0

  if (return_obj == T) {
    return(file)
  }

  if (remove.na) {

    sub <- subset(file, subset = st != 0)
    SpatialFeaturePlot(sub, features = "st", images = slice, image.alpha = image_opacity, pt.size.factor = pt_size)

  } else {
    SpatialFeaturePlot(file, features = "st", images = slice, image.alpha = image_opacity, pt.size.factor = pt_size)
  }

}

#' GeneVis
#' @param file Seurat object with pseudotime values in metadata
#' @param column Genes to be plotted
#' @param signal Selecting wheter genes or module pathways to visualize
#' @param span Curve smoothness
#' @param se Standard error
#' @param line_thickness Curve plot line thickness
#'
#' @import Seurat
#' @import tidyverse
#' @export
#'
#' @details
#' Visualization of genes of interest using reference line as starting point
#'
GeneVis <- function(file = NULL, column = NULL, signal = c("gene", "pathway"), span = 1, se = F, line_thickness = 1) {

  if (is.null(file) || class(file) != "Seurat") {
    stop("Error. File not found or format not supported.")
  }

  if (is.null(column)) {
    stop("Basic parameters are missing.")
  }

  signal <- match.arg(signal)

  # Need to add error handling here
  if (signal == "gene") {
    genes <- FetchData(file, vars = column)
  } else {
    genes <- file@meta.data[, column]
  }

  df <- file@meta.data %>%
    mutate(x = rownames(file@meta.data)) %>%
    select("x","st")

  q <- cbind(df, genes)

  df_long <- melt(q, id.vars = c("x", "st"))

  p <- ggplot(df_long, aes(x = st, y = value, color = variable))

  for (var in unique(df_long$variable)) {
    p <- p + geom_smooth(data = subset(df_long, variable == var), aes(x = st, y = value),
                         method = "loess", span = span, se = se, linewidth = line_thickness) + theme_classic()
  }

  return(p)

}
