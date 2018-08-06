return_MANOVA_results <- function(dataset, group_column) {
  F_dists <- find_approx_F_dist(dataset, group_column)
  results <- 1 - sapply(X = F_dists[c('Wilks','Roy','Pillai','Hotelling')], FUN = function(obj) pf(obj[1], obj[2], obj[3]))
  results <- rbind(p_f = results, statistic = F_dists$untransformed[1:4],
                   data.frame(F_dists[c('Wilks','Roy','Pillai','Hotelling')],row.names = c('F Approx.', 'df1', 'df2')))
  return(results)
}

find_approx_F_dist <- function(dataset, group_column) {
  # dataset (dataframe): dataset with groupings as integer values. 
  # group_column (string): string name of column with group entries, integer values. 
  MANOVA_stat_lst <- find_MANOVA_statistics(dataset,group_column)
  
  Vh <- MANOVA_stat_lst['n_groups'] - 1
  p <- ncol(dataset) - 1
  Ve <- nrow(dataset) - Vh - 1
  s <- min(Vh, p) 
  
  Wilks_approx_F <- FforWilks(Lambda = MANOVA_stat_lst['Wilks'], Vh = Vh, p = p, Ve = Ve)
  Roy_approx_F <- FBoundforRoy(R = MANOVA_stat_lst['Roys'], Vh = Vh, p = p, Ve = Ve)
  Pillai_approx_F <- FapproxforPillai(P = MANOVA_stat_lst['Pillai'], Vh = Vh, p = p, Ve = Ve, s = s)
  Hotelling_approx_F <- FapproxforHotelling(H = MANOVA_stat_lst['Hotelling'], Vh = Vh, p = p, Ve = Ve)

  return(list(untransformed = MANOVA_stat_lst, Wilks = Wilks_approx_F,Roy = Roy_approx_F, Pillai = Pillai_approx_F, Hotelling = Hotelling_approx_F))
}

find_MANOVA_statistics <- function(dataset, group_column){
  # dataset (dataframe): dataset with groupings as integer values. 
  # group_column (string): string name of column with group entries, integer values. 
  
  grouped_ds_lst <- lapply(1:length(unique(dataset[,group_column])), function(i) dataset[dataset[,group_column] == i,!names(dataset) %in% c(group_column)])
  H <- Reduce("+", lapply(grouped_ds_lst,function(g) hypothesis_iv(g, dataset)))
  E <- Reduce("+", lapply(grouped_ds_lst,function(g) error_iv(g, dataset)))
  
  Einv <- solve(E)
  HoverE <- H %*% Einv
  eigen_det <- eigen(HoverE)
  ev <- eigen_det$values
  
  Wilks <- 1/(prod(1 + ev))
  Roys <- (max(ev))/(1 + max(ev))
  Pillai <- sum(ev/(1 + ev))
  Hotelling <- sum(ev)
  
  return(c(Wilks = Wilks,Roys = Roys,Pillai = Pillai,Hotelling = Hotelling, n_groups = length(grouped_ds_lst)))
}

hypothesis_iv <- function(group,dataset) {
  A <- sapply(group,mean)
  B <- sapply(dataset[, 1:(ncol(dataset) - 1)],mean)
  dif <- A - B
  return((dif %*% t(dif))*nrow(group))
}

error_iv <- function(group,dataset) {
  A <- sapply(group,mean)
 
  mattimestranspose <- function(A)
    return(A %*% t(A))
  
  mylist <- lapply(1:nrow(group), function(i) mattimestranspose(t(as.matrix(group[i,] - A))))
  a1 <- Reduce('+',mylist)
  
  return(a1)
}

FforWilks <- function(Lambda, Vh, p, Ve) {
  t <- (((p^2)*(Vh^2) - 4)/((p^2) + (Vh^2) - 5))^.5
  df1 <- p*Vh
  w <- Ve + Vh - ((p + Vh + 1)/2)
  df2 <- w*t - (((p*Vh) - 2)/2)
  Fapprox <- ((1 - (Lambda^(1/t)))/(Lambda^(1/t)))*(df2/df1)
  return(c(Fapprox = Fapprox, df1 = df1, df2 = df2))
}

FBoundforRoy <- function(R, Vh, p, Ve) {
  v1 <- (Ve - p - 1)/2
  v2 <- (p - Vh - 1)/2
  
  return(c(Fapprox = R*v1/v2, df1 = 2*v1 + 2, df2 = 2*v2 + 2))
}

FapproxforPillai <- function(P, Vh, p, Ve, s) {
  N <- (Ve - Vh + s)/2
  m <- (abs(Vh - p) - 1)/2
  num <- (2*N + s + 1)*P
  den <- (2*m + s + 1)*(s - P)
  Fapprox <- num/den
  df1 <- s*(2*m + s + 1)
  df2 <- s*(2*N + s + 1)
  return(c(Fapprox = Fapprox, df1 = df1, df2 = df2))
}

FapproxforHotelling <- function(H, Vh, p, Ve) {
  a <- p*Vh
  B <- ((Ve + Vh - p - 1)*(Ve - 1))/((Ve - p - 3)*(Ve - p))
  b <- 4 + ((a + 2)/(B - 1))
  cnum <- a*(b - 2)
  cden <- b*(Ve - p + 1)
  Fapprox <- (H*cden)/cnum
  return(c(Fapprox = Fapprox, df1 = a, df2 = b))
}

