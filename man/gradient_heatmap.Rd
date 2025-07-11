% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SpatialVis.R
\name{gradient_heatmap}
\alias{gradient_heatmap}
\title{gradient_heatmap}
\usage{
gradient_heatmap(
  mtx = NULL,
  clus_method = "ward.D2",
  cutree_rows = 3,
  cluster_cols = F,
  rownames = T,
  hm_color = colorRampPalette(rev(brewer.pal(11, "Spectral")))(100)
)
}
\arguments{
\item{mtx}{Gene expression matrix}

\item{clus_method}{Clustering method}

\item{cluster_cols}{Clustering columns}

\item{hm_color}{Heatmap colors}

\item{cutreee_rows}{Cut heatmap}
}
\description{
gradient_heatmap
}
\details{
This functions plots a heatmap for Pseudo3MTime
}
