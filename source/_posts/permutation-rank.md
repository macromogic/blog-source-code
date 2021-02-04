---
title: 线性代数复习：置换矩阵和“名次向量”
date: 2021-02-04 01:31:03
categories: Math
tags:
 - Notes
 - Math
mathjax: true
---

# 线性代数复习：置换矩阵和“名次向量”

没事瞎水博客系列……

在日常处理矩阵的时候，有时我们希望在不更改矩阵的前提下获知其每一行/列的字典序**“名次”（rank）**。MATLAB/NumPy分别提供了`sortrows`/`argsort`方法来获得一个**“索引向量”（index vector）**，表示排序后的矩阵的每一行/列对应原矩阵的行/列号。只需对索引向量再做一次排序，便可得到对应的**”名次向量“（rank vector）**。为了深入理解这个操作背后的原理，我参考了StackExchange上的[这篇回答](https://math.stackexchange.com/questions/3607762/why-does-sorting-twice-produce-a-rank-vector)。从他的证明过程中我发现了一个关键：排序前后两个矩阵的关系可以用**排列/置换（permutation）**来刻画。下面我将站在线性代数的视角来系统化解释一下“名次向量”背后的原理。

<!-- more -->

Rank在线性代数中本来指代矩阵的秩，但该单词同时也具备“名次”这个义项。“索引向量”和“名次向量”仅为英文直译结果，暂时还没有想到/发现更好的称呼。

## 置换和置换矩阵

在我的[这篇博客](https://blog.macromogic.xyz/2019/08/28/CPC-Polya/)中有简要提到**置换**这个概念。一般地，一个$n$阶的置换可以刻画成$\{1, 2, \dots, n\}$到自身的一个双射，这里记作$\sigma$。其映射图为：
$$
\begin{bmatrix}
1 & 2 & \cdots & n \\
\sigma(1) & \sigma(2) & \cdots & \sigma(n)
\end{bmatrix}
$$
写成矩阵的形式就是：
$$
P_\sigma = 
\begin{bmatrix}
\mathbf{e}_{\sigma(1)} & \mathbf{e}_{\sigma(2)} & \cdots &\mathbf{e}_{\sigma(n)}
\end{bmatrix}
$$
其中$P_\sigma$表示$\sigma$对应的**置换矩阵**，$\mathbf{e}_i$表示$\mathbb{R}^n$中第$i$个**正交基**，即只有第$i$个元素为$1$，其余均为$0$的列向量，$i = 1, 2, \dots, n$。

观察置换矩阵的构成，显然它是[正交](https://zh.wikipedia.org/wiki/正交矩阵)的，即有$P_\sigma^T = P_\sigma^{-1}$（矩阵的逆等于其转置）。同时，置换矩阵的转置也是置换矩阵。

所有$n$阶置换在复合运算上构成一个**置换群（$n$次[对称群](https://zh.wikipedia.org/wiki/对称群_(n次对称群))）**。

## 置换和排序

矩阵按行/列排序，本质上可以视作一个行/列变换。下面仅讨论矩阵的列变换。

令$M$为一$m \times n$矩阵，$M^{(s)}$为其列排序后的结果，则该排序过程可以视作在列向量上的一个置换作用。即，存在一个$n$阶置换$\sigma$使得$M^{(s)} = M \cdot P_\sigma$。若我们事先已知$M$的列的大小关系，并按从小到大顺序赋值$1, 2, \dots, n$，则可以得到一个行向量$\mathbf{r}_M$，记作$M$的**“名次向量”**。显然我们有：
$$
\mathbf{r}_M \cdot P_\sigma = 
\begin{bmatrix}
1 & 2 & \cdots & n
\end{bmatrix}
$$
即：
$$
\mathbf{r}_M = 
\begin{bmatrix}
\sigma^{-1}(1) & \sigma^{-1}(2) & \cdots & \sigma^{-1}(n)
\end{bmatrix}
$$
由于$\forall 1 \leq i, j \leq n,\ M^{(s)}_{i, j} = M_{i, \sigma(j)}$，其中$M_{i, j}$代表矩阵$M$第$i$行第$j$列的元素，我们记$\mathbf{i}_M$为$M$的**“索引向量”**，其值为：
$$
\begin{align*}
\mathbf{i}_M &=
\begin{bmatrix}
1 & 2 & \cdots & n
\end{bmatrix}
\cdot P_\sigma \\
&=
\begin{bmatrix}
\sigma(1) & \sigma(2) & \cdots & \sigma(n)
\end{bmatrix}
\end{align*}
$$

## 从“索引”到“名次”

现在对$\mathbf{i}_M$进行排序，其对应的置换记作$\pi$，则有：
$$
\mathbf{i}_M \cdot P_\pi = 
\begin{bmatrix}
1 & 2 & \cdots & n
\end{bmatrix}
$$
又因为：
$$
\mathbf{r}_{\mathbf{i}_M} \cdot P_\pi = 
\begin{bmatrix}
1 & 2 & \cdots & n
\end{bmatrix}
$$
所以有：
$$
\begin{align*}
\mathbf{i}_M &= \mathbf{r}_{\mathbf{i}_M} \\
\begin{bmatrix}
\sigma(1) & \sigma(2) & \cdots & \sigma(n)
\end{bmatrix} &= 
\begin{bmatrix}
\pi^{-1}(1) & \pi^{-1}(2) & \cdots & \pi^{-1}(n)
\end{bmatrix}
\end{align*}
$$
因此$\sigma = \pi^{-1}$，即$\sigma$和$\pi$互逆，于是有：
$$
\begin{align*}
\mathbf{i}_{\mathbf{i}_M} &= 
\begin{bmatrix}
\pi(1) & \pi(2) & \cdots & \pi(n)
\end{bmatrix} \\
&=
\begin{bmatrix}
\sigma^{-1}(1) & \sigma^{-1}(2) & \cdots & \sigma^{-1}(n)
\end{bmatrix} \\
&= \mathbf{r}_M
\end{align*}
$$
自此，我们证明了*“索引向量的索引向量为原矩阵的名次向量”*这一命题。