#import "@preview/touying:0.5.3": *
#import "@preview/numbly:0.1.0": numbly
#import "@preview/cetz:0.3.1": canvas, draw
#import "@preview/cetz-plot:0.1.0": plot, chart
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

#align(
  center,
  text(size: 28pt)[
    诸晓婉(922110800509) - PPT

    张雨馨(923104780210) - 报告

    拓欣(922114740127) - 代码
  ],
)

== 项目介绍

蒙特卡罗方法, 也称统计模拟方法, 是1940年代中期由于科学技术的发展和电子计算机的发明, 而提出的一种以概率统计理论为指导的数值计算方法. 使用随机数来解决很多计算问题的方法

= 代码实现

== 串行

#codly(languages: codly-languages)
```fortran
program normal
   use, intrinsic :: iso_fortran_env, only: dp => real64
   implicit none

   real(dp) :: x, y, area, true_area, dis
   real(dp) :: r
   real(dp) :: start_cpu, end_cpu
   integer :: start_time, end_time
   integer :: i, inside_points, samples

   ! 参数
   r = 1.0_dp
   samples = 1000000
   inside_points = 0
   true_area = r*r*3.141592653589793_dp

   ! 开始时间
   call cpu_time(start_cpu)
   call system_clock(count=start_time)

   ! 蒙特卡洛
   do i = 1, samples
      call random_number(x)
      call random_number(y)
      x = x*r*2.0_dp - r
      y = y*r*2.0_dp - r

      if (x*x + y*y <= r*r) then
         inside_points = inside_points + 1
      end if
   end do

   ! 圆面积
   area = (real(inside_points, dp)/real(samples, dp))*(4.0_dp*r*r)
   dis = abs(area - true_area)

   ! 结束时间
   call cpu_time(end_cpu)
   call system_clock(count=end_time)

   ! 结果
   print '(A,F15.8)', '计算结果(面积): ', area
   print '(A,F15.8)', '半径: ', r
   print '(A,I10)', '样本量: ', samples
   print '(A,F15.8)', '结果精度(误差): ', dis
   print '(A,F15.8,A)', 'Wall Time: ', (end_time - start_time)/1000.0_dp, '秒'
   print '(A,F15.8,A)', 'CPU Time: ', (end_cpu - start_cpu), '秒'
end program normal
```

```bash
gfortran -O3 -march=native src/normal.f90 -o dist/normal
```

#align(center)[#text(
    weight: "bold",
    size: 10pt,
  )[不同样本量下结果误差的变化(值越小越好)]]
#canvas({
  draw.set-style(legend: (fill: white))
  chart.barchart(
    mode: "clustered",
    size: (9, auto),
    label-key: 0,
    value-key: (..range(1, 5),),
    bar-width: .8,
    x-label: "结果误差",
    y-label: "样本量",
    x-tick-step: 2.5,
    (
      ([100,000], 0.00248735),
      ([1,000,000], 0.00107535),
      ([10,000,000], 0.00007785),
      ([100,000,000], 0.00002563),
    ),
    labels: (),
    legend: "inner-north-east",
    label-data: true,
  )
})

#align(center)[#text(
    weight: "bold",
    size: 10pt,
  )[不同样本量下Wall Time/CPU Time的变化]]
#canvas({
  draw.set-style(legend: (fill: white))
  chart.barchart(
    mode: "clustered",
    size: (9, auto),
    label-key: 0,
    value-key: (..range(1, 5),),
    bar-width: .8,
    x-label: "时间",
    y-label: "样本量",
    x-tick-step: 2.5,
    (
      ([100,000], 0.00200000, 0.00154800),
      ([1,000,000], 0.01600000, 0.01563500),
      ([10,000,000], 0.18000000, 0.17832400),
      ([100,000,000], 1.64200000, 1.61098300),
    ),
    labels: ("Wall Time", "CPU Time"),
    legend: "inner-north-east",
  )
})

== OpenMP

#codly(languages: codly-languages)
```fortran
program omp
   use, intrinsic :: iso_fortran_env, only: dp => real64
   implicit none

   real(dp) :: x, y, area, true_area, dis
   real(dp) :: r
   real(dp) :: start_cpu, end_cpu
   integer :: start_time, end_time
   integer :: i, inside_points, samples
   integer :: tid

   ! 参数
   r = 1.0_dp
   samples = 1000000
   inside_points = 0
   true_area = r*r*3.141592653589793_dp

   ! 开始时间
   call cpu_time(start_cpu)
   call system_clock(count=start_time)

   !$omp parallel private(x, y, tid) reduction(+:inside_points)
   !$omp do
   do i = 1, samples
      call random_number(x)
      call random_number(y)
      x = x*r*2.0_dp - r
      y = y*r*2.0_dp - r

      if (x*x + y*y <= r*r) then
         inside_points = inside_points + 1
      end if
   end do
   !$omp end do
   !$omp end parallel

   ! 圆面积
   area = (real(inside_points, dp)/real(samples, dp))*(4.0_dp*r*r)
   dis = abs(area - true_area)

   ! 结束时间
   call cpu_time(end_cpu)
   call system_clock(count=end_time)

   ! 结果
   print '(A,F15.8)', '计算结果(面积): ', area
   print '(A,F15.8)', '半径: ', r
   print '(A,I10)', '样本量: ', samples
   print '(A,F15.8)', '结果精度(误差): ', dis
   print '(A,F15.8,A)', 'Wall Time: ', (end_time - start_time)/1000.0_dp, '秒'
   print '(A,F15.8,A)', 'CPU Time: ', (end_cpu - start_cpu), '秒'
end program omp
```

```bash
gfortran -O3 -march=native -openmp src/omp.f90 -o dist/omp-g
mpiifx -O3 -march=native -qopenmp -qmkl src/omp.f90 -o dist/omp-i
```

#align(center)[#text(
    weight: "bold",
    size: 10pt,
  )[不同样本量下结果误差的变化(值越小越好)]]
#canvas({
  draw.set-style(legend: (fill: white))
  chart.barchart(
    mode: "clustered",
    size: (9, auto),
    label-key: 0,
    value-key: (..range(1, 5),),
    bar-width: .8,
    x-label: "结果误差",
    y-label: "样本量",
    x-tick-step: 2.5,
    (
      ([100,000], 0.00087265),
      ([1,000,000], 0.00075535),
      ([10,000,000], 0.00048495),
      ([100,000,000], 0.00015935),
    ),
    labels: (),
    legend: "inner-north-east",
  )
})

#align(center)[#text(
    weight: "bold",
    size: 10pt,
  )[不同样本量下Wall Time/CPU Time的变化]]
#canvas({
  draw.set-style(legend: (fill: white))
  chart.barchart(
    mode: "clustered",
    size: (9, auto),
    label-key: 0,
    value-key: (..range(1, 5),),
    bar-width: .8,
    x-label: "时间",
    y-label: "样本量",
    x-tick-step: 2.5,
    (
      ([100,000], 0.00100000, 0.00156400),
      ([1,000,000], 0.01600000, 0.01571900),
      ([10,000,000], 0.18100000, 0.17869700),
      ([100,000,000], 1.57100000, 1.53920500),
    ),
    labels: ("Wall Time", "CPU Time"),
    legend: "inner-north-east",
  )
})

== OpenMP+MPI

#codly(languages: codly-languages)
```fortran
program hybrid
   use, intrinsic :: iso_fortran_env, only: dp => real64
   use mpi
   implicit none

   real(dp) :: x, y, pi, area, true_area, dis
   real(dp) :: r
   real(dp) :: start_cpu, end_cpu
   integer :: start_time, end_time
   integer :: i, local_inside, global_inside, samples, local_points
   integer :: ierr, rank, size

   ! MPI
   call MPI_Init(ierr)
   call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
   call MPI_Comm_size(MPI_COMM_WORLD, size, ierr)

   ! 参数
   r = 1.0_dp
   samples = 1000000
   local_points = samples/size
   local_inside = 0
   true_area = r*r*3.141592653589793_dp

   ! 开始时间
   if (rank == 0) then
      call cpu_time(start_cpu)
      call system_clock(count=start_time)
   end if

   !$omp parallel private(x, y) reduction(+:local_inside)
   !$omp do
   do i = 1, local_points
      call random_number(x)
      call random_number(y)
      x = x*r*2.0_dp - r
      y = y*r*2.0_dp - r

      if (x*x + y*y <= r*r) then
         local_inside = local_inside + 1
      end if
   end do
   !$omp end do
   !$omp end parallel

   ! 汇总所有进程的结果
   call MPI_Reduce(local_inside, global_inside, 1, MPI_INTEGER, &
                   MPI_SUM, 0, MPI_COMM_WORLD, ierr)

   if (rank == 0) then
      ! 圆面积
      area = (real(global_inside, dp)/real(samples, dp))*(4.0_dp*r*r)
      dis = abs(area - true_area)

      ! 结束时间
      call cpu_time(end_cpu)
      call system_clock(count=end_time)

      ! 结果
      print '(A,F15.8)', '计算结果(面积): ', area
      print '(A,F15.8)', '半径: ', r
      print '(A,I10)', '样本量: ', samples
      print '(A,F15.8)', '结果精度(误差): ', dis
      print '(A,F15.8,A)', 'Wall Time: ', (end_time - start_time)/1000.0_dp, '秒'
      print '(A,F15.8,A)', 'CPU Time: ', (end_cpu - start_cpu), '秒'
   end if

   call MPI_Finalize(ierr)
end program hybrid
```


```bash
mpif90 -O3 -fopenmp src/hybrid.f90 -o dist/hybrid-g
mpirun -np 8 ./dist/hybrid-g

mpiifx -O3 -march=native -qopenmp -lmpi -qmkl src/hybrid.f90 -o dist/hybrid-i && \
mpirun -np 8 ./dist/hybrid-i"
```

#align(center)[#text(
    weight: "bold",
    size: 10pt,
  )[不同样本量下结果误差的变化(值越小越好)]]
#canvas({
  draw.set-style(legend: (fill: white))
  chart.barchart(
    mode: "clustered",
    size: (9, auto),
    label-key: 0,
    value-key: (..range(1, 5),),
    bar-width: .8,
    x-label: "结果误差",
    y-label: "样本量",
    x-tick-step: 2.5,
    (
      ([100,000], 0.00151265),
      ([1,000,000], 0.00045135),
      ([10,000,000], 0.00007695),
      ([100,000,000], 0.00022915),
    ),
    labels: (),
    legend: "inner-north-east",
    label-data: true,
  )
})

#align(center)[#text(
    weight: "bold",
    size: 10pt,
  )[不同样本量下Wall Time/CPU Time的变化]]
#canvas({
  draw.set-style(legend: (fill: white))
  chart.barchart(
    mode: "clustered",
    size: (9, auto),
    label-key: 0,
    value-key: (..range(1, 5),),
    bar-width: .8,
    x-label: "时间",
    y-label: "样本量",
    x-tick-step: 2.5,
    (
      ([100,000], 0.05800000, 0.08832400),
      ([1,000,000], 0.06200000, 0.13039200),
      ([10,000,000], 0.07100000, 0.12257000),
      ([100,000,000], 0.29100000, 0.55104900),
    ),
    labels: ("Wall Time", "CPU Time"),
    legend: "inner-north-east",
  )
})

== MPICH/BLAS vs Intel MPI/MKL

这里我们分别使用GFortran编译器和Intel Fortran编译器来对比两者的性能

#align(center)[#text(
    weight: "bold",
    size: 10pt,
  )[不同样本量下执行速度(CPU Time)的变化]]
#canvas({
  draw.set-style(legend: (fill: white))
  chart.barchart(
    mode: "clustered",
    size: (9, auto),
    label-key: 0,
    value-key: (..range(1, 5),),
    bar-width: .8,
    x-label: "秒",
    y-label: "样本量",
    x-tick-step: 2.5,
    (
      ([100,000], 0.00156400, 0.01955200),
      ([1,000,000], 0.01571900, 0.04999400),
      ([10,000,000], 0.17869700, 0.36233200),
      ([100,000,000], 1.53920500, 3.80729400),
    ),
    labels: ([Intel MPI], [MPICH]),
    legend: "inner-north-east",
  )
})

= 项目展望

因为时间和技术的限制, 我们只实现了串行、OpenMP和OpenMP+MPI三种版本, 但是还有很多其他的优化方法可以尝试

== Coarray

Coarray是Fortran 2008的一个特性, 可以实现分布式内存并行计算, 无需自己编写OpenMP、MPI等代码, 但是需要编译器支持

== 使用Julia等更热门的语言

=== Julia

Julia是一个高性能的动态编程语言, 有很多并行计算的库, 可以实现分布式内存并行计算

- Threads.jl
- Distributed.jl

=== Python

Python虽然是一个解释型语言, 但是有很多高性能的库, 可以实现并行计算

- Cython
- Ray

=== Rust

Rust是一门近年来非常流行的系统编程语言, 有一些高性能的库可以实现并行计算

- Rayon

== 使用GPU加速

我们的显卡擅长浮点运算, 可以使用GPU加速来提高计算速度

而NVIDIA公司的CUDA是一个非常流行的GPU编程框架, 可以使用CUDA C/C++、CUDA Python、CUDA Fortran等语言来编写GPU程序

- NVIDIA CUDA Fortran

== 更高级的算法

- 分层采样 把蒙特卡洛法进一步微分，把一个任务拆分成了数个任务

- 重要性采样 需要一定的概论相关的数学知识

- 自适应采样 通过一定的算法/机器学习的方法来自适应的调整采样的方法

- 拟蒙特卡洛序列
  - Sobol序列
  - Halton序列
  - Faure序列

= <touying:hidden>

#align(center, text(size: 48pt, "谢谢!"))
