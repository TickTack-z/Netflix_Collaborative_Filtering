train_df = read.csv("C:\\Users\\sxzho\\OneDrive\\IEOR4525\\HW7\\train.csv",header = FALSE)
test_df = read.csv("C:\\Users\\sxzho\\OneDrive\\IEOR4525\\HW7\\test.csv",header = FALSE)
headings <- c('user','film','score')
names(train_df) <- headings
names(test_df) <- headings

#visulization
#score distribution
hist(train_df$score)
#frequency of film be scored
hist(table(train_df$film))
max(train_df$user)
#frequency of user scoring
hist(table(train_df$user))

#baseline
library(plyr)
library(hydroGOF)
est <- mean(train_df$score)
sqrt(mse(test_df$score,rep(est,nrow(test_df)),rm=TRUE))

#baseline with bias: x_bar+bi+bu
V <- 1:max(train_df[2])
U <- 1:max(train_df[1])
film <- integer(max(train_df[2]))
for (i in V){
  film[i] = mean(train_df$score[train_df[2]==i]) - est
}

user <- integer(max(train_df[1]))
for (u in U){
  user[u] = mean(train_df$score[train_df[1]==u]) - est
}

sqrt(mse(test_df$score,user[test_df$user]+film[test_df$film]+est))

#consider regulation 
#first construct Mu Mi:
Mi <- integer(max(test_df$film))
for (i in V){
  Mi[i] = sum(train_df$film==i)
}

Mu <- integer(max(test_df$user))
for (u in U){
  Mu[u] = sum(train_df$user==u)
}

y=integer(100)
#cross validation
for (lambda in seq(1,10,0.1)){
  #construct A
  A=diag(max(V)+max(U))
  
  for (u in 1:max(U)){
    A[u,u]=1
    A[u,max(U)+train_df$film[train_df$user==u]]=1/(lambda+Mu[u])
  }
  
  for (i in (max(U)+1):(max(V)+max(U))){
    A[i,i]=1
    A[i,train_df$user[train_df$film==i-max(U)]]=1/(lambda+Mi[i-max(U)])
  }
  
  #construct RHS
  RHS=integer(max(U)+max(V))
  for (u in 1: max(U)){
    RHS[u]=(sum(train_df$score[train_df$user==u]) - est*Mu[u])/(lambda+Mu[u])
  }
  for (i in (max(U)+1): (max(V)+ max(U))){
    RHS[i]=(sum(train_df$score[train_df$film==i-max(U)]) - est*Mi[i-max(U)])/(lambda+Mi[i-max(U)])
  }
  solution <- solve(A,RHS)
  
  y[lambda*10]=sqrt(mse(test_df$score,solution[test_df$user]+solution[test_df$film+rep(max(U),nrow(test_df))]+est))
}
plot(seq(1,10,0.1),y)

#choosing lambda=3.9
lambda <- 3.9
A=diag(max(V)+max(U))
for (u in 1:max(U)){
  A[u,u]=1
  A[u,max(U)+train_df$film[train_df$user==u]]=1/(lambda+Mu[u])
}
for (i in (max(U)+1):(max(V)+max(U))){
  A[i,i]=1
  A[i,train_df$user[train_df$film==i-max(U)]]=1/(lambda+Mi[i-max(U)])
}
#construct RHS
RHS=integer(max(U)+max(V))
for (u in 1: max(U)){
  RHS[u]=(sum(train_df$score[train_df$user==u]) - est*Mu[u])/(lambda+Mu[u])
}
for (i in (max(U)+1): (max(V)+ max(U))){
  RHS[i]=(sum(train_df$score[train_df$film==i-max(U)]) - est*Mi[i-max(U)])/(lambda+Mi[i-max(U)])
}
solution <- solve(A,RHS)
sqrt(mse(test_df$score,solution[test_df$user]+solution[test_df$film+rep(max(U),nrow(test_df))]+est))

#residual matrix
xresidual=train_df$score-(est+solution[train_df$user]+solution[train_df$film+rep(max(U),nrow(train_df))])
residual_matrix=matrix(0,nrow=max(U),ncol=max(V))
for (j in 1:length(xresidual)){
  residual_matrix[train_df$user[j],train_df$film[j]]=xresidual[j]
}

M=matrix(0,nrow=max(U),ncol=max(V))
for (j in 1:nrow(train_df)){
  M[train_df$user[j],train_df$film[j]]=1
}

#construct similarity matrix D
D <- diag(max(V))
for (i in 1:max(V)){
  D[i,i]=1
  for (j in 1:max(V)){
    if (i!=j){
      xintersect=intersect(which(M[,i]==1),which(M[,j]==1))
      if (length(xintersect)<2){
        D[i,j]=0
      }
      else
      {
        x1=residual_matrix[xintersect,i]
        x2=residual_matrix[xintersect,j]
        D[i,j]=sum(x1*x2)/sqrt(sum(x1*x1)*sum(x2*x2))
      }
        
    }
  }
}

y=integer(100)
for (k in seq(1,100,1)){
L <- k
for (j in 1:nrow(test_df)){
  u <- test_df[j,1]
  i <- test_df[j,2]
  films_rated=train_df$film[train_df$user==u]
  mydataframe=data.frame(abs_D=abs(D[i,films_rated]),D=D[i,films_rated],similar_film=films_rated)
  mydataframe=mydataframe[order(mydataframe[,1],decreasing = TRUE),]

  num=min(L,length(films_rated))
  #find nearest
  temp_index=mydataframe$similar_film[1:num]

  temp=sum(D[i,temp_index]*residual_matrix[u,mydataframe$similar_film[1:num]])
  under <- sum(abs(D[i,temp_index]))
  a[j] <- (test_df[j,3] - (est+solution[test_df[j,1]]+solution[test_df[j,2]+max(U)]+ temp/under) )^2
}
y[k]=sqrt(mean(a, na.rm=TRUE))
}    
plot(seq(1,100,1),y)

