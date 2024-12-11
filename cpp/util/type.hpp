#pragma once

#include <chrono>
#include <random>
#include <vector>

namespace mc
{
// 配置
struct Config
{
    size_t samples;  // 样本数量
    double radius;   // 半径
    bool use_simd;   // 是否使用SIMD
    bool use_vector; // 是否使用向量化

    // 随机数生成器类型
    enum class RandomType
    {
        STD,
        MKL
    } random_type;
};

// 统计
struct Statistics
{
    double result;      // 计算结果
    double accuracy;    // 精度
    double wall_time;   // Wall Time
    double cpu_time;    // CPU Time
    double variance;    // 方差
    double convergence; // 收敛率
    double confidence;  // 置信区间
    double utilization; // 资源利用率
    double speedup;     // Amdahl加速比
};
} // namespace mc
