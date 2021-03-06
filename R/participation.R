#' Participation Coefficient
#' @description Computes the participation coefficient for each node. The participation
#' coefficient measures the strength of a node's connections within its community. Positive
#' and negative signed weights for participation coefficients are computed separately.
#' 
#' @param A Network adjacency matrix
#' 
#' @param comm A vector of corresponding to each item's community.
#' Defaults to "walktrap" for the walktrap community detection algorithm.
#' Set to "louvain" for the louvain community detection algorithm.
#' Can also be set to user-specified communities (see examples)
#' 
#' @return Returns a list containing:
#' 
#' \item{overall}{Participation coefficient without signs considered}
#' 
#' \item{positive}{Participation coefficient with only positive sign}
#' 
#' \item{negative}{Participation coefficient wih only negative sign}
#' 
#' @details 
#' Values closer to 1 suggest greater within-community connectivity and 
#' values closer to 0 suggest greater between-community connectivity
#' 
#' @examples
#' #theoretical factors
#' comm <- c(rep(1,8), rep(2,8), rep(3,8), rep(4,8), rep(5,8), rep(6,8))
#' 
#' A <- TMFG(neoOpen)$A
#' 
#' pc <- participation(A, comm = comm)
#' 
#' #walktrap factors
#' wpc <- participation(A, comm = "walktrap")
#' 
#' @references
#' Guimera, R., & Amaral, L. A. N. (2005).
#' Functional cartography of complex metabolic networks.
#' \emph{Nature}, \emph{433}, 895-900.
#' doi: \href{https://doi.org/10.1038/nature03288}{10.1038/nature03288}
#' 
#' Rubinov, M., & Sporns, O. (2010). 
#' Complex network measures of brain connectivity: Uses and interpretations. 
#' \emph{Neuroimage}, \emph{52}, 1059-1069.
#' doi: \href{https://doi.org/10.1016/j.neuroimage.2009.10.003}{10.1016/j.neuroimage.2009.10.003}
#' 
#' @author Alexander Christensen <alexpaulchristensen@gmail.com>
#' 
#' @export
#Participation Coefficient----
participation <- function (A, comm = c("walktrap","louvain"))
{
    #nodes
    n <- ncol(A)
    
    #set diagonal to zero
    diag(A) <- 0
    
    #set communities
    if(missing(comm))
    {comm<-"walktrap"
    }else{comm<-comm}
    
    if(is.numeric(comm))
    {facts <- comm
    }else{
        if(comm=="walktrap")
        {facts <- igraph::walktrap.community(convert2igraph(A))$membership
        }else if(comm=="louvain")
        {facts <- louvain(A)$community}
    }
    
    #participation coefficient
    pcoef <- function (A, facts)
    {
        k <- colSums(A) #strength
        Gc <- facts #communities
        Kc2 <- vector(mode="numeric",length=n)  
        
        for(i in 1:max(Gc))
        {Kc2 <- Kc2 + colSums(A*(Gc==i))^2} #strength within communities squared
        
        ones <- vector(mode="numeric",length=n) + 1
        
        P <- ones - Kc2 / (k^2)
        
        P[!k] <- 0
        
        return(P)
    }
    
    overall <- 1- pcoef(A, facts) #overall participation coefficient
    
    #signed participation coefficient
    poswei <- ifelse(A>=0,A,0) #positive weights
    negwei <- ifelse(A<=0,A,0) #negative weights
    
    pos <- 1 - pcoef(poswei, facts) #positive  participation coefficient
    if(all(pos==1))
    {pos<-1-pos}
    neg <- 1 - pcoef(negwei, facts) #negative participation coefficient
    if(all(neg==1))
    {neg<-1-neg}
    
    return(list(overall=overall,positive=pos,negative=neg))
}
#----