Collaborative Filtering for Netflix Prize  
===================================  
    
### Baseline  

The baseline estimator where we use the average rating (across all ratings in the training data), ![](http://latex.codecogs.com/gif.latex?\\bar{x}), as our estimator 3.5238 , with test error 1.1220. (The sample ranged from 0 to 5.)

### Baseline with bias
Now construct biases for each movie and user according to

![](http://latex.codecogs.com/gif.latex?b_i:=\\frac{\sum_ux_{ui}}{M_i}-\bar{x})

![](http://latex.codecogs.com/gif.latex?b_u:=\\frac{\sum_ix_{ui}}{M_u}-\bar{x})

where Mi = # users that rated movie i and Mu = # movies rated by user u. The new baseline estimator is 

![](http://latex.codecogs.com/gif.latex?x_{ui}=\bar{x}+b_u+b_i)

The test error is 0.9919 in this case.

### Bias with Regularization 

now use regularization and validation on the test set to choose the biases. That is, solve

![](http://latex.codecogs.com/gif.latex?\\min_{b_i,b_u}\sum_{(u,i)}(x_{ui}-\hat{x_{ui}})^2+\lambda(\sum_ib_i^2+\sum_ub_u^2))

where the sum is over observations (u,i) in the training data and choose λ ≥ 0 to be that value which gives the best performance on the test set. Note that we are really using the test set as a validation set here.

This is an unconstrained concave optimization problem and the first order conditions will be sufficient to find the global optimum. these first order conditions (for user u and movie i) are:

![](http://latex.codecogs.com/gif.latex?b_u=\frac{\sum_{i:i~\text{rated}~\text{by}~u}\left(x_{\text{ui}}-b_i\right)-M_u\bar{x}}{\lambda+M_u})

![](http://latex.codecogs.com/gif.latex?b_i=\frac{\sum_{u:u~\text{rated}~i}\left(x_{ui}-b_u\right)-M_i\bar{x}}{\lambda+M_i})

The best λ we found is 3.9 via cross validation, with test error 0.9585.

### Consruct the residual matrix

Then we can use the estimator from above to construct a residual matrix

### Neighborhood Method

Now use a neighborhood method applied to the residual matrix to construct a new estimator of the form

![](http://latex.codecogs.com/gif.latex?\hat{x}^N_{ui}=\bar{x}+b_u+b_i+\frac{\sum_{j\in{L_i}}d_{ij}\tilde{x}_{uj}}{\sum_{j\in{L_i}}|d_{ij}|})

where Li denotes the neighborhood of movie i and the dij’s. We choose L, the size of a neighborhood, via validation on the test
set. We found the best L = 72, with test error 0.9446. 
