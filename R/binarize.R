#' Binarize Network
#' @description Converts weighted adjacency matrix to a binarized adjacency matrix
#' 
#' @param A An adjacency matrix of network data (or an array of matrices)
#' 
#' @return Returns an adjancency matrix of 1's and 0's
#' 
#' @examples
#' A <- TMFG(neoOpen)$A
#' 
#' neoB <- binarize(A)
#' 
#' @author Alexander Christensen <alexpaulchristensen@gmail.com>
#' 
#' @export
#Binarize function----
binarize <- function (A)
{
    bin <- ifelse(A!=0,1,0)
    row.names(bin) <- colnames(A)
    colnames(bin) <- colnames(A)
    
    return(bin)
}
#----