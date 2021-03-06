#' Maximum Spanning Tree
#' @description Applies the Maximum Spanning Tree (MaST) filtering method
#' 
#' @param data Can be a dataset or a correlation matrix
#' 
#' @param normal Should data be transformed to a normal distribution?
#' Defaults to FALSE.
#' Data is not transformed to be normal.
#' Set to TRUE if data should be transformed to be normal
#' (computes correlations using the \link[qgraph]{cor_auto} function)
#' 
#' @param na.data How should missing data be handled?
#' For "listwise" deletion the \code{\link{na.omit}} function is applied.
#' Set to "fiml" for Full Information Maxmimum Likelihood (\link[psych]{corFiml}).
#' Full Information Maxmimum Likelihood is \strong{recommended} but time consuming
#' 
#' @param depend Is network a dependency (or directed) network?
#' Defaults to FALSE.
#' Set TRUE to generate a MaST-filtered dependency network
#' (output obtained from the \code{\link{depend}} function)
#' 
#' @return A sparse association matrix
#' 
#' @examples
#' MaST.net <- MaST(neoOpen)
#' 
#' @references 
#' Adapted from: \url{https://www.mathworks.com/matlabcentral/fileexchange/23276-maximum-weight-spanning-tree--undirected}
#' 
#' @author Alexander Christensen <alexpaulchristensen@gmail.com>
#' 
#' @export
#Maximum Spanning Tree----
MaST <- function (data, normal = FALSE,
                  na.data = c("pairwise","listwise","fiml","none"),
                  depend = FALSE)
{
    
    #missing data handling
    if(missing(na.data))
    {
        if(any(is.na(data)))
        {stop("Missing values were detected! Set 'na.data' argument")
        }else{na.data<-"none"}
    }else{na.data<-match.arg(na.data)}
    
    if(na.data=="pairwise")
    {
        if(normal)
        {cormat<-qgraph::cor_auto(data,missing=na.data)
        }else{cormat<-cor(data,use="pairwise.complete.obs")}
    }else if(na.data=="listwise")
    {
        if(normal)
        {cormat<-qgraph::cor_auto(data,missing=na.data)
        }else{
            rem<-na.action(na.omit(data))
            warning(paste(length(na.action(na.omit(data)))),
                    " rows were removed for missing data\nrow(s): ",
                    paste(na.action(na.omit(data)),collapse = ", "))
            data<-na.omit(data)
        }
    }else if(na.data=="fiml")
    {
        if(normal)
        {cormat<-qgraph::cor_auto(data,missing=na.data)
        }else{cormat<-psych::corFiml(data)}
    }
    
    #corrlation matrix
    if(nrow(data)==ncol(data)){cormat<-data
    }else if(normal){cormat<-qgraph::cor_auto(data)
    }else{cormat<-cor(data)}
    
    FIND_PathCompression <- function (temproot)
    {
        ParentPointer[temproot]
        if(ParentPointer[temproot]!=temproot)
        {ParentPointer[temproot]<-FIND_PathCompression(ParentPointer[temproot])}
        parent<-ParentPointer[temproot]
    }
    
    corma<-abs(cormat)
    nodeT<-0
    nodeF<-0
    weights<-0
    wc<-0
    n<-ncol(corma)
    for (i in 1:n)
        for (j in 1:n)
            if (corma[i,j]!=0) #Figure out how to remove warning
            {
                wc<- wc+1
                nodeT[wc] <- i
                nodeF[wc] <- j
                weights[wc] <- corma[i,j]
            }
    edgelist<-cbind(weights,nodeT,nodeF)
    edgelist<-edgelist[order(edgelist[,1]),]
    #Number of edges
    e <- nrow(edgelist)
    #Assign ParentPointer to each vertex
    assign("ParentPointer",1:n)
    #Assign a tree rank to each vertex
    TreeRank<-matrix(0,nrow=1,ncol=n)
    #MSTreeEdges and counter
    MSTreeEdges<-matrix(0,nrow=n-1,ncol=3)
    MSTcounter<-0
    i<-e
    
    while((MSTcounter<(n-1))&&(e>=1))
    {
        #Find roots of the tree that the selected edge's two
        #vertices belong to. Also perform path compression.
        root1<-0
        root2<-0
        temproot<-0
        temproot<-as.numeric(edgelist[i,2])
        root1<-FIND_PathCompression(temproot)
        
        temproot<-as.numeric(edgelist[i,3])
        root2<-FIND_PathCompression(temproot)
        
        if(root1!=root2)
        {
            MSTcounter<-MSTcounter+1
            MSTreeEdges[MSTcounter,1:3]<-edgelist[i,]
            if(TreeRank[root1]>TreeRank[root2])
            {ParentPointer[root2]<-root1}else 
                if(TreeRank[root1]==TreeRank[root2])
                {TreeRank[root2]<-TreeRank[root2]+1
                ParentPointer[root1]<-root2}else if(TreeRank[root1]<TreeRank[root2])
                {ParentPointer[root1]<-root2}
        }
        i<-i-1
    }
    S<-MSTreeEdges
    if(depend)
    {
        for(i in 1:nrow(S))
            if(cormat[S[i,2],S[i,3]]>=cormat[S[i,3],S[i,2]])
            {S[i,1]<-cormat[S[i,2],S[i,3]]
            S[i,2]<-S[i,2]
            S[i,3]<-S[i,3]
            }else if(cormat[S[i,2],S[i,3]]<cormat[S[i,3],S[i,2]])
            {
                S[i,1]<-cormat[S[i,3],S[i,2]]
                S[i,2]<-S[i,3]
                S[i,3]<-S[i,2] 
            }
    }
    L<-S
    if(depend)
    {W<-matrix(1:nrow(cormat),nrow=nrow(cormat),ncol=1)
    X<-matrix(1:nrow(cormat),nrow=nrow(cormat),ncol=1)
    Y<-matrix(0,nrow=nrow(cormat),ncol=1)
    Z<-cbind(Y,W,X)
    K<-rbind(L,Z)
    }else{L[,2]<-S[,3]
    L[,3]<-S[,2]
    K<-rbind(S,L)}
    x<-as.matrix(Matrix::sparseMatrix(i=K[,2],j=K[,3],x=K[,1]))
    diag(x)<-1
    x<-as.matrix(x)
    x<-ifelse(x!=0,cormat,0)
    x<-as.data.frame(x)
    colnames(x)<-colnames(data)
    row.names(x)<-colnames(data)
    x<-as.matrix(x)
    return(x)
}
#----