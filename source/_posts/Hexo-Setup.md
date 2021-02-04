---
title: 跌跌撞撞的Hexo小记
date: 2019-08-23 00:26:57
tags: [Hexo, Manual, Setup]
categories: Manual
---

<font color=7A7A7A>_~~这篇文章应该是会长期更新的吧……大概~~_</font>

<font color=E0E0E0>_~~是不是颜色调的很淡你们就看不到我~~_</font>

去年11月份，怀揣着即将成为CS系学生的觉悟，我决定像周围大佬们一样建立一个属于自己的博客。可气的是，我电脑上的WSL运行的是Ubuntu 16.04.6 LTS，而Ubuntu自己的`apt`**向来不会**安装最新版本（或者较新版本）的工具~~（当然也不排除我懒得搞镜像源的问题）~~，在经历了配置Nginx失败、`npm`下载等一年之类的问题之后，我放弃了WordPress和Hexo，并在*pg999w*的推荐下入坑了Hugo。_However_，我的Hugo源文件一开始是在<font size=1>嫖来的</font>[t123yh][1]的服务器上编辑的，这也带来了一系列问题比如无法本地预览、服务器重置以后必须重新配置而我又没有写文章来记录、~~以及本人很懒根本就没更新文章~~。总而言之，作为一个已经进入CS系的~~韭菜~~，我决定回到**Hexo**坑并让这个博客复活。在此感谢[Whexy][2]和[Eveneko][3]的帮助。

前排提醒：下列操作均在WSL环境下进行。必要时需`sudo`。

<!-- more -->

## 0：建立博客

（先在这里放一个我参考过的[链接][4]）

Hexo基于Node.js，所以`nodejs`和`npm`的安装是必需的。安装好之后执行：

``` Bash
npm install -g hexo-cli
```

这样你就拥有了一个Hexo。然后在你建立的博客目录下面执行：

``` Bash
hexo init
```

就可以在当前目录下面生成一个Hexo环境了。Hexo默认在`source/_posts/`下面预置了一篇Hello world的文章，要预览当前的博客，执行：

``` Bash
hexo s
```

然后在浏览器访问`localhost:4000`就好啦。

要创建新文章，执行：

``` Bash
hexo new 文章名
```

Hexo会在`source/_posts`下面生成一个`文章名.md`文件。打开编辑即可。

（不会写Markdown的请[出门右转][5]）

那怎么部署呢？首先确保你安装了`git`并且有一个GitHub账号，这样我们可以借助**GitHub Pages**来发布自己的网站。在GitHub上创建名为`用户名.github.io`，这里“用户名”换成你自己的GitHub用户名。这样一来部署在上面的网页可以直接通过这个网址访问。

然后打开博客的配置文件`_config.yml`，找到`deploy`选项，然后如下填写：

``` 
deploy:
  type: git
  repo: 仓库完整路径（加上.git）
  branch: master
```

现在万事俱备，只欠东风了！

下面安装Git部署插件，执行：

``` Bash
npm install hexo-deployer-git --save
```

安装好之后再依次执行：

``` Bash
hexo clean
hexo d -g
```

输入你的GitHub账号密码，部署完成！

## 1：Config, config, config

配置自己的博客，大概可以配一辈子……至少我是这么觉得的……

正所谓“博客如此多娇，引无数英雄竞折腰”（不是

反正到现在为止我还是有些一知半解，暂且先在这里随便写一点吧，~~反正GitHub有备份~~

还是打开`_config.yml`，在最开头的`Site`部分，根据喜好写上标题、作者、描述、语言等等，例如：

``` 
# Site
title: Macromogic Blog
subtitle:
description: Nothing but dump
keywords:
author: T H
language: en
timezone:
```

然后呢……大概90%的Hexo用户都在使用**Next主题**吧（没统计过，别打我），在`themes/`下面把主题`git clone`下来，如果想要像我一样要用Git管理博客源码，就把主题的`.git`目录干掉吧。做完之后修改`_config.yml`如下：

```
theme: next
```

至此，主题配置完成！……就怪了。

主题里面能搞的事情太多了，鉴于笔者当前水平，还是推荐[链接][6]比较稳妥（大雾

## 2：后排摸雷

这一部分用来记录搭博客时的一些鸡毛蒜皮的问题。

### 平台迁移导致的Git版本管理问题

前文也提到了，我使用过Hugo来搭建博客，也在用Git来管理博客源码。虽然现在Hugo报废了，但我并不想直接`git push -f`直接把Hugo的版本历史直接干掉。所幸有一个**非常暴力**的解决方案：

- 在刚刚建立Hexo时，将内容全部备份到另一目录，然后该目录清空；
- `git pull`把Hugo的源码拉下来，同样清空，但是保留`.git`目录；
- 将备份的文件复制回来，推上去，结束。

这样如果想要回滚到Hugo就不是问题啦~~（当然这种事大概率是不会发生的了）~~。

### 文章置顶问题

文章置顶参考了[这篇文章][7]的做法：

首先安装支持置顶的仓库，并卸载原有的：

``` Bash
npm uninstall hexo-generator-index --save
npm install hexo-generator-index-pin-top --save
```

然后在文章首加上

```
top: true
```

即可。

光置顶没有标记感觉好像缺了点什么，那就手动加上吧！在`themes/next/layout/_macro/post.swig`文件中，找到`<div class="post meta">`标签，插入下列代码：

```
{% if post.top %}
  <i class="fa fa-thumb-tack"></i>
  <font color=9C9C9C>Top</font>
  <span class="post-meta-divider">|</span>
{% endif %}
```

结束啦！当然这里还有一个**多置顶文章顺序**的问题我没有测试，有需要的话可能会采取其它做法，到时候再追加到这里。

### Categories等页面404问题

一开始看到这个问题傻眼了，结果发现解决方案贼蠢：缺啥补啥。

执行下面命令：

``` Bash
hexo new page categories
hexo new page tags
hexo new page about
```

然后编辑一下对应的`index.md`即可。

蠢兮兮。

### MathJax渲染问题

对于需要在博客中写数学公式的人而言，MathJax是必需的。在`themes/next/_config.yml`中作如下修改：

```
math: 
  enable: true
  per_page: true
  mathjax:
    enable: true
  katex:
    enable: true
```

其中，若`per_page`设为`false`，则会对所有文章进行渲染；否则只会渲染文首添加了`mathjax: true`的文章。

下面出现了两个问题：

#### LaTeX和Markdown的语法冲突

语法冲突主要体现在`\\`、`\{`、`\}`等字符的渲染问题、下划线的解释问题（下标或者斜体）等。最后的解决方案是使用**Pandoc**进行渲染。当然，首先需要保证电脑上安装了`pandoc`，然后执行：

``` Bash
npm uninstall hexo-renderer-marked --save
npm install hexo-renderer-pandoc --save
```

这样就将渲染工具换成Pandoc了。

需要注意的是，如此操作之后，必须遵循[Pandoc的规定][8]编写Markdown。<font size=2.2>（手上有**Typora**还怕这个吗？）</font>

在我的WSL上，安装好`hexo-renderer-pandoc`之后，会出现另一个问题：就是在渲染过程中会报如下错误：

```
pandoc exited with code 9: pandoc: Unknown extension: smart
```

这是因为我一开始安装的Pandoc版本为1.9.0，而Pandoc在2.0及以后取消了Smart扩展。因此需要将Pandoc升级到2.0及以上版本（论Ubuntu有多糟心……）。

#### 长公式在移动设备上的支持

由于数学公式的渲染方式，在移动设备查看文章时难免会出现下图的情况：

![](https://seafile.t123yh.xyz:2/thumbnail/d04ee86e-0188-47c2-bcc0-d2089bd5045f/1024/Screenshot_2019-08-23-00-46-03-142_Chrome.png "突出的公式")

一条公式捅穿天际，要多丑有多丑……然而貌似也没有非常完美的解决方案。

一种简便点的方案是，使用`$$`将一整块行内公式拆成若干块，这样**有可能**会解决公式过长导致的问题，不过方法过于玄学，请~~看脸~~酌情使用。

另一种方案是，在文章中增加`<div>`来定义宽度，具体见[这篇文章][9]。本博客没有采用该方法。~~（反正也没好看到哪去）~~

### 免密码推送/部署

既要更新博客源码，又要部署博客，敲命令好麻烦啊。不如写个脚本一键解决吧：

``` Bash
#!/bin/bash

git add -A && git commit -a && git push && hexo clean && hexo d -g
```

现在我需要输入两次账号密码来完成这个任务了。这样依旧很麻烦，那就继续寻找免输密码的办法吧！

有一个在Git配置中存储账号密码的方法，然而这种存储方式是明文存储，不是很安全。参考链接在[这里][10]，我的实现操作如下：

``` Bash
git config --global credential.helper store
git pull
```

这样你的账号信息就会存储在`~/.git-credentials`里面。现在只要不修改密码，推送时就不会再提示输入账号密码了~

然而这个办法不能解决Hexo部署的问题。这个需要修改Hexo的配置。

首先运行：

``` Bash
ssh-keygen
```

连续几个回车，会生成你自己的ssh公钥和密钥。然后登录GitHub，在Settings > SSH and GPG Keys下面将`~/.ssh/id_rsa.pub`的内容添加到SSH Keys列表中。现在在命令行下执行：

``` Bash
ssh -T git@github.com
```

会显示以下内容：

```
Hi <Username>! You've successfully authenticated, but GitHub does not provide shell access.
Connection to github.com closed.
```

其中`<Username>`是你的GitHub用户名。看到上述内容说明你的SSH公钥生效了。

现在进入Hexo的`_config.yml`，找到`deploy`选项，将链接的`https://github.com/`替换成`git@github.com:`，保存。

至此，免密码部署也完成了！



以上就是目前为止搭建Hexo的心得体会。以后会再陆续添加。感谢阅读！



[1]: https://blog.t123yh.xyz:2 "%%%t123yh"
[2]: http://whexy.com "%%%Whexy"
[3]: https://eveneko.github.io "%%%Eveneko"
[4]: https://zhuanlan.zhihu.com/p/26625249 "知乎NB！"
[5]: https://github.com/younghz/Markdown "GitHub"
[6]: https://www.jianshu.com/p/1f8107a8778c "主题配置"
[7]: http://wangwlj.com/2018/01/09/blog_pin_post/ "文章置顶"
[8]: https://pandoc.org/MANUAL.html#pandocs-markdown "Pandoc的规定"
[9]: https://www.maixj.net/wz/mathjax-huanhang-11558 "MathJax自动换行"
[10]: https://stackoverflow.com/questions/35942754/how-to-save-username-and-password-in-git "Stack Overflow"

