---
title: 算法复习笔记：网络流
date: 2020-08-11 23:16:49
categories: Algorithm
tags:
 - Notes
 - Math
mathjax: true
---

# 算法复习笔记：网络流

龟速补上欠下的账ing……$\DeclareMathOperator{\capa}{cap}$

写完发现读着好晦涩，但数学不就是这样的吗🌚

## 基本概念/符号表示

为了方便下文叙述，现做如下规定/定义：

$G = (V, E)$是有向、无平行边的图，每条边边权为正，其中有一个**源点（source）**$s$和**汇（sink）点**$t$满足：没有一条边以$t$为起点，或以$s$为终点。

对某边$e \in E$，记该边边权为$c(e)$。

<!-- more -->

若某点集$A \subseteq V$，规定$E_A^- = (A \times (V \setminus A)) \cap E, E_A^+ = ((V \setminus A) \times A) \cap E$，即$E_A^-, E_A^+$分别表示**“离开$A$”**和**“到达$A$”**的边集。相似地，对于某一节点$v \in V$，记$E_v^- = (\{v\} \times (V \setminus \{v\})) \cap E, E_v^+ = ((V \setminus \{v\}) \times \{v\}) \cap E$。

$A \sqcup B$表示两个集合$A, B$的**不交并**。

若两个点集$A, B \subseteq V$满足$V = A \sqcup B$，且有：$u \in A, v \in B$以及子图$G_A=(A, (A \times A) \cap E), G_B = (B, (B \times B) \cap E)$分别连通，则称$(A, B)$为$G$的**割（cut）**（或**$s$-$t$割**）。

（用通俗语言描述就是将$G$一刀“砍”成两半，其中$s$和$t$不在同一边）

一个割的**容量（capacity）**定义为：$\capa(A, B) = \sum_{e \in E_A^-}c(e)$。

**最小割问题（Minimum Cut Problem）**：求网络流图$G$容量最小的$s$-$t$割。

若一个函数$f: E \rightarrow \mathbb{R}$满足：

- $\forall e \in E,\ 0 \leq f(e) \leq c(e)$，其中$c(e)$又称该边的**容量（capacity）**；

- $\forall v \in V \setminus \{s, t\},\ \sum_{e \in E_v^+} f(e) = \sum_{e \in E_v^-} f(e)$（**流量守恒，Flow Conservation**）

  称$f$为网络流图$G$的一个**流（flow）**。其**流量（flow value）**定义为$v(f) = \sum_{e \in E_s^-} f(e)$。

**最大流问题（Maximum Flow Problem）**：求网络流图$G$流量最大的流。

## 「流」和「割」

下面尝试说明：最大流问题和最小割问题是等价的。

首先引出**流量引理（Flow Value Lemma）**：对于任一流$f$和任一$s$-$t$割$(A, B)$，从$A$流向$B$的总流量等于离开$s$的总流量，即：
$$
\sum_{e \in E_A^-} f(e) - \sum_{e \in E_A^+} f(e) = v(f)
$$
*证明*：由流量守恒：
$$
\begin{align*}
v(f) &= \sum_{e \in E_s^-} f(e) \\
&= \sum_{v \in A} \left( \sum_{e \in E_v^-} f(e) - \sum_{e \in E_v^+} f(e) \right) \\
&= \sum_{e \in E_A^-} f(e) - \sum_{e \in E_A^+} f(e)
\end{align*}
$$
由该引理，可以得出流和割的**弱对偶性（Weak Duality）**：对于任一流$f$和任一$s$-$t$割$(A, B)$，$f$的流量$v(f)$至多等于$(A, B)$的容量$\capa(A, B)$。

*证明*：
$$
\begin{align*}
v(f) &=  \sum_{e \in E_A^-} f(e) - \sum_{e \in E_A^+} f(e) \\
&\leq \sum_{e \in E_A^-} f(e) \\
&\leq \sum_{e \in E_A^-} c(e) \\
&= \capa(A, B)
\end{align*}
$$
*引理*：若存在流$f$和割$(A, B)$使得$v(f) = \capa(A, B)$，则$f$是一个最大流，而$(A, B)$是一个最小割。

对于一张网络流图$G$，若已存在一个流$f$，我们希望获知是否能对这个流进行修改，比如更改某一条边的流量或发送一条从$s$到$t$的新流。因此我们需要一张新图$G_f = (V, E_f)$来刻画这个流之外“剩下”的状态，其中$G_f$和$E_f$分别称作**剩余图（residual graph）**和**剩余边集（set of residual edges）**。

若$e = (u, v) \in E$，则它对应的**剩余边（residual edge）**为$e$本身以及其反向边$e^R = (v, u)$。这两条边的容量（用$c_f$表示）分别为：
$$
\begin{align*}
c_f(e) &= c(e) - f(e) \\
c_f(e^R) &= f(e)
\end{align*}
$$
为保证剩余图依然是一张网络流图，规定$e$或$e^R$在$E_f$中当且仅当其容量非零。即：
$$
E_f = \{e \in E \mid f(e) < c(e)\} \cup \{e^R \mid e \in E, f(e) > 0 \}
$$
若$s, t$在$G_f$中依然连通，连接这两个节点的简单路径称为**增广路径（augmenting path）**或**增广路**。增广路上最小的剩余边容量称为**瓶颈容量（bottleneck capacity）**，记作$c_b(G_f, p)$。若$f$是$G$上的一个流，而$p$是$G_f$上一条增广路，那么将$p$加入（augment to）$f$中得到$f’$，有$v(f’) = v(f)+c_b(G_f, p)$。这条性质称作增广路的**主要特性（Key Property）**。一般地，若$f$是$G$上的一个流，而$g$是$G_f$上的一个流，那么$f+g$是$G$上的一个流，其中$v(f+g) = v(f) + v(g)$，对任意$e \in E$，有$(f+g)(e) = f(e) + g(e) - g(e^R)$。

## 最大流最小割定理

由增广路径的主要特性，我们可以获得一个基本的求最大流的思路：

> 若剩余图中仍存在增广路径，则沿这条路径发送一个流（即加入到已求的流中），重复执行这个步骤直到增广路径不存在。

这个思路称作**Ford-Fulkerson方法**。该方法的正确性由**增广路定理（Augmenting Path Theorem）**得到：流$f$是最大流当且仅当剩余图中不存在增广路。

此外，由上述提到的弱对偶性，我们自然地想到：一张图的最大流等于最小割。这就是**最大流最小割定理（Max-flow Min-cut Theorem）**的内容。下面对这两个定理进行证明。

要证明上述定理，只需说明以下三个命题互相等价：

- $a)$ 存在一个割$(A, B)$使得$v(f) = \capa(A, B)$
- $b)$ 流$f$是最大流
- $c)$ $f$对应的剩余图$G_f$中不存在增广路

*证明*：

$a) \Rightarrow b)$ 由「弱对偶性」的推论得出（任一流的流量小于等于任一割的容量，则等于割容量的流为最大流）。

$b) \Rightarrow c)$ 只需证明其逆否命题。若$G_f$中存在增广路$p$，由增广路的主要特性，可构造$f'$使得$v(f’) = v(f) + c_b(G_f, p) > v(f)$，因此$f$不是最大流。

$c) \Rightarrow a)$ 假设$f$对应的剩余图$G_f$中不存在增广路，令$A$为$s$在$G_f$中能到达的点的集合，$B = V \setminus A$，显然有$s \in A, t \in B$。由假设知，$G_f$不存在“离开$A$”的边，因此有$\forall e \in E_A^-, f(e) = c(e)$以及$\forall e \in E_A^+, f(e) = 0$（否则会产生“离开$A$”的剩余边，和假设矛盾）。于是由流量引理有：
$$
\begin{align*}
v(f) &= \sum_{e \in E_A^-} f(e) - \sum_{e \in E_A^+} f(e) \\
&= \sum_{e \in E_A^-} c(e) \\
&= \capa(A, B)
\end{align*}
$$
至此，增广路定理和最大流最小割定理都能得到证明。

## Ford-Fulkerson的实现

下面假定所有边容量均为$\left[1, \sum_{e \in E_s^-} c(e)\right]$内的正整数，且满足每条边的流量和剩余边容量均为正整数（整性不变性）。

（如果允许边的容量为无理数，无法证明Ford-Fulkerson算法能在有限时间内停止，或得到实际的最大流。[维基百科](https://zh.wikipedia.org/wiki/Ford–Fulkerson算法#无法终止算法的样例)上给出了该情形下的一个反例。）

由于每次流量至少增加$1$，不难证明Ford-Fulkerson方法能在至多$v(f^*) \leq C$次迭代内结束，其中$f^*$为最大流，$C$为某一正整数（**有穷性**）。

*推论*：若$C = 1$，则Ford-Fulkerson运行时间为$\mathrm{O}(mn)$，其中$m = |E|, n = |V|$。BFS遍历时间为$\mathrm{O}(m+n)$，添加增广路耗时$\mathrm{O}(n)$。

由整性不变性和增广路定理，不难证明：若网络流图中每条边权均为正整数，则存在一个最大流满足每条边的流量均为正整数。

现在讨论如何找到增广路并快速求出最大流。

### “容量缩放”（Capacity-Scaling）法

要想提高寻找增广路并且求得最大流的效率，一个直观的思路就是找到尽可能“_短且胖_”（即遍数少、瓶颈容量大）的增广路径。

首先，对于某一容量$\Delta$，令$G_f(\Delta)$表示剩余图中边容量不小于$\Delta$的部分，即$G_f(\Delta) = (V, E_f(\Delta))$，其中$E_f(\Delta) = \{e \in E_f \mid c_f(e) \geq \Delta\}$。观察到：$G_f(\Delta)$中任一增广路的容量一定大于等于$\Delta$，因而我们可以维护这个$\Delta$（称为**缩放因子，scaling parameter**），当$G_f(\Delta)$中不存在增广路时缩小$\Delta$值，直到$\Delta$为$1$为止，此时得到的流就是我们要求的最大流（$G_f(1)$不存在增广路等价于$G_f$不存在增广路，则由**增广路定理**显然可得）。

现实中，为提高运行效率，一般令$\Delta$初值为**不超过$\max_{e \in E_s^-}\{c(e)\}$的**最大的$2$的幂，每次缩放时将$\Delta$减半，则$\Delta$始终为$2$的某一次方，显然也满足上文提到的**整性不变性**。

下面提出三个引理：

*引理1*：该方法中有$1+\left\lfloor \log_2 C \right\rfloor$次迭代，其中$C$为上文**有穷性**处提到的迭代上界。

*证明*：由题目假设，显然有$\Delta \leq \max_{e \in E_s^-}\{c(e)\} \leq v(f^*) \leq C$，则缩放阶段数为$1+\left\lfloor \log_2 \Delta \right\rfloor \leq 1+\left\lfloor \log_2 C \right\rfloor$。

*引理2*：令$f$为一次迭代结束时的流（即，此时$G_f(\Delta)$不存在增广路），则$v(f^*) \leq v(f) + m\Delta$。

*证明*：我们只需证明：此时存在一个割$(A, B)$使得$\capa(A, B) \leq v(f) + m\Delta$。令$A$为$s$在$G_f(\Delta)$中能到达的点的集合，$B = V \setminus A$，则和之前证明类似地，有：
$$
\begin{align*}
v(f) &= \sum_{e \in E_A^-} f(e) - \sum_{e \in E_A^+} f(e) \\
&\geq \sum_{e \in E_A^-} \left( c(e) - \Delta \right) - \sum_{e \in E_A^+} \Delta \\
&\geq \sum_{e \in E_A^-} c(e) - m\Delta \\
&= \capa(A, B) - m\Delta
\end{align*}
$$
对第一个不等号的推导稍作解释：由假设知，$G_f$中不存在容量大于等于$\Delta$的增广路；更精确地说，$G_f$中离开$A$的剩余边权值均小于$\Delta$。因此有$\forall e \in E_A^-,\ f(e) \geq c(e) - \Delta$以及$\forall e \in E_A^+,\ f(e) \leq \Delta$。

*引理3*：每一次迭代最多加入$2m$条增广路。

*证明*：令$f$为某一次迭代开始时的流，由*引理2*有：$v(f^*) \leq v(f) + m \cdot 2\Delta$，又由算法知，每次增加的流量大小为$\Delta$，显然可得。

由上述三条引理知，该算法的时间复杂度为$\mathrm{O}(m^2\log C)$，其中一共加入$\mathrm{O}(m\log C)$条增广路，搜索每条增广路（BFS）需要$\mathrm{O}(m)$的时间。

### Edmonds–Karp/Dinic算法

Edmonds–Karp/Dinic算法思路和Ford-Fulkerson一样，不过时间复杂度可以优化至$\mathrm{O}(n^2m)$。该算法的思想是：**每次用BFS寻找一条增广路，并沿该路径发送一条大小为其瓶颈容量的流；重复该过程直到$s$和$t$不连通**。算法有穷性和正确性略去不证，下面对时间复杂度进行简单说明。

由BFS的性质，每次找到的增广路均为当前剩余图中最短的，且一次迭代的时间复杂度为$\mathrm{O}(mn)$（由Ford-Fulkerson有穷性推论）。又因为每次发送的流大小为增广路的瓶颈容量，则至少有一条剩余边被“填满”。因此下一条搜索到该边时路径长度一定大于此次迭代的路径，且不超过$n$。由上述可知每次找到的最短增广路长度是单调递增的，迭代次数为$\mathrm{O}(n)$。因此总时间复杂度为$\mathrm{O}(n^2m)$。

该算法还可以进一步优化（称为**ISAP**）。此外还存在一个忽略流守恒性、从比较“物理”的角度来求解的**预留推进算法**。请参阅[OI Wiki](https://oi-wiki.org/graph/flow/max-flow)。

