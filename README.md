# 基于蒙特卡洛法算圆的面积 并行计算

南京理工大学2024年秋季学期并行计算导论课程大作业, 提供C++(NCCL)/Rust/Bend三种解决方案

## 方法

### 算法

> 注重减少方差, 提升精度

- 原始
  - 分析误差随点数增长的收敛速度, 形成对照
  - 测试极端情况, 如非常低的采样点数和非常高的采样点数

- 自适应采样
- 低差异序列
- 重要性采样
- 极坐标变换
- 分层采样
- 准随机序列
- 蒙特卡洛树搜索

### 工程

> 注重运行效率和吞吐量

- 原始
- 随机数生成器
- SIMD
- 并行
- CUDA
- 多机

## 使用

```bash
git clone https://github.com/Hobr/parallel-monte-carlo
cd parallel-monte-carlo

echo "use flake" > .envrc
direnv allow

cargo install just

# C++
just cpp

# Rust
just rust

# Bend
cargo install hvm bend-lang
just bend-c
just bend-rs
just bend-cuda

# 开发
just install-dev
just fmt
just update
```
