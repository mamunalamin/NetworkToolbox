#' Leverage Centrality
#' @description Computes leverage centrlaity of each node in a network
#' (the degree of connected neighbors; \strong{Please see and cite Joyce et al., 2010})
#' @param A An adjacency matrix of network data
#' 
#' @param weighted Is the network weighted?
#' Defaults to TRUE.
#' Set to FALSE for unweighted measure of leverage centrality
#' 
#' @return A vector of leverage centrality values for each node in the network
#' 
#' @examples
#' A <- TMFG(neoOpen)$A
#' 
#' #Weighted
#' levW <- leverage(A)
#'
#' #Unweighted
#' levU <- leverage(A, weighted = FALSE)
#' 
#' @references 
#' Joyce, K. E., Laurienti, P. J., Burdette, J. H., & Hayasaka, S. (2010).
#' A new measure of centrality for brain networks. 
#' \emph{PLoS One}, \emph{5} e12200.
#' doi: \href{https://doi.org/10.1371/journal.pone.0012200}{10.1371/journal.pone.0012200}
#' 
#' @author Alexander Christensen <alexpaulchristensen@gmail.com>
#' 
#' @export 
#Leverage Centrality----
leverage <- function (A, weighted = TRUE)
{
    if(nrow(A)!=ncol(A))
    {stop("Input not an adjacency matrix")}
    
    if(!weighted)
    {B<-binarize(A)
    }else{B<-A}
    
    con<-colSums(B)
    
    lev<-matrix(1,nrow=nrow(B),ncol=1)
    
    for(i in 1:ncol(B))
    {lev[i]<-(1/con[i])*sum((con[i]-con[which(B[,i]!=0)])/(con[i]+con[which(B[,i]!=0)]))}
    
    for(i in 1:nrow(lev))
        if(is.na(lev[i,]))
        {lev[i,]<-0}
    
    lev <- as.vector(lev)
    
    names(lev) <- colnames(A)
    
    return(lev)
}
#----