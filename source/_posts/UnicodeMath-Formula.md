---
title: "UnicodeMath Formula"
date: 2018-11-15T23:13:02+08:00
author: "T H"
mathjax: true
categories: Math
tags:
 - Math
 - Manual
 - Legacy
---

_本文章搬迁自原Hugo博客_

# 使用UnicodeMath输入常用公式

---

## 写在前面
UnicodeMath虽然没有$\mathrm{\LaTeX}$那么强大的功能，但对一些专业要求不高的人来说已足够日常使用了——只需打开Word（2007版及以上或Office 365所有产品）就能快速键入并实时预览公式。本文主要针对不会使用$\mathrm{\LaTeX}$、又需要编写大量数学公式的人，简要介绍UnicodeMath格式常用公式的用法。
本文内容由笔者参考过[Office文档][1]、[Jacob Zhang的个人博客][2]（特别鸣谢）以及[Unicode官方文档][3]后整理而成。如有疏漏，敬请指正。
另外，文末有笔者之前整理的简要公式文档，内容与本文可能有个别出入，仅供参考，欢迎下载！

<!-- more -->

---

## 进入公式编辑

在**Word 2007及以上版本或Office 365产品**中按快捷键`Alt`+`=`（Mac为`Control`+`=`）即可进入公式编辑，显示如下：
![启动公式编辑](https://seafile.t123yh.xyz:2/thumbnail/27bf6df9ef14436995a6/1024/QQ%E6%88%AA%E5%9B%BE20181115110901.png "启动公式编辑")
在编辑框里输入公式，如：`y=ax^2+bx+c`，然后按空格，你会得到渲染之后的公式：
$$
y=ax^2+bx+c
$$
再比如，输入一个复杂一点的公式（注意公式中间的空格）：`f'(x_0)=lim_(x->x_0) (f(x)-f(x_0))/(x-x_0)`
会得到：
$$
f'(x_0)=\lim_{x \to x_0} \frac{f(x)-f(x_0)}{x-x_0}
$$
如果字体显示有误，调整成_斜体_（快捷键：`Ctrl`+`I`）即可。
注意UnicodeMath格式下每敲一次空格只渲染**一个**公式（如果有），有时候会在输入的同时渲染公式。**建议在阅读本文的同时在自己的电脑上尝试操作，以感受Office的实时渲染功能。**如果在公式末敲了几次空格都没有渲染成想要的公式，请检查格式是否正确：）。

---

## 特殊符号

### 运算符
 - 加减号 $\pm$ 和 $\mp$ 直接写作`+-`和`-+`；
 - 乘号 $\cdot$ 和 $\times$ 分别写作`\cdot`和`\times`；
 - 除号 $\div$ 写作`\div`；
 - 分数如 $\frac{\Large \ a\ }{\Large \ b\ }$ 可直接写作`a/b`，如果需要特殊格式如 ${\Large ^a}/{\Large _b}$ 或 $a/b$ 则写作`a\sdiv b`或`a\ldiv b`，注意公式中的空格；
 - 根号 $\sqrt{\ \ \ }$ 写作`\sqrt(...)`，其中`...`表示根号下的公式，如需指定根指数如 $\sqrt[n]{\ \ \ }$ 则写作`\sqrt(n&...)`；
 - 对数如 $\log_a{b}$ 写作`log_a b`，注意公式中的空格；
 - 极限如 $\lim\limits_{x \to 0}{f(x)}$ 写作`lim_(x->0) f(x)`，注意公式中的空格；
 - 复合函数 $\circ$ 写作`\circ`；
 - 偏导符号 $\partial$ 写作`\partial`。

### 关系符
 - 大于等于 $\ge$ 和小于等于 $\le$ 直接写作`>=`和`<=`；
 - 远大于 $\gg$ 和远小于 $\ll$ 直接写作`>>`和`<<`
 - 约等号 $\approx$ 和 $\doteq$ 分别写作`\approx`和`\doteq`；
 - 不等号 $\neq$ 写作`\neq`；
 - 恒等号 $\equiv$ 写作`\equiv`。

### 集合符号
 - 属于 $\in$ 和 $\ni$ 写作`\in`和`\ni`
 - 不属于 $\notin$ 写作`\notin`
 - 包含（于） $\subset$ 、$\subseteq$ 、 $\supset$ 、 $\supseteq$ 分别写作`\subset`、`\subseteq`、`\superset`、`\superseteq`；
 - 空集 $\emptyset$ 写作`\emptyset`
 - 交集 $\cap$ 和并集 $\cup$ 分别写作`\cap`和`\cup`

### 上下标和巨算符
 - 下标以`_`开头，必要时需加上括号，如 $x_n$ 写作`x_n`， $a_{i, j}$ 写作`a_(i,j)`；
 - 上标以`^`开头，其余同理，如 $a^x$ 、$e^{1-x}$ ；
 - 上下标可以同时出现，如 $C_m^n$ 写作`C_m^n`，也可以写在前面，如 $_{m}^{\ n}X$ 写作`(_m^n)X`；
 - 求和、求积符号如 $\sum\limits_{i=1}^n{x_i}$ 和 $\prod\limits_{j=1}^m{y_i}$ 分别写作`\sum_(i=1)^n x_i`和`\prod_(j=1)^m y_j`，注意公式中的空格；
 - 积分符号如 $\int_a^b{f(x)}$ 写作`\int_a^b f(x)`，注意公式中的空格；
 - 其余巨算符列举如下，用法参见上两条：

| 符号 | 输入格式 |
| :--: | :--: |
| $\iint$ | `\iint` |
| $\iiint$ | `\iiint` |
| $\oint$ | `\oint` |
| $\bigcap$ | `\bigcap` |
| $\bigcup$ | `\bigcup` |
| $\bigwedge$ | `\bigwedge` |
| $\bigvee$ | `\bigvee`|

部分公式如`\oiint`、`\oiiint`、`\coint`、`\aoint`无法通过MathJax表示，请读者自行试验。

### 其它
 - 标注符号如 $\vec{AB}$ 、 $\bar{x}$ 、 $\hat{y}$ 分别写作`(AB)\vec`、`x\bar`、`y\hat`，敲**两次**空格；
 - 无穷记号 $\infty$ 写作`\infty`；
 - 成比例符号 $\propto$ 写作`\propto`;
 - 因为 $\because$ 、所以 $\therefore$ 分别写作`\because`、`\therefore`；
 - 任意 $\forall$ 、存在 $\exists$ 分别写作`\forall`、`\exists`
 - 与 $\wedge$ 、或 $\vee$ 、非 $\neg$ 分别写作`\wedge`、`\vee`、`\neg`；
 - 平行 $\parallel$ 、垂直 $\perp$ 分别写作`\parallel`、`\perp`；
 - 角 $\angle$ 、角度 $^{\circ}$ 分别写作`\angle`、`\degree`；
 - 全等符号 $\cong$ 直接写作`~=`；
 - 分隔符 $\vert$ 写作`\vbar`；
 - 省略号 $\cdots$ 、 $\vdots$ 、$\ddots$ 分别写作`\cdots`、`\vdots`、`\ddots`。

---

## 字母及变体

 - 希腊字母的快捷命令，大写开头表示大写字母，小写开头表示小写字母，如 $A$ 写作`\Alpha`， $\alpha$ 写作`\alpha`，特殊地，希腊字母omicron（$O$、$o$）分别写作`\O`、`\o`；
 - 个别小写字母有多种写法，如 $\epsilon$ 写作`\epsilon`，而 $\varepsilon$ 写作`\varepsilon`（多了一个`var`），相似地，$\vartheta$ 、 $\varpi$ 、 $\varrho$ 、 $\varsigma$ 、 $\varphi$ 分别写作`\varepsilon`、`\varpi`、`\varrho`、`\varsigma`、`\varphi`；
 - 拉丁字母有三种变体，分别是手写体、花体、双线体，格式为在拉丁字母前加上`\script`、`\fraktur`或`\double`，如A的三种变体 $\mathcal{A}$ 、 $\mathfrak{A}$ 、 $\mathbb{A}$ 分别写作`\scriptA`、`\frakturA`、`\doubleA`（小写字母也适用）。

---

## 排版符号、括号
 - 位置格式符：
  - 位于上方，如 $\overset{B}{A}$ ，写作`A\above B`，注意公式中的空格，下同；
  - 位于下方，如 $\underset{B}{A}$ ，写作`A\below B`；
  - 上下排列，如 $A \atop B$ ，写作`A\atop B`。
 - 矩形方框， 如 $\fbox{a}$ ，写作`\rect(a)`。
 - 矩阵，使用`&`换列，`@`换行，如 $\begin{matrix}a&b\\\ c&d \end{matrix}$ ，写作`\matrix(a&b@c&d)`。
 - 多行公式，使用`&`指定对齐位置，`@`换行，如 $\begin{align} x+y&=2\notag\\\ y&=3\notag\end{align}$ ，写作`\eqarray(x+y&=2@y&=3)`。

---

## 箭头

 - 左向箭头 $\leftarrow$ 、 $\Leftarrow$ 、 $\leftharpoondown$ 、 $\leftharpoonup$ 分别写作`\leftarrow`、`\Leftarrow`、`\leftharpoondown`、`\leftharpoonup`;
 - 右向箭头 $\rightarrow$ 、 $\Rightarrow$ 、 $\rightharpoondown$ 、 $\rightharpoonup$ 分别写作`\rightarrow`、`\Rightarrow`、`\rightharpoondown`、`\righttharpoonup`;
 - 双向箭头 $\leftrightarrow$ 、 $\Leftrightarrow$ 、 $\rightleftharpoons$ 分别写作`\leftrightarrow`、`\Leftrightarrow`、`\lrhar`；
 - 双向箭头 $\Longleftarrow$ 、 $\Longrightarrow$ 、 $\Longleftrightarrow$ 分别写作`\Longleftarrow`、`\Longrightarrow`、`\Longleftrightarrow`。

---

## 文档整理

[点此][5]下载公式整理PDF版（虽然是之前整理的暂未更新）。另外，本文没有列举出的公式符号可以在**公式工具 > 设计**中查找（需要进入公式编辑）。


[1]:https://support.office.com/zh-cn/article/word-%E4%B8%AD%E4%BD%BF%E7%94%A8-unicodemath-%E5%92%8C-latex-%E7%9A%84%E7%BA%BF%E6%80%A7%E6%A0%BC%E5%BC%8F%E5%85%AC%E5%BC%8F-2e00618d-b1fd-49d8-8cb4-8d17f25754f8?ui=zh-CN&rs=zh-CN&ad=CN "Office Support"
[2]:https://jacobz.top/2017-08/WordMath/ "Jacob's Personal Blog"
[3]:http://unicode.org/notes/tn28/UTN28-PlainTextMath-v3.pdf "Unicode Official Document"
[4]: https://seafile.t123yh.xyz:2/lib/d04ee86e-0188-47c2-bcc0-d2089bd5045f/file/QQ%E6%88%AA%E5%9B%BE20181115110901.png
[5]:https://seafile.t123yh.xyz:2/lib/2200f1f7-a71d-4bf1-8086-c9835c7d4f28/file/UnicodeMath%E5%85%AC%E5%BC%8F%E5%BF%AB%E6%8D%B7%E9%94%AE.pdf?dl=1 "UnicodeMath tutorial zh-cn"


