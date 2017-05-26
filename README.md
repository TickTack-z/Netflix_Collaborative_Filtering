Collaborative Filtering for Netflix Prize  
===================================  
  大标题一般显示工程名,类似html的\<h1\><br />  
  你只要在标题下面跟上=====即可  
  
    

    
### Baseline  

The baseline estimator where we use the average rating (across all ratings in the training data), ![](http://latex.codecogs.com/gif.latex?\\bar{x}), as our estimator 3.5238 , with test error 1.1220.

### Baseline with bias
Now construct biases for each movie and user according to

![](http://latex.codecogs.com/gif.latex?b_i:=\\frac{\sum_ux_{ui}}{M_i}-\bar{x})

![](http://latex.codecogs.com/gif.latex?b_u:=\\frac{\sum_ix_{ui}}{M_u}-\bar{x})

where Mi = # users that rated movie i and Mu = # movies rated by user u. The new baseline estimator is 

![](http://latex.codecogs.com/gif.latex?x_{ui}=\bar{x}+b_u+b_i.)
### 单行文本框  
    这是一个单行的文本框,只要两个Tab再输入文字即可  
          
### 多行文本框    
    这是一个有多行的文本框  
    你可以写入代码等,每行文字只要输入两个Tab再输入文字即可  
    这里你可以输入一段代码  
  
### 比如我们可以在多行文本框里输入一段代码,来一个Java版本的HelloWorld吧  
    public class HelloWorld {  
  
      /**  
      * @param args  
   */  
   public static void main(String[] args) {  
   System.out.println("HelloWorld!");  
  
   }  
  
    }  
### 链接  
1.[点击这里你可以链接到www.google.com](http://www.google.com)<br />  
2.[点击这里我你可以链接到我的博客](http://guoyunsky.iteye.com)<br />  
  
###只是显示图片  
![github](http://github.com/unicorn.png "github")  
![baidu](http://www.baidu.com/img/bdlogo.gif "百度logo")  
###想点击某个图片进入一个网页,比如我想点击github的icorn然后再进入www.github.com  
[![image]](http://www.github.com/)  
[image]: http://github.com/github.png "github"  
  
### 文字被些字符包围  
> 文字被些字符包围  
>  
> 只要再文字前面加上>空格即可  
>  
> 如果你要换行的话,新起一行,输入>空格即可,后面不接文字  
> 但> 只能放在行首才有效  
  
### 文字被些字符包围,多重包围  
> 文字被些字符包围开始  
>  
> > 只要再文字前面加上>空格即可  
>  
>  > > 如果你要换行的话,新起一行,输入>空格即可,后面不接文字  
>  
> > > > 但> 只能放在行首才有效  
  
### 特殊字符处理  
有一些特殊字符如<,#等,只要在特殊字符前面加上转义字符\即可<br />  
你想换行的话其实可以直接用html标签\<br /\>  
