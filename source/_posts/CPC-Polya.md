---
title: CPC算法笔记——置换和Polya定理
date: 2019-08-28 15:05:02
tags: 
 - Math
 - CPC
 - Notes
categories: Math
mathjax: true
---

## 置换

**置换**即$[\![1, n]\!] \triangleq \{1, 2, \dots, n\}$到自身的1-1变换：$[\![1, n]\!] \rightarrow [\![1, n]\!]$

$p: i \rightarrow a_i, (a_i \neq a_j, i \neq j)$，

其中$a_1, a_2, \dots, a_n$是$[\![1, n]\!]$的一个**全排列**，

称此置换为$n$阶置换，记为：

$p=\pmatrix{1&2&\cdots&n\\a_1&a_2&\cdots&a_n}$

$n$阶置换共有$n!$个。

<!-- more -->

## 置换的乘法

定义$p_1p_2$表示**先做$p_1$的置换，再做$p_2$的置换**，如：

$p_1=\pmatrix{1&2&3&4\\3&1&2&4}, p_2=\pmatrix{1&2&3&4\\4&3&2&1}$

则

$p_1p_2=\pmatrix{1&2&3&4\\3&1&2&4}\cdot\pmatrix{1&2&3&4\\4&3&2&1}=\pmatrix{1&2&3&4\\3&1&2&4}\cdot\pmatrix{3&1&2&4\\2&4&3&1}=\pmatrix{1&2&3&4\\2&4&3&1}$

即

$p_1=\pmatrix{1&2&\cdots&n\\a_1&a_2&\cdots&a_n}$

$p_2=\pmatrix{1&2&\cdots&n\\b_1&b_2&\cdots&b_n}=\pmatrix{a_1&a_2&\cdots&a_n\\b_1(a_1)&b_2(a_2)&\cdots&c_n(a_n)}$

$\therefore p_1p_2=\pmatrix{1&2&\cdots&n\\b_1(a_1)&b_2(a_2)&\cdots&b_n(a_n)}$

## 置换群

$[\![1, n]\!]$上所有置换按上述乘法构成一个**群**，即满足**封闭性**、**结合律**、**有单位元** $p_1=\pmatrix{1&1&\cdots&1\\ 1&1&\cdots&1}$、**有逆元** $p^{-1}=\pmatrix{a_1&a_2&\cdots&a_n\\1&2&\cdots&n}$，我们称此群为**n个对象的对称群**，记为$S_n$。

$S_n$的任意一个子群称为**置换群**。

## Polya定理

设$\bar G$是n个对象的一个置换群，用m种颜色对这n个对象染色，则不同的染色方案数为：
$$
L=\frac{1}{|\overline G|}\sum_{i=1}^{g}m^{c(\overline{P_i})}
$$
其中$\overline G=\{\overline{P_1}, \overline{P_2}, \dots, \overline{P_g}\}$，$c(\overline{P_k})$为$\overline{P_k}$的循环节数。