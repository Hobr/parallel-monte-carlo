# 基于蒙特卡洛法算圆的面积 并行计算

南京理工大学2024年秋季学期并行计算导论课程大作业，使用了Fortran/Julia语言, 提供多种工程/数学解决方案

## 方法

- 语言
  - Fortran
    - 编译器
      - GNU Fortran
      - Intel Fortran
      - NVCC
    - 并行/分布式库
      - OpenMP
      - MPI
      - Coarray
    - GPU
      - CUDA
      - OpenACC

  - Julia
    - Threads
    - Distributed
    - CUDA

  - Bend
    - C运行时
    - Rust运行时
    - CUDA运行时

- 算法
  - 基本蒙特卡洛算法
    - 批处理
  - 对称性优化
    - 对称次数
  - 重要性采样
  - 分层采样
    - 分层次数
  - 重要性-分层采样
    - 分层次数
  - 自适应采样
    - 机器学习
  - 拟蒙特卡洛序列
    - Sobol序列
    - Halton序列
    - Faure序列

- 工程
  - 编译优化
  - 内存优化
  - 误差控制
  - SIMD
  - 矢量化
  - 缓存优化
  - 随机数生成器
  - GPU
  - 并行计算
  - 分布式
  - 分布式GPU
  - 异构计算
  - 负载均衡策略
  - 性能分析(瓶颈)
  - 统一基准测试
  - 可视化展示

- 指标
  - 样本量
  - 结果精度(与真实值的差距)
  - 执行时间
    - Wall Time
    - CPU Time
  - 方差
  - 收敛性
  - 误差置信区间
  - 资源利用率
  - Amdahl定律加速比

## 使用

```bash
git clone https://github.com/Hobr/parallel-monte-carlo
cd parallel-monte-carlo

echo "use flake" > .envrc
direnv allow

julia
]add LoopVectorization VSL CUDA Distributed Plots BenchmarkTools TimerOutputs JuliaFormatter
]up
include("main.jl")
exit()
```
