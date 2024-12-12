#import "@preview/touying:0.5.3": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#import themes.stargazer: *

#show: stargazer-theme.with(
  aspect-ratio: "4-3",
  footer: self => self.info.title,
  config-info(
    title: [基于蒙特卡洛法算圆的面积],
    subtitle: [小组大作业报告],
    author: [拓欣 诸晓婉 张雨馨],
    date: "2024年12月12日",
  ),
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

= 介绍

== 小组介绍

#align(center,text(size: 28pt)[
诸晓婉(922110800509) - PPT

张雨馨(923104780210) - 报告

拓欣(922114740127) - 代码
])

== 项目介绍

= 代码实现

== 串行

#codly(languages: codly-languages)
```fortran
program monte_carlo_pi
end program monte_carlo_pi
```

== OpenMP

== OpenMP+MPI

== Coarray

= Intel Fortran

#focus-slide[#image("pic/justfile.png")]

== Intel MPI vs MPICH

== OpenBLAS vs MKL

= 未来展望

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
#image("pic/cuda.jpg",width: 25%)

== 更高级的算法

- 分层采样 把蒙特卡洛法进一步微分，把一个任务拆分成了数个任务

- 重要性采样 需要一定的概论相关的数学知识

- 自适应采样 通过一定的算法/机器学习的方法来自适应的调整采样的方法

- 拟蒙特卡洛序列
    - Sobol序列
    - Halton序列
    - Faure序列

= <touying:hidden>

#align(center,text(size: 48pt,"谢谢!"))
