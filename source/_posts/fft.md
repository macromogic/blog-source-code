---
title: 算法复习笔记：多项式凭什么能FFT？
date: 2020-06-23 20:23:19
categories: Algorithm
tags:
 - Notes
 - Math
mathjax: true
---

# 算法复习笔记：多项式凭什么能FFT？

## 写在前面

本文仅面向学习FFT算法的**CS学生**。文中关于傅里叶变换的阐述仅用于帮助**快速简要**地理解算法背后时域/频域变换的意义，逻辑性不会像「信号与系统」课那么强。本人没系统学过「信号与系统」这门课，能写出这篇文章也要感谢来自FDU、SCUT的两位同学的帮助。欢迎各位大佬对本文内容进行指正！

要系统学习「信号与系统」的内容，可参阅**奥本海默**著的《信号与系统》一书。

在我学习FFT时，第一个面对的问题背景是**「给定两个多项式，如何快速求得二者的乘积？」**老师或者博客会先介绍**多项式的系数表示和点值表示**（在下一节也会再啰嗦一遍），然后引入**单位根**和**分治**思想来实现两种表示法间的转换。[这篇专栏](https://zhuanlan.zhihu.com/p/31584464)对算法内容及前置知识的讲解算是非常详尽的了，但它并没有解决一个问题：傅里叶变换的本质是将时域上的卷积转化成频域上的乘法，那么多项式的系数/点值表示为什么能和信号的时域/频域对应？本文将从**偏向EE**的角度来探讨这个算法，并尝试揭示其中的关联。

<!-- more -->

## 多项式

### 多项式的表示

给定一个环$\mathcal{R}$（通常是交换环）和一个未知数$x$，则形如：
$$
p(x) = a_0 + a_1x + a_2x^2 + \dots + a_nx^n
$$
的表达式称作$\mathcal{R}$上的**（一元）$n$次多项式（Polynomial of order $n$）**（其中$a_0, \dots, a_n \in \mathcal{R}$）。本文默认$\mathcal{R} = \mathbb{C}$，但系数在$\mathbb{R}$中取值。上述形式称作多项式$p$的**系数表示**。

由**代数基本定理**，上述多项式在$\mathbb{C}$上存在$n$个根$x_1, x_2, \dots, x_n$，则$p$可写成以下形式：
$$
p(x) = A(x - x_1)(x - x_2)\dots(x - x_n)
$$
取$x_0 \notin \{x_1, \dots, x_n\}$，则$A$的值可以唯一确定。一般地，一个$n$次多项式可以由$\mathcal{R}^2$上的$n+1$个点$(x_0, y_0), \dots, (x_n, y_n)$唯一确定/表示。这种表示方法称作多项式$p$的**点值表示**。

### 多项式的计算

令：
$$
\begin{align*}p(x) &= a_0 + a_1x + \dots + a_nx^n \\q(x) &= b_0 + b_1x + \dots + b_nx^n\end{align*}
$$
其点值表示为：
$$
\begin{align*}p(x) &: (x_0, y_0), (x_1, y_1), \dots, (x_n, y_n) \\q(x) &: (x_0, z_0), (x_1, z_1), \dots, (x_n, z_n)\end{align*}
$$
其和为：
$$
(p+q)(x) = (a_0+b_0) + (a_1+b_1)x + \dots + (a_n+b_n)x^n \\(p+q)(x): (x_0, y_0+z_0), (x_1, y_1+z_1), \dots, (x_n, y_n+z_n)
$$
积为：
$$
(pq)(x) = a_0b_0 + (a_0b_1+a_1b_0)x + \dots + \left(\sum_{0 \leq i \leq k}a_ib_{k-i}\right)x^k + \dots + a_nb_nx^{2n} \\(pq)(x): (x_0, y_0z_0), (x_1, y_1z_1), \dots, (x_n, y_nz_n), \dots, (x_{2n}, y_{2n}z_{2n})
$$
（注意做乘法时需要$2n+1$个点，因为乘积次数为$2n$）

对某一个值$x$求值时：
$$
\begin{align*}p(x) &= a_0 + a_1x + \dots + a_nx^n \\&= a_0 + (a_1 + (a_2 + \dots(a_{n-1} + a_nx)x\dots)x)x \\p(x) &= \sum_{k=0}^{n}\frac{\prod_{i \neq k} (x-x_i)}{\prod_{i \neq k} (x_k-x_i)}y_k\end{align*}
$$
使用点值表示求值本质上是在解下面这个线性方程组（写成矩阵的形式）：
$$
\begin{bmatrix}y_0 \\ y_1 \\ \vdots \\ y_n\end{bmatrix}=\begin{bmatrix}1 & x_0 & \cdots & x_0^n \\1 & x_1 & \cdots & x_1^n \\\vdots & \vdots & \ddots & \vdots \\1 & x_n & \cdots & x_n^n\end{bmatrix}\begin{bmatrix}a_0 \\ a_1 \\ \vdots \\ a_n\end{bmatrix}
$$
然后求：
$$
\begin{align*}y &= \begin{bmatrix}1 & x & \cdots & x^n\end{bmatrix}\begin{bmatrix}a_0 \\ a_1 \\ \vdots \\ a_n\end{bmatrix} \\&=\begin{bmatrix}1 & x & \cdots & x^n\end{bmatrix}\begin{bmatrix}1 & x_0 & \cdots & x_0^n \\1 & x_1 & \cdots & x_1^n \\\vdots & \vdots & \ddots & \vdots \\1 & x_n & \cdots & x_n^n\end{bmatrix}^{-1}\begin{bmatrix}y_0 \\ y_1 \\ \vdots \\ y_n\end{bmatrix}\end{align*}
$$
关于该式的计算会在**“线性代数”速览**一节展开。

不难看出，两种表示方式在求积和求值上分别具有优势。其实这里的系数/点值转换和信号的时域/频域转换非常相似——两种表示法下的乘法过程可以和时域上的卷积、频域上的乘法对应起来。事实上在（我见过的）几乎所有的FFT博客/讲义都把这个过程叫做DFT/IDFT。下一节我将简要介绍**傅里叶变换（Fourier Transformation，FT）**的来由，以及**离散傅里叶变换（Discrete Fourier Transformation，DFT）**和多项式的联系。

## “信号与系统”速览

这一部分实际上省略了大量铺垫内容，部分内容可能阐释不清，如有不明白的地方请参阅奥本海默并以书上内容为准。

### 冲激函数和线性时不变系统

**冲激函数**（数学上常称为**Dirac $\delta$函数**，下简称**$\delta$函数**）是定义在$\mathbb{R}$上的一个广义函数。其满足：

- $\delta(x) \neq 0 \iff x = 0$；
- $\int_{-\infty}^{+\infty}\delta(x)\mathrm{d}x = 1$。

离散情形（可认为在$\mathbb{Z}$上）下的$\delta$函数可视作：
$$
\delta[x] = \begin{cases}1,& x = 0 \\0,& x \neq 0 \end{cases}
$$
**线性时不变系统（Linear and Time Invariant System，LTIS）**可视作某信号处理函数，顾名思义满足以下性质：

- **时不变性**：输出不会随时间变化，若输入信号为平移后的$x(t+t_0)$，则输出也为平移后的$y(t+t_0)$；
- **线性性**：输入某些信号的线性组合$\sum_k c_kx_k(t)$，输出也为对应结果的线性组合$\sum_k c_ky_k(t)$。特别地，若输入为$\int_{-\infty}^{+\infty}c_\omega x_\omega(t)\mathrm{d}\omega$，对应输出也为$\int_{-\infty}^{+\infty}c_\omega y_\omega(t)\mathrm{d}\omega$。

### LTIS在连续信号上的作用

观察到$\delta$函数的性质，对任一连续信号$f(t)$，其值可表示为：
$$
f(t) = \int_{-\infty}^{+\infty}f(\tau)\delta(t-\tau)\mathrm{d}\tau
$$
将上式中$f(\tau)$视为$\delta(t - \tau)$的系数，则由LTIS的性质可知作用后的结果为：
$$
y(t) = \int_{-\infty}^{+\infty}f(\tau)h(t-\tau)\mathrm{d}\tau
$$
其中$h$是LTIS作用在$\delta$上的结果。

下面观察$f(t) = e^{j\omega t}$（其中$j$为虚数单位，$\omega$为频率，下同）的情形：

观察$y(t)$的形式，不难发现这其实是一个**卷积式**，即$y = f * h$，其中$h$表征了作用在$f$上的LTIS。由卷积式的对称性，上式可写成：
$$
\begin{align*}y(t) &= \int_{-\infty}^{+\infty}e^{j\omega(t - \tau)}h(\tau)\mathrm{d}\tau \\&= e^{j\omega t}\int_{-\infty}^{+\infty}e^{-j\omega\tau} h(\tau)\mathrm{d}\tau\end{align*}
$$
记$H(\omega) = \int_{-\infty}^{+\infty}e^{-j\omega\tau} h(\tau)\mathrm{d}\tau$，则上式可写作$y(t) = f(t)H(\omega)$，即LTIS作用的结果仅为$e^{j\omega t}$乘以一个关于$\omega$的系数。

为什么要讨论这个函数形式？由欧拉公式$e^{jx} = \cos x + j\sin x$知，复指数和周期函数有着天然的联系。由于复指数信号在LTIS中有上述优秀的性质，人们很自然地想把任意周期函数（信号）表示成一系列$e^{j\omega_i t}$的线性组合（这也是一个粗糙的**傅里叶级数**的雏形）：
$$
f(t) = \sum_k A(\omega_k)e^{j\omega_k t}
$$
事实上，非周期函数（信号）可以类似地以积分形式表示，可以认为非周期函数是周期趋近无穷大的周期函数：
$$
f(t) = \int_{-\infty}^{+\infty}A(\omega)e^{j\omega t}\mathrm{d}\omega \qquad (1)
$$
对于表征LTIS的函数$g(t)$，有：
$$
B(\omega) = \int_{-\infty}^{+\infty}e^{-j\omega \tau}g(\tau)\mathrm{d}\tau \qquad (2)
$$
则二者卷积结果为：
$$
(f*g)(t) = \int_{-\infty}^{+\infty}A(\omega)B(\omega)e^{j\omega t}\mathrm{d}\omega \qquad (3)
$$
不难看出，$f(t)$和$g(t)$是时域上的函数（以时间$t$为自变量），而$A(\omega)$和$B(\omega)$是频域上的函数（以频率$\omega$为自变量）。上面的$(1)$式和$(2)$式可以证明是互逆的操作（即**傅里叶变换**和**逆傅里叶变换**，证明参考Stein的《傅里叶分析导论》第五章）。由$(3)$式知，时域上的卷积和频域上的乘法等价。至此，我们应该对傅里叶级数和傅里叶变换有了非常粗浅简略的认识，下面来对傅里叶变换进行拓展。

### FT的拓展：DFT与多项式表示

下面提出时域函数和频域函数的两条特性，不作证明：

- 时域的周期化对应频域的离散化；
- 时域的离散化对应频域的周期化。

两条特性比较拗口，但是有高度的对称性。第一条特性比较好理解：时域上的周期函数可以用一系列成谐波关系的复指数函数$f_k(t) = e^{jk\omega_0 t}$（$k = 0, \pm1, \pm2, \dots$）的线性组合表示，表现在频域上则是离散的图像；第二条可以结合对称性和逆傅里叶变换理解。

根据这两个特性，下面我们直接拓展到**离散傅里叶变换（Discrete Fourier Transformation，DFT）**。DFT处理的是**有限离散序列**的卷积，该序列可以被认为是一个**离散周期信号**的主值序列（循环节）。变换后的序列也将是离散周期序列。

上面提到过$\delta$函数在离散情形下的形式。由离散周期性，可以将无限求和等价写成有限求和的形式。令信号周期为$N$，则可以类似地表示：
$$
f[t] = \sum_{k=0}^{N-1} f[k]\delta[t-k]
$$
其中$t = 0, 1, \dots, N-1$。LTIS的作用结果为：
$$
y[t] = \sum_{k=0}^{N-1} f[k]h[t-k]
$$
上文提到过，周期信号可由一系列谐波函数叠加表示。下面讨论$f[t] = e^{j\frac{2\pi i}{N}t}$的情形：
$$
\begin{align*}y[t] &= \sum_{k=0}^{N-1} e^{j\frac{2\pi i}{N}(t-k)}h[k] \\&= e^{j\frac{2\pi i}{N}t} \sum_{k=0}^{N-1} e^{-j\frac{2\pi i}{N}k}h[k]\end{align*}
$$
令$H[i] = \sum_{k=0}^{N-1} e^{-j\frac{2\pi i}{N}k}h[k]$，则$y[t] = f[t]H[i]$。

由于$e^{j\frac{2\pi i}{N}t}$在离散情形下只有$N$个不同取值，一般的离散周期信号可以表示为：
$$
f[t] = \sum_{i=0}^{N-1}c_i  e^{j\frac{2\pi i}{N}t}
$$
对$f[t]$做DFT的结果为：
$$
A[i] = \sum_{t=0}^{N-1}f[t]e^{-j\frac{2\pi i}{N}t}
$$
令$\omega_i = e^{-j\frac{2\pi i}{N}t}$（其中$i = 0, 1, \dots, N-1$），则DFT写成矩阵的形式为：
$$
\begin{bmatrix}A[0] \\ A[1] \\ \vdots \\ A[N-1]\end{bmatrix}=\begin{bmatrix}1 & \omega_0 & \cdots & \omega_0^{N-1} \\1 & \omega_1 & \cdots & \omega_1^{N-1} \\\vdots & \vdots & \ddots & \vdots \\1 & \omega_{N-1} & \cdots & \omega_{N-1}^{N-1}\end{bmatrix}\begin{bmatrix}f[0] \\ f[1] \\ \vdots \\ f[N-1]\end{bmatrix}
$$
因此IDFT的形式为：
$$
\begin{align*}\begin{bmatrix}f[0] \\ f[1] \\ \vdots \\ f[N-1]\end{bmatrix}&=\begin{bmatrix}1 & \omega_0 & \cdots & \omega_0^{N-1} \\1 & \omega_1 & \cdots & \omega_1^{N-1} \\\vdots & \vdots & \ddots & \vdots \\1 & \omega_{N-1} & \cdots & \omega_{N-1}^{N-1}\end{bmatrix}^{-1}\begin{bmatrix}A[0] \\ A[1] \\ \vdots \\ A[N-1]\end{bmatrix} \\&= \frac{1}{N}\begin{bmatrix}1 & \omega_0^{-1} & \cdots & \omega_0^{-(N-1)} \\1 & \omega_1^{-1} & \cdots & \omega_1^{-(N-1)} \\\vdots & \vdots & \ddots & \vdots \\1 & \omega_{N-1}^{-1} & \cdots & \omega_{N-1}^{-(N-1)}\end{bmatrix}\begin{bmatrix}A[0] \\ A[1] \\ \vdots \\ A[N-1]\end{bmatrix} \\\end{align*}
$$
上式的$\omega_i$实际就是**单位根**。关于该式的计算会在**“线性代数”速览**一节展开。

到这一步为止，我们可以揭示出多项式和离散周期信号的关系：将多项式的系数视作周期信号在时域上一个周期内的取值，则频域上的值就是该多项式在$N$个单位根上的取值。这样一来，DFT和IDFT这两个词应用在多项式计算上也就不显生硬了。

光揭示了多项式和DFT的联系还不够，按上式进行变换的时间复杂度仍为$O(N^2)$。下面我们先把遗留的矩阵计算问题啰嗦一下，再来讲FFT如何提高计算速度。

## “线性代数”速览

这一节只是对范特蒙德矩阵相关计算的解说，不感兴趣的话可以跳过。

### 行列式快速复习

对于$\mathcal{R}$上的$n \times n$方阵$M = (m_{ij})$，令$S_n$为$\{1, 2, \dots, n\}$上的置换群，则**$M$的行列式**为：
$$
\det M = \sum_{\sigma \in S_n} \prod_{i=1}^n m_{i, \sigma(i)}
$$
行列式有以下性质：

- 转置矩阵的行列式和原矩阵相同；
- 矩阵某一行（列）乘以某个倍数，行列式乘以相同的倍数；
- 矩阵某一行（列）加上另一行（列）的某个倍数，行列式不变；
- 矩阵行列式非零当且仅当矩阵可逆。

矩阵$M$的**伴随矩阵**记作$M^* = (M_{ij})^T$，其中$M_{ij}$代表$M$关于$m_{ij}$的**代数余子式**（即去掉第$i$行第$j$列后矩阵的行列式乘以$(-1)^{i+j}$）。若$M$可逆，则$M^{-1} = \frac{1}{\det M}M^*$。

### 范特蒙德矩阵

**范特蒙德（Vandermonde）矩阵**指形如下面形式的矩阵（有时也指它的转置）：
$$
V = \begin{bmatrix}1 & x_1 & \cdots & x_1^{n-1} \\1 & x_2 & \cdots & x_2^{n-1} \\\vdots & \vdots & \ddots & \vdots \\1 & x_n & \cdots & x_n^{n-1}\end{bmatrix}
$$
不难看出，若存在$i \neq j$使得$x_i = x_j$，则$\det V = 0$。

**定理** 范特蒙德矩阵的行列式为$\det V = \prod_{1 \leq i < j \leq n}(x_j - x_i)$。

**证明** 记$V_1=V$，将$V_1$从右向左每列依次减去左边一列的$x_1$倍，则：
$$
V_1' = \begin{bmatrix}1 & 0 & \cdots & 0 \\1 & x_2-x_1 & \cdots & x_2^{n-2}(x_2-x_1) \\\vdots & \vdots & \ddots & \vdots \\1 & x_n-x_1 & \cdots & x_n^{n-2}(x_n-x_1)\end{bmatrix} \\
$$
对第一行做拉普拉斯展开，则：
$$
\begin{align*}\det V &= \det V_1 \\&= \det V_1' \\&= \det \begin{bmatrix}x_2-x_1 & \cdots & x_2^{n-2}(x_2-x_1) \\\vdots & \ddots & \vdots \\x_n-x_1 & \cdots & x_n^{n-2}(x_n-x_1)\end{bmatrix} \\&= \prod_{i=2}^n(x_i-x_1) \det \begin{bmatrix}1 & \cdots & x_2^{n-2} \\\vdots & \ddots & \vdots \\1 & \cdots & x_n^{n-2}\end{bmatrix} \end{align*}
$$
记$V_2$为上面最后一步得到的矩阵，类似地有：
$$
\det V_2 = \prod_{i=3}^n (x_i-x_2)\det V_3
$$
依次类推，行列式得证。

### “点值表示法”的求值

令：
$$
X = \begin{bmatrix}1 & x_0 & \cdots & x_0^n \\1 & x_1 & \cdots & x_1^n \\\vdots & \vdots & \ddots & \vdots \\1 & x_n & \cdots & x_n^n\end{bmatrix}
$$
下面计算该式：
$$
y = \begin{bmatrix}1 & x & \cdots & x^n\end{bmatrix}X^{-1}\begin{bmatrix}y_0 \\ y_1 \\ \vdots \\ y_n\end{bmatrix}
$$
讨论$y_k$的系数，由拉普拉斯展开式的形式，有：
$$
\begin{align*}\frac{1}{\prod_{0 \leq i < j \leq n}(x_j - x_i)}\begin{bmatrix}1 & x & \cdots & x^n\end{bmatrix}\begin{bmatrix}X_{k0} \\ X_{k1} \\ \vdots \\ X_{kn}\end{bmatrix}&=\frac{1}{\prod_{0 \leq i < j \leq n}(x_j - x_i)}\det\begin{bmatrix}1 & x_0 & \cdots & x_0^n \\\vdots & \vdots & \ddots & \vdots \\1 & x & \cdots & x^n \\\vdots & \vdots & \ddots & \vdots \\1 & x_n & \cdots & x_n^n\end{bmatrix} \\&= \frac{\prod_{0 \leq i < j \leq n, i \neq k, j \neq k}(x_j-x_i)\prod_{0 \leq i < k}(x-x_i)\prod_{k < j \leq n}(x_j-x)}{\prod_{0 \leq i < j \leq n}(x_j - x_i)} \\&= \frac{\prod_{i \neq k} (x-x_i)}{\prod_{i \neq k} (x_k-x_i)}\end{align*}
$$

### IDFT矩阵的计算

DFT矩阵为：
$$
F = \begin{bmatrix}1 & \omega_0 & \cdots & \omega_0^{N-1} \\1 & \omega_1 & \cdots & \omega_1^{N-1} \\\vdots & \vdots & \ddots & \vdots \\1 & \omega_{N-1} & \cdots & \omega_{N-1}^{N-1}\end{bmatrix}
$$
$F^{-1}$也可用上述方法暴力计算，但观察到$\frac{1}{\sqrt{N}}F$是厄米（Hermitian）矩阵，即$\frac{1}{N}F\bar{F}^T = I$，其中$\bar{F}$表示$F$的元素取共轭复数的结果，很自然地就有：
$$
F^{-1} = \frac{1}{N}\bar{F}
$$

## FFT如何提速？

下面介绍**快速傅里叶变换（Fast Fourier Transformation，FFT）**的核心思路。

FFT的提速得益于**分治**的思想。考虑下列$n$次多项式（$n$为奇数）：
$$
p(x) = a_0 + a_1x + \dots + a_{n-1}x^{n-1}a_nx^n
$$
将$p$的系数按奇偶次项分开，构造下列多项式：
$$
\begin{align*}p_0(x) &= a_0 + a_2x + \dots + a_{n-1}x^{\frac{n-1}{2}} \\p_1(x) &= a_1 + a_3x + \dots + a_{n}x^{\frac{n-1}{2}}\end{align*}
$$
则有：
$$
\begin{align*}p(x) &= p_0(x^2) + p_1(x^2) \cdot x \\p(-x) &= p_0(x^2) - p_1(x^2) \cdot x\end{align*}
$$
这样可将多项式的计算拆分成两个长度为原来一半的多项式的计算。为保证每次恰好能将多项式分成长度相等的两个多项式，可以将原多项式补全成$2^k-1$次（$k$为某个正整数），高次项系数补0。

接下来探讨单位复根的使用：

记$\omega_n^k = e^{j\frac{2\pi k}{n}}$，则有$\omega_n^k= \omega_{2n}^{2k} = (\omega_{2n}^{k})^2$，$-\omega_n^k = \omega_n^{k+n/2}$，证明略。

代入上式则有：
$$
\begin{align*}p(\omega_n^k) &= p_0(\omega_{n/2}^k) + p_1(\omega_{n/2}^k) \cdot \omega_n^k \\p(\omega_n^{k+n/2}) &= p_0(\omega_{n/2}^k) - p_1(\omega_{n/2}^k) \cdot \omega_n^k\end{align*}
$$
取$k = 0, 1, 2, \dots, \frac{n}{2} - 1$，则可以通过拆分后的式子计算原多项式的值，总时间复杂度降为$O(n \log n)$。

IDFT的过程和DFT基本一致，只有细节上的差距，这里略去，详情可见下面的代码模板。

至此，在多项式乘法中应用DFT/IDFT才真正具有意义：傅里叶变换不是无用功，它能帮助显著缩短计算时间。

## 代码模板

实现细节这里不再赘述，请参考[这篇专栏](https://zhuanlan.zhihu.com/p/31584464)或搜索Cooley-Tukey算法（其中使用了一些位运算技巧来减小分治的空间开销）。实际使用中调用带`template`的两个函数即可。

``` C++
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <cmath>
#include <complex>

using namespace std;

namespace fft {

typedef complex<double> cd;

const int MAXL = 3600180;
const double PI = acos(-1.0);

cd a[MAXL], b[MAXL];

int rev[MAXL];

inline void get_rev(int bit) {
    for (int i = 0; i < (1 << bit); i++) {
        rev[i] = (rev[i >> 1] >> 1) | ((i & 1) << (bit - 1));
    }
}

inline void fft(cd* a, int n, int dft) {
    for (int i = 0; i < n; i++) {
        if (i < rev[i]) {
            swap(a[i], a[rev[i]]);
        }
    }
    for (int step = 1; step < n; step <<= 1) {
        cd omega = exp(cd(0, dft * PI / step));
        for (int j = 0; j < n; j += (step << 1)) {
            cd omk(1, 0);
            for (int k = j; k < j + step; k++) {
                cd x = a[k];
                cd y = omk * a[k + step];
                a[k] = x + y;
                a[k + step] = x - y;
                omk *= omega;
            }
        }
    }
    if (dft == -1) {
        for (int i = 0; i < n; i++) {
            a[i] /= n;
        }
    }
}

inline void init() {
    memset(a, 0, sizeof(a));
    memset(b, 0, sizeof(b));
    memset(rev, 0, sizeof(rev));
}

template <class T>
inline void get_conv(T* arr1, int len1, T* arr2, int len2) {
    init();
    int bit = 1;
    while ((1 << bit) < len1 + len2 - 1) bit++;
    int s = 1 << bit;
    for (int i = 0; i < len1; i++) {
        a[i] = double(arr1[i]);
    }
    for (int i = 0; i < len2; i++) {
        b[i] = double(arr2[i]);
    }
    get_rev(bit);
    fft(a, s, 1);
    fft(b, s, 1);
    for (int i = 0; i < s; i++) {
        a[i] *= b[i];
    }
    fft(a, s, -1);
}

template <class T>
inline void get_ans(T* ans, int st, int ed) {
    for (int i = st; i < ed; i++) {
        ans[i - st] = T(a[i].real() + 0.5);
    }
}

}  // namespace fft

```

## 后记

以上内容为一个学了一年FFT没学明白的蒟蒻试图在一个下午之内参透FT的含义的产物。其中有很多内容可能存在疏漏，如果有更加准确却不失简洁性的解释，欢迎联系指正。

~~不过估计也不会有人会像我一样钻牛角尖钻出这么个四不像吧？~~

