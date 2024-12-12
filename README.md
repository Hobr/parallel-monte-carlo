# 基于蒙特卡洛法算圆的面积 并行计算

南京理工大学2024年秋季学期并行计算导论课程大作业, 提供多种工程/数学解决方案

## 方法

- 语言
  - Fortran
    - OpenMP
    - MPI
    - Coarray
    - OpenCoarrays

  - Bend
    - C运行时
    - Rust运行时
    - CUDA运行时

- 指标
  - 半径
  - 样本量
  - 结果精度(与真实值的差距)
  - Wall Time
  - CPU Time

## 使用

```bash
git clone https://github.com/Hobr/parallel-monte-carlo
cd parallel-monte-carlo

echo "use flake" > .envrc
direnv allow

just install
just fmt
just julia
```
