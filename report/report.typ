#import "@preview/rubber-article:0.1.0": *

#show: article.with()

#maketitle(
  title: "基于蒙特卡洛法算圆的面积",
  authors: (
    "诸晓婉(922110800509)",
    "张雨馨(923104780210)",
    "拓欣(922114740127)",
  ),
  date: "2024年12月",
)

= 介绍

== 小组介绍

诸晓婉 - PPT

张雨馨 - 报告

拓欣 - 代码

== 项目介绍

= 代码实现

== 串行

== OpenMP

== OpenMP+MPI

= Intel Fortran

== Intel MPI vs MPICH

== OpenBLAS vs MKL

= 未来展望

== Coarray

Coarray是Fortran 2008的一个特性, 可以实现分布式内存并行计算, 无需自己编写OpenMP、MPI等代码, 但是需要编译器支持

== 使用Julia等更热门的语言

=== Julia

- Threads.jl
- Distributed.jl

=== Python

- Ray

=== Rust

- Rayon

== 使用GPU加速

- NVIDIA CUDA Fortran

== 更高级的算法

- 分层采样 把蒙特卡洛法进一步微分，把一个任务拆分成了数个任务

- 重要性采样 需要一定的概论相关的数学知识

- 自适应采样 通过一定的算法/机器学习的方法来自适应的调整采样的方法

- 拟蒙特卡洛序列
    - Sobol序列
    - Halton序列
    - Faure序列
