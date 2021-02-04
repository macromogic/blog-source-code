---
title: CPC算法笔记——中国剩余定理
date: 2019-08-22 16:59:31
categories: Math
tags:
 - Math
 - CPC
 - Notes
mathjax: true
---

中国剩余定理可用于解一元线性方程组：
$$
\begin{cases}
x \equiv a_1 \pmod {m_1} \\
x \equiv a_2 \pmod {m_2} \\
\quad \vdots \\
x \equiv a_n \pmod {m_n}
\end{cases}
$$

<!-- more -->

## 模数两两互质的情形

令$M = \prod\limits_{i=1}^{n} m_i,\ M_i = \frac{M}{m_i},\ t_i = M_i^{-1}$（模$m_i$意义下），则可构造通解：
$$
x_S = \sum_{i=1}^{n} a_it_iM_i + kM,\ k \in \mathbb{Z}
$$
**证明**

由假设，$\forall j \in \{1, 2, \dots, n\},\ \gcd(m_i, M_i) = 1$，则由Bezout定理可推知，$\exists t_i \text{ s.t. } t_iM_i \equiv 1 \pmod {m_i}$，即$M_i$存在模$m_i$意义下的数论倒数$t_i$。

考虑乘积$a_it_iM_i$可知：$a_it_iM_i \equiv a_i \pmod {m_i};\ $$a_jt_jM_j \equiv 0 \pmod {m_i}, $$\forall j \in \{1, 2, \dots, n\}, j \neq i$，所以令$x = \sum\limits_{i=1}^{n} a_it_iM_i$，则有$x \equiv a_i \pmod {m_i}, \forall i \in \{1, 2, \dots, n\}$。

假设$x_1, x_2$为该方程的两个解，由于模数两两互质，有$M \mid (x_1-x_2)$，即任意两个整数解必然相差$M$的整数倍，故解集为$\{\sum\limits_{i=1}^{n} a_it_iM_i + kM \mid k \in \mathbb{Z}\}$。


## 模数不两两互质的情形

### 方法一：转化为模数互质[<sup>[1]</sup>](#refer-1)

先提出以下引理：

**引理1** 方程组有解的充要条件是$\forall i, j \in \{1, 2, \dots, n\}, i \neq j,\ $$\gcd(m_i, m_j) \mid (b_i-b_j)$。

**证明**

考虑将
$$
\begin{cases}
x \equiv a_1 \pmod {m_1} \\
x \equiv a_2 \pmod {m_2}
\end{cases}
$$
转化为不定方程组：
$$
\begin{cases}
x = pm_1 + a_1 \\
x = qm_2 + a_2
\end{cases}
$$
两式相减得：
$$
pm_1 - qm_2 = a_1 - a_2
$$
若方程有解，由Bezout定理知，$\gcd(m_i, m_j) \mid (a_i - a_j)$，以此类推可证必要性。充分性同理。

**引理2** 设$m$为正整数，对其质因数分解得$m = \prod\limits_{i=1}^{\alpha} p_i^{e_i}$，则方程$x \equiv a \pmod m$等价于方程组
$$
\begin{cases}
x \equiv a \pmod {p_1^{e_1}} \\
x \equiv a \pmod {p_2^{e_2}} \\
\quad \vdots \\
x \equiv a \pmod {p_\alpha^{e_\alpha}}
\end{cases}
$$
**结论显然，证明略**

**引理3** 设$p$为质数，$\alpha \geq \beta$，则方程组
$$
\begin{cases}
x \equiv a_1 \pmod {p^\alpha} \\
x \equiv a_2 \pmod {p^\beta}
\end{cases}
$$
的解就是方程$x \equiv a_1 \pmod {p^\alpha}$的解，即在有解的条件下二者等价。

**证明**

若方程组有解，则$\exists k, l$使得：
$$
\begin{align*}
x = a_1 + kp^\alpha &= a_1 + (kp^{\alpha-\beta})p^\beta \\
&= a_2 + lp^\beta
\end{align*}
$$
即
$$
a_1 \equiv a_2 \pmod p
$$
故原方程组可写成：
$$
\begin{cases}
x \equiv a_1 \pmod {p^\alpha} \\
x \equiv a_1 \pmod {p^\beta}
\end{cases}
$$
该方程组的解显然是$x \equiv a_1 \pmod {p^\alpha}$的解，即二者等价。

------

利用以上三个引理，可以将原方程组转化为模数为素数乘方的方程组，若不存在矛盾的方程，则可用中国剩余定理求解。

### 方法二：两两合并法

由**引理1**的证明，若方程组有解，对前两个方程，可由扩展Euclid算法解得$p, q$使得$pm_1 - qm_2 = a_1 - a_2$，则两个方程等价于
$$
x \equiv pm_1+a_1 \pmod {\mathrm{lcm}(m_1, m_2)}
$$
或
$$
x \equiv qm_2+a_2 \pmod {\mathrm{lcm}(m_1, m_2)}
$$
以此类推。

## 参考文献

<div id="refer-1">[1]<a href="http://www.cnki.com.cn/Article/CJFDTotal-GLKX201003013.htm">刘古胜,徐东星,余畅.推广的孙子定理[J].高师理科学刊,2010,30(03):26-28. </a></div>

