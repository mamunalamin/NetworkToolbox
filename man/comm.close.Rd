% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/comm.close.R
\name{comm.close}
\alias{comm.close}
\title{Community Closeness Centrality}
\usage{
comm.close(A, comm, weighted = FALSE)
}
\arguments{
\item{A}{An adjacency matrix of network data}

\item{comm}{A vector or matrix corresponding to the
community each node belongs to}

\item{weighted}{Is the network weighted?
Defaults to FALSE.
Set to TRUE for weighted measures}
}
\value{
A vector of community closeness centrality values for each specified
community in the network
(larger values suggest more central positioning)
}
\description{
Computes the community closeness centrality measure of each
community in a network
}
\examples{
A <- TMFG(neoOpen)$A

comm <- igraph::walktrap.community(convert2igraph(abs(A)))$membership

#Weighted
result <- comm.close(A, comm)

#Unweighted
result <- comm.close(A, comm, weighted = FALSE)

}
\references{
Christensen, A. P., Cotter, K. N., Silvia, P. J., & Benedek, M. (2018)
Scale development via network analysis: A comprehensive and concise measure of Openness to Experience
\emph{PsyArXiv}, 1-40.
doi: \href{https://doi.org/10.31234/osf.io/3raxt}{10.31234/osf.io/3raxt}
}
\author{
Alexander Christensen <alexpaulchristensen@gmail.com>
}
