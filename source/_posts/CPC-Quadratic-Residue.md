---
title: CPC算法笔记——二次剩余
date: 2019-09-19 08:45:41
categories: Math
tags: 
 - Math
 - CPC
 - Notes
mathjax: true
---

## 定义

一个整数$x$对另一个整数$p$的**二次剩余**，指$x^2$模$p$的余数。

我们称整数$d$为**模$p$的二次剩余**当且仅当$\exists x \in \mathbb{Z} \mbox{ s.t. } x^2 \equiv d \pmod p$；反之，称$d$为**模$p$的非二次剩余**。

上下文无歧义的情况下可以简称为**剩余**和**非剩余**。

<!-- more -->

## 素数的二次剩余

$p=2$时，显然每个整数都是$p$的二次剩余。下面仅讨论**奇素数**的情形：

首先观察到一个显然的结论：
$$
x^2 \equiv (p-x)^2 \pmod p
$$
因此，在$\mathbb{Z}/p\mathbb{Z}$中，模$p$的二次剩余一共有$\frac{p+1}{2}$个，分别是$0^2, 1^2, \dots, (\frac{p-1}{2})^2$。忽略$0$的情形，则模$p$的二次剩余和二次非剩余各有$\frac{p-1}{2}$个。

### Euler准则 / Euler判别法

**Euler准则**应用于判断整数$a$是否是素数$p$的二次剩余。

为方便叙述，先引入**Legendre符号**：
$$
\left( \frac{a}{p} \right) = 
\begin{cases}
0 ,&  a \equiv 0 \pmod p\\
1 ,&  a \not \equiv0 \pmod p,\ \exists x \mbox{ s.t. } x^2 \equiv a \pmod p \\
-1 ,& \nexists x \mbox{ s.t. } x^2 \equiv a \pmod p
\end{cases}
$$
Euler准则的内容是：对$\forall a \in \mathbb{Z}, p \nmid a$：
$$
\left( \frac{a}{p} \right) \equiv a^{\frac{p-1}{2}} \pmod p
$$
*证明待补充*

由Euler准则可得到以下**Legendre符号的性质**：

- $\left(\frac{\cdot}{p}\right)$是**完全积性函数**，即$\forall a, b \in \mathbb{Z},\ \left(\frac{ab}{p}\right) = \left(\frac{a}{p}\right)\left(\frac{b}{p}\right)$
- 若$a \equiv b \pmod p$，则$\left(\frac{a}{p}\right) = \left(\frac{b}{p}\right)$
- $\left(\frac{a^2}{p}\right) = 1$

由此知：

- 二次剩余的乘法逆元依然是二次剩余，非二次剩余的乘法逆元依然是非二次剩余；
- 两个二次剩余或者非二次剩余的乘积是二次剩余；
- 二次剩余和非二次剩余的乘积是非二次剩余。

### 二次互反律

对于两个奇素数$p$和$q$：
$$
\left({\frac{p}{q}}\right)\cdot \left({\frac{q}{p}}\right)=(-1)^{\frac{(p-1)(q-1)}{4}}
$$
该定律可以将模数较大的二次剩余判别问题转移成模数较小的情形。

下面两个性质称为**二次互反律的第一补充和第二补充**：
$$
\left(\frac{-1}{p}\right) = (-1)^{\frac{p-1}{2}} \equiv 
\begin{cases}
1,& p \equiv 1 \pmod 4 \\
-1,& p \equiv 3 \pmod 4
\end{cases} \\
\left(\frac{2}{p}\right) = (-1)^{\frac{p^2-1}{8}} \equiv 
\begin{cases}
1,& p \equiv 1 \mbox{ or } 7 \pmod 8 \\
-1,& p \equiv 3 \mbox{ or } 5 \pmod 8
\end{cases}
$$
对奇素数$p$，还有以下结论：
$$
\left({\frac{3}{p}}\right)=(-1)^{\left\lceil {\frac{p+1}{6}}\right\rceil }=
{\begin{cases}
1,& p\equiv 1{\mbox{ or }}11{\pmod{12}}\\
-1,& p\equiv 5{\mbox{ or }}7{\pmod{12}}
\end{cases}} \\
\left({\frac{5}{p}}\right)=(-1)^{\left\lfloor {\frac{p-2}{5}}\right\rfloor }=
{\begin{cases}
1,& p\equiv 1{\mbox{ or }}4{\pmod 5}\\
-1,& p\equiv 2{\mbox{ or }}3{\pmod 5}
\end{cases}} \\
\left({\frac {7}{p}}\right)=
\begin{cases}
1,& p\equiv 1,3,9,19,25,{\mbox{ or }}27{\pmod {28}}\\
-1,& p\equiv 5,11,13,15,17,{\mbox{ or }}23{\pmod {28}}
\end{cases}
$$

### 求解方程：Cipolla算法

下面来解方程$x^2 \equiv d \pmod p$：

**定理** 设$a$满足$\omega = a^2 - d$不是模$p$的二次剩余，那么$x \equiv (a+\sqrt{\omega})^{\frac{p+1}{2}} \pmod p$满足$x^2 \equiv d \pmod p$。

**证明**

> 首先观察到以下结论：
> $$
> \binom{p}{i} \equiv 0 \pmod p,\ i = 1, 2, \dots, p-1 \\
> a^{p-1} \equiv 1 \pmod p \\
> \omega^\frac{p-1}{2} = \left({\frac{\omega}{p}}\right) \equiv -1 \pmod p
> $$
> 因此有：
> $$
> \begin{align*}
> (a+\sqrt{\omega})^p 
> &= a^p + \sum_{i-1}^{p-1} \binom{p}{i}a^i(\sqrt{\omega})^{p-i} + > \omega^{\frac{p-1}{2}}\sqrt{\omega} \\
> &\equiv a^p + \omega^\frac{p-1}{2} \sqrt{\omega} \pmod p \\ 
> &\equiv a - \sqrt{\omega} \pmod p
> \end{align*}
> $$
> 所以
> $$
> \begin{align*}
> x^2 &= (a+\sqrt{\omega})^{p+1} \\
> &= (a+\sqrt{\omega})^p(a+\sqrt{\omega}) \\
> &\equiv (a-\sqrt{\omega})(a+\sqrt{\omega}) \pmod p \\
> &\equiv a^2 - (a^2-d) \pmod p \\
> &\equiv d \pmod p
> \end{align*}
> $$

由上述定理，只需在$\mathbb{Z}/p\mathbb{Z}$中找到符合条件的$a$，即可求解方程$x^2 \equiv d \pmod p$。使用随机数找$a$的次数期望为$2$，计算$(a+\sqrt{\omega})^{\frac{p+1}{2}} \mod p$需要在二次域$\mathbb{Q}(\sqrt{\omega})$上进行，算法复杂度为$\mathrm{O}(\log p)$。

## 素数乘方的二次剩余

先讨论$p=2$的情形：

**引理 1** 奇数$a$是$2^k$的二次剩余当且仅当$a \equiv 1 \pmod 8$。

**证明**

> 设$x = 2m + 1$，则$x^2 = 4m^2 + 4m + 1 = 4m(m+1) + 1$，故$x^2 \equiv 1 \pmod 8$，反正显然。

由**引理 1**可推得，关于$2^2, 2^3, 2^4, \dots$的二次剩余是具有$4^k(8m+1)$形式的所有数；特殊地，$4$的二次剩余是$0, 1$。

------

下面讨论$p$为奇素数的情形：

**引理 2** 若整数$a$和$p$互质，$a$是$p$的若干次方的二次剩余当且仅当$a$是$p$的二次剩余。

*证明略*

若模数为$p^n$，那么$p^ka$：

- 在$k \geq n$时是二次剩余（取模后为$0$）；
- 在$k < n$时：
  - $k$为奇数时不是二次剩余；
  - $k$为偶数时是二次剩余当且仅当$a$是二次剩余。

模$p^k$意义下的二次剩余和非二次剩余的行为遵循和模$p$意义下相同的规则（见[Euler准则](#Euler准则 / Euler判别法)部分），而$p$不是$p^{2k+1}$的二次剩余，上述结论显然易得。

## 合数的二次剩余

对合数$m = \sum\limits_{i=1}^\alpha p_i^{e_i}$，其中$p_i$为质数，且$\forall i \neq j, p_i \neq p_j$：

若$a$是$m$的二次剩余，则$a$是**任意**$p_i^k$的二次剩余，其中$1 \leq i \leq \alpha, k \leq e_i$；

若$a$不是$m$的二次剩余，则**存在**$p_i^k$使得$a$不是$p_i^k$的二次剩余，其中$1 \leq i \leq \alpha, k \leq e_i$。

在模合数意义下，两个二次剩余的积依然是二次剩余；而两个非剩余、剩余和非剩余的积可能是$0$、剩余或非剩余。

**例 1**（剩余和非剩余的积） $6$的二次剩余为$1, 3, 4$：

- $3 \times 5 \equiv 3 \pmod 6$，结果为二次剩余；
- $4 \times 2 \equiv 2 \pmod 6$，结果为非二次剩余。

**例 2**（两个非剩余的积） $15$的二次剩余为$1, 4, 6, 9, 10$：

- $2 \times 8 \equiv 1 \pmod {15}$，结果为二次剩余；
- $2 \times 7 \equiv 14 \pmod {15}$，结果为非二次剩余。

这个现象可以从抽象代数的角度解释：$\mathbb{Z}/m\mathbb{Z}$中所有和模$m$互质的同余类构成一个乘法群，称作$\mathbb{Z}/m\mathbb{Z}$上的**可逆元群**$(\mathbb{Z}/m\mathbb{Z})^*$；这些同余类的平方可构成可逆元群的子群$H$。不同的非剩余可能属于不同的陪集，也不存在一个简单的法则来判断其属于哪一个陪集。特殊地，$m$为质数时，$(\mathbb{Z}/m\mathbb{Z})^*$除去子群$H$后只剩下一个陪集，故有特殊结论成立。