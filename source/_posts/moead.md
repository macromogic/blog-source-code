---
title: 演化多目标优化：基于分解思想的经典算法MOEA/D
date: 2021-02-18 12:56:31
categories: EMO
tags:
 - Notes
 - EMO
mathjax: true
---

# 演化多目标优化：基于分解思想的经典算法MOEA/D

## 前言

在多目标优化问题中，基于帕累托支配关系的最优解集（即帕累托前，PF）很可能不是有限的集合；多数情况下可能是高维空间中某一区域。因此，优化算法的目标就是在有限时间里得到一个能够表现出PF的形状、且分布良好的解集。这也是为什么收敛性和多样性在演化多目标优化算法中是两大重要指标。经典的基于支配关系的算法框架（如[NSGA-II](https://blog.macromogic.xyz/2021/02/05/nsga-ii/)等）依靠适应值来维护解集的多样性，避免边缘解的丢失以及解过于密集的现象。而MOEA/D的提出，将分解的思想重新带入了演化多目标优化的领域来。

<!-- more -->

## 常见分解方法

分解思想的核心是将一个多目标问题转化成一系列单目标问题来同时优化。这其中涉及到各种标量化的方法，如**加权求和（Weighted Sum）法**、**Tchebycheff法**、**边界交点（Boundary Intersection, BI）法**等。加权求和的思想很简单，假设原目标函数为$\mathbf{F} = (F_1, F_2, \dots, F_n)^T$，给定一个权重向量$\boldsymbol{\lambda} = (\lambda_1, \lambda_2, \dots, \lambda_n)^T$，其中$\forall i = 1, 2, \dots, n,\ \lambda_i \geq 0$且$\sum_{i=1}^n \lambda_i = 1$，则新的目标函数为该解各个分量的加权和，即：
$$
g^{\mathrm{ws}}(\mathbf{x} \mid \boldsymbol{\lambda}) = \sum_{i=1}^n\lambda_iF_i(\mathbf{x})
$$
Tchebycheff法基于一个参考向量$\mathbf{z}$和一个权重向量$\boldsymbol{\lambda}$，其中$\mathbf{z}$每个分量为决策空间中对应分量上的最值。对应的目标函数为该解到$\mathbf{z}$的“加权Tchebycheff距离”，即：
$$
g^{\mathrm{te}}(\mathbf{x} \mid \boldsymbol{\lambda}, \mathbf{z}) = \max_{1 \leq i \leq n} \{ \lambda_i \left\lvert F_i(\mathbf{x}) - z_i \right\rvert \}
$$
BI法同样需要参考向量$\mathbf{z}$和权重向量$\boldsymbol{\lambda}$，其目的是尽可能将答案向$\mathbf{z}$的方向“拉拽”，因而对应的目标函数为：
$$
\begin{align*}
g^{\mathrm{bi}}(\mathbf{x} \mid \boldsymbol{\lambda}, \mathbf{z}) &= d \\
\text{s.t. }\ \ \qquad \mathbf{z} - \mathbf{F}(\mathbf{x}) &= d\boldsymbol{\lambda}
\end{align*}
$$
BI法的一个缺陷在于$\mathbf{F}(\mathbf{x}), \mathbf{z}, \boldsymbol{\lambda}$需要满足上式中的共线条件；而该约束在多数情形下难以维护。因此，我们可以考虑引入一个带**惩罚参数（Penalty parameter）$\theta$**的版本，即：
$$
g^{\mathrm{pbi}}(\mathbf{x} \mid \boldsymbol{\lambda}, \mathbf{z}) = d_1 + \theta d_2
$$
其中$d_1, d_2$分别表示$\mathbf{F}(\mathbf{x})$和$\mathbf{z}$的距离在$\boldsymbol{\lambda}$上的投影、以及$\mathbf{F}(\mathbf{x})$到$\boldsymbol{\lambda}$所在直线的距离：
$$
\begin{align*}
d_1 &= \frac{\left\lVert (\mathbf{z} - \mathbf{F}(\mathbf{x}))^T \boldsymbol{\lambda} \right\rVert}{\left\lVert \boldsymbol{\lambda} \right\rVert} \\
d_2 &= \left\lVert \mathbf{F}(\mathbf{x}) - (\mathbf{z} - d_1\boldsymbol{\lambda}) \right\rVert
\end{align*}
$$
该方法也被称作**广义BI法**、或者**PBI（Penalty-based BI）法**。相比上述的Tchebycheff法，PBI法的优势在于它的分布更加均匀，且更能将支配解区分出来。

## MOEA/D主体框架

由上述叙述可知，基于分解思想的算法主要是将多目标问题转化成单目标问题来辅助解决，且最优解的位置高度依赖选取的权重向量。若我们选取多个权重向量，那么问题将会变成一系列相对独立的单目标问题，每个问题对应一个权重向量；且若权重向量的选取合理，最后得到的PF也是良好分布的。

初始化阶段，在选取完一系列权重向量$\boldsymbol{\lambda}^{(1)}, \boldsymbol{\lambda}^{(2)}, \dots, \boldsymbol{\lambda}^{(N)}$后，我们首先找到每个权重向量的$T$个“近邻”，其中第$i$个权重向量$\boldsymbol{\lambda}^{(i)}$的近邻对应的下标集合记作$B^{(i)}$，对应问题的答案记为$\mathbf{x}^{(i)}$。在演化过程中，$\boldsymbol{\lambda}^{(i)}$对应的单目标问题的下一代个体由下标在$B^{(i)}$中的个体杂交产生，得到的新个体将被用于更新参考向量$\mathbf{z}$、该问题对应的答案$\mathbf{x}^{(i)}$以及“近邻向量”对应问题的答案$\mathbf{x}^{(j)}\ (j \in B^{(i)})$。整个问题的PF由一个独立的外部缓存维护。