% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MaST.R
\name{MaST}
\alias{MaST}
\title{Maximum Spanning Tree}
\usage{
MaST(data, normal = FALSE, na.data = c("pairwise", "listwise", "fiml",
  "none"), depend = FALSE)
}
\arguments{
\item{data}{Can be a dataset or a correlation matrix}

\item{normal}{Should data be transformed to a normal distribution?
Defaults to FALSE.
Data is not transformed to be normal.
Set to TRUE if data should be transformed to be normal
(computes correlations using the \link[qgraph]{cor_auto} function)}

\item{na.data}{How should missing data be handled?
For "listwise" deletion the \code{\link{na.omit}} function is applied.
Set to "fiml" for Full Information Maxmimum Likelihood (\link[psych]{corFiml}).
Full Information Maxmimum Likelihood is \strong{recommended} but time consuming}

\item{depend}{Is network a dependency (or directed) network?
Defaults to FALSE.
Set TRUE to generate a MaST-filtered dependency network
(output obtained from the \code{\link{depend}} function)}
}
\value{
A sparse association matrix
}
\description{
Applies the Maximum Spanning Tree (MaST) filtering method
}
\examples{
MaST.net <- MaST(neoOpen)

}
\references{
Adapted from: \url{https://www.mathworks.com/matlabcentral/fileexchange/23276-maximum-weight-spanning-tree--undirected}
}
\author{
Alexander Christensen <alexpaulchristensen@gmail.com>
}
