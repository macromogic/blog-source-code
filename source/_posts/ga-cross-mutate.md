---
title: 遗传算法中经典的交叉/变异算子
date: 2021-02-09 00:21:43
categories: Algorithm
tags:
 - Notes
 - EMO
 - Algorithm
mathjax: true
---

# 遗传算法中经典的交叉/变异算子

在遗传算法中，如何从亲代中产生好的子代个体是至关重要的问题。本文将收录一些经典的、但理解起来略有难度的交叉和变异算子（Crossover and mutation operators），并简要叙述一下其背后的原理。

本文中各种算子的中文名称均为个人直译结果，不代表学术界公认译名（本来也基本没有……）。

<!-- more -->

## 模拟01交叉

**模拟01交叉（Simulated Binary Crossover, SBX）**将01编码的交叉思想拓展到了实数编码的问题上来。首先我们来重新观察01编码下的单点交叉：给定两个亲代个体$x_1, x_2$，我们可以写成$n$位二进制表达形式：
$$
\begin{align*}
x_1 &= a_{n-1} \cdot 2^{n-1} + a_{n-2} \cdot 2^{n-2} + \dots + a_1 \cdot 2 + a_0 \\
x_2 &= b_{n-1} \cdot 2^{n-1} + b_{n-2} \cdot 2^{n-2} + \dots + b_1 \cdot 2 + b_0
\end{align*}
$$
设交叉发生在第$k$位，则上式可以简写成：
$$
\begin{align*}
x_1 &= A_1 \cdot 2^k + A_0 \\
x_2 &= B_1 \cdot 2^k + B_0
\end{align*}
$$
由这两个个体，我们可以得到两个子代个体：
$$
\begin{align*}
y_1 &= A_1 \cdot 2^k + B_0 \\
y_2 &= B_1 \cdot 2^k + A_0
\end{align*}
$$
观察这两组式子，不难发现$(x_1 + x_2) / 2 = (y_1 + y_2) / 2$，即亲代和子代都关于某一中心点等距。为了量化交叉过程中的距离变化关系，我们引入一个概念——**扩张因子（Spread factor）$\beta$**。它的定义式为：
$$
\beta = \left|\frac{y_1 - y_2}{x_1 - x_2}\right|
$$
当$0 \leq \beta < 1$时，我们称该交叉是**收缩的（Contracting）**；当$\beta > 1$时，称该交叉为**扩张的（Expanding）**；当$\beta = 1$时，称该交叉为**稳定的（Stationary）**。在[这篇论文](https://wpmedia.wolfram.com/uploads/sites/13/2018/02/09-2-2.pdf)中，作者讨论并推广了极端情况下（亲代为全0和全1）交叉点的位置$k$满足某一扩张因子$\beta$的概率密度函数。令收缩情形下和扩张情形下的概率密度函数分别为$\mathcal{C}(\beta)$和$\mathcal{E}(\beta)$，函数在各自定义域上的积分均为0.5。作者给出了两个函数的形式和以下关系式：
$$
\mathcal{E}(\beta) = \frac{1}{\beta^2}\mathcal{C}(\frac{1}{\beta})
$$
在实数域上，要想达成模拟01交叉的特点，我们首先要讲实数和01串建立联系。假设存在这样一个线性映射：
$$
\begin{align*}
p_i &= mx_i + t \\
c_i &= my_i + t
\end{align*}
$$
我们可以利用该映射将原本01编码的亲代$x_1, x_2$和子代$y_1, y_2$映射成实数$p_1, p_2$以及$c_1, c_2$。由该映射的线性性，扩张因子这个概念可以很自然地推广到实数编码上。因此我们可以用下式来进行交叉操作：
$$
\begin{align*}
c_1 &= 0.5[(1 + \beta) p_1 + (1 - \beta) p_2] \\
c_2 &= 0.5[(1 - \beta) p_1 + (1 + \beta) p_2]
\end{align*}
$$
不难验证该交叉满足式中的扩张因子$\beta$。$\beta$的分布由以下式子来模拟，详细不在这里赘述了：
$$
\mathcal{P}(\beta) = \begin{cases}
0.5(\eta_c + 1)\beta^{\eta_c},& 0 \leq \beta \leq 1 \\
0.5(\eta_c + 1)\beta^{-(\eta_c + 2)},& \beta > 1
\end{cases}
$$
其中$\eta_c$称为**分布指数（Distribution index）**。$\eta_c$越大，$\mathcal{P}(\beta)$在$\beta = 1$处的取值就越大，交叉得到的子代也就离亲代越近。在实际运行中，获取$\beta$的途径是给定一个随机数$u \in [0, 1]$，然后从上述分布中求得$u$分位点作为当前（扩张因子对应的）算子。

## 顺序交叉

**顺序交叉（Order Crossover, OX）**适用于邮差问题等以排列的形式编码的问题。它的特性是在交叉两个排列的同时保持两个片段在各自亲代中的顺序。以单点交叉举例，假设两亲代是`[1, 2, 3, 4, 5, 6]`和`[5, 6, 3, 2, 4, 1]`，在下标3处交叉的结果则为`[1, 2, 3, 5, 6, 4]`和`[5, 6, 3, 1, 2, 4]`。

推广到两点交叉的情形，使用Python实现的代码如下：

``` python
import random

def ox(xa, xb):
    d = len(xa)
    c1, c2 = random.sample(range(d), 2)
    if c1 > c2:
        c1, c2 = c2, c1
        
    u = xa[:]
    for j in range(c1, c2):
        h = 0
        while xb[j] != u[h]:
            h = (h + 1) % d
        l = (h + 1) % d
        while l != c2:
            u[h] = u[l]
            h = (h + 1) % d
            l = (l + 1) % d
    for j in range(c1, c2):
        u[j] = xb[j]
        
    return u
```

简要分析一下，上述代码将$\mathbf{x}^b$中下标范围在$[c_1, c_2)$里的部分替换到$\mathbf{x}^a$中得到子代$\mathbf{u}$。要理解第一个for循环的功能，我们首先把这个序列看成一个循环序列。初始化阶段，令$\mathbf{u} = \mathbf{x}^a$。对$[c_1, c_2)$里的每个下标$j$，首先在$\mathbf{u}$中找到$x_j^b$出现的下标$h$，然后对$[h, c_2)$这个区间内的元素做一次“左移”。为了方便理解，我们可以认为此处进行了一次“循环左移”，使得$x_j^b$这个元素被移动至$c_2-1$这个位置。如此循环操作后，$\mathbf{x}^b$中下标范围不在$[c_1, c_2)$里的部分在$\mathbf{u}$中对应的下标都不在$[c_1, c_2)$里。此时我们只需将$\mathbf{x}^b$中对应的元素复制进$\mathbf{u}$中即可。

---

下面的内容等看完相关文献再补上……

## 多项式变异

**多项式变异（Polynomial Mutation）**和SBX一样，适用于实数形式编码的问题。

## 差分进化中的交叉算子

**差分进化（Differential Evolution, DE）**算法依靠两个个体的差值和另一选出来的个体组合来搜索新的解。