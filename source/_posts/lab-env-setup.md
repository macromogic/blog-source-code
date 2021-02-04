---
title: 远端虚拟机环境配置避雷指南
date: 2020-10-30 22:52:21
tags: [Manual, Setup, Ubuntu]
categories: Manual
---

2021-02-04 Update: 早知道就先升级到18.04或者20.04来配置了，也不会有下面这么多坑了orz

---

感谢上天让我在忙的头都要掉了的时候还有时间来写这篇博客记录这艰难曲折的配环境之路……希望以下内容对读者没有任何帮助。

<!-- more -->

## 前言

这学期因为要做创新实践，复现论文的时候需要运行MATLAB程序，但我并不想在自己的电脑上再装一个庞然大物，遂向课题组伸手讨了一台服务器上的虚拟机。虚拟机由VMWare ESXi管理，系统是Ubuntu 16.04 LTS（含桌面）。

VMware有一个好，如果电脑上装有VMWare Remote Console或其他产品，可以使用其自带的VMRC协议直接唤起远程桌面。首先你需要获取到服务器的域名/IP以及当前虚拟机的MOID，然后只需在命令行执行一行指令：

``` cmd
start "" "vmrc://<server-addr>/?moid=<moid>"
```

或者在macOS/Linux下执行：

``` zsh
open "vmrc://<server-addr>/?moid=<moid>"
```

VMWare Remote Console窗口会自动拉起。

## GCC/Python环境搭建

Ubuntu 16.04依然安装着GCC 5以及Python 3.5，这对0202年的打工人是及其不友好的。然而作为怕麻烦爱摸鱼的打工人，能用`apt`解决的事情绝不去手动安装。所以这里先添加PPA：

``` bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:ubuntu-toolchain-r/test # for GCC
sudo add-apt-repository ppa:deadsnakes/ppa # for Python
sudo apt update
```

现在就可以根据自己的需求安装需要的版本了。

对于Python的`pip`包，为避免多版本导致的问题，建议使用`python3.x -m easy_install pip` 来安装。使用`pip`安装需要的包时，也使用`python3.x -m pip install xxx`来保证正确性。

## MATLAB的配置

从官网下载并解压安装包之后，直接`cd`到对应目录然后`sudo ./install`即可。安装时需保证login username和当前登录的用户名一致，安装完成后才能正常使用。这样安装会带来一个问题：后期添加新的add-on的时候会有权限问题。解决方案是用`chown`给当前账户赋予权限。

VSCode社区提供了一整套MATLAB支持插件，使用前需手动配置Mlint路径来支持语法检查。以R2020b版本为例，默认安装情况下Mlint路径为：

```
/usr/local/MATLAB/R2020b/bin/glnxa64/mlint
```

这样，配合VSCode的其它插件，可以达成比MATLAB原生界面更舒适的开发体验。唯一美中不足的是运行脚本功能暂时还没有支持按钮或快捷键，需要手动F1执行。

## 用Python来运行MATLAB？

MATLAB官方提供了一套支持引擎，在安装目录里手动setup一下即可使用。详情参考[官方说明](https://ww2.mathworks.cn/help/matlab/matlab_external/install-the-matlab-engine-for-python.html)。此外，有一个号称「比原生引擎更简洁」的MATLAB交互库：[Transplant](https://pypi.org/project/Transplant/)。这个库支持Python原生/NumPy/Scipy类型和MATLAB类型的自动转换，并且变量和方法的调用方式非常简单。这个库本身也「十分简洁」，主要代码基本在[GitHub](https://github.com/bastibe/transplant)的`transplant/transplant_master.py`中一目了然。尽管这两个库让Python用户能够直接在熟悉的环境下调用MATLAB函数，这个交互接口还是存在一些弊端：

- 无法定义、修改MATLAB的全局变量；
- 无法将MATLAB的函数名覆写成变量（本来也不应该）；
- 无法将Python方法传入MATLAB：根据[这条issue](https://github.com/bastibe/transplant/issues/89)，MATLAB暂时未提供相关支持，因此不容易实现。

如果一段代码中存在大量全局变量且需要进行反复修改的话，建议还是直接编辑MATLAB源码。

此外还有一个注意事项：Python原生的`list`类型由于没有类型约束，会被转换成MATLAB的`cell`类型；要想使用数组/矩阵类型，建议使用`numpy.ndarray`。

此外，Transplant号称可以通过ssh唤起远端机器的MATLAB交互界面（需要相关库支持，详见PyPI文档），但实际使用时引发了下面的异常：

```
Error loading libzmq: There was an error loading the library "zmq"
zmq.so: cannot open shared object file: No such file or directory
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/usr/local/lib/python3.8/site-packages/transplant/transplant_master.py", line 571, in __init__
    self.eval('0;') # no-op. Wait for Matlab startup to complete.
  File "/usr/local/lib/python3.8/site-packages/transplant/transplant_master.py", line 637, in __getattr__
    return self._get_global(name)
  File "/usr/local/lib/python3.8/site-packages/transplant/transplant_master.py", line 92, in _get_global
    response = self.send_message('get_global', name=name)
  File "/usr/local/lib/python3.8/site-packages/transplant/transplant_master.py", line 151, in send_message
    self._wait_socket(zmq.POLLOUT)
  File "/usr/local/lib/python3.8/site-packages/transplant/transplant_master.py", line 181, in _wait_socket
    raise RuntimeError('Process died unexpectedly')
RuntimeError: Process died unexpectedly
```

查阅网上相关问题，发现都是找不到`libzmq.so`之类的文件，而不是`zmq.so`。尝试安装了各种库依然无果。个人猜测是R2020b的依赖库发生了些微变化，而开发者暂时还没修复该问题。

（是不是该去提个issue呢……）