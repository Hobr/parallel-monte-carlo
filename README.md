# 基于蒙特卡洛法算圆的面积 并行计算

南京理工大学2024年秋季学期并行计算导论课程大作业, 提供C++/Rust/Bend三种解决方案

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
