#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

= 工程优化

== 代码优化

=== 矢量化

通过算法矢量化, 代码可以更好地进行并行计算

=== SIMD

为了充分利用CPU性能, 我们使用了SIMD指令集以提高代码的运行效率

== 随机数生成器

=== 伪随机数

通过伪随机数生成器, 我们可以生成大量的随机数, 但其性能较差, 且随机性较差

=== Intel MKL

为了提高随机数生成器的性能, 我们使用了Intel MKL库

== OpenMP

通过OpenMP, 我们可以更好地利用多核CPU的性能

== OpenMP+MPI

通过OpenMP+MPI, 我们可以更好地利用多核CPU和多节点的性能

== CUDA

通过CUDA, 我们可以更好地利用GPU的性能

== Coarray

通过Coarray, 我们可以更好地利用多核CPU和多节点的性能

Coarray是Fortran社区提出的一种并行编程模型, 用于在多核CPU和多节点上进行并行计算, 与OpenMP+MPI类似, 但更加简单易用
