######################################################################################
# function to generate linear combination of vectors
# according to Eq. 1 in the JCTC paper (Costa et al, 2015)
combine <- function(M, v){
  n <- length(v)
  if(n > 1){
    out <- M[,1] * v[1]
    if(ncol(M) != n) stop("The number of vectors and alphas must be equal ")
    for(i in 2:n){
      out <- out + M[,i] * v[i]
    }
  }else{
    out <- M * v[1]
  }
  # normalize resulting vectors 
  out / sqrt(sum(out*out))
}
####################################################################################
read.mass.psf <- function(top){
  a <- as.numeric(system(command = paste0("grep '!NATOM' ",top," | awk '{print $1}'"),intern = TRUE))
  out <- as.numeric(system(command = paste0("grep -A ",a," '!NATOM' ",top," | awk '{print $8}' | tail -n +2"), intern = TRUE)) 
  #names(out) <-  c("eleno", "segid", "resno","resid","elety","elesy","charge","mass","zero","zero2","wmain")
  return(out)
}
######################################################################################
#####################################################################################
# function to displace structure along normal modes
# up to a desired magnitude
displace.nma <- function(pdb,vec,rms,selection,outname){
  xyz <- as.vector(pdb$xyz)
  if(selection == 'calpha'){
    pdb.inds <- atom.select(pdb, string = 'calpha')
    mag <- sqrt(length(pdb.inds$atom)) * rms / sqrt(sum(vec * vec))
    plus <- vec*mag + xyz
  }
  if(selection == 'noh'){
    pdb.inds <- atom.select(pdb, string = 'noh')
    mag <- sqrt(length(pdb.inds$atom)) * rms / sqrt(sum(vec * vec))
    plus <- vec*mag + xyz
  }
  #coor <- t(cbind(xyz, plus))
  write.pdb(pdb=pdb, xyz = plus, file = outname)
}
#####################################################################################