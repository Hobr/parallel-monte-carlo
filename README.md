# 基于蒙特卡洛法算圆的面积 并行计算

南京理工大学2024年秋季学期并行计算导论课程大作业, 提供多种工程/数学解决方案

## 方法

### 语言方案

- CPP
  - C++20
  - OpenMP
  - MPI
  - SSE/AVX

- Rust
  - Rayon

- Bend
  - Rust
  - CUDA

### 工程优化

- 并行计算
  - OpenMP多线程
  - MPI分布式计算
  - 改进随机数生成器
  - CUDA GPU加速
  - 混合并行(MPI+OpenMP)
  - 向量化指令(SSE/AVX)

### 数学优化

- 采样策略
  - 纯随机采样(标准蒙特卡洛)
  - 分层采样
  - 拟蒙特卡洛序列(Sobol/Halton序列)
  - 重要性采样
  - 自适应采样
  - 蒙特卡洛树搜索

- 误差控制
  - 方差缩减技术
  - 置信区间估计
  - 收敛性分析
  - 不同精度要求下的采样数优化

### 对照组合

- 基准组
  - 单线程 + 纯随机采样
  - OpenMP + 纯随机采样
  - CUDA + 纯随机采样

- 算法优化组
  - OpenMP + 分层采样
  - OpenMP + 拟蒙特卡洛序列
  - OpenMP + 重要性采样

- 工程优化组
  - MPI + 纯随机采样
  - 向量化 + 纯随机采样
  - 混合并行 + 纯随机采样

- 完全优化组
  - 混合并行 + 拟蒙特卡洛序列 + 缓存优化
  - CUDA + 重要性采样 + 共享内存优化

### 指标

- 计算时间(加速比)
- 计算精度
- 收敛速度
- 资源利用率
- 扩展性(不同核心数/节点数下的性能)

## 使用

### 第一步 拉取

```bash
git clone https://github.com/Hobr/parallel-monte-carlo
cd parallel-monte-carlo

# 其他系统请自行参考`flake.nix`文件安装必要的依赖
echo "use flake" > .envrc
direnv allow

just build
just run

# 开发
just install
just fmt
just update
```

## 参考

- [Rust编码规范](https://rust-coding-guidelines.github.io/rust-coding-guidelines-zh/)
- [OpenMP 简易教程](https://lemon-412.github.io/imgs/20200516OpenMP_simple_Program.pdf)
- [OpenMP并行编程](http://scc.ustc.edu.cn/_upload/article/files/f6/ed/85b3c0514658a6b88cc470263787/W020121113517997951933.pdf)
- [高性能计算之并行编程技术-MPI 并行程序设计](http://www.whigg.cas.cn/resource/superComputer/201010/P020101023579409136210.pdf)
- [MPI并行编程入门](https://scc.ustc.edu.cn/_upload/article/files/e0/98/a9f0c4964abdb3281233d7943f9e/W020121113517561886972.pdf)
- [NUMA架构的CPU-你真的用好了么？](http://cenalulu.github.io/linux/numa/)
- [如何在生产环境排查 Rust 内存占用过高问题s](https://rustmagazine.github.io/rust_magazine_2021/chapter_5/rust-memory-troubleshootting.html)
- [浅谈Actor模型](http://chuquan.me/2023/01/15/actor/)
